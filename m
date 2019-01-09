Return-Path: <SRS0=1Gsi=PR=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725440AbfAIGM5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 9 Jan 2019 01:12:57 -0500
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH] crypto: sm3 - fix undefined shift by >= width of value
Date: Tue,  8 Jan 2019 22:12:41 -0800
Message-Id: <20190109061241.6943-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

sm3_compress() calls rol32() with shift >= 32, which causes undefined
behavior.  This is easily detected by enabling CONFIG_UBSAN.

Explicitly AND with 31 to make the behavior well defined.

Fixes: 4f0fc1600edb ("crypto: sm3 - add OSCCA SM3 secure hash")
Cc: <stable@vger.kernel.org> # v4.15+
Cc: Gilad Ben-Yossef <gilad@benyossef.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/sm3_generic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/sm3_generic.c b/crypto/sm3_generic.c
index 9a5c60f08aad8..c0cf87ae7ef6d 100644
--- a/crypto/sm3_generic.c
+++ b/crypto/sm3_generic.c
@@ -100,7 +100,7 @@ static void sm3_compress(u32 *w, u32 *wt, u32 *m)
 
 	for (i = 0; i <= 63; i++) {
 
-		ss1 = rol32((rol32(a, 12) + e + rol32(t(i), i)), 7);
+		ss1 = rol32((rol32(a, 12) + e + rol32(t(i), i & 31)), 7);
 
 		ss2 = ss1 ^ rol32(a, 12);
 
-- 
2.20.1
