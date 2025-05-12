Received: from mail-ua1-f49.google.com (mail-ua1-f49.google.com [209.85.222.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B121254863
	for <linux-crypto@vger.kernel.org>; Mon, 12 May 2025 18:38:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747075088; cv=none; b=j+TVD/j1OTH8AwQN/mN9+C93VIui6UQU3gN6ZLvBeGjmiGHMJ85vQnEpzsa9E5IvgLboUvJjWHT27GE3QYKy+b7brKuRemY81RMQJkgNkuZ2EoHMhc5nl1rvUctG+sNftcz4RKla4X0TwCfLXoVUgQcFb2vTGRaANr89wyCoxPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747075088; c=relaxed/simple;
	bh=k7Q4o2N6Q2g6B9kYg8rDBbJH3IWbVHWT7D82n0lZFbE=;
	h=From:References:In-Reply-To:MIME-Version:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LNFLaIBKTgm44OEgVd3zzLu8B2KKo4uNRFU+ROM7hDDvPDC9lNPFwF95X1iYQhf1aTpf6w0rOsN9ujwK6LJuj7qJo2mXcbxl2Mdmss68HDzO65rkriuVKiZ1LZDF3+g2nct0WFztSrCKBYuuXONbj/8C+AfcJnn8Jfvu7Beb3jA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=AFPeIp1a; arc=none smtp.client-ip=209.85.222.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="AFPeIp1a"
Received: by mail-ua1-f49.google.com with SMTP id a1e0cc1a2514c-879e8e2237dso2594493241.0
        for <linux-crypto@vger.kernel.org>; Mon, 12 May 2025 11:38:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1747075085; x=1747679885; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:thread-index:mime-version:in-reply-to
         :references:from:from:to:cc:subject:date:message-id:reply-to;
        bh=5LDMHDpSDfser3c+gh0bbNNLirO+DF6A+J/e1p+nc7Q=;
        b=AFPeIp1aM1bUhTBLDisaX0+KwhwGPXWavKHDkA42nQzGmyFG4drF2U4ufgFBvHZn31
         /NDt+C6k0NJWkBgeB4CI/4BtFxWAaLEJAJ98VFQ4ckGfo4sfGv3B1LrE3FQpGOiT/WzO
         sw9CfW8jCl6DTnRHgBQtsw3/2xw12mqyzHmrw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747075085; x=1747679885;
        h=cc:to:subject:message-id:date:thread-index:mime-version:in-reply-to
         :references:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5LDMHDpSDfser3c+gh0bbNNLirO+DF6A+J/e1p+nc7Q=;
        b=Dj0LY6nXJ57X8ooHxqPCB7TrvEpTdWCCPhbLwRNA/FoolmziNwZQPTSve0qtHUoG31
         EqmeLEbar7MXLT197k3wDpUZDd26WLOKIdlh5/CCPF9LuDUs/X2d0zRDuNpr/vYhTrDo
         Ng+VNsDAT9YBUXWGZVixdQ8J9SYjNtXPsqPKsvm4us44QkO4fqFTnQt0gVyC4MTYGTg1
         4FTGDZtc89NfS4P8JRdbusTetCPg+l31jnCtewh/jX5Ju5BpB+6tW/EH/Y7AUA4i8MuA
         plJmiouu+f/4zukX8YSWTcBrPizuD4V81GwgVffUoKSNgULepwGHZiNF7s7DLUCEgtwB
         5y6g==
X-Forwarded-Encrypted: i=1; AJvYcCWdZygpdxYSoLK5jjZANNni2q+1vSXHfaRNy2VTabcLPP+suvrh2mHHEajLDoRGJm5sOBMlethX7bZ85UU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxi8VLIldSHFxWCgLx7z9xpEOQrD0CIhCZx3GLgZlNLaop7ieFi
	vzJUbZmB9e9JFKP5xsPPH+JTUzuhFe0ZE2Q3vIQGbQujBet2f32mncz0D/xAFTvMIs+s5mvq7n0
	s8AeetUpw1ICMIgbdK+KvaYvp4FTMouAxv2kc
X-Gm-Gg: ASbGncsx9aJl796w5ssIZ8HHO+ls1BwE2N9lz+8Ui74AoVkjfmbf5xlcijH40uUsIeu
	H6IcHLCQv1+atQHyycp6mxTEaMYLFeVIGDx4OZ4kDUcFs/pTO1GiQZntobPQ+w0HzGHCf2t8QTZ
	WKH/XT7B99PqgzU1i8+Wdxm7L550jJZD3wQA==
X-Google-Smtp-Source: AGHT+IF0l1XIFMiD5ruF2lSZ6uORA5ReBa6AdYiYCzvB9lxFvGsKkN6xIL+Xowz9Eex9vOkIgAlD/ZLyLXPY5hoGEjc=
X-Received: by 2002:a67:e7cc:0:b0:4c1:83c4:8562 with SMTP id
 ada2fe7eead31-4deed36db85mr11825119137.13.1747075085444; Mon, 12 May 2025
 11:38:05 -0700 (PDT)
From: William Zhang <william.zhang@broadcom.com>
References: <20250512-bcmbca-peripherals-arm-v3-0-86f97ab4326f@linaro.org> <20250512-bcmbca-peripherals-arm-v3-6-86f97ab4326f@linaro.org>
In-Reply-To: <20250512-bcmbca-peripherals-arm-v3-6-86f97ab4326f@linaro.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQHRV/QBxSS57P/922lUlscQxKMBIAHxw9EDs9Sb9PA=
Date: Mon, 12 May 2025 11:38:07 -0700
X-Gm-Features: AX0GCFvFTIMl4G9YOO5NI5m-hLIsTGeRv-4WDwppcl2QI9TcvcE0DSCJ6QAO5YI
Message-ID: <706a72182e4d34a5c2523c7ef1bbb80e@mail.gmail.com>
Subject: RE: [PATCH v3 06/12] ARM: dts: bcm63138: Add BCMBCA peripherals
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
	boundary="000000000000e1cef80634f49dc7"

--000000000000e1cef80634f49dc7
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
> Subject: [PATCH v3 06/12] ARM: dts: bcm63138: Add BCMBCA peripherals
>
> All the BCMBCA SoCs share a set of peripherals at 0xff800000,
> albeit at slightly varying memory locations on the bus and
> with varying IRQ assignments.
>
> Extend the peripheral interrupt window to 0x10000 as it need
> to fit the DMA block.
>
> Add the GPIO, RNG and LED and DMA blocks for the
> BCM63138 based on the vendor files 63138_map_part.h and
> 63138_intr.h from the "bcmopen-consumer" code drop.
>
> This SoC has up to 160 possible GPIOs due to having 5
> registers with 32 GPIOs in each available.
>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>  arch/arm/boot/dts/broadcom/bcm63138.dtsi | 79
> +++++++++++++++++++++++++++++++-
>  1 file changed, 78 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm/boot/dts/broadcom/bcm63138.dtsi
> b/arch/arm/boot/dts/broadcom/bcm63138.dtsi
> index
> e74ba6bf370da63d3c115e38b4f20c71baff2116..4ec568586b14c89daceddea8f1
> 7381f72f512a93 100644
> --- a/arch/arm/boot/dts/broadcom/bcm63138.dtsi
> +++ b/arch/arm/boot/dts/broadcom/bcm63138.dtsi
> @@ -184,13 +184,69 @@ ubus@fffe8000 {
>  		compatible =3D "simple-bus";
>  		#address-cells =3D <1>;
>  		#size-cells =3D <1>;
> -		ranges =3D <0 0xfffe8000 0x8100>;
> +		ranges =3D <0 0xfffe8000 0x10000>;
>
>  		timer: timer@80 {
>  			compatible =3D "brcm,bcm6328-timer", "syscon";
>  			reg =3D <0x80 0x3c>;
>  		};
>
> +		/* GPIOs 0 .. 31 */
> +		gpio0: gpio@100 {
> +			compatible =3D "brcm,bcm6345-gpio";
> +			reg =3D <0x100 0x04>, <0x114 0x04>;
> +			reg-names =3D "dirout", "dat";
> +			gpio-controller;
> +			#gpio-cells =3D <2>;
> +			status =3D "disabled";
> +		};
> +
> +		/* GPIOs 32 .. 63 */
> +		gpio1: gpio@104 {
> +			compatible =3D "brcm,bcm6345-gpio";
> +			reg =3D <0x104 0x04>, <0x118 0x04>;
> +			reg-names =3D "dirout", "dat";
> +			gpio-controller;
> +			#gpio-cells =3D <2>;
> +			status =3D "disabled";
> +		};
> +
> +		/* GPIOs 64 .. 95 */
> +		gpio2: gpio@108 {
> +			compatible =3D "brcm,bcm6345-gpio";
> +			reg =3D <0x108 0x04>, <0x11c 0x04>;
> +			reg-names =3D "dirout", "dat";
> +			gpio-controller;
> +			#gpio-cells =3D <2>;
> +			status =3D "disabled";
> +		};
> +
> +		/* GPIOs 96 .. 127 */
> +		gpio3: gpio@10c {
> +			compatible =3D "brcm,bcm6345-gpio";
> +			reg =3D <0x10c 0x04>, <0x120 0x04>;
> +			reg-names =3D "dirout", "dat";
> +			gpio-controller;
> +			#gpio-cells =3D <2>;
> +			status =3D "disabled";
> +		};
> +
> +		/* GPIOs 128 .. 159 */
> +		gpio4: gpio@110 {
> +			compatible =3D "brcm,bcm6345-gpio";
> +			reg =3D <0x110 0x04>, <0x124 0x04>;
> +			reg-names =3D "dirout", "dat";
> +			gpio-controller;
> +			#gpio-cells =3D <2>;
> +			status =3D "disabled";
> +		};
> +
> +		rng@300 {
> +			compatible =3D "brcm,iproc-rng200";
> +			reg =3D <0x300 0x28>;
> +			interrupts =3D <GIC_SPI 85 IRQ_TYPE_LEVEL_HIGH>;
> +		};
> +
>  		serial0: serial@600 {
>  			compatible =3D "brcm,bcm6345-uart";
>  			reg =3D <0x600 0x1b>;
> @@ -209,6 +265,14 @@ serial1: serial@620 {
>  			status =3D "disabled";
>  		};
>
> +		leds: led-controller@700 {
> +			#address-cells =3D <1>;
> +			#size-cells =3D <0>;
> +			compatible =3D "brcm,bcm63138-leds";
> +			reg =3D <0x700 0xdc>;
> +			status =3D "disabled";
> +		};
> +
>  		hsspi: spi@1000 {
>  			#address-cells =3D <1>;
>  			#size-cells =3D <0>;
> @@ -248,6 +312,19 @@ bootlut: bootlut@8000 {
>  			reg =3D <0x8000 0x50>;
>  		};
>
> +		pl081_dma: dma-controller@d000 {
> +			compatible =3D "arm,pl081", "arm,primecell";
> +			// The magic B105F00D info is missing
> +			arm,primecell-periphid =3D <0x00041081>;
> +			reg =3D <0xd000 0x1000>;
> +			interrupts =3D <GIC_SPI 23 IRQ_TYPE_LEVEL_HIGH>;
> +			memcpy-burst-size =3D <256>;
> +			memcpy-bus-width =3D <32>;
> +			clocks =3D <&periph_clk>;
> +			clock-names =3D "apb_pclk";
> +			#dma-cells =3D <2>;
> +		};
> +
>  		reboot {
>  			compatible =3D "syscon-reboot";
>  			regmap =3D <&timer>;
>
> --
> 2.49.0

Reviewed-by: William Zhang <william.zhang@broadcom.com>

--000000000000e1cef80634f49dc7
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
JOEwDQYJYIZIAWUDBAIBBQCggccwLwYJKoZIhvcNAQkEMSIEIH6fhHOST5BvqEcvFJo+Lga+fAiC
L1/BWzeYLwusqZrWMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTI1
MDUxMjE4MzgwNVowXAYJKoZIhvcNAQkPMU8wTTALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsG
CWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQcwCwYJYIZIAWUDBAIBMA0GCSqGSIb3
DQEBAQUABIIBABWVCJUe+7uL7sXs16KD0W3uSex/85Nqp96BYUMgsvThoaD1ghTB1jsqAhkOfshO
oElNTCHp6GO9t09sKap7ud1tpa6qB/9IV0qoovjd3/v8pNuB8Y0i6AugFeB5jpnoDZXIviMplHOb
h9eV5RwnaPQOPfNdZtjj18FILB2XWnhZxpIAgdNx1o1dQ13/Nozp0o6SdTZs4FLRD9Qj+m+o1qSt
kc7bjuH6pMuUe973szjtjQu7vtXeIJw8CZPRTpx5CTchMB0HbSBVFUK45qD6ZrMw8i0tKgyPFxiz
cYvSf4wnzdxA4tOgPmtQfdRxkeKazaiyw5Mfb1n0bKZfZivO/IM=
--000000000000e1cef80634f49dc7--
