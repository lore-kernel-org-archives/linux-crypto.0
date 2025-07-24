Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87C262D8DA3
	for <linux-crypto@vger.kernel.org>; Thu, 24 Jul 2025 09:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753349421; cv=none; b=a++giesF7jPE7eaMObUQ0WIdw+frabotbfE2RjDaqr9RDaZwubwkLfRTQoGg/EfuCR+ubsIiA5yJJPwNJQmuzII1NfwBrfvpnLBtNZdobAYrVVpKDxAUdsuay9reM7nMBjF/HVX+WS7qVSDCvoG0/rHhsVgf+VWni932TdW4pPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753349421; c=relaxed/simple;
	bh=MR4+0IGmwIsK+cxrpY4XhQYneMzF86b9Vmoxzw5wyjU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dc7jmsjorXsCTMfu4rpRH1g/T/8CCENY/x+4Kk/ejISAwG4E64IWUXa3bBYErJOK0brtahkfD8kALvuSlVR4gi3G8lp/dFfPGMeDeVvcXtOQIgSpX++/Dh51ZZGeJtkzXW3607dyHDnWVIIa1w0MaM+OOAZuDTVsjUo+vbm3y0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=He2ePwaN; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="He2ePwaN"
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-55516abe02cso1094253e87.0
        for <linux-crypto@vger.kernel.org>; Thu, 24 Jul 2025 02:30:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1753349418; x=1753954218; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UomwMYm6V80ZuZPrz7YKXe0vLuxIpqX7vRa+Pl5FCU8=;
        b=He2ePwaNVcTjtMzHlJ0bZqq5qOjHan24UlRTTDm+fFIxVG8y1t7/BYitio1cI7p8qN
         AQG+HDugO6tpjFiTLb9H9E6I+Lf0/Rzpu7M1EA9HtK63tNsICyEshlRaiBmlCdAT/Lvk
         beQjO3h4ETQl4MgbP0fV4LjHNpvSK05ePjcMI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753349418; x=1753954218;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UomwMYm6V80ZuZPrz7YKXe0vLuxIpqX7vRa+Pl5FCU8=;
        b=A13ru9k7uh0Zz9cgUPTY+AVy6examePuH9WTf/xnAtMJBXNjoRXF3NMsgpe/0yTRbG
         J/Gz7xO85nm779lmWBDqXa1FthzSmxMGsgR0XB7cpLtdFdbMeT8HdEBY76YybnBR1FCo
         FppmhlKF1fWTIrV3b6QXzvLnTnELmAey23V337dBxZLexrPwb24HiEJoqA3/Td6znGfQ
         3yTEPbTmfEWipqDLaG7CNvpo8k8yTfOLaC+UMJsE18stPYvKxNGEmjjyo3O9NnEHi8WT
         8h+7uG+D9Ngv+P2TYUli0+nSJJm+Yy7EpirM+6m4dpDzOTArMIaQdrxBv0qi8u4k0tKH
         43Iw==
X-Forwarded-Encrypted: i=1; AJvYcCU72qHncTN7/TYbXqPTu0B5CqlkxXUgpyTBBPHoTOT8Q0/ciz86LGPFSqIBvEzAHWOS/B+sGUwLPYQqNcU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9TL6SOMnkHzgf+ZIzklzQ+rvCmccPpOHeYGPJQ1QfzLVCXMy5
	hiiQElgrTS9q7QCrSCEG6SXbxPSRV0des3NSKHGRU/Rc7Q7EFt157ZP9758smB5h+QRgy5ma34W
	FLOZkM8ag4dF2uex0PpqSxz5AyQyBQ/pNYHxfAZ4T
