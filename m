From: Kenneth Lee <nek.in.cn@gmail.com>
Subject: [RFC PATCH 1/7] vfio/spimdev: Add documents for WarpDrive framework
Date: Wed,  1 Aug 2018 18:22:15 +0800
Message-ID: <20180801102221.5308-2-nek.in.cn@gmail.com>
References: <20180801102221.5308-1-nek.in.cn@gmail.com>
Cc: linuxarm@huawei.com
To: Jonathan Corbet <corbet@lwn.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Kenneth Lee <liguozhu@hisilicon.com>,
        Hao Fang <fanghao11@huawei.com>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        Zaibo Xu <xuzaibo@huawei.com>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, iommu@lists.linux-foundation.org,
        kvm@vger.kernel.org, linux-accelerators@lists.ozlabs.org,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Sanjay Kumar <sanjay.k.kumar@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180801102221.5308-1-nek.in.cn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Kenneth Lee <liguozhu@hisilicon.com>

WarpDrive is a common user space accelerator framework.  Its main component
in Kernel is called spimdev, Share Parent IOMMU Mediated Device. It exposes
the hardware capabilities to the user space via vfio-mdev. So processes in
user land can obtain a "queue" by open the device and direct access the
hardware MMIO space or do DMA operation via VFIO interface.

WarpDrive is intended to be used with Jean Philippe Brucker's SVA patchset
(it is still in RFC stage) to support multi-process. But This is not a must.
Without the SVA patches, WarpDrive can still work for one process for every
hardware device.

This patch add detail documents for the framework.

