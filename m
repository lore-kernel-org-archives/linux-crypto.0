Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1420929405
	for <linux-crypto@vger.kernel.org>; Fri, 16 Oct 2026 04:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792125774; cv=pass; b=tQb305USF+szC9nKhQpVzUOfojc3oPSN8NEaYlTYuA2HHbsbKgmrXy+sWc6pRlcu571+Ts2AtV+nZNnP6+iAXRnEdF/ygNS5cACd8AONKegA0CgfZOk/hSS+WWacKB9yJEQuDZUa0Pqo69uHBaP6aDQhrhy9N1JcR0pReFRbWng=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792125774; c=relaxed/simple;
	bh=hirSQS/OqvADHiytlKbGmIxt0jyt7X0sIkL5Ta9doMI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EfVHjBNlh52RVg827hUSp4vG7TWqwYnhhJpg5H3j9aUjBmGAPm0DaTgKB6rKSP7Nm2jp93G+Myv8ynFukULwPdhVWW/yOklHFVeVwP/P8O0Ub7QCp7t1t0xpnt36Lmfn5i6gUxAMNZI9cMPr21DndZHA8xpAnWteo+De9xS0ceM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bgr2kgSc; arc=pass smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bgr2kgSc"
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-5bce4e278baso807273e87.0
        for <linux-crypto@vger.kernel.org>; Thu, 15 Oct 2026 21:42:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792125771; cv=none;
        d=google.com; s=arc-20260327;
        b=Zn5TosFn1Zp5Plw5/kXQT9a30+lX2LHWgCpi4CmYri6I/yfhLBt0PWex8ld6C7/Vj6
         z145w3RciHumsHSraRLtK66qZI9CkGiJsyvQK1Zu7OvDWXiPZZI/0KPlZ2pEdw/nhu5I
         eu5i+iDKb01dV2IW+Del2SAAeCZkSptUK6cI4Bk9aOE4hflwUmMv2yTBKjKKr/ATfreb
         CZ/a+YW0lLVqIpZbrgFUVIU42B09BG9OlLrPvw3SFXbF0VmQoIt/i7UB5rMKyyOYvLa7
         TFOb7LtNM+hlZyIKW3NQudjcKQWgRUPOgZTe2Ij5ZSaBcANiE07KjhP85TygJp6bIeLS
         764Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=HOrvcb8VGO3g3u2hTYFvmKxMb4WgJQMQSCQrwrKKXf4=;
        fh=AU3u+6/yg5EMJUk2rLJGpe3+mjXAKg1DuOvW9ZbwX6w=;
        b=L8713lEuSgiikNX4DdbZdU5cCNynuWVX7cdCWUta5s6y+TtcI0ZwYRpo3h+fvdVYfn
         QKyBsx8Cam0mFXyMvtY1V6G+6duZlt98yQhLxA2ku0Akpsvun2vSFsG7DnEZs8M3omcR
         a9ewLufwYB3jWtBXS1s7oxdBRhhteIsCXGrgt7+aeDq5Jo8HVIEWg0PU6ZLOiX4yDeQQ
         0qpdn9ye5zXQOpna611Dd6412RwpGtaLcbdb2qd34WBmJIyADuhXuEEShlyp5KdGfBTy
         TeagVmyAtBZ/ALjZQNLLW5VR4Kclz8dwn2+gbRbYwJmXT6YMswFwK5QGP3DXjlEbpbnH
         n7QA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792125771; x=1792730571; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=HOrvcb8VGO3g3u2hTYFvmKxMb4WgJQMQSCQrwrKKXf4=;
        b=bgr2kgSciaksstH62QWZSAviIm/CpyG3AZtsZrPZ8M61VtcukbvAA5reryyuDylF1C
         JRFvT07T+uQsd4fYeE84Tensho07i/3wZLiJcnSWrjasmlCW2/Rnoew478okXivTOaKX
         yr3rIJwaO2CLi/whLUWitbANYfpp84WGKEuQuj67kL9k1KHBOrF/bDhnDVAzoRmITfXA
         j5ZMpoKN1/pYWKaTeDv1NhMBbd5GyHCYKloR5UKa/rsnH+aBn5nxbgEkws1lzgJz8fN5
         3tryB5GbvF9vFJGLujoYN9w/PbRziGo9hLSoOo6WIfREox4DXFtQspeIo6zam5nOelzr
         s92A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792125771; x=1792730571;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HOrvcb8VGO3g3u2hTYFvmKxMb4WgJQMQSCQrwrKKXf4=;
        b=tLIpBOW29Kv/SBIZxPtyHuNnJMHUzoR6Mey/AlQTvvXMoc2IYL2lerhDLeHz//WEqU
         NuqhurfL8mqIKD2S3pmXlksMXNi4J11mhpxVraRGPHoqiurEhEi9jDO60p+++5jsF7uo
         pT0L6XAuNj/LOlkeVBNrSM3a/+bkJja75LF2JO1ao/knolVYcoQSIdSLj3yPxg6pa3uW
         3KUQ8NX9PDWMDAEzlzv/BmQKg3eNrQgdjtxKhKBrKegX8GpfrwGsLh77mzfrZdSZqbO+
         NVJTTO7FEeeD/bAB63Q1rX9RDfZsv2gzwgJJH+kPD2JzNFa15xMUBicjfHRfCj8v+tru
         32og==
