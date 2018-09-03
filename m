From: Kenneth Lee <nek.in.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/7] vfio/sdmdev: Add documents for WarpDrive framework
Date: Mon,  3 Sep 2018 08:51:58 +0800
Message-ID: <20180903005204.26041-2-nek.in.cn@gmail.com>
References: <20180903005204.26041-1-nek.in.cn@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
To: Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
	"David S . Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>,
	Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Kenneth Lee <liguozhu-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org>, Hao Fang <fanghao11-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>,
	Zhou Wang <wangzhou1-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org>, Zaibo Xu <xuzaibo-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>,
	Philippe Ombredanne <pombredanne-od1rfyK75/E@public.gmane.org>,
	Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>,
	Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-accelerators-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org, Lu Baolu <baolu.lu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>,
	Sanjay Kumar <sanjay.k.kumar-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20180903005204.26041-1-nek.in.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

From: Kenneth Lee <liguozhu-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org>

WarpDrive is a common user space accelerator framework.  Its main component
in Kernel is called sdmdev, Share Domain Mediated Device. It exposes
the hardware capabilities to the user space via vfio-mdev. So processes in
user land can obtain a "queue" by open the device and direct access the
hardware MMIO space or do DMA operation via VFIO interface.

WarpDrive is intended to be used with Jean Philippe Brucker's SVA
patchset to support multi-process. But This is not a must.  Without the
SVA patches, WarpDrive can still work for one process for every hardware
device.

This patch add detail documents for the framework.

Signed-off-by: Kenneth Lee <liguozhu-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org>
---
 Documentation/00-INDEX                |   2 +
 Documentation/warpdrive/warpdrive.rst | 100 ++++
 Documentation/warpdrive/wd-arch.svg   | 728 ++++++++++++++++++++++++++
 3 files changed, 830 insertions(+)
 create mode 100644 Documentation/warpdrive/warpdrive.rst
 create mode 100644 Documentation/warpdrive/wd-arch.svg

diff --git a/Documentation/00-INDEX b/Documentation/00-INDEX
index 2754fe83f0d4..9959affab599 100644
--- a/Documentation/00-INDEX
+++ b/Documentation/00-INDEX
@@ -410,6 +410,8 @@ vm/
 	- directory with info on the Linux vm code.
 w1/
 	- directory with documents regarding the 1-wire (w1) subsystem.
+warpdrive/
+	- directory with documents about WarpDrive accelerator framework.
 watchdog/
 	- how to auto-reboot Linux if it has "fallen and can't get up". ;-)
 wimax/
