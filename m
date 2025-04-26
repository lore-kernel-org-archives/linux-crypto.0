Received: from mail-ua1-f49.google.com (mail-ua1-f49.google.com [209.85.222.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B881B2AF1B
	for <linux-crypto@vger.kernel.org>; Sat, 26 Apr 2025 01:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745630548; cv=none; b=HMMZ2cClwyLJ7jWeoQcVLuQtMDv6HKC7kQJrUHF3V2VRgXnEv7ebUkS1GEoslgIYFHyC8yx0NY8BfNdnG966F0w5SefKrgH8NJnX26dMNb/zgNFfu29rF/sFALkiWUmqaRLq/Y2Je2TODpG3t6pjFhXBV0Slol3XSlguEoaKSW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745630548; c=relaxed/simple;
	bh=dqIqw82RZkABBJ5+VSauY1sA7YnkS90gWAmPo9Hf/NY=;
	h=From:References:In-Reply-To:MIME-Version:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ozPNo5LlRvLC6VFsDgITSZVNGY2FIxx2K1ZmvknhKX6c8v2I0qmZNTDppKEU3RudxaAphps8sfr8G+k3cVgREM4hDlP0mQ36ODk8JXQsKyfrzSLOoj8/O4s95hIOvH62dYA9s7vJkuVRKvSoiC3TbXq51t/R9vIBmH0h9381Obc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=hzV6MIbH; arc=none smtp.client-ip=209.85.222.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="hzV6MIbH"
Received: by mail-ua1-f49.google.com with SMTP id a1e0cc1a2514c-86d6ac4d5a9so1263781241.1
        for <linux-crypto@vger.kernel.org>; Fri, 25 Apr 2025 18:22:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1745630545; x=1746235345; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:thread-index:mime-version:in-reply-to
         :references:from:from:to:cc:subject:date:message-id:reply-to;
        bh=NOhB0ILZToOySniDU9LZhNwisxea7bzoW89QkBKRCdI=;
        b=hzV6MIbHt/LdwyM8ztDQzyIj7LOOxV/x48AxY9zyDoMiF1DzymmhKYQP5Ofmo1+JkO
         FWA98nGa9Mu6od10uvYLUheoje+i9zx0vv1x4Cz1NOpdsgg26T6xe+YC49OtT9o06Hfn
         LEO2fgbAAWuh1UvajCp9unOvEfRE2ajvJRWyg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745630545; x=1746235345;
        h=cc:to:subject:message-id:date:thread-index:mime-version:in-reply-to
         :references:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NOhB0ILZToOySniDU9LZhNwisxea7bzoW89QkBKRCdI=;
        b=jAiMX1cr5d+EAdT4+bXagPVy8rGad4M12OVcacSxSAFLoTfpGGXPnTlGcCGLlUwmyh
         LxIAk7zsBXPlp7IjzcllI+uxVu7spm/CHD1Gg19jcwkCSgZEHpK8ug+wfkDcWcSbx2Kr
         T++mwGbf831dKmjM6Ec06NpluYxIa4RMqGAkFGHFdxp3x2wrfUYqM8hUgb5DdykEapr/
         xQ9MCYoLIy9Z3O6ZsSM1++jJyieCHdms/EjuE82xMwCJ1lhp0oCZ/hw7U1sSXIHlGybK
         rGTpFiMT38vA0CvgewMF5Uy0NzESWomFcsRt3ORYEXeifdFNBLGo0jvwumef6ar9AasK
         zqPQ==
X-Forwarded-Encrypted: i=1; AJvYcCXQnv2U1cyiwRdGOdcPC5SxJUrmop06DP8mzEREDCmeTZuVOy2mmU7uRTm/F/Oql9HaHl6y710sUE9Fyq8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwX4qOQrAl/nek1EoxYbataQEemfLL6q7Ahq5qIl1iVldzoOVcc
	vQhkRTLj9b4RcHYhAwKf9v5xYFQRJMjMfr4qx7p2/SGNKQfGYhaPAg14N/i4/ubP3Uv9FRxXjEc
	fr4ZMP0OWuEOmmmljhfRkIpFB2pOVwDZXPK+d
X-Gm-Gg: ASbGncvrdEg1hSwROT35McNIQEAotGNGcuraUnCuEwml3rYTPmkjCDg1IuW+Wh0a37+
	gKroJJ3JaNDEoy14HGBBmadcEgx0wsBOOl81OY8J4p4+jNTXDT0ct1bBh9jRxt2RoFs4t5ZvxJi
	+FcxuqQBpmjA9Gl3VYO6/Lvr0=
X-Google-Smtp-Source: AGHT+IEZBG83EfNrSuomd8AKku3d7/HdzYrZ4sPeWM6YecfNjsbPXzQ7/tdM41hX86k8sAwLA6IEr1wUZG4QDluHVsY=
X-Received: by 2002:a05:6122:1d4d:b0:518:6286:87a4 with SMTP id
 71dfb90a1353d-52a89d94031mr3765175e0c.4.1745630545538; Fri, 25 Apr 2025
 18:22:25 -0700 (PDT)
From: William Zhang <william.zhang@broadcom.com>
References: <20250406-bcmbca-peripherals-arm-v2-0-22130836c2ed@linaro.org> <20250406-bcmbca-peripherals-arm-v2-12-22130836c2ed@linaro.org>
In-Reply-To: <20250406-bcmbca-peripherals-arm-v2-12-22130836c2ed@linaro.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQKk0Iba5S5vFfMGFNn0Sizjy9mbxwF/riLushbzqrA=
Date: Fri, 25 Apr 2025 18:22:23 -0700
X-Gm-Features: ATxdqUEEy_t-pUNNkiz8KCllbxnH65fJq-B4ty0HNHHtf0wz-8QRveGqWyjVE7A
Message-ID: <ac71a22772cb678f2c6fce4b01172f4b@mail.gmail.com>
Subject: RE: [PATCH v2 12/12] ARM64: dts: bcm63158: Add BCMBCA peripherals
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
	boundary="00000000000098905f0633a448f8"

--00000000000098905f0633a448f8
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> -----Original Message-----
> From: Linus Walleij <linus.walleij@linaro.org>
> Sent: Sunday, April 6, 2025 8:33 AM
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
> Subject: [PATCH v2 12/12] ARM64: dts: bcm63158: Add BCMBCA peripherals
>
> All the BCMBCA SoCs share a set of peripherals at 0xff800000,
> albeit at slightly varying memory locations on the bus and
> with varying IRQ assignments. On BCM63158 the PERF window was
> too big so adjust it down to its real size (0x3000).
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
> at 0xff810000 where the DMA resides, so we create new windows
> for these two peripheral group reflecting the internal
> structure of the B0 SoC.
>
> This SoC has up to 256 possible GPIOs due to having 8
> registers with 32 GPIOs in each available.
>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>  arch/arm64/boot/dts/broadcom/bcmbca/bcm63158.dtsi | 150
> +++++++++++++++++++++-
>  1 file changed, 147 insertions(+), 3 deletions(-)
>
> diff --git a/arch/arm64/boot/dts/broadcom/bcmbca/bcm63158.dtsi
> b/arch/arm64/boot/dts/broadcom/bcmbca/bcm63158.dtsi
> index
> 48d618e75866452a64adfdc781ac0ea3c2eff3e8..a47c5d6d034a7ae56803a6516
> 36148383acb8cc9 100644
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
> @@ -119,11 +120,107 @@ gic: interrupt-controller@1000 {
>  		};
>  	};
>
> +	/* PERF Peripherals */
>  	bus@ff800000 {
>  		compatible =3D "simple-bus";
>  		#address-cells =3D <1>;
>  		#size-cells =3D <1>;
> -		ranges =3D <0x0 0x0 0xff800000 0x800000>;
> +		ranges =3D <0x0 0x0 0xff800000 0x3000>;
> +
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
>
>  		hsspi: spi@1000 {
>  			#address-cells =3D <1>;
> @@ -150,14 +247,61 @@ nandcs: nand@0 {
>  				reg =3D <0>;
>  			};
>  		};
> +	};
> +
> +	/* B0 AHB Peripherals */
While this is AHB IP block but it is under the same periph bus.   I suggest
to
move it back to bus@ff800000  node

> +	bus@ff810000 {
> +		compatible =3D "simple-bus";
> +		#address-cells =3D <1>;
> +		#size-cells =3D <1>;
> +		ranges =3D <0x0 0x0 0xff810000 0x2000>;
> +
> +		pl081_dma: dma-controller@1000 {
> +			compatible =3D "arm,pl081", "arm,primecell";
> +			// The magic B105F00D info is missing
> +			arm,primecell-periphid =3D <0x00041081>;
> +			reg =3D <0x1000 0x1000>;
> +			interrupts =3D <GIC_SPI 94 IRQ_TYPE_LEVEL_HIGH>;
> +			memcpy-burst-size =3D <256>;
> +			memcpy-bus-width =3D <32>;
> +			clocks =3D <&periph_clk>;
> +			clock-names =3D "apb_pclk";
> +			#dma-cells =3D <2>;
> +		};
> +	};
> +
> +	/* B0 ARM UART Peripheral block */
Same here.

> +	bus@ff812000 {
> +		compatible =3D "simple-bus";
> +		#address-cells =3D <1>;
> +		#size-cells =3D <1>;
> +		ranges =3D <0x0 0x0 0xff812000 0x3000>;
>
> -		uart0: serial@12000 {
> +		uart0: serial@0 {
>  			compatible =3D "arm,pl011", "arm,primecell";
> -			reg =3D <0x12000 0x1000>;
> +			reg =3D <0x0 0x1000>;
>  			interrupts =3D <GIC_SPI 32 IRQ_TYPE_LEVEL_HIGH>;
>  			clocks =3D <&uart_clk>, <&uart_clk>;
>  			clock-names =3D "uartclk", "apb_pclk";
>  			status =3D "disabled";
>  		};
> +
> +		uart1: serial@1000 {
> +			compatible =3D "arm,pl011", "arm,primecell";
> +			reg =3D <0x1000 0x1000>;
> +			interrupts =3D <GIC_SPI 33 IRQ_TYPE_LEVEL_HIGH>;
> +			clocks =3D <&uart_clk>, <&uart_clk>;
> +			clock-names =3D "uartclk", "apb_pclk";
> +			status =3D "disabled";
> +		};
> +
> +		uart2: serial@2000 {
> +			compatible =3D "arm,pl011", "arm,primecell";
> +			reg =3D <0x2000 0x1000>;
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

--00000000000098905f0633a448f8
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIIQYwYJKoZIhvcNAQcCoIIQVDCCEFACAQExDzANBglghkgBZQMEAgEFADALBgkqhkiG9w0BBwGg
gg3HMIIFDTCCA/WgAwIBAgIQeEqpED+lv77edQixNJMdADANBgkqhkiG9w0BAQsFADBMMSAwHgYD
VQQLExdHbG9iYWxTaWduIFJvb3QgQ0EgLSBSMzETMBEGA1UEChMKR2xvYmFsU2lnbjETMBEGA1UE
AxMKR2xvYmFsU2lnbjAeFw0yMDA5MTYwMDAwMDBaFw0yODA5MTYwMDAwMDBaMFsxCzAJBgNVBAYT
AkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQDEyhHbG9iYWxTaWduIEdDQyBS
MyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA
vbCmXCcsbZ/a0fRIQMBxp4gJnnyeneFYpEtNydrZZ+GeKSMdHiDgXD1UnRSIudKo+moQ6YlCOu4t
rVWO/EiXfYnK7zeop26ry1RpKtogB7/O115zultAz64ydQYLe+a1e/czkALg3sgTcOOcFZTXk38e
aqsXsipoX1vsNurqPtnC27TWsA7pk4uKXscFjkeUE8JZu9BDKaswZygxBOPBQBwrA5+20Wxlk6k1
e6EKaaNaNZUy30q3ArEf30ZDpXyfCtiXnupjSK8WU2cK4qsEtj09JS4+mhi0CTCrCnXAzum3tgcH
cHRg0prcSzzEUDQWoFxyuqwiwhHu3sPQNmFOMwIDAQABo4IB2jCCAdYwDgYDVR0PAQH/BAQDAgGG
MGAGA1UdJQRZMFcGCCsGAQUFBwMCBggrBgEFBQcDBAYKKwYBBAGCNxQCAgYKKwYBBAGCNwoDBAYJ
KwYBBAGCNxUGBgorBgEEAYI3CgMMBggrBgEFBQcDBwYIKwYBBQUHAxEwEgYDVR0TAQH/BAgwBgEB
/wIBADAdBgNVHQ4EFgQUljPR5lgXWzR1ioFWZNW+SN6hj88wHwYDVR0jBBgwFoAUj/BLf6guRSSu
TVD6Y5qL3uLdG7wwegYIKwYBBQUHAQEEbjBsMC0GCCsGAQUFBzABhiFodHRwOi8vb2NzcC5nbG9i
YWxzaWduLmNvbS9yb290cjMwOwYIKwYBBQUHMAKGL2h0dHA6Ly9zZWN1cmUuZ2xvYmFsc2lnbi5j
b20vY2FjZXJ0L3Jvb3QtcjMuY3J0MDYGA1UdHwQvMC0wK6ApoCeGJWh0dHA6Ly9jcmwuZ2xvYmFs
c2lnbi5jb20vcm9vdC1yMy5jcmwwWgYDVR0gBFMwUTALBgkrBgEEAaAyASgwQgYKKwYBBAGgMgEo
CjA0MDIGCCsGAQUFBwIBFiZodHRwczovL3d3dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzAN
BgkqhkiG9w0BAQsFAAOCAQEAdAXk/XCnDeAOd9nNEUvWPxblOQ/5o/q6OIeTYvoEvUUi2qHUOtbf
jBGdTptFsXXe4RgjVF9b6DuizgYfy+cILmvi5hfk3Iq8MAZsgtW+A/otQsJvK2wRatLE61RbzkX8
9/OXEZ1zT7t/q2RiJqzpvV8NChxIj+P7WTtepPm9AIj0Keue+gS2qvzAZAY34ZZeRHgA7g5O4TPJ
/oTd+4rgiU++wLDlcZYd/slFkaT3xg4qWDepEMjT4T1qFOQIL+ijUArYS4owpPg9NISTKa1qqKWJ
jFoyms0d0GwOniIIbBvhI2MJ7BSY9MYtWVT5jJO3tsVHwj4cp92CSFuGwunFMzCCA18wggJHoAMC
AQICCwQAAAAAASFYUwiiMA0GCSqGSIb3DQEBCwUAMEwxIDAeBgNVBAsTF0dsb2JhbFNpZ24gUm9v
dCBDQSAtIFIzMRMwEQYDVQQKEwpHbG9iYWxTaWduMRMwEQYDVQQDEwpHbG9iYWxTaWduMB4XDTA5
MDMxODEwMDAwMFoXDTI5MDMxODEwMDAwMFowTDEgMB4GA1UECxMXR2xvYmFsU2lnbiBSb290IENB
IC0gUjMxEzARBgNVBAoTCkdsb2JhbFNpZ24xEzARBgNVBAMTCkdsb2JhbFNpZ24wggEiMA0GCSqG
SIb3DQEBAQUAA4IBDwAwggEKAoIBAQDMJXaQeQZ4Ihb1wIO2hMoonv0FdhHFrYhy/EYCQ8eyip0E
XyTLLkvhYIJG4VKrDIFHcGzdZNHr9SyjD4I9DCuul9e2FIYQebs7E4B3jAjhSdJqYi8fXvqWaN+J
J5U4nwbXPsnLJlkNc96wyOkmDoMVxu9bi9IEYMpJpij2aTv2y8gokeWdimFXN6x0FNx04Druci8u
nPvQu7/1PQDhBjPogiuuU6Y6FnOM3UEOIDrAtKeh6bJPkC4yYOlXy7kEkmho5TgmYHWyn3f/kRTv
riBJ/K1AFUjRAjFhGV64l++td7dkmnq/X8ET75ti+w1s4FRpFqkD2m7pg5NxdsZphYIXAgMBAAGj
QjBAMA4GA1UdDwEB/wQEAwIBBjAPBgNVHRMBAf8EBTADAQH/MB0GA1UdDgQWBBSP8Et/qC5FJK5N
UPpjmove4t0bvDANBgkqhkiG9w0BAQsFAAOCAQEAS0DbwFCq/sgM7/eWVEVJu5YACUGssxOGhigH
M8pr5nS5ugAtrqQK0/Xx8Q+Kv3NnSoPHRHt44K9ubG8DKY4zOUXDjuS5V2yq/BKW7FPGLeQkbLmU
Y/vcU2hnVj6DuM81IcPJaP7O2sJTqsyQiunwXUaMld16WCgaLx3ezQA3QY/tRG3XUyiXfvNnBB4V
14qWtNPeTCekTBtzc3b0F5nCH3oO4y0IrQocLP88q1UOD5F+NuvDV0m+4S4tfGCLw0FREyOdzvcy
a5QBqJnnLDMfOjsl0oZAzjsshnjJYS8Uuu7bVW/fhO4FCU29KNhyztNiUGUe65KXgzHZs7XKR1g/
XzCCBU8wggQ3oAMCAQICDDG6HZcbcVdEvVYk4TANBgkqhkiG9w0BAQsFADBbMQswCQYDVQQGEwJC
RTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTExMC8GA1UEAxMoR2xvYmFsU2lnbiBHQ0MgUjMg
UGVyc29uYWxTaWduIDIgQ0EgMjAyMDAeFw0yMjA5MTAxMTMxNDVaFw0yNTA5MTAxMTMxNDVaMIGQ
MQswCQYDVQQGEwJJTjESMBAGA1UECBMJS2FybmF0YWthMRIwEAYDVQQHEwlCYW5nYWxvcmUxFjAU
BgNVBAoTDUJyb2FkY29tIEluYy4xFjAUBgNVBAMTDVdpbGxpYW0gWmhhbmcxKTAnBgkqhkiG9w0B
CQEWGndpbGxpYW0uemhhbmdAYnJvYWRjb20uY29tMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIB
CgKCAQEAyKF+RmY29Wvfmfe3L8J4rZNmBIvRmrWKI5td5L0vlpPMCEzUkVhBdL2N9cDP0rPScvWL
CX/9cI1a2BUy/6/ZT5j9PhcUn6A3kwKFGukLY2itfKaDrP3ANVJGhBXPVJ6sx55GF41PkiL2EMnY
7LJGNpl9WHYrw8VqtRediPyXq8M6ZWGPZWxygsE6y1pOkEk9qLpvXTb2Epxk2JWcQFZQCDWVULue
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
JOEwDQYJYIZIAWUDBAIBBQCggccwLwYJKoZIhvcNAQkEMSIEIA3ZA1UTM1kfCMI6eSzhBwjQy3qj
L6/w4ZJgIq2OOdXNMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTI1
MDQyNjAxMjIyNVowXAYJKoZIhvcNAQkPMU8wTTALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsG
CWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQcwCwYJYIZIAWUDBAIBMA0GCSqGSIb3
DQEBAQUABIIBAFQPDuLHkHIoMcOv8y+/KRZLcf5ucRDk4OwMcVC2GHTOw5Evq9xye6pTZmEfFsOw
kdmavPpaHZkl0bc+60/xf1Fjo16VoBNQJ4a1vqkQHqnOaWoDVQSSUs21o7/hzaVYS+uskC2G9umN
/JDZgRxjILYAQUCP9LVLZ2LACBYuuOLH2oLjh8I/OscYEujc+C6gRbDQoL+eHrmp2NbXJVqSzoEw
iXH6SganEM7PVsgj50h/6lGj9cHHR/xLxt4x9Uj4AKhV/b0iYXYsnvVqz8kWKfDbaFxIcFl9Ri33
jvokKfSEEy78Ivb1BUX0EVq4uMXFHlHKBdJiG8aXRDlH0ErawBo=
--00000000000098905f0633a448f8--
