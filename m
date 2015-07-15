From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH v3 0/4] crypto: qat - add RSA support to qat driver
Date: Wed, 15 Jul 2015 15:28:21 -0700
Message-ID: <20150715222821.22719.34149.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
	pingchao.yang@intel.com, davem@davemloft.net,
	tadeusz.struk@intel.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:43915 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753597AbbGOW3I (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 15 Jul 2015 18:29:08 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This series adds RSA support to the qat driver.
First patch adds the logic in FW loader to load the Modular Math Processor(MMP)
firmware to the device's internal memory.
Second patch adds logic to load MMP firmware from disk.
Third patch adds the actual RSA implementation.
It also contains minor cleanup - namely removes unused TRNG rings.
Fourth patch adds limitation for supported rsa key lengths to rsa-generic.

Once this is accepted updated version of qat_895xcc.bin firmware and the new mmp
firmware will follow.

changes in v3:
- remove sw fallback and add key size limitats to rsa generic instead.
- add rsa key parser to qat to avoid data conversion to and from MPI. This
  also removes qat dependency on rsa-generic.
- add extra space in qat_rsa_req for alignment.

changes in v2:
- add fallback to software for unsupported key lengths.
---

Pingchao Yang (1):
      crypto: qat - add support for MMP FW

Tadeusz Struk (3):
      crypto: qat - add MMP FW support to accel engine
      crypto: qat - Add support for RSA algorithm
      crypto: rsa - limit supported key lengths


 crypto/rsa.c                                       |   27 +
 drivers/crypto/qat/Kconfig                         |    2 
 drivers/crypto/qat/qat_common/.gitignore           |    1 
 drivers/crypto/qat/qat_common/Makefile             |    5 
 drivers/crypto/qat/qat_common/adf_accel_devices.h  |    3 
 drivers/crypto/qat/qat_common/adf_accel_engine.c   |   42 +
 drivers/crypto/qat/qat_common/adf_common_drv.h     |   12 
 drivers/crypto/qat/qat_common/adf_init.c           |    4 
 drivers/crypto/qat/qat_common/icp_qat_fw.h         |    2 
 drivers/crypto/qat/qat_common/icp_qat_fw_pke.h     |  112 ++++
 drivers/crypto/qat/qat_common/qat_algs.c           |    5 
 drivers/crypto/qat/qat_common/qat_asym_algs.c      |  639 ++++++++++++++++++++
 drivers/crypto/qat/qat_common/qat_crypto.c         |   19 -
 drivers/crypto/qat/qat_common/qat_crypto.h         |    2 
 drivers/crypto/qat/qat_common/qat_hal.c            |   13 
 drivers/crypto/qat/qat_common/qat_rsakey.asn1      |    5 
 drivers/crypto/qat/qat_common/qat_uclo.c           |   27 -
 .../crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c |    7 
 .../crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.h |    3 
 drivers/crypto/qat/qat_dh895xcc/adf_drv.c          |   12 
 20 files changed, 871 insertions(+), 71 deletions(-)
 create mode 100644 drivers/crypto/qat/qat_common/.gitignore
 create mode 100644 drivers/crypto/qat/qat_common/icp_qat_fw_pke.h
 create mode 100644 drivers/crypto/qat/qat_common/qat_asym_algs.c
 create mode 100644 drivers/crypto/qat/qat_common/qat_rsakey.asn1

--
