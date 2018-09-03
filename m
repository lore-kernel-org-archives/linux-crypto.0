From: Kenneth Lee <nek.in.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [RFCv2 PATCH 0/7] A General Accelerator Framework, WarpDrive
Date: Mon,  3 Sep 2018 08:51:57 +0800
Message-ID: <20180903005204.26041-1-nek.in.cn@gmail.com>
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

WarpDrive is an accelerator framework to expose the hardware capabilities
directly to the user space. It makes use of the exist vfio and vfio-mdev
facilities. So the user application can send request and DMA to the
hardware without interaction with the kernel. This removes the latency
of syscall.

WarpDrive is the name for the whole framework. The component in kernel
is called SDMDEV, Share Domain Mediated Device. Driver driver exposes its
hardware resource by registering to SDMDEV as a VFIO-Mdev. So the user
library of WarpDrive can access it via VFIO interface.

The patchset contains document for the detail. Please refer to it for more
information.

This patchset is intended to be used with Jean Philippe Brucker's SVA
patch [1], which enables not only IO side page fault, but also PASID
support to IOMMU and VFIO.

With these features, WarpDrive can support non-pinned memory and
multi-process in the same accelerator device.  We tested it in our SoC
integrated Accelerator (board ID: D06, Chip ID: HIP08). A reference work
tree can be found here: [2].

But it is not mandatory. This patchset is tested in the latest mainline
kernel without the SVA patches.  So it supports only one process for each
accelerator.

We have noticed the IOMMU aware mdev RFC announced recently [3].

The IOMMU aware mdev has similar idea but different intention comparing to
WarpDrive. It intends to dedicate part of the hardware resource to a VM.
And the design is supposed to be used with Scalable I/O Virtualization.
While sdmdev is intended to share the hardware resource with a big amount
of processes.  It just requires the hardware supporting address
translation per process (PCIE's PASID or ARM SMMU's substream ID).

But we don't see serious confliction on both design. We believe they can be
normalized as one.

The patch 1 is document of the framework. The patch 2 and 3 add sdmdev
support. The patch 4, 5 and 6 is drivers for Hislicon's ZIP Accelerator
which is registered to both crypto and warpdrive(sdmdev) and can be
used from kernel or user space at the same time. The patch 7 is a user
space sample demonstrating how WarpDrive works.


Change History:
V2 changed from V1:
	1. Change kernel framework name from SPIMDEV (Share Parent IOMMU
	   Mdev) to SDMDEV (Share Domain Mdev).
	2. Allocate Hardware Resource when a new mdev is created (While
	   it is allocated when the mdev is openned)
	3. Unmap pages from the shared domain when the sdmdev iommu group is
	   detached. (This procedure is necessary, but missed in V1)
	4. Update document accordingly.
	5. Rebase to the latest kernel (4.19.0-rc1)
	
	According the review comment on RFCv1, We did try to use dma-buf
	as back end of WarpDrive. It can work properly with the current
	solution [4], but it cannot make use of process's
	own memory address space directly. This is important to many
	acceleration scenario. So dma-buf will be taken as a backup
	alternative for noiommu scenario, it will be added in the future
	version. 


Refernces:
[1] https://www.spinics.net/lists/kernel/msg2651481.html
[2] https://github.com/Kenneth-Lee/linux-kernel-warpdrive/tree/warpdrive-sva-v0.5
[3] https://lkml.org/lkml/2018/7/22/34
[4] https://github.com/Kenneth-Lee/linux-kernel-warpdrive/tree/warpdrive-v0.7-dmabuf

Best Regards
Kenneth Lee

