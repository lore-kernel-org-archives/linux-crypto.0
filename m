From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: crypto: cryptd - Add finup/export/import for hash
Date: Wed, 22 Jul 2009 11:12:13 +0800
Message-ID: <20090722031213.GA28449@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:41136 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756004AbZGVDMP (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 21 Jul 2009 23:12:15 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by arnor.apana.org.au with esmtp (Exim 4.63 #1 (Debian))
	id 1MTSFa-0004HT-L5
	for <linux-crypto@vger.kernel.org>; Wed, 22 Jul 2009 13:12:14 +1000
Received: from herbert by gondolin.me.apana.org.au with local (Exim 4.69)
	(envelope-from <herbert@gondor.apana.org.au>)
	id 1MTSFa-0007PA-0v
	for linux-crypto@vger.kernel.org; Wed, 22 Jul 2009 11:12:14 +0800
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi:

This patch fills in the new finup/export/import functions in
cryptd.

commit 6fba00d176ab73b15bb8e31f261582943429a92b
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Wed Jul 22 11:10:22 2009 +0800

    crypto: cryptd - Add finup/export/import for hash
    
    This patch adds the finup/export/import functions to the cryptd
    ahash implementation.  We simply invoke the underlying shash
    operations.
    
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/cryptd.c b/crypto/cryptd.c
index fbd26f9..2eb7058 100644
--- a/crypto/cryptd.c
+++ b/crypto/cryptd.c
@@ -478,6 +478,29 @@ static int cryptd_hash_final_enqueue(struct ahash_request *req)
 	return cryptd_hash_enqueue(req, cryptd_hash_final);
 }
 
+static void cryptd_hash_finup(struct crypto_async_request *req_async, int err)
+{
+	struct ahash_request *req = ahash_request_cast(req_async);
+	struct cryptd_hash_request_ctx *rctx = ahash_request_ctx(req);
+
+	if (unlikely(err == -EINPROGRESS))
+		goto out;
+
+	err = shash_ahash_finup(req, &rctx->desc);
+
+	req->base.complete = rctx->complete;
+
+out:
+	local_bh_disable();
+	rctx->complete(&req->base, err);
+	local_bh_enable();
+}
+
+static int cryptd_hash_finup_enqueue(struct ahash_request *req)
+{
+	return cryptd_hash_enqueue(req, cryptd_hash_finup);
+}
+
 static void cryptd_hash_digest(struct crypto_async_request *req_async, int err)
 {
 	struct cryptd_hash_ctx *ctx = crypto_tfm_ctx(req_async->tfm);
@@ -507,6 +530,20 @@ static int cryptd_hash_digest_enqueue(struct ahash_request *req)
 	return cryptd_hash_enqueue(req, cryptd_hash_digest);
 }
 
+static int cryptd_hash_export(struct ahash_request *req, void *out)
+{
+	struct cryptd_hash_request_ctx *rctx = ahash_request_ctx(req);
+
+	return crypto_shash_export(&rctx->desc, out);
+}
+
+static int cryptd_hash_import(struct ahash_request *req, const void *in)
+{
+	struct cryptd_hash_request_ctx *rctx = ahash_request_ctx(req);
+
+	return crypto_shash_import(&rctx->desc, in);
+}
+
 static int cryptd_create_hash(struct crypto_template *tmpl, struct rtattr **tb,
 			      struct cryptd_queue *queue)
 {
@@ -546,6 +583,9 @@ static int cryptd_create_hash(struct crypto_template *tmpl, struct rtattr **tb,
 	inst->alg.init   = cryptd_hash_init_enqueue;
 	inst->alg.update = cryptd_hash_update_enqueue;
 	inst->alg.final  = cryptd_hash_final_enqueue;
+	inst->alg.finup  = cryptd_hash_finup_enqueue;
+	inst->alg.export = cryptd_hash_export;
+	inst->alg.import = cryptd_hash_import;
 	inst->alg.setkey = cryptd_hash_setkey;
 	inst->alg.digest = cryptd_hash_digest_enqueue;
 
Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
