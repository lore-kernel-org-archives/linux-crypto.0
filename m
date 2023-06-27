Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA536EB64D9
	for <linux-crypto@archiver.kernel.org>; Tue, 27 Jun 2023 10:03:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231685AbjF0KDx (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 27 Jun 2023 06:03:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231940AbjF0KDP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 27 Jun 2023 06:03:15 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C76133C32
        for <linux-crypto@vger.kernel.org>; Tue, 27 Jun 2023 03:00:00 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qE5Tw-007kCb-IG; Tue, 27 Jun 2023 17:59:33 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 27 Jun 2023 17:59:32 +0800
Date:   Tue, 27 Jun 2023 17:59:32 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [PATCH] crypto: akcipher - Do not copy dst if it is NULL
Message-ID: <ZJqzBNpwyanNHLE9@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

As signature verification has a NULL destination buffer, the pointer
needs to be checked before the memcpy is done.

Fixes: addde1f2c966 ("crypto: akcipher - Add sync interface without SG lists")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/akcipher.c b/crypto/akcipher.c
index e9b6ddcdf124..52813f0b19e4 100644
--- a/crypto/akcipher.c
+++ b/crypto/akcipher.c
@@ -234,7 +234,8 @@ EXPORT_SYMBOL_GPL(crypto_akcipher_sync_prep);
 int crypto_akcipher_sync_post(struct crypto_akcipher_sync_data *data, int err)
 {
 	err = crypto_wait_req(err, &data->cwait);
-	memcpy(data->dst, data->buf, data->dlen);
+	if (data->dst)
+		memcpy(data->dst, data->buf, data->dlen);
 	data->dlen = data->req->dst_len;
 	kfree_sensitive(data->req);
 	return err;
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
