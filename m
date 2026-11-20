Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.49
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795202681;
	b=hlEItcQHlZuAnWcwFttv4Z1MY9kAI2+QBesXHn2PJ08/7vRVAKenWDptAW1mMSwRk6wr
	 GbFb/RePyl7KI0JWI0BnZx4XzO1tK090pBEdt7I+RLp9TW/GRCYGrAE3ta7xNirZsZMPL
	 zMrwDJ+rHhlQWdg9X2gLjpGHgcNHwlmXd/D6moxLNSHQ/9lmusayTumkpR/aKtTF8VAxd
	 D5e1gk1kx9d/snWSMpmmLlgXdvbO8LKFZkeqo8faWoYWiRPGvB+8dhb9Ylt6v+PdswS1u
	 bPCI8mmG868aUvz4RMUgV66bw0ApMV/B8jni5oKxGTeKZXiq8931APmFuskj4WqDJ0w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795202681;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=xcib+K/+9ejSnUqHeRUGsbo8GBDthvLScqBZBkgzZaU=;
	b=CLsZU9/B+GuoaM6RCrxGRWBBOHrMnw+uI9A5eh7vuW6FkYbONMKhdSHyIZVLpGkXzf61
	 Lqatl+6tiKK8tc8V8zSA0JlT5ZhK5HI2QqjD1cCv5eZTK9SfzU5Vr7oyHZiAFZUWgsTw3
	 /sIKI9mp8v4CxYo2DAJrTAcW2lP1ju9yEAIgfU3jATCG5co9LOF/xYHzttc5JkOw8U3I3
	 EqywNXjOMr2uRKOPkIoGfx4wCiGq4bmu+eYQfabqFkDMX9jiswmpVn+FIgWcm2FYDtK7o
	 9GvR4PoruOU/goI8yGQkuMdPD6dRlgKeOCHhjGiDvNFm5TQp+FbCAH1tFB61rV3FbqA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=RLMtmdrS;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.49
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A47C606A6DB
	for <linux-crypto@vger.kernel.org>; Fri, 20 Nov 2026 19:24:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9A47C606A6DB
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=RLMtmdrS
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-5c1a3374400so966214e87.2
        for <linux-crypto@vger.kernel.org>; Fri, 20 Nov 2026 11:24:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795202679; cv=none;
        d=google.com; s=arc-20260327;
        b=s75CeVEm3Jw0lEx0zBpmNemx7IZV0DVRnCNNscBgF5dHxtgDNN8jzMBz3lDdoVHDJP
         V6rZuHo/BZFiEkAbXvym3pyTxxlDmrPadmD1DB2kHbkTLq2G5XyuZcZmyVVHqWHE0rKZ
         OwdG7RF6BmAZ2X0/wKgwJG6KWzs/7l6Uy6LgGmAMe86lPG4Ul2qIRVUX60heh5DXcufN
         TMQoedF8gB3t8LMn2fagVeoIIiOcpCRy6vBEnawUDNWE3wejQTVavyYau5wIHnyONqul
         6rjProDq1HpLW0dwWOJKLj8R4WFZpMkG0vQ+zYuWmnMbvpgOOb+qe+27WlxL27N+gYyU
         TkiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=xcib+K/+9ejSnUqHeRUGsbo8GBDthvLScqBZBkgzZaU=;
        fh=2VnDZN9QPRmvFlG6IhTbDI0G014e/72BnsQduCOfkX0=;
        b=fi++11XQTaxmCcT13aiygmvCsWwRugEpqNsX2CvulLk0kghs4DjUa5hvgekHd4g/0N
         01w9b+MGQIJfQEg1INmGUH9MrI41j7vdLWDhsFCKWj/40ib2Kiw5ajuQYrCMxSs2mCD1
         0RRAgnAm1rvZ80xvbhFgpegM003OAQ19OG8JtyWI1HtT0VQsrACxRMKZyTKb2tjmHL16
         ec2g49WShQzUPBYB57J50qSefMl877Kyef86b/UCLmTQyQ5Ki0B/uLNTAzeVMmLfxcht
         9wVHoXt/V2g5QEvXyyiRpYvhI5UcXbMH9OkDdWS3tIPNYZ3VfVRBJqpewpGJn1t4egEe
         80aQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795202679; x=1795807479; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=xcib+K/+9ejSnUqHeRUGsbo8GBDthvLScqBZBkgzZaU=;
        b=RLMtmdrSystqPyU2lB0yL3uisLVi2LnI+I2YWpGObFiLJE8CeukqG16P2U7prJwYFa
         zNdjgREXbjaGCZ9YglgS99wd4B4A1j93SH7sHzfchadC3ySHWvPZiEJdU/Bg6uWyriqg
         7osL02C6PDPso7HRjTYPEdoHXZ/jB/mljVxEhuYvE1164v5pltWI4oTr6ksgUrBhQB4j
         TQiYM1zk8ostt0rJPlRHfboDyI5NlX3dKSlUJrr2y1QadQk/+mFt8yd/vv6d7SOCPuis
         9ubPlrwew/GOwF0xcPEIawiwq1E0PhpU5mHY+69Kw4/ugMOTGZdLRnmnEk3o7wCSLPRO
         1DRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795202679; x=1795807479;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xcib+K/+9ejSnUqHeRUGsbo8GBDthvLScqBZBkgzZaU=;
        b=KaE6zHDIHbpyLXa/SQwwTOYIgiuJbGtVC0DaKYlM7FPL2NvX/scwAlhtCOZgs1BMVJ
         MudwaZWlbiVr9/++x27lS1S2xpHwCZPVcohtteA2u6jGWJP5m7LVcFV6QeloM4x16i+9
         dNZWuLvKhkItE3RfsQKzNzKgzuVbbmVH/yGvPIMMkhYomY6WXyxw3LSpfQqC2BhnIbR7
         AMBpmR6CGm5mpgpDYUcMaPAIn2ZYPIbaM7ovW1aBCpknc1y98YkxJ4u5gA18ttFoTNy0
         mdu/V5xP1XBRWGHqF5VaYo84vQ7a3f8f8GGhFNkM//sJlvincks4NKoG4CA4R9Hd/Uzp
         GRXg==
