From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH 00/10] crypto: qat: Checkpatch and other cleanups plus SKU1
Date: Fri, 25 Jul 2014 15:55:03 -0700
Message-ID: <20140725225410.24909.56360.stgit@gitlad.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <tadeusz.struk@intel.com>, <davem@davemloft.net>,
	<bruce.w.allan@intel.com>, <bo.cui@intel.com>,
	<pingchao.yang@intel.com>, <qat-linux@intel.com>,
	<linux-crypto@vger.kernel.org>
To: <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:21581 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751137AbaGYWzG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 25 Jul 2014 18:55:06 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

issue.

Hi,
Minor cleanups for the qat driver.
The last patch fixes SKU1 device startup issue.
Rest of the patches clean up new checkpatch issues plus some minor
and cosmetic updates.
---

Tadeusz Struk (10):
      crypto: qat: Fixed SKU1 dev issue
      crypto: qat: Cleanup - Use hweight for bit counting
      crypto: qat: Cleanup - Updated print outputs
      crypto: qat: Cleanup - change ae_num to ae_id
      crypto: qat: Cleanup - change slice->regions to slice->region
      crypto: qat: Cleanup - use min_t macro
      crypto: qat: Cleanup - remove unnecessary parentheses
      crypto: qat: Cleanup - remove unneeded header
      crypto: qat: Cleanup - checkpatch blank lines
      crypto: qat: Cleanup - remove unnecessary return codes


 drivers/crypto/qat/qat_common/adf_accel_engine.c   |    4 
 drivers/crypto/qat/qat_common/adf_cfg.c            |    1 
 drivers/crypto/qat/qat_common/adf_init.c           |    2 
 .../crypto/qat/qat_common/adf_transport_internal.h |    3 
 drivers/crypto/qat/qat_common/icp_qat_fw_la.h      |    1 
 drivers/crypto/qat/qat_common/icp_qat_hw.h         |    6 -
 drivers/crypto/qat/qat_common/icp_qat_uclo.h       |    2 
 drivers/crypto/qat/qat_common/qat_algs.c           |    2 
 drivers/crypto/qat/qat_common/qat_hal.c            |   44 ++---
 drivers/crypto/qat/qat_common/qat_uclo.c           |  180 +++++++++-----------
 .../crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.h |    2 
 11 files changed, 112 insertions(+), 135 deletions(-)

-- 
