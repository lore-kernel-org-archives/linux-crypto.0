Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C91511EE033;
	Mon, 19 May 2025 06:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747635453; cv=none; b=n9APaSoJRXG86jNCXASTcekERvIEAckn3vn5ev60E1RtXiyqbiFFtvbCYOvjuVjvyIuFQ/jWFg5aUqDlHSm2uPiwKlhCCUiI+UjF+Ld9wm1uGLiLHTDeyHcLM1X84kkwktfb2Zzwk0CSy0uWmmkp3Dmii14AaGqbKC7weVpb/pM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747635453; c=relaxed/simple;
	bh=X5GJ7fkgYQcAJRQSyUFLIiFdiJkFCrX/pT0nSEPwZrs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EtpuTFmMis10YL9zgqP2h8Xdsvc5kQ+TIY0cmDWKMZWtciqii3jxasRwh4h7zm5qLMr0NgOv3p1+8DFE9jdF6rH8MUcr+8f+mHprz2aD82YxyWM/f7S4gZb6ZFMKn1cLK7TGR+tj0UBumXDrqa/DI3M6VCnKuDUF3DgYpxfxrcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VP6JZACg; arc=none smtp.client-ip=209.85.128.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VP6JZACg"
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-70d70ee042dso2872107b3.2;
        Sun, 18 May 2025 23:17:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747635451; x=1748240251; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jBNU5u2YmmeIbqiZvjKL8Me63oYy0PF/cjbsD5421OA=;
        b=VP6JZACgeFlM3aUbClxfbMxPXS3p7xxo7tIA1VI36cj7t639dDMVgWa8ERlSmbXFT0
         EGYQSGVZnm38ezxjzNEOscnjSszTfZmhKqiboRL299aE4A39VlxnI4Eq72HfB6K+L3qT
         79LEKwudzMJmsYE7cYKpjGK61FhON4NTXy2BYR4GPBWp7XwKFHtdQSvUUu/LagPfhGAn
         PCMTDlUBRXNO07uyhe8GSjvczj6I5oupJGBBcLitDJHusnnqSb17Mg5OfKFxK+MxsylV
         PfVVOU936VsgVGzsWsEDO2OlwNL7OQ3r6eDbbJTUUszCsrrkNuPMVQiDnDWK9p46aNDz
         0y6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747635451; x=1748240251;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jBNU5u2YmmeIbqiZvjKL8Me63oYy0PF/cjbsD5421OA=;
        b=rxifsDYqia7GOgKcP9at3ONkQccngXAIjl58Y0V0HeQiOj5TESbNjYeJznC528JH4p
         CvSem0J762AhGn3Ey6nhoxrgxuJcrYPjcA0WCy2A3aToxTFtL+mtfOym6a+VU9Mjpujt
         ol0QP2cWjbNHKgreB5jZPehpeeGNc0y3oWHbcv37R9r+C1oPxWRGmmLGuH6JFT9OTI+G
         /J5gspw8tsDHVVR1hmMmqv8uEo2NPI+0PurWSiN2dfX1uFnb79O+scYcATEuRNqhL0kY
         sMr+xeAc9ccPSFKb1NGb5GadbSBVqW42pR8QzmC5DO15Ck0L1aIxga7GMcwk2/IqKnVO
         g/Uw==
X-Forwarded-Encrypted: i=1; AJvYcCVEXPrBzu7GhEOPhFxn+88HnQDuzMrWRqwbyZwbBaPZ+eEAamSpR1yCMTdDtQMoOi4COSRNEfCJ@vger.kernel.org, AJvYcCXQOB+/X6v2d5q8wsg/WW7E64IRykuCBnSZdXl90wZsKv+dkdhBtr0PmJwRtgwkj9C0jkNJ/54dwWUuOyI=@vger.kernel.org, AJvYcCXZ/lK/o4tiGCPWSp4zfsazq5HsDPRnh/2E8W73MxjefT8zbPHyuJonspGSo1PHjZKBKWJD2KCTLd6Rc/M8@vger.kernel.org
X-Gm-Message-State: AOJu0YxoanbfA6DCj2MasxF3OR6SHb9dmN1DbSj/g/x6WAFQ7rTp0IIn
	lKGQh0KA7bwBCyZQlWW7Qn6JJSXv8x8RJYclvDGrQZQy+q9wUKXYp9tbMstqDrAsFmrON/cAn3S
	YGwo+88zbDO1/ntBe4pTPwSambxUwSn0C4ueI
X-Gm-Gg: ASbGncs79drRMbIm5wE1DTrwciPN62beZnQSh0VQTqj83au8APH14uMG8O3F4U6CEHj
	9pugoTMXNAyqg0/pFebrFIk4K1saSAEqZxb7VVlR3q4o76ZaCmG6/LtPnjdABcRatTDw6K94pqz
	lpHGPvSC4pGoYUc8DcWslDXjEJfnLlPFUf8huPco+Ncr8=
X-Google-Smtp-Source: AGHT+IHiaGedTKMQUyOmF/2PbOlD8dAD7zpteTR5THOtwWTtVqGGVGMmGpxyPZzf8C/ua0h4Su6Y0/YH/RX7L+ZZp+w=
X-Received: by 2002:a05:690c:3390:b0:6f7:56f7:239a with SMTP id
 00721157ae682-70ca7a0f442mr152102797b3.5.1747635450584; Sun, 18 May 2025
 23:17:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250514051043.3178659-1-bbhushan2@marvell.com>
 <20250514051043.3178659-4-bbhushan2@marvell.com> <aCqzAQH06FAoYpYO@gondor.apana.org.au>
