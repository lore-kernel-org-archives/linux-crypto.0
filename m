Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A726E16A395
	for <linux-crypto@vger.kernel.org>; Sat, 25 Jul 2026 14:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784988855; cv=none; b=J4iNNOdkIWOahB7qOzxSLtipAppmYnOlEoHtsiDHW5rhzreBlYrMYFtwmUFpQ5iR23KTP8NqOFccDn2aC+O7UNWZRx9kZ03K7U/YACdF0ZKZ/YIwDMOcWRTf5wn+vSv7MtzEjdgQ3WSX/BF1C+HWB+SM5qfZong5FQiJVU8/d4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784988855; c=relaxed/simple;
	bh=XaiiDgwrOlI8vEMiMyKkT+LVbivn03Etl8oTlsYtgs8=;
	h=Mime-Version:Content-Type:Date:Message-Id:To:Cc:Subject:From:
	 References:In-Reply-To; b=P/8CqtgnTkoIJHK6li68ZZWtzs9t6kuCSxHwz5GSge2zLT5RfQcoTNrTmuNbCjx67yHf78GQx4it8iASZEyeuco62eTi6467klL+dLZhIvHDCFLGmlFibhMzmDa0Tgb6UwGhnp16K6nQhm3byugUkKoQ9kPidY/qaEgj+l0P3qQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cknow-tech.com; spf=pass smtp.mailfrom=cknow-tech.com; dkim=pass (2048-bit key) header.d=cknow-tech.com header.i=@cknow-tech.com header.b=da3/HJr1; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cknow-tech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cknow-tech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cknow-tech.com header.i=@cknow-tech.com header.b="da3/HJr1"
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cknow-tech.com;
	s=key1; t=1784988826;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aurhGwZBtBlsxKOKCfqWZVexhQ9NLkHWaOYsLZ76OpY=;
	b=da3/HJr1HSGbmZyx2j9hWWmH/1NxbPWVXq53bqxfd0z44gcBfNWmUIIA6poL2n64I8AuhQ
	uRHFtQfiyIIfxu8b/wyNuRkBxvQN3BM0BJfvHvei1IPRL4KeXvslOUP9ZiE66TA+Otldtv
	hRIQf1bPl6eVm6eCP6JLYkI4iPPpCAG4g1JCSP9zKpHY0ubdI06qGvyfrPkGNyIR5aDcBu
	nCjm1OdSU9fHObwgOmGP+BVHPMGnGxKbOyZygf/C3kQjZ1gSMQCRPRuew+tMnCp2EHx4cY
	fTuUI51v5ibUUcc94fhxhBG8aXJlReALfZbHTprdNh640ubIcPrefCADtSLD0g==
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sat, 25 Jul 2026 16:13:20 +0200
Message-Id: <DK7PPYNCUU5F.31BXH4215WDKI@cknow-tech.com>
To: "Dawid Olesinski" <dawidro@gmail.com>, =?utf-8?q?Heiko_St=C3=BCbner?=
 <heiko@sntech.de>
Cc: "Sebastian Reichel" <sebastian.reichel@collabora.com>, "Herbert Xu"
 <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>,
 "Rob Herring" <robh@kernel.org>, "Krzysztof Kozlowski"
 <krzk+dt@kernel.org>, "Conor Dooley" <conor+dt@kernel.org>, "Corentin
 Labbe" <clabbe@baylibre.com>, <linux-crypto@vger.kernel.org>,
 <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
 <linux-rockchip@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 3/4] arm64: dts: rockchip: Add crypto node to
 rk356x-base
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Diederik de Haas" <diederik@cknow-tech.com>
References: <20260708175837.1718437-1-dawidro@gmail.com>
 <20260708175837.1718437-4-dawidro@gmail.com> <ak7jEYTAGgeDdi1W@venus>
 <4011768.FjKLVJYuhi@diego> <20260710153012.0a840512@enyo>
