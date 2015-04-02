From: Stephan Mueller <smueller@chronox.de>
Subject: Re: crypto: api - Change crypto_unregister_instance argument type
Date: Thu, 02 Apr 2015 16:54:03 +0200
Message-ID: <2597941.K7IMfLeYM0@tauon>
References: <20150402143122.GA9699@gondor.apana.org.au> <20150402143940.GA9947@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Steffen Klassert <steffen.klassert@secunet.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:58117 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752985AbbDBOyG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 2 Apr 2015 10:54:06 -0400
In-Reply-To: <20150402143940.GA9947@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 2. April 2015, 22:39:40 schrieb Herbert Xu:

Hi Herbert,

>This patch makes crypto_unregister_instance take a crypto_instance
>instead of a crypto_alg.  This allows us to remove a duplicate
>CRYPTO_ALG_INSTANCE check in crypto_unregister_instance.
>
>Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
>
>diff --git a/crypto/algapi.c b/crypto/algapi.c
>index 0f1976e..f1d0307 100644
>--- a/crypto/algapi.c
>+++ b/crypto/algapi.c
>@@ -551,17 +551,13 @@ err:
> }
> EXPORT_SYMBOL_GPL(crypto_register_instance);
>
>-int crypto_unregister_instance(struct crypto_alg *alg)
>+int crypto_unregister_instance(struct crypto_instance *inst)
> {
>-	struct crypto_instance *inst = (void *)alg;
> 	LIST_HEAD(list);
>
>-	if (!(alg->cra_flags & CRYPTO_ALG_INSTANCE))
>-		return -EINVAL;
>-
> 	down_write(&crypto_alg_sem);
>
>-	crypto_remove_spawns(alg, &list, NULL);
>+	crypto_remove_spawns(&inst->alg, &list, NULL);
> 	crypto_remove_instance(inst, &list);
>
> 	up_write(&crypto_alg_sem);
>diff --git a/crypto/crypto_user.c b/crypto/crypto_user.c
>index c5148a3..eab2497 100644
>--- a/crypto/crypto_user.c
>+++ b/crypto/crypto_user.c
>@@ -316,7 +316,7 @@ static int crypto_del_alg(struct sk_buff *skb, struct
>nlmsghdr *nlh, if (atomic_read(&alg->cra_refcnt) != 1)
> 		return -EBUSY;
>
>-	return crypto_unregister_instance(alg);
>+	return crypto_unregister_instance((struct crypto_instance *)alg);

Instead of using type casts, isn't container_of() a cleaner way (and hopefully 
a safer way) of casting? 
> }
>
> static struct crypto_alg *crypto_user_skcipher_alg(const char *name, u32
>type, diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
>index 623a59c..0ecb768 100644
>--- a/include/crypto/algapi.h
>+++ b/include/crypto/algapi.h
>@@ -137,7 +137,7 @@ struct crypto_template *crypto_lookup_template(const char
>*name);
>
> int crypto_register_instance(struct crypto_template *tmpl,
> 			     struct crypto_instance *inst);
>-int crypto_unregister_instance(struct crypto_alg *alg);
>+int crypto_unregister_instance(struct crypto_instance *inst);
>
> int crypto_init_spawn(struct crypto_spawn *spawn, struct crypto_alg *alg,
> 		      struct crypto_instance *inst, u32 mask);


Ciao
Stephan
