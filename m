Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 908F223ABBB
	for <linux-crypto@vger.kernel.org>; Fri, 25 Jul 2025 11:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753443840; cv=none; b=YK8VaxfMzpl601mt+hgcnBldJ5Nr7udM1Qc74VQ000o0dcrP7H/1bM5bQoEqDnsLeaGRnu7QmILfEHDRZYIWsAP3nD1JjfSq/qMmtFCmVcZHEdtUS/BHo4JSitYz87pVCr9zaYmwlX8fG+t38Mxe3+HqftpRQlacO7bMp1Fv+Fg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753443840; c=relaxed/simple;
	bh=IU7jvnAwzmp5GuJHgplXAk58lqyd9tH4hjc214tIw4o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KiNxgF+cSd+YLE8BwNHrEjf+jdxL74eYgyJ8Ge9Au+N2/zoip+xqgR6bJF7QTBmRbnmlUoHwKU8xinFeSPbsurEoJs4JnQCGOVA20fROICPNbGPW795P/M8Yy3rSoK9t8b/WXIT6nHJkRCDBh5Os1IMdbJsbgvzEGtV9hCKCwVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=TrBY7du4; arc=none smtp.client-ip=209.85.219.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="TrBY7du4"
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-700c7e4c048so30171546d6.3
        for <linux-crypto@vger.kernel.org>; Fri, 25 Jul 2025 04:43:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1753443837; x=1754048637; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=liSvRWA4OuPhKZFuMFSYIULFcTNts/JUeGi4znSdmNM=;
        b=TrBY7du4LnvpsUkd2jrJImNvju63DhXPSn9gt+ISaAzLsGZNdVEOTCF9ohTnIPYUKQ
         veMjv3gmoKUYO5aNtMngHYDrZ9TEPXBASZAw6WOYorxfOYeKjVrsABU86IKWPFvWgsCb
         sdKRXRgOEsiudtErWjRTryEy94K6JOADEARU0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753443837; x=1754048637;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=liSvRWA4OuPhKZFuMFSYIULFcTNts/JUeGi4znSdmNM=;
        b=mCTEl9AUlyquCBhkeei9aB3OQC9aQxFcUKijBCbfnesE7cLIiav1AkDF3oKQ9kidO5
         AkItKfE+3d0FGjV+l7FIk/o94JDE8c/HmnvM/Y4sn+uP1Yv1XpI/EiigKBSh7dliv1C4
         Ka1Fg0syNCPr6CYTTarR6/Hj0aBOx7ixbnQuKPQKeAq9KM9LWOA4WzCV9rln/0QtJ7L4
         4tQdRDbtQz1ogrC8S12jkbaQ/y3QXG/CFwCnCmHGXDAZ3UUef1Ym4ug3GAyT5b01YXKJ
         FY/JC2u6oRmirGNDFTffbgVV4P6WvcMEeDP8s2gCFp9hKvzc9KI/MPPVvz67AMfZyxHL
         dVlA==
X-Forwarded-Encrypted: i=1; AJvYcCWX0V3r/dHR5l26x0pcK03QeWShxhaUHqcJm3bbm5hPehmKUee7zGp2dPkY6B5k1qUOGf9knHh4nDTlCiY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy7uSH8yGkw8gbESI/kw4TXjqRSgAmDW+rcogENJePMt8bnARQZ
	Fu0K/cfc5XJbpReHDt5mSP22usX3k/z6DnDgD3mbYHtVTGJa++mUSYV6kWgov6ji4J2u45EEZNh
	dw+8mYb33
X-Gm-Gg: ASbGncskS9uqZRRUt5hKrB3oVrOv9dKcJFN6ZRqW9FCHA+meqC9K9+FvOYY6pweRR3J
	WniqYkPT1/WIWIrfl9utN4pglrT6D5Zit1I6fxcT81rabtmBszv9KQjkOGrIEilF/cOWsoEXuMG
	IxsJx7EHCS1xSY1u2aFJzO3bXWgcffwc5HZQFNCohHZfCJAXVLN+lGtCETtVhgW/V4H6eVB20nF
	KCRe3uiuUSDDtz2tve/KaKOlLJ/U10u0yC4d7Gj/McXamNajRl3qenIdQ5zyAW4TPQ6IWKQlQbn
	6S7AnDjVXccmyy0nhnxtGPz67As52n6WQkzvPDn7o01WaA5x1cwGefwLDhf85xuAecEtOfWmd8k
	gwBclarCVerV5Y9wndUuZcz4hUreYqTrueJVj/M7ZvudWnTgZ4d3p5zLldw==
X-Google-Smtp-Source: AGHT+IFSoIYLaylnKNJKUvso41DSnkz7VB5B7UBF3wpBwV04Vrsg+erKULDUrK+ib7mzzDsUq/a9gg==
X-Received: by 2002:a05:6214:29eb:b0:704:8e16:51e9 with SMTP id 6a1803df08f44-707205ef5fbmr20178916d6.45.1753443837161;
        Fri, 25 Jul 2025 04:43:57 -0700 (PDT)
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com. [209.85.219.46])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-7070fcca5a4sm25292626d6.79.2025.07.25.04.43.57
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Jul 2025 04:43:57 -0700 (PDT)
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-700c7e4c048so30171076d6.3
        for <linux-crypto@vger.kernel.org>; Fri, 25 Jul 2025 04:43:57 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXk4xl4c+xjtp+sNXfinZC8UfRpuLMd2JbLcnSbP5aAelmj78KzqeR4pe6kGM3qVeLvADatq4EhQBkzIrw=@vger.kernel.org