In-Reply-To: <20260710153012.0a840512@enyo>
X-Migadu-Flow: FLOW_OUT

On Fri Jul 10, 2026 at 4:30 PM CEST, Dawid Olesinski wrote:
> On Thu, 09 Jul 2026 09:07:23 +0200
> Heiko St=C3=BCbner <heiko@sntech.de> wrote:
>
>> Am Donnerstag, 9. Juli 2026, 01:56:10 Mitteleurop=C3=A4ische Sommerzeit
>> schrieb Sebastian Reichel:
>> > Hi,
>> >=20
>> > On Wed, Jul 08, 2026 at 06:58:24PM +0100, Dawid Olesinski wrote: =20
>> > > Add the device tree node for the V2 cryptographic hardware
>> > > accelerator on RK356x SoCs (RK3566, RK3568).
>> > >=20
>> > > The IP block sits in the non-secure peripheral domain. Its three
>> > > clocks (core, aclk, hclk) and reset line are accessible directly
>> > > through the main non-secure CRU, so no firmware intermediary is
>> > > required.
>> > >=20
>> > > The node is disabled by default; board files that wish to use
>> > > hardware crypto offload must enable it. =20
>> >=20
>> > Why is it disabled by default? It doesn't seem to be board specific
>> > at all to me (the same question applies to the RK3588 DT). =20
>>=20
>> You're definitly right about that ... there are no board specific
>> resources needed, so Dawid please drop the status from both nodes.
>>=20
>
> I'll drop the `status =3D "disabled";`=20
> lines from both the RK356x and RK3588 device trees in v3.

That also means you can drop the label/phandle as there's no longer a need
to reference it in board files.

Cheers,
  Diederik

> Thanks for the review!
>
> Dawid
>
>> > >=20
>> > > Signed-off-by: Dawid Olesinski <dawidro@gmail.com>
>> > > ---
>> > >  arch/arm64/boot/dts/rockchip/rk356x-base.dtsi | 12 ++++++++++++
>> > >  1 file changed, 12 insertions(+)
>> > >=20
>> > > diff --git a/arch/arm64/boot/dts/rockchip/rk356x-base.dtsi
>> > > b/arch/arm64/boot/dts/rockchip/rk356x-base.dtsi index
>> > > a5832895bd39..9de7e7487ca1 100644 ---
>> > > a/arch/arm64/boot/dts/rockchip/rk356x-base.dtsi +++
>> > > b/arch/arm64/boot/dts/rockchip/rk356x-base.dtsi @@ -1112,6
>> > > +1112,18 @@ sdhci: mmc@fe310000 { status =3D "disabled";
>> > >  	};
>> > > =20
>> > > +	crypto: crypto@fe380000 {
>> > > +		compatible =3D "rockchip,rk3568-crypto";
>> > > +		reg =3D <0x0 0xfe380000 0x0 0x2000>;
>> > > +		interrupts =3D <GIC_SPI 4 IRQ_TYPE_LEVEL_HIGH>;
>> > > +		clocks =3D <&cru CLK_CRYPTO_NS_CORE>, <&cru
>> > > ACLK_CRYPTO_NS>,
>> > > +			 <&cru HCLK_CRYPTO_NS>;
>> > > +		clock-names =3D "core", "aclk", "hclk";
>> > > +		resets =3D <&cru SRST_CRYPTO_NS_CORE>;
>> > > +		reset-names =3D "core";
>> > > +		status =3D "disabled";
>> > > +	};
>> > > +
>> > >  	/*
>> > >  	 * Testing showed that the HWRNG found in RK3566
>> > > produces unacceptably
>> > >  	 * low quality of random data, so the HWRNG isn't
>> > > enabled for all RK356x =20
>> >  =20
>>=20
>>=20
>>=20
>>=20
>
>
> _______________________________________________
> Linux-rockchip mailing list
> Linux-rockchip@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-rockchip

