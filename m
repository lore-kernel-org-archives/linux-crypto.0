Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEBEF43901C
	for <linux-crypto@vger.kernel.org>; Tue, 20 Jan 2026 14:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.178
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768917977; cv=pass; b=bZ5tB5H5U7XN7ikCqzmT6XmlBzmI9cgZeA2enTCw/pDweTBbL0Ko6LAleLLy8uIqCMEJYdp0i/UlK6LmELTYOe0GyU3HSs55ngVTlYuL0/KuIIltph6G8WnRkQKYYpwpPvRKUsjrEuVfuq5ISRTJ8lpfjL48oStLIJdY95Od+x8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768917977; c=relaxed/simple;
	bh=YK2c/N6z+9ArDdm+zc44ynJ17RZ2p78JcQ4HLMIlkFI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tnNkyVVHPdq/tkQzC73km4AzeR8hR96FXGlqCx7ZYAhztllx5A303bIqG1nTk1MT2+pqbSXvpxqr7H5LbMsvl3HS+z5zXQ4mWk4mnggE/p3y20sagK1YtdLH9QKdKwTKRRjelwIsQgsbvHEGF+/Ihp4fSp0YfFaB708oYIX7ttM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloudflare.com; spf=pass smtp.mailfrom=cloudflare.com; dkim=pass (2048-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b=PYoULEK4; arc=pass smtp.client-ip=209.85.208.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloudflare.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cloudflare.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b="PYoULEK4"
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-382fea4a160so51708441fa.2
        for <linux-crypto@vger.kernel.org>; Tue, 20 Jan 2026 06:06:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768917974; cv=none;
        d=google.com; s=arc-20240605;
        b=ge2CYBsOk/+sT/KliMZfGjrNpv2g99Se0B2SGTEz2G0ps7WnlHbouVPTRYwGas/eeP
         zgCpedG8OT7Ik6sbZ3hIhQg1MvM84PtfU+Bn/77P7OjLxE3BWz016aPx7QERqPUwtwIt
         WYIk6HoiN67AhLTmqwo9BOPWIIGBRpAi6BabBjRVso86kR7aPyToMkRXXLrPYDbWBR1Q
         xLzCKeickj26ELolg8HvlJvUuvAO78wK6thCuJiUvhoVZZan2lFE0JzrBsEihZv11va9
         X4mefuNEpY0sfyj7NGRPa/VLkQIOOVRH+XIPt2+Jqf1lgFcv+IiBEpyFKPDG9jN4wavG
         R+WA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=coebzWgpCcGie0B0iLVoXdMDPnL95oM6P6x36fKk/EY=;
        fh=6PSOudsKU0o3MCoGShRrp5wAbkL/j+mTbhmm4h6E+FA=;
        b=kUJk2f0h80QTfm7ZzjhyLPfa+gG/nUWOJo+gzTybj9ts+vvvf54WPU3VdL3TUgm5tS
         lquKDVj/9MXiuPn98QNnh1PAWyLVymUuYNZIggduG0J4KUZ1taxa45fvhTpg60SBs8be
         7WN0rnhKgSnI4ZshOPw6IDnHRn+GLy7cOf0r6iyrxmMQg1zwH7H33jcUBvdc/CPg9/2G
         oipQqWC25bgfLT7uNVoqn1popprWBWXu5q+0J+pDTWxumtKS2BaPCPSMs8bjP+Uob/E7
         3l8HO7SIoHlG3/HmquY3X0ptffPfXZ7MpW1CoBQgangG9iOYphgkOmZK4rcesfMFpmO7
         EO1Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google09082023; t=1768917974; x=1769522774; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=coebzWgpCcGie0B0iLVoXdMDPnL95oM6P6x36fKk/EY=;
        b=PYoULEK4cqitfrBlIQZhi3kBTcJ+4N1ROiEDanbo1dg1WfyOIkx6t5rW2nuJUV9UjM
         dy7Iz80h/Q8OrjKMs0wAC29Ed/+tYt8l3KFLwSUhWbYdWR0/UPdJDh5vOHAD6PGVLt4Z
         wFGwr7plHN1/0MWWvVGoF0P2Ycb+Pnj3JVRNtgfTZmsS+6j+xW+lF3nM+7GcDY18knjA
         mbl6pYs3dt+9c6N0OPuAZ1ScUp2RKzD0RUDmz2GyoKmSnMA8jvzrM5aRMvjWWTHO5dox
         2CHvvcz/jF/yOMCKU/9q35LF1xXj8m7iQUC4MiFwXTnoKXwk2Dx5StR/NS0HDUD4sll/
         VslA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768917974; x=1769522774;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=coebzWgpCcGie0B0iLVoXdMDPnL95oM6P6x36fKk/EY=;
        b=m2a2tUPvWgoOqMz4TTq/7jSfg0cmxL3HaS2TdbQ7b944ZnpvVGTBlU/MHa2rl/FOzg
         cwxBWH0a6kHT4KIYxLsjjFkZe5xQPa4zQl/MjSBmswYc/+UfdZLZ2s7v8P/1vpgd8Py3
         AHgkUi9sxL9D/XyXtfr53eYBKSF+SSnr8HyrzJSsEUF6isH1KH+FQ0z0lNEibITi69/T
         95HNfteex2YOIWiQ/K0GW5awVxJSm+a6/H5TpnofkxHX76mfVBxE+1z/R6Wita/oJaI7
         OJcW8npK6Lsv5eIU9VTLNmj0WItRW2rdeIjs4sVgaiJ5zhoMhOCtCqT9pln7DDNN579/
         05aQ==
X-Forwarded-Encrypted: i=1; AJvYcCWYTPpJQWTupdqWuufp0AFI2i3AtxqpA6l8+DgwpkydBNO3sM2gG7+5lc/l2AG6aR0TJ5PiTRTmqePgdv4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwmCYdYOq08eXbxS86CkNDaQR69HvndyfUSCv2hIx9VTxhEL4CF
	Pr6PHre6dQR6sq403lAByRKiP8VXoMY4ZDphSSzI3aRizzoTvqvrXTHG8/SwQVPnYmDwvrwNiji
	tyRb+mUxpxdBEhtPeUzMcs2aY5k4nMgUTLX+kZaSm7LvqEoWKrIPIOSM=
X-Gm-Gg: AZuq6aIZHdCsW53BjWNtONbEd4iLQnQsYMcTT9jdk/gGnU4Yc65CgKibQdremDNyP4X
	4t1aPaqRcPxVl8XA6um9pd2eY1MvlZBOzIpdexxl0Ejryz+M7Tw+NnoFOIwCKpbHbd6tXhB6UfB
	jspVox40rxp5XopjE9meOjZF++J6d+wfzzPZsov1hgo6DSjZs7o6Ie75LcADvG04E6GTlMZR1bU
	nxkKVq7GoUiUGF7KTjnLP8ThPtWz9DuOldLLexmjDAV8gA6czVaTHZDNJaaLSllmy9AWD0TxDit
	TTCyskk7BWQ=
X-Received: by 2002:a05:651c:31cd:b0:383:20cd:530d with SMTP id
 38308e7fff4ca-38384147aa6mr58209661fa.7.1768917973945; Tue, 20 Jan 2026
 06:06:13 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260115215100.312611-1-dhowells@redhat.com> <20260115215100.312611-3-dhowells@redhat.com>
In-Reply-To: <20260115215100.312611-3-dhowells@redhat.com>
From: Ignat Korchagin <ignat@cloudflare.com>
Date: Tue, 20 Jan 2026 14:06:02 +0000
X-Gm-Features: AZwV_Qig-WseM1AqWnFAmAYc7N-AnkJS9PkeaesylQLn3vd-pGi7_2LyqZ5fUb8
Message-ID: <CALrw=nH8zOXiyiCGkx1A533ijM=pyVebbhYCFpUyvP0bnjrXzA@mail.gmail.com>
Subject: Re: [PATCH v12 02/10] pkcs7: Allow the signing algo to calculate the
 digest itself
To: David Howells <dhowells@redhat.com>
Cc: Lukas Wunner <lukas@wunner.de>, Jarkko Sakkinen <jarkko@kernel.org>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Eric Biggers <ebiggers@kernel.org>, 
	Luis Chamberlain <mcgrof@kernel.org>, Petr Pavlu <petr.pavlu@suse.com>, 
	Daniel Gomez <da.gomez@kernel.org>, Sami Tolvanen <samitolvanen@google.com>, 
	"Jason A . Donenfeld" <Jason@zx2c4.com>, Ard Biesheuvel <ardb@kernel.org>, Stephan Mueller <smueller@chronox.de>, 
	linux-crypto@vger.kernel.org, keyrings@vger.kernel.org, 
	linux-modules@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi David,

On Thu, Jan 15, 2026 at 9:51=E2=80=AFPM David Howells <dhowells@redhat.com>=
 wrote:
>
> The ML-DSA public key algorithm really wants to calculate the message
> digest itself, rather than having the digest precalculated and fed to it
> separately as RSA does[*].  The kernel's PKCS#7 parser, however, is
> designed around the latter approach.
>
>   [*] ML-DSA does allow for an "external mu", but CMS doesn't yet have th=
at
>   standardised.
>
> Fix this by noting in the public_key_signature struct when the signing
> algorithm is going to want this and then, rather than doing the digest of
> the authenticatedAttributes ourselves and overwriting the sig->digest wit=
h
> that, replace sig->digest with a copy of the contents of the
> authenticatedAttributes section and adjust the digest length to match.
>
> This will then be fed to the public key algorithm as normal which can do
> what it wants with the data.
>
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Lukas Wunner <lukas@wunner.de>
> cc: Ignat Korchagin <ignat@cloudflare.com>
> cc: Stephan Mueller <smueller@chronox.de>
> cc: Eric Biggers <ebiggers@kernel.org>
> cc: Herbert Xu <herbert@gondor.apana.org.au>
> cc: keyrings@vger.kernel.org
> cc: linux-crypto@vger.kernel.org
> ---
>  crypto/asymmetric_keys/pkcs7_parser.c |  4 +--
>  crypto/asymmetric_keys/pkcs7_verify.c | 48 ++++++++++++++++++---------
>  include/crypto/public_key.h           |  1 +
>  3 files changed, 36 insertions(+), 17 deletions(-)
>
> diff --git a/crypto/asymmetric_keys/pkcs7_parser.c b/crypto/asymmetric_ke=
ys/pkcs7_parser.c
> index 423d13c47545..3cdbab3b9f50 100644
> --- a/crypto/asymmetric_keys/pkcs7_parser.c
> +++ b/crypto/asymmetric_keys/pkcs7_parser.c
> @@ -599,8 +599,8 @@ int pkcs7_sig_note_set_of_authattrs(void *context, si=
ze_t hdrlen,
>         }
>
>         /* We need to switch the 'CONT 0' to a 'SET OF' when we digest */
> -       sinfo->authattrs =3D value - (hdrlen - 1);
> -       sinfo->authattrs_len =3D vlen + (hdrlen - 1);
> +       sinfo->authattrs =3D value - hdrlen;
> +       sinfo->authattrs_len =3D vlen + hdrlen;
>         return 0;
>  }
>
> diff --git a/crypto/asymmetric_keys/pkcs7_verify.c b/crypto/asymmetric_ke=
ys/pkcs7_verify.c
> index 6d6475e3a9bf..0f9f515b784d 100644
> --- a/crypto/asymmetric_keys/pkcs7_verify.c
> +++ b/crypto/asymmetric_keys/pkcs7_verify.c
> @@ -70,8 +70,6 @@ static int pkcs7_digest(struct pkcs7_message *pkcs7,
>          * digest we just calculated.
>          */
>         if (sinfo->authattrs) {
> -               u8 tag;
> -
>                 if (!sinfo->msgdigest) {
>                         pr_warn("Sig %u: No messageDigest\n", sinfo->inde=
x);
>                         ret =3D -EKEYREJECTED;
> @@ -97,20 +95,40 @@ static int pkcs7_digest(struct pkcs7_message *pkcs7,
>                  * as the contents of the digest instead.  Note that we n=
eed to
>                  * convert the attributes from a CONT.0 into a SET before=
 we
>                  * hash it.
> +                *
> +                * However, for certain algorithms, such as ML-DSA, the d=
igest
> +                * is integrated into the signing algorithm.  In such a c=
ase,
> +                * we copy the authattrs, modifying the tag type, and set=
 that
> +                * as the digest.
>                  */
> -               memset(sig->digest, 0, sig->digest_size);
> -
> -               ret =3D crypto_shash_init(desc);
> -               if (ret < 0)
> -                       goto error;
> -               tag =3D ASN1_CONS_BIT | ASN1_SET;
> -               ret =3D crypto_shash_update(desc, &tag, 1);
> -               if (ret < 0)
> -                       goto error;
> -               ret =3D crypto_shash_finup(desc, sinfo->authattrs,
> -                                        sinfo->authattrs_len, sig->diges=
t);
> -               if (ret < 0)
> -                       goto error;
> +               if (sig->algo_does_hash) {
> +                       kfree(sig->digest);
> +
> +                       ret =3D -ENOMEM;
> +                       sig->digest =3D kmalloc(umax(sinfo->authattrs_len=
, sig->digest_size),
> +                                             GFP_KERNEL);

I'm still bothered by this "reallocation". You mentioned we need to do
some parsing for attributes, but it seems by the time this function is
called we have all the data to do something like
kmalloc(sig->algo_does_hash ? umax(sinfo->authattrs_len,
sig->digest_size) : sig->digest_size, GFP_KERNEL) during the initial
allocation. Or am I missing something?

> +                       if (!sig->digest)
> +                               goto error_no_desc;
> +
> +                       sig->digest_size =3D sinfo->authattrs_len;
> +                       memcpy(sig->digest, sinfo->authattrs, sinfo->auth=
attrs_len);
> +                       ((u8 *)sig->digest)[0] =3D ASN1_CONS_BIT | ASN1_S=
ET;
> +                       ret =3D 0;
> +               } else {
> +                       u8 tag =3D ASN1_CONS_BIT | ASN1_SET;
> +
> +                       ret =3D crypto_shash_init(desc);
> +                       if (ret < 0)
> +                               goto error;
> +                       ret =3D crypto_shash_update(desc, &tag, 1);
> +                       if (ret < 0)
> +                               goto error;
> +                       ret =3D crypto_shash_finup(desc, sinfo->authattrs=
 + 1,
> +                                                sinfo->authattrs_len - 1=
,
> +                                                sig->digest);
> +                       if (ret < 0)
> +                               goto error;
> +               }
>                 pr_devel("AADigest =3D [%*ph]\n", 8, sig->digest);
>         }
>
> diff --git a/include/crypto/public_key.h b/include/crypto/public_key.h
> index 81098e00c08f..e4ec8003a3a4 100644
> --- a/include/crypto/public_key.h
> +++ b/include/crypto/public_key.h
> @@ -46,6 +46,7 @@ struct public_key_signature {
>         u8 *digest;
>         u32 s_size;             /* Number of bytes in signature */
>         u32 digest_size;        /* Number of bytes in digest */
> +       bool algo_does_hash;    /* Public key algo does its own hashing *=
/

nit: still do not like this name, but have no better alternatives so far

>         const char *pkey_algo;
>         const char *hash_algo;
>         const char *encoding;
>

Ignat
