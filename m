Received: from mail-oi1-f175.google.com (mail-oi1-f175.google.com [209.85.167.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 711BA2E7177
	for <linux-crypto@vger.kernel.org>; Fri, 25 Jul 2025 11:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753443813; cv=none; b=VCSBW9IDFn86dgi9hDQvXD2sM5Z9sNveyAU3QuLgIbcAEB1I8sF6FlQeR4hlHLHbPSRdSzQqieT3TFap9DxonX3n8/cntpQ6GHmspA+e9KbSKkhAtbm3gxu73Qh/SNQKBgijYvEDcsSk7A3RbkqHqlui/3zgnK8f/EQNfVYoCvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753443813; c=relaxed/simple;
	bh=yYEFudnuqhhtZ+sqQ+TFTlE2skKtiAAPYNG8FKAlAuU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fIjsU7ClwSk6DIy0Nd2PvlsyJO5ARbyKlJwuVoPgAjNAkoAefLRAW4nTReirMT+Okql7x0Q4epDQo4ebryP051a+JXtEkiGNd3JVWkyLLd88HinUMxNfNNtjsF7BkdM+rzcZnd9dklqQcEkhYHADAfqPxhlXsl26MmzkLLcWAxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=C9P0LKz3; arc=none smtp.client-ip=209.85.167.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="C9P0LKz3"
Received: by mail-oi1-f175.google.com with SMTP id 5614622812f47-41cbc8da42aso1084044b6e.2
        for <linux-crypto@vger.kernel.org>; Fri, 25 Jul 2025 04:43:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1753443810; x=1754048610; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=29HDb0CStjqCTbdMTaT8ki881uLabi0viRhzF0Cw5Io=;
        b=C9P0LKz3GqvzRV8Oq58vKadmo+TW7yKV5RdOyUPu2ET7+mhG37NjlAZB6NwXmdLqHw
         DEjztsACvmM5Sm9zsPqeT5i0ziRwcfuzkf9gkUWPAneSW6rd1YjH6cBaHde81HmHmPg0
         O00l2GlrBG5xZVzwmapFjCQIUIcpaMMYPT8kk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753443810; x=1754048610;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=29HDb0CStjqCTbdMTaT8ki881uLabi0viRhzF0Cw5Io=;
        b=rvmWdA7mMd6xs/zeviMGjxvLZLytNhGrZadH1+G9zydKR2sfBobZPIrG7zh9sIBpvf
         msz/t+ZNy3sqxJsx9bCBWwX5Sp40IjML/ZOsVIyoSPkREtsTIu5cZWsWOIAjKcgCTtmN
         +lXomhCGLywNGfL/LjnJcIV/HYqvgNZDz2BMGLQCkFW3Me1FlTU5GE/XCb5cdCWe2IVu
         Ox2HYoJYdAPSuFvnjb0T2lXUllWDYchztK86auGHHd7syOgr4dQ4jc5fqzilMcrTdftl
         HmRYr7NxWYuHMw3H3sZCkSDd9I77CnySvNrgiuaNd0euFlHEqclo2BPxkhy0QX2Al8p4
         2eQw==
X-Forwarded-Encrypted: i=1; AJvYcCUgGkz31c9YqY0yf/HTOKs6iod51vVlkSqybgr0l44a6iUwVt8X/G2exMtPpEVeoP21HnnXN7Cw2YKgWGQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyXziEfUh5Y+BeVa3vwwe9MZ9Ys7fG7oivayTVt77g5ZjuAp5bN
	iWa4oJr3fXEOD19jGVTYTCwmcpQGeH9uFkaq4osNVAlg7DcaYK8Ir+dn2H1RBPbeL6KU85IVd9o
	3GKg6+w==
X-Gm-Gg: ASbGncvIbs+XSEYalDlQrQWMS/QvI4SfBAHEfCACtz/L7dxYPK6k8jTZERuduiQguTA
	nmsZwCflQumuFCLVGpzkqGIya5pV55TCJqoEhLukvOc83A/zLj12vkLxyOH9Qp5Daa5YKoFn/WR
	blXgSWLeu8N7vYFxaNAURiw7nZ1Djr3eLiG2C6KFpAlnqFZrz5SUbC3bVTTK02WXC7++y9VsBhO
	m6dqfl9KnIgbOPQY29Z1P5nzB7Ibd6N6crEGjX6W9j3MhXt3tyg6aAX+Hr69iDh35AqMIlyoT9i
	4sNahTyB0rH7HWqfSKLZ2EGA9j4qKgJD9Yv33sOQidIg10b14DkdEfqW4VF/0QBVYIggJuPTnl2
	5IBcb3h2E0mOkA0QwSQ0Kcts4BncULRqyR/94WFv8E7MySpvGJTgQ/2BpaQ==
X-Google-Smtp-Source: AGHT+IEyRingtK5uHAEsvEGcr1iIGFBArvz+C/HKqAsLrTBX3ecAbViae0L2XsN3JkdacN5BwwGMWw==
X-Received: by 2002:a05:6808:f0b:b0:425:767e:9ca2 with SMTP id 5614622812f47-42bb79cd130mr737308b6e.1.1753443810183;
        Fri, 25 Jul 2025 04:43:30 -0700 (PDT)
Received: from mail-oo1-f41.google.com (mail-oo1-f41.google.com. [209.85.161.41])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-42a30f5b39bsm601880b6e.17.2025.07.25.04.43.29
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Jul 2025 04:43:29 -0700 (PDT)
Received: by mail-oo1-f41.google.com with SMTP id 006d021491bc7-61591e51092so981222eaf.0
        for <linux-crypto@vger.kernel.org>; Fri, 25 Jul 2025 04:43:29 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWCPnQlo8rzz2ae9FnzwJbO7/2eLla9CuRtDLtyMZ6POaAhmS3pzfbDC096erpFDRO1uqA4mLRNUY83iK8=@vger.kernel.org
X-Received: by 2002:a05:6102:5799:b0:4e5:ade7:eb7c with SMTP id
 ada2fe7eead31-4fa3fac29femr330925137.12.1753439652105; Fri, 25 Jul 2025
 03:34:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250724083914.61351-1-angelogioacchino.delregno@collabora.com> <20250724083914.61351-35-angelogioacchino.delregno@collabora.com>
In-Reply-To: <20250724083914.61351-35-angelogioacchino.delregno@collabora.com>
From: Fei Shao <fshao@chromium.org>
Date: Fri, 25 Jul 2025 18:33:36 +0800
X-Gmail-Original-Message-ID: <CAC=S1nhfg_qD044bO8EOV=MckoNVtJXQ47XBeDFMPwJ9goHg-A@mail.gmail.com>
X-Gm-Features: Ac12FXyYX3cOTb6n6096sUC59Z8DCV1ifB6_qbpW9gH46tmstAs2fiwwoJYhrGs
Message-ID: <CAC=S1nhfg_qD044bO8EOV=MckoNVtJXQ47XBeDFMPwJ9goHg-A@mail.gmail.com>
Subject: Re: [PATCH 34/38] arm64: dts: mediatek: mt8195: Fix ranges for jpeg
 enc/decoder nodes
To: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: linux-mediatek@lists.infradead.org, robh@kernel.org, 
	daniel.lezcano@linaro.org, mwalle@kernel.org, devicetree@vger.kernel.org, 
	linus.walleij@linaro.org, linux-remoteproc@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org, 
	olivia.wen@mediatek.com, shane.chien@mediatek.com, linux-gpio@vger.kernel.org, 
	linux-phy@lists.infradead.org, airlied@gmail.com, simona@ffwll.ch, 
	herbert@gondor.apana.org.au, jassisinghbrar@gmail.com, jiaxin.yu@mediatek.com, 
	andy.teng@mediatek.com, chunfeng.yun@mediatek.com, jieyy.yang@mediatek.com, 
	chunkuang.hu@kernel.org, conor+dt@kernel.org, jitao.shi@mediatek.com, 
	p.zabel@pengutronix.de, arnd@arndb.de, kishon@kernel.org, 
	kyrie.wu@mediatek.corp-partner.google.com, maarten.lankhorst@linux.intel.com, 
	tinghan.shen@mediatek.com, mripard@kernel.org, ck.hu@mediatek.com, 
	broonie@kernel.org, eugen.hristev@linaro.org, houlong.wei@mediatek.com, 
	matthias.bgg@gmail.com, tglx@linutronix.de, mchehab@kernel.org, 
	linux-arm-kernel@lists.infradead.org, granquet@baylibre.com, 
	sam.shih@mediatek.com, mathieu.poirier@linaro.org, fparent@baylibre.com, 
	andersson@kernel.org, sean.wang@kernel.org, linux-sound@vger.kernel.org, 
	lgirdwood@gmail.com, vkoul@kernel.org, linux-crypto@vger.kernel.org, 
	tzimmermann@suse.de, atenart@kernel.org, krzk+dt@kernel.org, 
	linux-media@vger.kernel.org, davem@davemloft.net
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 24, 2025 at 5:51=E2=80=AFPM AngeloGioacchino Del Regno
<angelogioacchino.delregno@collabora.com> wrote:
>
> The jpeg decoder main node is under the soc bus but currently has
> no ranges or reg specified, while the children do, and this is
> wrong in multiple aspects.
>
> The very same is also valid for the jpeg encoder node.
>
> Rename the decoder and encoder nodes to "jpeg-decoder@1a040000"
> and to "jpeg-encoder@1a030000" respectively, and change their
> children to use the newly defined ranges.
>
> Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@coll=
abora.com>

Despite now jpeg-encoder isn't sorted in order, I guess we all agree
it's much easier to read in this way, so

Reviewed-by: Fei Shao <fshao@chromium.org>

> ---
>  arch/arm64/boot/dts/mediatek/mt8195.dtsi | 30 +++++++++++++-----------
>  1 file changed, 16 insertions(+), 14 deletions(-)
>
> diff --git a/arch/arm64/boot/dts/mediatek/mt8195.dtsi b/arch/arm64/boot/d=
ts/mediatek/mt8195.dtsi
> index dd065b1bf94a..35b10082bb89 100644
> --- a/arch/arm64/boot/dts/mediatek/mt8195.dtsi
> +++ b/arch/arm64/boot/dts/mediatek/mt8195.dtsi
> @@ -3014,7 +3014,7 @@ venc: video-codec@1a020000 {
>                         #size-cells =3D <2>;
>                 };
>
> -               jpgdec-master {
> +               jpeg-decoder@1a040000 {
>                         compatible =3D "mediatek,mt8195-jpgdec";
>                         power-domains =3D <&spm MT8195_POWER_DOMAIN_VDEC1=
>;
>                         iommus =3D <&iommu_vdo M4U_PORT_L19_JPGDEC_WDMA0>=
,
> @@ -3025,11 +3025,12 @@ jpgdec-master {
>                                  <&iommu_vdo M4U_PORT_L19_JPGDEC_BUFF_OFF=
SET0>;
>                         #address-cells =3D <2>;
>                         #size-cells =3D <2>;
> -                       ranges;
> +                       ranges =3D <0 0 0 0x1a040000 0 0x20000>,
> +                                <1 0 0 0x1b040000 0 0x10000>;
>
> -                       jpgdec@1a040000 {
> +                       jpgdec@0,0 {
>                                 compatible =3D "mediatek,mt8195-jpgdec-hw=
";
> -                               reg =3D <0 0x1a040000 0 0x10000>;/* JPGDE=
C_C0 */
> +                               reg =3D <0 0 0 0x10000>;/* JPGDEC_C0 */
>                                 iommus =3D <&iommu_vdo M4U_PORT_L19_JPGDE=
C_WDMA0>,
>                                          <&iommu_vdo M4U_PORT_L19_JPGDEC_=
BSDMA0>,
>                                          <&iommu_vdo M4U_PORT_L19_JPGDEC_=
WDMA1>,
> @@ -3042,9 +3043,9 @@ jpgdec@1a040000 {
>                                 power-domains =3D <&spm MT8195_POWER_DOMA=
IN_VDEC0>;
>                         };
>
> -                       jpgdec@1a050000 {
> +                       jpgdec@0,10000 {
>                                 compatible =3D "mediatek,mt8195-jpgdec-hw=
";
> -                               reg =3D <0 0x1a050000 0 0x10000>;/* JPGDE=
C_C1 */
> +                               reg =3D <0 0 0x10000 0x10000>;/* JPGDEC_C=
1 */
>                                 iommus =3D <&iommu_vdo M4U_PORT_L19_JPGDE=
C_WDMA0>,
>                                          <&iommu_vdo M4U_PORT_L19_JPGDEC_=
BSDMA0>,
>                                          <&iommu_vdo M4U_PORT_L19_JPGDEC_=
WDMA1>,
> @@ -3057,9 +3058,9 @@ jpgdec@1a050000 {
>                                 power-domains =3D <&spm MT8195_POWER_DOMA=
IN_VDEC1>;
>                         };
>
> -                       jpgdec@1b040000 {
> +                       jpgdec@1,0 {
>                                 compatible =3D "mediatek,mt8195-jpgdec-hw=
";
> -                               reg =3D <0 0x1b040000 0 0x10000>;/* JPGDE=
C_C2 */
> +                               reg =3D <1 0 0 0x10000>;/* JPGDEC_C2 */
>                                 iommus =3D <&iommu_vpp M4U_PORT_L20_JPGDE=
C_WDMA0>,
>                                          <&iommu_vpp M4U_PORT_L20_JPGDEC_=
BSDMA0>,
>                                          <&iommu_vpp M4U_PORT_L20_JPGDEC_=
WDMA1>,
> @@ -3088,7 +3089,7 @@ vdosys0: syscon@1c01a000 {
>                 };
>
>
> -               jpgenc-master {
> +               jpeg-encoder@1a030000 {
>                         compatible =3D "mediatek,mt8195-jpgenc";
>                         power-domains =3D <&spm MT8195_POWER_DOMAIN_VENC_=
CORE1>;
>                         iommus =3D <&iommu_vpp M4U_PORT_L20_JPGENC_Y_RDMA=
>,
> @@ -3097,11 +3098,12 @@ jpgenc-master {
>                                         <&iommu_vpp M4U_PORT_L20_JPGENC_B=
SDMA>;
>                         #address-cells =3D <2>;
>                         #size-cells =3D <2>;
> -                       ranges;
> +                       ranges =3D <0 0 0 0x1a030000 0 0x10000>,
> +                                <1 0 0 0x1b030000 0 0x10000>;
>
> -                       jpgenc@1a030000 {
> +                       jpgenc@0,0 {
>                                 compatible =3D "mediatek,mt8195-jpgenc-hw=
";
> -                               reg =3D <0 0x1a030000 0 0x10000>;
> +                               reg =3D <0 0 0 0x10000>;
>                                 iommus =3D <&iommu_vdo M4U_PORT_L19_JPGEN=
C_Y_RDMA>,
>                                                 <&iommu_vdo M4U_PORT_L19_=
JPGENC_C_RDMA>,
>                                                 <&iommu_vdo M4U_PORT_L19_=
JPGENC_Q_TABLE>,
> @@ -3112,9 +3114,9 @@ jpgenc@1a030000 {
>                                 power-domains =3D <&spm MT8195_POWER_DOMA=
IN_VENC>;
>                         };
>
> -                       jpgenc@1b030000 {
> +                       jpgenc@1,0 {
>                                 compatible =3D "mediatek,mt8195-jpgenc-hw=
";
> -                               reg =3D <0 0x1b030000 0 0x10000>;
> +                               reg =3D <1 0 0 0x10000>;
>                                 iommus =3D <&iommu_vpp M4U_PORT_L20_JPGEN=
C_Y_RDMA>,
>                                                 <&iommu_vpp M4U_PORT_L20_=
JPGENC_C_RDMA>,
>                                                 <&iommu_vpp M4U_PORT_L20_=
JPGENC_Q_TABLE>,
> --
> 2.50.1
>
>
