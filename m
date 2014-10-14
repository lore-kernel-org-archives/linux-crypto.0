From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH v2 0/2] crypto: qat - Fix for invalid dma mapping and numa
Date: Mon, 13 Oct 2014 18:24:21 -0700
Message-ID: <20141014012251.742.5500.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: prarit@redhat.com, bruce.w.allan@intel.com, qat-linux@intel.com,
	naleksan@redhat.com, linux-crypto@vger.kernel.org,
	davem@davemloft.net
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:60918 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754219AbaJNB0l (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 13 Oct 2014 21:26:41 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,
These two patches fix invalid (zero length) dma mapping and
enforce numa configuration for maximum performance.

Change log:
v2 - Removed numa node calculation based bus number and use predefined
functions instead.

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---

Tadeusz Struk (2):
      crypto: qat - Prevent dma mapping zero length assoc data
      crypto: qat - Enforce valid numa configuration


 drivers/crypto/qat/qat_common/adf_accel_devices.h |    3 +-
 drivers/crypto/qat/qat_common/adf_transport.c     |   12 +++++---
 drivers/crypto/qat/qat_common/qat_algs.c          |    7 +++--
 drivers/crypto/qat/qat_common/qat_crypto.c        |    8 +++--
 drivers/crypto/qat/qat_dh895xcc/adf_admin.c       |    2 +
 drivers/crypto/qat/qat_dh895xcc/adf_drv.c         |   32 ++++++++-------------
 drivers/crypto/qat/qat_dh895xcc/adf_isr.c         |    2 +
 7 files changed, 32 insertions(+), 34 deletions(-)

-- 
