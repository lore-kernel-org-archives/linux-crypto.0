Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBAD7C77B7E
	for <linux-crypto@archiver.kernel.org>; Thu,  1 Jun 2023 08:48:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232046AbjFAIsE (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 1 Jun 2023 04:48:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231428AbjFAIry (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 1 Jun 2023 04:47:54 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C052B134
        for <linux-crypto@vger.kernel.org>; Thu,  1 Jun 2023 01:47:50 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1q4dyB-00Fb2R-Cb; Thu, 01 Jun 2023 16:47:44 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 01 Jun 2023 16:47:43 +0800
Date:   Thu, 1 Jun 2023 16:47:43 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@kernel.org>, dm-devel@redhat.com
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: dm crypt: Avoid using MAX_CIPHER_BLOCKSIZE
Message-ID: <ZHhbL+SbWRnTW4b7@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

MAX_CIPHER_BLOCKSIZE is an internal implementation detail and should
not be relied on by users of the Crypto API.

Instead of storing the IV on the stack, allocate it together with
the crypto request.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/md/dm-crypt.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 40cb1719ae4d..0e7e443dde11 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -31,10 +31,10 @@
 #include <asm/unaligned.h>
 #include <crypto/hash.h>
 #include <crypto/md5.h>
-#include <crypto/algapi.h>
 #include <crypto/skcipher.h>
 #include <crypto/aead.h>
 #include <crypto/authenc.h>
+#include <crypto/utils.h>
 #include <linux/rtnetlink.h> /* for struct rtattr and RTA macros only */
 #include <linux/key-type.h>
 #include <keys/user-type.h>
@@ -743,16 +743,23 @@ static int crypt_iv_eboiv_ctr(struct crypt_config *cc, struct dm_target *ti,
 static int crypt_iv_eboiv_gen(struct crypt_config *cc, u8 *iv,
 			    struct dm_crypt_request *dmreq)
 {
-	u8 buf[MAX_CIPHER_BLOCKSIZE] __aligned(__alignof__(__le64));
+	struct crypto_skcipher *tfm = any_tfm(cc);
 	struct skcipher_request *req;
 	struct scatterlist src, dst;
 	DECLARE_CRYPTO_WAIT(wait);
+	unsigned int reqsize;
 	int err;
+	u8 *buf;
 
-	req = skcipher_request_alloc(any_tfm(cc), GFP_NOIO);
+	reqsize = ALIGN(crypto_skcipher_reqsize(tfm), __alignof__(__le64));
+
+	req = kmalloc(reqsize + cc->iv_size, GFP_NOIO);
 	if (!req)
 		return -ENOMEM;
 
+	skcipher_request_set_tfm(req, tfm);
+
+	buf = (u8 *)req + reqsize;
 	memset(buf, 0, cc->iv_size);
 	*(__le64 *)buf = cpu_to_le64(dmreq->iv_sector * cc->sector_size);
 
@@ -761,7 +768,7 @@ static int crypt_iv_eboiv_gen(struct crypt_config *cc, u8 *iv,
 	skcipher_request_set_crypt(req, &src, &dst, cc->iv_size, buf);
 	skcipher_request_set_callback(req, 0, crypto_req_done, &wait);
 	err = crypto_wait_req(crypto_skcipher_encrypt(req), &wait);
-	skcipher_request_free(req);
+	kfree_sensitive(req);
 
 	return err;
 }
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
