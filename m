From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH] crypto: generic/cts - fix regression in iv handling
Date: Mon, 16 Jan 2017 09:16:35 +0000
Message-ID: <1484558195-14522-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:34971 "EHLO
        mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750864AbdAPJQq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 16 Jan 2017 04:16:46 -0500
Received: by mail-wm0-f41.google.com with SMTP id r126so150706596wmr.0
        for <linux-crypto@vger.kernel.org>; Mon, 16 Jan 2017 01:16:46 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Since the skcipher conversion in commit 0605c41cc53c ("crypto:
cts - Convert to skcipher"), the cts code tacitly assumes that
the underlying CBC encryption transform performed on the first
part of the plaintext returns an IV in req->iv that is suitable
for encrypting the final bit.

While this is usually the case, it is not mandated by the API, and
given that the CTS code already accesses the ciphertext scatterlist
to retrieve those bytes, we can simply copy them into req->iv before
proceeding.

Fixes: 0605c41cc53c ("crypto: cts - Convert to skcipher")
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 crypto/cts.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/crypto/cts.c b/crypto/cts.c
index a1335d6c35fb..3270ce8f278d 100644
--- a/crypto/cts.c
+++ b/crypto/cts.c
@@ -114,6 +114,7 @@ static int cts_cbc_encrypt(struct skcipher_request *req)
 
 	sg = scatterwalk_ffwd(rctx->sg, req->dst, offset - bsize);
 	scatterwalk_map_and_copy(d + bsize, sg, 0, bsize, 0);
+	memcpy(req->iv, d + bsize, bsize);
 
 	memset(d, 0, bsize);
 	scatterwalk_map_and_copy(d, req->src, offset, lastn, 0);
-- 
2.7.4
