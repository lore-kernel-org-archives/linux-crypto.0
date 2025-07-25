Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4B371BD4F7
	for <linux-crypto@vger.kernel.org>; Fri, 25 Jul 2025 12:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753445123; cv=none; b=JnH161fQFH0o0Yj2OTWpQ9/EwDTeDJ/tAUqgAtHdT0Z2KoDAUqs7h+3dZETn7rp14+97F49u/S3Qt0UhOCnwMT/pGdyIDmk2Sn4KHYxVwIlFw/wZiIU4lO7LzXrlGNIdSwntm7awOpkvYIH/uOio5maWdLCIfz8Z5eQOh9Yutek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753445123; c=relaxed/simple;
	bh=wuFFxAizy2X1aAZ/SF2x06cfnVSKnpsKMko3UN4we2M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tXRkT/pNqC1ArcR+g2BKGLGyvngAsDLz5U597iDuqFENfKguCOvM6fJNZWlNSZiPA4Oq6OaO30Bd0m+ySbhy98TkYgfhWQ34g66RIvXYYO2gECvPJiYVq3lafBtfTQe95jQ2Jxiq0BVmDCtqJbs8jQjdnESGM8j8RfSqM/ZUd+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=gKVsEev7; arc=none smtp.client-ip=209.85.222.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="gKVsEev7"
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-7e278d8345aso203302185a.0
        for <linux-crypto@vger.kernel.org>; Fri, 25 Jul 2025 05:05:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1753445120; x=1754049920; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IaRYlYWMnL5FdToAvFBY21N9TEhebXI6JAmJStjizl0=;
        b=gKVsEev7BfMcVceHmdlWupJV88MIRqyMCzzNooTLCEozhmVlRD7L3xYSetc2X8ylmw
         PfkSbL8Gzu3SfzwndGZEfkVpKp8bPCsh1CxsRWAVmzkea8culU04deFvzu6BZin0PeiM
         nXgYN1D12gM5Gp17wawNCLEVvI84SOQxGZJWw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753445120; x=1754049920;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IaRYlYWMnL5FdToAvFBY21N9TEhebXI6JAmJStjizl0=;
        b=Sj9HX4ZJa5TKlR00NT02lT3ghrhMyhFOBtnNBHfEUw/hf/WDiLBqat2QATvTIenhVs
         OhUvcgsQ1LqVAU5X4d251nzKD3DgpZfp/9wA0XEQuJLl32+AI7b5zS6IzIMfmx5FokUI
         4w5ySMMIYYUJk/ZV7PLCnlFtGAekn+KFu8dbA8pjZBpwkm3m0BPopchGwjhVur7820Bk
         SjnGtK5p2ez8cwtG9G9WnpVYyct3K9N08YT5ifDrjQYDcum8AmzLM7VON4UQWFd8/+/M
         UkqbXax4/XX5feIyqNv34ZoTtSYdqmZKq/AL9S+MiknZcV1toOir4kxlH/bx3tOlpt01
         IGVA==
X-Forwarded-Encrypted: i=1; AJvYcCXrkAvyeLnGtcYolpXk/22dwH274UR6vvIVc0gnBZ9+pDintLdrF0zINin4/41wpWC2TYj8GLy2Stj2icY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwcWpY3jei2xHmHDBppCmzzYKPrc6pd1tnpvMxNiG/0Mh0E2z5d
	rZHi4TzYU/s76jRBgrFzgBZce62Ayrgvd/UeYCWrgHrkQNAFpfhe/LyA9BiEn0D2dWY4bxb1xIj
	ItMs=
