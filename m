Return-Path: <SRS0=oFif=NX=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-pg1-f195.google.com ([209.85.215.195]:42144 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727357AbeKLRuc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Nov 2018 12:50:32 -0500
From: Kenneth Lee <nek.in.cn@gmail.com>
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Tim Sell <timothy.sell@unisys.com>,
        Sanyog Kale <sanyog.r.kale@intel.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?=
        <u.kleine-koenig@pengutronix.de>, Vinod Koul <vkoul@kernel.org>,
        David Kershner <david.kershner@unisys.com>,
        Sagar Dharia <sdharia@codeaurora.org>,
        Gavin Schenk <g.schenk@eckelmann.de>,
        Jens Axboe <axboe@kernel.dk>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        Cyrille Pitchen <cyrille.pitchen@free-electrons.com>,
        Johan Hovold <johan@kernel.org>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        Hao Fang <fanghao11@huawei.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Zaibo Xu <xuzaibo@huawei.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-accelerators@lists.ozlabs.org
Cc: linuxarm@huawei.com, guodong.xu@linaro.org,
        zhangfei.gao@foxmail.com, haojian.zhuang@linaro.org,
        Kenneth Lee <liguozhu@hisilicon.com>
Subject: [RFCv3 PATCH 0/6] A General Accelerator Framework, WarpDrive
Date: Mon, 12 Nov 2018 15:58:01 +0800
Message-Id: <20181112075807.9291-1-nek.in.cn@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Kenneth Lee <liguozhu@hisilicon.com>

*WarpDrive* is a general accelerator framework for the user application to
access the hardware without going through the kernel in data path.

WarpDrive is the name for the whole framework. The component in kernel
is called uacce, meaning "Unified/User-space-access-intended Accelerator
Framework". It makes use of the capability of IOMMU to maintain a
unified virtual address space between the hardware and the process.

The first patch in this patchset contains document of the framework.
Please refer to it for more information.

WarpDrive is intended to be used with Jean Philippe Brucker's SVA
patchset[1], which enables IO side page fault and PASID support. But
this patchset itself is simply the first step to support the no-PASID
version.

The patch 1 is document of the framework. The patch 2 add uacce support.
The patch 3 and 4 are drivers for Hisilicon's ZIP Accelerator. It is
registered to crypto subsystem. The patch 5 adds uacce support to the
accelerator driver. It then can work in either crypto or uacce mode. It
can support both mode at the same time when PASID mode is added in the
future.

The patch 6 is is a user space sample demonstrating how WarpDrive is
used.

The intension of this RFC is to know if the idea is acceptable.
So the focus is the uacce itself. The patch 3 and 4 will be sent to mainline
by another topic. We assume they will be accepted first and we can
upstream uacce. And if SVA is upstreamed, the new feature will be added
accordingly.

Change History:
V3 changed from V2:
	1. Build uacce from original IOMMU interface. V2 is built on VFIO.
	   But the VFIO way locking the user memory in place will not
	   work properly if the process fork a child. Because the
	   copy-on-write strategy will make the parent process lost its
	   page. This is not acceptable to accelerator user.
	2. The kernel component is renamed to uacce from sdmdev
	   accordingly
	3. Document is updated for the new design. The Static Shared
	   Virtual Memory concept is introduced to replace the User
	   Memory Sharing concept.
	4. Rebase to the lastest kernel (4.20.0-rc1)
	5. As an RFC, this version is tested only with "test-to-pass"
	   test case and not tested with Jean's SVA patch.

V2 changed from V1:
	1. Change kernel framework name from SPIMDEV (Share Parent IOMMU
	   Mdev) to SDMDEV (Share Domain Mdev).
	2. Allocate Hardware Resource when a new mdev is created (While
	   it is allocated when the mdev is openned)
	3. Unmap pages from the shared domain when the sdmdev iommu group is
	   detached. (This procedure is necessary, but missed in V1)
	4. Update document accordingly.
	5. Rebase to the latest kernel (4.19.0-rc1)


Refernces:
[1] https://www.spinics.net/lists/kernel/msg2651481.html
[2] https://github.com/Kenneth-Lee/linux-kernel-warpdrive/tree/warpdrive-sva-v0.5
[3] https://lkml.org/lkml/2018/7/22/34

Best Regards
Kenneth Lee

Kenneth Lee (6):
  uacce: Add documents for WarpDrive/uacce
  uacce: add uacce module
  crypto/hisilicon: add hisilicon Queue Manager driver
  crypto/hisilicon: add Hisilicon zip driver
  crypto: add uacce support to Hisilicon qm
  uacce: add user sample for uacce/warpdrive

 Documentation/warpdrive/warpdrive.rst       | 260 ++++++
 Documentation/warpdrive/wd-arch.svg         | 764 ++++++++++++++++
 Documentation/warpdrive/wd.svg              | 526 +++++++++++
 Documentation/warpdrive/wd_q_addr_space.svg | 359 ++++++++
 drivers/Kconfig                             |   2 +
 drivers/Makefile                            |   1 +
 drivers/crypto/hisilicon/Kconfig            |  19 +-
 drivers/crypto/hisilicon/Makefile           |   2 +
 drivers/crypto/hisilicon/qm.c               | 926 ++++++++++++++++++++
 drivers/crypto/hisilicon/qm.h               | 227 +++++
 drivers/crypto/hisilicon/qm_usr_if.h        |  32 +
 drivers/crypto/hisilicon/zip/Makefile       |   2 +
 drivers/crypto/hisilicon/zip/zip.h          |  57 ++
 drivers/crypto/hisilicon/zip/zip_crypto.c   | 362 ++++++++
 drivers/crypto/hisilicon/zip/zip_crypto.h   |  18 +
 drivers/crypto/hisilicon/zip/zip_main.c     | 191 ++++
 drivers/uacce/Kconfig                       |  11 +
 drivers/uacce/Makefile                      |   2 +
 drivers/uacce/uacce.c                       | 902 +++++++++++++++++++
 include/linux/uacce.h                       | 117 +++
 include/uapi/linux/uacce.h                  |  33 +
 samples/warpdrive/AUTHORS                   |   3 +
 samples/warpdrive/ChangeLog                 |   1 +
 samples/warpdrive/Makefile.am               |   9 +
 samples/warpdrive/NEWS                      |   1 +
 samples/warpdrive/README                    |  32 +
 samples/warpdrive/autogen.sh                |   3 +
 samples/warpdrive/cleanup.sh                |  13 +
 samples/warpdrive/conf.sh                   |   4 +
 samples/warpdrive/configure.ac              |  52 ++
 samples/warpdrive/drv/hisi_qm_udrv.c        | 228 +++++
 samples/warpdrive/drv/hisi_qm_udrv.h        |  57 ++
 samples/warpdrive/drv/wd_drv.h              |  19 +
 samples/warpdrive/test/Makefile.am          |   7 +
 samples/warpdrive/test/test_hisi_zip.c      | 150 ++++
 samples/warpdrive/wd.c                      |  96 ++
 samples/warpdrive/wd.h                      |  97 ++
 samples/warpdrive/wd_adapter.c              |  71 ++
 samples/warpdrive/wd_adapter.h              |  36 +
 39 files changed, 5691 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/warpdrive/warpdrive.rst
 create mode 100644 Documentation/warpdrive/wd-arch.svg
 create mode 100644 Documentation/warpdrive/wd.svg
 create mode 100644 Documentation/warpdrive/wd_q_addr_space.svg
 create mode 100644 drivers/crypto/hisilicon/qm.c
 create mode 100644 drivers/crypto/hisilicon/qm.h
 create mode 100644 drivers/crypto/hisilicon/qm_usr_if.h
 create mode 100644 drivers/crypto/hisilicon/zip/Makefile
 create mode 100644 drivers/crypto/hisilicon/zip/zip.h
 create mode 100644 drivers/crypto/hisilicon/zip/zip_crypto.c
 create mode 100644 drivers/crypto/hisilicon/zip/zip_crypto.h
 create mode 100644 drivers/crypto/hisilicon/zip/zip_main.c
 create mode 100644 drivers/uacce/Kconfig
 create mode 100644 drivers/uacce/Makefile
 create mode 100644 drivers/uacce/uacce.c
 create mode 100644 include/linux/uacce.h
 create mode 100644 include/uapi/linux/uacce.h
 create mode 100644 samples/warpdrive/AUTHORS
 create mode 100644 samples/warpdrive/ChangeLog
 create mode 100644 samples/warpdrive/Makefile.am
 create mode 100644 samples/warpdrive/NEWS
 create mode 100644 samples/warpdrive/README
 create mode 100755 samples/warpdrive/autogen.sh
 create mode 100755 samples/warpdrive/cleanup.sh
 create mode 100755 samples/warpdrive/conf.sh
 create mode 100644 samples/warpdrive/configure.ac
 create mode 100644 samples/warpdrive/drv/hisi_qm_udrv.c
 create mode 100644 samples/warpdrive/drv/hisi_qm_udrv.h
 create mode 100644 samples/warpdrive/drv/wd_drv.h
 create mode 100644 samples/warpdrive/test/Makefile.am
 create mode 100644 samples/warpdrive/test/test_hisi_zip.c
 create mode 100644 samples/warpdrive/wd.c
 create mode 100644 samples/warpdrive/wd.h
 create mode 100644 samples/warpdrive/wd_adapter.c
 create mode 100644 samples/warpdrive/wd_adapter.h

-- 
2.17.1
