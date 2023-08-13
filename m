Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EABEC001DE
	for <linux-crypto@archiver.kernel.org>; Sun, 13 Aug 2023 06:54:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230222AbjHMGyr (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 13 Aug 2023 02:54:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230293AbjHMGyg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 13 Aug 2023 02:54:36 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA1231725
        for <linux-crypto@vger.kernel.org>; Sat, 12 Aug 2023 23:54:32 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qV4zc-002bl3-18; Sun, 13 Aug 2023 14:54:29 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 13 Aug 2023 14:54:28 +0800
From:   "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Sun, 13 Aug 2023 14:54:28 +0800
Subject: [v2 PATCH 11/36] crypto: virtio - Remove prepare/unprepare request
References: <ZNh94a7YYnvx0l8C@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Gaurav Jain <gaurav.jain@nxp.com>
Message-Id: <E1qV4zc-002bl3-18@formenos.hmeau.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The callbacks for prepare and unprepare request in crypto_engine
is superfluous.  They can be done directly from do_one_request.

Move the code into do_one_request and remove the unused callbacks.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/virtio/virtio_crypto_akcipher_algs.c |    2 --
 drivers/crypto/virtio/virtio_crypto_skcipher_algs.c |    2 --
 2 files changed, 4 deletions(-)

diff --git a/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c b/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
index 6963344f6a3a..ff3369ca319f 100644
--- a/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
+++ b/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
@@ -476,8 +476,6 @@ static int virtio_crypto_rsa_init_tfm(struct crypto_akcipher *tfm)
 
 	ctx->tfm = tfm;
 	ctx->enginectx.op.do_one_request = virtio_crypto_rsa_do_req;
-	ctx->enginectx.op.prepare_request = NULL;
-	ctx->enginectx.op.unprepare_request = NULL;
 
 	akcipher_set_reqsize(tfm,
 			     sizeof(struct virtio_crypto_akcipher_request));
diff --git a/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c b/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c
index e5876286828b..71b8751ab5ab 100644
--- a/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c
+++ b/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c
@@ -524,8 +524,6 @@ static int virtio_crypto_skcipher_init(struct crypto_skcipher *tfm)
 	ctx->tfm = tfm;
 
 	ctx->enginectx.op.do_one_request = virtio_crypto_skcipher_crypt_req;
-	ctx->enginectx.op.prepare_request = NULL;
-	ctx->enginectx.op.unprepare_request = NULL;
 	return 0;
 }
 
