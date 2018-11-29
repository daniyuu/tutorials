import numpy as np
from pdftabextract import imgproc

# get the image file of the scanned page

imgfile = "./data/pic-2.png"


# create an image processing object with the scanned page
iproc_obj = imgproc.ImageProc(imgfile)

# calculate the scaling of the image file in relation to the text boxes coordinate system dimensions
page_scaling_x = iproc_obj.img_w
page_scaling_y = iproc_obj.img_h

# detect the lines
lines_hough = iproc_obj.detect_lines(canny_kernel_size=3, canny_low_thresh=50, canny_high_thresh=150,
                                     hough_rho_res=1,
                                     hough_theta_res=np.pi/500,
                                     hough_votes_thresh=round(0.2 * iproc_obj.img_w))
print("> found %d lines" % len(lines_hough))