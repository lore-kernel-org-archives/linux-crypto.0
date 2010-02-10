From: richih.mailinglist@gmail.com
Subject: [PATCH 1/1] CRYPTO: Fix checkpatch errors & warnings in arc4.c
Date: Wed, 10 Feb 2010 02:17:39 +0100
Message-ID: <1265764660-23178-1-git-send-email-richih.mailinglist@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: richih.mailinglist@gmail.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-fx0-f220.google.com ([209.85.220.220]:44859 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754300Ab0BJBS1 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Feb 2010 20:18:27 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Richard Hartmann <richih.mailinglist@gmail.com>


Signed-off-by: Richard Hartmann <richih.mailinglist@gmail.com>
---
 crypto/arc4.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/crypto/arc4.c b/crypto/arc4.c
index 8be47e1..8a61fa2 100644
--- a/crypto/arc4.c
+++ b/crypto/arc4.c
@@ -1,4 +1,4 @@
-/* 
+/*
  * Cryptographic API
  *
  * ARC4 Cipher Algorithm
@@ -33,16 +33,15 @@ static int arc4_set_key(struct crypto_tfm *tfm, const u8 *in_key,
 	ctx->x = 1;
 	ctx->y = 0;
 
-	for(i = 0; i < 256; i++)
+	for (i = 0; i < 256; i++)
 		ctx->S[i] = i;
 
-	for(i = 0; i < 256; i++)
-	{
+	for (i = 0; i < 256; i++) {
 		u8 a = ctx->S[i];
 		j = (j + in_key[k] + a) & 0xff;
 		ctx->S[i] = ctx->S[j];
 		ctx->S[j] = a;
-		if(++k >= key_len)
+		if (++k >= key_len)
 			k = 0;
 	}
 
-- 
1.6.6.1