X-Gm-Gg: ASbGncvsg8h/2eAjEybmIv49+t/W3cJiMaEJQCPX2sKvYDEd642T1u8B/j/FuouRtti
	p8NSDqKnxyuO77McUTUJUBRTyaXX1yesxRq47N6ZOol4nv/fD2yQUPW/FZKhICdrF8miw9qZyOX
	0VPdtNs+f0ZHCxyMLXGbiJ7nE1LVjCqkXei0sAKYNop6SgNGiDev/80ef4cVkpwqd6/8+Qyahor
	wZ8QFRkYjgGMmmEX4Im+0sUq0WTPzRFMCIrMhRe8SQBnw==
X-Google-Smtp-Source: AGHT+IH1lXhOoKFIGLzswAaXQ/xdrKCcLg4Bs+hSUU/wAe3mRs3pt6lfFpYUUkDOjisZO/3IZcyl3MPX+Jll/FYr+/8=
X-Received: by 2002:a05:6512:2c87:b0:55a:4e67:7cdb with SMTP id
 2adb3069b0e04-55b5589a412mr400418e87.18.1753349417507; Thu, 24 Jul 2025
 02:30:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250724083914.61351-1-angelogioacchino.delregno@collabora.com> <20250724083914.61351-23-angelogioacchino.delregno@collabora.com>
In-Reply-To: <20250724083914.61351-23-angelogioacchino.delregno@collabora.com>
From: Chen-Yu Tsai <wenst@chromium.org>
Date: Thu, 24 Jul 2025 17:30:06 +0800
X-Gm-Features: Ac12FXxWUOXitKh1quEjvg3RMxamDaOT0bnXe7uMSX2DfmXQwXv_3I70hIvhN2Q
Message-ID: <CAGXv+5GBq5CqHAHWLMsZLU=NYVurAQZBgknsvOZoK_XhyUfxew@mail.gmail.com>
Subject: Re: [PATCH 22/38] arm64: dts: mediatek: Fix node name for SYSIRQ
 controller on all SoCs
To: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: linux-mediatek@lists.infradead.org, robh@kernel.org, 
	herbert@gondor.apana.org.au, davem@davemloft.net, krzk+dt@kernel.org, 
	conor+dt@kernel.org, chunkuang.hu@kernel.org, p.zabel@pengutronix.de, 
	airlied@gmail.com, simona@ffwll.ch, maarten.lankhorst@linux.intel.com, 
	mripard@kernel.org, tzimmermann@suse.de, jassisinghbrar@gmail.com, 
	mchehab@kernel.org, matthias.bgg@gmail.com, chunfeng.yun@mediatek.com, 
	vkoul@kernel.org, kishon@kernel.org, sean.wang@kernel.org, 
	linus.walleij@linaro.org, lgirdwood@gmail.com, broonie@kernel.org, 
	andersson@kernel.org, mathieu.poirier@linaro.org, daniel.lezcano@linaro.org, 
	tglx@linutronix.de, atenart@kernel.org, jitao.shi@mediatek.com, 
	ck.hu@mediatek.com, houlong.wei@mediatek.com, 
	kyrie.wu@mediatek.corp-partner.google.com, andy.teng@mediatek.com, 
	tinghan.shen@mediatek.com, jiaxin.yu@mediatek.com, shane.chien@mediatek.com, 
	olivia.wen@mediatek.com, granquet@baylibre.com, eugen.hristev@linaro.org, 
	arnd@arndb.de, sam.shih@mediatek.com, jieyy.yang@mediatek.com, 
	frank-w@public-files.de, mwalle@kernel.org, fparent@baylibre.com, 
	linux-crypto@vger.kernel.org, devicetree@vger.kernel.org, 
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-phy@lists.infradead.org, linux-gpio@vger.kernel.org, 
	linux-remoteproc@vger.kernel.org, linux-sound@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 24, 2025 at 4:40=E2=80=AFPM AngeloGioacchino Del Regno
<angelogioacchino.delregno@collabora.com> wrote:
>
> The sysirq has "intpol-controller" as node name, but being this an
> interrupt controller, it needs to be named "interrupt-controller"
> as per what the bindings (correctly) expect.
>
> This commit brings no functional changes, but fixes a dtbs_check
> warning.
>
> Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@coll=
abora.com>