X-Forwarded-Encrypted: i=1; AL+hErE0B6ZrGTXQpNauqTR+fBL5VDxQWAWRk3eiHBGzdh/GH25u2rvw7X1gI21rThKNkCzU2DYDFSZv8puEvF8=@vger.kernel.org
X-Gm-Message-State: APuU4Z/BdyLErs/X3Qu6EooEmSJQBXb2ZmzU6GjSIeJMNYKqJqRzZtnC
	AGQk/JEDBEVEvJD0z6iqgos1MQYqXIBVaFrWAOstHBSTvVZcTmFgd6knCe9+l/V81cQ5K5Jl20w
	Zm+S+MG9SLIB3Rw6yboA7lCXJTyka70M=
X-Gm-Gg: AZFdTZfHvWDU5NodbqFs7m/tsvjg84yYU+AReSLTCeNZs42XX/TWjijxZWmLv/C9Tcu
	u+9tbz8nS/H1w0kHVb1xjLNUh/HQlsTgiq0Xf1BAU2iAq8Jjpcm8vzNkb4Uqy4+Yjx1OsXtXJi6
	DdWrjACXTijjx3rxKjm4k4VBH7eXeFTCSkgD/RODgRU6JcK7zeHFPJIh1Oyh1f8/+ebOuaHUbaL
	3GpGN49Q+QRFbBvYApK6C5k+oKh0IUugmo1DJe9onvsioyyIxLNOPjvEp1wap7vqJrRO6X8u6Jb
	0xsEnWSD08FD+O+QJSZ9L18L+UPeQA4SJ1fzvnC8eacQGCCs3ntefZKwhmp10zeFCCs2+LNNEL9
	qBAy8ArBheSzZgZ0NwFFVszlw6TFdQgNwBgEj
X-Received: by 2002:a05:6512:a819:20b0:5bf:d551:8c71 with SMTP id
 2adb3069b0e04-5c1bc7d15a5mr838569e87.18.1795202678517; Fri, 20 Nov 2026
 11:24:38 -0800 (PST)
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261106072412.7909-1-kanchanapsridhar2026@gmail.com>
 <20261106072412.7909-5-kanchanapsridhar2026@gmail.com> <sashiko-outbox-202710@kernel.org>
