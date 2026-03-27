Received: from smtpout-02.galae.net (smtpout-02.galae.net [185.246.84.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27961393DD3;
	Fri, 27 Mar 2026 20:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.84.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774642282; cv=none; b=pmdJ42qbPm+DYv+bditVKA2YBu3rocFcsloEoZ/LXKOVtd+hHM5B7b51EmsuPWxi0psK4wdDYCvVj31ucLZSj6sWkWLmhqy65lmM8MNdkWEtB4Bl1ZsrDFRiMpNa00zTIB49doj12kTX364Ak03k841JTmv6YYNjyMWsijvTmhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774642282; c=relaxed/simple;
	bh=dVZyfeEgrkGYmDshoQsQ4RLpKkjU6LGopLTjHakrndA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ud3MI6bcyaUsHhIkvkbWI56vnVk7mNJBhXrS6wroIwlljmJP1HFShOOZZ0Kvp07NgcJgmDaqsYnbxlfxyekJlvygH5gPKLGAwz1njlp4rMiXbibx3MYppouG8CdnN7iMnYNlk5wgSAyk2mlnlTJkTIBsrlI7Syzdh83oxPmldyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=CT635IC3; arc=none smtp.client-ip=185.246.84.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="CT635IC3"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-02.galae.net (Postfix) with ESMTPS id DFC971A3033;
	Fri, 27 Mar 2026 20:11:19 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id B404060268;
	Fri, 27 Mar 2026 20:11:19 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 6938510451AF7;
	Fri, 27 Mar 2026 21:11:14 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1774642278; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=DIlrp9PjoRowHYZrJ7gc0fvN1Nwlk04nBRTDWt8Ig3w=;
	b=CT635IC3QQJ9j3PVQe+py5sJkt2oMZwPoLThB5jvtWnOVqrWOrq06xqGcCgdgXoHJrXMr8
	uwoBdNqh6pcF5Rb6AZPWqVjjWhdlSOKjY7aMMMQjEtKclEDtR7TWilFV65QqoTtDTO5uFA
	+mBgamfOadbous7asK2oPVEV9yM6mVd01qKXYoeUloq9u2tbyrhHNyQP1SqbY42kbsoFOk
	3+NjTBkXzG/FgzWZMF3aXuqFHqfpDssBTR/MrXgdQdQvtMrVvcyyK64rqJqZr6jTryo5Vv
	heas5wAdL2apG+2aZufBT46a39qq+r7cwH1GQpZKtc8/8YZ0+2IZXdgDKta5LA==
From: "Miquel Raynal (Schneider Electric)" <miquel.raynal@bootlin.com>
Date: Fri, 27 Mar 2026 21:09:38 +0100
Subject: [PATCH 16/16] ARM: dts: renesas: r9a06g032: Describe the EIP-150
 block
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260327-schneider-v7-0-rc1-crypto-v1-16-5e6ff7853994@bootlin.com>
References: <20260327-schneider-v7-0-rc1-crypto-v1-0-5e6ff7853994@bootlin.com>
In-Reply-To: <20260327-schneider-v7-0-rc1-crypto-v1-0-5e6ff7853994@bootlin.com>
To: Michael Turquette <mturquette@baylibre.com>, 
 Stephen Boyd <sboyd@kernel.org>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
 Olivia Mackall <olivia@selenic.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 Jayesh Choudhary <j-choudhary@ti.com>, 
 "David S. Miller" <davem@davemloft.net>, 
 Christian Marangi <ansuelsmth@gmail.com>, 
 Antoine Tenart <atenart@kernel.org>, 
 Geert Uytterhoeven <geert+renesas@glider.be>, 
 Magnus Damm <magnus.damm@gmail.com>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 Pascal EBERHARD <pascal.eberhard@se.com>, 
 Wolfram Sang <wsa+renesas@sang-engineering.com>, linux-clk@vger.kernel.org, 
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-crypto@vger.kernel.org, linux-renesas-soc@vger.kernel.org, 
 "Miquel Raynal (Schneider Electric)" <miquel.raynal@bootlin.com>
X-Mailer: b4 0.14.3
X-Last-TLS-Session-Version: TLSv1.3

The EIP-150 is composed of 3 blocks:
* An interrupt controller named EIP-201 AIC
    - fed by a clock coming from the EIP-150
    - connected to the main GIC
* A random number generator named EIP-76
    - fed by a clock coming from the EIP-150
    - signalling interrupts through the AIC
* A public key accelerator engine named EIP-28
    - Fed by a clock coming from the EIP-150
    - Signalling interrupts through the AIC

Signed-off-by: Miquel Raynal (Schneider Electric) <miquel.raynal@bootlin.com>
---
 arch/arm/boot/dts/renesas/r9a06g032.dtsi | 42 ++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/arch/arm/boot/dts/renesas/r9a06g032.dtsi b/arch/arm/boot/dts/renesas/r9a06g032.dtsi
index f4f760aff28b..6aaa93ed03d6 100644
--- a/arch/arm/boot/dts/renesas/r9a06g032.dtsi
+++ b/arch/arm/boot/dts/renesas/r9a06g032.dtsi
@@ -8,6 +8,7 @@
 
 #include <dt-bindings/interrupt-controller/arm-gic.h>
 #include <dt-bindings/clock/r9a06g032-sysctrl.h>
+#include <dt-bindings/interrupt-controller/inside-secure,safexcel-eip201.h>
 
 / {
 	compatible = "renesas,r9a06g032";
@@ -170,6 +171,47 @@ usb@2,0 {
 			};
 		};
 
+		eip150: bus@40040000 {
+			compatible = "inside-secure,safexcel-eip150", "simple-pm-bus";
+			clocks = <&sysctrl R9A06G032_HCLK_CRYPTO_EIP150>;
+			#clock-cells = <0>;
+			clock-map = <&sysctrl R9A06G032_HCLK_CRYPTO_EIP150>;
+			#address-cells = <1>;
+			#size-cells = <1>;
+			ranges = <0x40040000 0x40040000 0x10000>;
+			status = "disabled";
+
+			eip76_rng: rng@40040000 {
+				compatible = "inside-secure,safexcel-eip76";
+				reg = <0x40040000 0x80>;
+				interrupt-parent = <&eip201_aic>;
+				interrupts = <AIC_TRNG_INT IRQ_TYPE_EDGE_RISING>;
+				clocks = <&eip150>;
+				status = "disabled";
+			};
+
+			eip28_pka: crypto@40044000 {
+				compatible = "inside-secure,safexcel-eip28";
+				reg = <0x40044000 0x4000>;
+				interrupt-parent = <&eip201_aic>;
+				interrupts = <AIC_PKA_INT0 IRQ_TYPE_EDGE_RISING>,
+					     <AIC_PKA_INT1 IRQ_TYPE_EDGE_RISING>,
+					     <AIC_PKA_INT2 IRQ_TYPE_EDGE_RISING>;
+				clocks = <&eip150>;
+				status = "disabled";
+			};
+
+			eip201_aic: interrupt-controller@40048000 {
+				compatible = "inside-secure,safexcel-eip201";
+				reg = <0x40048000 0x4000>;
+				interrupts = <GIC_SPI 55 IRQ_TYPE_LEVEL_HIGH>;
+				interrupt-controller;
+				#interrupt-cells = <2>;
+				clocks = <&eip150>;
+				status = "disabled";
+			};
+		};
+
 		uart0: serial@40060000 {
 			compatible = "renesas,r9a06g032-uart", "renesas,rzn1-uart", "snps,dw-apb-uart";
 			reg = <0x40060000 0x400>;

-- 
2.51.1

