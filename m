From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH] crypto: qat - don't need qat_auth_state struct
Date: Wed, 14 Jan 2015 10:27:35 -0800
Message-ID: <20150114182735.5482.89743.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	qat-linux@intel.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:40831 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753186AbbANSa4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 14 Jan 2015 13:30:56 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

We don't need the qat_auth_state structure anymore.

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 drivers/crypto/qat/qat_common/qat_algs.c |    6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/qat_algs.c b/drivers/crypto/qat/qat_common/qat_algs.c
index e2c4b25..1dc5b0a 100644
--- a/drivers/crypto/qat/qat_common/qat_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_algs.c
@@ -102,12 +102,6 @@ struct qat_alg_cd {
 	};
 } __aligned(64);
 
-#define MAX_AUTH_STATE_SIZE sizeof(struct icp_qat_hw_auth_algo_blk)
-
-struct qat_auth_state {
-	uint8_t data[MAX_AUTH_STATE_SIZE + 64];
-} __aligned(64);
-
 struct qat_alg_aead_ctx {
 	struct qat_alg_cd *enc_cd;
 	struct qat_alg_cd *dec_cd;
