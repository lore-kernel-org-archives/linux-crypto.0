Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793988769;
	b=MjOApZtKWg+qxO8QFU7n41gUy3SDLfd2Nd+KxQ0cw+X8yiAQgKE+POIfquYSUwv8+VWa
	 c57KEprvO5IBMViKjrEt1YamNM4CfqIYUt/OK6ubI9+sPSwR6ofwpn0sATpmw5k2rYFwr
	 tZgD2YAJ6pWqSNFNyjXhamNnz7LkIX/zza81mM2MxSqc75hoXDQdvi/teKmYT69S79bgS
	 +0wEu1oj+VAbzc0VPQ8tmD4reDrM0KXs5JA0LP4BaaK57TVCMOlBgpzyJKQl/TeCIVjWf
	 3UVttp43FVr+kkwplfKusqFa7qcQaTR0iwWXQmFM0ymVbBeLXWj7LrAGunVkb05/lUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793988769;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Received:
	 X-Forwarded-Encrypted:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=xABCAQ/j3mpYe9Wdms85794hL2vRznEt57kS2ozzMLM=;
	b=PTIEuE/DSyy9rYW0APTshP5ZTg2v24No1pM+349BRl5DvPPd4FsAM3TnR09CA5T3Ser9
	 rQdbXSYM9RrhSxiVap+G4eTB1B0NSo0mQZcWqzjFi4KnGfTuNFxNgsVHcHLjw1r4RhwWC
	 jjQlMcksA7XQ0yq3r6MAcLHBn/iJRfFZGKDq+cwTHgHTfyVQOIHcXKuYYSRclsy1cyb/0
	 8oeE8FCX+qAdfv8R2CXji0IX82Xxb5XgX2ftdesYpP2oZG1L54iT9FAZGtC54+CFCql1j
	 Pf/oYD4DVcSUBKti4MlXJCFztsV+J+5Xd0H5KK9pGRAByQpqRw/rnOQ64XlS5F+g0DA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=linux.win;
	spf=pass smtp.mailfrom=gmail.com;
	arc=none smtp.remote-ip=209.85.208.41
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29228606A326
	for <linux-crypto@vger.kernel.org>; Fri,  6 Nov 2026 18:12:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 29228606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.win
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-6b561b60b78so3034003a12.1
        for <linux-crypto@vger.kernel.org>; Fri, 06 Nov 2026 10:12:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793988767; x=1794593567;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xABCAQ/j3mpYe9Wdms85794hL2vRznEt57kS2ozzMLM=;
        b=NwMUaWtvT/h3pqPXvQFoFUTsLUiWpjuGr0d3OOSRxdUJfkqaCCLsICwHVQy717zjuS
         BlyZbWKVto7jHHzSbzG0BUUkieSAXqqHENqwdZsOeS1/DThxrTp/5Csx1zRbvljIS03c
         WKZgIt1b1JnX3hs41+SXzfkKWtw5IxczIQWnztjEuXF9rGnq0N5fk/QCReid7+jQ5tQi
         XKHfrWhZ+mF3qOy2w58ZU5BWUUmJD3/eqEPVxNxVMrnmbiqxpdNksDnnypdPrURfWAUz
         xSkDRJwRKyU9nIwicGj6mP1RX3PUv953tIj6twbRiDIpplA5oSox3gcCsy6RqjG+gOcj
         DfSg==
X-Forwarded-Encrypted: i=1; AKwUvBywphEe9B7ZP1+B0cOTjvSH800KynsfO37krX0FKJtIgdeIfUG43BIiLbBW+DnF64kxemwk6zKQgHa6cac=@vger.kernel.org
X-Gm-Message-State: APuU4Z893wzNLh49WeyHnipsd211AjR8GSX9W2hzrbdA7WUDTCXsaHSL
	nWYSHx28fhoQODHhdS0jCsXs8k1Wh2koQ75yQ5wb5PGL2fGRfAnxUG/kyHu330PBcLw=
X-Gm-Gg: AYBFou07K1J+TY0V6b4A5EE3qZtTyDrYWQKgwqM5w0IK9BL7/okcDypuwwE83zhoUkt
	rCujZQB5ws/Nu6SnvbrPJ2zeRrcXKOtpBlKvIhHQR7s3HiNOco5lUtagc96XV2rRGIq/zvOZ+/i
	I31OFjlEC2VUXZZuDwhbD5f+0IENS1L+V1LVA/R1KU265JzpzgZKPbdf/e8r5aQ37cL7uiAEHYN
	OQ2gmOvbNh8b+S0gbyGzV0DnerMq8RitHZ7orB6S5rJPCL+GWlarY2JL6I2aksfO3VFMbpOo+Zl
	ZcDaXuUyA8K0GufU95It4v7XY9BhwMH6GPbHh4boeZiRBseJumD5MDvVNkTu37kTcXuCZfvxR1x
	EoQcTshRXdYqgeGSC/pE8ZvqsA1yYlFlzhP1Q6t8dmoPm6j016WnR4vUpKruNrDy4bSko4lTBk3
	aQMjrEc7BTqvmUXxOV6+FrZWj3ulnZbEohMW+U0IYvhUBXMMV+RqqPq5En3KERJ0iTxNIcHVmE7
	02l7jQZVhuG4xCJYE91BObwSrioP27ScKlvWtGng5IdZvu8LFPPCWZ8snut8oG/p94/FKVj3xj8
	gXx+Mb8YdDAlRb4g95MAme5s5YNx0mlKto9AnaXuVuv43hDxnG92wjTBdzY=
