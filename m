Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.176
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794038586;
	b=uhA8sIA78rGzzChGUnL4WkL0d260vOC4hWprYd4BorN5NxiGVBK6ILAvgHNxiX89GSAz
	 T2raZwjVoULT32vdl3Uqbq4ceVESQAx0h3YE1nNqK0NhY+oOic1U+l04GA+nznp1qDnmG
	 s53Gu9jmMgWI6vq8q3P4m4SnJzgxqjQdgaIwJCOkNA3XLgNPUrAylnTRPym2uEUINjgAu
	 r0WLhQ7Z6gD+ufVcjUENJJNGIpvpcAtVexvLYqSG/+UvipbWiv2wYsQWFbuurIJ1tF73v
	 c8Ta25pvrXByo7QiaTY4vHULeLf9T/2zZgoO/tDi/RJCLNAzMUEHg/HkkQFO3MYQaUQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794038586;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=UBKjIJV0Jyc+FtrJEW7tHvzq9gV7uRShW+9B+nXoav0=;
	b=4TnjgZIOx/hSOJnQZjL3YBt6XJi3wBGxzFyHr6WAACMMtxffM70jU0wSMm1GMbU/0Wkf
	 +JGBRcA7I8j+uAZAS92Gcby+mnE1gp326EoZsJE3seM2MqGehZekC87qKZBMtm+VhQPe7
	 7Mx/lzKlMmBvGF6UMAleHJDniAhX5mbyEPOcHyYpFPdgyzZfGavxnUWppED/z5s0JMg4w
	 T5AHIPMYWrr4Q3qHiptHcmkquZGKK7TkAvLkHb331xtxwBeDr4nJd+uEX3U6G0p5MqkXk
	 +EsZzd1qAPQsbo6UIqKs87D0PMvNdlYakJpSvQPzlE3s9n/iiriCCxkoz3owKpn1vkQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=0wZGBE3p;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.176
Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 707A4606A32D
	for <linux-crypto@vger.kernel.org>; Sat,  7 Nov 2026 08:03:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 707A4606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=0wZGBE3p
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-3ac91f5aa89so10082281fa.1
        for <linux-crypto@vger.kernel.org>; Sat, 07 Nov 2026 00:03:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794038583; cv=none;
        d=google.com; s=arc-20260327;
        b=Fo0JiEkVVESRSD8+C3Qudx6dhskxOetqMHGRSFFXSqCH8dDGEXSUhispc6ZV+y4Ifn
         oAnokYFeaE1A0yp34Vv2Qe3RpwdKvFuDtfpHcBBWHzynBaIMXocS7lcmGEVfLRWxiLjg
         JalutkrgzVuO5RST41GRB6O3upfymiZVkNQwqk0gbP4n2zzTisgN1rbMD+006HU7TxsM
         dvqkK7zd7L6JD7sOEkQ4FZuvZIjnV2WSsvAvg1NviHaP7silqxoLlTWl/wu/HrzaYN4e
         OByxAyFCJpvdJQWI9QF4MuEVcK1g+0ZaBahORcb0wtnZXfgXxdDCmfPtBkfw08B2nk8H
         pHPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=UBKjIJV0Jyc+FtrJEW7tHvzq9gV7uRShW+9B+nXoav0=;
        fh=UOYPuyPLQzRZVsWds9CH+yc8Zhk4SuDDXjbWkTzxdjg=;
        b=GU8v7aesR091r4Oq0rGb2fcjUwx9ECCAnl7kFdzEg9Pg3wpgmZDAcGIRgTreRRoTkR
         7dCGbEgFVtasdzJN2TBXjtE1VJkmjcZ8kz2misJsq5gmvObRTrb/7BrjaXeF74OpjRqm
         2NMMMKf+GrtWbVA8+MVFni/qbNsDcQ6/PhQ9nLV4bN71F+2WJc3vZ3JgoylWBuvQJoSU
         BWGLv6xmfTIizkQaIOeuPfDe4KRwUVyXMfUMx6t049EruximVsxUXJffD9ZET+q9ewUm
         vadT9KVUGz0Sx4UaKteiCVsHDRdlPb4hhWjM1dyT+25vhN6RMyKUOmlmWMfSIk0mSMh5
         URsA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794038583; x=1794643383; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=UBKjIJV0Jyc+FtrJEW7tHvzq9gV7uRShW+9B+nXoav0=;
        b=0wZGBE3pi7rRQQLtiubDQsoUKYdeo6JB/h6gxTy2ypWXDwuov5jhpsm9/39Po1RNh7
         cmAU9zxqvRGIHi/P1V1t8v2adQTdSm5KtKmnrFs9mgGdZ6uEnfRUEC+9YD585t6IlyOC
         JM579bY6MFiiK4vrYx8r+etYaV64jQb75hfZGfLppJop0YU/cGIQPtS3IwKyuphfgBWJ
         6q9gifSthlnKhSUz2UVe3PPEM/nKFWeq/WJ4gYmOOaTXNktNREBnU+HrhQijBAR4Wwex
         u9WfGJ3oTkfpNhuAhpvCoV1CQf8c5fJmmRn2LXN93vrfhnNoAuNuXzaCcmsDLEVZdYVL
         7l7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794038583; x=1794643383;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UBKjIJV0Jyc+FtrJEW7tHvzq9gV7uRShW+9B+nXoav0=;
        b=Uo0LszKE5Cy60ZT9xHdiQdnAP3bIlJEE8yUkCCvET9IhTlr/AsuPj3LnXJE6nblHOO
         eB11IaL6SGuyr6tE7XwKqNgv/mh7wGk62DjyFTE7lr6bYgiocuJNRsUUsDS87BQHrF9F
         WNYIpXg2kGS6XixhK1hfansBTQ0xx4cBmHA6h04uqK+MotzPGUgQKlFajFLT0v879Vof
         UYWO2RkZMO7JfANoPN4lJl0sOZY/lObJBG1Pu+AYm/HVyGhB8KLuuUUgG74rgpToEhbS
         RnAw/6Vq6HB3eJjyE3WtsrHKruj5tNgZyZiVE5x00bufwb0DIXyNFP4YDaESQVCcRhze
         kgCQ==
