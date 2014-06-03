From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [RFC][PATCH 0/4 v2] crypto: Add support for Intel(R) QuickAssist
	Technology (QAT)
Date: Tue, 3 Jun 2014 15:13:10 -0700
Message-ID: <20140603221310.GA6137@gitlad.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tadeusz.struk@intel.com, john.griffin@intel.com,
	bruce.w.allan@intel.com, karen.xiang@intel.com,
	pingchaox.yang@intel.com, bo.cui@intel.com, davem@davemloft.net,
	qat-linux@intel.com, linux-crypto@vger.kernel.org
To: tadeusz.struk@intel.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:22471 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965576AbaFCWNN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 3 Jun 2014 18:13:13 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,
This patchset adds support for Intel(R) QuickAssist Technology (QAT) and DH895xCC hardware accelerator.
First patch adds a common infractructure that will be used by all QAT devices.
Second patch adds a firmware loader module that is used to load the microcode to the acceleration engines and start them.
Third patch adds dh895xcc hardware specific code, which hooks to the common infrastructure and provides acceleration for
the following algorithms:
authenc(hmac(sha1),cbc(aes)), authenc(hmac(sha256),cbc(aes)), authenc(hmac(sha512),cbc(aes))
Forth patch updates makefiles etc.

More info on the hardware accelerator and the Quick Assist Technology can be found on:
https://01.org/packet-processing/intel%C2%AE-quickassist-technology-drivers-and-patches

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
Signed-off-by: Karen Xiang <karen.xiang@intel.com>
Signed-off-by: Pingchaox Yang <pingchaox.yang@intel.com>
Acked-by: John Griffin <john.griffin@intel.com>
Acked-by: Bo Cui <bo.cui@intel.com>
Reviewed-by: Bruce W. Allan <bruce.w.allan@intel.com>
---
 drivers/crypto/Kconfig                                      |    1 +
 drivers/crypto/Makefile                                     |    1 +
 drivers/crypto/qat/qat_common/Makefile                      |   13 +
 drivers/crypto/qat/qat_common/adf_accel_devices.h           |  204 +++++++++++++++
 drivers/crypto/qat/qat_common/adf_accel_engine.c            |  168 ++++++++++++
 drivers/crypto/qat/qat_common/adf_aer.c                     |  258 +++++++++++++++++++
 drivers/crypto/qat/qat_common/adf_cfg.c                     |  359 ++++++++++++++++++++++++++
 drivers/crypto/qat/qat_common/adf_cfg.h                     |   87 +++++++
 drivers/crypto/qat/qat_common/adf_cfg_common.h              |  100 ++++++++
 drivers/crypto/qat/qat_common/adf_cfg_strings.h             |   83 ++++++
 drivers/crypto/qat/qat_common/adf_cfg_user.h                |   94 +++++++
 drivers/crypto/qat/qat_common/adf_common_drv.h              |  192 ++++++++++++++
 drivers/crypto/qat/qat_common/adf_ctl_drv.c                 |  490 +++++++++++++++++++++++++++++++++++
 drivers/crypto/qat/qat_common/adf_dev_mgr.c                 |  215 ++++++++++++++++
 drivers/crypto/qat/qat_common/adf_init.c                    |  388 ++++++++++++++++++++++++++++
 drivers/crypto/qat/qat_common/adf_transport.c               |  565 +++++++++++++++++++++++++++++++++++++++++
 drivers/crypto/qat/qat_common/adf_transport.h               |   63 +++++
 drivers/crypto/qat/qat_common/adf_transport_access_macros.h |  160 ++++++++++++
 drivers/crypto/qat/qat_common/adf_transport_debug.c         |  301 ++++++++++++++++++++++
 drivers/crypto/qat/qat_common/adf_transport_internal.h      |  115 +++++++++
 drivers/crypto/qat/qat_common/icp_qat_fw.h                  |  316 +++++++++++++++++++++++
 drivers/crypto/qat/qat_common/icp_qat_fw_init_admin.h       |  131 ++++++++++
 drivers/crypto/qat/qat_common/icp_qat_fw_la.h               |  403 +++++++++++++++++++++++++++++
 drivers/crypto/qat/qat_common/icp_qat_fw_loader_handle.h    |   78 ++++++
 drivers/crypto/qat/qat_common/icp_qat_hal.h                 |  125 +++++++++
 drivers/crypto/qat/qat_common/icp_qat_hw.h                  |  305 ++++++++++++++++++++++
 drivers/crypto/qat/qat_common/icp_qat_uclo.h                |  377 +++++++++++++++++++++++++++
 drivers/crypto/qat/qat_common/qat_algs.c                    | 1033 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/crypto/qat/qat_common/qat_crypto.c                  |  284 +++++++++++++++++++++
 drivers/crypto/qat/qat_common/qat_crypto.h                  |   83 ++++++
 drivers/crypto/qat/qat_common/qat_hal.c                     | 1402 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/crypto/qat/qat_common/qat_uclo.c                    | 1191 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/crypto/qat/qat_dh895xcc/Makefile                    |    8 +
 drivers/crypto/qat/qat_dh895xcc/adf_admin.c                 |  144 +++++++++++
 drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c      |  214 ++++++++++++++++
 drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.h      |   86 +++++++
 drivers/crypto/qat/qat_dh895xcc/adf_drv.c                   |  448 ++++++++++++++++++++++++++++++++
 drivers/crypto/qat/qat_dh895xcc/adf_drv.h                   |   67 +++++
 drivers/crypto/qat/qat_dh895xcc/adf_hw_arbiter.c            |  159 ++++++++++++
 drivers/crypto/qat/qat_dh895xcc/adf_isr.c                   |  266 +++++++++++++++++++
 drivers/crypto/qat/qat_dh895xcc/qat_admin.c                 |  107 ++++++++
 firmware/Makefile                                           |    1 +
 44 files changed, 11092 insertions(+)
 create mode 100644 drivers/crypto/qat/qat_common/Makefile
 create mode 100644 drivers/crypto/qat/qat_common/adf_accel_devices.h
 create mode 100644 drivers/crypto/qat/qat_common/adf_accel_engine.c
 create mode 100644 drivers/crypto/qat/qat_common/adf_aer.c
 create mode 100644 drivers/crypto/qat/qat_common/adf_cfg.c
 create mode 100644 drivers/crypto/qat/qat_common/adf_cfg.h
 create mode 100644 drivers/crypto/qat/qat_common/adf_cfg_common.h
 create mode 100644 drivers/crypto/qat/qat_common/adf_cfg_strings.h
 create mode 100644 drivers/crypto/qat/qat_common/adf_cfg_user.h
 create mode 100644 drivers/crypto/qat/qat_common/adf_common_drv.h
 create mode 100644 drivers/crypto/qat/qat_common/adf_ctl_drv.c
 create mode 100644 drivers/crypto/qat/qat_common/adf_dev_mgr.c
 create mode 100644 drivers/crypto/qat/qat_common/adf_init.c
 create mode 100644 drivers/crypto/qat/qat_common/adf_transport.c
 create mode 100644 drivers/crypto/qat/qat_common/adf_transport.h
 create mode 100644 drivers/crypto/qat/qat_common/adf_transport_access_macros.h
 create mode 100644 drivers/crypto/qat/qat_common/adf_transport_debug.c
 create mode 100644 drivers/crypto/qat/qat_common/adf_transport_internal.h
 create mode 100644 drivers/crypto/qat/qat_common/icp_qat_fw.h
 create mode 100644 drivers/crypto/qat/qat_common/icp_qat_fw_init_admin.h
 create mode 100644 drivers/crypto/qat/qat_common/icp_qat_fw_la.h
 create mode 100644 drivers/crypto/qat/qat_common/icp_qat_fw_loader_handle.h
 create mode 100644 drivers/crypto/qat/qat_common/icp_qat_hal.h
 create mode 100644 drivers/crypto/qat/qat_common/icp_qat_hw.h
 create mode 100644 drivers/crypto/qat/qat_common/icp_qat_uclo.h
 create mode 100644 drivers/crypto/qat/qat_common/qat_algs.c
 create mode 100644 drivers/crypto/qat/qat_common/qat_crypto.c
 create mode 100644 drivers/crypto/qat/qat_common/qat_crypto.h
 create mode 100644 drivers/crypto/qat/qat_common/qat_hal.c
 create mode 100644 drivers/crypto/qat/qat_common/qat_uclo.c
 create mode 100644 drivers/crypto/qat/qat_dh895xcc/Makefile
 create mode 100644 drivers/crypto/qat/qat_dh895xcc/adf_admin.c
 create mode 100644 drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
 create mode 100644 drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.h
 create mode 100644 drivers/crypto/qat/qat_dh895xcc/adf_drv.c
 create mode 100644 drivers/crypto/qat/qat_dh895xcc/adf_drv.h
 create mode 100644 drivers/crypto/qat/qat_dh895xcc/adf_hw_arbiter.c
 create mode 100644 drivers/crypto/qat/qat_dh895xcc/adf_isr.c
 create mode 100644 drivers/crypto/qat/qat_dh895xcc/qat_admin.c
