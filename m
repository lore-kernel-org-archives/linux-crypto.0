Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793989610;
	b=mRlvikQhKauCcKnsej6s3LO750VQZIA1leriwEzGqD5LJ0x9zpyXiomL9Z58Hqh9u5yg
	 80lc534noE5juArN7IKFkItn5GJJ94YsiTVM/bBwwQL5A8ZHPoc23kZWEIPx56AZ7pMaB
	 rbjBSRz19x1w5nNUTp4Q6YMc3med4RzFVhTM0ESjvvc+VuyoLiso2TptSpznPwTNYRH1O
	 bLsEsx9F0x73kQTvWyIC/hij0WU/FmiM/wdd/2N2JY9MO4XYFbRSPejlsilyKD6RldmNa
	 PVz2es9vbr7jJij5mrBUf6erLw491CCfLWQq3l9NuVHsZq4IrvLhQZoXgo3CLBln3Nw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793989610;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Received:
	 X-Forwarded-Encrypted:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=wspKiW0hD3dBrqADNHKAUvUnRHsMW1qUo4TQycTg8jY=;
	b=zMRfmz+mRW4UX7wb5dXFVUstb2a5XpIUE0Z4AQARRAmu9Auf5Gy9SeSAEg418kgAtC2G
	 xPr/VKz1AwCL09CIzCbCOm7MEVsTjDYIdPtjn/Vz5Vite73sKfI5Po7/yjOd107H0CRH6
	 4u0rTWtUfcu/Y9OvkOJwlx2Dx5YXqSQ8WlBTmmnBQFzvIUEny4W2/ffBUjGs576gYk0jM
	 PNViBDnjp+PuOKNCFKO7p4kTfCN2Kjio/5XnD6dzdR9YMPGOUHNGypBocicjV/WOEIWLF
	 sXKJCd+GF1O6SHByfgLBYEGPf4NK3wOPHilBCFT5yiTQw21c/B+mtCKX+zREX+PxIRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=linux.win;
	spf=pass smtp.mailfrom=gmail.com;
	arc=none smtp.remote-ip=209.85.208.51
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1722606A32F
	for <linux-crypto@vger.kernel.org>; Fri,  6 Nov 2026 18:26:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D1722606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.win
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-6b2237b596cso1823398a12.0
        for <linux-crypto@vger.kernel.org>; Fri, 06 Nov 2026 10:26:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793989608; x=1794594408;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wspKiW0hD3dBrqADNHKAUvUnRHsMW1qUo4TQycTg8jY=;
        b=GQyaF2dVTpzvokY7etMAcHCzLydSuBVKP3fD8XXkCQ5zBuodVTvEiRoe62wuyttWUF
         q1it4W8k3ANSj4i4EJ2t6j5wNEua5UHSe+alrE+mIZ6+WGGQMfEXP+SZfLJCTqvL3mQq
         oWIdNYxz7QfHwYlc90RKkUL0f0tx4zKZgdPKm69b1o563NRJLtvtl4GhNQQ4Pm5tkIGp
         LenqdqRW+iVgI+WBn3FBJs8yY/lpNrS/Zdw0eUqK2UVtiTlC3jrpbIbMikCDCAVIrCye
         RrVZDPn/c9I2iLWIGMw6Fq9w4+PVpdchExBqzx3gagk41vrfgZRPPHZZz4Dt0rFeWbKk
         wD7g==
X-Forwarded-Encrypted: i=1; AL+hErGjnckjMglfZUhhrMA7JFWFpJr8gqvUYP+dKhQdHcUteSBvrRt/0AhzcHadSmxh3QXKBswTgsg9SzMOBzM=@vger.kernel.org
X-Gm-Message-State: APuU4Z+65nuytI7QV3B3XNNhSdGeSDd2b1ldqPC+/O78tN82pR7IlvyS
	YLYZXpYS0UHvxiIKqh9eqED42KIGd4Yj6Ji5VOpdRdq3VdkIAtOwp52B6w0H/ecSHvc=
X-Gm-Gg: AYBFou3LnmRLqDJAuclZZzjA/nG3J4PuF8V+lnqf/kHXQ3pcm0dA4L2Ao64LNQcb7so
	GASfi4K8NYdTn2Iq/cooEuUzPFYx5g6jotwap8ZxIU4C/xdjQuJmKRIllM0TX50DaLaTvvXsEF9
	vBDXMIKHXlTtlY5dR7TSGQNzUYFd5cAZdpTxjuaONvqJsdbVpbGi++vZXZXzmYwM4M/doCwwMpA
	1EPdxHb8ME4cBKHvniSwqBUUENnFe0MkDeAGaROYXpy6H6BybpXKMQPHuUYChsvLlUlDxlJhWbv
	Z6y7lBWW5Mt+4GoEkGB1cXWYlsCtqcV3W3S0hS6m3qRFFWgiOOPujjLWKwQane0aX1x2Fq06rGg
	/jb91vePnSpjDt8VfxHTsDaLtEJmilRwE1FEIUK2S1J4ofnBQfWweMRJ8QpKi9VLWwfF9ZNWo/O
	Crp2Rpxx84RkD6nRI5Qlndnuf4MczyPnJzWJ8nI9KTTv3a5QMT3pRxqerGFIvV5W9/QERaYqsPZ
	cSUeV1qcRnqHFaIB0eWvCzd711rplPeetBTOLUnMdQhKthVAYXZSK+ae54/BV+gvP2o3u2uH2Wf
	NBGJluuG6JKc/q3DRQPk5Oml1IaTtkaipdqW5Fhc5R9MrxpjVVl+LKvvNIQ=
