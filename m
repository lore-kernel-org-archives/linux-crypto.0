Received: from smtpout-03.galae.net (smtpout-03.galae.net [185.246.85.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07A823933FE
	for <linux-crypto@vger.kernel.org>; Thu, 22 Jan 2026 09:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.85.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769074095; cv=none; b=HjkVTaO9EU7N58afWfQ8MAq5OzIRp12/6Xp5dU7ZG0iQZh7BlRvpMy2ubT/whbUJMQMUXbKTShpCy2OI0rnocuhEj56Z6K8yEhxX/GZaZucB0A8Uj1YnUnxtrJwKyS1lSxxag+i7k1MzVSl8xUxJVHjO9+K+h3gjuVOU8pLwn9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769074095; c=relaxed/simple;
	bh=WwNfxBmzgG8tz55vWzbW3bj3arj3zhhpC0uI/7oe6W0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=glYEqUpod3X0G8K+G6Ih+419T7RnSyWTkYKbDIMGXRFd7bcqwlRyosxJJsoPfN//as61W/ZsjuQ9ODIIfyx+gW9gNiY2NxkcH51opa3ocZKxEZnON8TA3OlMRQLL1VmCDn0xQTm3WKPF04KLmUbsxnuJQqggvTd4WylDAd0qiCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=XYwxPmQ+; arc=none smtp.client-ip=185.246.85.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="XYwxPmQ+"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-03.galae.net (Postfix) with ESMTPS id 7CC814E421E4;
	Thu, 22 Jan 2026 09:28:09 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 47871606B6;
	Thu, 22 Jan 2026 09:28:09 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 149B8119B24FC;
	Thu, 22 Jan 2026 10:28:01 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1769074088; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=ecA15Vx12iOuabOvm7sXXldy4x2qXzfYEVChnCDQANI=;
	b=XYwxPmQ+wJnQzV+UMPulA9KosXrbNo/2ixYwHVUorsDLTSG8nCW/N5wo3Y+QoCzLj/7QHW
	++jGUmLig/U/drgmo3BxwZwVe3i9IYL+9/qZV1hPqrmGU9CRpPheBgyIQxPGYMotGN35Mb
	lEYQ0olAOmXMz59n7zaOGQ5a0gwNU4gdsXnzWYiOQAxqBJtVs5ZhDefOcf0DvWv7egh0VH
	D1Ppe5+IfUuf/ze55YYjH4nEKkNEvmEPJhg2GWqrsUXCJmZ+biMHAFBKm+L1Tv1QIJ5i+g
	xzN4Dntb/TMrSW8ffq97pIA0q8LLuvf3+21iw7HpE+b+T4QOvazSa70eU8sZJg==
From: Gregory CLEMENT <gregory.clement@bootlin.com>
To: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 krzk+dt@kernel.org
Cc: herbert@gondor.apana.org.au, davem@davemloft.net, robh@kernel.org,
 conor+dt@kernel.org, andrew@lunn.ch, sebastian.hesselbarth@gmail.com,
 matthias.bgg@gmail.com, angelogioacchino.delregno@collabora.com,
 atenart@kernel.org, linux-crypto@vger.kernel.org,
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org,
 kernel@collabora.com
Subject: Re: [PATCH v2 3/4] arm64: dts: marvell: Add SoC specific
 compatibles to SafeXcel crypto
In-Reply-To: <20260112145558.54644-4-angelogioacchino.delregno@collabora.com>
References: <20260112145558.54644-1-angelogioacchino.delregno@collabora.com>
 <20260112145558.54644-4-angelogioacchino.delregno@collabora.com>
Date: Thu, 22 Jan 2026 10:28:01 +0100
Message-ID: <87ikcukndq.fsf@BLaptop.bootlin.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Last-TLS-Session-Version: TLSv1.3

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
writes:

> Following the changes in the binding for the SafeXcel crypto
> engine, add SoC specific compatibles to the existing nodes in
> Armada 37xx and CP11x.
>

Applied on mvebu/dt64

Thanks,

Gregory

> Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@coll=
abora.com>
> ---
>  arch/arm64/boot/dts/marvell/armada-37xx.dtsi  | 3 ++-
>  arch/arm64/boot/dts/marvell/armada-cp11x.dtsi | 3 ++-
>  2 files changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm64/boot/dts/marvell/armada-37xx.dtsi b/arch/arm64/bo=
ot/dts/marvell/armada-37xx.dtsi
> index c612317043ea..87f9367aec12 100644
> --- a/arch/arm64/boot/dts/marvell/armada-37xx.dtsi
> +++ b/arch/arm64/boot/dts/marvell/armada-37xx.dtsi
> @@ -427,7 +427,8 @@ xor11 {
>  			};
>=20=20
>  			crypto: crypto@90000 {
> -				compatible =3D "inside-secure,safexcel-eip97ies";
> +				compatible =3D "marvell,armada-3700-crypto",
> +					     "inside-secure,safexcel-eip97ies";
>  				reg =3D <0x90000 0x20000>;
>  				interrupts =3D <GIC_SPI 20 IRQ_TYPE_LEVEL_HIGH>,
>  					     <GIC_SPI 21 IRQ_TYPE_LEVEL_HIGH>,
> diff --git a/arch/arm64/boot/dts/marvell/armada-cp11x.dtsi b/arch/arm64/b=
oot/dts/marvell/armada-cp11x.dtsi
> index d9d409eac259..39599171d51b 100644
> --- a/arch/arm64/boot/dts/marvell/armada-cp11x.dtsi
> +++ b/arch/arm64/boot/dts/marvell/armada-cp11x.dtsi
> @@ -512,7 +512,8 @@ CP11X_LABEL(sdhci0): mmc@780000 {
>  		};
>=20=20
>  		CP11X_LABEL(crypto): crypto@800000 {
> -			compatible =3D "inside-secure,safexcel-eip197b";
> +			compatible =3D "marvell,armada-cp110-crypto",
> +				     "inside-secure,safexcel-eip197b";
>  			reg =3D <0x800000 0x200000>;
>  			interrupts =3D <88 IRQ_TYPE_LEVEL_HIGH>,
>  				<89 IRQ_TYPE_LEVEL_HIGH>,
> --=20
> 2.52.0
>

--=20
Gr=C3=A9gory CLEMENT, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