X-Forwarded-Encrypted: i=1; AL+hErHRoHIoWGfYI9VKwWc9zBdXfNpgDE+QOUEJVXy76xwOkgj7zg2wCPknCOLEyYBSfBegkaS/xLL4nqI1lu8=@vger.kernel.org
X-Gm-Message-State: APuU4Z9Nz1necGMw8uY5VKqDu5XHnqlPyOYuVyr04FAzYNABltVmok47
	1VpY4GmQuMzHsehKaSORSg/3r+BYXjqKRfCKpTFUuyPowd0csHfNMIx7wcqLjPraiFsIwtCoWpV
	dREHF1d0Jutend3AMDMcjBkVzxep64gtiXue8iqpG3iy86zc=
X-Gm-Gg: AYBFou1QgOWUQTUcjKZGW4b9ky+PzkGcnjGdehj2deTvMm5lYoBy+2/YjwW8VRiHDin
	atv3auG8yvOjVRmqerGhHRpMmzHCAurPC+hhhZhPIAIJg3mbXWrAIY+v75p4KXqFUTF9UDd30Pj
	s63vNj4Grf5tXOzIJmd9haeBaC248vy2+lnTgFuW0hxcl/K3SQ0j1llz8S8HM3+MCzcf0O8kmyX
	5affOx334Ev940bXm4NHhb6GE70Q7ciw1ntJQGBesmQ+4BKwX9gHK2tyuy2HMdTgoCNyvWoRFI2
	fNzv/HLaopGM+Q0VH+6T2cWy4z5L4avzUcbF7ETa3SW/AkaJS9Gl+Q2ccCr13/XDkNP2k33tvKR
	7sGCl8bxBxYdq31arhgUkpim4Wr3DRBHGlnKoHnw=
X-Received: by 2002:a2e:bd07:0:b0:3a5:af50:bc99 with SMTP id
 38308e7fff4ca-3acf3b20711mr8857361fa.13.1794038583192; Sat, 07 Nov 2026
 00:03:03 -0800 (PST)
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261106200423.37769-1-ampr.mhd@gmail.com>
In-Reply-To: <20261106200423.37769-1-ampr.mhd@gmail.com>
From: Muhammad Mahdi Amirpour <ampr.mhd@gmail.com>
Date: Sat, 7 Nov 2026 11:32:51 +0330
X-Gm-Features: AclHuK8se3YTl-AisXd9olJNlKqNSemA9zYOj4Th4vrPgv6cDYoaaBCODDUwIsY
Message-ID: <CAB_t1-BWNRNOQaCh=qz3s1q2bQhS=njpt-v1u0JrT-Lyw21MRA@mail.gmail.com>
Subject: Re: [PATCH v2] pkcs7: Return -EOPNOTSUPP for data-taking algorithms
 in pkcs7_get_digest()
To: David Howells <dhowells@redhat.com>, Herbert Xu <herbert@gondor.apana.org.au>
Cc: Lukas Wunner <lukas@wunner.de>, Ignat Korchagin <ignat@linux.win>, 
	"David S . Miller" <davem@davemloft.net>, keyrings@vger.kernel.org, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Note: ignat@cloudflare.com bounced; the correct address per
MAINTAINERS is ignat@linux.win. The patch is otherwise unchanged
and available at:

https://lore.kernel.org/all/20261106200423.37769-1-ampr.mhd@gmail.com/

Thanks,
Mahdi

On Fri, Nov 6, 2026 at 11:34=E2=80=AFPM Muhammad Mahdi Amirpour
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
> Fixes: f3eccecd782d ("pkcs7: Allow the signing algo to do whatever digest=
ion it wants itself")
> Cc: stable@vger.kernel.org # v7.0+
> Signed-off-by: Muhammad Mahdi Amirpour <ampr.mhd@gmail.com>
> ---
> v2:
>  - Add algorithm name to the pr_notice_once() message (Ignat)
>  - Add Fixes: and Cc: stable tags (Ignat)
>
>  crypto/asymmetric_keys/pkcs7_verify.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
>
> diff --git a/crypto/asymmetric_keys/pkcs7_verify.c b/crypto/asymmetric_ke=
ys/pkcs7_verify.c
> index 474e2c1ae21b..c2e0eda502e2 100644
> --- a/crypto/asymmetric_keys/pkcs7_verify.c
> +++ b/crypto/asymmetric_keys/pkcs7_verify.c
> @@ -147,14 +147,15 @@ int pkcs7_get_digest(struct pkcs7_message *pkcs7, c=
onst u8 **buf, u32 *len,
>         if (sinfo =3D=3D NULL || sinfo->next !=3D NULL)
>                 return -EBADMSG;
>
> +       if (sinfo->sig->algo_takes_data) {
> +               pr_notice_once("%s: No digest for data-taking algorithm (=
%s)\n",
> +                              __func__, sinfo->sig->pkey_algo);
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
