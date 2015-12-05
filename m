From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH 0/7] Add support for qat_c3xxx and qat_c62x devices
Date: Fri, 04 Dec 2015 16:56:12 -0800
Message-ID: <20151205005612.27411.60451.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, pingchao.yang@intel.com,
	qat-linux@intel.com, tadeusz.struk@intel.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:37390 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755091AbbLEA7W (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 4 Dec 2015 19:59:22 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The following series adds support for the new
qat_c3xxx and qat_c62x acceleration devices.

---
Pingchao Yang (1):
      crypto: qat - add support for new devices to FW loader

Tadeusz Struk (6):
      crypto: qat - add new device definitions
      crypto: qat - move isr files to qat common so that they can be reused
      crypto: qat - add support for c3xxx accel type
      crypto: qat - add support for c62x accel type
      crypto: qat - add support for c3xxxvf accel type
      crypto: qat - add support for c62xvf accel type

 drivers/crypto/qat/Kconfig                         |   44 ++
 drivers/crypto/qat/Makefile                        |    4 
 drivers/crypto/qat/qat_c3xxx/Makefile              |    3 
 drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c   |  248 +++++++++
 drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.h   |   84 +++
 drivers/crypto/qat/qat_c3xxx/adf_drv.c             |  335 ++++++++++++
 drivers/crypto/qat/qat_c3xxxvf/Makefile            |    3 
 .../crypto/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c   |  173 ++++++
 .../crypto/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.h   |   64 ++
 drivers/crypto/qat/qat_c3xxxvf/adf_drv.c           |  305 +++++++++++
 drivers/crypto/qat/qat_c62x/Makefile               |    3 
 drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.c     |  248 +++++++++
 drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.h     |   84 +++
 drivers/crypto/qat/qat_c62x/adf_drv.c              |  335 ++++++++++++
 drivers/crypto/qat/qat_c62xvf/Makefile             |    3 
 drivers/crypto/qat/qat_c62xvf/adf_c62xvf_hw_data.c |  173 ++++++
 drivers/crypto/qat/qat_c62xvf/adf_c62xvf_hw_data.h |   64 ++
 drivers/crypto/qat/qat_c62xvf/adf_drv.c            |  305 +++++++++++
 drivers/crypto/qat/qat_common/Makefile             |    2 
 drivers/crypto/qat/qat_common/adf_accel_devices.h  |   14 -
 drivers/crypto/qat/qat_common/adf_accel_engine.c   |    9 
 drivers/crypto/qat/qat_common/adf_admin.c          |    3 
 drivers/crypto/qat/qat_common/adf_aer.c            |    2 
 drivers/crypto/qat/qat_common/adf_cfg_common.h     |    4 
 drivers/crypto/qat/qat_common/adf_common_drv.h     |   19 +
 drivers/crypto/qat/qat_common/adf_ctl_drv.c        |    8 
 drivers/crypto/qat/qat_common/adf_dev_mgr.c        |   36 +
 drivers/crypto/qat/qat_common/adf_init.c           |   21 -
 drivers/crypto/qat/qat_common/adf_isr.c            |  348 +++++++++++++
 drivers/crypto/qat/qat_common/adf_pf2vf_msg.c      |   23 -
 drivers/crypto/qat/qat_common/adf_transport.c      |   20 -
 .../crypto/qat/qat_common/adf_transport_internal.h |    2 
 drivers/crypto/qat/qat_common/adf_vf_isr.c         |  280 ++++++++++
 .../qat/qat_common/icp_qat_fw_loader_handle.h      |   10 
 drivers/crypto/qat/qat_common/icp_qat_hal.h        |   37 +
 drivers/crypto/qat/qat_common/icp_qat_uclo.h       |  165 ++++++
 drivers/crypto/qat/qat_common/qat_crypto.c         |   92 +++
 drivers/crypto/qat/qat_common/qat_hal.c            |  122 +++-
 drivers/crypto/qat/qat_common/qat_uclo.c           |  555 +++++++++++++++++++-
 drivers/crypto/qat/qat_dh895xcc/Makefile           |    4 
 .../crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c |    5 
 .../crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.h |    7 
 drivers/crypto/qat/qat_dh895xcc/adf_drv.c          |   95 ---
 drivers/crypto/qat/qat_dh895xcc/adf_drv.h          |   58 --
 drivers/crypto/qat/qat_dh895xcc/adf_isr.c          |  332 ------------
 drivers/crypto/qat/qat_dh895xccvf/Makefile         |    4 
 .../qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c    |    5 
 .../qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.h    |   10 
 drivers/crypto/qat/qat_dh895xccvf/adf_drv.c        |   87 ---
 drivers/crypto/qat/qat_dh895xccvf/adf_drv.h        |   57 --
 drivers/crypto/qat/qat_dh895xccvf/adf_isr.c        |  258 ---------
 51 files changed, 4112 insertions(+), 1060 deletions(-)
 create mode 100644 drivers/crypto/qat/qat_c3xxx/Makefile
 create mode 100644 drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c
 create mode 100644 drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.h
 create mode 100644 drivers/crypto/qat/qat_c3xxx/adf_drv.c
 create mode 100644 drivers/crypto/qat/qat_c3xxxvf/Makefile
 create mode 100644 drivers/crypto/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c
 create mode 100644 drivers/crypto/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.h
 create mode 100644 drivers/crypto/qat/qat_c3xxxvf/adf_drv.c
 create mode 100644 drivers/crypto/qat/qat_c62x/Makefile
 create mode 100644 drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.c
 create mode 100644 drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.h
 create mode 100644 drivers/crypto/qat/qat_c62x/adf_drv.c
 create mode 100644 drivers/crypto/qat/qat_c62xvf/Makefile
 create mode 100644 drivers/crypto/qat/qat_c62xvf/adf_c62xvf_hw_data.c
 create mode 100644 drivers/crypto/qat/qat_c62xvf/adf_c62xvf_hw_data.h
 create mode 100644 drivers/crypto/qat/qat_c62xvf/adf_drv.c
 create mode 100644 drivers/crypto/qat/qat_common/adf_isr.c
 create mode 100644 drivers/crypto/qat/qat_common/adf_vf_isr.c
 delete mode 100644 drivers/crypto/qat/qat_dh895xcc/adf_drv.h
 delete mode 100644 drivers/crypto/qat/qat_dh895xcc/adf_isr.c
 delete mode 100644 drivers/crypto/qat/qat_dh895xccvf/adf_drv.h
 delete mode 100644 drivers/crypto/qat/qat_dh895xccvf/adf_isr.c

--
