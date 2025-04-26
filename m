Received: from mail-vk1-f180.google.com (mail-vk1-f180.google.com [209.85.221.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B74A31DF733
	for <linux-crypto@vger.kernel.org>; Sat, 26 Apr 2025 01:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745630011; cv=none; b=PtHBr124DU13CxiNTneK+ZzxMinxxXQy2FLYOg3lVZZGnkS2/u68sOfx2epixjVuyxb8UrvqkCwvdTJ53i4QS3/uR8pFe4ir2cZl18TfClTVUaxWOx8S7v2STdcWlm0LLxg9KMypD+4saTOwSNZK5nuolLkV84jhkioNRv+fr1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745630011; c=relaxed/simple;
	bh=LxNb+dcBX8HjhN7G3qjFK6yRtn18uFN+xMtiKtcjl+U=;
	h=From:References:In-Reply-To:MIME-Version:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eLd3DG6+roRQDFullaQqljkX/3BWzCIq+ooVV1VTMnGQS8iUItnx7RhqsRzKWMlN0xuWlzluzTyb3QZzE6lCh4SIAgaoTKU5gTQUzKRcNsT9uaHEUT/lt430BT5e71AHE0dvuvkWQz+Vw34Txh5eLO76UTBUoB5BZHUrjwCVC9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=gEfftUFy; arc=none smtp.client-ip=209.85.221.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="gEfftUFy"
Received: by mail-vk1-f180.google.com with SMTP id 71dfb90a1353d-5242f137a1eso1109665e0c.1
        for <linux-crypto@vger.kernel.org>; Fri, 25 Apr 2025 18:13:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1745630008; x=1746234808; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:thread-index:mime-version:in-reply-to
         :references:from:from:to:cc:subject:date:message-id:reply-to;
        bh=uVSg2H6GLeF8sGT8O+fk6CiJBnwM9wWC5Jrozd8Npj0=;
        b=gEfftUFyp0HQFoDVTV+aiCOCGr132wEw/L7WS87NCsyERzdx+ARGfKZ6uTYYiE5+0q
         gl1qHTF8Wl08pqcbN6Tz6iFHHOmY85mNWrLrJnIu4LjNbdTtsh5/88gr/u0MUSMAA6Ij
         bu7rYQOaEFpuXBnkSSI71BZjuMQ6EXwl/YaeQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745630008; x=1746234808;
        h=cc:to:subject:message-id:date:thread-index:mime-version:in-reply-to
         :references:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uVSg2H6GLeF8sGT8O+fk6CiJBnwM9wWC5Jrozd8Npj0=;
        b=rIXOKKhumXrpZq9U2jEfK9MlZN4Rl6kZEjUNivDnShPGJJdhgkAADW+9uGhBCgow8l
         2LxSALW3k8TERhrCFp5Oc7tHcVWJLc/LLvY4jDuFAKpVuux0HVte8hffBGxoyUyaCSkW
         0bNykK9plgWSA3CjTw9wSFvRNMvxWFtA1mg6pXintuqw9xalOT0WXuYqARTBLOYdipmB
         LDCe1dDAsZz2NCE805Vz6CgZpG3aS46UX00SHtNolKVJ/QXAnUq2tOp3naDEqIWutY3w
         9PTzaIQdqB8V56wfeZKAGgOr9k5UH29RDNC+NuOnPGJIbVYVkcSlKbWK+m96laY0oUuU
         53QA==
X-Forwarded-Encrypted: i=1; AJvYcCUeC7nMX/aSnxKYW715iOjeJo8dzn143wuOSVgKjhed3uRovHhtpld5OtimCGw8C0cl+EGz4j9F+eMvYeI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxsB+gjFeBoJjduK6IBMvSz1zuV0Pcx76H0YZN9V5CoLgaQaeCO
	DNvjJsj0gL161O+wzEb8nlK6s7cLhuu28B8i19WsqHT+lqX3OVFcIgOeofRTAazKWxb6WBuC3T3
	NY/ajj8tGr3ZpJrlRBEbxh85oZf52ISQHjMTK
X-Gm-Gg: ASbGnctUGLqMl8GmXjQVFxGhO74WrAJw7I3n7YfjsOPYO21RQDMyL9FIZCqRmBrTPYt
	n3F2TsCC1LvRKDXJHy7WhRV0DUL1q4oD1O65O00RvBfDV12DWUjs1ySR27k2p9PwrarSJ6fK9Qp
	myOaH3X/bvDdwSNwHnw/bXKksOAZo7KdlDLA==
X-Google-Smtp-Source: AGHT+IGDZ9/Feuo8TT79yyf/erpihB9wYIENSdaLEF3c7ll4Nfsef2mCZ8pCsTAr4iQCA3R7DK0CEnmllMp/ho77BrU=
X-Received: by 2002:a05:6122:6594:b0:528:bd71:8a8e with SMTP id
 71dfb90a1353d-52a9702836fmr1276952e0c.5.1745630008563; Fri, 25 Apr 2025
 18:13:28 -0700 (PDT)
From: William Zhang <william.zhang@broadcom.com>
References: <20250406-bcmbca-peripherals-arm-v2-0-22130836c2ed@linaro.org> <20250406-bcmbca-peripherals-arm-v2-10-22130836c2ed@linaro.org>
In-Reply-To: <20250406-bcmbca-peripherals-arm-v2-10-22130836c2ed@linaro.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQKk0Iba5S5vFfMGFNn0Sizjy9mbxwGNeTBIshaDuYA=
Date: Fri, 25 Apr 2025 18:13:26 -0700
X-Gm-Features: ATxdqUEF7QswsDYWIT62tPu1PtoOui55cYiegvw85UKL9KXHn190j7XDU4dnIqE
Message-ID: <62fd647b4c1ba40747b164da49288216@mail.gmail.com>
Subject: RE: [PATCH v2 10/12] ARM64: dts: bcm6856: Add BCMBCA peripherals
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
	boundary="00000000000096bd3c0633a42871"

--00000000000096bd3c0633a42871
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
> Subject: [PATCH v2 10/12] ARM64: dts: bcm6856: Add BCMBCA peripherals
>
> All the BCMBCA SoCs share a set of peripherals at 0xff800000,
> albeit at slightly varying memory locations on the bus and
> with varying IRQ assignments. ARM64 SoCs have additional
> peripherals at 0xff858000. On BCM6856 the PERF window was
> too big so adjust it down to its real size (0x3000) and add
> another window for PERF1 at 0xff858000.
>
> Add the watchdog, GPIO blocks, RNG, LED, second UART and DMA
> blocks for the BCM6856 based on the vendor files 6856_map_part.h
> and 6856_intr.h from the "bcmopen-consumer" code drop.
>
> This SoC has up to 256 possible GPIOs due to having 8
> registers with 32 GPIOs in each available.
>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>  arch/arm64/boot/dts/broadcom/bcmbca/bcm6856.dtsi | 138
> ++++++++++++++++++++++-
>  1 file changed, 137 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm64/boot/dts/broadcom/bcmbca/bcm6856.dtsi
> b/arch/arm64/boot/dts/broadcom/bcmbca/bcm6856.dtsi
> index
> 00c62c1e5df00c722884a7adfcb7be08a43c0dc3..d6d0b8e1a65b494be414dd584
> 1b65f8ff489d684 100644
> --- a/arch/arm64/boot/dts/broadcom/bcmbca/bcm6856.dtsi
> +++ b/arch/arm64/boot/dts/broadcom/bcmbca/bcm6856.dtsi
> @@ -93,11 +93,103 @@ gic: interrupt-controller@1000 {
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
> +		watchdog@480 {
> +			compatible =3D "brcm,bcm6345-wdt";
> +			reg =3D <0x480 0x10>;
> +		};
> +
> +		watchdog@4c0 {
> +			compatible =3D "brcm,bcm6345-wdt";
> +			reg =3D <0x4c0 0x10>;
> +			status =3D "disabled";
> +		};
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
>
>  		uart0: serial@640 {
>  			compatible =3D "brcm,bcm6345-uart";
> @@ -108,6 +200,29 @@ uart0: serial@640 {
>  			status =3D "disabled";
>  		};
>
> +		uart1: serial@660 {
> +			compatible =3D "brcm,bcm6345-uart";
> +			reg =3D <0x660 0x18>;
> +			interrupts =3D <GIC_SPI 33 IRQ_TYPE_LEVEL_HIGH>;
> +			clocks =3D <&periph_clk>;
> +			clock-names =3D "refclk";
> +			status =3D "disabled";
> +		};
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
> @@ -134,4 +249,25 @@ nandcs: nand@0 {
>  			};
>  		};
>  	};
> +
> +	/* PERF1 Peripherals */
Same here.  I suggest to keep it under the same bus@ff800000 node.

> +	bus@ff858000 {
> +		compatible =3D "simple-bus";
> +		#address-cells =3D <1>;
> +		#size-cells =3D <1>;
> +		ranges =3D <0x0 0x0 0xff858000 0x4000>;
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
>  };
>
> --
> 2.49.0

--00000000000096bd3c0633a42871
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
JOEwDQYJYIZIAWUDBAIBBQCggccwLwYJKoZIhvcNAQkEMSIEIJrmI2z2LbBrzUE0qnleq+Y8uDqK
0RyI2iprr0TgGS+UMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTI1
MDQyNjAxMTMyOFowXAYJKoZIhvcNAQkPMU8wTTALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsG
CWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQcwCwYJYIZIAWUDBAIBMA0GCSqGSIb3
DQEBAQUABIIBAGOPr5TdI8Hg0rksQ99eKEZsdkP7Hba/Tu1w+Q53OAms6LQUk/tp5yMeDiRlXxuG
8scRk4maaoaeZxK2JVmdHUuvsc2ATBuwXz97TzjVakBn9Q2Dv4ElKgGVdtsJn9ODjPIX/6OaJLY2
uvzx3LP7fRwHXYjMSQDQSEsbm0w3yMUv6S1ukT6X9Ks0Ttl1A7fKJYXUi/HsLl9kAj4zT7cZ7Kc4
lDHzHooGYLxhYTruJwJDt1I1vKS1P8kbttx8GD29+Q7fgJltKY55l42uEwhCYfnmQoYQpTTM/qvk
9NxXBLD6fp5b8TCLZQyi716qaml71AL3b7hEdGiF6jcd3PUfQ48=
--00000000000096bd3c0633a42871--