Signed-off-by: Kenneth Lee <liguozhu@hisilicon.com>
---
 Documentation/00-INDEX                |   2 +
 Documentation/warpdrive/warpdrive.rst | 153 ++++++
 Documentation/warpdrive/wd-arch.svg   | 732 ++++++++++++++++++++++++++
 Documentation/warpdrive/wd.svg        | 526 ++++++++++++++++++
 4 files changed, 1413 insertions(+)
 create mode 100644 Documentation/warpdrive/warpdrive.rst
 create mode 100644 Documentation/warpdrive/wd-arch.svg
 create mode 100644 Documentation/warpdrive/wd.svg

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
index 000000000000..3792b2780ea6
--- /dev/null
+++ b/Documentation/warpdrive/warpdrive.rst
@@ -0,0 +1,153 @@
+Introduction of WarpDrive
+=========================
+
+*WarpDrive* is a general accelerator framework built on top of vfio.
+It can be taken as a light weight virtual function, which you can use without
+*SR-IOV* like facility and can be shared among multiple processes.
+
+It can be used as the quick channel for accelerators, network adaptors or
+other hardware in user space. It can make some implementation simpler.  E.g.
+you can reuse most of the *netdev* driver and just share some ring buffer to
+the user space driver for *DPDK* or *ODP*. Or you can combine the RSA
+accelerator with the *netdev* in the user space as a Web reversed proxy, etc.
+
+The name *WarpDrive* is simply a cool and general name meaning the framework
+makes the application faster. In kernel, the framework is called SPIMDEV,
+namely "Share Parent IOMMU Mediated Device".
+
+
+How does it work
+================
+
+*WarpDrive* takes the Hardware Accelerator as a heterogeneous processor which
+can share some load for the CPU:
+
+.. image:: wd.svg
+        :alt: This is a .svg image, if your browser cannot show it,
+                try to download and view it locally
+
+So it provides the capability to the user application to:
+
+1. Send request to the hardware
+2. Share memory with the application and other accelerators
+
+These requirements can be fulfilled by VFIO if the accelerator can serve each
+application with a separated Virtual Function. But a *SR-IOV* like VF (we will
+call it *HVF* hereinafter) design is too heavy for the accelerator which
+service thousands of processes.
+
+And the *HVF* is not good for the scenario that a device keep most of its
+resource but share partial of the function to the user space. E.g. a *NIC*
+works as a *netdev* but share some hardware queues to the user application to
+send packets direct to the hardware.
+
+*VFIO-mdev* can solve some of the problem here. But *VFIO-mdev* has two problem:
+
+1. it cannot make use of its parent device's IOMMU.
+2. it is assumed to be openned only once.
+
+So it will need some add-on for better resource control and let the VFIO
+driver be aware of this.
+
+
+Architecture
+------------
+
+The full *WarpDrive* architecture is represented in the following class
+diagram:
+
+.. image:: wd-arch.svg
+        :alt: This is a .svg image, if your browser cannot show it,
+                try to download and view it locally
+
+The idea is: when a device is probed, it can be registered to the general
+framework, e.g. *netdev* or *crypto*, and the *SPIMDEV* at the same time.
+
+If *SPIMDEV* is registered. A *mdev* creation interface is created. Then the
+system administrator can create a *mdev* in the user space and set its
+parameters via its sysfs interfacev. But not like the other mdev
+implementation, hardware resource will not be allocated until it is opened by
+an application.
+
+With this strategy, the hardware resource can be easily scheduled among
+multiple processes.
+
+
+The user API
+------------
+
+We adopt a polling style interface in the user space: ::
+
+        int wd_request_queue(int container, struct wd_queue *q,
+                             const char *mdev)
+        void wd_release_queue(struct wd_queue *q);
+
+        int wd_send(struct wd_queue *q, void *req);
+        int wd_recv(struct wd_queue *q, void **req);
+        int wd_recv_sync(struct wd_queue *q, void **req);
+
+the ..._sync() interface is a wrapper to the non sync version. They wait on the
+device until the queue become available.
+
+Memory can be done by VFIO DMA API. Or the following helper function can be
+adopted: ::
+
+        int wd_mem_share(struct wd_queue *q, const void *addr,
+                         size_t size, int flags);
+        void wd_mem_unshare(struct wd_queue *q, const void *addr, size_t size);
+
+Todo: if the IOMMU support *ATS* or *SMMU* stall mode. mem share is not
+necessary. This can be check with SPImdev sysfs interface.
+
+The user API is not mandatory. It is simply a suggestion and hint what the
+kernel interface is supposed to support.
+
+
+The user driver
+---------------
+
+*WarpDrive* expose the hardware IO space to the user process (via *mmap*). So
+it will require user driver for implementing the user API. The following API
+is suggested for a user driver: ::
+
+        int open(struct wd_queue *q);
+        int close(struct wd_queue *q);
+        int send(struct wd_queue *q, void *req);
+        int recv(struct wd_queue *q, void **req);
+
+These callback enable the communication between the user application and the
+device. You will still need the hardware-depend algorithm driver to access the
+algorithm functionality of the accelerator itself.
+
+
+Multiple processes support
+==========================
+
+In the latest mainline kernel (4.18) when this document is written.
+Multi-process is not supported in VFIO yet.
+
+*JPB* has a patchset to enable this[2]_. We have tested it with our hardware
+(which is known as *D06*). It works well. *WarpDrive* rely on them to support
+multiple processes. If it is not enabled, *WarpDrive* can still work, but it
+support only one process, which will share the same io map table with kernel
+(but the user application cannot access the kernel address, So it is not going
+to be a security problem)
+
+
+Legacy Mode Support
+===================
+For the hardware on which IOMMU is not support, WarpDrive can run on *NOIOMMU*
+mode.
+
+
+References
+==========
+.. [1] Accroding to the comment in in mm/gup.c, The *gup* is only safe within
+       a syscall.  Because it can only keep the physical memory in place
+       without making sure the VMA will always point to it. Maybe we should
+       raise the VM_PINNED patchset (see
+       https://lists.gt.net/linux/kernel/1931993) again to solve this problem.
+.. [2] https://patchwork.kernel.org/patch/10394851/
+.. [3] https://zhuanlan.zhihu.com/p/35489035
+
+.. vim: tw=78
diff --git a/Documentation/warpdrive/wd-arch.svg b/Documentation/warpdrive/wd-arch.svg
new file mode 100644
index 000000000000..1b3d1817c4ba
--- /dev/null
+++ b/Documentation/warpdrive/wd-arch.svg
@@ -0,0 +1,732 @@
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
+     inkscape:zoom="0.98994949"
+     inkscape:cx="222.32868"
+     inkscape:cy="370.44492"
+     inkscape:document-units="px"
+     inkscape:current-layer="layer1"
+     showgrid="false"
+     inkscape:window-width="1916"
+     inkscape:window-height="1033"
+     inkscape:window-x="0"
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
+         style="font-size:15px;line-height:1.25">spimdev</tspan></text>
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
+         id="tspan2278">regist<tspan
+   style="text-align:start;text-anchor:start"
+   id="tspan2280">er as mdev with &quot;share </tspan></tspan><tspan
+         sodipodi:role="line"
+         x="343.81625"
+         y="805.19141"
+         style="font-size:15px;line-height:1.25;text-align:start;text-anchor:start"
+         id="tspan2357"><tspan
+   style="text-align:start;text-anchor:start"
+   id="tspan2359">parent iommu&quot; attribu</tspan>te</tspan></text>
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
+         style="font-style:italic;font-variant:normal;font-weight:normal;font-stretch:normal;font-size:15px;line-height:1.25;font-family:sans-serif;-inkscape-font-specification:'sans-serif Italic';stroke-width:1px">Share Parent's IOMMU mdev</tspan></text>
+  </g>
+</svg>
diff --git a/Documentation/warpdrive/wd.svg b/Documentation/warpdrive/wd.svg
new file mode 100644
index 000000000000..87ab92ebfbc6
--- /dev/null
+++ b/Documentation/warpdrive/wd.svg
@@ -0,0 +1,526 @@
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
+   height="116mm"
+   viewBox="0 0 744.09449 411.02338"
+   id="svg2"
+   version="1.1"
+   inkscape:version="0.92.3 (2405546, 2018-03-11)"
+   sodipodi:docname="wd.svg">
+  <defs
+     id="defs4">
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
+    <linearGradient
+       inkscape:collect="always"
+       xlink:href="#linearGradient5026"
+       id="linearGradient5032-3"
+       x1="353"
+       y1="211.3622"
+       x2="565.5"
+       y2="174.8622"
+       gradientUnits="userSpaceOnUse"
+       gradientTransform="matrix(2.7384117,0,0,0.91666329,-952.8283,571.10143)" />
+    <filter
+       inkscape:collect="always"
+       style="color-interpolation-filters:sRGB"
+       id="filter4169-3-5"
+       x="-0.031597666"
+       width="1.0631953"
+       y="-0.099812768"
+       height="1.1996255">
+      <feGaussianBlur
+         inkscape:collect="always"
+         stdDeviation="1.3307599"
+         id="feGaussianBlur4171-6-3" />
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
+    <linearGradient
+       inkscape:collect="always"
+       xlink:href="#linearGradient5026"
+       id="linearGradient5032-3-8"
+       x1="353"
+       y1="211.3622"
+       x2="565.5"
+       y2="174.8622"
+       gradientUnits="userSpaceOnUse"
+       gradientTransform="matrix(1.0104674,0,0,1.0052679,-218.642,661.15448)" />
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
+    <linearGradient
+       inkscape:collect="always"
+       xlink:href="#linearGradient5026"
+       id="linearGradient5032-3-8-2"
+       x1="353"
+       y1="211.3622"
+       x2="565.5"
+       y2="174.8622"
+       gradientUnits="userSpaceOnUse"
+       gradientTransform="matrix(2.1450559,0,0,1.0052679,-521.97704,740.76422)" />
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
+         id="feGaussianBlur4171-6-3-9-1" />
+    </filter>
+    <linearGradient
+       inkscape:collect="always"
+       xlink:href="#linearGradient5026"
+       id="linearGradient5032-3-8-0"
+       x1="353"
+       y1="211.3622"
+       x2="565.5"
+       y2="174.8622"
+       gradientUnits="userSpaceOnUse"
+       gradientTransform="matrix(1.0104674,0,0,1.0052679,83.456748,660.20747)" />
+    <filter
+       inkscape:collect="always"
+       style="color-interpolation-filters:sRGB"
+       id="filter4169-3-5-8-6"
+       x="-0.031597666"
+       width="1.0631953"
+       y="-0.099812768"
+       height="1.1996255">
+      <feGaussianBlur
+         inkscape:collect="always"
+         stdDeviation="1.3307599"
+         id="feGaussianBlur4171-6-3-9-2" />
+    </filter>
+    <linearGradient
+       inkscape:collect="always"
+       xlink:href="#linearGradient5026"
+       id="linearGradient5032-3-84"
+       x1="353"
+       y1="211.3622"
+       x2="565.5"
+       y2="174.8622"
+       gradientUnits="userSpaceOnUse"
+       gradientTransform="matrix(1.9884948,0,0,0.94903536,-318.42665,564.37696)" />
+    <filter
+       inkscape:collect="always"
+       style="color-interpolation-filters:sRGB"
+       id="filter4169-3-5-4"
+       x="-0.031597666"
+       width="1.0631953"
+       y="-0.099812768"
+       height="1.1996255">
+      <feGaussianBlur
+         inkscape:collect="always"
+         stdDeviation="1.3307599"
+         id="feGaussianBlur4171-6-3-0" />
+    </filter>
+    <marker
+       markerWidth="11.227358"
+       markerHeight="12.355258"
+       refX="10"
+       refY="6.177629"
+       orient="auto"
+       id="marker4825-6-0-0">
+      <path
+         inkscape:connector-curvature="0"
+         id="path4757-1-93-8"
+         d="M 0.42024733,0.42806444 10.231357,6.3500844 0.24347733,11.918544"
+         style="fill:none;fill-rule:evenodd;stroke:#000000;stroke-width:1px;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1" />
+    </marker>
+    <marker
+       markerWidth="11.227358"
+       markerHeight="12.355258"
+       refX="10"
+       refY="6.177629"
+       orient="auto"
+       id="marker4825-6-3">
+      <path
+         inkscape:connector-curvature="0"
+         id="path4757-1-1"
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
+     inkscape:zoom="0.98994949"
+     inkscape:cx="457.47339"
+     inkscape:cy="250.14781"
+     inkscape:document-units="px"
+     inkscape:current-layer="layer1"
+     showgrid="false"
+     inkscape:window-width="1916"
+     inkscape:window-height="1033"
+     inkscape:window-x="0"
+     inkscape:window-y="22"
+     inkscape:window-maximized="0"
+     fit-margin-right="0.3" />
+  <metadata
+     id="metadata7">
+    <rdf:RDF>
+      <cc:Work
+         rdf:about="">
+        <dc:format>image/svg+xml</dc:format>
+        <dc:type
+           rdf:resource="http://purl.org/dc/dcmitype/StillImage" />
+        <dc:title></dc:title>
+      </cc:Work>
+    </rdf:RDF>
+  </metadata>
+  <g
+     inkscape:label="Layer 1"
+     inkscape:groupmode="layer"
+     id="layer1"
+     transform="translate(0,-641.33861)">
+    <rect
+       style="fill:#000000;stroke:#000000;stroke-width:0.6465112;filter:url(#filter4169-3-5)"
+       id="rect4136-3-6-5"
+       width="101.07784"
+       height="31.998148"
+       x="128.74678"
+       y="80.648842"
+       transform="matrix(2.7384116,0,0,0.91666328,-284.06895,664.79751)" />
+    <rect
+       style="fill:url(#linearGradient5032-3);fill-opacity:1;stroke:#000000;stroke-width:1.02430749"
+       id="rect4136-2-6"
+       width="276.79272"
+       height="29.331528"
+       x="64.723419"
+       y="736.84473" />
+    <text
+       xml:space="preserve"
+       style="font-style:normal;font-weight:normal;line-height:0%;font-family:sans-serif;letter-spacing:0px;word-spacing:0px;fill:#000000;fill-opacity:1;stroke:none;stroke-width:1px;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1"
+       x="78.223282"
+       y="756.79803"
+       id="text4138-6-2"><tspan
+         sodipodi:role="line"
+         id="tspan4140-1-9"
+         x="78.223282"
+         y="756.79803"
+         style="font-size:15px;line-height:1.25">user application (running by the CPU</tspan></text>
+    <path
+       style="fill:none;fill-rule:evenodd;stroke:#000000;stroke-width:1px;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1;marker-end:url(#marker4825-6)"
+       d="m 217.67507,876.6738 113.40331,45.0758"
+       id="path4661"
+       inkscape:connector-curvature="0"
+       sodipodi:nodetypes="cc" />
+    <path
+       style="fill:none;fill-rule:evenodd;stroke:#000000;stroke-width:1px;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1;marker-end:url(#marker4825-6-0)"
+       d="m 208.10197,767.69811 0.29362,76.03656"
+       id="path4661-6"
+       inkscape:connector-curvature="0"
+       sodipodi:nodetypes="cc" />
+    <rect
+       style="fill:#000000;stroke:#000000;stroke-width:0.6465112;filter:url(#filter4169-3-5-8)"
+       id="rect4136-3-6-5-3"
+       width="101.07784"
+       height="31.998148"
+       x="128.74678"
+       y="80.648842"
+       transform="matrix(1.0104673,0,0,1.0052679,28.128628,763.90722)" />
+    <rect
+       style="fill:url(#linearGradient5032-3-8);fill-opacity:1;stroke:#000000;stroke-width:0.65159565"
+       id="rect4136-2-6-6"
+       width="102.13586"
+       height="32.16671"
+       x="156.83217"
+       y="842.91852" />
+    <text
+       xml:space="preserve"
+       style="font-style:normal;font-weight:normal;font-size:12px;line-height:0%;font-family:sans-serif;letter-spacing:0px;word-spacing:0px;fill:#000000;fill-opacity:1;stroke:none;stroke-width:1px;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1"
+       x="188.58519"
+       y="864.47125"
+       id="text4138-6-2-8"><tspan
+         sodipodi:role="line"
+         id="tspan4140-1-9-0"
+         x="188.58519"
+         y="864.47125"
+         style="font-size:15px;line-height:1.25;stroke-width:1px">MMU</tspan></text>
+    <rect
+       style="fill:#000000;stroke:#000000;stroke-width:0.6465112;filter:url(#filter4169-3-5-8-5)"
+       id="rect4136-3-6-5-3-1"
+       width="101.07784"
+       height="31.998148"
+       x="128.74678"
+       y="80.648842"
+       transform="matrix(2.1450556,0,0,1.0052679,1.87637,843.51696)" />
+    <rect
+       style="fill:url(#linearGradient5032-3-8-2);fill-opacity:1;stroke:#000000;stroke-width:0.94937181"
+       id="rect4136-2-6-6-0"
+       width="216.8176"
+       height="32.16671"
+       x="275.09283"
+       y="922.5282" />
+    <text
+       xml:space="preserve"
+       style="font-style:normal;font-weight:normal;font-size:12px;line-height:0%;font-family:sans-serif;letter-spacing:0px;word-spacing:0px;fill:#000000;fill-opacity:1;stroke:none;stroke-width:1px;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1"
+       x="347.81482"
+       y="943.23291"
+       id="text4138-6-2-8-8"><tspan
+         sodipodi:role="line"
+         id="tspan4140-1-9-0-5"
+         x="347.81482"
+         y="943.23291"
+         style="font-size:15px;line-height:1.25;stroke-width:1px">Memory</tspan></text>
+    <rect
+       style="fill:#000000;stroke:#000000;stroke-width:0.6465112;filter:url(#filter4169-3-5-8-6)"
+       id="rect4136-3-6-5-3-5"
+       width="101.07784"
+       height="31.998148"
+       x="128.74678"
+       y="80.648842"
+       transform="matrix(1.0104673,0,0,1.0052679,330.22737,762.9602)" />
+    <rect
+       style="fill:url(#linearGradient5032-3-8-0);fill-opacity:1;stroke:#000000;stroke-width:0.65159565"
+       id="rect4136-2-6-6-8"
+       width="102.13586"
+       height="32.16671"
+       x="458.93091"
+       y="841.9715" />
+    <text
+       xml:space="preserve"
+       style="font-style:normal;font-weight:normal;font-size:12px;line-height:0%;font-family:sans-serif;letter-spacing:0px;word-spacing:0px;fill:#000000;fill-opacity:1;stroke:none;stroke-width:1px;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1"
+       x="490.68393"
+       y="863.52423"
+       id="text4138-6-2-8-6"><tspan
+         sodipodi:role="line"
+         id="tspan4140-1-9-0-2"
+         x="490.68393"
+         y="863.52423"
+         style="font-size:15px;line-height:1.25;stroke-width:1px">IOMMU</tspan></text>
+    <rect
+       style="fill:#000000;stroke:#000000;stroke-width:0.6465112;filter:url(#filter4169-3-5-4)"
+       id="rect4136-3-6-5-6"
+       width="101.07784"
+       height="31.998148"
+       x="128.74678"
+       y="80.648842"
+       transform="matrix(1.9884947,0,0,0.94903537,167.19229,661.38193)" />
+    <rect
+       style="fill:url(#linearGradient5032-3-84);fill-opacity:1;stroke:#000000;stroke-width:0.88813609"
+       id="rect4136-2-6-2"
+       width="200.99274"
+       height="30.367374"
+       x="420.4675"
+       y="735.97351" />
+    <text
+       xml:space="preserve"
+       style="font-style:normal;font-weight:normal;font-size:12px;line-height:0%;font-family:sans-serif;letter-spacing:0px;word-spacing:0px;fill:#000000;fill-opacity:1;stroke:none;stroke-width:1px;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1"
+       x="441.95297"
+       y="755.9068"
+       id="text4138-6-2-9"><tspan
+         sodipodi:role="line"
+         id="tspan4140-1-9-9"
+         x="441.95297"
+         y="755.9068"
+         style="font-size:15px;line-height:1.25;stroke-width:1px">Hardware Accelerator</tspan></text>
+    <path
+       style="fill:none;fill-rule:evenodd;stroke:#000000;stroke-width:1px;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1;marker-end:url(#marker4825-6-0-0)"
+       d="m 508.2914,766.55885 0.29362,76.03656"
+       id="path4661-6-1"
+       inkscape:connector-curvature="0"
+       sodipodi:nodetypes="cc" />
+    <path
+       style="fill:none;fill-rule:evenodd;stroke:#000000;stroke-width:1px;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1;marker-end:url(#marker4825-6-3)"
+       d="M 499.70201,876.47297 361.38296,920.80258"
+       id="path4661-1"
+       inkscape:connector-curvature="0"
+       sodipodi:nodetypes="cc" />
+  </g>
+</svg>
-- 
2.17.1
