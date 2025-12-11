Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F09B2D948D
	for <linux-crypto@vger.kernel.org>; Thu, 11 Dec 2025 11:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765452750; cv=none; b=IV4g117CcSCJeMG6Ybk0aipt8TMgsH7sSY8Io3VUtN8+6Zx/OgHPT+lxnE01dkb+zIEC+xWeMRkjh0rn0J2K/ZC4LOAwZ11W2Ih0tF4tCpcX+EA6sB2OSgNkag1/Ajb8/H6J6TV1QT4cuYr7smY/xIszkERwe/cMqkrlvyISGm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765452750; c=relaxed/simple;
	bh=POzzpg6IYRZPIIqbdlvOsPFON8CAFCtqiOP8BsCzG6o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=loeX84VemPHqHhc3llRKFY9pHqwExskifqGLUDFSm9eE1/5Q1uL3cEaFdarSdnN7HYCDrBvGRwn4zYlVDwoco+nF3Suv6RTCM351x6HzO1W1wQzJryixxisN57cBzY1Y74h4HrUJznwSmpSaCKjZ+E4lMC+MVPv3B0ObM7zGl6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=NtJnTaGk; arc=none smtp.client-ip=209.85.128.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="NtJnTaGk"
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-78a712cfbc0so9670127b3.1
        for <linux-crypto@vger.kernel.org>; Thu, 11 Dec 2025 03:32:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1765452747; x=1766057547; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=tsAQFyywzgQt8hTuOma0wGcWOIPVIjI9LIgrRTCikK4=;
        b=NtJnTaGkvuf9r5BFmo4AYj1CaI/INFVazyoJJPcv6K82v1KZBH+lOmxmhfMbLhLfcr
         uVe7oFkhwFobKOHzwGE63T2H9L27wdtFG+lP/ffLqN/Mwa1j979U38NfyOSHMXS4xV3U
         OrdQcgWaJj8CfZdVsKjpGx41q+OVZcHd3SbAOyBbBmsyNmFmA0CWANT/ZLsn+l6reRO1
         iDromQMSouYwyd7ZM/RM76HLP6f9e1+BLAwv/74l3krLepSOQYcYDlUObFz9s5MOBoxu
         N2kKHOYjrMvzXu+SXOX2XqGew8KU/TGDHnk00b1SzSh5f5/FiQLTSjZ2VPcdWiI9COTz
         Jxlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765452747; x=1766057547;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tsAQFyywzgQt8hTuOma0wGcWOIPVIjI9LIgrRTCikK4=;
        b=B4d0BoHuaOx3BAOb04fm3LtQAUI62Nh958b/K/NzWWonz0Vty/IpFsUiseNLIxrQSo
         oa1BGLWO4aZ+7qfHeIKfoehgk/GuYSb7ccfCSfdx0FkRQyeuQlHaWZqh3tJO2KIen4AI
         3BNcPfakfTit+9tLIhSTHtQyfJZ+2slK6l55sIS7SKJrt0BSIUDBC2oIeukqHC2iWmP6
         1Mwr9JYmMQc2/29/nxsfty4dM5XVldBs4OGC4iNs+dHni0gLo186U2B8t5OiBUA0gnuC
         oZsMjN/Z9INDUuZPy5jr1SvoRQZq9jsGPfSXJKo1nv9HxLXwg8zH9Dlj7lAt4UPzUg7O
         wVCw==
X-Forwarded-Encrypted: i=1; AJvYcCWGHbwzWDBrG+5TUWv2dq5YE0Zh8mbiEsJL3idoMCOoJE4p6e6n5CZn3+O/ode/z0uGaulRa0WxpdB0wF8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzwlc8jA4WFNvIAVGIos/bHGzfBCGvWuMXh/gmxV+8I4XIcChXK
	CRtGWNmE57GeaK0xJhpzS8iW92ta4B4BN9/3Umd8sMpVLTqdApHQM9Vi4w+p/ANauGP/liKGkVs
	0Ez+bXv96Sn6hUAzY97QZThFGKzUCC/Q3OaFiwWJ05A==
