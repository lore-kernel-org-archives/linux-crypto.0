From: Richard Hartmann <richih.mailinglist@gmail.com>
Subject: [PATCH 1/1] CRYPTO: Fix checkpatch errors & warnings in anubis.c
Date: Wed, 10 Feb 2010 01:53:06 +0100
Message-ID: <1265763187-22417-1-git-send-email-richih.mailinglist@gmail.com>
Cc: Richard Hartmann <richih.mailinglist@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-fx0-f220.google.com ([209.85.220.220]:50137 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672Ab0BJAx4 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Feb 2010 19:53:56 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Signed-off-by: Richard Hartmann <richih.mailinglist@gmail.com>
---
 crypto/anubis.c |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/crypto/anubis.c b/crypto/anubis.c
index e42c3a8..77530d5 100644
--- a/crypto/anubis.c
+++ b/crypto/anubis.c
@@ -469,14 +469,13 @@ static int anubis_setkey(struct crypto_tfm *tfm, const u8 *in_key,
 	u32 kappa[ANUBIS_MAX_N];
 	u32 inter[ANUBIS_MAX_N];
 
-	switch (key_len)
-	{
+	switch (key_len) {
 		case 16: case 20: case 24: case 28:
 		case 32: case 36: case 40:
 			break;
 		default:
 			*flags |= CRYPTO_TFM_RES_BAD_KEY_LEN;
-			return - EINVAL;
+			return -EINVAL;
 	}
 
 	ctx->key_len = key_len * 8;
@@ -530,23 +529,24 @@ static int anubis_setkey(struct crypto_tfm *tfm, const u8 *in_key,
 		/*
 		 * compute kappa^{r+1} from kappa^r:
 		 */
-		if (r == R) {
+		if (r == R)
 			break;
-		}
 		for (i = 0; i < N; i++) {
 			int j = i;
 			inter[i]  = T0[(kappa[j--] >> 24)       ];
-			if (j < 0) j = N - 1;
+			if (j < 0)
+				j = N - 1;
 			inter[i] ^= T1[(kappa[j--] >> 16) & 0xff];
-			if (j < 0) j = N - 1;
+			if (j < 0)
+				j = N - 1;
 			inter[i] ^= T2[(kappa[j--] >>  8) & 0xff];
-			if (j < 0) j = N - 1;
+			if (j < 0)
+				j = N - 1;
 			inter[i] ^= T3[(kappa[j  ]      ) & 0xff];
 		}
 		kappa[0] = inter[0] ^ rc[r];
-		for (i = 1; i < N; i++) {
+		for (i = 1; i < N; i++)
 			kappa[i] = inter[i];
-		}
 	}
 
 	/*
@@ -690,7 +690,7 @@ static struct crypto_alg anubis_alg = {
 static int __init anubis_mod_init(void)
 {
 	int ret = 0;
-	
+
 	ret = crypto_register_alg(&anubis_alg);
 	return ret;
 }
-- 
1.6.6.1

