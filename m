From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
Subject: [PATCH 09/14] crypto: caam - remove unreachable code in report_ccb_status()
Date: Wed, 9 Nov 2016 10:46:19 +0200
Message-ID: <1478681184-9442-10-git-send-email-horia.geanta@nxp.com>
References: <1478681184-9442-1-git-send-email-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: "David S. Miller" <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2nam03on0063.outbound.protection.outlook.com ([104.47.42.63]:7488
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752300AbcKIKTo (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 9 Nov 2016 05:19:44 -0500
In-Reply-To: <1478681184-9442-1-git-send-email-horia.geanta@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

ERRID is a 4-bit field.
Since err_id values are in [0..15] and err_id_list array size is 16,
the condition "err_id < ARRAY_SIZE(err_id_list)" is always true.

Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
 drivers/crypto/caam/error.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/caam/error.c b/drivers/crypto/caam/error.c
index 33e41ea83fcc..79a0cc70717f 100644
--- a/drivers/crypto/caam/error.c
+++ b/drivers/crypto/caam/error.c
@@ -146,10 +146,9 @@ static void report_ccb_status(struct device *jrdev, const u32 status,
 	    strlen(rng_err_id_list[err_id])) {
 		/* RNG-only error */
 		err_str = rng_err_id_list[err_id];
-	} else if (err_id < ARRAY_SIZE(err_id_list))
+	} else {
 		err_str = err_id_list[err_id];
-	else
-		snprintf(err_err_code, sizeof(err_err_code), "%02x", err_id);
+	}
 
 	/*
 	 * CCB ICV check failures are part of normal operation life;
-- 
2.4.4
