From: "George Spelvin" <linux@horizon.com>
Subject: [PATCH 05/10] crypto/des_generic: Ignore parity on triple keys
Date: Sun, 08 Feb 2009 06:52:50 -0500
Message-ID: <20090208115250.5271.qmail@science.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, linux@horizon.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from science.horizon.com ([192.35.100.1]:17658 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752662AbZBHL7c (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 8 Feb 2009 06:59:32 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

des3_ede_setkey now ignores unused bits (often used for parity)
when comparing keys to report weak combinations.
---
 crypto/des_generic.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/des_generic.c b/crypto/des_generic.c
index 24d7f93..d9a81d8 100644
--- a/crypto/des_generic.c
+++ b/crypto/des_generic.c
@@ -821,8 +821,8 @@ static int des3_ede_setkey(struct crypto_tfm *tfm, const u8 *key,
 	u32 *expkey = dctx->expkey;
 	u32 *flags = &tfm->crt_flags;
 
-	if (unlikely(!((K[0] ^ K[2]) | (K[1] ^ K[3])) ||
-		     !((K[2] ^ K[4]) | (K[3] ^ K[5]))) &&
+	if (unlikely(!(((K[0] ^ K[2]) | (K[1] ^ K[3])) & 0xfefefefe) ||
+		     !(((K[2] ^ K[4]) | (K[3] ^ K[5])) & 0xfefefefe)) &&
 		     (*flags & CRYPTO_TFM_REQ_WEAK_KEY))
 	{
 		*flags |= CRYPTO_TFM_RES_WEAK_KEY;
-- 
1.6.0.6

