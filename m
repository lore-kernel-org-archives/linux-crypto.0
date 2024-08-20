Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com [209.85.128.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AA3B19E7E9
	for <linux-crypto@vger.kernel.org>; Tue, 20 Aug 2024 17:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724174046; cv=none; b=jHgawUgXmrt1nVg9zM9qfDoXfvqaUiTb71tDwQGJHvLmDN8bLwXN1h1SSWkdKfNYufzqgHdiJ0M6t8mEcB7n7P0ko2fGFVNDytPsiXWJ++p6D5rsGoeaU6cH6TyqXA3g5TnXIXOzM10g8/QAirPxSVmMMA7D4r58942PZrAjVVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724174046; c=relaxed/simple;
	bh=2lVkKdqehJG04jhZ3pW5ceonBsh1Cq0qoNCVFsBOVBo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HbYpaJVTZ9G3fhANldy+YJY7AxwsiwKln3j0V/EK4IfHidmgURGoa4QDatH5qOuc8+iWvU3Sj8i27IpEsZLhcsPhyVJK7HoOqO4INASar/BR4eV9v2tulwT8/MV+wL48LS9UvtdFCnQqmJCojAsyvycJIqk899ZhxkQammr+By8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=lMfoMHxe; arc=none smtp.client-ip=209.85.128.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="lMfoMHxe"
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-6bd3407a12aso16692257b3.3
        for <linux-crypto@vger.kernel.org>; Tue, 20 Aug 2024 10:14:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1724174044; x=1724778844; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BwGK+7G7r3d4CJEjvTfV9YmJ/I67fGFPGs7io7rtb3o=;
        b=lMfoMHxePxF01DLnlY2zUM1cG74XeX0N+hgfgJl8GPMadK4GIxTnLJg9XTt1srw2xR
         8MBirWzljgsBmk2cl43yo5C98o5gkToJ0zeBZsBTTQ3jlVomB6/NA4lb49moS5DhUwRv
         Yrebt7MIvjSwpcgjAS9EYmPcRHLf95Q08XPyo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724174044; x=1724778844;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BwGK+7G7r3d4CJEjvTfV9YmJ/I67fGFPGs7io7rtb3o=;
        b=YHtpeNNmq45ivR2+R6lKDo+nhDq7+ZU5DI02ZOzxEX7sVGfGFm5cOvYyR7for2cWFx
         O5Ac8oa5f0S+FwDO3Q4t1zPcgfAQ7FXbR2wbx2Fu5QMcNrZk6x7CpAnrpiVFpQhh7Ofb
         JviNRVKs3OMHo98eOjVqvcT8/TAEale4Kz0bFuevOPbvoFxAZUl5ReNcDoyAFbsNKmp4
         bUJEtvHwPN7kvoRvYVb6FIND32dwuitNIOvE3udZFssAhMKLi9VKZvn5PNEfE/7XYk1W
         Gz3l+zA3Wn41eoNpuYytTzFtca8TRRT5hTDkdWmqGVwF/57znTe/MYdXnnil1sP1Insu
         o0/w==
X-Forwarded-Encrypted: i=1; AJvYcCVYL3qTp8QTiDaWggPqgReyW9DTT0v1y4sDaWQOOCZ+x8RDFK1ObHO/TIRQ5oEUvqPgzgmNElGMvtVyQVM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxftLLFnEjkTfdL/vCD/8ahGiQGSS8kGK6FeTeK9/9ngABHBP8N
	TmchGGJjFF4SK3Ah2Npwdr1qGK+gWOnAQo9Gf3hJSYlnkPf5MXJ5pJNoMuQZyZKwhuUZ/yClQqw
	7pthZtCYmlSTGWSCUZcofZQ6k5ui2r9U/CNxK4Jv2WZj7bEQm72w=
X-Google-Smtp-Source: AGHT+IHUekorS04ibCuz2TyT2Kz+zw3a1Ep/tdutGrTztzL+QGwys5f8o96Ch/MK5KMKsRoeqXNf6S8IVBNcO6UJrWg=
X-Received: by 2002:a05:690c:108:b0:665:54fa:5abf with SMTP id
 00721157ae682-6b1b9b5af53mr196871907b3.2.1724174044068; Tue, 20 Aug 2024
 10:14:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240621082053.638952-1-pavitrakumarm@vayavyalabs.com>
 <20240621082053.638952-7-pavitrakumarm@vayavyalabs.com> <20240820-bunion-cloud-89ab9ac2d82c@spud>
In-Reply-To: <20240820-bunion-cloud-89ab9ac2d82c@spud>
From: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
Date: Tue, 20 Aug 2024 22:43:53 +0530
Message-ID: <CALxtO0mxakJbDdaZyUZ3sjn9BsoZ4janJEC-=kOxb9-_mh4npA@mail.gmail.com>
Subject: Re: [PATCH v5 6/7] Add SPAcc dts overlay
To: Conor Dooley <conor@kernel.org>
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org, 
	Ruud.Derwig@synopsys.com, manjunath.hadli@vayavyalabs.com, 
	bhoomikak@vayavyalabs.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Conor,
  This is SPAcc v5 patch-set.
  In SPAcc v7 patch-set (which was merged by Herbert on crypto-dev)
this DTS overlay is dropped.
  I will be pushing a yaml patch to document the DTS bindings separately.

Warm regards,
PK

On Tue, Aug 20, 2024 at 9:54=E2=80=AFPM Conor Dooley <conor@kernel.org> wro=
te:
>
> On Fri, Jun 21, 2024 at 01:50:52PM +0530, Pavitrakumar M wrote:
> > Signed-off-by: Manjunath Hadli <manjunath.hadli@vayavyalabs.com>
> > Signed-off-by: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
> > Acked-by: Ruud Derwig <Ruud.Derwig@synopsys.com>
>
> In case it is not clear from Geert's mail earlier today, NAK to merging
> any of this without bindings.
>
> Thanks,
> Conor.
>
> > ---
> >  arch/arm64/boot/dts/xilinx/Makefile           |  3 ++
> >  .../arm64/boot/dts/xilinx/snps-dwc-spacc.dtso | 35 +++++++++++++++++++
> >  2 files changed, 38 insertions(+)
> >  create mode 100644 arch/arm64/boot/dts/xilinx/snps-dwc-spacc.dtso
> >
> > diff --git a/arch/arm64/boot/dts/xilinx/Makefile b/arch/arm64/boot/dts/=
xilinx/Makefile
> > index 1068b0fa8e98..1e98ca994283 100644
> > --- a/arch/arm64/boot/dts/xilinx/Makefile
> > +++ b/arch/arm64/boot/dts/xilinx/Makefile
> > @@ -20,6 +20,7 @@ dtb-$(CONFIG_ARCH_ZYNQMP) +=3D zynqmp-zcu1275-revA.dt=
b
> >
> >  dtb-$(CONFIG_ARCH_ZYNQMP) +=3D zynqmp-sm-k26-revA.dtb
> >  dtb-$(CONFIG_ARCH_ZYNQMP) +=3D zynqmp-smk-k26-revA.dtb
> > +dtb-$(CONFIG_ARCH_ZYNQMP) +=3D zynqmp-smk-k26-revA.dtb
> >
> >  zynqmp-sm-k26-revA-sck-kv-g-revA-dtbs :=3D zynqmp-sm-k26-revA.dtb zynq=
mp-sck-kv-g-revA.dtbo
> >  dtb-$(CONFIG_ARCH_ZYNQMP) +=3D zynqmp-sm-k26-revA-sck-kv-g-revA.dtb
> > @@ -29,3 +30,5 @@ zynqmp-smk-k26-revA-sck-kv-g-revA-dtbs :=3D zynqmp-sm=
k-k26-revA.dtb zynqmp-sck-kv-
> >  dtb-$(CONFIG_ARCH_ZYNQMP) +=3D zynqmp-smk-k26-revA-sck-kv-g-revA.dtb
> >  zynqmp-smk-k26-revA-sck-kv-g-revB-dtbs :=3D zynqmp-smk-k26-revA.dtb zy=
nqmp-sck-kv-g-revB.dtbo
> >  dtb-$(CONFIG_ARCH_ZYNQMP) +=3D zynqmp-smk-k26-revA-sck-kv-g-revB.dtb
> > +zynqmp-zcu104-revC-snps-dwc-spacc-dtbs :=3D zynqmp-zcu104-revC.dtb snp=
s-dwc-spacc.dtbo
> > +dtb-$(CONFIG_ARCH_ZYNQMP) +=3D zynqmp-zcu104-revC-snps-dwc-spacc.dtb
> > diff --git a/arch/arm64/boot/dts/xilinx/snps-dwc-spacc.dtso b/arch/arm6=
4/boot/dts/xilinx/snps-dwc-spacc.dtso
> > new file mode 100644
> > index 000000000000..603ad92f4c49
> > --- /dev/null
> > +++ b/arch/arm64/boot/dts/xilinx/snps-dwc-spacc.dtso
> > @@ -0,0 +1,35 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * dts file for Synopsys DWC SPAcc
> > + *
> > + * (C) Copyright 2024 Synopsys
> > + *
> > + * Ruud Derwig <Ruud.Derwig@synopsys.com>
> > + */
> > +
> > +/dts-v1/;
> > +/plugin/;
> > +
> > +/ {
> > +     #address-cells =3D <2>;
> > +     #size-cells =3D <2>;
> > +
> > +     fragment@0 {
> > +             target =3D <&amba>;
> > +
> > +             overlay1: __overlay__ {
> > +                     #address-cells =3D <2>;
> > +                     #size-cells =3D <2>;
> > +
> > +                     dwc_spacc: spacc@400000000 {
> > +                             compatible =3D "snps-dwc-spacc";
> > +                             reg =3D /bits/ 64 <0x400000000 0x3FFFF>;
> > +                             interrupts =3D <0 89 4>;
> > +                             interrupt-parent =3D <&gic>;
> > +                             clock-names =3D "ref_clk";
> > +                             spacc_priority =3D <0>;
> > +                             spacc_index =3D <0>;
> > +                     };
> > +             };
> > +     };
> > +};
> > --
> > 2.25.1
> >