diff --git a/Documentation/warpdrive/warpdrive.rst b/Documentation/warpdrive/warpdrive.rst
new file mode 100644
index 000000000000..6d2a5d1e08c4
--- /dev/null
+++ b/Documentation/warpdrive/warpdrive.rst
@@ -0,0 +1,100 @@
+Introduction of WarpDrive
+=========================
+
+*WarpDrive* is a general accelerator framework for user space. It intends to
+provide interface for the user process to send request to hardware
+accelerator without heavy user-kernel interaction cost.
+
+The *WarpDrive* user library is supposed to provide a pipe-based API, such as:
+        ::
+        int wd_request_queue(struct wd_queue *q);
+        void wd_release_queue(struct wd_queue *q);
+
+        int wd_send(struct wd_queue *q, void *req);
+        int wd_recv(struct wd_queue *q, void **req);
+        int wd_recv_sync(struct wd_queue *q, void **req);
+        int wd_flush(struct wd_queue *q);
+
+*wd_request_queue* creates the pipe connection, *queue*, between the
+application and the hardware. The application sends request and pulls the
+answer back by asynchronized wd_send/wd_recv, which directly interact with the
+hardware (by MMIO or share memory) without syscall.
+
+*WarpDrive* maintains a unified application address space among all involved
+accelerators.  With the following APIs: ::
+
+        int wd_mem_share(struct wd_queue *q, const void *addr,
+                         size_t size, int flags);
+        void wd_mem_unshare(struct wd_queue *q, const void *addr, size_t size);
+
+The referred process space shared by these APIs can be directly referred by the
+hardware. The process can also dedicate its whole process space with flags,
+*WD_SHARE_ALL* (not in this patch yet).
+
+The name *WarpDrive* is simply a cool and general name meaning the framework
+makes the application faster. As it will be explained in this text later, the
+facility in kernel is called *SDMDEV*, namely "Share Domain Mediated Device".
+
+
+How does it work
+================
+
+*WarpDrive* is built upon *VFIO-MDEV*. The queue is wrapped as *mdev* in VFIO.
+So memory sharing can be done via standard VFIO standard DMA interface.
+
+The architecture is illustrated as follow figure:
+
+.. image:: wd-arch.svg
+        :alt: WarpDrive Architecture
+
+Accelerator driver shares its capability via *SDMDEV* API: ::
+
+        vfio_sdmdev_register(struct vfio_sdmdev *sdmdev);
+        vfio_sdmdev_unregister(struct vfio_sdmdev *sdmdev);
+        vfio_sdmdev_wake_up(struct spimdev_queue *q);
+
+*vfio_sdmdev_register* is a helper function to register the hardware to the
+*VFIO_MDEV* framework. The queue creation is done by *mdev* creation interface.
+
+*WarpDrive* User library mmap the mdev to access its mmio space and shared
+memory. Request can be sent to, or receive from, hardware in this mmap-ed
+space until the queue is full or empty.
+
+The user library can wait on the queue by ioctl(VFIO_SDMDEV_CMD_WAIT) the mdev
+if the queue is full or empty. If the queue status is changed, the hardware
+driver use *vfio_sdmdev_wake_up* to wake up the waiting process.
+
+
+Multiple processes support
+==========================
+
+In the latest mainline kernel (4.18) when this document is written,
+multi-process is not supported in VFIO yet.
+
+Jean Philippe Brucker has a patchset to enable it[1]_. We have tested it
+with our hardware (which is known as *D06*). It works well. *WarpDrive* rely
+on them to support multiple processes. If it is not enabled, *WarpDrive* can
+still work, but it support only one mdev for a process, which will share the
+same io map table with kernel. (But it is not going to be a security problem,
+since the user application cannot access the kernel address space)
+
+When multiprocess is support, mdev can be created based on how many
+hardware resource (queue) is available. Because the VFIO framework accepts only
+one open from one mdev iommu_group. Mdev become the smallest unit for process
+to use queue. And the mdev will not be released if the user process exist. So
+it will need a resource agent to manage the mdev allocation for the user
+process. This is not in this document's range.
+
+
+Legacy Mode Support
+===================
+For the hardware on which IOMMU is not support, WarpDrive can run on *NOIOMMU*
+mode. That require some update to the mdev driver, which is not included in
+this version yet.
+
+
+References
+==========
+.. [1] https://patchwork.kernel.org/patch/10394851/
+
+.. vim: tw=78
diff --git a/Documentation/warpdrive/wd-arch.svg b/Documentation/warpdrive/wd-arch.svg
new file mode 100644
index 000000000000..2b0c467ee399
--- /dev/null
+++ b/Documentation/warpdrive/wd-arch.svg
@@ -0,0 +1,728 @@
+<?xml version="1.0" encoding="UTF-8" standalone="no"?>
+<!-- Created with Inkscape (http://www.inkscape.org/) -->
+
+<svg
+   xmlns:dc="http://purl.org/dc/elements/1.1/"
+   xmlns:cc="http://creativecommons.org/ns#"
+   xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
+   xmlns:svg="http://www.w3.org/2000/svg"
+   xmlns="http://www.w3.org/2000/svg"
+   xmlns:xlink="http://www.w3.org/1999/xlink"
+   xmlns:sodipodi="http://sodipodi.sourceforge.net/DTD/sodipodi-0.dtd"
+   xmlns:inkscape="http://www.inkscape.org/namespaces/inkscape"
+   width="210mm"
+   height="193mm"
+   viewBox="0 0 744.09449 683.85823"
+   id="svg2"
+   version="1.1"
+   inkscape:version="0.92.3 (2405546, 2018-03-11)"
+   sodipodi:docname="wd-arch.svg">
+  <defs
+     id="defs4">
+    <linearGradient
+       inkscape:collect="always"
+       id="linearGradient6830">
+      <stop
+         style="stop-color:#000000;stop-opacity:1;"
+         offset="0"
+         id="stop6832" />
+      <stop
+         style="stop-color:#000000;stop-opacity:0;"
+         offset="1"
+         id="stop6834" />
+    </linearGradient>
+    <linearGradient
+       inkscape:collect="always"
+       xlink:href="#linearGradient5026"
+       id="linearGradient5032"
+       x1="353"
+       y1="211.3622"
+       x2="565.5"
+       y2="174.8622"
+       gradientUnits="userSpaceOnUse"
+       gradientTransform="translate(-89.949614,405.94594)" />
+    <linearGradient
+       inkscape:collect="always"
+       id="linearGradient5026">
+      <stop
+         style="stop-color:#f2f2f2;stop-opacity:1;"
+         offset="0"
+         id="stop5028" />
+      <stop
+         style="stop-color:#f2f2f2;stop-opacity:0;"
+         offset="1"
+         id="stop5030" />
+    </linearGradient>
+    <filter
+       inkscape:collect="always"
+       style="color-interpolation-filters:sRGB"
+       id="filter4169-3"
+       x="-0.031597666"
+       width="1.0631953"
+       y="-0.099812768"
+       height="1.1996255">
+      <feGaussianBlur
+         inkscape:collect="always"
+         stdDeviation="1.3307599"
+         id="feGaussianBlur4171-6" />
+    </filter>
+    <linearGradient
+       inkscape:collect="always"
+       xlink:href="#linearGradient5026"
+       id="linearGradient5032-1"
+       x1="353"
+       y1="211.3622"
+       x2="565.5"
+       y2="174.8622"
+       gradientUnits="userSpaceOnUse"
+       gradientTransform="translate(175.77842,400.29111)" />
+    <filter
+       inkscape:collect="always"
+       style="color-interpolation-filters:sRGB"
+       id="filter4169-3-0"
+       x="-0.031597666"
+       width="1.0631953"
+       y="-0.099812768"
+       height="1.1996255">
+      <feGaussianBlur
+         inkscape:collect="always"
+         stdDeviation="1.3307599"
+         id="feGaussianBlur4171-6-9" />
+    </filter>
+    <marker
+       markerWidth="18.960653"
+       markerHeight="11.194658"
+       refX="9.4803267"
+       refY="5.5973287"
+       orient="auto"
+       id="marker4613">
+      <rect
+         y="-5.1589785"
+         x="5.8504119"
+         height="10.317957"
+         width="10.317957"
+         id="rect4212"
+         style="fill:#ffffff;stroke:#000000;stroke-width:0.69143367;stroke-miterlimit:4;stroke-dasharray:none"
+         transform="matrix(0.86111274,0.50841405,-0.86111274,0.50841405,0,0)">
+        <title
+           id="title4262">generation</title>
+      </rect>
+    </marker>
+    <marker
+       markerWidth="11.227358"
+       markerHeight="12.355258"
+       refX="10"
+       refY="6.177629"
+       orient="auto"
+       id="marker4825">
+      <path
+         inkscape:connector-curvature="0"
+         id="path4757"
+         d="M 0.42024733,0.42806444 10.231357,6.3500844 0.24347733,11.918544"
+         style="fill:none;fill-rule:evenodd;stroke:#000000;stroke-width:1px;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1" />
+    </marker>
+    <marker
+       markerWidth="11.227358"
+       markerHeight="12.355258"
+       refX="10"
+       refY="6.177629"
+       orient="auto"
+       id="marker4825-6">
+      <path
+         inkscape:connector-curvature="0"
+         id="path4757-1"
+         d="M 0.42024733,0.42806444 10.231357,6.3500844 0.24347733,11.918544"
+         style="fill:none;fill-rule:evenodd;stroke:#000000;stroke-width:1px;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1" />
+    </marker>
+    <linearGradient
+       inkscape:collect="always"
+       xlink:href="#linearGradient5026"
+       id="linearGradient5032-3-9"
+       x1="353"
+       y1="211.3622"
+       x2="565.5"
+       y2="174.8622"
+       gradientUnits="userSpaceOnUse"
+       gradientTransform="matrix(1.2452511,0,0,0.98513016,-190.95632,540.33156)" />
+    <filter
+       inkscape:collect="always"
+       style="color-interpolation-filters:sRGB"
+       id="filter4169-3-5-8"
+       x="-0.031597666"
+       width="1.0631953"
+       y="-0.099812768"
+       height="1.1996255">
+      <feGaussianBlur
+         inkscape:collect="always"
+         stdDeviation="1.3307599"
+         id="feGaussianBlur4171-6-3-9" />
+    </filter>
+    <marker
+       markerWidth="11.227358"
+       markerHeight="12.355258"
+       refX="10"
+       refY="6.177629"
+       orient="auto"
+       id="marker4825-6-2">
+      <path
+         inkscape:connector-curvature="0"
+         id="path4757-1-9"
+         d="M 0.42024733,0.42806444 10.231357,6.3500844 0.24347733,11.918544"
+         style="fill:none;fill-rule:evenodd;stroke:#000000;stroke-width:1px;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1" />
+    </marker>
+    <marker
+       markerWidth="11.227358"
+       markerHeight="12.355258"
+       refX="10"
+       refY="6.177629"
+       orient="auto"
+       id="marker4825-6-2-1">
+      <path
+         inkscape:connector-curvature="0"
+         id="path4757-1-9-9"
+         d="M 0.42024733,0.42806444 10.231357,6.3500844 0.24347733,11.918544"
+         style="fill:none;fill-rule:evenodd;stroke:#000000;stroke-width:1px;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1" />
+    </marker>
+    <linearGradient
+       inkscape:collect="always"
+       xlink:href="#linearGradient5026"
+       id="linearGradient5032-3-9-7"
+       x1="353"
+       y1="211.3622"
+       x2="565.5"
+       y2="174.8622"
+       gradientUnits="userSpaceOnUse"
+       gradientTransform="matrix(1.3742742,0,0,0.97786398,-234.52617,654.63367)" />
+    <filter
+       inkscape:collect="always"
+       style="color-interpolation-filters:sRGB"
+       id="filter4169-3-5-8-5"
+       x="-0.031597666"
+       width="1.0631953"
+       y="-0.099812768"
+       height="1.1996255">
+      <feGaussianBlur
+         inkscape:collect="always"
+         stdDeviation="1.3307599"
+         id="feGaussianBlur4171-6-3-9-0" />
+    </filter>
+    <marker
+       markerWidth="11.227358"
+       markerHeight="12.355258"
+       refX="10"
+       refY="6.177629"
+       orient="auto"
+       id="marker4825-6-2-6">
+      <path
+         inkscape:connector-curvature="0"
+         id="path4757-1-9-1"
+         d="M 0.42024733,0.42806444 10.231357,6.3500844 0.24347733,11.918544"
+         style="fill:none;fill-rule:evenodd;stroke:#000000;stroke-width:1px;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1" />
+    </marker>
+    <linearGradient
+       inkscape:collect="always"
+       xlink:href="#linearGradient5026"
+       id="linearGradient5032-3-9-4"
+       x1="353"
+       y1="211.3622"
+       x2="565.5"
+       y2="174.8622"
+       gradientUnits="userSpaceOnUse"
+       gradientTransform="matrix(1.3742912,0,0,2.0035845,-468.34428,342.56603)" />
+    <filter
+       inkscape:collect="always"
+       style="color-interpolation-filters:sRGB"
+       id="filter4169-3-5-8-54"
+       x="-0.031597666"
+       width="1.0631953"
+       y="-0.099812768"
+       height="1.1996255">
+      <feGaussianBlur
+         inkscape:collect="always"
+         stdDeviation="1.3307599"
+         id="feGaussianBlur4171-6-3-9-7" />
+    </filter>
+    <marker
+       markerWidth="11.227358"
+       markerHeight="12.355258"
+       refX="10"
+       refY="6.177629"
+       orient="auto"
+       id="marker4825-6-2-1-8">
+      <path
+         inkscape:connector-curvature="0"
+         id="path4757-1-9-9-6"
+         d="M 0.42024733,0.42806444 10.231357,6.3500844 0.24347733,11.918544"
+         style="fill:none;fill-rule:evenodd;stroke:#000000;stroke-width:1px;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1" />
+    </marker>
+    <marker
+       markerWidth="11.227358"
+       markerHeight="12.355258"
+       refX="10"
+       refY="6.177629"
+       orient="auto"
+       id="marker4825-6-2-1-8-8">
+      <path
+         inkscape:connector-curvature="0"
+         id="path4757-1-9-9-6-9"
+         d="M 0.42024733,0.42806444 10.231357,6.3500844 0.24347733,11.918544"
+         style="fill:none;fill-rule:evenodd;stroke:#000000;stroke-width:1px;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1" />
+    </marker>
+    <marker
+       markerWidth="11.227358"
+       markerHeight="12.355258"
+       refX="10"
+       refY="6.177629"
+       orient="auto"
+       id="marker4825-6-0">
+      <path
+         inkscape:connector-curvature="0"
+         id="path4757-1-93"
+         d="M 0.42024733,0.42806444 10.231357,6.3500844 0.24347733,11.918544"
+         style="fill:none;fill-rule:evenodd;stroke:#000000;stroke-width:1px;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1" />
+    </marker>
+    <marker
+       markerWidth="11.227358"
+       markerHeight="12.355258"
+       refX="10"
+       refY="6.177629"
+       orient="auto"
+       id="marker4825-6-0-2">
+      <path
+         inkscape:connector-curvature="0"
+         id="path4757-1-93-6"
+         d="M 0.42024733,0.42806444 10.231357,6.3500844 0.24347733,11.918544"
+         style="fill:none;fill-rule:evenodd;stroke:#000000;stroke-width:1px;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1" />
+    </marker>
+    <filter
+       inkscape:collect="always"
+       style="color-interpolation-filters:sRGB"
+       id="filter5382"
+       x="-0.089695387"
+       width="1.1793908"
+       y="-0.10052069"
+       height="1.2010413">
+      <feGaussianBlur
+         inkscape:collect="always"
+         stdDeviation="0.86758925"
+         id="feGaussianBlur5384" />
+    </filter>
+    <linearGradient
+       inkscape:collect="always"
+       xlink:href="#linearGradient6830"
+       id="linearGradient6836"
+       x1="362.73923"
+       y1="700.04059"
+       x2="340.4751"
+       y2="678.25488"
+       gradientUnits="userSpaceOnUse"
+       gradientTransform="translate(-23.771026,-135.76835)" />
+    <marker
+       markerWidth="11.227358"
+       markerHeight="12.355258"
+       refX="10"
+       refY="6.177629"
+       orient="auto"
+       id="marker4825-6-2-6-2">
+      <path
+         inkscape:connector-curvature="0"
+         id="path4757-1-9-1-9"
+         d="M 0.42024733,0.42806444 10.231357,6.3500844 0.24347733,11.918544"
+         style="fill:none;fill-rule:evenodd;stroke:#000000;stroke-width:1px;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1" />
+    </marker>
+  </defs>
+  <sodipodi:namedview
+     id="base"
+     pagecolor="#ffffff"
+     bordercolor="#666666"
+     borderopacity="1.0"
+     inkscape:pageopacity="0.0"
+     inkscape:pageshadow="2"
+     inkscape:zoom="1.4"
+     inkscape:cx="313.72367"
+     inkscape:cy="307.5947"
+     inkscape:document-units="px"
+     inkscape:current-layer="layer1"
+     showgrid="false"
+     inkscape:window-width="1916"
+     inkscape:window-height="1033"
+     inkscape:window-x="1920"
+     inkscape:window-y="22"
+     inkscape:window-maximized="0"
+     fit-margin-right="0.3"
+     inkscape:snap-global="false" />
+  <metadata
+     id="metadata7">
+    <rdf:RDF>
+      <cc:Work
+         rdf:about="">
+        <dc:format>image/svg+xml</dc:format>
+        <dc:type
+           rdf:resource="http://purl.org/dc/dcmitype/StillImage" />
+        <dc:title />
+      </cc:Work>
+    </rdf:RDF>
+  </metadata>
+  <g
+     inkscape:label="Layer 1"
+     inkscape:groupmode="layer"
+     id="layer1"
+     transform="translate(0,-368.50374)">
+    <rect
+       style="fill:#000000;stroke:#000000;stroke-width:0.6465112;filter:url(#filter4169-3)"
+       id="rect4136-3-6"
+       width="101.07784"
+       height="31.998148"
+       x="283.01144"
+       y="588.80896" />
+    <rect
+       style="fill:url(#linearGradient5032);fill-opacity:1;stroke:#000000;stroke-width:0.6465112"
+       id="rect4136-2"
+       width="101.07784"
+       height="31.998148"
+       x="281.63498"
+       y="586.75739" />
+    <text
+       xml:space="preserve"
+       style="font-style:normal;font-weight:normal;line-height:0%;font-family:sans-serif;letter-spacing:0px;word-spacing:0px;fill:#000000;fill-opacity:1;stroke:none;stroke-width:1px;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1"
+       x="294.21747"
+       y="612.50073"
+       id="text4138-6"><tspan
+         sodipodi:role="line"
+         id="tspan4140-1"
+         x="294.21747"
+         y="612.50073"
+         style="font-size:15px;line-height:1.25">WarpDrive</tspan></text>
+    <rect
+       style="fill:#000000;stroke:#000000;stroke-width:0.6465112;filter:url(#filter4169-3-0)"
+       id="rect4136-3-6-3"
+       width="101.07784"
+       height="31.998148"
+       x="548.7395"
+       y="583.15417" />
+    <rect
+       style="fill:url(#linearGradient5032-1);fill-opacity:1;stroke:#000000;stroke-width:0.6465112"
+       id="rect4136-2-60"
+       width="101.07784"
+       height="31.998148"
+       x="547.36304"
+       y="581.1026" />
+    <text
+       xml:space="preserve"
+       style="font-style:normal;font-weight:normal;line-height:0%;font-family:sans-serif;letter-spacing:0px;word-spacing:0px;fill:#000000;fill-opacity:1;stroke:none;stroke-width:1px;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1"
+       x="557.83484"
+       y="602.32745"
+       id="text4138-6-6"><tspan
+         sodipodi:role="line"
+         id="tspan4140-1-2"
+         x="557.83484"
+         y="602.32745"
+         style="font-size:15px;line-height:1.25">user_driver</tspan></text>
+    <path
+       style="fill:none;fill-rule:evenodd;stroke:#000000;stroke-width:1px;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1;marker-end:url(#marker4613)"
+       d="m 547.36304,600.78954 -156.58203,0.0691"
+       id="path4855"
+       inkscape:connector-curvature="0"
+       sodipodi:nodetypes="cc" />
+    <rect
+       style="fill:#000000;stroke:#000000;stroke-width:0.6465112;filter:url(#filter4169-3-5-8)"
+       id="rect4136-3-6-5-7"
+       width="101.07784"
+       height="31.998148"
+       x="128.74678"
+       y="80.648842"
+       transform="matrix(1.2452511,0,0,0.98513016,113.15182,641.02594)" />
+    <rect
+       style="fill:url(#linearGradient5032-3-9);fill-opacity:1;stroke:#000000;stroke-width:0.71606314"
+       id="rect4136-2-6-3"
+       width="125.86729"
+       height="31.522341"
+       x="271.75983"
+       y="718.45435" />
+    <text
+       xml:space="preserve"
+       style="font-style:normal;font-weight:normal;line-height:0%;font-family:sans-serif;letter-spacing:0px;word-spacing:0px;fill:#000000;fill-opacity:1;stroke:none;stroke-width:1px;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1"
+       x="306.29599"
+       y="746.50073"
+       id="text4138-6-2-6"><tspan
+         sodipodi:role="line"
+         id="tspan4140-1-9-1"
+         x="306.29599"
+         y="746.50073"
+         style="font-size:15px;line-height:1.25">sdmdev</tspan></text>
+    <path
+       style="fill:none;fill-rule:evenodd;stroke:#000000;stroke-width:1px;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1;marker-end:url(#marker4825-6-2)"
+       d="m 329.57309,619.72453 5.0373,97.14447"
+       id="path4661-3"
+       inkscape:connector-curvature="0"
+       sodipodi:nodetypes="cc" />
+    <path
+       style="fill:none;fill-rule:evenodd;stroke:#000000;stroke-width:1px;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1;marker-end:url(#marker4825-6-2-1)"
+       d="m 342.57219,830.63108 -5.67699,-79.2841"
+       id="path4661-3-4"
+       inkscape:connector-curvature="0"
+       sodipodi:nodetypes="cc" />
+    <rect
+       style="fill:#000000;stroke:#000000;stroke-width:0.6465112;filter:url(#filter4169-3-5-8-5)"
+       id="rect4136-3-6-5-7-3"
+       width="101.07784"
+       height="31.998148"
+       x="128.74678"
+       y="80.648842"
+       transform="matrix(1.3742742,0,0,0.97786398,101.09126,754.58534)" />
+    <rect
+       style="fill:url(#linearGradient5032-3-9-7);fill-opacity:1;stroke:#000000;stroke-width:0.74946606"
+       id="rect4136-2-6-3-6"
+       width="138.90866"
+       height="31.289837"
+       x="276.13297"
+       y="831.44263" />
+    <text
+       xml:space="preserve"
+       style="font-style:normal;font-weight:normal;line-height:0%;font-family:sans-serif;letter-spacing:0px;word-spacing:0px;fill:#000000;fill-opacity:1;stroke:none;stroke-width:1px;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1"
+       x="295.67819"
+       y="852.98224"
+       id="text4138-6-2-6-1"><tspan
+         sodipodi:role="line"
+         id="tspan4140-1-9-1-0"
+         x="295.67819"
+         y="852.98224"
+         style="font-size:15px;line-height:1.25">Device Driver</tspan></text>
+    <text
+       xml:space="preserve"
+       style="font-style:normal;font-weight:normal;line-height:0%;font-family:sans-serif;letter-spacing:0px;word-spacing:0px;fill:#000000;fill-opacity:1;stroke:none;stroke-width:1px;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1"
+       x="349.31198"
+       y="829.46118"
+       id="text4138-6-2-6-1-6"><tspan
+         sodipodi:role="line"
+         id="tspan4140-1-9-1-0-3"
+         x="349.31198"
+         y="829.46118"
+         style="font-size:15px;line-height:1.25">*</tspan></text>
+    <text
+       xml:space="preserve"
+       style="font-style:normal;font-weight:normal;line-height:0%;font-family:sans-serif;letter-spacing:0px;word-spacing:0px;fill:#000000;fill-opacity:1;stroke:none;stroke-width:1px;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1"
+       x="349.98282"
+       y="768.698"
+       id="text4138-6-2-6-1-6-2"><tspan
+         sodipodi:role="line"
+         id="tspan4140-1-9-1-0-3-0"
+         x="349.98282"
+         y="768.698"
+         style="font-size:15px;line-height:1.25">1</tspan></text>
+    <path
+       style="fill:none;fill-rule:evenodd;stroke:#000000;stroke-width:1px;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1;marker-end:url(#marker4825-6-2-6)"
+       d="m 568.1238,614.05402 0.51369,333.80219"
+       id="path4661-3-5"
+       inkscape:connector-curvature="0"
+       sodipodi:nodetypes="cc" />
+    <text
+       xml:space="preserve"
+       style="font-style:normal;font-weight:normal;line-height:0%;font-family:sans-serif;text-align:center;letter-spacing:0px;word-spacing:0px;text-anchor:middle;fill:#000000;fill-opacity:1;stroke:none;stroke-width:1px;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1"
+       x="371.8013"
+       y="664.62476"
+       id="text4138-6-2-6-1-6-2-5"><tspan
+         sodipodi:role="line"
+         x="371.8013"
+         y="664.62476"
+         id="tspan4274"
+         style="font-size:15px;line-height:1.25">&lt;&lt;vfio&gt;&gt;</tspan><tspan
+         sodipodi:role="line"
+         x="371.8013"
+         y="683.37476"
+         id="tspan4305"
+         style="font-size:15px;line-height:1.25">resource management</tspan></text>
+    <text
+       xml:space="preserve"
+       style="font-style:normal;font-weight:normal;line-height:0%;font-family:sans-serif;letter-spacing:0px;word-spacing:0px;fill:#000000;fill-opacity:1;stroke:none;stroke-width:1px;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1"
+       x="389.92969"
+       y="587.44836"
+       id="text4138-6-2-6-1-6-2-56"><tspan
+         sodipodi:role="line"
+         id="tspan4140-1-9-1-0-3-0-9"
+         x="389.92969"
+         y="587.44836"
+         style="font-size:15px;line-height:1.25">1</tspan></text>
+    <text
+       xml:space="preserve"
+       style="font-style:normal;font-weight:normal;line-height:0%;font-family:sans-serif;letter-spacing:0px;word-spacing:0px;fill:#000000;fill-opacity:1;stroke:none;stroke-width:1px;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1"
+       x="528.64813"
+       y="600.08429"
+       id="text4138-6-2-6-1-6-3"><tspan
+         sodipodi:role="line"
+         id="tspan4140-1-9-1-0-3-7"
+         x="528.64813"
+         y="600.08429"
+         style="font-size:15px;line-height:1.25">*</tspan></text>
+    <rect
+       style="fill:#000000;stroke:#000000;stroke-width:0.6465112;filter:url(#filter4169-3-5-8-54)"
+       id="rect4136-3-6-5-7-4"
+       width="101.07784"
+       height="31.998148"
+       x="128.74678"
+       y="80.648842"
+       transform="matrix(1.3745874,0,0,1.8929066,-132.7754,556.04505)" />
+    <rect
+       style="fill:url(#linearGradient5032-3-9-4);fill-opacity:1;stroke:#000000;stroke-width:1.07280123"
+       id="rect4136-2-6-3-4"
+       width="138.91039"
+       height="64.111"
+       x="42.321312"
+       y="704.8371" />
+    <text
+       xml:space="preserve"
+       style="font-style:normal;font-weight:normal;line-height:0%;font-family:sans-serif;letter-spacing:0px;word-spacing:0px;fill:#000000;fill-opacity:1;stroke:none;stroke-width:1px;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1"
+       x="110.30745"
+       y="722.94025"
+       id="text4138-6-2-6-3"><tspan
+         sodipodi:role="line"
+         x="111.99202"
+         y="722.94025"
+         id="tspan4366"
+         style="font-size:15px;line-height:1.25;text-align:center;text-anchor:middle">other standard </tspan><tspan
+         sodipodi:role="line"
+         x="110.30745"
+         y="741.69025"
+         id="tspan4368"
+         style="font-size:15px;line-height:1.25;text-align:center;text-anchor:middle">framework</tspan><tspan
+         sodipodi:role="line"
+         x="110.30745"
+         y="760.44025"
+         style="font-size:15px;line-height:1.25;text-align:center;text-anchor:middle"
+         id="tspan6840">(crypto/nic/others)</tspan></text>
+    <path
+       style="fill:none;fill-rule:evenodd;stroke:#000000;stroke-width:1px;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1;marker-end:url(#marker4825-6-2-1-8)"
+       d="M 276.29661,849.04109 134.04449,771.90853"
+       id="path4661-3-4-8"
+       inkscape:connector-curvature="0"
+       sodipodi:nodetypes="cc" />
+    <text
+       xml:space="preserve"
+       style="font-style:normal;font-weight:normal;line-height:0%;font-family:sans-serif;letter-spacing:0px;word-spacing:0px;fill:#000000;fill-opacity:1;stroke:none;stroke-width:1px;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1"
+       x="313.70813"
+       y="730.06366"
+       id="text4138-6-2-6-36"><tspan
+         sodipodi:role="line"
+         id="tspan4140-1-9-1-7"
+         x="313.70813"
+         y="730.06366"
+         style="font-size:10px;line-height:1.25">&lt;&lt;lkm&gt;&gt;</tspan></text>
+    <text
+       xml:space="preserve"
+       style="font-style:normal;font-weight:normal;line-height:0%;font-family:sans-serif;text-align:start;letter-spacing:0px;word-spacing:0px;text-anchor:start;fill:#000000;fill-opacity:1;stroke:none;stroke-width:1px;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1"
+       x="343.81625"
+       y="786.44141"
+       id="text4138-6-2-6-1-6-2-5-7-5"><tspan
+         sodipodi:role="line"
+         x="343.81625"
+         y="786.44141"
+         style="font-size:15px;line-height:1.25;text-align:start;text-anchor:start"
+         id="tspan2357">register as mdev with</tspan><tspan
+         sodipodi:role="line"
+         x="343.81625"
+         y="805.19141"
+         style="font-size:15px;line-height:1.25;text-align:start;text-anchor:start"
+         id="tspan1462">&quot;share domain&quot; attribute</tspan></text>
+    <text
+       xml:space="preserve"
+       style="font-style:normal;font-weight:normal;line-height:0%;font-family:sans-serif;letter-spacing:0px;word-spacing:0px;fill:#000000;fill-opacity:1;stroke:none;stroke-width:1px;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1"
+       x="29.145819"
+       y="833.44244"
+       id="text4138-6-2-6-1-6-2-5-7-5-2"><tspan
+         sodipodi:role="line"
+         x="29.145819"
+         y="833.44244"
+         id="tspan4301"
+         style="font-size:15px;line-height:1.25">register to other subsystem</tspan></text>
+    <text
+       xml:space="preserve"
+       style="font-style:normal;font-weight:normal;line-height:0%;font-family:sans-serif;letter-spacing:0px;word-spacing:0px;fill:#000000;fill-opacity:1;stroke:none;stroke-width:1px;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1"
+       x="301.20813"
+       y="597.29437"
+       id="text4138-6-2-6-36-1"><tspan
+         sodipodi:role="line"
+         id="tspan4140-1-9-1-7-2"
+         x="301.20813"
+         y="597.29437"
+         style="font-size:10px;line-height:1.25">&lt;&lt;user_lib&gt;&gt;</tspan></text>
+    <text
+       xml:space="preserve"
+       style="font-style:normal;font-weight:normal;line-height:0%;font-family:sans-serif;text-align:center;letter-spacing:0px;word-spacing:0px;text-anchor:middle;fill:#000000;fill-opacity:1;stroke:none;stroke-width:1px;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1"
+       x="649.09613"
+       y="774.4798"
+       id="text4138-6-2-6-1-6-2-5-3"><tspan
+         sodipodi:role="line"
+         id="tspan4140-1-9-1-0-3-0-4-6"
+         x="649.09613"
+         y="774.4798"
+         style="font-size:15px;line-height:1.25">&lt;&lt;vfio&gt;&gt;</tspan><tspan
+         sodipodi:role="line"
+         x="649.09613"
+         y="793.2298"
+         id="tspan4274-7"
+         style="font-size:15px;line-height:1.25">Hardware Accessing</tspan></text>
+    <text
+       xml:space="preserve"
+       style="font-style:normal;font-weight:normal;line-height:0%;font-family:sans-serif;text-align:center;letter-spacing:0px;word-spacing:0px;text-anchor:middle;fill:#000000;fill-opacity:1;stroke:none;stroke-width:1px;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1"
+       x="371.01291"
+       y="529.23682"
+       id="text4138-6-2-6-1-6-2-5-36"><tspan
+         sodipodi:role="line"
+         x="371.01291"
+         y="529.23682"
+         id="tspan4305-3"
+         style="font-size:15px;line-height:1.25">wd user api</tspan></text>
+    <path
+       style="fill:none;fill-rule:evenodd;stroke:#000000;stroke-width:1px;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1"
+       d="m 328.19325,585.87943 0,-23.57142"
+       id="path4348"
+       inkscape:connector-curvature="0" />
+    <ellipse
+       style="opacity:1;fill:#ffffff;fill-opacity:1;fill-rule:evenodd;stroke:#000000;stroke-width:1;stroke-miterlimit:4;stroke-dasharray:none;stroke-dashoffset:0"
+       id="path4350"
+       cx="328.01468"
+       cy="551.95081"
+       rx="11.607142"
+       ry="10.357142" />
+    <path
+       style="opacity:0.444;fill:url(#linearGradient6836);fill-opacity:1;fill-rule:evenodd;stroke:none;stroke-width:1;stroke-miterlimit:4;stroke-dasharray:none;stroke-dashoffset:0;filter:url(#filter5382)"
+       id="path4350-2"
+       sodipodi:type="arc"
+       sodipodi:cx="329.44327"
+       sodipodi:cy="553.37933"
+       sodipodi:rx="11.607142"
+       sodipodi:ry="10.357142"
+       sodipodi:start="0"
+       sodipodi:end="6.2509098"
+       d="m 341.05041,553.37933 a 11.607142,10.357142 0 0 1 -11.51349,10.35681 11.607142,10.357142 0 0 1 -11.69928,-10.18967 11.607142,10.357142 0 0 1 11.32469,-10.52124 11.607142,10.357142 0 0 1 11.88204,10.01988"
+       sodipodi:open="true" />
+    <text
+       xml:space="preserve"
+       style="font-style:normal;font-weight:normal;line-height:0%;font-family:sans-serif;text-align:center;letter-spacing:0px;word-spacing:0px;text-anchor:middle;fill:#000000;fill-opacity:1;stroke:none;stroke-width:1px;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1"
+       x="543.91455"
+       y="978.22363"
+       id="text4138-6-2-6-1-6-2-5-36-3"><tspan
+         sodipodi:role="line"
+         x="543.91455"
+         y="978.22363"
+         id="tspan4305-3-67"
+         style="font-size:15px;line-height:1.25">Device(Hardware)</tspan></text>
+    <path
+       style="fill:none;fill-rule:evenodd;stroke:#000000;stroke-width:1px;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1;marker-end:url(#marker4825-6-2-6-2)"
+       d="m 347.51164,865.4527 153.19752,91.52439"
+       id="path4661-3-5-1"
+       inkscape:connector-curvature="0"
+       sodipodi:nodetypes="cc" />
+    <text
+       xml:space="preserve"
+       style="font-style:normal;font-weight:normal;font-size:12px;line-height:0%;font-family:sans-serif;letter-spacing:0px;word-spacing:0px;fill:#000000;fill-opacity:1;stroke:none;stroke-width:1px;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1"
+       x="343.6398"
+       y="716.47754"
+       id="text4138-6-2-6-1-6-2-5-7-5-2-6"><tspan
+         sodipodi:role="line"
+         x="343.6398"
+         y="716.47754"
+         id="tspan4301-4"
+         style="font-style:italic;font-variant:normal;font-weight:normal;font-stretch:normal;font-size:15px;line-height:1.25;font-family:sans-serif;-inkscape-font-specification:'sans-serif Italic';stroke-width:1px">Share Domain mdev</tspan></text>
+  </g>
+</svg>
-- 
2.17.1
