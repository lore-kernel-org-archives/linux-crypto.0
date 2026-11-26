Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795723264;
	b=QVHMPCPLJUlruz2UGM1h3FRPh3Ok0ID/S0QX1KrppwHNP4sHHzc/t2hwadJpEhK6UrC1
	 FSYl3Sz1+fPZi42i/ZfQ3do3HRorpurVs4mU41xaafh/r0DVVXeqtep6Kxe4dEDxhsL0v
	 FIr/s97Tzktqt2oUrqQyp77vxy9kbmSZB5MDLzRHwFIHN/wsf7dBySapn37uqbDJArZcm
	 HmphjgBGdXiD/cRTk/uFW7tQh++vgIMY8cZ3V6RTQDiFjdJTvQgPZdks+uJJjVJbBxYu0
	 PZIroyNfi8lgmbLL5lEYDEf/eJ0+m+Vi/3Qa3ol3ILA9wAvOmn2gJMH0h+A+3mq/d3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795723264;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=JCXkt01VM6U/p+0B+tdrqVqUmglqEINGvVX7k+vJJ0Y=;
	b=Nb5uIrrhxwxhMS/wH4LDHzbQIXlw3qhm6+6RBxNGq2giP+puyyLE+PjBg6E+gEIGZ8h/
	 idcWI932j4MLzY3mhxaK98NWgy7cfZIL+MixjMp1uv6HPnM2VgsE/7xjGjEb12l//KtZM
	 z0t9TkGTx9cVN+/ZhT4l8Ls3U0Iz2QQiWV+IM+kDNowjd6eEMXUf+CXWPK8FhbUrMg0Kk
	 5ijBdTe3mBnJ0jXWaxtCxc66twYKpjzhhMBI6xBgkEh1HuA0K3P9rEpLY0E4YlA9USGnv
	 A1dptDkozqlQVMCWlY7jo5q1AgWkRjLXbyZ7cD+xoMrXwuh5lnbUhwm1XUymVOzOI3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QQ+8kPxa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02A79606A31C;
	Thu, 26 Nov 2026 20:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QQ+8kPxa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0880A1F000D2;
	Thu, 26 Nov 2026 20:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795723263;
	bh=JCXkt01VM6U/p+0B+tdrqVqUmglqEINGvVX7k+vJJ0Y=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QQ+8kPxarTAXPrxzVhz6Wm20mtwm9s1ldQX1dNi1cBpqnC5iq8aQbcRFNbW+aNkxp
	 9RKY91D2pCLbPzsajyW5pvc42wALgiHKemoFyi8Gq/ikXXrtDWhYHSKmq3nRnXhwvG
	 uxaaCc9tzwSM3wRsyFudkaihA48SbyQ8GL9gL4dFdDUW7eSPTmN79yVZyJPNQrMEdb
	 jfPQGq/ynke5W2tEqeNRph9RIxFwMJFxmELbHH/g7AZrkJoCzGNz9UeuFE1EKnnThp
	 rbzfQP21TtwFXsyDhHi/ZKZnGrB0FdGV+XX7lzYFyh8IOR9PtKWdOVXNeh7ZcjNIJx
	 P2G9QwWh/0DIw==
Message-ID: <sashiko-outbox-236139@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v13 22/25] arm64: dts: amlogic: a1: add crypto node
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jose Nieto" <jnieto.alaber@gmail.com>, "Corentin Labbe" <clabbe@baylibre.com>, "Herbert
 Xu" <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, linux-amlogic@lists.infradead.org, devicetree@vger.kernel.org, "Neil
 Armstrong" <neil.armstrong@linaro.org>, "Martin Blumenstingl" <martin.blumenstingl@googlemail.com>, "Krzysztof
 Kozlowski" <krzk+dt@kernel.org>, "Rob Herring" <robh@kernel.org>, "Conor
 Dooley" <conor+dt@kernel.org>, "Alexey Romanov" <romanov.alexey2000@gmail.com>
In-Reply-To: <20261126193241.1471372-23-jnieto.alaber@gmail.com>
References: <20261126193241.1471372-1-jnieto.alaber@gmail.com>
 <20261126193241.1471372-23-jnieto.alaber@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 26 Nov 2026 20:01:02 +0000
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] arm64: dts: amlogic: a1: fake clk81 fixed-clock used instead
  of clkc_periphs
--

commit f6324854d1c8642eee51ed11c0843bb81bd2ce76
Author: Alexey Romanov <romanov.alexey2000@gmail.com>

arm64: dts: amlogic: a1: add crypto node

This commit adds a crypto controller node and a fixed-clock clk81 node to
the Amlogic Meson A1 devicetree.

> diff --git a/arch/arm64/boot/dts/amlogic/meson-a1.dtsi b/arch/arm64/boot/=
dts/amlogic/meson-a1.dtsi
> index 6f6a6145cba12..396260b7b3989 100644
> --- a/arch/arm64/boot/dts/amlogic/meson-a1.dtsi
> +++ b/arch/arm64/boot/dts/amlogic/meson-a1.dtsi
> @@ -686,6 +686,14 @@ sd_emmc: mmc@10000 {
>  				assigned-clocks =3D <&clkc_periphs CLKID_SD_EMMC>;
>  				assigned-clock-rates =3D <24000000>;
>  			};
> +
> +			crypto: crypto@6000 {
> +				compatible =3D "amlogic,a1-crypto";
> +				reg =3D <0x0 0x6000 0x0 0x48>;
> +				interrupts =3D <GIC_SPI 120 IRQ_TYPE_EDGE_RISING>;
> +				clocks =3D <&clk81>;
> +				power-domains =3D <&pwrc PWRC_DMA_ID>;
> +			};
>  		};
> =20
>  		usb: usb@fe004400 {
> @@ -767,4 +775,10 @@ xtal: xtal-clk {
>  		clock-output-names =3D "xtal";
>  		#clock-cells =3D <0>;
>  	};
> +
> +	clk81: clk81 {
> +		compatible =3D "fixed-clock";
> +		#clock-cells =3D <0>;
> +		clock-frequency =3D <64000000>;
> +	};
>  };

[Severity: Medium]
Should crypto@6000 take its clock from &clkc_periphs instead of defining a
separate root fixed-clock node?

meson-a1.dtsi already defines clkc_periphs ("amlogic,a1-peripherals-clkc"),
which registers the A1 system and DMA clocks (CLKID_SYS and CLKID_DMA).
Adding a synthetic 64 MHz clk81 fixed-clock node bypasses the SoC clock
controller and uses a non-generic node name that does not match the
^clock-([0-9]+|[a-z0-9-]+)$ pattern required by fixed-clock.yaml.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261126193241.1471=
372-1-jnieto.alaber@gmail.com?part=3D22
