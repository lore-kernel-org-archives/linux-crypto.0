Received: from smtpout-03.galae.net (smtpout-03.galae.net [185.246.85.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D063F4657D6
	for <linux-crypto@vger.kernel.org>; Wed,  8 Jul 2026 12:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.85.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783515359; cv=none; b=m0h+jvQlbbR3Jiq7IdUYm0m5SyKTJ/qyG8xzY505g6VhetBcVfu6gdGEJWaVXEunGC0yNv+1xDUlM0Zx9yLKJsjF3cPWFYKybfuVMcRYI9D1dmdA25afoZ/AxqR6eNichIeXbNmPUnG6OeGg4AJg0YMMOv3YlOUMkhLIpQkLkjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783515359; c=relaxed/simple;
	bh=kpiLFxzc6cwGGBAjdzk8SGF1cVdXl/ofqMasqqKGK4o=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=htc+eX8ijTkW4gHC5Txi53Iq9Hl8wHs55mBciRGp6qkO6E3ncmcVtgrMho51OIsx68gdCI0raZZ4GNJsNxUznXHhl2wLYXVJkj69LsjVW4eZYtSJDJCshwgESIMl1z/jgSa5hkgFw6qZ/AcCqk5U26N7KyO3ShfkaOv5vQGC1BE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=nXBXgJZe; arc=none smtp.client-ip=185.246.85.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="nXBXgJZe"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-03.galae.net (Postfix) with ESMTPS id 87F0A4E40CF0;
	Wed,  8 Jul 2026 12:55:56 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 5879060337;
	Wed,  8 Jul 2026 12:55:56 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id DE71B11BC0D0F;
	Wed,  8 Jul 2026 14:55:46 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1783515354; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=iza98kz5xw5DiWQU+V2skvZGj0/IUU27q+G/NM1EOqk=;
	b=nXBXgJZeJJG7Qnf8SuuZ2ZMmaaAqfYucgvsc6vdHWFp7bAuESPZ5iu1prbeyiJJfRKaf+H
	1rBtVZrNDC5HnI6JpEMSvfna/fJppRz5s6eGwyOI0WolgF9E0gibhJ2U7i6yVB9X+LEBs7
	ehPvF3+vl4FVNMk8Zw/Mc4l4vOHK/fZCq9TI6pJwFg6O6SqzOf37XY8XNsXD+iBOzAgjiF
	6inKB9vdIxW0rElpCvzx4Wy2kHx+h/+tRvfPI9tmyp3b931rMJFwV42ajpd8HJJfyb4RHu
	aRRB9Ie+I3HRkqD5EMb37UO2a3ONWW6f1koesHDwMabTG/WbY9xJEe75nzt+/w==
From: Miquel Raynal <miquel.raynal@bootlin.com>
To: Rob Herring <robh@kernel.org>
Cc: Michael Turquette <mturquette@baylibre.com>,  Stephen Boyd
 <sboyd@kernel.org>,  Krzysztof Kozlowski <krzk+dt@kernel.org>,  Conor
 Dooley <conor+dt@kernel.org>,  Thomas Gleixner <tglx@kernel.org>,  Olivia
 Mackall <olivia@selenic.com>,  Herbert Xu <herbert@gondor.apana.org.au>,
  Jayesh Choudhary <j-choudhary@ti.com>,  "David S. Miller"
 <davem@davemloft.net>,  Christian Marangi <ansuelsmth@gmail.com>,  Antoine
 Tenart <atenart@kernel.org>,  Geert Uytterhoeven
 <geert+renesas@glider.be>,  Magnus Damm <magnus.damm@gmail.com>,  Thomas
 Petazzoni <thomas.petazzoni@bootlin.com>,  Pascal EBERHARD
 <pascal.eberhard@se.com>,  Wolfram Sang
 <wsa+renesas@sang-engineering.com>,  linux-clk@vger.kernel.org,
  devicetree@vger.kernel.org,  linux-kernel@vger.kernel.org,
  linux-crypto@vger.kernel.org,  linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 16/16] ARM: dts: renesas: r9a06g032: Describe the
 EIP-150 block
In-Reply-To: <20260407193356.GB3531350-robh@kernel.org> (Rob Herring's message
	of "Tue, 7 Apr 2026 14:33:56 -0500")
References: <20260327-schneider-v7-0-rc1-crypto-v1-0-5e6ff7853994@bootlin.com>
	<20260327-schneider-v7-0-rc1-crypto-v1-16-5e6ff7853994@bootlin.com>
	<20260407193356.GB3531350-robh@kernel.org>
User-Agent: mu4e 1.12.7; emacs 30.2
Date: Wed, 08 Jul 2026 14:55:46 +0200
Message-ID: <87qzldiqst.fsf@bootlin.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Last-TLS-Session-Version: TLSv1.3

Hello Rob,

Sorry for the late answer.

On 07/04/2026 at 14:33:56 -05, Rob Herring <robh@kernel.org> wrote:

> On Fri, Mar 27, 2026 at 09:09:38PM +0100, Miquel Raynal (Schneider Electr=
ic) wrote:
>> The EIP-150 is composed of 3 blocks:
>> * An interrupt controller named EIP-201 AIC
>>     - fed by a clock coming from the EIP-150
>>     - connected to the main GIC
>> * A random number generator named EIP-76
>>     - fed by a clock coming from the EIP-150
>>     - signalling interrupts through the AIC
>> * A public key accelerator engine named EIP-28
>>     - Fed by a clock coming from the EIP-150
>>     - Signalling interrupts through the AIC
>>=20
>> Signed-off-by: Miquel Raynal (Schneider Electric) <miquel.raynal@bootlin=
.com>
>> ---
>>  arch/arm/boot/dts/renesas/r9a06g032.dtsi | 42 +++++++++++++++++++++++++=
+++++++
>>  1 file changed, 42 insertions(+)
>>=20
>> diff --git a/arch/arm/boot/dts/renesas/r9a06g032.dtsi b/arch/arm/boot/dt=
s/renesas/r9a06g032.dtsi
>> index f4f760aff28b..6aaa93ed03d6 100644
>> --- a/arch/arm/boot/dts/renesas/r9a06g032.dtsi
>> +++ b/arch/arm/boot/dts/renesas/r9a06g032.dtsi
>> @@ -8,6 +8,7 @@
>>=20=20
>>  #include <dt-bindings/interrupt-controller/arm-gic.h>
>>  #include <dt-bindings/clock/r9a06g032-sysctrl.h>
>> +#include <dt-bindings/interrupt-controller/inside-secure,safexcel-eip20=
1.h>
>>=20=20
>>  / {
>>  	compatible =3D "renesas,r9a06g032";
>> @@ -170,6 +171,47 @@ usb@2,0 {
>>  			};
>>  		};
>>=20=20
>> +		eip150: bus@40040000 {
>> +			compatible =3D "inside-secure,safexcel-eip150", "simple-pm-bus";
>> +			clocks =3D <&sysctrl R9A06G032_HCLK_CRYPTO_EIP150>;
>> +			#clock-cells =3D <0>;
>> +			clock-map =3D <&sysctrl R9A06G032_HCLK_CRYPTO_EIP150>;
>
> I don't get why you need clock-map here. Why can't you just put this=20
> clock in each child node?

From a pure fonctional point of view it would work of course, but that's
IMO not an accurate representation of the hardware.

The EIP-150 is a single IP block with one clock input from the SoC
perspective. The children don't have independent wires to the clock
controller (sysctrl). The clock is routed through the container and
distributed internally.

I made the assumption that form a hardware point of view, container
nodes (like the EIP-150) somehow share a close design philosophy with
connectors wrt. the access of the upper resources.

Also, since nexus nodes are an established DT pattern, it felt like we
should bridge the gap on the clock side, hence this proposal.

Can you please confirm whether this is okay to pursue in this path or if
you really think we should stick to a simpler representation?

Thanks,
Miqu=C3=A8l
