Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0572439F66
	for <linux-crypto@vger.kernel.org>; Tue,  4 Aug 2026 08:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785833267; cv=pass; b=lIHEfnr9+R5CKOajWkVmiCn4IcB3grridYSpBmbXRjlRAheH4/igpyJL3+SXxBRZe0JypXLZroNYwIBIsd3zmdV6Byu6v7n3x3xPVBQXFduT4wCqYDKifo02lMlK2QgaFbPlwni6+r3e3rpqqzLdlCvu9o/B8/v5f2JcCaAJG2o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785833267; c=relaxed/simple;
	bh=EDsXnn8Di4gWusHH0L98J9lbJovO3WcIQcUtoghafX4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ba6dd+oPmhYNFMP0DTFBlSOSfpwDf7OfoltQYmpN+DeT2mpvEBiVMnJebS7jqNrebOKU4yFq2v4hm1lzv0gEiqY59hrlzfn3EstFOiqH58Jrlf+lsInuxVTPvOErLHki32kdXZAZuYs9vm11kD1mzqyOe1hw1Sy3by9+R6n9DdE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=E2cR17DE; arc=pass smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E2cR17DE"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6a0ddef4e35so3149728a12.2
        for <linux-crypto@vger.kernel.org>; Tue, 04 Aug 2026 01:47:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785833264; cv=none;
        d=google.com; s=arc-20260327;
        b=imDR8OhiGoa3cnrNc9+0PDzmKFfkUWsfP3G0ZJ5VwggdN4fMhrvKfkhRMlbPjsWBu/
         zKiGXsqaPe+B4wqyBmZAr3PYnDDyJNGN9VdQQ0dKORUnUjOVvZdltt+IPw0/APs3KncZ
         gSOfx4xAhP7KHMgQNcL228Fkfh1gUkrLksAXVV8yZ19vsx1Z1HfwBRQQPN/xlG1r9xPV
         njw3FrKvCDDvTawCT2wA3MU0Ldj2ty/F768C1JT6rl1BfXwbFwUIvRhlXJZ5my3H5D/K
         MNSemjumw8ckkEOgnIXNDcaSlVVzrIK3lmV0xfKjqvMAnoDg3UgxswNSFBcpMqXXfSMd
         jIKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=PEqd+ZWTPxL49LxbuVR3ifbNbPtx5D5bB35ut3i3dWQ=;
        fh=5K6/ghwykrH4po4NMcsMy4vch7JuwUzxT1Z2Z7gxVw4=;
        b=OCSOuy3B18nIyeJDfgOBKdB3t7UmckEDd4ATUl7L4atZzH82XYNmTS1ijLMrb1u4Ny
         4TsFJ5y6Qg+qNBde+TuGgvaNxHHPTsVucBPGwTA6CXPh0kuQEN9XKQfOgt8IhErcfom4
         sCTiwzxrSlHWiCwVZa4G0zKgz6/mwEcp/opzRPGaJVdfqD7/CEvaHdyN5l3TDaK7tOnz
         Nnq0IgEF7FehQ3+QmOhidEcRQKczD4IWTni3AAs24MOGol28tIr9+enT6Zy8GVxx3CH+
         q9OU6O7H6b1LgHjZL6CubLUkk/6FIxhrvZevBEFzWdwh0RljTZvE92GDik0Sf/sw1C62
         CATA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785833264; x=1786438064; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=PEqd+ZWTPxL49LxbuVR3ifbNbPtx5D5bB35ut3i3dWQ=;
        b=E2cR17DE42Mx9lggP15H++IrABmo34HQ1b1KlMQkQFhAxoOKHpMbmz/rHlSbH6HsKD
         Qo7WSjpF9nGgNJeXuviQdkV2MKy5Sjv49AETtw0c8yzxzsGQy2LwRRqPddzbPjmTnaLI
         SKg8u9DSP1BTbsSD+kmfjxZhJeBAZrGrL2wuDRl4o+pKXc9v9//4VsCfxvPP5kMxEM5M
         cWu2LQcor7CsdNk7whS6DFvFWBOzRrS+lH4hm9VB0Fb1/MvythBpB41PudOtzMCrBxDH
         UK+EO62Is/Vd6irmb7qbyG+WSJziyBQTrORNS10iiCREHLJuUbTFk7undcoI02nq/sMH
         8d0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785833264; x=1786438064;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PEqd+ZWTPxL49LxbuVR3ifbNbPtx5D5bB35ut3i3dWQ=;
        b=Y8M/Drj6CvzjrQ4mOagBg5l7Vzq9Yny2fAPGZ5/2U6f6+bQzbOWhkh69TAlRM0SuoP
         P/UOadlO9Ry5cIQlakGlE36F7XiglF2ghjpMVqU4v2KoncbpdtYQzDf1ZMsnSVVcGZhv
         NaDiFXWaoVsFtwMObJxlwipAAXZPX9Mk4IAfxJr5hTZHsPlFxR0j9NKN8o4Ul+9A9ydA
         jj6K4yQGBtlRAPhza67tsiV/CnNxCkvs55GR4cUhvuSzJy9zE5fw1Pr11h1YUn+VgZmx
         oQJITvPgD0VfHErY6cD/42x+PgGaO8swHQ9Np5HIVpSSsBo1ghMbdBnacM199Mb38JOI
         ZuoA==