X-Gm-Gg: ASbGncs5Tc355I0ff5gmxIe2dOLSIGG9X+R8rDk4F2cpia46cTKSwChhwki20rWJ57Y
	6ZkJAIK9ccWu4hs+9jS0LEcpOHQsqhmMz8noYlYPKojJmDn50wyuIViTGdy6m93VH6VmWgGAjlu
	TFvDBUpIth5QXwjYWtvMXkqbR3gvZwav4mZxdbcBcEdRA/HyZ4rqSWmb7WRPIdGyF2Jpq0VTJFK
	pdzsAuBufH2zbodWy3vtLPmcdDuWKeg7+nwQlD5w6AgUalOES0xGCBJUJBHS0v4gKN8sOqHFcl9
	clb5CIg6c9YJ+QLreGcNPdEI6yv8YR5U3SXyclEfYUF9ePSE2t651zvQUTse+QUJn7T6Ak5Bji1
	PvR5m7BxX6kdoIVT5gPZsZNfLFqhkZnoCz6UZ4mzhIYwXiQMbxs4PEqZ1tYhpeQ==
X-Google-Smtp-Source: AGHT+IGyShUK4Yc6kJwZ2VZICL+7uoFNbXC86we0QBqNMu8sbt4Qe9MBFh3NIag8QtwL976Vcznt7Q==
X-Received: by 2002:a05:620a:4088:b0:7e2:d113:ede7 with SMTP id af79cd13be357-7e63be52fe0mr182842085a.22.1753445120266;
        Fri, 25 Jul 2025 05:05:20 -0700 (PDT)
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com. [209.85.222.176])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7e632d4d49csm234609785a.4.2025.07.25.05.05.19
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Jul 2025 05:05:19 -0700 (PDT)
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-7dfc604107eso178802385a.2
        for <linux-crypto@vger.kernel.org>; Fri, 25 Jul 2025 05:05:19 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXGOYweUf2e5SrRJDjloC+Y8CYaK8vGIlQea2+B1/RtPGnsMR8f2Plx0l198wRQ0b8L9M6zl2GxsEK/278=@vger.kernel.org
X-Received: by 2002:a05:6102:cce:b0:4e6:4e64:baeb with SMTP id
 ada2fe7eead31-4fa3ff55fbamr323634137.17.1753441040390; Fri, 25 Jul 2025
 03:57:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250724083914.61351-1-angelogioacchino.delregno@collabora.com> <20250724083914.61351-18-angelogioacchino.delregno@collabora.com>
In-Reply-To: <20250724083914.61351-18-angelogioacchino.delregno@collabora.com>
From: Fei Shao <fshao@chromium.org>
Date: Fri, 25 Jul 2025 18:56:44 +0800
X-Gmail-Original-Message-ID: <CAC=S1nh5bF6kZe7TFA_EGPGt8Xp_rfuc-rkeXgjRCU=QEtZQiw@mail.gmail.com>
X-Gm-Features: Ac12FXw-hSTS0fHSbHXeHNK-nhzfyTLOXfpWf3gYQQXz8LA0IhEjugCIp682sPw
Message-ID: <CAC=S1nh5bF6kZe7TFA_EGPGt8Xp_rfuc-rkeXgjRCU=QEtZQiw@mail.gmail.com>
Subject: Re: [PATCH 17/38] arm64: dts: mediatek: mt6797: Fix pinctrl node names
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

On Thu, Jul 24, 2025 at 5:48=E2=80=AFPM AngeloGioacchino Del Regno
<angelogioacchino.delregno@collabora.com> wrote:
>
> Change the pinctrl node names to adhere to the binding: the main
> nodes are now named like "uart0-pins" and the children "pins-bus".
>
> Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@coll=
abora.com>

Reviewed-by: Fei Shao <fshao@chromium.org>