X-Received: by 2002:a17:907:9283:b0:c46:78af:6150 with SMTP id a640c23a62f3a-c4d20150ea3mr556697966b.2.1793988767390;
        Fri, 06 Nov 2026 10:12:47 -0800 (PST)
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com. [209.85.218.43])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c4d3569f7fasm93680766b.52.2026.11.06.10.12.45
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Nov 2026 10:12:45 -0800 (PST)
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c169ae1cb26so349369466b.1
        for <linux-crypto@vger.kernel.org>; Fri, 06 Nov 2026 10:12:45 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBx1kA46hjc2bEZ1u17v4U2UcWgHXrXaNEaP/5HrjMIXSn+jT5qo1U0zVu/pVwCAq8f8WTNCpHWtzZSxba4=@vger.kernel.org
X-Received: by 2002:a17:907:7285:b0:c3e:2224:1b86 with SMTP id
 a640c23a62f3a-c4d3525a428mr313145766b.2.1793988764396; Fri, 06 Nov 2026
 10:12:44 -0800 (PST)
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261015110826.126621-1-ampr.mhd@gmail.com>
In-Reply-To: <20261015110826.126621-1-ampr.mhd@gmail.com>
From: Ignat Korchagin <ignat@linux.win>
Date: Fri, 6 Nov 2026 18:12:31 +0000
X-Gmail-Original-Message-ID: <CAOs+rJW8nMAAT3BHghtS+V=Pwz6bTg679ND41gsKWHtdsLsksw@mail.gmail.com>
X-Gm-Features: AclHuK-B8qlW9POQL_jz_S8L2JcDrY1HJuCgVxk7uflmFEZo1Scl9EmB4edwCMI
Message-ID: <CAOs+rJW8nMAAT3BHghtS+V=Pwz6bTg679ND41gsKWHtdsLsksw@mail.gmail.com>
Subject: Re: [PATCH] crypto: pkcs7: Return no-digest for data-taking algorithms
To: Muhammad Mahdi Amirpour <ampr.mhd@gmail.com>
Cc: David Howells <dhowells@redhat.com>, Lukas Wunner <lukas@wunner.de>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, 
	keyrings@vger.kernel.org, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 15, 2026 at 12:08=E2=80=AFPM Muhammad Mahdi Amirpour
<ampr.mhd@gmail.com> wrote:
>
> pkcs7_get_digest() is documented to return a digest for IMA to use
> when verifying a modsig.  For signature algorithms where the public
> key algorithm consumes the raw data rather than a precomputed hash
> (algo_takes_data, currently ML-DSA), pkcs7_digest() does not produce
> an intermediate digest.
>
> When such a signature has no authenticated attributes, sig->m points
> at the raw data and m_free is false, so the existing check rejects it.
> But when the signature does have authenticated attributes, sig->m is
> an allocated buffer containing a modified copy of the AuthAttrs and
> m_free is true.  The existing check therefore returns that buffer to
> the caller as if it were a digest.
>
> Test for algo_takes_data directly and report that no digest is
> available, before attempting to call pkcs7_digest().  This covers
> both ML-DSA cases consistently and removes the now-dead m_free check.
>
> The only in-tree caller, ima_collect_modsig(), does not check the
> return value of pkcs7_get_digest(); for a data-taking algorithm it
> will now leave the digest fields unset and fall through with no
> digest, which is the correct outcome for an algorithm that does not
> produce an intermediate digest.  Callers that do care can detect the
> new -EOPNOTSUPP return.
>
> Signed-off-by: Muhammad Mahdi Amirpour <ampr.mhd@gmail.com>

Would be nice to include "Fixes: " and "Cc: stable.."

> ---
>  crypto/asymmetric_keys/pkcs7_verify.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
>
> diff --git a/crypto/asymmetric_keys/pkcs7_verify.c b/crypto/asymmetric_ke=
ys/pkcs7_verify.c
> index 474e2c1ae21..7939b08b603 100644
> --- a/crypto/asymmetric_keys/pkcs7_verify.c
> +++ b/crypto/asymmetric_keys/pkcs7_verify.c
> @@ -147,14 +147,15 @@ int pkcs7_get_digest(struct pkcs7_message *pkcs7, c=
onst u8 **buf, u32 *len,
>         if (sinfo =3D=3D NULL || sinfo->next !=3D NULL)
>                 return -EBADMSG;
>
> +       if (sinfo->sig->algo_takes_data) {
> +               pr_notice_once("%s: No digest for data-taking algorithm\n=
",

We should actually include what the algorithm is here probably for
easier debugging

> +                              __func__);
> +               return -EOPNOTSUPP;
> +       }
> +
>         ret =3D pkcs7_digest(pkcs7, sinfo);
>         if (ret)
>                 return ret;
> -       if (!sinfo->sig->m_free) {
> -               pr_notice_once("%s: No digest available\n", __func__);
> -               return -EINVAL; /* TODO: MLDSA doesn't necessarily calcul=
ate an
> -                                * intermediate digest. */
> -       }
>
>         *buf =3D sinfo->sig->m;
>         *len =3D sinfo->sig->m_size;
> --
> 2.55.0
>
>

Ignat