In-Reply-To: <aCqzAQH06FAoYpYO@gondor.apana.org.au>
From: Bharat Bhushan <bharatb.linux@gmail.com>
Date: Mon, 19 May 2025 11:47:18 +0530
X-Gm-Features: AX0GCFvGrGnK0GeTGdFaEW-bVKPMRJDbZYoy_7YsggpymiU9Hg6KfHCMNOtICoI
Message-ID: <CAAeCc_=QShbySa8x9zU+QnDqn1SLK3JLXMD8RYNoax+gh3NVEQ@mail.gmail.com>
Subject: Re: [PATCH 3/4 RESEND] crypto: octeontx2: Fix address alignment on
 CN10K A0/A1 and OcteonTX2
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Bharat Bhushan <bbhushan2@marvell.com>, bbrezillon@kernel.org, arno@natisbad.org, 
	schalla@marvell.com, davem@davemloft.net, giovanni.cabiddu@intel.com, 
	linux@treblig.org, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, May 19, 2025 at 9:57=E2=80=AFAM Herbert Xu <herbert@gondor.apana.or=
g.au> wrote:
>
> On Wed, May 14, 2025 at 10:40:42AM +0530, Bharat Bhushan wrote:
> >
> > @@ -429,22 +431,50 @@ otx2_sg_info_create(struct pci_dev *pdev, struct =
otx2_cpt_req_info *req,
> >               return NULL;
> >       }
> >
> > -     g_sz_bytes =3D ((req->in_cnt + 3) / 4) *
> > -                   sizeof(struct otx2_cpt_sglist_component);
> > -     s_sz_bytes =3D ((req->out_cnt + 3) / 4) *
> > -                   sizeof(struct otx2_cpt_sglist_component);
> > +     /* Allocate memory to meet below alignment requirement:
> > +      *  ----------------------------------
> > +      * |    struct otx2_cpt_inst_info     |
> > +      * |    (No alignment required)       |
> > +      * |     -----------------------------|
> > +      * |    | padding for 8B alignment    |
> > +      * |----------------------------------|
> > +      * |    SG List Gather/Input memory   |
> > +      * |    Length =3D multiple of 32Bytes  |
> > +      * |    Alignment =3D 8Byte             |
> > +      * |----------------------------------|
> > +      * |    SG List Scatter/Output memory |
> > +      * |    Length =3D multiple of 32Bytes  |
> > +      * |    Alignment =3D 8Byte             |
> > +      * |    (padding for below alignment) |
> > +      * |     -----------------------------|
> > +      * |    | padding for 32B alignment   |
> > +      * |----------------------------------|
> > +      * |    Result response memory        |
> > +      *  ----------------------------------
> > +      */
> >
> > -     dlen =3D g_sz_bytes + s_sz_bytes + SG_LIST_HDR_SIZE;
> > -     align_dlen =3D ALIGN(dlen, align);
> > -     info_len =3D ALIGN(sizeof(*info), align);
> > -     total_mem_len =3D align_dlen + info_len + sizeof(union otx2_cpt_r=
es_s);
> > +     info_len =3D sizeof(*info);
> > +
> > +     g_len =3D ((req->in_cnt + 3) / 4) *
> > +              sizeof(struct otx2_cpt_sglist_component);
> > +     s_len =3D ((req->out_cnt + 3) / 4) *
> > +              sizeof(struct otx2_cpt_sglist_component);
> > +
> > +     dlen =3D g_len + s_len + SG_LIST_HDR_SIZE;
> > +
> > +     /* Allocate extra memory for SG and response address alignment */
> > +     total_mem_len =3D ALIGN(info_len, OTX2_CPT_DPTR_RPTR_ALIGN) + dle=
n;

This add extra memory for 8-byte (OTX2_CPT_DPTR_RPTR_ALIGN) alignment

> > +     total_mem_len =3D ALIGN(total_mem_len, OTX2_CPT_RES_ADDR_ALIGN) +
> > +                      sizeof(union otx2_cpt_res_s);

This add extra memory for 32-byte (OTX2_CPT_RES_ADDR_ALIGN))
In case not observed,  OTX2_CPT_RES_ADDR_ALIGN is not the same as
OTX2_CPT_DPTR_RPTR_ALIGN.

>
> This doesn't look right.  It would be correct if kzalloc returned
> a 32-byte aligned pointer to start with.  But it doesn't anymore,
> which is why you're making this patch in the first place :)
>
> So you need to add extra memory to bridge the gap between what it
> returns and what you expect.  Since it returns 8-byte aligned
> memory, and you expect 32-byte aligned pointers, you should add
> 24 bytes.
>
> IOW the calculation should be:
>
>         total_mem_len =3D ALIGN(info_len, OTX2_CPT_DPTR_RPTR_ALIGN) + dle=
n;
>         total_mem_len =3D ALIGN(total_mem_len, OTX2_CPT_DPTR_RPTR_ALIGN);
>         total_mem_len +=3D (OTX2_CPT_RES_ADDR_ALIGN - 1) &
>                          ~(OTX2_CPT_DPTR_RPTR_ALIGN - 1);
>
> >       info =3D kzalloc(total_mem_len, gfp);
> >       if (unlikely(!info))
> >               return NULL;
> >
> >       info->dlen =3D dlen;
> > -     info->in_buffer =3D (u8 *)info + info_len;
> > +     info->in_buffer =3D PTR_ALIGN((u8 *)info + info_len,
> > +                                 OTX2_CPT_DPTR_RPTR_ALIGN);
> > +     info->out_buffer =3D info->in_buffer + 8 + g_len;
>
> I presume the 8 here corresponds to SG_LIST_HDR_SIZE from the dlen
> calculation above.  If so please spell it out as otherwise it's just
> confusing.

Yes, this is for SG_LIST_HDR_SIZE, will use same here.

Thanks
-Bharat

>
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
