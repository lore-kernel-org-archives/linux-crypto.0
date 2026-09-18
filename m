Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AE3342885A
	for <linux-crypto@vger.kernel.org>; Fri, 18 Sep 2026 20:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.225.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789764930; cv=pass; b=FUFpmEV4kA7cJRURydpEMTPAa3pw3kAZ/LejMhxl5+Xu4qPIdbf2ij6vw5KwFXgR/1TEPXDSLCVagfCm2wjD+oId9lWtXxXkMc24eOZRNfdDVpTQzy8u3Orwxx5q+j8tiTswHrKhdLxz7YTTbInoOYaVmQAHxx5aDVXQhOEXZCA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789764930; c=relaxed/simple;
	bh=luig+1o1M/fsF9vaNIsARo6CqC/xBHmV9/YvD0slYb0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ec2uw4dv8iGmqgssQUUqmZ2GwZil7CisfYY/zCP6sLYZfqTPUqvcBcLrg+2iuELM+c2lC3bYnBzQ3fDSV2KPAYzawsNvdbXGhCbLC4fZTHO4CKP6mJ6bsUMRuPbcQalpx1hPpf6L/tawR+oEmFz69Vwz+YCNBMI5zTkPAEaPXxY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QgvfrAyV; arc=pass smtp.client-ip=74.125.225.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QgvfrAyV"
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49fbdc010d7so330855e9.0
        for <linux-crypto@vger.kernel.org>; Fri, 18 Sep 2026 13:55:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789764927; cv=none;
        d=google.com; s=arc-20260327;
        b=DgglhKSTHdXCEiN8tY8xbpwf3Gon6UIsdGGLlG+ew8NKVNKCdxuSfYppJ5RWub1zfg
         vGFlgcMRGfQ2b1KwbOcPx6VrEBMizDHFD+zvZDMgIjCfylqAVgNmq+RX4j7RDi9Xr5Vi
         Nmc9+8yMcqVwSCMC2u50/PK2btmYYDRVsIHXXv91FH1DsS3+aPbx0lwNoSeQOzzXsYMD
         HZ3ThrogqlQMFx05HkpHPTqWozxdCUZmtYbPhVYuwnQwofAZw6SqsgoMyzIb+4ffcSpG
         lhpHOOa+jJMyFPVXrlRRs1+0NpSKGCZzFpCCDPBNcLSAXKgMA82qK4MOgpzd3CPJFlQc
         DXQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=sgTcRorf9vWGoUo+DaV05plknDxMZzVIVIvRR476748=;
        fh=wiSDzc2yo011fFLH8rVCU/alWy7HqlZWy8zO2GNVNls=;
        b=LTDNoLzHXf+CpJyBmMhSi+QRi2g4v/kmOyBOkO+s2efpnntml7uHX004ua2dyV+Aqt
         GmrXkIwVMWIBJgrgCG4MctSFN97URkll6JIQK7dDUyt2/9onX/R91o0D0+Pc1FF5TiMD
         S84KMfmAyf612vnSlUsRNxqZ11eE8r7/0EwhbjDJ0akEUIgOOnUgwH1IQjfnEaimDSEV
         6HK3snEglpAZXLoszaVqwe8anir9zuW6AkrTdMERADCybu1zf7nQhDPZqMDP1ukDCAFU
         ydFwE6fM36yx7/tX2XbQlXstU9/EctmThFw4nEFvCAGFbvCQJvXNzAFGjTC54GwPOx0u
         GhKA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789764927; x=1790369727; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=sgTcRorf9vWGoUo+DaV05plknDxMZzVIVIvRR476748=;
        b=QgvfrAyVtarzFii+eQWDsnHGq4Y9Hg6vLJpArY54u/yeCWeXNT0q2xiAK+xmfxKc+n
         qvPKfSuBe9GNjYH2FOcZzMz8fKUWqpUKMg4iyLnIw7uyzZ8gGK2u2inY8qtQTrg81zw9
         Xgx/zzo6ZneW58DnSliy5LFJFb/usXMuuHouLK3hks46uAPXmNBiMH7mIj2g2C37eiTG
         ajbMRq0u+xFmnVnCj18FjfqFh/J6ldxPnZafjDZnxKiFvBOVUOy1wlRv0vHtLxQFZlYO
         nF2u/0g/Rdb4oANUJRVMJMwPcmMywDEBTBqtB/iawN0WEHZStzF3tmZn40g8jYWZ1sI5
         N6lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789764927; x=1790369727;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sgTcRorf9vWGoUo+DaV05plknDxMZzVIVIvRR476748=;
        b=OwvDeE6Jn2kZxLvqPCMW3DAfZVoaaGq6iElyKV9npGfZY6es4UDD1c0KamlRr2+7pJ
         72z2jt+yHHFfkMEx8c0x9HWDN2rH+662CXjOy+eguUpJF3Mf1sz2GrQ5P9NbHrlM9iUK
         IjH4KBr2532CZUCyZwSAEz4m7iGBL/+GnJZ675nzjsybnLHMyagw+kkwA9KlATc4fLi9
         L3jcpZgf254x+PHC5yBJjh6NcSHTenjO3EGZAYBjFWdzqGD45AW/Nb/4tH2QuMb+m1K8
         pOhL8fWBQrgdkur8jTXLAi8XZajUXhHdo5j28EQKJ0BVarFonKylv5LWJRD8jDgqdH9/
         Vx4w==