Kenneth Lee (7):
  vfio/sdmdev: Add documents for WarpDrive framework
  iommu: Add share domain interface in iommu for sdmdev
  vfio: add sdmdev support
  crypto: add hisilicon Queue Manager driver
  crypto: Add Hisilicon Zip driver
  crypto: add sdmdev support to Hisilicon QM
  vfio/sdmdev: add user sample

 Documentation/00-INDEX                    |   2 +
 Documentation/warpdrive/warpdrive.rst     | 100 +++
 Documentation/warpdrive/wd-arch.svg       | 728 ++++++++++++++++
 drivers/crypto/Makefile                   |   2 +-
 drivers/crypto/hisilicon/Kconfig          |  25 +
 drivers/crypto/hisilicon/Makefile         |   2 +
 drivers/crypto/hisilicon/qm.c             | 979 ++++++++++++++++++++++
 drivers/crypto/hisilicon/qm.h             | 122 +++
 drivers/crypto/hisilicon/zip/Makefile     |   2 +
 drivers/crypto/hisilicon/zip/zip.h        |  57 ++
 drivers/crypto/hisilicon/zip/zip_crypto.c | 353 ++++++++
 drivers/crypto/hisilicon/zip/zip_crypto.h |   8 +
 drivers/crypto/hisilicon/zip/zip_main.c   | 195 +++++
 drivers/iommu/iommu.c                     |  29 +-
 drivers/vfio/Kconfig                      |   1 +
 drivers/vfio/Makefile                     |   1 +
 drivers/vfio/sdmdev/Kconfig               |  10 +
 drivers/vfio/sdmdev/Makefile              |   3 +
 drivers/vfio/sdmdev/vfio_sdmdev.c         | 363 ++++++++
 drivers/vfio/vfio_iommu_type1.c           | 151 +++-
 include/linux/iommu.h                     |  15 +
 include/linux/vfio_sdmdev.h               |  96 +++
 include/uapi/linux/vfio_sdmdev.h          |  29 +
 samples/warpdrive/AUTHORS                 |   2 +
 samples/warpdrive/ChangeLog               |   1 +
 samples/warpdrive/Makefile.am             |   9 +
 samples/warpdrive/NEWS                    |   1 +
 samples/warpdrive/README                  |  32 +
 samples/warpdrive/autogen.sh              |   3 +
 samples/warpdrive/cleanup.sh              |  13 +
 samples/warpdrive/configure.ac            |  52 ++
 samples/warpdrive/drv/hisi_qm_udrv.c      | 223 +++++
 samples/warpdrive/drv/hisi_qm_udrv.h      |  53 ++
 samples/warpdrive/test/Makefile.am        |   7 +
 samples/warpdrive/test/comp_hw.h          |  23 +
 samples/warpdrive/test/test_hisi_zip.c    | 206 +++++
 samples/warpdrive/wd.c                    | 309 +++++++
 samples/warpdrive/wd.h                    | 154 ++++
 samples/warpdrive/wd_adapter.c            |  74 ++
 samples/warpdrive/wd_adapter.h            |  43 +
 40 files changed, 4470 insertions(+), 8 deletions(-)
 create mode 100644 Documentation/warpdrive/warpdrive.rst
 create mode 100644 Documentation/warpdrive/wd-arch.svg
 create mode 100644 drivers/crypto/hisilicon/qm.c
 create mode 100644 drivers/crypto/hisilicon/qm.h
 create mode 100644 drivers/crypto/hisilicon/zip/Makefile
 create mode 100644 drivers/crypto/hisilicon/zip/zip.h
 create mode 100644 drivers/crypto/hisilicon/zip/zip_crypto.c
 create mode 100644 drivers/crypto/hisilicon/zip/zip_crypto.h
 create mode 100644 drivers/crypto/hisilicon/zip/zip_main.c
 create mode 100644 drivers/vfio/sdmdev/Kconfig
 create mode 100644 drivers/vfio/sdmdev/Makefile
 create mode 100644 drivers/vfio/sdmdev/vfio_sdmdev.c
 create mode 100644 include/linux/vfio_sdmdev.h
 create mode 100644 include/uapi/linux/vfio_sdmdev.h
 create mode 100644 samples/warpdrive/AUTHORS
 create mode 100644 samples/warpdrive/ChangeLog
 create mode 100644 samples/warpdrive/Makefile.am
 create mode 100644 samples/warpdrive/NEWS
 create mode 100644 samples/warpdrive/README
 create mode 100755 samples/warpdrive/autogen.sh
 create mode 100755 samples/warpdrive/cleanup.sh
 create mode 100644 samples/warpdrive/configure.ac
 create mode 100644 samples/warpdrive/drv/hisi_qm_udrv.c
 create mode 100644 samples/warpdrive/drv/hisi_qm_udrv.h
 create mode 100644 samples/warpdrive/test/Makefile.am
 create mode 100644 samples/warpdrive/test/comp_hw.h
 create mode 100644 samples/warpdrive/test/test_hisi_zip.c
 create mode 100644 samples/warpdrive/wd.c
 create mode 100644 samples/warpdrive/wd.h
 create mode 100644 samples/warpdrive/wd_adapter.c
 create mode 100644 samples/warpdrive/wd_adapter.h

-- 
2.17.1
