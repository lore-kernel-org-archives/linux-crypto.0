From: Stanimir Varbanov <svarbanov-NEYub+7Iv8PQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v4 0/3] Add Qualcomm crypto driver
Date: Wed, 25 Jun 2014 19:28:56 +0300
Message-ID: <1403713739-3074-1-git-send-email-svarbanov@mm-sol.com>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-arm-msm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Stanimir Varbanov <svarbanov-NEYub+7Iv8PQT0dZR+AlfA@public.gmane.org>
To: Rob Herring <rob.herring-bsGFqQB8/DxBDgjK7y7TUQ@public.gmane.org>,
	Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>,
	Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>,
	Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>,
	Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>,
	Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
	"David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
	Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
	Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

Here is v4 of the patchset.

Changes since v3:
- Fixed trivial typo related to unnecessary semicolon.

regards,
Stan

---------------------------------------------------------------------
Here is the third version of the crypto driver.

Changes since v2:

 - reworked crypto_enqueue/dequeue_request mechanism. The queue
   length has been changed to one to reflect the hardware
   capabilities
 - the workqueue has been deleted and replaced by new queue function
 - few not functional changes like making some variables const
 - fixed one issue in SG helper related to SG table manipulation
 - added fallback for algorithms/modes unsupported by the hardware
 - patches 1 to 6 are squashed in one i.e 1/3
 - patches 7 and 8 are squashed in one i.e 2/3

---------------------------------------------------------------------
Here is the second version of the patch set. This time tagged
as an RFC to avoid confusions. The driver is splitted by files
and is buildable at the last patch. When the review has finished
1/9 to 7/9 could be squashed in one patch.

Any comments appreciated!

Changes since v1:

core
 - added MODULE_DEVICE_TABLE
 - reorganise includes
 - kernel doc comments
 - fix probe error path, forgot to destroy workqueue
 - rework clocks and kill loops for enabling
 - restructure the interfaces between core part of the driver
   and crypto type algorithms. Now struct qce_algo_ops has
   .unregister_algs operation and it is implemented by every
   algorithm type (unregister_algs was common in v1).
   Also async_req_queue/done are now part of core structure
   qce_device

regs-v5
 - use GENMASK and include bitops.h

dma-sg helpers
 - do not check !IS_ERR on error path
 - various fixes as per review comments
 - reorganise includes
 - return error on qce_dma_terminate_all

ablkcipher
 - use queue and done callbacks from struct qce_device
 - reorganise includes
 - kernel doc notation

sha-hmac
 - use queue and done callbacks from struct qce_device
 - make byte_count __be32
 - kernel doc notation
 - make rctx flags member unsigned long
 - cleanup qce_ahash_update function
 - make const * input args of qce_import_common

common
 - rename bits/masks to use _SHIFT suffix
 - reorganise includes and add qce_get_version function
 - make rctx flags unsigned long
 - move blocksize boundary check on function begging and
   clear BYTECOUNT registers on first processing block

This driver is based on Codeaurora's driver found at [1]

[1] https://www.codeaurora.org/cgit/quic/la/kernel/msm-3.10/tree/drivers/crypto/msm?h=msm-3.10

Stanimir Varbanov (3):
  crypto: qce: Qualcomm crypto engine driver
  crypto: qce: Build Qualcomm crypto driver
  ARM: DT: qcom: Add Qualcomm crypto driver binding document

 .../devicetree/bindings/crypto/qcom-qce.txt        |   25 +
 drivers/crypto/Kconfig                             |   15 +
 drivers/crypto/Makefile                            |    1 +
 drivers/crypto/qce/Makefile                        |    6 +
 drivers/crypto/qce/ablkcipher.c                    |  431 ++++++++++++++
 drivers/crypto/qce/cipher.h                        |   68 +++
 drivers/crypto/qce/common.c                        |  435 +++++++++++++++
 drivers/crypto/qce/common.h                        |  102 ++++
 drivers/crypto/qce/core.c                          |  286 ++++++++++
 drivers/crypto/qce/core.h                          |   68 +++
 drivers/crypto/qce/dma.c                           |  186 ++++++
 drivers/crypto/qce/dma.h                           |   58 ++
 drivers/crypto/qce/regs-v5.h                       |  334 +++++++++++
 drivers/crypto/qce/sha.c                           |  588 ++++++++++++++++++++
 drivers/crypto/qce/sha.h                           |   81 +++
 15 files changed, 2684 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/crypto/qcom-qce.txt
 create mode 100644 drivers/crypto/qce/Makefile
 create mode 100644 drivers/crypto/qce/ablkcipher.c
 create mode 100644 drivers/crypto/qce/cipher.h
 create mode 100644 drivers/crypto/qce/common.c
 create mode 100644 drivers/crypto/qce/common.h
 create mode 100644 drivers/crypto/qce/core.c
 create mode 100644 drivers/crypto/qce/core.h
 create mode 100644 drivers/crypto/qce/dma.c
 create mode 100644 drivers/crypto/qce/dma.h
 create mode 100644 drivers/crypto/qce/regs-v5.h
 create mode 100644 drivers/crypto/qce/sha.c
 create mode 100644 drivers/crypto/qce/sha.h

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
