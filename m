From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [RFC PATCH] crypto: prevent helper ciphers from being allocated by users
Date: Sun, 15 Mar 2015 12:49:09 +0100
Message-ID: <19820211.DIXnfZpKhF@tachyon.chronox.de>
References: <13986065.EbkBp8M36a@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: 'Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:46692 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752675AbbCOLtO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 15 Mar 2015 07:49:14 -0400
In-Reply-To: <13986065.EbkBp8M36a@tachyon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Freitag, 13. M=E4rz 2015, 22:09:21 schrieb Stephan Mueller:

Hi Stephan,

> Hi,
>=20
> Several hardware related cipher implementations are implemented as fo=
llows:
> a "helper" cipher implementation is registered with the kernel crypto=
 API.
>=20
> Such helper ciphers are never intended to be called by normal users. =
In some
> cases, calling them via the normal crypto API may even cause failures
> including kernel crashes. In a normal case, the "wrapping" ciphers th=
at use
> the helpers ensure that these helpers are invoked such that they cann=
ot
> cause any calamity.
>=20
> Also, with kernel code, we can be reasonably sure that such helper ci=
phers
> are never called directly as the kernel code is under our control.
>=20
> But I am getting very uneasy when the AF_ALG user space interface com=
es into
> play. With that, unprivileged users can call all ciphers registered w=
ith
> the crypto API, including these helper ciphers that are not intended =
to be
> called directly. That means, with AF_ALG user space may invoke these =
helper
> ciphers and may cause undefined states or side effects.
>=20
> For example, without the commit 81e397d937a8e9f46f024a9f876cf14d8e2b4=
5a7 the
> AES-NI GCM implementation could be used to crash the kernel with the
> AF_ALG(aead) interface. But without the patch, using the AES-NI GCM
> implementation through the regular cipher types was no problem at all=
=2E
>=20
> To avoid any potential side effects with such helpers, I propose a ch=
ange to
> the kernel crypto API to prevent the helpers to be called directly. T=
hese
> helpers have the following properties:
>=20
> - they are all marked with a cra_priority of 0 and can therefore be e=
asily
> identified
>=20
> - they are never intended to be instantiated via the regular crypto_a=
lloc_*
> routines, but always via the crypto_*_spawn API. That API is separate=
 from
> the regular allocation API of crypto_alloc_*
>=20
> Therefore, a guard to prevent the instantiation of helper ciphers by =
normal
> users can be done by preventing successful instances of helper cipher=
s in
> crypto_alloc_*. To make life easy, I would recommend to simply use th=
e
> cra_priority as a flag that shall trigger an error in crypto_alloc_*.
>=20
> The following code is tested and confirmed to work (i.e. preventing t=
he use
> of helper ciphers by callers, but allowing helper ciphers to be used =
to
> serve other ciphers). This patch searched for all invocations of
> __crypto_alloc_tfm and added the check for cra_priority except in the
> crypto_spawn_tfm call. Specifically, I tested __driver-gcm-aes-aesni =
vs
> rfc4106-gcm-aesni. In addition, I tested a large array of other ciphe=
rs
> where none were affected by the change.
>=20
> diff --git a/crypto/ablkcipher.c b/crypto/ablkcipher.c
> index db201bca..2cd83ad 100644
> --- a/crypto/ablkcipher.c
> +++ b/crypto/ablkcipher.c
> @@ -688,7 +688,7 @@ struct crypto_ablkcipher *crypto_alloc_ablkcipher=
(const
> char *alg_name,
>  			goto err;
>  		}
>=20
> -		tfm =3D __crypto_alloc_tfm(alg, type, mask);
> +		tfm =3D __crypto_alloc_tfm_safe(alg, type, mask);
>  		if (!IS_ERR(tfm))
>  			return __crypto_ablkcipher_cast(tfm);
>=20
> diff --git a/crypto/aead.c b/crypto/aead.c
> index 2222710..9ae3aa9 100644
> --- a/crypto/aead.c
> +++ b/crypto/aead.c
> @@ -542,7 +542,7 @@ struct crypto_aead *crypto_alloc_aead(const char
> *alg_name, u32 type, u32 mask)
>  			goto err;
>  		}
>=20
> -		tfm =3D __crypto_alloc_tfm(alg, type, mask);
> +		tfm =3D __crypto_alloc_tfm_safe(alg, type, mask);
>  		if (!IS_ERR(tfm))
>  			return __crypto_aead_cast(tfm);
>=20
> diff --git a/crypto/api.c b/crypto/api.c
> index 2a81e98..8b1bb2d 100644
> --- a/crypto/api.c
> +++ b/crypto/api.c
> @@ -389,6 +389,27 @@ out:
>  }
>  EXPORT_SYMBOL_GPL(__crypto_alloc_tfm);
>=20
> +struct crypto_tfm *__crypto_alloc_tfm_safe(struct crypto_alg *alg, u=
32
> type, +					   u32 mask)
> +{
> +	/*
> +	 * Prevent all ciphers from being loaded which have a cra_priority
> +	 * of 0. Those cipher implementations are helper ciphers and
> +	 * are not intended for general consumption.
> +	 *
> +	 * The only exceptions are the compression algorithms which
> +	 * have no priority.
> +	 */
> +	if (!alg->cra_priority &&
> +	    ((alg->cra_flags & CRYPTO_ALG_TYPE_MASK) !=3D
> +	      CRYPTO_ALG_TYPE_PCOMPRESS) &&
> +	    ((alg->cra_flags & CRYPTO_ALG_TYPE_MASK) !=3D
> +	      CRYPTO_ALG_TYPE_COMPRESS))

&& !(mask & CRYPTO_ALG_TESTED))

is missing here to allow ciphers to be self tested

> +		return ERR_PTR(-ENOENT);
> +
> +	return __crypto_alloc_tfm(alg, type, mask);
> +}
> +EXPORT_SYMBOL_GPL(__crypto_alloc_tfm_safe);
>  /*
>   *	crypto_alloc_base - Locate algorithm and allocate transform
>   *	@alg_name: Name of algorithm
> @@ -425,7 +446,7 @@ struct crypto_tfm *crypto_alloc_base(const char
> *alg_name, u32 type, u32 mask)
>  			goto err;
>  		}
>=20
> -		tfm =3D __crypto_alloc_tfm(alg, type, mask);
> +		tfm =3D __crypto_alloc_tfm_safe(alg, type, mask);
>  		if (!IS_ERR(tfm))
>  			return tfm;
>=20
> diff --git a/crypto/internal.h b/crypto/internal.h
> index bd39bfc..8526a37 100644
> --- a/crypto/internal.h
> +++ b/crypto/internal.h
> @@ -91,6 +91,8 @@ void crypto_remove_final(struct list_head *list);
>  void crypto_shoot_alg(struct crypto_alg *alg);
>  struct crypto_tfm *__crypto_alloc_tfm(struct crypto_alg *alg, u32 ty=
pe,
>  				      u32 mask);
> +struct crypto_tfm *__crypto_alloc_tfm_safe(struct crypto_alg *alg, u=
32
> type, +					   u32 mask);
>  void *crypto_create_tfm(struct crypto_alg *alg,
>  			const struct crypto_type *frontend);
>  struct crypto_alg *crypto_find_alg(const char *alg_name,


--=20
Ciao
Stephan
