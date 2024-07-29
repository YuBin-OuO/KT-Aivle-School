import flet as ft
import base64
import cv2

from ultralytics import YOLO
import math

# cap = cv2.VideoCapture("Your video path")
cap = cv2.VideoCapture(0)

# model
model = YOLO()

# object classes
classNames = ["person", "bicycle", "car", "motorbike", "aeroplane", "bus", "train", "truck", "boat",
              "traffic light", "fire hydrant", "stop sign", "parking meter", "bench", "bird", "cat",
              "dog", "horse", "sheep", "cow", "elephant", "bear", "zebra", "giraffe", "backpack", "umbrella",
              "handbag", "tie", "suitcase", "frisbee", "skis", "snowboard", "sports ball", "kite", "baseball bat",
              "baseball glove", "skateboard", "surfboard", "tennis racket", "bottle", "wine glass", "cup",
              "fork", "knife", "spoon", "bowl", "banana", "apple", "sandwich", "orange", "broccoli",
              "carrot", "hot dog", "pizza", "donut", "cake", "chair", "sofa", "pottedplant", "bed",
              "diningtable", "toilet", "tvmonitor", "laptop", "mouse", "remote", "keyboard", "cell phone",
              "microwave", "oven", "toaster", "sink", "refrigerator", "book", "clock", "vase", "scissors",
              "teddy bear", "hair drier", "toothbrush"
              ]

class Countdown(ft.UserControl):
    def __init__(self):
        super().__init__()

    def did_mount(self):
        self.update_timer()

    def update_timer(self):
        while True:
            _, img = cap.read()
            results = model(img, stream=True)
            
            # coordinates
            for r in results:
                boxes = r.boxes

                for box in boxes:
                    # bounding box
                    x1, y1, x2, y2 = box.xyxy[0]
                    x1, y1, x2, y2 = int(x1), int(y1), int(x2), int(y2) # convert to int values

                    # put box in cam
                    cv2.rectangle(img, (x1, y1), (x2, y2), (0, 255, 255), 2)

                    # confidence
                    confidence = math.ceil((box.conf[0]*100))/100
                    # print("Confidence --->",confidence)

                    # class name
                    cls = int(box.cls[0])
                    # print("Class name -->", classNames[cls])

                    # object details
                    org = [x1, y1]
                    font = cv2.FONT_HERSHEY_SIMPLEX
                    fontScale = 1
                    color = (255, 255, 255)
                    thickness = 2

                    cv2.putText(img, classNames[cls], org, font, fontScale, color, thickness)

            # cv2.imshow('Webcam', img)
            
            _, im_arr = cv2.imencode('.png', img)
            im_b64 = base64.b64encode(im_arr)
            self.img.src_base64 = im_b64.decode("utf-8")
            self.update()

    def build(self):
        self.img = ft.Image(
            border_radius=ft.border_radius.all(20)
        )
        return self.img

def height_changed(e):
    print(e.control.value)

section = ft.Container(
    margin=ft.margin.only(bottom=40),
    content=ft.Row([
        ft.Card(
            elevation=30,
            content=ft.Container(
                bgcolor=ft.colors.WHITE24,
                padding=10,
                border_radius = ft.border_radius.all(20),
                content=ft.Column([
                    Countdown(),
                    ft.Text("OPENCV WITH FLET",
                         size=20, weight="bold",
                         color=ft.colors.WHITE),
                ]
                ),
            )
        ),
        ft.Card(
            elevation=30,
            content=ft.Container(
                bgcolor=ft.colors.WHITE24,
                padding=10,
                border_radius=ft.border_radius.all(20),
                content=ft.Column([
                    ft.Slider(
                        min=500, max=900,on_change=lambda e:print(e.control.value)
                    ),
                    ft.Slider(
                        min=500, max=900,
                    )

                ]
                ),

            )
        )
    ],
        alignment=ft.MainAxisAlignment.CENTER,
    )
)

def main(page: ft.Page):
    page.padding = 50
    page.window_left = page.window_left+100
    page.theme_mode = ft.ThemeMode.LIGHT
    page.add(
        section,
    )

if __name__ == '__main__':
    ft.app(target=main)
    cap.release()
    cv2.destroyAllWindows()