X-Gm-Message-State: AOJu0YyfzW/FVt5LgmrZXMgfmXya+FTHxnb4OiDWc2mMxpySirvMtFBV
	ERuVE3ELlpUdiUSAU0w/KrRI3k464VYiGi6C/cRyTIez56NthraaClEDzZxBb01+jDPbsqqpyxH
	Hkv8I7NVzEHSfsXmHLB65yz3Ni2CnYjHukg==
X-Gm-Gg: AR+sD10F6WO67Q0gCZSyJdBq4MJq/3fphbQUACemDssE/CH9ZF32zyKX1+GtAR8QMa1
	1MtBg7INUSoYmCO8nUqEk7mUyC50mj7qR9GquJFwu5SvaAX7PpeVSQFqLo64QYlx2FcuCfBUY8p
	UWhVfE1ynjscwAs3K8KwEKzyC/OAADI2n5UIabaa7AIX849OHbMJKGH5LIMqW/YJgPg06zLDpbS
	NCRZsKSEaYHoSCeMyh5PteBAnS+4wZLYWOu8YvQYNS9uBrM1chmzVUkIV+Xp5luy4BnGTrhGc5O
	WzKNC+Sie1ERZ680hm5/Rb6c3RvBmPuARv3V5bOxyltqY3UWbY7F9BRUjXQLrvmvhsHaaQvEp14
	zLbXO3GS8tJHi1LYXvVDp+iMuH5hitCcZ2gsiWBTgUt19rhNq2IFySsfaNcKLb5NdoMkchrIEeo
	M2kfTMLkZr8bjCf4pMpT92DoqDn4FBMvg8Ufyt+BHM4PBvHrZmXCp33a4=
X-Received: by 2002:a05:6402:52c2:b0:698:5f89:9a51 with SMTP id
 4fb4d7f45d1cf-6a0a7c60fa3mr10770360a12.5.1785833263890; Tue, 04 Aug 2026
 01:47:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260803224028.87631-1-rosenp@gmail.com> <8e0dc8db-bfb7-40f4-b6f8-fc773e8b74f1@redhat.com>
 <CAKxU2N9=qABcpCoQSJ+LeLu0nZj-XBdhetoecwsfRGky+Vgc9w@mail.gmail.com> <b4d28139-941d-4b36-808d-5c41d370a237@redhat.com>
In-Reply-To: <b4d28139-941d-4b36-808d-5c41d370a237@redhat.com>
From: Rosen Penev <rosenp@gmail.com>
Date: Tue, 4 Aug 2026 01:47:32 -0700
X-Gm-Features: AUfX_mzNEAyoOHtQCIPW_HwakxjROKMWJD7od1R36oBJT0J9fGberv98m0h3rTo
Message-ID: <CAKxU2N93kpikbASYSLvkSpLU3Sgd-U_SW8rypBVZD8mjfMypYQ@mail.gmail.com>
Subject: Re: [PATCH] crypto: eip93 - use struct_size() and flexible array for
 ring allocation
To: Thomas Huth <thuth@redhat.com>
Cc: linux-crypto@vger.kernel.org, Christian Marangi <ansuelsmth@gmail.com>, 
	Antoine Tenart <atenart@kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 4, 2026 at 12:47=E2=80=AFAM Thomas Huth <thuth@redhat.com> wrot=
