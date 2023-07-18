Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 757ECEB64DC
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Jul 2023 13:02:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232559AbjGRNB6 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 18 Jul 2023 09:01:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232493AbjGRNBY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Jul 2023 09:01:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C7CE1FEF;
        Tue, 18 Jul 2023 06:00:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 042EE614FB;
        Tue, 18 Jul 2023 13:00:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 178C6C433CA;
        Tue, 18 Jul 2023 13:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689685220;
        bh=M7WgPUSIPoeRnhagLleZw11JZUjXzh7EjhC9ItdylhI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZiqeV+BnZp3cLfA0MbxVPtz12ltzOoRSGxIORn0Gi//Rft3vveQhu0SjmWQWBCr6y
         CimWcYY2BnWLFZOpS1dkdgCF5KhOgCmOumRRbE3tgC1vamXZSIUoCzOjWeBAuvHkoT
         bmlK9VgojWthOUgQshf1e6xPJkY34b9KQAf7cy1o1KkiB1KulcsBBCsvs+QENZM6tU
         WJdFfgfWftd+tcznULjDoG+tps1F3jrdnP95FxyqkRnzApk8jXjonDy+83onKlSagl
         gyS7vLkWPZ7ChOnN1uQz9FZv57FvLZY/5pbGnW1DEoxc/JNtoaCd0DVyc0khrwyZ3h
         Nq8L4k3r0uh1w==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Haren Myneni <haren@us.ibm.com>,
        Nick Terrell <terrelln@fb.com>,
        Minchan Kim <minchan@kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Jens Axboe <axboe@kernel.dk>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Richard Weinberger <richard@nod.at>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        qat-linux@intel.com, linuxppc-dev@lists.ozlabs.org,
        linux-mtd@lists.infradead.org, netdev@vger.kernel.org
Subject: [RFC PATCH 11/21] crypto: deflate - drop obsolete 'comp' implementation
Date:   Tue, 18 Jul 2023 14:58:37 +0200
Message-Id: <20230718125847.3869700-12-ardb@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230718125847.3869700-1-ardb@kernel.org>
References: <20230718125847.3869700-1-ardb@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3314; i=ardb@kernel.org; h=from:subject; bh=M7WgPUSIPoeRnhagLleZw11JZUjXzh7EjhC9ItdylhI=; b=owGbwMvMwCFmkMcZplerG8N4Wi2JIWVbT9Vz0SiZCzNmlVRdnKSfvtS574N93b97iX832bmU3 QlKyPrVUcrCIMbBICumyCIw+++7nacnStU6z5KFmcPKBDKEgYtTACYivYGRoYGZ/d62qVNZEw5b bVxzpfjx1dxEiRczJu3OYWisXWV4xZKRof3PC46/975fuv+B+8HuefcX7pyd+fLPBHOJ5XPWmt0 6Ks8GAA==
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

No users of the obsolete 'comp' crypto compression API remain, so let's
drop the software deflate version of it.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 crypto/deflate.c | 58 +-------------------
 1 file changed, 1 insertion(+), 57 deletions(-)

diff --git a/crypto/deflate.c b/crypto/deflate.c
index f4f127078fe2a5aa..0955040ca9e64146 100644
--- a/crypto/deflate.c
+++ b/crypto/deflate.c
@@ -130,13 +130,6 @@ static void *deflate_alloc_ctx(struct crypto_scomp *tfm)
 	return ctx;
 }
 
-static int deflate_init(struct crypto_tfm *tfm)
-{
-	struct deflate_ctx *ctx = crypto_tfm_ctx(tfm);
-
-	return __deflate_init(ctx);
-}
-
 static void __deflate_exit(void *ctx)
 {
 	deflate_comp_exit(ctx);
@@ -149,13 +142,6 @@ static void deflate_free_ctx(struct crypto_scomp *tfm, void *ctx)
 	kfree_sensitive(ctx);
 }
 
-static void deflate_exit(struct crypto_tfm *tfm)
-{
-	struct deflate_ctx *ctx = crypto_tfm_ctx(tfm);
-
-	__deflate_exit(ctx);
-}
-
 static int __deflate_compress(const u8 *src, unsigned int slen,
 			      u8 *dst, unsigned int *dlen, void *ctx)
 {
@@ -185,14 +171,6 @@ static int __deflate_compress(const u8 *src, unsigned int slen,
 	return ret;
 }
 
-static int deflate_compress(struct crypto_tfm *tfm, const u8 *src,
-			    unsigned int slen, u8 *dst, unsigned int *dlen)
-{
-	struct deflate_ctx *dctx = crypto_tfm_ctx(tfm);
-
-	return __deflate_compress(src, slen, dst, dlen, dctx);
-}
-
 static int deflate_scompress(struct crypto_scomp *tfm, const u8 *src,
 			     unsigned int slen, u8 *dst, unsigned int *dlen,
 			     void *ctx)
@@ -241,14 +219,6 @@ static int __deflate_decompress(const u8 *src, unsigned int slen,
 	return ret;
 }
 
-static int deflate_decompress(struct crypto_tfm *tfm, const u8 *src,
-			      unsigned int slen, u8 *dst, unsigned int *dlen)
-{
-	struct deflate_ctx *dctx = crypto_tfm_ctx(tfm);
-
-	return __deflate_decompress(src, slen, dst, dlen, dctx);
-}
-
 static int deflate_sdecompress(struct crypto_scomp *tfm, const u8 *src,
 			       unsigned int slen, u8 *dst, unsigned int *dlen,
 			       void *ctx)
@@ -256,19 +226,6 @@ static int deflate_sdecompress(struct crypto_scomp *tfm, const u8 *src,
 	return __deflate_decompress(src, slen, dst, dlen, ctx);
 }
 
-static struct crypto_alg alg = {
-	.cra_name		= "deflate",
-	.cra_driver_name	= "deflate-generic",
-	.cra_flags		= CRYPTO_ALG_TYPE_COMPRESS,
-	.cra_ctxsize		= sizeof(struct deflate_ctx),
-	.cra_module		= THIS_MODULE,
-	.cra_init		= deflate_init,
-	.cra_exit		= deflate_exit,
-	.cra_u			= { .compress = {
-	.coa_compress 		= deflate_compress,
-	.coa_decompress  	= deflate_decompress } }
-};
-
 static struct scomp_alg scomp = {
 	.alloc_ctx		= deflate_alloc_ctx,
 	.free_ctx		= deflate_free_ctx,
@@ -283,24 +240,11 @@ static struct scomp_alg scomp = {
 
 static int __init deflate_mod_init(void)
 {
-	int ret;
-
-	ret = crypto_register_alg(&alg);
-	if (ret)
-		return ret;
-
-	ret = crypto_register_scomp(&scomp);
-	if (ret) {
-		crypto_unregister_alg(&alg);
-		return ret;
-	}
-
-	return ret;
+	return crypto_register_scomp(&scomp);
 }
 
 static void __exit deflate_mod_fini(void)
 {
-	crypto_unregister_alg(&alg);
 	crypto_unregister_scomp(&scomp);
 }
 
-- 
2.39.2