X-Forwarded-Encrypted: i=1; AKwUvBwNsMt8aBU57JSX0l3nEQ6Va75kV/V3G2WKXQ16Zeff6s3D9rstQMIcNutss+XfhgkO0TRNBjytTzFbRkU=@vger.kernel.org
X-Gm-Message-State: AFuF++lJgRAMoUlmXNzoVCVMWodQrXwJsXtYE0y9P6Hb58pl+hgMcG9U
	nnDK/17ozYnq0jcKmR+d//lWK3WUF1z4xg3YPMHU+jdckwlp+QFeU2nWRqRXUviyWkpAIdJKVNa
	Yqf5RBVAHzg7rgG8oPkemz42P7bwoD/4=
X-Gm-Gg: AYBFou12WIlbmoSDzBMjbFRovIqt3XywERNxbnxyOM0b5vFMzuFJBzC2fGfcHyl3wUh
	/8WRHdshnux4QI/HyOiv1POEycmRqVQJTgiDWalUxukoI/WMy7dDtvPtazLCjikNmlbqj2BcQqq
	PST52tv7BqD8mtRPhZ+QDP7fritjEK55cKbG+gD2ONJ/nJxZR890VlJYpolIly0ksTWkxeuS2c/
	Hv0rWZaTPR5IWYosMIZz/6pcZ/0OtfmJg+yo5j7QQBq3g7811vouki1nVE7+GTMNtUmhf0pQVCU
	iRBMDTmTbYpyCdpkIa8doj3EAmU8JzQ0cP4FGpKmpOoLyTE+QeKdZgGM4xghbYrGK3iLBCsIGGB
	tWK/PjFx+S8Q0JnjpMi3+CMc=
X-Received: by 2002:a17:907:d02:b0:c25:3ccf:bd9c with SMTP id
 a640c23a62f3a-c2a1a8e09e8mr331776566b.2.1789764477295; Fri, 18 Sep 2026
 13:47:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260916-ti-dra7-omap-sham-fix-v2-0-4eadb60081e5@gmail.com>
 <20260916-ti-dra7-omap-sham-fix-v2-2-4eadb60081e5@gmail.com> <20260918144224.4dfb8515@kemnade.info>
In-Reply-To: <20260918144224.4dfb8515@kemnade.info>
From: Bhargav Joshi <j.bhargav.u@gmail.com>
Date: Sat, 19 Sep 2026 02:17:44 +0530
X-Gm-Features: AcwNN1WKvA-fdN2xNZdCXGZd1cxpuLrv71RZ7MqA3wlpHyScvRfY20wc8pzPN-Q
Message-ID: <CAOWyW_5GU__FE25POrjKH=CmOHaeBRJPw4xS2cdodePm3LydhA@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] ARM: dts: ti: omap: dra7: Remove clocks from
 crypto nodes