X-Received: by 2002:a05:6102:6891:b0:4dd:b82d:e0de with SMTP id
 ada2fe7eead31-4fa3ff44195mr308667137.17.1753440019738; Fri, 25 Jul 2025
 03:40:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250724083914.61351-1-angelogioacchino.delregno@collabora.com> <20250724083914.61351-38-angelogioacchino.delregno@collabora.com>
In-Reply-To: <20250724083914.61351-38-angelogioacchino.delregno@collabora.com>
From: Fei Shao <fshao@chromium.org>
Date: Fri, 25 Jul 2025 18:39:43 +0800
X-Gmail-Original-Message-ID: <CAC=S1njv7qrL0LyhZsp=HVdxxDo2bA7FbCkMVqJ9R9qpg-0hMw@mail.gmail.com>
X-Gm-Features: Ac12FXzAeqGgOrEJjRR1J4ryO0U3L8RJWv4_H_TyT4RYPsIpmGY3ViSbTr41uno
Message-ID: <CAC=S1njv7qrL0LyhZsp=HVdxxDo2bA7FbCkMVqJ9R9qpg-0hMw@mail.gmail.com>
Subject: Re: [PATCH 37/38] arm64: dts: mediatek: mt8395-kontron-i1200: Fix
 MT6360 regulator nodes
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
> All of the MT6360 regulator nodes were wrong and would not probe
> because the regulator names are supposed to be lower case, but
> they are upper case in this devicetree.
>
> Change all nodes to be lower case to get working regulators.
>
> Fixes: 94aaf79a6af5 ("arm64: dts: mediatek: add Kontron 3.5"-SBC-i1200")
> Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@coll=
abora.com>

Reviewed-by: Fei Shao <fshao@chromium.org>

> ---
>  .../mediatek/mt8395-kontron-3-5-sbc-i1200.dts    | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
>
> diff --git a/arch/arm64/boot/dts/mediatek/mt8395-kontron-3-5-sbc-i1200.dt=
s b/arch/arm64/boot/dts/mediatek/mt8395-kontron-3-5-sbc-i1200.dts
> index 4985b65925a9..d16f545cbbb2 100644
> --- a/arch/arm64/boot/dts/mediatek/mt8395-kontron-3-5-sbc-i1200.dts
> +++ b/arch/arm64/boot/dts/mediatek/mt8395-kontron-3-5-sbc-i1200.dts
> @@ -352,7 +352,7 @@ regulator {
>                         LDO_VIN2-supply =3D <&vsys>;
>                         LDO_VIN3-supply =3D <&vsys>;
>
> -                       mt6360_buck1: BUCK1 {
> +                       mt6360_buck1: buck1 {
>                                 regulator-name =3D "emi_vdd2";
>                                 regulator-min-microvolt =3D <600000>;
>                                 regulator-max-microvolt =3D <1800000>;
> @@ -362,7 +362,7 @@ MT6360_OPMODE_LP
>                                 regulator-always-on;
>                         };
>
> -                       mt6360_buck2: BUCK2 {
> +                       mt6360_buck2: buck2 {
>                                 regulator-name =3D "emi_vddq";
>                                 regulator-min-microvolt =3D <300000>;
>                                 regulator-max-microvolt =3D <1300000>;
> @@ -372,7 +372,7 @@ MT6360_OPMODE_LP
>                                 regulator-always-on;
>                         };
>
> -                       mt6360_ldo1: LDO1 {
> +                       mt6360_ldo1: ldo1 {
>                                 regulator-name =3D "mt6360_ldo1"; /* Test=
 point */
>                                 regulator-min-microvolt =3D <1200000>;
>                                 regulator-max-microvolt =3D <3600000>;
> @@ -380,7 +380,7 @@ mt6360_ldo1: LDO1 {
>                                                            MT6360_OPMODE_=
LP>;
>                         };
>
> -                       mt6360_ldo2: LDO2 {
> +                       mt6360_ldo2: ldo2 {
>                                 regulator-name =3D "panel1_p1v8";
>                                 regulator-min-microvolt =3D <1800000>;
>                                 regulator-max-microvolt =3D <1800000>;
> @@ -388,7 +388,7 @@ mt6360_ldo2: LDO2 {
>                                                            MT6360_OPMODE_=
LP>;
>                         };
>
> -                       mt6360_ldo3: LDO3 {
> +                       mt6360_ldo3: ldo3 {
>                                 regulator-name =3D "vmc_pmu";
>                                 regulator-min-microvolt =3D <1800000>;
>                                 regulator-max-microvolt =3D <3300000>;
> @@ -396,7 +396,7 @@ mt6360_ldo3: LDO3 {
>                                                            MT6360_OPMODE_=
LP>;
>                         };
>
> -                       mt6360_ldo5: LDO5 {
> +                       mt6360_ldo5: ldo5 {
>                                 regulator-name =3D "vmch_pmu";
>                                 regulator-min-microvolt =3D <3300000>;
>                                 regulator-max-microvolt =3D <3300000>;
> @@ -404,7 +404,7 @@ mt6360_ldo5: LDO5 {
>                                                            MT6360_OPMODE_=
LP>;
>                         };
>
> -                       mt6360_ldo6: LDO6 {
> +                       mt6360_ldo6: ldo6 {
>                                 regulator-name =3D "mt6360_ldo6"; /* Test=
 point */
>                                 regulator-min-microvolt =3D <500000>;
>                                 regulator-max-microvolt =3D <2100000>;
> @@ -412,7 +412,7 @@ mt6360_ldo6: LDO6 {
>                                                            MT6360_OPMODE_=
LP>;
>                         };
>
> -                       mt6360_ldo7: LDO7 {
> +                       mt6360_ldo7: ldo7 {
>                                 regulator-name =3D "emi_vmddr_en";
>                                 regulator-min-microvolt =3D <1800000>;
>                                 regulator-max-microvolt =3D <1800000>;
> --
> 2.50.1
>
>