e:
>
> On 04/08/2026 09.18, Rosen Penev wrote:
> > On Tue, Aug 4, 2026 at 12:11=E2=80=AFAM Thomas Huth <thuth@redhat.com> =
wrote:
> >>
> >> On 04/08/2026 00.40, Rosen Penev wrote:
> >>> Embed the single ring as a flexible array member in eip93_device
> >>> instead of allocating it separately. This simplifies the probe path
> >>> and uses struct_size() for a single allocation.
> >>>
> >>> Assisted-by: opencode:big-pickle
> >>> Signed-off-by: Rosen Penev <rosenp@gmail.com>
> >>> ---
> >>>    .../crypto/inside-secure/eip93/eip93-main.c   |  6 +----
> >>>    .../crypto/inside-secure/eip93/eip93-main.h   | 22 +++++++++------=
----
> >>>    2 files changed, 12 insertions(+), 16 deletions(-)
> >>>
> >>> diff --git a/drivers/crypto/inside-secure/eip93/eip93-main.c b/driver=
s/crypto/inside-secure/eip93/eip93-main.c
> >>> index 1a8dabc4ada4..e62785952b0d 100644
> >>> --- a/drivers/crypto/inside-secure/eip93/eip93-main.c
> >>> +++ b/drivers/crypto/inside-secure/eip93/eip93-main.c
> >>> @@ -415,7 +415,7 @@ static int eip93_crypto_probe(struct platform_dev=
ice *pdev)
> >>>        u32 ver, algo_flags;
> >>>        int ret;
> >>>
> >>> -     eip93 =3D devm_kzalloc(dev, sizeof(*eip93), GFP_KERNEL);
> >>> +     eip93 =3D devm_kzalloc(dev, struct_size(eip93, ring, 1), GFP_KE=
RNEL);
> >>>        if (!eip93)
> >>>                return -ENOMEM;
> >>>
> >>> @@ -436,10 +436,6 @@ static int eip93_crypto_probe(struct platform_de=
vice *pdev)
> >>>        if (ret)
> >>>                return ret;
> >>>
> >>> -     eip93->ring =3D devm_kcalloc(eip93->dev, 1, sizeof(*eip93->ring=
), GFP_KERNEL);
> >>> -     if (!eip93->ring)
> >>> -             return -ENOMEM;
> >>> -
> >>>        ret =3D eip93_desc_init(eip93);
> >>>        if (ret)
> >>>                return ret;
> >>> diff --git a/drivers/crypto/inside-secure/eip93/eip93-main.h b/driver=
s/crypto/inside-secure/eip93/eip93-main.h
> >>> index 990c2401b7ce..5f0f51081743 100644
> >>> --- a/drivers/crypto/inside-secure/eip93/eip93-main.h
> >>> +++ b/drivers/crypto/inside-secure/eip93/eip93-main.h
> >>> @@ -92,17 +92,6 @@
> >>>                                                    EIP93_HASH_SHA224 =
| \
> >>>                                                    EIP93_HASH_SHA256)=
)
> >>>
> >>> -/**
> >>> - * struct eip93_device - crypto engine device structure
> >>> - */
> >>> -struct eip93_device {
> >>> -     void __iomem            *base;
> >>> -     struct device           *dev;
> >>> -     struct clk              *clk;
> >>> -     int                     irq;
> >>> -     struct eip93_ring               *ring;
> >>> -};
> >>> -
> >>>    struct eip93_desc_ring {
> >>>        void                    *base;
> >>>        void                    *base_end;
> >>> @@ -131,6 +120,17 @@ struct eip93_ring {
> >>>        struct idr                      crypto_async_idr;
> >>>    };
> >>>
> >>> +/**
> >>> + * struct eip93_device - crypto engine device structure
> >>> + */
> >>> +struct eip93_device {
> >>> +     void __iomem            *base;
> >>> +     struct device           *dev;
> >>> +     struct clk              *clk;
> >>> +     int                     irq;
> >>> +     struct eip93_ring       ring[];
> >>> +};
> >> This looks weird, too. If there is always only one "ring", why don't y=
ou
> >> embed it without the "[]" into the struct eip93_device directly?
> > keeps all callers the same. -> vs .
> So it's basically keeping the patch small and generating many WTFs for
> future reviewers of the code vs. having a bigger patch now and better
> understable code in the future. Not my decision (it's up to the
> maintainers), but FWIW I'd rather go with option 2.
>
> Anyway, if you want to keep it short, wouldn't it also be possible to
> declare it as ring[1] instead and then keep the sizeof() instead of the
> struct_size() ?
No because [1] arrays are deprecated.
>
>   Thomas
>
