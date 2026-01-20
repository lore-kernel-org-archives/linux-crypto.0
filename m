Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 863A2426EB3
	for <linux-crypto@vger.kernel.org>; Tue, 20 Jan 2026 14:26:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768919203; cv=pass; b=FPoiFpl3pf5qxGqO8YFeO4aXTfYb0O0Z5DwlrrsWknbPGj8RDxmKCg1RJ5kmqUuDz/wCM7KeVCBY5vNtN0+jF2d79mY1D06qFxPn9hMlCv4DeXNdzSoD+UjcCDvQxW1e03Pzka4u1poaVU4b/7A9M/tFNil1u9gtouZgt+a5DbY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768919203; c=relaxed/simple;
	bh=QCUDSMlskNb3W9hlYknvFO06WK3AaORHPIrE66uCBys=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NqEavUmnGCaF+j3+068v1PeLjmYD+3TTmkO3wSFXFXCnRGkSvknszV60pCl/KjutIuOURduxmtP+chxccQs/TcbzO9XREuapIDZyufFxb7rTn68ukgtjI8TddGfsIdMBSxzSdGJoBWjmFHUOpCul9GM41gIvfycmIUJqDNlK9zg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloudflare.com; spf=pass smtp.mailfrom=cloudflare.com; dkim=pass (2048-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b=VdI0hQmy; arc=pass smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloudflare.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cloudflare.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b="VdI0hQmy"
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-598f8136a24so6232415e87.3
        for <linux-crypto@vger.kernel.org>; Tue, 20 Jan 2026 06:26:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768919199; cv=none;
        d=google.com; s=arc-20240605;
        b=Y0l0z73adFLQ2wn5YzOWeU5e/Lx/vfBPSd32tUE/1eSi3+U4PWJAyd/cVp946+fkDt
         cPYsQPeUMGUejsZAOqxSl/roplfjLLxVd06zGS+m7r4+2gXOBzrX1iaQOlT6IFGmuQla
         mMQmd9B785Y0N+a4Dzz/YvsLZ5xKWE11PxR43VaI64VjU3c8HUDulf1ae3vKrQ8DN+Zu
         7vghTlXeAXBAxZq/pHzHdPgnJ8U1xqgCpDAe48eB+NSNUAC7m6XB9GhJA6uOkxfUriFw
         soAeicjZh2Wm95YSu/pDYVDtDxuj87TSucF5pXlLg0S6ithHCIAWYYNiTPdqeZ6i7HDK
         RDUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=j+y0XNEyJZqJ0cJubEJQ2uLanbXj9PPXMmxI3R28pZA=;
        fh=Pv/YiQ9Y/VAyi5ZlXD+HlpX698TFlmXv0K5idZS3Bds=;
        b=l1chx2T16qoZMcmXALxwyDR5J2BIx5r/aISiIpTzzZzvNE4U5dHqWz2NVYm3CUCQYY
         uuVsY9HLf8Ld5kl10rxUGONjD6Iy4WyORJE8I63RH2MSE+OsiOOijujIlLqtIskq7vfX
         5cakQhUQ3/msJV3nweEgK9r3lH7EkTAnKptuZuzzpYZUi6PkUmrFrHHWVwJMbuT7OSjv
         5yrwLFWH+EutRwUDQHiqSsfh6s49bz0yW4Fun9VEEp7/4QJH3ZymFpvkZJa9ir0GSPZf
         KAN94QdvRDhq35Icx+htiD1MEkJsXhnNRYeizJzLEopQolDMiAmm5qm3g64hsYxfjIt2
         78jw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google09082023; t=1768919199; x=1769523999; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j+y0XNEyJZqJ0cJubEJQ2uLanbXj9PPXMmxI3R28pZA=;
        b=VdI0hQmytenS+jbFR8JWN8bQGr1oP/VMIXkr1zY36MqdnYmyKK8SXQ9DFxQ8rk8eJh
         JpO71mVj7wECk8qKxajEDh5u8ZW+vFTWiMZTti+5eoIs8FKaTr8RZl0t9G9d1i/KPrbq
         vVNbuDGgPhsnmmdWwOvf06hlx8as25/1+Xwc7HGnOpXOEjaLxFRWIbMItpVyDJlFMciG
         cCP3dl8Q+gp2R0sI77ISUX6MhR08xraJvYcFCPBkBXkfnwSY+vnm5rwgp+nopr3ZQrxD
         3k2dxIygFGwsVI9xn7IjnpyuSrtg7wn5ARRRXUej55KPwKr2uAyfAhG+fepzERlyTwGQ
         uYZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768919199; x=1769523999;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=j+y0XNEyJZqJ0cJubEJQ2uLanbXj9PPXMmxI3R28pZA=;
        b=Q1O45jaH4oBWbCt7wFSwjg21mXw3fi9SMnLqRrnm/f1JKTVjxXP4wj8FjPHQ4/ceXr
         +g4G9L82pL0Mq73u17o47t7SKfVZ+GFia3PUvChsIS0Ue0sVGwfsw4nrK/YMK6bBXiaJ
         XP2KXvLAq9LJhvshjRdSXR6PdDdnHrknMdSqg3Oxgz5PdGXaPz0IjmzOnoZN+ZbySYNz
         KRDOmYg7DoJTXICJH4S19NESnx3dcv4QmMRdFjAtLI222r8TFURJCXnNTMMM47MEeo4R
         Y+FkFj0BZ1lw1E5qCb74oS8flC+A0jXEHRf9TSdBQxWTguSM0q896sktLEio+OExaqZC
         bVpA==
X-Forwarded-Encrypted: i=1; AJvYcCXW3NttvEA0ukDJDjAVYvS07hECz8BIN07Z6WulSpCsuwmOPmuM+QAmVWSKSeR1OjC6Tr3GSxguww3ZNhk=@vger.kernel.org
X-Gm-Message-State: AOJu0YyWKpurGbna0J9fZCS2DoTEZQMLnsB/3+xA++1DVS0l66Em5iPb
	uuAVXScWvtR44xMImiOl/vf3N/HFktTFnCVbPb5O3i5S/+0cBw+DM6lXDuviGOBRn0aM0g/4vKh
	WjHEEikL1oawbyhS8X/vrRif2tN7ew7ehcljpI2eIew==
X-Gm-Gg: AZuq6aKYEheOafV7e5zAei9hkv13MmngyNzSCJGnRCKWD1tkJJpqer/gN9XeQiyeBGp
	bQk9LqZXZb7lbx84xu/ttQQH6LFasIfgCMTI21YupmKsh2nCYZj0y29eIxIPNyB06NJTMopzFvE
	eXzT8ERulUvVuIKbXJ95V0jkLAEKlobpBPYquQUw+sBQsXhchFy6PGyWKLVeLnVTj0+GSuPdkOf
	i8mNPXTyLuC1qFkZy4uYrnPtQJNIPo0GngdGpZ4EfMJoZ/4NL7ppC5nuzeUP07yobKctN56wapR
	HRz3PNWNlbI=
X-Received: by 2002:a05:6512:3e18:b0:59b:4213:7587 with SMTP id
 2adb3069b0e04-59baffbf254mr4497256e87.27.1768919198478; Tue, 20 Jan 2026
 06:26:38 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260115215100.312611-1-dhowells@redhat.com> <20260115215100.312611-8-dhowells@redhat.com>
In-Reply-To: <20260115215100.312611-8-dhowells@redhat.com>
From: Ignat Korchagin <ignat@cloudflare.com>
Date: Tue, 20 Jan 2026 14:26:26 +0000
X-Gm-Features: AZwV_QipPdJflh9cHYaRR7wlshA2f9qAKN5Q6O0QXOsc-HZaHvJ9O1uUzfNJuw0
Message-ID: <CALrw=nFwF7pUG81hBaPd4=GfXGUmBFW1Krc1XVo9qDqCptDMzQ@mail.gmail.com>
Subject: Re: [PATCH v12 07/10] crypto: Add RSASSA-PSS support
To: David Howells <dhowells@redhat.com>
Cc: Lukas Wunner <lukas@wunner.de>, Jarkko Sakkinen <jarkko@kernel.org>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Eric Biggers <ebiggers@kernel.org>, 
	Luis Chamberlain <mcgrof@kernel.org>, Petr Pavlu <petr.pavlu@suse.com>, 
	Daniel Gomez <da.gomez@kernel.org>, Sami Tolvanen <samitolvanen@google.com>, 
	"Jason A . Donenfeld" <Jason@zx2c4.com>, Ard Biesheuvel <ardb@kernel.org>, Stephan Mueller <smueller@chronox.de>, 
	linux-crypto@vger.kernel.org, keyrings@vger.kernel.org, 
	linux-modules@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tadeusz Struk <tadeusz.struk@intel.com>, "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 15, 2026 at 9:51=E2=80=AFPM David Howells <dhowells@redhat.com>=
 wrote:
>
> Add support for RSASSA-PSS [RFC8017 sec 8.1] signature verification suppo=
rt
> to the RSA driver in crypto/.  Note that signing support is not provided.
>
> The verification function requires an info string formatted as a
> space-separated list of key=3Dvalue pairs.  The following parameters need=
 to
> be provided:
>
>  (1) sighash=3D<algo>
>
>      The hash algorithm to be used to digest the data.
>
>  (2) pss_mask=3D<type>,...
>
>      The mask generation function (MGF) and its parameters.
>
>  (3) pss_salt=3D<len>
>
>      The length of the salt used.
>
> The only MGF currently supported is "mgf1".  This takes an additional
> parameter indicating the mask-generating hash (which need not be the same
> as the data hash).  E.g.:
>
>      "sighash=3Dsha256 pss_mask=3Dmgf1,sha256 pss_salt=3D32"
>
> Signed-off-by: David Howells <dhowells@redhat.com>

Reviewed-by: Ignat Korchagin <ignat@cloudflare.com>

> cc: Tadeusz Struk <tadeusz.struk@intel.com>
> cc: Herbert Xu <herbert@gondor.apana.org.au>
> cc: David S. Miller <davem@davemloft.net>
> cc: Lukas Wunner <lukas@wunner.de>
> cc: Ignat Korchagin <ignat@cloudflare.com>
> cc: keyrings@vger.kernel.org
> cc: linux-crypto@vger.kernel.org
> ---
>  crypto/Makefile               |   1 +
>  crypto/rsa.c                  |   8 +
>  crypto/rsassa-pss.c           | 384 ++++++++++++++++++++++++++++++++++
>  include/crypto/hash.h         |   3 +
>  include/crypto/internal/rsa.h |   2 +
>  5 files changed, 398 insertions(+)
>  create mode 100644 crypto/rsassa-pss.c
>
> diff --git a/crypto/Makefile b/crypto/Makefile
> index 267d5403045b..5c91440d1751 100644
> --- a/crypto/Makefile
> +++ b/crypto/Makefile
> @@ -50,6 +50,7 @@ rsa_generic-y +=3D rsa.o
>  rsa_generic-y +=3D rsa_helper.o
>  rsa_generic-y +=3D rsa-pkcs1pad.o
>  rsa_generic-y +=3D rsassa-pkcs1.o
> +rsa_generic-y +=3D rsassa-pss.o
>  obj-$(CONFIG_CRYPTO_RSA) +=3D rsa_generic.o
>
>  $(obj)/ecdsasignature.asn1.o: $(obj)/ecdsasignature.asn1.c $(obj)/ecdsas=
ignature.asn1.h
> diff --git a/crypto/rsa.c b/crypto/rsa.c
> index 6c7734083c98..189a09d54c16 100644
> --- a/crypto/rsa.c
> +++ b/crypto/rsa.c
> @@ -10,6 +10,7 @@
>  #include <linux/mpi.h>
>  #include <crypto/internal/rsa.h>
>  #include <crypto/internal/akcipher.h>
> +#include <crypto/internal/sig.h>
>  #include <crypto/akcipher.h>
>  #include <crypto/algapi.h>
>
> @@ -414,8 +415,14 @@ static int __init rsa_init(void)
>         if (err)
>                 goto err_unregister_rsa_pkcs1pad;
>
> +       err =3D crypto_register_sig(&rsassa_pss_alg);
> +       if (err)
> +               goto err_rsassa_pss;
> +
>         return 0;
>
> +err_rsassa_pss:
> +       crypto_unregister_template(&rsassa_pkcs1_tmpl);
>  err_unregister_rsa_pkcs1pad:
>         crypto_unregister_template(&rsa_pkcs1pad_tmpl);
>  err_unregister_rsa:
> @@ -425,6 +432,7 @@ static int __init rsa_init(void)
>
>  static void __exit rsa_exit(void)
>  {
> +       crypto_unregister_sig(&rsassa_pss_alg);
>         crypto_unregister_template(&rsassa_pkcs1_tmpl);
>         crypto_unregister_template(&rsa_pkcs1pad_tmpl);
>         crypto_unregister_akcipher(&rsa);
> diff --git a/crypto/rsassa-pss.c b/crypto/rsassa-pss.c
> new file mode 100644
> index 000000000000..c12ffa3813df
> --- /dev/null
> +++ b/crypto/rsassa-pss.c
> @@ -0,0 +1,384 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/*
> + * RSA Signature Scheme combined with EMSA-PSS encoding (RFC 8017 sec 8.=
2)
> + *
> + * https://www.rfc-editor.org/rfc/rfc8017#section-8.1
> + *
> + * Copyright (c) 2025 Red Hat
> + */
> +
> +#define pr_fmt(fmt) "RSAPSS: "fmt
> +#include <linux/ctype.h>
> +#include <linux/module.h>
> +#include <linux/oid_registry.h>
> +#include <linux/parser.h>
> +#include <linux/scatterlist.h>
> +#include <crypto/akcipher.h>
> +#include <crypto/algapi.h>
> +#include <crypto/hash.h>
> +#include <crypto/sig.h>
> +#include <crypto/internal/akcipher.h>
> +#include <crypto/internal/rsa.h>
> +#include <crypto/internal/sig.h>
> +
> +struct rsassa_pss_ctx {
> +       struct crypto_akcipher *rsa;
> +       unsigned int    key_size;
> +       unsigned int    salt_len;
> +       char            *pss_hash;
> +       char            *mgf1_hash;
> +};
> +
> +enum {
> +       rsassa_pss_verify_hash_algo,
> +       rsassa_pss_verify_pss_mask,
> +       rsassa_pss_verify_pss_salt,
> +};
> +
> +static const match_table_t rsassa_pss_verify_params =3D {
> +       { rsassa_pss_verify_hash_algo,  "sighash=3D%s" },
> +       { rsassa_pss_verify_pss_mask,   "pss_mask=3D%s" },
> +       { rsassa_pss_verify_pss_salt,   "pss_salt=3D%u" },
> +       {}
> +};
> +
> +/*
> + * Parse the signature parameters out of the info string.
> + */
> +static int rsassa_pss_vinfo_parse(struct rsassa_pss_ctx *ctx,
> +                                 char *info)
> +{
> +       substring_t args[MAX_OPT_ARGS];
> +       char *p;
> +
> +       ctx->pss_hash =3D NULL;
> +       ctx->mgf1_hash =3D NULL;
> +       ctx->salt_len =3D 0;
> +
> +       while ((p =3D strsep(&info, " \t"))) {
> +               if (*p =3D=3D '\0' || *p =3D=3D ' ' || *p =3D=3D '\t')
> +                       continue;
> +
> +               switch (match_token(p, rsassa_pss_verify_params, args)) {
> +               case rsassa_pss_verify_hash_algo:
> +                       *args[0].to =3D 0;
> +                       ctx->pss_hash =3D args[0].from;
> +                       break;
> +               case rsassa_pss_verify_pss_mask:
> +                       if (memcmp(args[0].from, "mgf1", 4) !=3D 0)
> +                               return -ENOPKG;
> +                       if (args[0].from[4] !=3D ',')
> +                               return -EINVAL;
> +                       args[0].from +=3D 5;
> +                       if (args[0].from >=3D args[0].to)
> +                               return -EINVAL;
> +                       *args[0].to =3D 0;
> +                       ctx->mgf1_hash =3D args[0].from;
> +                       break;
> +               case rsassa_pss_verify_pss_salt:
> +                       if (match_uint(&args[0], &ctx->salt_len) < 0)
> +                               return -EINVAL;
> +                       break;
> +               default:
> +                       pr_debug("Unknown info param\n");
> +                       return -EINVAL; /* Ignoring it might be better. *=
/
> +               }
> +       }
> +
> +       if (!ctx->pss_hash ||
> +           !ctx->mgf1_hash ||
> +           !ctx->salt_len)
> +               return -EINVAL;
> +       return 0;
> +}
> +
> +/*
> + * Perform mask =3D MGF1(mgfSeed, masklen) - RFC8017 appendix B.2.1.
> + */
> +static int MGF1(struct rsassa_pss_ctx *ctx,
> +               const u8 *mgfSeed, unsigned int mgfSeed_len,
> +               u8 *mask, unsigned int maskLen)
> +{
> +       unsigned int counter, count_to, hLen, T_len;
> +       __be32 *C;
> +       int err;
> +       u8 *T, *t, *to_hash;
> +
> +       struct crypto_shash *hash_tfm __free(crypto_free_shash) =3D
> +               crypto_alloc_shash(ctx->mgf1_hash, 0, 0);
> +       if (IS_ERR(hash_tfm))
> +               return PTR_ERR(hash_tfm);
> +
> +       hLen =3D crypto_shash_digestsize(hash_tfm);
> +       count_to =3D DIV_ROUND_UP(maskLen, hLen);
> +       T_len =3D hLen * count_to;
> +
> +       struct shash_desc *Hash __free(kfree) =3D
> +               kmalloc(roundup(sizeof(struct shash_desc) +
> +                               crypto_shash_descsize(hash_tfm), 64) +
> +                       roundup(T_len, 64) + /* T */
> +                       roundup(mgfSeed_len + 4, 64), /* mgfSeed||C */
> +                       GFP_KERNEL);
> +       if (!Hash)
> +               return -ENOMEM;
> +
> +       Hash->tfm =3D hash_tfm;
> +
> +       /* 2: Let T be the empty octet string. */
> +       T =3D (void *)Hash +
> +               roundup(sizeof(struct shash_desc) +
> +                       crypto_shash_descsize(hash_tfm), 64);
> +
> +       /* 3: Generate the mask. */
> +       to_hash =3D T + roundup(T_len, 64);
> +       memcpy(to_hash, mgfSeed, mgfSeed_len);
> +       C =3D (__be32 *)(to_hash + mgfSeed_len);
> +
> +       t =3D T;
> +       for (counter =3D 0; counter < count_to; counter++) {
> +               /* 3A: C =3D I2OSP(counter, 4). */
> +               put_unaligned_be32(counter, C);
> +
> +               /* 3B: T =3D T || Hash(mgfSeed || C). */
> +               err =3D crypto_shash_digest(Hash, to_hash, mgfSeed_len + =
4, t);
> +               if (err < 0)
> +                       return err;
> +
> +               t +=3D hLen;
> +       }
> +
> +       /* 4: Output T to mask */
> +       memcpy(mask, T, maskLen);
> +       return 0;
> +}
> +
> +/*
> + * Perform EMSA-PSS-VERIFY(M, EM, emBits) - RFC8017 sec 9.1.2.
> + */
> +static int emsa_pss_verify(struct rsassa_pss_ctx *ctx,
> +                          const u8 *M, unsigned int M_len,
> +                          const u8 *EM, unsigned int emLen)
> +{
> +       unsigned int emBits, hLen, sLen, DB_len;
> +       const u8 *maskedDB, *H;
> +       u8 *mHash, *dbMask, *DB, *salt, *Mprime, *Hprime;
> +       int err, i;
> +
> +       emBits =3D 8 - fls(EM[0]);
> +       emBits =3D emLen * 8 - emBits;
> +
> +       struct crypto_shash *hash_tfm __free(crypto_free_shash) =3D
> +               crypto_alloc_shash(ctx->pss_hash, 0, 0);
> +       if (IS_ERR(hash_tfm))
> +               return PTR_ERR(hash_tfm);
> +
> +       hLen =3D crypto_shash_digestsize(hash_tfm);
> +       sLen =3D ctx->salt_len;
> +
> +       if (sLen > 65536 ||
> +           emBits < 8 * (hLen + sLen) + 9)
> +               return -EBADMSG;
> +
> +       DB_len =3D emLen - hLen - 1;
> +
> +       struct shash_desc *Hash __free(kfree) =3D
> +               kmalloc(roundup(sizeof(struct shash_desc) +
> +                               crypto_shash_descsize(hash_tfm), 64) +
> +                       roundup(hLen, 64) + /* mHash */
> +                       roundup(DB_len, 64) + /* DB and dbMask */
> +                       roundup(8 + hLen + sLen, 64) + /* M' */
> +                       roundup(hLen, 64), /* H' */
> +                       GFP_KERNEL);
> +       if (!Hash)
> +               return -ENOMEM;
> +
> +       Hash->tfm =3D hash_tfm;
> +
> +       mHash =3D (void *)Hash +
> +               roundup(sizeof(struct shash_desc) +
> +                       crypto_shash_descsize(hash_tfm), 64);
> +       DB =3D dbMask =3D mHash + roundup(hLen, 64);
> +       Mprime =3D dbMask + roundup(DB_len, 64);
> +       Hprime =3D Mprime + roundup(8 + hLen + sLen, 64);
> +
> +       /* 1. Check len M against hash input limitation. */
> +       /* The standard says ~2EiB for SHA1, so I think we can ignore thi=
s. */
> +
> +       /* 2. mHash =3D Hash(M).
> +        * In theory, we would do:
> +        *      err =3D crypto_shash_digest(Hash, M, M_len, mHash);
> +        * but the caller is assumed to already have done that for us.
> +        */
> +       if (M_len !=3D hLen)
> +               return -EINVAL;
> +       memcpy(mHash, M, hLen);
> +
> +       /* 3. Check emLen against hLen + sLen + 2. */
> +       if (emLen < hLen + sLen + 2)
> +               return -EBADMSG;
> +
> +       /* 4. Validate EM. */
> +       if (EM[emLen - 1] !=3D 0xbc)
> +               return -EKEYREJECTED;
> +
> +       /* 5. Pick maskedDB and H. */
> +       maskedDB =3D EM;
> +       H =3D EM + DB_len;
> +
> +       /* 6. Check leftmost 8emLen-emBits bits of maskedDB are 0. */
> +       /* Can only find emBits by counting the zeros on the Left. */
> +
> +       /* 7. Let dbMask =3D MGF(H, emLen - hLen - 1). */
> +       err =3D MGF1(ctx, H, hLen, dbMask, DB_len);
> +       if (err < 0)
> +               return err;
> +
> +       /* 8. Let DB =3D maskedDB XOR dbMask. */
> +       for (i =3D 0; i < DB_len; i++)
> +               DB[i] =3D maskedDB[i] ^ dbMask[i];
> +
> +       /* 9. Set leftmost bits in DB to zero. */
> +       int z =3D 8 * emLen - emBits;
> +
> +       if (z > 0) {
> +               if (z >=3D 8) {
> +                       DB[0] =3D 0;
> +               } else {
> +                       z =3D 8 - z;
> +                       DB[0] &=3D (1 << z) - 1;
> +               }
> +       }
> +
> +       /* 10. Check the left part of DB is {0,0,...,1}. */
> +       for (i =3D 0; i < emLen - hLen - sLen - 2; i++)
> +               if (DB[i] !=3D 0)
> +                       return -EKEYREJECTED;
> +       if (DB[i] !=3D 0x01)
> +               return -EKEYREJECTED;
> +
> +       /* 11. Let salt be the last sLen octets of DB. */
> +       salt =3D DB + DB_len - sLen;
> +
> +       /* 12. Let M' be 00 00 00 00 00 00 00 00 || mHash || salt. */
> +       memset(Mprime, 0, 8);
> +       memcpy(Mprime + 8, mHash, hLen);
> +       memcpy(Mprime + 8 + hLen, salt, sLen);
> +
> +       /* 13. Let H' =3D Hash(M'). */
> +       err =3D crypto_shash_digest(Hash, Mprime, 8 + hLen + sLen, Hprime=
);
> +       if (err < 0)
> +               return err;
> +
> +       /* 14. Check H =3D H'. */
> +       if (memcmp(H, Hprime, hLen) !=3D 0)
> +               return -EKEYREJECTED;
> +       return 0;
> +}
> +
> +/*
> + * Perform RSASSA-PSS-VERIFY((n,e),M,S) - RFC8017 sec 8.1.2.
> + */
> +static int rsassa_pss_verify(struct crypto_sig *tfm,
> +                            const void *src, unsigned int slen,
> +                            const void *digest, unsigned int dlen,
> +                            const char *info)
> +{
> +       struct rsassa_pss_ctx *ctx =3D crypto_sig_ctx(tfm);
> +       struct crypto_wait cwait;
> +       struct scatterlist sg;
> +       unsigned int rsa_reqsize =3D crypto_akcipher_reqsize(ctx->rsa);
> +       u8 *EM;
> +       int err;
> +
> +       if (!info)
> +               return -EINVAL;
> +
> +       char *str __free(kfree) =3D kstrdup(info, GFP_KERNEL);
> +       if (!str)
> +               return -ENOMEM;
> +
> +       err =3D rsassa_pss_vinfo_parse(ctx, str);
> +       if (err < 0)
> +               return err;
> +
> +       /* RFC8017 sec 8.1.2 step 1 - length checking */
> +       if (!ctx->key_size || slen !=3D ctx->key_size)
> +               return -EINVAL;
> +
> +       /* RFC8017 sec 8.1.2 step 2 - RSA verification */
> +       struct akcipher_request *rsa_req __free(kfree) =3D
> +               kmalloc(sizeof(*rsa_req) + rsa_reqsize + ctx->key_size,
> +                       GFP_KERNEL);
> +       if (!rsa_req)
> +               return -ENOMEM;
> +
> +       EM =3D (u8 *)(rsa_req + 1) + rsa_reqsize;
> +       memcpy(EM, src, slen);
> +
> +       crypto_init_wait(&cwait);
> +       sg_init_one(&sg, EM, slen);
> +       akcipher_request_set_tfm(rsa_req, ctx->rsa);
> +       akcipher_request_set_crypt(rsa_req, &sg, &sg, slen, slen);
> +       akcipher_request_set_callback(rsa_req, CRYPTO_TFM_REQ_MAY_SLEEP,
> +                                     crypto_req_done, &cwait);
> +
> +       err =3D crypto_akcipher_encrypt(rsa_req);
> +       err =3D crypto_wait_req(err, &cwait);
> +       if (err)
> +               return err;
> +
> +       /* RFC 8017 sec 8.1.2 step 3 - EMSA-PSS(M, EM, modbits-1) */
> +       return emsa_pss_verify(ctx, digest, dlen, EM, slen);
> +}
> +
> +static unsigned int rsassa_pss_key_size(struct crypto_sig *tfm)
> +{
> +       struct rsassa_pss_ctx *ctx =3D crypto_sig_ctx(tfm);
> +
> +       return ctx->key_size * BITS_PER_BYTE;
> +}
> +
> +static int rsassa_pss_set_pub_key(struct crypto_sig *tfm,
> +                                   const void *key, unsigned int keylen)
> +{
> +       struct rsassa_pss_ctx *ctx =3D crypto_sig_ctx(tfm);
> +
> +       return rsa_set_key(ctx->rsa, &ctx->key_size, RSA_PUB, key, keylen=
);
> +}
> +
> +static int rsassa_pss_init_tfm(struct crypto_sig *tfm)
> +{
> +       struct crypto_akcipher *rsa;
> +       struct rsassa_pss_ctx *ctx =3D crypto_sig_ctx(tfm);
> +
> +       rsa =3D crypto_alloc_akcipher("rsa", 0, 0);
> +       if (IS_ERR(rsa))
> +               return PTR_ERR(rsa);
> +
> +       ctx->rsa =3D rsa;
> +       return 0;
> +}
> +
> +static void rsassa_pss_exit_tfm(struct crypto_sig *tfm)
> +{
> +       struct rsassa_pss_ctx *ctx =3D crypto_sig_ctx(tfm);
> +
> +       crypto_free_akcipher(ctx->rsa);
> +}
> +
> +struct sig_alg rsassa_pss_alg =3D {
> +       .verify         =3D rsassa_pss_verify,
> +       .set_pub_key    =3D rsassa_pss_set_pub_key,
> +       .key_size       =3D rsassa_pss_key_size,
> +       .init           =3D rsassa_pss_init_tfm,
> +       .exit           =3D rsassa_pss_exit_tfm,
> +       .base =3D {
> +               .cra_name        =3D "rsassa-pss",
> +               .cra_driver_name =3D "rsassa-pss-generic",
> +               .cra_priority    =3D 100,
> +               .cra_module      =3D THIS_MODULE,
> +               .cra_ctxsize     =3D sizeof(struct rsassa_pss_ctx),
> +       },
> +};
> +
> +MODULE_ALIAS_CRYPTO("rsassa-pss");
> diff --git a/include/crypto/hash.h b/include/crypto/hash.h
> index 586700332c73..49b1ea5cf78d 100644
> --- a/include/crypto/hash.h
> +++ b/include/crypto/hash.h
> @@ -779,6 +779,9 @@ static inline void crypto_free_shash(struct crypto_sh=
ash *tfm)
>         crypto_destroy_tfm(tfm, crypto_shash_tfm(tfm));
>  }
>
> +DEFINE_FREE(crypto_free_shash, struct crypto_shash*,
> +           if (!IS_ERR_OR_NULL(_T)) { crypto_free_shash(_T); });
> +
>  static inline const char *crypto_shash_alg_name(struct crypto_shash *tfm=
)
>  {
>         return crypto_tfm_alg_name(crypto_shash_tfm(tfm));
> diff --git a/include/crypto/internal/rsa.h b/include/crypto/internal/rsa.=
h
> index 071a1951b992..d7f38a273949 100644
> --- a/include/crypto/internal/rsa.h
> +++ b/include/crypto/internal/rsa.h
> @@ -83,4 +83,6 @@ static inline int rsa_set_key(struct crypto_akcipher *c=
hild,
>
>  extern struct crypto_template rsa_pkcs1pad_tmpl;
>  extern struct crypto_template rsassa_pkcs1_tmpl;
> +extern struct sig_alg rsassa_pss_alg;
> +
>  #endif
>
