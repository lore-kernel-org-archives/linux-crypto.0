From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 2/2] crypto: testmgr - add chunked test cases for chacha20
Date: Mon, 14 Aug 2017 14:28:15 +0100
Message-ID: <20170814132815.24524-2-ard.biesheuvel@linaro.org>
References: <20170814132815.24524-1-ard.biesheuvel@linaro.org>
Cc: herbert@gondor.apana.org.au, steffen.klassert@secunet.com,
        tobias@strongswan.org, martin@strongswan.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wr0-f175.google.com ([209.85.128.175]:33436 "EHLO
        mail-wr0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752026AbdHNN2d (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Aug 2017 09:28:33 -0400
Received: by mail-wr0-f175.google.com with SMTP id b65so9849106wrd.0
        for <linux-crypto@vger.kernel.org>; Mon, 14 Aug 2017 06:28:32 -0700 (PDT)
In-Reply-To: <20170814132815.24524-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

We failed to catch a bug in the chacha20 code after porting it to the
skcipher API. We would have caught it if any chunked tests had been
defined, so define some now so we will catch future regressions.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 crypto/testmgr.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index 6ceb0e2758bb..d54971d2d1c8 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -32675,6 +32675,10 @@ static const struct cipher_testvec chacha20_enc_tv_template[] = {
 			  "\x5b\x86\x2f\x37\x30\xe3\x7c\xfd"
 			  "\xc4\xfd\x80\x6c\x22\xf2\x21",
 		.rlen	= 375,
+		.also_non_np = 1,
+		.np	= 3,
+		.tap	= { 375 - 20, 4, 16 },
+
 	}, { /* RFC7539 A.2. Test Vector #3 */
 		.key	= "\x1c\x92\x40\xa5\xeb\x55\xd3\x8a"
 			  "\xf3\x33\x88\x86\x04\xf6\xb5\xf0"
@@ -33049,6 +33053,9 @@ static const struct cipher_testvec chacha20_enc_tv_template[] = {
 			  "\xa1\xed\xad\xd5\x76\xfa\x24\x8f"
 			  "\x98",
 		.rlen	= 1281,
+		.also_non_np = 1,
+		.np	= 3,
+		.tap	= { 1200, 1, 80 },
 	},
 };
 
-- 
2.11.0