To: Andreas Kemnade <andreas@kemnade.info>
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>, Kevin Hilman <khilman@baylibre.com>, 
	Roger Quadros <rogerq@kernel.org>, Tony Lindgren <tony@atomide.com>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	Animesh Agarwal <animeshagarwal28@gmail.com>, linux-omap@vger.kernel.org, 
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 18, 2026 at 6:12=E2=80=AFPM Andreas Kemnade <andreas@kemnade.in=
fo> wrote:
>
> On Wed, 16 Sep 2026 02:29:39 +0530
> Bhargav Joshi <j.bhargav.u@gmail.com> wrote:
>
> > The omap-sham, omap4-des and omap2-aes crypto drivers do not use
> > "clocks" and "clock-names" properties. Clock management is handled by
> > the ti-sysc interconnect parent wrapper. The dt-bindings for
> > ti,omap-sham and ti,omap-aes don't define these clock properties. Havin=
g
> > them in the child nodes causes dtbs_check warnings.
> >
> > Remove the "clocks" and "clock-names" properties from the sham, des and
> > aes nodes.
> >
> > Reviewed-by: Andreas Kemnade <andreas@kemnade.info>
> > Signed-off-by: Bhargav Joshi <j.bhargav.u@gmail.com>
>
> I was a bit too fast here, clocks here are different from what is
> used in the ti-sysc block. So some more thought and argumenting is needed=
.
Clocking is handled by ti-sysc parent block, furthermore other dtsi
such as omap5,
omap4, am4372 which uses the same hardware doesn't define any clock in
the child node.
parent block defines a clock with clock-name: fck
clocks =3D <&l4sec_clkctrl DRA7_L4SEC_AES2_CLKCTRL 0>;
clock-names =3D "fck";
and child main part as
clocks =3D <&l3_iclk_div>;
clock-names =3D "fck";
If child node needs this separate clock  in child node then binding
for aes and sham needs
to be updated to allow clocks and clock-names leaving des binding as it is.

Best Regards,
Bhargav
>
> Regards,
> Andreas
>
> > ---
> >  arch/arm/boot/dts/ti/omap/dra7-l4.dtsi | 2 --
> >  arch/arm/boot/dts/ti/omap/dra7.dtsi    | 8 --------
> >  2 files changed, 10 deletions(-)
> >
> > diff --git a/arch/arm/boot/dts/ti/omap/dra7-l4.dtsi b/arch/arm/boot/dts=
/ti/omap/dra7-l4.dtsi
> > index a595745afe59..bca035fd7e62 100644
> > --- a/arch/arm/boot/dts/ti/omap/dra7-l4.dtsi
> > +++ b/arch/arm/boot/dts/ti/omap/dra7-l4.dtsi
> > @@ -2086,8 +2086,6 @@ des: des@0 {
> >                               interrupts =3D <GIC_SPI 77 IRQ_TYPE_LEVEL=
_HIGH>;
> >                               dmas =3D <&sdma_xbar 117>, <&sdma_xbar 11=
6>;
> >                               dma-names =3D "tx", "rx";
> > -                             clocks =3D <&l3_iclk_div>;
> > -                             clock-names =3D "fck";
> >                       };
> >               };
> >
> > diff --git a/arch/arm/boot/dts/ti/omap/dra7.dtsi b/arch/arm/boot/dts/ti=
/omap/dra7.dtsi
> > index 711ce4c31bb1..0784c6d9cbe4 100644
> > --- a/arch/arm/boot/dts/ti/omap/dra7.dtsi
> > +++ b/arch/arm/boot/dts/ti/omap/dra7.dtsi
> > @@ -1012,8 +1012,6 @@ aes1: aes@0 {
> >                               interrupts =3D <GIC_SPI 80 IRQ_TYPE_LEVEL=
_HIGH>;
> >                               dmas =3D <&edma_xbar 111 0>, <&edma_xbar =
110 0>;
> >                               dma-names =3D "tx", "rx";
> > -                             clocks =3D <&l3_iclk_div>;
> > -                             clock-names =3D "fck";
> >                       };
> >               };
> >
> > @@ -1043,8 +1041,6 @@ aes2: aes@0 {
> >                               interrupts =3D <GIC_SPI 59 IRQ_TYPE_LEVEL=
_HIGH>;
> >                               dmas =3D <&edma_xbar 114 0>, <&edma_xbar =
113 0>;
> >                               dma-names =3D "tx", "rx";
> > -                             clocks =3D <&l3_iclk_div>;
> > -                             clock-names =3D "fck";
> >                       };
> >               };
> >
> > @@ -1073,8 +1069,6 @@ sham1: sham@0 {
> >                               interrupts =3D <GIC_SPI 46 IRQ_TYPE_LEVEL=
_HIGH>;
> >                               dmas =3D <&edma_xbar 119 0>;
> >                               dma-names =3D "rx";
> > -                             clocks =3D <&l3_iclk_div>;
> > -                             clock-names =3D "fck";
> >                       };
> >               };
> >
> > @@ -1103,8 +1097,6 @@ sham2: sham@0 {
> >                               interrupts =3D <GIC_SPI 163 IRQ_TYPE_LEVE=
L_HIGH>;
> >                               dmas =3D <&edma_xbar 165 0>;
> >                               dma-names =3D "rx";
> > -                             clocks =3D <&l3_iclk_div>;
> > -                             clock-names =3D "fck";
> >                       };
> >               };
> >
> >
>
