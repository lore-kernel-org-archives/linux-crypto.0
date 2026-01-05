Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com [209.85.208.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C75B4320A2C
	for <linux-crypto@vger.kernel.org>; Mon,  5 Jan 2026 20:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767644402; cv=none; b=qFS1IMLtwUJpcjuFx8OohMYpZO3GSjueS1YseByZ/ZRFoQHuanBFtJCvaaQ7HiGJzMTbzAv8bvHBaauhwxKHsnCVStFhmrFZ7dNcDMBIeO7B0MmgGkJEDU1VJuowHGSzPE8Ra3SKDiDc/iRAvr5sPLBFqgDm+pNBuhDcOlQIxfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767644402; c=relaxed/simple;
	bh=erV/7hImZhxHV6hFL0eAvsX15yKory6E1e03cKjfxr4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZOytZb//y0hvvo8nAOmbDtVAuHdOb2Sq4JyhGyDwE+z10dZzzzsaavAnfn+o5ZvLA2pomPM2pF/lac/Udp4wL8rGjPXuApHbF7vo6MhCNr5r8lQe3Ulnr2CE/Q0UHu7CkZlcZ6pTi9JibFERk4M088th2LpHJnNrfCaDYSUqq04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloudflare.com; spf=pass smtp.mailfrom=cloudflare.com; dkim=pass (2048-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b=dDa7OOf9; arc=none smtp.client-ip=209.85.208.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloudflare.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cloudflare.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b="dDa7OOf9"
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-37ba5af5951so3173161fa.1
        for <linux-crypto@vger.kernel.org>; Mon, 05 Jan 2026 12:20:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google09082023; t=1767644399; x=1768249199; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8imYTE9fZ+fkXdg0Oayh+IU33w1fYi/u+y+9etIX+Q8=;
        b=dDa7OOf986Bn8AQ8Or14ROEMS5p95LkV+7LwkZF+jQ/QHpOEE4eP6YemnWrWCYB5yx
         /SbAoykMPAcOIQ7lMMvIIH62ajtbSAICa6oiihq2sjJ/coeK9vGMvMGrJW4R7SkeUJkT
         r3wVfcfQdOB5eQuQh0kf4Qc/T8EL+My2t0YT01vGGesau2ejM0TBw0gcs0SKH4tv2oE3
         9p4haVCgWnPkoNErSpRTKvfC8wzSbK6+pUEkRJxI0VCKXaEmgbkxlbW/UcAEMPFUluQ3
         1/eXKQckDoSD6wlEbXikmXeCAsJIe2OEnZZ2RbFw2fZdr1ibmlIbmHH2y6CcKG0PXSTb
         fv3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767644399; x=1768249199;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8imYTE9fZ+fkXdg0Oayh+IU33w1fYi/u+y+9etIX+Q8=;
        b=ex+xTlnsF5h6r8I9gZIvmGywDPTfn6O928NKkSprO0LIdw78Tilpe4w951ltblLvF2
         lwxKdqh7Yg4km53lafqmd1Ycfhj+4V1ypeyMo/rWjPnuKPc5s79DtpWEEpsHP5YtuMVF
         +MYrQAHTsl7a0hqXB3ka9DT14oA5bAxs8NnldGlSdcNO0LVyX77VF3wNM9cdgJc95yWS
         qIB3ohF38gWf+SPdFzhh9SDK7y/IkpmCtzxmE4RvsGe1xp3aAapHXTFh1Y+/hldBVes6
         Q0395N5DvjF2Y5SzPweG9XdjF2klwE2yS2PII2awB5nqSoMshFPaNSg9W/N0HKRpRsph
         hedg==
X-Forwarded-Encrypted: i=1; AJvYcCVNwoLf6BJDj1ESThESjesDnbpFSWhMxw8tsxKGMhiD6cxe2mTWa4OzQhVnPWpgAvuStiOPrWgJOYBsAYs=@vger.kernel.org
X-Gm-Message-State: AOJu0YzMzbEyqfT/Lg+x8DDu/HHOQUGSOv/JY+58jqr/OwTIYrJcYCLV
	2Sv+1yLIMYi5vHlFsrCV58bx3LdBrj6Exz9m8F3K5j8jrAC9IehF/XcO6fdrqypijZWJV+9CROP
	m969gKKkISCqybKRZfzCpEsWzpWi5rfpbU3txFlPVAg==
X-Gm-Gg: AY/fxX46zqtcEW7fLHSGxdIuyUFA+ZG39cCOBtAZHxBOfVTdj77GWMscKqz5FotbGz2
	PpZid0cVhzpNL8Dwme00yW/r5hmUkIUbxRflM7v88XBaoe6qLABwKO+t2QTUfOByv/JmvDjDp3f
	gbGuuaf7KSwJrTqAY1R8WzHqkjRItLnoJ4HazeV3ni2namWWgIQlxFtm3Vz+LJ3oyl36S2PqNO9
	yfpV5enqdEdLQcyh3YbDxqTJChtThA3/rxwWlFzepAPXUSqol57SOkiIK47aj2oJOKxCr9TeVBW
	ZqmUz2IVthS/2HQ=
X-Google-Smtp-Source: AGHT+IEnKyZPZAXVWl4XySHhAyeX1jQxNch1dZ7PUiMgSlQINGs89/Rye9DThfBkGuzHjxQfRHCo0ZVS2sSmWkjX4do=
X-Received: by 2002:a05:6512:b98:b0:598:eef2:d30d with SMTP id
 2adb3069b0e04-59b6525facbmr312799e87.44.1767644398750; Mon, 05 Jan 2026
 12:19:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260105152145.1801972-1-dhowells@redhat.com> <20260105152145.1801972-3-dhowells@redhat.com>
In-Reply-To: <20260105152145.1801972-3-dhowells@redhat.com>
From: Ignat Korchagin <ignat@cloudflare.com>
Date: Mon, 5 Jan 2026 20:19:47 +0000
X-Gm-Features: AQt7F2rv67S9698z3Pcf5z3TICLvtuIGkvngE4YX9ydSrQdbUONZrUF6YhFvpQQ
Message-ID: <CALrw=nFj9OEsREJ8Kxox3U6N8y=e00ZawxEkCPOb5-6_k=7+nQ@mail.gmail.com>
Subject: Re: [PATCH v11 2/8] pkcs7: Allow the signing algo to calculate the
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

On Mon, Jan 5, 2026 at 3:22=E2=80=AFPM David Howells <dhowells@redhat.com> =
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

Can we refactor this so we allocate the right size from the start.
Alternatively, should we just unconditionally use this approach
"overallocating" some times?

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

It seems this controls if we hash authenticated attributes, not the
data itself. Maybe reflect this in the name? Something like
do_authattrs_hash or authattrs_algo_passthrough?

>         const char *pkey_algo;
>         const char *hash_algo;
>         const char *encoding;
>

Ignat