Reviewed-by: Chen-Yu Tsai <wenst@chromium.org>

> ---
>  arch/arm64/boot/dts/mediatek/mt6755.dtsi | 2 +-
>  arch/arm64/boot/dts/mediatek/mt6779.dtsi | 2 +-
>  arch/arm64/boot/dts/mediatek/mt6795.dtsi | 2 +-
>  arch/arm64/boot/dts/mediatek/mt6797.dtsi | 2 +-
>  4 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/arch/arm64/boot/dts/mediatek/mt6755.dtsi b/arch/arm64/boot/d=
ts/mediatek/mt6755.dtsi
> index b55d3fac9bd4..8da5c0a56a02 100644
> --- a/arch/arm64/boot/dts/mediatek/mt6755.dtsi
> +++ b/arch/arm64/boot/dts/mediatek/mt6755.dtsi
> @@ -98,7 +98,7 @@ timer {
>                              (GIC_CPU_MASK_SIMPLE(8) | IRQ_TYPE_LEVEL_LOW=
)>;
>         };
>
> -       sysirq: intpol-controller@10200620 {
> +       sysirq: interrupt-controller@10200620 {
>                 compatible =3D "mediatek,mt6755-sysirq",
>                              "mediatek,mt6577-sysirq";
>                 interrupt-controller;
> diff --git a/arch/arm64/boot/dts/mediatek/mt6779.dtsi b/arch/arm64/boot/d=
ts/mediatek/mt6779.dtsi
> index 5c579e88e749..70f3375916e8 100644
> --- a/arch/arm64/boot/dts/mediatek/mt6779.dtsi
> +++ b/arch/arm64/boot/dts/mediatek/mt6779.dtsi
> @@ -138,7 +138,7 @@ ppi_cluster1: interrupt-partition-1 {
>
>                 };
>
> -               sysirq: intpol-controller@c53a650 {
> +               sysirq: interrupt-controller@c53a650 {
>                         compatible =3D "mediatek,mt6779-sysirq",
>                                      "mediatek,mt6577-sysirq";
>                         interrupt-controller;
> diff --git a/arch/arm64/boot/dts/mediatek/mt6795.dtsi b/arch/arm64/boot/d=
ts/mediatek/mt6795.dtsi
> index 38f65aad2802..58833e5135c8 100644
> --- a/arch/arm64/boot/dts/mediatek/mt6795.dtsi
> +++ b/arch/arm64/boot/dts/mediatek/mt6795.dtsi
> @@ -404,7 +404,7 @@ pwrap: pwrap@1000d000 {
>                         clock-names =3D "spi", "wrap";
>                 };
>
> -               sysirq: intpol-controller@10200620 {
> +               sysirq: interrupt-controller@10200620 {
>                         compatible =3D "mediatek,mt6795-sysirq",
>                                      "mediatek,mt6577-sysirq";
>                         interrupt-controller;
> diff --git a/arch/arm64/boot/dts/mediatek/mt6797.dtsi b/arch/arm64/boot/d=
ts/mediatek/mt6797.dtsi
> index f2d93bf6a055..8ac98a378fd6 100644
> --- a/arch/arm64/boot/dts/mediatek/mt6797.dtsi
> +++ b/arch/arm64/boot/dts/mediatek/mt6797.dtsi
> @@ -228,7 +228,7 @@ apmixedsys: apmixed@1000c000 {
>                 #clock-cells =3D <1>;
>         };
>
> -       sysirq: intpol-controller@10200620 {
> +       sysirq: interrupt-controller@10200620 {
>                 compatible =3D "mediatek,mt6797-sysirq",
>                              "mediatek,mt6577-sysirq";
>                 interrupt-controller;
> --
> 2.50.1
>
