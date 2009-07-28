From: Roel Kluin <roel.kluin@gmail.com>
Subject: [PATCH] crypto: Write outside array bounds
Date: Tue, 28 Jul 2009 17:07:11 +0200
Message-ID: <4A6F141F.5000904@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ew0-f226.google.com ([209.85.219.226]:42316 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753575AbZG1PE1 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 28 Jul 2009 11:04:27 -0400
Received: by ewy26 with SMTP id 26so93430ewy.37
        for <linux-crypto@vger.kernel.org>; Tue, 28 Jul 2009 08:04:27 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

In crypto_aes_expand_key() loop8(i) writes up to ctx->key_enc[8*i+15], at most
63. ctx->key_enc has length (15*16)/4 == 60, so the last 16 bytes of key_enc
will overflow into ctx->key_dec.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
Found with Parfait, http://research.sun.com/projects/parfait/

This concerns crypto/aes_generic.c, function crypto_aes_expand_key(),
macro loop8() on line 1249.

1244:           ctx->key_enc[4] = le32_to_cpu(key[4]);
1245:           ctx->key_enc[5] = le32_to_cpu(key[5]);
1246:           ctx->key_enc[6] = le32_to_cpu(key[6]);
1247:           t = ctx->key_enc[7] = le32_to_cpu(key[7]);
1248:           for (i = 0; i < 7; ++i)
1249:                   loop8(i);
1250:           break;
1251:   }
1252:
1253:   ctx->key_dec[0] = ctx->key_enc[key_len + 24];
1254:   ctx->key_dec[1] = ctx->key_enc[key_len + 25];

please review.

diff --git a/include/crypto/aes.h b/include/crypto/aes.h
index 7524ba3..dd8c628 100644
--- a/include/crypto/aes.h
+++ b/include/crypto/aes.h
@@ -14,7 +14,7 @@
 #define AES_KEYSIZE_192		24
 #define AES_KEYSIZE_256		32
 #define AES_BLOCK_SIZE		16
-#define AES_MAX_KEYLENGTH	(15 * 16)
+#define AES_MAX_KEYLENGTH	(16 * 16)
 #define AES_MAX_KEYLENGTH_U32	(AES_MAX_KEYLENGTH / sizeof(u32))
 
 /*
