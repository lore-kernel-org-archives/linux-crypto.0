Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86C65EB64D7
	for <linux-crypto@archiver.kernel.org>; Mon, 26 Jun 2023 10:34:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbjFZKeE (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 26 Jun 2023 06:34:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbjFZKd5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 26 Jun 2023 06:33:57 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CB2710D8
        for <linux-crypto@vger.kernel.org>; Mon, 26 Jun 2023 03:33:49 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qDjXU-007Jl5-7v; Mon, 26 Jun 2023 18:33:45 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 26 Jun 2023 18:33:44 +0800
Date:   Mon, 26 Jun 2023 18:33:44 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [PATCH] crypto: sig - Fix verify call
Message-ID: <ZJlpiMTIR3cKcY7D@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The dst SG list needs to be set to NULL for verify calls.  Do
this as otherwise the underlying algorithm may fail.

Furthermore the digest needs to be copied just like the source.

Fixes: 6cb8815f41a9 ("crypto: sig - Add interface for sign/verify")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/akcipher.c b/crypto/akcipher.c
index 152cfba1346c..0eb8f78751d5 100644
--- a/crypto/akcipher.c
+++ b/crypto/akcipher.c
@@ -192,12 +192,17 @@ EXPORT_SYMBOL_GPL(akcipher_register_instance);
 int crypto_akcipher_sync_prep(struct crypto_akcipher_sync_data *data)
 {
 	unsigned int reqsize = crypto_akcipher_reqsize(data->tfm);
-	unsigned int mlen = max(data->slen, data->dlen);
 	struct akcipher_request *req;
 	struct scatterlist *sg;
+	unsigned int mlen;
 	unsigned int len;
 	u8 *buf;
 
+	if (data->dst)
+		mlen = max(data->slen, data->dlen);
+	else
+		mlen = data->slen + data->dlen;
+
 	len = sizeof(*req) + reqsize + mlen;
 	if (len < mlen)
 		return -EOVERFLOW;
@@ -212,9 +217,10 @@ int crypto_akcipher_sync_prep(struct crypto_akcipher_sync_data *data)
 	data->buf = buf;
 	memcpy(buf, data->src, data->slen);
 
-	sg = data->sg;
+	sg = &data->sg;
 	sg_init_one(sg, buf, mlen);
-	akcipher_request_set_crypt(req, sg, sg, data->slen, data->dlen);
+	akcipher_request_set_crypt(req, sg, data->dst ? sg : NULL,
+				   data->slen, data->dlen);
 
 	crypto_init_wait(&data->cwait);
 	akcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_SLEEP,
diff --git a/crypto/internal.h b/crypto/internal.h
index e3cf5a658d51..63e59240d5fb 100644
--- a/crypto/internal.h
+++ b/crypto/internal.h
@@ -44,7 +44,7 @@ struct crypto_akcipher_sync_data {
 
 	struct akcipher_request *req;
 	struct crypto_wait cwait;
-	struct scatterlist sg[2];
+	struct scatterlist sg;
 	u8 *buf;
 };
 
diff --git a/crypto/sig.c b/crypto/sig.c
index d812555c88af..b48c18ec65cd 100644
--- a/crypto/sig.c
+++ b/crypto/sig.c
@@ -128,9 +128,7 @@ int crypto_sig_verify(struct crypto_sig *tfm,
 	if (err)
 		return err;
 
-	sg_init_table(data.sg, 2);
-	sg_set_buf(&data.sg[0], src, slen);
-	sg_set_buf(&data.sg[1], digest, dlen);
+	memcpy(data.buf + slen, digest, dlen);
 
 	return crypto_akcipher_sync_post(&data,
 					 crypto_akcipher_verify(data.req));
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
