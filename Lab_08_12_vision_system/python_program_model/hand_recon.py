import cv2
import numpy as np
from matplotlib import pyplot as plt

import cv2
import numpy as np


IMG_SIZE = 64;

YCBCR_MULT = np.array([[0.299, 0.587, 0.114],
                       [-0.168736, -0.331264, 0.5],
                       [0.5, -0.418688, -0.081312]],
                      dtype=float)

YCBCR_ADDER = np.array([0, 128, 128]).T

T_A = 77
T_B = 127
T_C = 133
T_D = 173

I = cv2.imread("hand_photo.jpg")
I = cv2.resize(I, (IMG_SIZE, IMG_SIZE))

cv2.imshow("Scaled", I)
cv2.waitKey(0)
cv2.destroyAllWindows()
cv2.imwrite("hand_recon.ppm", I)

I = cv2.cvtColor(I, cv2.COLOR_BGR2RGB)
I_YCbCr = np.zeros_like(I, dtype=np.uint8)

for y in range(IMG_SIZE):
    for x in range(IMG_SIZE):
        I_YCbCr[y,x] = YCBCR_MULT @ I[y,x,:] + YCBCR_ADDER

I_y = I_YCbCr[:,:,0]
I_cb = I_YCbCr[:,:,1]
I_cr = I_YCbCr[:,:,2]

cv2.imshow("YCbCr", I_YCbCr)
cv2.waitKey(0)
cv2.destroyAllWindows()

cv2.imwrite("hand_YCbCr.ppm", I_YCbCr)

I_bin = np.zeros_like(I_y)
I_bin[(I_cb > T_A) & (I_cb < T_B) & (I_cr > T_C) & (I_cr < T_D)] = 255

cv2.imshow("maska", I_bin)
cv2.waitKey(0)
cv2.destroyAllWindows()

I_bin = cv2.medianBlur(I_bin, 5)

cv2.imshow("maska po filtracji", I_bin)
cv2.waitKey(0)
cv2.destroyAllWindows()


I_mask = I_bin // 255

m00 = np.sum(I_mask)
Y, X = np.indices(I_mask.shape)

m10 = np.sum(X * I_mask)
m01 = np.sum(Y * I_mask)

x_sc = (m10 / m00).astype(np.uint8)
y_sc = (m01 / m00).astype(np.uint8)


I_bin = cv2.cvtColor(I_bin, cv2.COLOR_GRAY2BGR)

cv2.line(I_bin, (x_sc, 0), (x_sc, IMG_SIZE), (0,0,255), 1)
cv2.line(I_bin, (0, y_sc), (IMG_SIZE, y_sc), (0,0,255), 1)

cv2.imshow("Binarized", I_bin)
cv2.waitKey(0)
cv2.destroyAllWindows()



                 

