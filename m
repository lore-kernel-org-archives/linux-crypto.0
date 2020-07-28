Return-Path: <SRS0=t+Y3=BH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 050C6C43458
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jul 2020 07:19:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E0FF721775
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jul 2020 07:19:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727942AbgG1HT1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 Jul 2020 03:19:27 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:54878 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727852AbgG1HT1 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Jul 2020 03:19:27 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1k0JtU-0006SU-25; Tue, 28 Jul 2020 17:19:25 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Tue, 28 Jul 2020 17:19:24 +1000
From:   "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Tue, 28 Jul 2020 17:19:24 +1000
Subject: [v3 PATCH 20/31] crypto: nitrox - Set final_chunksize on rfc3686
References: <20200728071746.GA22352@gondor.apana.org.au>
To:     Ard Biesheuvel <ardb@kernel.org>,
        Stephan Mueller <smueller@chronox.de>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>
Message-Id: <E1k0JtU-0006SU-25@fornost.hmeau.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The rfc3686 implementation in cavium/nitrox does not support partial
operation and therefore this patch sets its final_chunksize to -1
to mark this fact.

This patch also sets the chunksize to the AES block size.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/cavium/nitrox/nitrox_skcipher.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/cavium/nitrox/nitrox_skcipher.c b/drivers/crypto/cavium/nitrox/nitrox_skcipher.c
index 7a159a5da30a0..0b597c6aa68af 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_skcipher.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_skcipher.c
@@ -573,6 +573,8 @@ static struct skcipher_alg nitrox_skciphers[] = { {
 	.min_keysize = AES_MIN_KEY_SIZE + CTR_RFC3686_NONCE_SIZE,
 	.max_keysize = AES_MAX_KEY_SIZE + CTR_RFC3686_NONCE_SIZE,
 	.ivsize = CTR_RFC3686_IV_SIZE,
+	.chunksize = AES_BLOCK_SIZE,
+	.final_chunksize = -1,
 	.init = nitrox_skcipher_init,
 	.exit = nitrox_skcipher_exit,
 	.setkey = nitrox_aes_ctr_rfc3686_setkey,
