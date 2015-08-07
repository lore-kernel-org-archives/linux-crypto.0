From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH 0/5] crypto: qat - Add support for SRIOV
Date: Fri, 07 Aug 2015 11:34:14 -0700
Message-ID: <20150807183414.630.25889.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, bhelgaas@google.com,
	linux-pci@vger.kernel.org, qat-linux@intel.com,
	tadeusz.struk@intel.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:10963 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945937AbbHGSfP (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 7 Aug 2015 14:35:15 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The following series adds SRIOV support for qat dh895xcc HW accelerator.
First patch moves admin code and hw arbiter code that can be reused by PF
and VF to common code in qat/qat_common/
Second patch enables SRIOV support on dh895xcc PF.
Third patch adds dh895xcc VF specific code.
Fourth patch adds FW const table initialization,
which may be required by VFs.
Fifth patch adds pci quirk for a HW issue on VF.

---

Tadeusz Struk (5):
      crypto: qat - Move adf admin and adf hw arbitrer to common code
      crypto: qat - Add support for SRIOV
      crypto: qat - Add qat dh895xcc VF driver
      crypto: qat - Add FW const table
      PCI: Add quirk for Intel DH895xCC VF PCI config erratum


 drivers/crypto/qat/Kconfig                         |   11 +
 drivers/crypto/qat/Makefile                        |    1 
 drivers/crypto/qat/qat_common/Makefile             |    3 
 drivers/crypto/qat/qat_common/adf_accel_devices.h  |   42 ++
 drivers/crypto/qat/qat_common/adf_admin.c          |  290 ++++++++++++++
 drivers/crypto/qat/qat_common/adf_aer.c            |    3 
 drivers/crypto/qat/qat_common/adf_cfg.c            |    3 
 drivers/crypto/qat/qat_common/adf_cfg_common.h     |    3 
 drivers/crypto/qat/qat_common/adf_common_drv.h     |   44 ++
 drivers/crypto/qat/qat_common/adf_ctl_drv.c        |    6 
 drivers/crypto/qat/qat_common/adf_dev_mgr.c        |  283 +++++++++++++-
 drivers/crypto/qat/qat_common/adf_hw_arbiter.c     |  168 ++++++++
 drivers/crypto/qat/qat_common/adf_init.c           |   94 +----
 drivers/crypto/qat/qat_common/adf_pf2vf_msg.c      |  336 +++++++++++++++++
 drivers/crypto/qat/qat_common/adf_pf2vf_msg.h      |  144 +++++++
 drivers/crypto/qat/qat_common/adf_sriov.c          |  406 ++++++++++++++++++++
 drivers/crypto/qat/qat_common/adf_transport.c      |    7 
 drivers/crypto/qat/qat_common/qat_crypto.c         |    7 
 drivers/crypto/qat/qat_dh895xcc/Makefile           |    5 
 drivers/crypto/qat/qat_dh895xcc/adf_admin.c        |  145 -------
 .../crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c |   30 +
 .../crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.h |    9 
 drivers/crypto/qat/qat_dh895xcc/adf_drv.c          |   83 ++--
 drivers/crypto/qat/qat_dh895xcc/adf_drv.h          |    9 
 drivers/crypto/qat/qat_dh895xcc/adf_hw_arbiter.c   |  159 --------
 drivers/crypto/qat/qat_dh895xcc/adf_isr.c          |  139 +++++--
 drivers/crypto/qat/qat_dh895xcc/qat_admin.c        |  107 -----
 drivers/crypto/qat/qat_dh895xccvf/Makefile         |    5 
 .../qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c    |  172 ++++++++
 .../qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.h    |   68 +++
 drivers/crypto/qat/qat_dh895xccvf/adf_drv.c        |  393 +++++++++++++++++++
 drivers/crypto/qat/qat_dh895xccvf/adf_drv.h        |   57 +++
 drivers/crypto/qat/qat_dh895xccvf/adf_isr.c        |  258 +++++++++++++
 drivers/pci/quirks.c                               |   85 ++++
 34 files changed, 2959 insertions(+), 616 deletions(-)
 create mode 100644 drivers/crypto/qat/qat_common/adf_admin.c
 create mode 100644 drivers/crypto/qat/qat_common/adf_hw_arbiter.c
 create mode 100644 drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
 create mode 100644 drivers/crypto/qat/qat_common/adf_pf2vf_msg.h
 create mode 100644 drivers/crypto/qat/qat_common/adf_sriov.c
 delete mode 100644 drivers/crypto/qat/qat_dh895xcc/adf_admin.c
 delete mode 100644 drivers/crypto/qat/qat_dh895xcc/adf_hw_arbiter.c
 delete mode 100644 drivers/crypto/qat/qat_dh895xcc/qat_admin.c
 create mode 100644 drivers/crypto/qat/qat_dh895xccvf/Makefile
 create mode 100644 drivers/crypto/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c
 create mode 100644 drivers/crypto/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.h
 create mode 100644 drivers/crypto/qat/qat_dh895xccvf/adf_drv.c
 create mode 100644 drivers/crypto/qat/qat_dh895xccvf/adf_drv.h
 create mode 100644 drivers/crypto/qat/qat_dh895xccvf/adf_isr.c

--