X-Received: by 2002:a05:6402:4414:b0:6b4:1629:b1aa with SMTP id 4fb4d7f45d1cf-6b59752af00mr2552457a12.2.1793989608112;
        Fri, 06 Nov 2026 10:26:48 -0800 (PST)
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com. [209.85.208.41])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b664ad2d0bsm950680a12.10.2026.11.06.10.26.46
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Nov 2026 10:26:47 -0800 (PST)
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-6b547d6c07bso1026205a12.1
        for <linux-crypto@vger.kernel.org>; Fri, 06 Nov 2026 10:26:46 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBx1rRj6/Xk5gcoRYIizLd1UP4MAuW9Wg/OgzEm6WL7jmR/9hnduXNr2gf9UpiR88sUnW0sQhOWkftkKLYE=@vger.kernel.org
X-Received: by 2002:a17:907:97c3:b0:c46:5973:2a1c with SMTP id
 a640c23a62f3a-c4d354f2af0mr301446066b.37.1793989606141; Fri, 06 Nov 2026
 10:26:46 -0800 (PST)
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20260928042641.307683-1-pawliczekerwin@gmail.com> <20261026034429.742489-1-pawliczekerwin@gmail.com>
In-Reply-To: <20261026034429.742489-1-pawliczekerwin@gmail.com>
From: Ignat Korchagin <ignat@linux.win>
Date: Fri, 6 Nov 2026 18:26:34 +0000
X-Gmail-Original-Message-ID: <CAOs+rJXfSBYrWTiuDDs=a=fHJjQfZmgiXtL+inOn_TEn+bDrqQ@mail.gmail.com>
X-Gm-Features: AclHuK-wbvCyvvqqMYIWIT3bx5pHhKw58mEs2iXFDK51EX3tNnHQ9F5CYVQcD20
Message-ID: <CAOs+rJXfSBYrWTiuDDs=a=fHJjQfZmgiXtL+inOn_TEn+bDrqQ@mail.gmail.com>
Subject: Re: [PATCH] crypto: ecc - Randomize the initial Z in ecc_make_pub_key()
To: Erwin Pawliczek <pawliczekerwin@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, "David S . Miller" <davem@davemloft.net>, 
	Lukas Wunner <lukas@wunner.de>, Stefan Berger <stefanb@linux.ibm.com>, 
	Randy Dunlap <rdunlap@infradead.org>, Paul Louvel <paul.louvel@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 26, 2026 at 3:44=E2=80=AFAM Erwin Pawliczek
<pawliczekerwin@gmail.com> wrote:
>
> ecc_make_pub_key() calls ecc_point_mult() without an initial Z, so the
> final Z, and therefore the input to vli_mod_inv(), is a deterministic
> function of the private key. vli_mod_inv() is not constant time, so
> key generation leaks information about the private key through its
> running time.
>
> crypto_ecdh_shared_secret() already passes a random initial Z, which
> blinds the inversion input. Do the same in ecc_make_pub_key().
>
> Key generation is used in the kernel by Bluetooth SMP and TPM2 HMAC
> sessions, which generate ephemeral P-256 keys.
>
> crypto_kpp_generate_public_key(), KVM guest on an i7-1165G7 (median
> over 4 boots of the best of 9 runs of 300 calls):
>
>     P-256:   744.9 us ->  753.2 us (+1.1%; within noise)
>     P-384:  1674.2 us -> 1651.6 us (-1.4%; within noise)
>
> Suggested-by: Ignat Korchagin <ignat@linux.win>
> Signed-off-by: Erwin Pawliczek <pawliczekerwin@gmail.com>

Reviewed-by: Ignat Korchagin <ignat@linux.win>

> ---
> Replaces "crypto: ecc - Use constant-time modular inversion in ecc_point_=
mult()":
> https://lore.kernel.org/all/20260928042641.307683-1-pawliczekerwin@gmail.=
com/
>
>  crypto/ecc.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
>
> diff --git a/crypto/ecc.c b/crypto/ecc.c
> index c7366eb7ce1f..6696bf0d90a6 100644
> --- a/crypto/ecc.c
> +++ b/crypto/ecc.c
> @@ -1614,20 +1614,26 @@ int ecc_make_pub_key(unsigned int curve_id, unsig=
ned int ndigits,
>  {
>         int ret =3D 0;
>         struct ecc_point *pk;
> +       u64 rand_z[ECC_MAX_DIGITS];
> +       unsigned int nbytes;
>         const struct ecc_curve *curve =3D ecc_get_curve(curve_id);
>
> -       if (!private_key) {
> +       if (!private_key || ndigits > ARRAY_SIZE(rand_z)) {
>                 ret =3D -EINVAL;
>                 goto out;
>         }
>
> +       nbytes =3D ndigits << ECC_DIGITS_TO_BYTES_SHIFT;
> +
> +       get_random_bytes(rand_z, nbytes);
> +
>         pk =3D ecc_alloc_point(ndigits);
>         if (!pk) {
>                 ret =3D -ENOMEM;
>                 goto out;
>         }
>
> -       ecc_point_mult(pk, &curve->g, private_key, NULL, curve, ndigits);
> +       ecc_point_mult(pk, &curve->g, private_key, rand_z, curve, ndigits=
);
>
>         /* SP800-56A rev 3 5.6.2.1.3 key check */
>         if (ecc_is_pubkey_valid_full(curve, pk)) {
> @@ -1641,6 +1647,7 @@ int ecc_make_pub_key(unsigned int curve_id, unsigne=
d int ndigits,
>  err_free_point:
>         ecc_free_point(pk);
>  out:
> +       memzero_explicit(rand_z, sizeof(rand_z));
>         return ret;
>  }
>  EXPORT_SYMBOL(ecc_make_pub_key);
> --
> 2.53.0
>
>