X-Forwarded-Encrypted: i=1; AKwUvBxTW7lpKyADft+tNNckT6BVXQOT5+hM1aPTF7Ypbcrud3KbC1Pjxrd9x/0dxBcgoKU7WZeaSp9JX93+ld8=@vger.kernel.org
X-Gm-Message-State: AFq9FYICkih3LUdbcmI3OT3EbJmxSmXapGNVmvsxhRIHqqHs49WZhlu0
	q5OHdoA6Y1pNCQTcb3pLxdUMjd16Tq0D47c6ZIZ2IE5DZQaYRvuaglo0bmrne4v7M/hduxBJKp8
	s20kRhfyfusG6vaVszcoyr+517fjqHPY=
X-Gm-Gg: AYBFou0gfJELnaVQTtZvZffepAeCj0lhc6JgVInO7/+ppfwvB2hQoKKII9GZ+/YhgNt
	v3mO4cc3o90pYXu16cjonyNaiBjbQhbNMqyJpK0nPM0pidhcv0oxHokAK5EHhov6LlVqqmVd0Tf
	JW/TNBv6QA5mGuiLB6POHqMsa+t2NtdmrA1nARiCfJriDVl57xwk3+yhNGaCfmE7fZ4LHPXoP03
	ZPFhqs6fqaCWq2/I5SZJenECqBuI7TJBjUoi4/5KwdXIqClo0vKToX2IbhhtJktPQAkH+rq+FX/
	wOJITnQcO7PD5gVlWIQMMdMBwUCDT8hoggeG6TVuvuKTOPejA1P99c8=
X-Received: by 2002:a05:6512:b88:b0:5b8:edea:6800 with SMTP id
 2adb3069b0e04-5be476da151mr631619e87.22.1792125770781; Thu, 15 Oct 2026
 21:42:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261008182814.27450-1-kanchanapsridhar2026@gmail.com>
 <as-jZopKRfuYAiTE@google.com> <CACpmpoeS_cvXRWJXqiYZV9oykk=91efv8KtZgK2Pi-QwHnQH3A@mail.gmail.com>
 <CAO9r8zN5n=9v4K+OtEEODg=e0kcFW99PreUcZm09q9CUMQc+ew@mail.gmail.com>
 <CACpmpofdoeVbbw7izCDeJ7eS+XpWj+3sp3teKEQWywyRB75jYQ@mail.gmail.com>
 <CAO9r8zMaaUsBaS0TJumochRKt2ShV7nRaLnYPWv3=S-wUFgitw@mail.gmail.com>
 <CACpmpoecz4tjr-qvFRy22CGuF+4NBWbE7HVjdTGFqQOheK3CLg@mail.gmail.com>
 <CAO9r8zOAcf4=TscCXjMYvowUx-_u9qLGqY2-p7cK-z5CUU_x8w@mail.gmail.com>
 <CACpmpofYXDMviE6FS-BZdVntmQFvS+_xvfmOnJ2caZFerz6vyg@mail.gmail.com> <atGqPIpUfX0LDokV@gondor.apana.org.au>
In-Reply-To: <atGqPIpUfX0LDokV@gondor.apana.org.au>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Thu, 15 Oct 2026 21:42:38 -0700
X-Gm-Features: AclHuK9lFk3Bp3AlNyS2F-GkGX_WVBdlaB2VfCt4lT21jMqDyuj_BMkFpZJj-S4
Message-ID: <CACpmpofAtQymsWVG+XtvzHahthFmNHXND8t-pqj0fgURCP6Okg@mail.gmail.com>
Subject: Re: [PATCH v1 0/8] Batched zswap_store() with compression batching
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Yosry Ahmed <yosry@kernel.org>, hannes@cmpxchg.org, nphamcs@gmail.com, 
	chengming.zhou@linux.dev, akpm@linux-foundation.org, linux-mm@kvack.org, 
	davem@davemloft.net, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, rientjes@google.com, willy@infradead.org, 
	senozhatsky@chromium.org, 
	"Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 15, 2026 at 9:38=E2=80=AFPM Herbert Xu <herbert@gondor.apana.or=
g.au> wrote:
>
> On Thu, Oct 15, 2026 at 08:32:21PM -0700, Kanchana P. Sridhar wrote:
> >
> > If you are Ok with all this, we will need Herbert's Ok for this change
> > in patch 3:
> >
> > diff --git a/crypto/acompress.c b/crypto/acompress.c
> > index 192ea996e779..db8e4c82b900 100644
> > --- a/crypto/acompress.c
> > +++ b/crypto/acompress.c
> > @@ -293,8 +293,12 @@ int crypto_acomp_compress(struct acomp_req *req)
> >                 return -EAGAIN;
> >
> >         if (likely(req->unit_size && acomp_request_issg(req))) {
> > -               if (!crypto_acomp_req_seg(tfm))
> > -                       return acomp_do_req_chain(req, true);
> > +               if (likely(!crypto_acomp_req_seg(tfm))) {
> > +                       int err =3D tfm->compress(req);
> > +
> > +                       req->dst->length =3D unlikely(err) ? err : req-=
>dlen;
> > +                       return err;
> > +               }
>
> What if you put this short-circuit into acomp_do_req_chain instead,
> does it still give you the same performance boost?

Sure, that's a great idea! I will let you know if this gives the same
performance boost.

Thanks,
Kanchana

>
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
