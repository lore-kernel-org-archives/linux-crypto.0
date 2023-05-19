Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 558EAC77B7F
	for <linux-crypto@archiver.kernel.org>; Fri, 19 May 2023 08:29:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230076AbjESI3P (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 19 May 2023 04:29:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230150AbjESI3N (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 May 2023 04:29:13 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E321E58;
        Fri, 19 May 2023 01:29:11 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pzvTZ-00AnMQ-5M; Fri, 19 May 2023 16:28:38 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 19 May 2023 16:28:37 +0800
From:   "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Fri, 19 May 2023 16:28:37 +0800
Subject: [PATCH 3/3] crypto: cmac - Add support for cloning
References: <ZGcyuyjJwZhdYS/G@gondor.apana.org.au>
To:     Dmitry Safonov <dima@arista.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andy Lutomirski <luto@amacapital.net>,
        Ard Biesheuvel <ardb@kernel.org>,
        Bob Gilligan <gilligan@arista.com>,
        Dan Carpenter <error27@gmail.com>,
        David Laight <David.Laight@aculab.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Francesco Ruggeri <fruggeri05@gmail.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Ivan Delalande <colona@arista.com>,
        Leonard Crestez <cdleonard@gmail.com>,
        Salam Noureddine <noureddine@arista.com>,
        netdev@vger.kernel.org
Message-Id: <E1pzvTZ-00AnMQ-5M@formenos.hmeau.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Allow hmac to be cloned.  The underlying cipher needs to support
cloning by not having a cra_init function (all implementations of
aes that do not require a fallback can be cloned).

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/cmac.c |   18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/crypto/cmac.c b/crypto/cmac.c
index bcc6f19a4f64..fce6b0f58e88 100644
--- a/crypto/cmac.c
+++ b/crypto/cmac.c
@@ -213,7 +213,22 @@ static int cmac_init_tfm(struct crypto_shash *tfm)
 	ctx->child = cipher;
 
 	return 0;
-};
+}
+
+static int cmac_clone_tfm(struct crypto_shash *tfm, struct crypto_shash *otfm)
+{
+	struct cmac_tfm_ctx *octx = crypto_shash_ctx(otfm);
+	struct cmac_tfm_ctx *ctx = crypto_shash_ctx(tfm);
+	struct crypto_cipher *cipher;
+
+	cipher = crypto_clone_cipher(octx->child);
+	if (IS_ERR(cipher))
+		return PTR_ERR(cipher);
+
+	ctx->child = cipher;
+
+	return 0;
+}
 
 static void cmac_exit_tfm(struct crypto_shash *tfm)
 {
@@ -280,6 +295,7 @@ static int cmac_create(struct crypto_template *tmpl, struct rtattr **tb)
 	inst->alg.final = crypto_cmac_digest_final;
 	inst->alg.setkey = crypto_cmac_digest_setkey;
 	inst->alg.init_tfm = cmac_init_tfm;
+	inst->alg.clone_tfm = cmac_clone_tfm;
 	inst->alg.exit_tfm = cmac_exit_tfm;
 
 	inst->free = shash_free_singlespawn_instance;
