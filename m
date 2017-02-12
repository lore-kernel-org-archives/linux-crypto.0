From: Nicholas Mc Guire <der.herr@hofr.at>
Subject: [PATCH RFC] crypto: testmgr drop wrong init_completion
Date: Sun, 12 Feb 2017 16:05:46 +0100
Message-ID: <1486911946-19501-1-git-send-email-der.herr@hofr.at>
Cc: "David S. Miller" <davem@davemloft.net>,
        Tadeusz Struk <tadeusz.struk@intel.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nicholas Mc Guire <der.herr@hofr.at>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from www.osadl.org ([62.245.132.105]:38344 "EHLO www.osadl.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751116AbdBLPFX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 12 Feb 2017 10:05:23 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

init_completion() is called here to reinitialize a completion object
that was already re-initialized in wait_async_op() by 
reinit_completion() if complete (via tcrypt_complete()) had been called
and wait_for_completion() returned, so no need to reinit it here.


Fixes: commit 946cc46372dc ("crypto: testmgr - add tests vectors for RSA")
Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
---

Found by experimental coccinelle script
./crypto/testmgr.c:2174:1-16: WARNING: possible duplicate init_completion

Only based on code review and no testing. In case I am overlooking something
and the re-initialization of the completion object is actually needed it
should be using reinit_completion() and not init_completion() anyway.
But as wait_async_op() will leave with the completion object re-initialized
it really should not be needed here (found no path in between that could
have called completion()).

Patch was only compile tested with: x86_64_defconfig (implies cryptomgr-y)

Patch is against linux-4.10-rc6 (localversion-next is next-20170210)

 crypto/testmgr.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 98eb097..15fb453 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -2171,7 +2171,6 @@ static int test_akcipher_one(struct crypto_akcipher *tfm,
 
 	sg_init_one(&src, xbuf[0], vecs->c_size);
 	sg_init_one(&dst, outbuf_dec, out_len_max);
-	init_completion(&result.completion);
 	akcipher_request_set_crypt(req, &src, &dst, vecs->c_size, out_len_max);
 
 	/* Run RSA decrypt - m = c^d mod n;*/
-- 
2.1.4