> ---
>  arch/arm64/boot/dts/mediatek/mt6797.dtsi | 40 ++++++++++++------------
>  1 file changed, 20 insertions(+), 20 deletions(-)
>
> diff --git a/arch/arm64/boot/dts/mediatek/mt6797.dtsi b/arch/arm64/boot/d=
ts/mediatek/mt6797.dtsi
> index 0e9d11b4585b..be401617dfd8 100644
> --- a/arch/arm64/boot/dts/mediatek/mt6797.dtsi
> +++ b/arch/arm64/boot/dts/mediatek/mt6797.dtsi
> @@ -135,71 +135,71 @@ pio: pinctrl@10005000 {
>                 gpio-controller;
>                 #gpio-cells =3D <2>;
>
> -               uart0_pins_a: uart0 {
> -                       pins0 {
> +               uart0_pins_a: uart0-pins {
> +                       pins-bus {
>                                 pinmux =3D <MT6797_GPIO234__FUNC_UTXD0>,
>                                          <MT6797_GPIO235__FUNC_URXD0>;
>                         };
>                 };
>
> -               uart1_pins_a: uart1 {
> -                       pins1 {
> +               uart1_pins_a: uart1-pins {
> +                       pins-bus {
>                                 pinmux =3D <MT6797_GPIO232__FUNC_URXD1>,
>                                          <MT6797_GPIO233__FUNC_UTXD1>;
>                         };
>                 };
>
> -               i2c0_pins_a: i2c0 {
> -                       pins0 {
> +               i2c0_pins_a: i2c0-pins {
> +                       pins-bus {
>                                 pinmux =3D <MT6797_GPIO37__FUNC_SCL0_0>,
>                                          <MT6797_GPIO38__FUNC_SDA0_0>;
>                         };
>                 };
>
> -               i2c1_pins_a: i2c1 {
> -                       pins1 {
> +               i2c1_pins_a: i2c1-pins {
> +                       pins-bus {
>                                 pinmux =3D <MT6797_GPIO55__FUNC_SCL1_0>,
>                                          <MT6797_GPIO56__FUNC_SDA1_0>;
>                         };
>                 };
>
> -               i2c2_pins_a: i2c2 {
> -                       pins2 {
> +               i2c2_pins_a: i2c2-pins {
> +                       pins-bus {
>                                 pinmux =3D <MT6797_GPIO96__FUNC_SCL2_0>,
>                                          <MT6797_GPIO95__FUNC_SDA2_0>;
>                         };
>                 };
>
> -               i2c3_pins_a: i2c3 {
> -                       pins3 {
> +               i2c3_pins_a: i2c3-pins {
> +                       pins-bus {
>                                 pinmux =3D <MT6797_GPIO75__FUNC_SDA3_0>,
>                                          <MT6797_GPIO74__FUNC_SCL3_0>;
>                         };
>                 };
>
> -               i2c4_pins_a: i2c4 {
> -                       pins4 {
> +               i2c4_pins_a: i2c4-pins {
> +                       pins-bus {
>                                 pinmux =3D <MT6797_GPIO238__FUNC_SDA4_0>,
>                                          <MT6797_GPIO239__FUNC_SCL4_0>;
>                         };
>                 };
>
> -               i2c5_pins_a: i2c5 {
> -                       pins5 {
> +               i2c5_pins_a: i2c5-pins {
> +                       pins-bus {
>                                 pinmux =3D <MT6797_GPIO240__FUNC_SDA5_0>,
>                                          <MT6797_GPIO241__FUNC_SCL5_0>;
>                         };
>                 };
>
> -               i2c6_pins_a: i2c6 {
> -                       pins6 {
> +               i2c6_pins_a: i2c6-pins {
> +                       pins-bus {
>                                 pinmux =3D <MT6797_GPIO152__FUNC_SDA6_0>,
>                                          <MT6797_GPIO151__FUNC_SCL6_0>;
>                         };
>                 };
>
> -               i2c7_pins_a: i2c7 {
> -                       pins7 {
> +               i2c7_pins_a: i2c7-pins {
> +                       pins-bus {
>                                 pinmux =3D <MT6797_GPIO154__FUNC_SDA7_0>,
>                                          <MT6797_GPIO153__FUNC_SCL7_0>;
>                         };
> --
> 2.50.1
>
>