X-Gm-Gg: AY/fxX6VLELZuqBSKOdUCnyB40GEGCT2pTVAY/iVhwXp3yzZLtODK30hdWNY7qAoYEs
	bJvK9iIymKFjno1EcI8pjAGl326rFuXI3MVLPI9EZl+Lb3RwO1h2ZeHMoW7gyTliMnTETJt+DC7
	MSnf63CO/hV9OcazW6xla5NAnZte5U90KeG5TKfFVZJJ8U0hEmJxZNDy8ibL3oNqr3RplmbLzZx
	ygZl7Qap5JY0wCVc8Raw2EydRbwmdcvJFIWPbMG3lNcUOjr/wEi2x65neQPVckZLbGkB955jqJ8
	mC3Pta8=
X-Google-Smtp-Source: AGHT+IGi8FI7tue2F1muYiYdXCcwa1VCSq2fLFaLgh7A0p4DE+EvhP5UsxEj9lkt3uuk+LvjC2KVDNW0gmzNrvJK74w=
X-Received: by 2002:a05:690c:45c5:b0:787:bf16:d489 with SMTP id
 00721157ae682-78ca64495eamr51688117b3.62.1765452747098; Thu, 11 Dec 2025
 03:32:27 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251211-dev-dt-warnings-all-v1-0-21b18b9ada77@codeconstruct.com.au>
 <20251211-dev-dt-warnings-all-v1-8-21b18b9ada77@codeconstruct.com.au>
In-Reply-To: <20251211-dev-dt-warnings-all-v1-8-21b18b9ada77@codeconstruct.com.au>
From: Ulf Hansson <ulf.hansson@linaro.org>
Date: Thu, 11 Dec 2025 12:31:50 +0100
X-Gm-Features: AQt7F2pk6E2fyrBRST0HoIuBOhvmNQUfLJiP182o7R-P0Ig55Fk3IUyQwfYuHbU
Message-ID: <CAPDyKFpQXYFFrZ-unVxa9m2+tKLEyFZyo7Tv7JD_7vTbqqfmDQ@mail.gmail.com>
Subject: Re: [PATCH RFC 08/16] ARM: dts: aspeed: Use specified wp-inverted
 property for AST2600 EVB
To: Andrew Jeffery <andrew@codeconstruct.com.au>
Cc: Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
	Conor Dooley <conor+dt@kernel.org>, Linus Walleij <linusw@kernel.org>, Joel Stanley <joel@jms.id.au>, 
	linux-hwmon@vger.kernel.org, devicetree@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-aspeed@lists.ozlabs.org, 
	linux-kernel@vger.kernel.org, openbmc@lists.ozlabs.org, 
	linux-gpio@vger.kernel.org, linux-mmc@vger.kernel.org, 
	linux-crypto@vger.kernel.org, linux-iio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 11 Dec 2025 at 09:47, Andrew Jeffery
<andrew@codeconstruct.com.au> wrote:
>
> While sdhci-pltfm supports sdhci,wp-inverted, it also supports
> the un-prefixed and specified wp-inverted property. Switch the EVB
> devicetree to use the specified property to remove warnings when
> checking the DTB.
>
> Signed-off-by: Andrew Jeffery <andrew@codeconstruct.com.au>

FWIW:

Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>


> ---
>  arch/arm/boot/dts/aspeed/aspeed-ast2600-evb.dts | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm/boot/dts/aspeed/aspeed-ast2600-evb.dts b/arch/arm/boot/dts/aspeed/aspeed-ast2600-evb.dts
> index 3eba676e57f1..c51977dcb56b 100644
> --- a/arch/arm/boot/dts/aspeed/aspeed-ast2600-evb.dts
> +++ b/arch/arm/boot/dts/aspeed/aspeed-ast2600-evb.dts
> @@ -315,7 +315,7 @@ &sdhci0 {
>         bus-width = <4>;
>         max-frequency = <100000000>;
>         sdhci-caps-mask = <0x7 0x0>;
> -       sdhci,wp-inverted;
> +       wp-inverted;
>         vmmc-supply = <&vcc_sdhci0>;
>         vqmmc-supply = <&vccq_sdhci0>;
>         clk-phase-sd-hs = <7>, <200>;
> @@ -326,7 +326,7 @@ &sdhci1 {
>         bus-width = <4>;
>         max-frequency = <100000000>;
>         sdhci-caps-mask = <0x7 0x0>;
> -       sdhci,wp-inverted;
> +       wp-inverted;
>         vmmc-supply = <&vcc_sdhci1>;
>         vqmmc-supply = <&vccq_sdhci1>;
>         clk-phase-sd-hs = <7>, <200>;
>
> --
> 2.47.3
>
>
