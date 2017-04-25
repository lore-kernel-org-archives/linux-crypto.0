From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
Subject: [PATCH 3/5] crypto: caampkc - incapsulate dropping leading zeros into function
Date: Tue, 25 Apr 2017 16:26:37 +0300
Message-ID: <20170425132639.20178-4-horia.geanta@nxp.com>
References: <20170425132639.20178-1-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: "David S. Miller" <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>,
        Dan Douglass <dan.douglass@nxp.com>,
        Radu Alexe <radu.alexe@nxp.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-co1nam03on0060.outbound.protection.outlook.com ([104.47.40.60]:64288
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1430993AbdDYN1R (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 25 Apr 2017 09:27:17 -0400
In-Reply-To: <20170425132639.20178-1-horia.geanta@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Radu Alexe <radu.alexe@nxp.com>

This function will be used into further patches.

Signed-off-by: Radu Alexe <radu.alexe@nxp.com>
Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
 drivers/crypto/caam/caampkc.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/caam/caampkc.c b/drivers/crypto/caam/caampkc.c
index 999ba18495b0..d2c6977ba82e 100644
--- a/drivers/crypto/caam/caampkc.c
+++ b/drivers/crypto/caam/caampkc.c
@@ -357,6 +357,14 @@ static void caam_rsa_free_key(struct caam_rsa_key *key)
 	key->n_sz = 0;
 }
 
+static void caam_rsa_drop_leading_zeros(const u8 **ptr, size_t *nbytes)
+{
+	while (!**ptr && *nbytes) {
+		(*ptr)++;
+		(*nbytes)--;
+	}
+}
+
 /**
  * caam_read_raw_data - Read a raw byte stream as a positive integer.
  * The function skips buffer's leading zeros, copies the remained data
@@ -370,10 +378,7 @@ static inline u8 *caam_read_raw_data(const u8 *buf, size_t *nbytes)
 {
 	u8 *val;
 
-	while (!*buf && *nbytes) {
-		buf++;
-		(*nbytes)--;
-	}
+	caam_rsa_drop_leading_zeros(&buf, nbytes);
 	if (!*nbytes)
 		return NULL;
 
-- 
2.12.0.264.gd6db3f216544
