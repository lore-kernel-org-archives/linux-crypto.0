From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH 0/4] crypto: qat: Minor Fixes
Date: Tue, 24 Jun 2014 15:19:18 -0700
Message-ID: <20140624221833.3872.65930.stgit@tstruk-mobl1.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: davem@davemloft.net, bruce.w.allan@intel.com,
	linux-crypto@vger.kernel.org, qat-linux@intel.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:27913 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751206AbaFXWWR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 24 Jun 2014 18:22:17 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The following series fixes minor format issues, updates FW info, and fixes
error path crash when no firmware is present.
---

Tadeusz Struk (4):
      crypto: qat: Fix random config build warnings
      crypto: qat: Updated Firmware Info Metadata
      crypto: qat: Fixed new checkpatch warnings
      crypto: qat: Fix error path crash when no firmware is present


 drivers/crypto/qat/Kconfig                         |    1 +
 drivers/crypto/qat/qat_common/adf_accel_devices.h  |    1 +
 drivers/crypto/qat/qat_common/adf_aer.c            |    1 +
 drivers/crypto/qat/qat_common/adf_cfg.c            |    3 ++
 drivers/crypto/qat/qat_common/adf_common_drv.h     |    2 +-
 drivers/crypto/qat/qat_common/adf_transport.c      |    2 ++
 .../crypto/qat/qat_common/adf_transport_debug.c    |    3 ++
 drivers/crypto/qat/qat_common/qat_algs.c           |   10 ++++++--
 drivers/crypto/qat/qat_common/qat_crypto.c         |    4 ++-
 drivers/crypto/qat/qat_common/qat_hal.c            |    7 ++++--
 drivers/crypto/qat/qat_common/qat_uclo.c           |   25 +++++++++++---------
 drivers/crypto/qat/qat_dh895xcc/adf_drv.c          |    1 +
 drivers/crypto/qat/qat_dh895xcc/adf_hw_arbiter.c   |   12 +++++-----
 drivers/crypto/qat/qat_dh895xcc/adf_isr.c          |    2 +-
 14 files changed, 48 insertions(+), 26 deletions(-)

-- 
