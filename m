Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32F4CC4332F
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Nov 2022 09:43:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233399AbiKVJnI (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Nov 2022 04:43:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233289AbiKVJmk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Nov 2022 04:42:40 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEE7B120B0
        for <linux-crypto@vger.kernel.org>; Tue, 22 Nov 2022 01:42:37 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1oxPnO-00H3Hz-Km; Tue, 22 Nov 2022 17:42:27 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 22 Nov 2022 17:42:26 +0800
Date:   Tue, 22 Nov 2022 17:42:26 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Gonglei <arei.gonglei@huawei.com>,
        virtualization@lists.linux-foundation.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [PATCH] crypto: virtio - Use helper to set reqsize
Message-ID: <Y3yZgn/ffk21bGaM@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The value of reqsize must only be changed through the helper.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c b/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
index 168195672e2e..b2979be613b8 100644
--- a/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
+++ b/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
@@ -479,6 +479,9 @@ static int virtio_crypto_rsa_init_tfm(struct crypto_akcipher *tfm)
 	ctx->enginectx.op.prepare_request = NULL;
 	ctx->enginectx.op.unprepare_request = NULL;
 
+	akcipher_set_reqsize(tfm,
+			     sizeof(struct virtio_crypto_akcipher_request));
+
 	return 0;
 }
 
@@ -505,7 +508,6 @@ static struct virtio_crypto_akcipher_algo virtio_crypto_akcipher_algs[] = {
 			.max_size = virtio_crypto_rsa_max_size,
 			.init = virtio_crypto_rsa_init_tfm,
 			.exit = virtio_crypto_rsa_exit_tfm,
-			.reqsize = sizeof(struct virtio_crypto_akcipher_request),
 			.base = {
 				.cra_name = "rsa",
 				.cra_driver_name = "virtio-crypto-rsa",
@@ -528,7 +530,6 @@ static struct virtio_crypto_akcipher_algo virtio_crypto_akcipher_algs[] = {
 			.max_size = virtio_crypto_rsa_max_size,
 			.init = virtio_crypto_rsa_init_tfm,
 			.exit = virtio_crypto_rsa_exit_tfm,
-			.reqsize = sizeof(struct virtio_crypto_akcipher_request),
 			.base = {
 				.cra_name = "pkcs1pad(rsa,sha1)",
 				.cra_driver_name = "virtio-pkcs1-rsa-with-sha1",
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
