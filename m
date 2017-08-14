From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 1/2] crypto/chacha20: fix handling of chunked input
Date: Mon, 14 Aug 2017 14:28:14 +0100
Message-ID: <20170814132815.24524-1-ard.biesheuvel@linaro.org>
Cc: herbert@gondor.apana.org.au, steffen.klassert@secunet.com,
        tobias@strongswan.org, martin@strongswan.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:38426 "EHLO
        mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752026AbdHNN2a (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Aug 2017 09:28:30 -0400
Received: by mail-wm0-f54.google.com with SMTP id f15so43779885wmg.1
        for <linux-crypto@vger.kernel.org>; Mon, 14 Aug 2017 06:28:30 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Commit 9ae433bc79f9 ("crypto: chacha20 - convert generic and x86 versions
to skcipher") ported the existing chacha20 code to use the new skcipher
API, and introduced a bug along the way. Unfortunately, the tcrypt tests
did not catch the error, and it was only found recently by Tobias.

Stefan kindly diagnosed the error, and proposed a fix which is similar
to the one below, with the exception that 'walk.stride' is used rather
than the hardcoded block size. This does not actually matter in this
case, but it's a better example of how to use the skcipher walk API.

Fixes: 9ae433bc79f9 ("crypto: chacha20 - convert generic and x86 ...")
Cc: <stable@vger.kernel.org> # v4.11+
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Reported-by: Tobias Brunner <tobias@strongswan.org>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 crypto/chacha20_generic.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/crypto/chacha20_generic.c b/crypto/chacha20_generic.c
index 8b3c04d625c3..4a45fa4890c0 100644
--- a/crypto/chacha20_generic.c
+++ b/crypto/chacha20_generic.c
@@ -91,9 +91,14 @@ int crypto_chacha20_crypt(struct skcipher_request *req)
 	crypto_chacha20_init(state, ctx, walk.iv);
 
 	while (walk.nbytes > 0) {
+		unsigned int nbytes = walk.nbytes;
+
+		if (nbytes < walk.total)
+			nbytes = round_down(nbytes, walk.stride);
+
 		chacha20_docrypt(state, walk.dst.virt.addr, walk.src.virt.addr,
-				 walk.nbytes);
-		err = skcipher_walk_done(&walk, 0);
+				 nbytes);
+		err = skcipher_walk_done(&walk, walk.nbytes - nbytes);
 	}
 
 	return err;
-- 
2.11.0
