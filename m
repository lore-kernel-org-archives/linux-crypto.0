Return-Path: <SRS0=B+FN=SQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8863C10F14
	for <linux-crypto@archiver.kernel.org>; Sun, 14 Apr 2019 12:07:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BFD412084E
	for <linux-crypto@archiver.kernel.org>; Sun, 14 Apr 2019 12:07:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726312AbfDNMHt (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 14 Apr 2019 08:07:49 -0400
Received: from orcrist.hmeau.com ([104.223.48.154]:50428 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725829AbfDNMHt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 14 Apr 2019 08:07:49 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hFdvE-0000Ga-1f; Sun, 14 Apr 2019 20:07:44 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hFdvD-0002ku-Qv; Sun, 14 Apr 2019 20:07:43 +0800
Date:   Sun, 14 Apr 2019 20:07:43 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     linux-crypto@vger.kernel.org, Ondrej Mosnacek <omosnace@redhat.com>
Subject: crypto: lrw - Fix atomic sleep when walking skcipher
Message-ID: <20190414120743.7fy2jckdytdscj72@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

When we perform a walk in the completion function, we need to ensure
that it is atomic.

Fixes: ac3c8f36c31d ("crypto: lrw - Do not use auxiliary buffer")
Cc: <stable@vger.kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/lrw.c b/crypto/lrw.c
index 0430ccd08728..aef3588e1550 100644
--- a/crypto/lrw.c
+++ b/crypto/lrw.c
@@ -143,7 +143,8 @@ static int next_index(u32 *counter)
  * mutliple calls to the 'ecb(..)' instance, which usually would be slower than
  * just doing the next_index() calls again.
  */
-static int xor_tweak(struct skcipher_request *req, bool second_pass)
+static int xor_tweak(struct skcipher_request *req, bool second_pass,
+		     bool atomic)
 {
 	const int bs = LRW_BLOCK_SIZE;
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
@@ -161,7 +162,7 @@ static int xor_tweak(struct skcipher_request *req, bool second_pass)
 		skcipher_request_set_tfm(req, tfm);
 	}
 
-	err = skcipher_walk_virt(&w, req, false);
+	err = skcipher_walk_virt(&w, req, atomic);
 	iv = (__be32 *)w.iv;
 
 	counter[0] = be32_to_cpu(iv[3]);
@@ -200,12 +201,12 @@ static int xor_tweak(struct skcipher_request *req, bool second_pass)
 
 static int xor_tweak_pre(struct skcipher_request *req)
 {
-	return xor_tweak(req, false);
+	return xor_tweak(req, false, false);
 }
 
-static int xor_tweak_post(struct skcipher_request *req)
+static int xor_tweak_post(struct skcipher_request *req, bool atomic)
 {
-	return xor_tweak(req, true);
+	return xor_tweak(req, true, atomic);
 }
 
 static void crypt_done(struct crypto_async_request *areq, int err)
@@ -213,7 +214,7 @@ static void crypt_done(struct crypto_async_request *areq, int err)
 	struct skcipher_request *req = areq->data;
 
 	if (!err)
-		err = xor_tweak_post(req);
+		err = xor_tweak_post(req, true);
 
 	skcipher_request_complete(req, err);
 }
@@ -245,7 +246,7 @@ static int encrypt(struct skcipher_request *req)
 	init_crypt(req);
 	return xor_tweak_pre(req) ?:
 		crypto_skcipher_encrypt(subreq) ?:
-		xor_tweak_post(req);
+		xor_tweak_post(req, false);
 }
 
 static int decrypt(struct skcipher_request *req)
@@ -256,7 +257,7 @@ static int decrypt(struct skcipher_request *req)
 	init_crypt(req);
 	return xor_tweak_pre(req) ?:
 		crypto_skcipher_decrypt(subreq) ?:
-		xor_tweak_post(req);
+		xor_tweak_post(req, false);
 }
 
 static int init_tfm(struct crypto_skcipher *tfm)
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
