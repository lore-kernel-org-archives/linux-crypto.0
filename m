Received: from mail-oa1-f50.google.com (mail-oa1-f50.google.com [209.85.160.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B962D22A808
	for <linux-crypto@vger.kernel.org>; Fri, 25 Jul 2025 10:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753439176; cv=none; b=JF9WpU6MTh+K13BJ24d1QKRTt3ks0TU4nGTsaySVXtIrTEjsweMpTwPk2cUPTXlCxZbZ06RtredXNFeS2K4jFFRso4FxIa6auJSc6TGnV3GWZmdMpC1Wyks+Wg+mJmNxZyTXMHw3o3ZaXnoeA2ZAUiUCa87YN2JoEVwWNgh7RTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753439176; c=relaxed/simple;
	bh=2XXVnmKfKOuWrZjQTjDdYxCXEPvU5YjHEeLez+QHVDs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RHMTWyNsQKTm6ACPz5I4nMTuC2sw5PhtPemtPVXQjnq6WgEZTSD9z0O9c8zB2LaF6FTqcmNLy7rrDNSyUz/BuXVQ4vlCUgwkQFR9x8ln8RCQvTW6w8qPhpaEZaE2evrhlEwBHo1w1yhQhdFuRSmc7JP37aR0XZHMUHBati3uSd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=cVwC1HQZ; arc=none smtp.client-ip=209.85.160.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="cVwC1HQZ"
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-2eb6c422828so2020102fac.1
        for <linux-crypto@vger.kernel.org>; Fri, 25 Jul 2025 03:26:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1753439173; x=1754043973; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s9CPe4n6W7cHa+GL0hIjIVMWtvIyx6LwWGjspV/N2Ok=;
        b=cVwC1HQZ8xTZkULUdBCtm7+uwlV31P8CdHj1hDClXinZhy+/EYrJiNmMUl+ckUtQHi
         P7KgAW5vDYRoaM+JRDLvogKuVlKyaXGw8TcBz8YbYZF7IM4TrwPgL5FKuiLZDqdBoSRy
         a3r7rX0GcdQAnoiCsEhS4a1pLv/T7z5pLOfG4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753439173; x=1754043973;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=s9CPe4n6W7cHa+GL0hIjIVMWtvIyx6LwWGjspV/N2Ok=;
        b=cdDJIED4RCpLG6FH1ZOWwAsYN6JMdQOBmCIhm3p8fD3JsFsUc3lXHB2BUTxoG6DNXx
         1ySjjboDi9WIqn7tF9o3F+fp5ODgDVi2EZFtdcKhZL4rzh//Jhr/uM1G3rvlcVWmo0sx
         avS7lRJ5Tp5AM/ifAB3LuY3wOwUaOr9quyNDUjTw2iC3psdHQSyZNk8TAR8uFWJzR0FD
         dLCBkmNHrOSC9Pl2Bmfff0phg86hcmnN4EyBO/+P287ZQLGp3YLh7v8BU99IbGaQohs3
         Y6B58Fl7vlvGhMGnfLn+mjMdGtd322O8tw3TwMw1O0XWSSav9Aykm6vzM0gDZPY/nKMQ
         EwmA==
X-Forwarded-Encrypted: i=1; AJvYcCWfLZGIspRiqENFm5SbpaQKc9Xdm1Jal2Fo4JIflVZ9DKEa0LrjRaabIR1UiBGCEIhuw02T1KneZK57JWY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxQoEAKkcoJIPFeq03E183A1SpGk7tUNmaLFrkdOHOo6PmgF/43
	aYwRYniPs4w6dMj2/tng2ZbIGx3AyX5mH9iu6Dhbcz0U419Oa8mJF9XL12BAv0GDhnN2PZLdkhk
	NzKhacQ==
X-Gm-Gg: ASbGnctBcq23aTSZxpjav12wlMm/0ed7A6NF2nlpFmvYoItJLae1/BVRvUHha/puMaT
	9C7SsDby4cTT+wNvZZ9KdRMXePYrkG4VIN+vUOzPH9YuiyShp3OpjawujogAKrVlDQFm/8K4/Js
	xhS1zf+15f9MNTeS3m2LONLfAVMeoPI+iGLzBZ/Am6wsTA+GhBX6fLfPuT9e7/zq7iljC9/hgJF
	OeoQoB6khmMcNR6rDMZyVk6QiDdaYyp83YwaiUrn628Vnn+lYpYwJ5Gtj1d+6hnEpSZX5rTZX4K
	6oIJklNZnn4HXwk+ywaaaiBFtlKcYrt4E1HkcQlQ64fGdfElbBQZLDVeI3OT8SqOxEzm5jb192W
	1N4Y9Jn4knrWuVqPNVi7PqQFYZbwx1I0SH4xzvzpcXmYqXGReaNuz9wL0hA==
X-Google-Smtp-Source: AGHT+IGBKQoNTkRas/bFo9HG7aDFIvOGTRReAiHndB7PBfRhrt9FSxtXv2x0i1RblMPLgrWhDY0/9Q==
X-Received: by 2002:a05:6870:e409:b0:2d4:dc79:b92 with SMTP id 586e51a60fabf-30701f0b23bmr770277fac.6.1753439173584;
        Fri, 25 Jul 2025 03:26:13 -0700 (PDT)
Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com. [209.85.210.52])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-306e1f77e1asm998717fac.39.2025.07.25.03.26.12
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Jul 2025 03:26:13 -0700 (PDT)
Received: by mail-ot1-f52.google.com with SMTP id 46e09a7af769-73e8cc38e80so1471021a34.1
        for <linux-crypto@vger.kernel.org>; Fri, 25 Jul 2025 03:26:12 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWfQUZ+YkSUjmdlQ/PEKsFGpp7hNFpKzZKnzKRh8Pv5kr0lBYziFW+RZGt0804bRpTpsGu3XyQPBjuRe0g=@vger.kernel.org
X-Received: by 2002:a05:6102:1623:b0:4fa:dd4:6877 with SMTP id
 ada2fe7eead31-4fa2eb0ce5dmr2502816137.4.1753438693359; Fri, 25 Jul 2025
 03:18:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250724083914.61351-1-angelogioacchino.delregno@collabora.com> <20250724083914.61351-31-angelogioacchino.delregno@collabora.com>
In-Reply-To: <20250724083914.61351-31-angelogioacchino.delregno@collabora.com>
From: Fei Shao <fshao@chromium.org>
Date: Fri, 25 Jul 2025 18:17:35 +0800
X-Gmail-Original-Message-ID: <CAC=S1niM4ddPSaOM9uMRQuUS8HwPw+gtxe9kGUggWQx6uio5eA@mail.gmail.com>
X-Gm-Features: Ac12FXzF0-E5XCOaIf5MFeMvqjYMvWSzSdwqzh1uEwhsUpfXPcd-rqBecXNopmU
Message-ID: <CAC=S1niM4ddPSaOM9uMRQuUS8HwPw+gtxe9kGUggWQx6uio5eA@mail.gmail.com>
Subject: Re: [PATCH 30/38] arm64: dts: mediatek: pumpkin-common: Fix pinctrl
 node names
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

On Thu, Jul 24, 2025 at 5:50=E2=80=AFPM AngeloGioacchino Del Regno
<angelogioacchino.delregno@collabora.com> wrote:
>
> Fix the pinctrl node names to adhere to the bindings, as the main
> pin node is supposed to be named like "uart0-pins" and the pinmux
> node named like "pins-bus".
>
> Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@coll=
abora.com>

Reviewed-by: Fei Shao <fshao@chromium.org>

> ---
>  .../boot/dts/mediatek/pumpkin-common.dtsi      | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
>
> diff --git a/arch/arm64/boot/dts/mediatek/pumpkin-common.dtsi b/arch/arm6=
4/boot/dts/mediatek/pumpkin-common.dtsi
> index a356db5fcc5f..805fb82138a8 100644
> --- a/arch/arm64/boot/dts/mediatek/pumpkin-common.dtsi
> +++ b/arch/arm64/boot/dts/mediatek/pumpkin-common.dtsi
> @@ -198,8 +198,8 @@ &usb_phy {
>  };
>
>  &pio {
> -       gpio_keys_default: gpiodefault {
> -               pins_cmd_dat {
> +       gpio_keys_default: gpio-keys-pins {
> +               pins-cmd-dat {
>                         pinmux =3D <MT8516_PIN_42_KPCOL0__FUNC_GPIO42>,
>                                  <MT8516_PIN_43_KPCOL1__FUNC_GPIO43>;
>                         bias-pull-up;
> @@ -207,7 +207,7 @@ pins_cmd_dat {
>                 };
>         };
>
> -       i2c0_pins_a: i2c0 {
> +       i2c0_pins_a: i2c0-pins {
>                 pins1 {
>                         pinmux =3D <MT8516_PIN_58_SDA0__FUNC_SDA0_0>,
>                                  <MT8516_PIN_59_SCL0__FUNC_SCL0_0>;
> @@ -215,7 +215,7 @@ pins1 {
>                 };
>         };
>
> -       i2c2_pins_a: i2c2 {
> +       i2c2_pins_a: i2c2-pins {
>                 pins1 {
>                         pinmux =3D <MT8516_PIN_60_SDA2__FUNC_SDA2_0>,
>                                  <MT8516_PIN_61_SCL2__FUNC_SCL2_0>;
> @@ -223,21 +223,21 @@ pins1 {
>                 };
>         };
>
> -       tca6416_pins: pinmux_tca6416_pins {
> -               gpio_mux_rst_n_pin {
> +       tca6416_pins: tca6416-pins {
> +               pins-mux-rstn {
>                         pinmux =3D <MT8516_PIN_65_UTXD1__FUNC_GPIO65>;
>                         output-high;
>                 };
>
> -               gpio_mux_int_n_pin {
> +               pins-mux-intn {
>                         pinmux =3D <MT8516_PIN_64_URXD1__FUNC_GPIO64>;
>                         input-enable;
>                         bias-pull-up;
>                 };
>         };
>
> -       ethernet_pins_default: ethernet {
> -               pins_ethernet {
> +       ethernet_pins_default: ethernet-pins {
> +               pins-eth {
>                         pinmux =3D <MT8516_PIN_0_EINT0__FUNC_EXT_TXD0>,
>                                  <MT8516_PIN_1_EINT1__FUNC_EXT_TXD1>,
>                                  <MT8516_PIN_5_EINT5__FUNC_EXT_RXER>,
> --
> 2.50.1
>
>
