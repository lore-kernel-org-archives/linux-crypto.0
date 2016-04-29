From: Julia Lawall <Julia.Lawall@lip6.fr>
Subject: [PATCH 0/5] Use dma_pool_zalloc
Date: Fri, 29 Apr 2016 22:09:07 +0200
Message-ID: <1461960552-7429-1-git-send-email-Julia.Lawall@lip6.fr>
Cc: kernel-janitors@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	=?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>,
	linux-kernel@vger.kernel.org,
	Dan Williams <dan.j.williams@intel.com>,
	dmaengine@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
To: linux-crypto@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Dma_pool_zalloc combines dma_pool_alloc and memset 0.  The semantic patch
that makes this transformation is as follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
type T;
T *d;
expression e;
statement S;
@@

        d =
-            dma_pool_alloc
+            dma_pool_zalloc
             (...);
        if (!d) S
-       memset(d, 0, sizeof(T));

@@
expression d,e;
statement S;
@@

        d =
-            dma_pool_alloc
+            dma_pool_zalloc
             (...);
        if (!d) S
-       memset(d, 0, sizeof(*d));
// </smpl>

---

 drivers/crypto/marvell/tdma.c    |    5 ++---
 drivers/dma/fsldma.c             |    3 +--
 drivers/dma/ioat/init.c          |    5 ++---
 drivers/dma/mmp_pdma.c           |    3 +--
 drivers/dma/xilinx/xilinx_vdma.c |    3 +--
 5 files changed, 7 insertions(+), 12 deletions(-)