In-Reply-To: <sashiko-outbox-202710@kernel.org>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Fri, 20 Nov 2026 11:24:26 -0800
X-Gm-Features: Aa3M54rU46Ty9WvfOdS1wdoE0OXKdFP_zbBLl2cCiKFxY9ohzryN1SoHktkXPJs
Message-ID: <CACpmpoffJbo-8ba9kxjRn0mrBwzH3u=Cc3Y0kj_rDAnGrjWnRw@mail.gmail.com>
Subject: Re: [PATCH v3 4/8] crypto: acomp - Add API to get a compression
 algorithm's batch-size.
To: sashiko-reviews@lists.linux.dev
Cc: hannes@cmpxchg.org, yosry@kernel.org, nphamcs@gmail.com, 
	chengming.zhou@linux.dev, akpm@linux-foundation.org, linux-mm@kvack.org, 
	herbert@gondor.apana.org.au, davem@davemloft.net, 
	linux-crypto@vger.kernel.org, rientjes@google.com, willy@infradead.org, 
	senozhatsky@chromium.org, 
	"Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 6, 2026 at 11:25=E2=80=AFPM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue to consider:
> - [Medium] crypto: acomp: batch_size gated on acomp_is_async() instead
>   of REQ_SEG
> --
>
> commit 2fa95d403dcc5d6c7b702698b0e306a5d643d3b3
> Author: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>
>
> crypto: acomp - Add API to get a compression algorithm's batch-size.
>
> This commit adds a batch_size field to struct acomp_alg and introduces
> crypto_acomp_batch_size() to query the maximum batch size supported by an
> acomp transform.
>
> > diff --git a/crypto/acompress.c b/crypto/acompress.c
> > index ac4dc52668b89..df9e42f519c35 100644
> > --- a/crypto/acompress.c
> > +++ b/crypto/acompress.c
> > @@ -327,6 +327,20 @@ int crypto_acomp_decompress(struct acomp_req *req)
> >  }
> >  EXPORT_SYMBOL_GPL(crypto_acomp_decompress);
> >
> > +unsigned int crypto_acomp_batch_size(struct crypto_acomp *tfm)
> > +{
> > +     if (acomp_is_async(tfm) &&
> > +         (crypto_comp_alg_common(tfm)->base.cra_type =3D=3D &crypto_ac=
omp_type)) {
> > +             struct acomp_alg *alg =3D crypto_acomp_alg(tfm);
> > +
> > +             if (alg && alg->batch_size > 1)
> > +                     return alg->batch_size;
> > +     }
> > +
> > +     return 1;
> > +}
> > +EXPORT_SYMBOL_GPL(crypto_acomp_batch_size);
>
> [Severity: Medium]
> Should crypto_acomp_batch_size() check crypto_acomp_req_seg(tfm) (or
> have crypto_register_acomp() enforce CRYPTO_ALG_REQ_SEG when batch_size
> > 1) instead of gating on acomp_is_async(tfm)?

As described in response to Sashiko's v2 comments, this is kept simple
for now and for the only known use-case which is acomp_is_async(tfm).


>
> crypto_acomp_compress() dispatches segmented requests based on
> crypto_acomp_req_seg(tfm):
>
> crypto/acompress.c:crypto_acomp_compress() {
>     ...
>         if (req->unit_size && acomp_request_issg(req)) {
>                 if (!crypto_acomp_req_seg(tfm))
>                         return acomp_do_req_chain(req, true);
>
>                 return tfm->compress(req);
>         }
>     ...
> }
>
> If an asynchronous acomp_alg sets batch_size > 1 without setting
> CRYPTO_ALG_REQ_SEG in cra_flags, crypto_acomp_batch_size() returns
> alg->batch_size, but crypto_acomp_compress() routes batched requests
> (req->slen > req->unit_size) to acomp_do_req_chain(), which fails with
> -ENOSYS.  Conversely, requiring acomp_is_async(tfm) forces
> crypto_acomp_batch_size() to return 1 for synchronous acomp_alg
> transforms even when they set batch_size > 1 and CRYPTO_ALG_REQ_SEG.
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261106072412.79=
09-1-kanchanapsridhar2026@gmail.com?part=3D4
