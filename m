From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH 0/3] crypto: qat - add RSA support to qat driver
Date: Fri, 10 Jul 2015 10:06:16 -0700
Message-ID: <20150710170616.4483.44445.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
	pingchao.yang@intel.com, davem@davemloft.net,
	tadeusz.struk@intel.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:58854 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932123AbbGJRGt (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 10 Jul 2015 13:06:49 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This series adds RSA support to the qat driver.
First patch adds the logic in FW loader to load the Modular Math Processor(MMP)
firmware to the device's internal memory.
Second patch adds logic to load MMP firmware from disk.
Third patch adds the actual RSA implementation.
It also contains minor cleanup - namely removes unused TRNG rings.

Once this is accepted a version of qat_895xcc.bin firmware and the new mmp
firmware will follow.
---

Pingchao Yang (1):
      crypto: qat - add support for MMP FW

Tadeusz Struk (2):
      crypto: qat - add MMP FW support to accel engine
      crypto: qat - Add support for RSA algorithm


 drivers/crypto/qat/Kconfig                         |    2 
 drivers/crypto/qat/qat_common/Makefile             |    1 
 drivers/crypto/qat/qat_common/adf_accel_devices.h  |    3 
 drivers/crypto/qat/qat_common/adf_accel_engine.c   |   42 +
 drivers/crypto/qat/qat_common/adf_common_drv.h     |   10 
 drivers/crypto/qat/qat_common/adf_init.c           |    4 
 drivers/crypto/qat/qat_common/icp_qat_fw.h         |    2 
 drivers/crypto/qat/qat_common/icp_qat_fw_pke.h     |  112 ++++
 drivers/crypto/qat/qat_common/qat_algs.c           |    5 
 drivers/crypto/qat/qat_common/qat_asym_algs.c      |  583 ++++++++++++++++++++
 drivers/crypto/qat/qat_common/qat_crypto.c         |   19 -
 drivers/crypto/qat/qat_common/qat_crypto.h         |    2 
 drivers/crypto/qat/qat_common/qat_hal.c            |   13 
 drivers/crypto/qat/qat_common/qat_uclo.c           |   27 -
 .../crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c |    7 
 .../crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.h |    2 
 drivers/crypto/qat/qat_dh895xcc/adf_drv.c          |   12 
 17 files changed, 777 insertions(+), 69 deletions(-)
 create mode 100644 drivers/crypto/qat/qat_common/icp_qat_fw_pke.h
 create mode 100644 drivers/crypto/qat/qat_common/qat_asym_algs.c

--
