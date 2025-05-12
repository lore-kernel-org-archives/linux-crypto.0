Received: from mail-ua1-f41.google.com (mail-ua1-f41.google.com [209.85.222.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB72C2798F6
	for <linux-crypto@vger.kernel.org>; Mon, 12 May 2025 18:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747075643; cv=none; b=nnuOrl48Or7HwNnO+B81lxwTh3PfwG2tqWCIUXWQ0DuI0H/3ckIpO9IPPB9Z2tWbY1ZbIwv572w90vgvKtHWD2rQ+8adyp5NUAGz2T2I2mCG9M4UW7B5BpsRzqmj4hQ4Z8h9294AQ90nHlT1yBuaqogVYDwj9vFaUEyWjMAgtjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747075643; c=relaxed/simple;
	bh=pjp0Jm/+unRxg3M7klBuy33/1qS+MTGzc4pjf5oLtK0=;
	h=From:References:In-Reply-To:MIME-Version:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=j1okBBSS7OntJCh8ECEX+tCcJ+crCiB7puRa23oj7KMOHj3qYbVttD6TTdzjclrTJoxNvP8Y5yYujCxL9FKWMBGUY7vnu5dSzKFkJs/PYv42PTLuR51AGQTu7/r2jsInF1ba9N0AH/xOLeHawxy7kLXdhSqzZZdc407Uk7IJB7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=Z/GoK6Fs; arc=none smtp.client-ip=209.85.222.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Z/GoK6Fs"
Received: by mail-ua1-f41.google.com with SMTP id a1e0cc1a2514c-87843c435f3so1311405241.3
        for <linux-crypto@vger.kernel.org>; Mon, 12 May 2025 11:47:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1747075639; x=1747680439; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:thread-index:mime-version:in-reply-to
         :references:from:from:to:cc:subject:date:message-id:reply-to;
        bh=F4MFj3TahCbDFxpmhOnFQI0vS6q4s6XkVreGNkFYpaU=;
        b=Z/GoK6FsuRjS/ioW/IHHg+6iJYhDOYl8LR0SMMEEra1cGfhgqfAsEr/iTW0gJTySp5
         5gFrQ6iC56rynI1NU8gQo/1jQzy/25gvroZ40Au390313gGPI8eTnGfjKLGN/qL4rEXk
         8O08dPCWatl4ZQ+jaFr29rTeepTNDvO7gKdGw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747075639; x=1747680439;
        h=cc:to:subject:message-id:date:thread-index:mime-version:in-reply-to
         :references:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F4MFj3TahCbDFxpmhOnFQI0vS6q4s6XkVreGNkFYpaU=;
        b=Bwyu8c0O3bFUuL+/+YhOMbQ+4oCp9mLRzDMRSTWKqPef14efmCfs4p7WnvTpFsz0hB
         1DQhCh2SbMRVmVljS2/RmU77mRf/louHh6Hc/aJvCgT18SLaZlRhpAzRq2wi0Xzwnji2
         lIbPyMxSH3ACkT9LONxZ/8xiGdBhhL18GjX9LezR2zAvtCaTxoT1oo6BRBPlYBLn52YD
         PQcKv5Tqv38DhU8MwotKuMR7kgBL7WfgeLN++NgPyU4SrQEabPzK8s8DVAjR3hV6m6Jg
         Gu6rXliAPP6Sc6T1ZfxISsO3gBkdvwlPtH9y3W1j254iXsffhvCW1TrHlhASappSDmxU
         jVNQ==
X-Forwarded-Encrypted: i=1; AJvYcCX+S2ZdEEu2H3nqgrknVeYuJTh1L8zQ0+lRAuDIl8xEYrLCh1M6+0qYw20/vrmwTQIEok36/MI4/TDDYLI=@vger.kernel.org
X-Gm-Message-State: AOJu0YysQuqme8LZR3qCh0Uzb84gt/7xw9brE2FE2I02DI4Yasy8WWZo
	dI6XN9CVNh9OA1O8PJUjcFr7agP8PEC0LaQsMJF3DjN6OVASyxn+qXV7wJwZUe59NUL4VnrylO8
	jkOt2hiHfqrt3hehN7gv2qmJritC8ZIqzUQ1T
X-Gm-Gg: ASbGncu0BKntElTDK+tH33vGy/4OFI4nMhmqTiJztaqL8PHyE3RGYEGmCwJd+ryPmMI
	nmilIQj3PE5dNYfJakNaaKn6Ddj8YTKVLz1S6R/3irqWh4hqLL1y4GI5GJTjkr9DCWHyowu/z/j
	/roxaDwNijBJPGwqiFeXGU5X/HM2/GMk//0Q==
X-Google-Smtp-Source: AGHT+IEdUFNJlWQQ8kD7dhEYXNHCoavyBbj+nglEL1JLWeQdnYImHwqg4BYtrPap6Koftx2zRL/G5cOJklIkLEz6V2U=
X-Received: by 2002:a05:6102:3e18:b0:4dd:ba76:feec with SMTP id
 ada2fe7eead31-4deed33318emr11065473137.6.1747075638657; Mon, 12 May 2025
 11:47:18 -0700 (PDT)
From: William Zhang <william.zhang@broadcom.com>
References: <20250512-bcmbca-peripherals-arm-v3-0-86f97ab4326f@linaro.org> <20250512-bcmbca-peripherals-arm-v3-12-86f97ab4326f@linaro.org>
In-Reply-To: <20250512-bcmbca-peripherals-arm-v3-12-86f97ab4326f@linaro.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQHRV/QBxSS57P/922lUlscQxKMBIAIGj5tCs9P4KlA=
Date: Mon, 12 May 2025 11:47:21 -0700
X-Gm-Features: AX0GCFuxeVwxGExYSh-doW1JB-IYztvBH0iJNd68QNLMbxVReatUt_NHGdOACSA
Message-ID: <2371fc6196d4a0aef2f25c439c4028de@mail.gmail.com>
Subject: RE: [PATCH v3 12/12] ARM64: dts: bcm63158: Add BCMBCA peripherals
To: Linus Walleij <linus.walleij@linaro.org>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Anand Gore <anand.gore@broadcom.com>, Kursad Oney <kursad.oney@broadcom.com>, 
	Florian Fainelli <florian.fainelli@broadcom.com>, =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>, 
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, Olivia Mackall <olivia@selenic.com>, 
	Ray Jui <rjui@broadcom.com>, Scott Branden <sbranden@broadcom.com>, 
	Florian Fainelli <f.fainelli@gmail.com>
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-crypto@vger.kernel.org
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="000000000000dc05930634f4be78"

--000000000000dc05930634f4be78
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> -----Original Message-----
> From: Linus Walleij <linus.walleij@linaro.org>
> Sent: Monday, May 12, 2025 5:06 AM
> To: Rob Herring <robh@kernel.org>; Krzysztof Kozlowski
> <krzk+dt@kernel.org>;
> Conor Dooley <conor+dt@kernel.org>; William Zhang
> <william.zhang@broadcom.com>; Anand Gore <anand.gore@broadcom.com>;
> Kursad Oney <kursad.oney@broadcom.com>; Florian Fainelli
> <florian.fainelli@broadcom.com>; Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.p=
l>;
> Broadcom
> internal kernel review list <bcm-kernel-feedback-list@broadcom.com>;
> Olivia
> Mackall <olivia@selenic.com>; Ray Jui <rjui@broadcom.com>; Scott Branden
> <sbranden@broadcom.com>; Florian Fainelli <f.fainelli@gmail.com>
> Cc: devicetree@vger.kernel.org; linux-arm-kernel@lists.infradead.org;
> linux-
> crypto@vger.kernel.org; Linus Walleij <linus.walleij@linaro.org>
> Subject: [PATCH v3 12/12] ARM64: dts: bcm63158: Add BCMBCA peripherals
>
> All the BCMBCA SoCs share a set of peripherals at 0xff800000,
> albeit at slightly varying memory locations on the bus and
> with varying IRQ assignments.
>
> Add the watchdog, GPIO blocks, RNG, LED, second UART and DMA
> blocks for the BCM63158 based on the vendor files 63158_map_part.h
> and 63158_intr.h from the "bcmopen-consumer" code drop.
>
> The DTSI file has clearly been authored for the B0 revision of
> the SoC: there is an earlier A0 version, but this has
> the UARTs in the legacy PERF memory space, while the B0
> has opened a new peripheral window at 0xff812000 for the
> three UARTs. It also has a designated AHB peripheral area
> at 0xff810000 where the DMA resides, the peripheral range
> window fits these two peripheral groups.
>
> This SoC has up to 256 possible GPIOs due to having 8
> registers with 32 GPIOs in each available.
>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>  arch/arm64/boot/dts/broadcom/bcmbca/bcm63158.dtsi | 129
> ++++++++++++++++++++++
>  1 file changed, 129 insertions(+)
>
> diff --git a/arch/arm64/boot/dts/broadcom/bcmbca/bcm63158.dtsi
> b/arch/arm64/boot/dts/broadcom/bcmbca/bcm63158.dtsi
> index
> 48d618e75866452a64adfdc781ac0ea3c2eff3e8..a441388c0cd251d7dd5381f7b5
> 59633a89693232 100644
> --- a/arch/arm64/boot/dts/broadcom/bcmbca/bcm63158.dtsi
> +++ b/arch/arm64/boot/dts/broadcom/bcmbca/bcm63158.dtsi
> @@ -1,6 +1,7 @@
>  // SPDX-License-Identifier: (GPL-2.0+ OR MIT)
>  /*
>   * Copyright 2022 Broadcom Ltd.
> + * This DTSI is for the B0 and later revision of the SoC
>   */
>
>  #include <dt-bindings/interrupt-controller/irq.h>
> @@ -125,6 +126,101 @@ bus@ff800000 {
>  		#size-cells =3D <1>;
>  		ranges =3D <0x0 0x0 0xff800000 0x800000>;
>
> +		/* GPIOs 0 .. 31 */
> +		gpio0: gpio@500 {
> +			compatible =3D "brcm,bcm6345-gpio";
> +			reg =3D <0x500 0x04>, <0x520 0x04>;
> +			reg-names =3D "dirout", "dat";
> +			gpio-controller;
> +			#gpio-cells =3D <2>;
> +			status =3D "disabled";
> +		};
> +
> +		/* GPIOs 32 .. 63 */
> +		gpio1: gpio@504 {
> +			compatible =3D "brcm,bcm6345-gpio";
> +			reg =3D <0x504 0x04>, <0x524 0x04>;
> +			reg-names =3D "dirout", "dat";
> +			gpio-controller;
> +			#gpio-cells =3D <2>;
> +			status =3D "disabled";
> +		};
> +
> +		/* GPIOs 64 .. 95 */
> +		gpio2: gpio@508 {
> +			compatible =3D "brcm,bcm6345-gpio";
> +			reg =3D <0x508 0x04>, <0x528 0x04>;
> +			reg-names =3D "dirout", "dat";
> +			gpio-controller;
> +			#gpio-cells =3D <2>;
> +			status =3D "disabled";
> +		};
> +
> +		/* GPIOs 96 .. 127 */
> +		gpio3: gpio@50c {
> +			compatible =3D "brcm,bcm6345-gpio";
> +			reg =3D <0x50c 0x04>, <0x52c 0x04>;
> +			reg-names =3D "dirout", "dat";
> +			gpio-controller;
> +			#gpio-cells =3D <2>;
> +			status =3D "disabled";
> +		};
> +
> +		/* GPIOs 128 .. 159 */
> +		gpio4: gpio@510 {
> +			compatible =3D "brcm,bcm6345-gpio";
> +			reg =3D <0x510 0x04>, <0x530 0x04>;
> +			reg-names =3D "dirout", "dat";
> +			gpio-controller;
> +			#gpio-cells =3D <2>;
> +			status =3D "disabled";
> +		};
> +
> +		/* GPIOs 160 .. 191 */
> +		gpio5: gpio@514 {
> +			compatible =3D "brcm,bcm6345-gpio";
> +			reg =3D <0x514 0x04>, <0x534 0x04>;
> +			reg-names =3D "dirout", "dat";
> +			gpio-controller;
> +			#gpio-cells =3D <2>;
> +			status =3D "disabled";
> +		};
> +
> +		/* GPIOs 192 .. 223 */
> +		gpio6: gpio@518 {
> +			compatible =3D "brcm,bcm6345-gpio";
> +			reg =3D <0x518 0x04>, <0x538 0x04>;
> +			reg-names =3D "dirout", "dat";
> +			gpio-controller;
> +			#gpio-cells =3D <2>;
> +			status =3D "disabled";
> +		};
> +
> +		/* GPIOs 224 .. 255 */
> +		gpio7: gpio@51c {
> +			compatible =3D "brcm,bcm6345-gpio";
> +			reg =3D <0x51c 0x04>, <0x53c 0x04>;
> +			reg-names =3D "dirout", "dat";
> +			gpio-controller;
> +			#gpio-cells =3D <2>;
> +			status =3D "disabled";
> +		};
> +
> +
> +		leds: led-controller@800 {
> +			#address-cells =3D <1>;
> +			#size-cells =3D <0>;
> +			compatible =3D "brcm,bcm63138-leds";
> +			reg =3D <0x800 0xdc>;
> +			status =3D "disabled";
> +		};
> +
> +		rng@b80 {
> +			compatible =3D "brcm,iproc-rng200";
> +			reg =3D <0xb80 0x28>;
> +			interrupts =3D <GIC_SPI 85 IRQ_TYPE_LEVEL_HIGH>;
> +		};
> +
>  		hsspi: spi@1000 {
>  			#address-cells =3D <1>;
>  			#size-cells =3D <0>;
> @@ -151,6 +247,21 @@ nandcs: nand@0 {
>  			};
>  		};
>
> +		/* B0 AHB Peripherals */
> +		pl081_dma: dma-controller@11000 {
> +			compatible =3D "arm,pl081", "arm,primecell";
> +			// The magic B105F00D info is missing
> +			arm,primecell-periphid =3D <0x00041081>;
> +			reg =3D <0x11000 0x1000>;
> +			interrupts =3D <GIC_SPI 94 IRQ_TYPE_LEVEL_HIGH>;
> +			memcpy-burst-size =3D <256>;
> +			memcpy-bus-width =3D <32>;
> +			clocks =3D <&periph_clk>;
> +			clock-names =3D "apb_pclk";
> +			#dma-cells =3D <2>;
> +		};
> +
> +		/* B0 ARM UART Peripheral block */
>  		uart0: serial@12000 {
>  			compatible =3D "arm,pl011", "arm,primecell";
>  			reg =3D <0x12000 0x1000>;
> @@ -159,5 +270,23 @@ uart0: serial@12000 {
>  			clock-names =3D "uartclk", "apb_pclk";
>  			status =3D "disabled";
>  		};
> +
> +		uart1: serial@13000 {
> +			compatible =3D "arm,pl011", "arm,primecell";
> +			reg =3D <0x13000 0x1000>;
> +			interrupts =3D <GIC_SPI 33 IRQ_TYPE_LEVEL_HIGH>;
> +			clocks =3D <&uart_clk>, <&uart_clk>;
> +			clock-names =3D "uartclk", "apb_pclk";
> +			status =3D "disabled";
> +		};
> +
> +		uart2: serial@14000 {
> +			compatible =3D "arm,pl011", "arm,primecell";
> +			reg =3D <0x14000 0x1000>;
> +			interrupts =3D <GIC_SPI 35 IRQ_TYPE_LEVEL_HIGH>;
> +			clocks =3D <&uart_clk>, <&uart_clk>;
> +			clock-names =3D "uartclk", "apb_pclk";
> +			status =3D "disabled";
> +		};
>  	};
>  };
>
> --
> 2.49.0

Reviewed-by: William Zhang <william.zhang@broadcom.com>

--000000000000dc05930634f4be78
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
YDZuuBJwnyCzevMoPtVYPharioL5H3BRnQi8YoTXH7/uRo33dewYFm474yFjwwnt82TFtveVZkVq
6h4WIQ4wTcwFfET8zMkELnGzS5SHCl8sPD+lNxxJ1JDZYwIDAQABo4IB2zCCAdcwDgYDVR0PAQH/
BAQDAgWgMIGjBggrBgEFBQcBAQSBljCBkzBOBggrBgEFBQcwAoZCaHR0cDovL3NlY3VyZS5nbG9i
YWxzaWduLmNvbS9jYWNlcnQvZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAuY3J0MEEGCCsGAQUF
BzABhjVodHRwOi8vb2NzcC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAy
MDBNBgNVHSAERjBEMEIGCisGAQQBoDIBKAowNDAyBggrBgEFBQcCARYmaHR0cHM6Ly93d3cuZ2xv
YmFsc2lnbi5jb20vcmVwb3NpdG9yeS8wCQYDVR0TBAIwADBJBgNVHR8EQjBAMD6gPKA6hjhodHRw
Oi8vY3JsLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNybDAlBgNV
HREEHjAcgRp3aWxsaWFtLnpoYW5nQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAf
BgNVHSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUq65GzwZxydFHjjYEU/9h
xHhPWlwwDQYJKoZIhvcNAQELBQADggEBAA2hGG3JPAdGPH0ZdohGUCIVjKz+U+EFuIDbS6A/5jqX
VhYAxZlzj7tSjUIM7G7IhyfqPC46GKJ/4x+Amz1Z6YxNGy71L68kYD6hIbBcA5AM42QBUufly6Oa
/ppSz3WoflVyFFQ5YXniZ+eU+2/cdnYZg4aVUnFjimOF5o3NfMLzOkhQNxbaDjFUfUYD8hKmU6v4
0vUBj8KZ9Gi1LIagLKUREn8jku0lcLsRbnJ5Ey5ScajC/FESPyYWasOW8j8/1EoJksmhbYGKNS6C
urb/KlmDGfVrIRYDbL0ckhGQIP5c6L+kSQZ2sHnQK0e0WgIaZYxaPYeY5u0GLCOze+3vyRMxggJg
MIICXAIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYD
VQQDEyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgwxuh2XG3FXRL1W
JOEwDQYJYIZIAWUDBAIBBQCggccwLwYJKoZIhvcNAQkEMSIEID0tazJk8U5JxZqv88ecpP2phyvT
vYm1zYFQ5PsPdHLmMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTI1
MDUxMjE4NDcxOVowXAYJKoZIhvcNAQkPMU8wTTALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsG
CWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQcwCwYJYIZIAWUDBAIBMA0GCSqGSIb3
DQEBAQUABIIBAFqqNqHs/CcPUh06kkQAgG7mcVZSi2ri79GRugJBLIPSQ8IKTSpVV7DEXbo6OE2N
qjF5PQgSno0eEsrQi12y6il9RDhjLu+cvlSFGaNIcQDlstOCxOPvQ7cFRHS56nsD0RSTCVU/MIqt
T0kFo6R3ar5w+6qa/ToLFCs+jnZI0+C+2WfmBtiV7GDt1uBv6VMMgKkZuZHkzHbR46Jq3vDmqpZi
XTBcB7loQMQ8tjqcdFFjZRYamWIGvEPKleC+pkf+YxcDNdW/pTbMjfzpgHp/ePR3nP1tU1QdNcH/
oGbD4Jpr0GW5Bce0Q+3lZOUm3QW2DXYexy/2wD/2jw+5OCbUBCQ=
--000000000000dc05930634f4be78--
