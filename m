Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DBFCEB64DB
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Jun 2023 09:01:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240530AbjFOJBZ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 15 Jun 2023 05:01:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241071AbjFOJBY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Jun 2023 05:01:24 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BC6A1FCC;
        Thu, 15 Jun 2023 02:01:21 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1q9iqZ-003Fs9-GC; Thu, 15 Jun 2023 17:00:52 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 15 Jun 2023 17:00:51 +0800
Date:   Thu, 15 Jun 2023 17:00:51 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Dmitry Safonov <dima@arista.com>
Cc:     linux-kernel@vger.kernel.org, Bob Gilligan <gilligan@arista.com>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Francesco Ruggeri <fruggeri05@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        linux-crypto@vger.kernel.org
Subject: [v2 PATCH] crypto: api - Add __crypto_alloc_tfmgfp
Message-ID: <ZIrTQ1tN5LMuRB/5@gondor.apana.org.au>
References: <20230614174643.3836590-1-dima@arista.com>
 <20230614174643.3836590-3-dima@arista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230614174643.3836590-3-dima@arista.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jun 14, 2023 at 06:46:42PM +0100, Dmitry Safonov wrote:
> Use it straight away in crypto_clone_cipher(), as that is not meant to
> sleep.
> 
> Signed-off-by: Dmitry Safonov <dima@arista.com>
> ---
>  crypto/algapi.c   | 2 +-
>  crypto/api.c      | 6 +++---
>  crypto/cipher.c   | 2 +-
>  crypto/internal.h | 2 +-
>  4 files changed, 6 insertions(+), 6 deletions(-)

Good catch.  Though I'd rather add the gfp argument to a separate
function because I'm in the process of replacing ciphers with
something that uses the new crypto_types API.

Once that happens ciphers will switch over to the normal cloning
call and this can be removed.

---8<---
Use it straight away in crypto_clone_cipher(), as that is not meant to
sleep.

Fixes: 51d8d6d0f4be ("crypto: cipher - Add crypto_clone_cipher")
Signed-off-by: Dmitry Safonov <dima@arista.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/api.c b/crypto/api.c
index d375e8cd770d..9007b33e1108 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -395,15 +395,15 @@ void crypto_shoot_alg(struct crypto_alg *alg)
 }
 EXPORT_SYMBOL_GPL(crypto_shoot_alg);
 
-struct crypto_tfm *__crypto_alloc_tfm(struct crypto_alg *alg, u32 type,
-				      u32 mask)
+struct crypto_tfm *__crypto_alloc_tfmgfp(struct crypto_alg *alg, u32 type,
+					 u32 mask, gfp_t gfp)
 {
 	struct crypto_tfm *tfm = NULL;
 	unsigned int tfm_size;
 	int err = -ENOMEM;
 
 	tfm_size = sizeof(*tfm) + crypto_ctxsize(alg, type, mask);
-	tfm = kzalloc(tfm_size, GFP_KERNEL);
+	tfm = kzalloc(tfm_size, gfp);
 	if (tfm == NULL)
 		goto out_err;
 
@@ -430,6 +430,13 @@ struct crypto_tfm *__crypto_alloc_tfm(struct crypto_alg *alg, u32 type,
 out:
 	return tfm;
 }
+EXPORT_SYMBOL_GPL(__crypto_alloc_tfmgfp);
+
+struct crypto_tfm *__crypto_alloc_tfm(struct crypto_alg *alg, u32 type,
+				      u32 mask)
+{
+	return __crypto_alloc_tfmgfp(alg, type, mask, GFP_KERNEL);
+}
 EXPORT_SYMBOL_GPL(__crypto_alloc_tfm);
 
 /*
diff --git a/crypto/cipher.c b/crypto/cipher.c
index d39ef5f72ab8..a5a88038f0d6 100644
--- a/crypto/cipher.c
+++ b/crypto/cipher.c
@@ -101,8 +101,8 @@ struct crypto_cipher *crypto_clone_cipher(struct crypto_cipher *cipher)
 	if (alg->cra_init)
 		return ERR_PTR(-ENOSYS);
 
-	ntfm = __crypto_alloc_tfm(alg, CRYPTO_ALG_TYPE_CIPHER,
-				  CRYPTO_ALG_TYPE_MASK);
+	ntfm = __crypto_alloc_tfmgfp(alg, CRYPTO_ALG_TYPE_CIPHER,
+				     CRYPTO_ALG_TYPE_MASK, GFP_ATOMIC);
 	if (IS_ERR(ntfm))
 		return ERR_CAST(ntfm);
 
diff --git a/crypto/internal.h b/crypto/internal.h
index 024c2c795f59..12c50b7e7d87 100644
--- a/crypto/internal.h
+++ b/crypto/internal.h
@@ -118,6 +118,8 @@ void crypto_remove_spawns(struct crypto_alg *alg, struct list_head *list,
 			  struct crypto_alg *nalg);
 void crypto_remove_final(struct list_head *list);
 void crypto_shoot_alg(struct crypto_alg *alg);
+struct crypto_tfm *__crypto_alloc_tfmgfp(struct crypto_alg *alg, u32 type,
+					 u32 mask, gfp_t gfp);
 struct crypto_tfm *__crypto_alloc_tfm(struct crypto_alg *alg, u32 type,
 				      u32 mask);
 void *crypto_create_tfm_node(struct crypto_alg *alg,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
