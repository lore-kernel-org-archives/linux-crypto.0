Received: from mx1.sberdevices.ru (mx1.sberdevices.ru [37.18.73.165])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79C8A1C3E;
	Thu, 23 May 2024 10:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=37.18.73.165
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716461210; cv=none; b=GmWFCZ2mto0WUpMblLvjoK4xtTc5ImmKxcB5nZxXhTRjWWK42vENpfgd/K8w9S/0k5cDn4/plX/t84Fo6DTBCr2pmaTUbdT54R12rFBV+MeXJXputHpnOMEHqrmavgMTQxs4uZ3fT3jokiz/CCB8oi1QcvhaME4J/3hYGuhs8FU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716461210; c=relaxed/simple;
	bh=phdcH303K7W6digXm2+Nm3VH+E3ndnFcG2TU5FEz9d4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=SeEzZe9usV2Nmes6l0JJHmfhAOK71GNgoQu4Vl/gW7uGZBKUR4v9IZZW5TKECpNoCqrlW53GmJdcfH4pUd+brQKo4XQ2ILYwZnUnSPwZ8xxX8ho8TX+PVGbW7MvcFMymwrNdvyVGPXDs4HWfqmPx7o9/05BWNn+iOXLvnVSn+Co=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=salutedevices.com; spf=pass smtp.mailfrom=salutedevices.com; dkim=pass (2048-bit key) header.d=salutedevices.com header.i=@salutedevices.com header.b=XgKtqM6N; arc=none smtp.client-ip=37.18.73.165
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=salutedevices.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=salutedevices.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=salutedevices.com header.i=@salutedevices.com header.b="XgKtqM6N"
Received: from p-infra-ksmg-sc-msk01 (localhost [127.0.0.1])
	by mx1.sberdevices.ru (Postfix) with ESMTP id A0860100013;
	Thu, 23 May 2024 13:46:36 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru A0860100013
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=salutedevices.com;
	s=mail; t=1716461196;
	bh=rnyJQc1d86XKiiLfsDTO95JbMJ3DJ5VaEkCq2oxfEnQ=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version:From;
	b=XgKtqM6NCtTLA5Z/OdZI3BU+DWFC1tck1eSc02By5hPnEfP+2PSZe37i7YkyTPQi4
	 GC7CxA+kD1zMBVoKJ80AckALSi0Rx4vjV2jkTcHGUhH01+FmZCy+IGNrVA9fn1rxRa
	 G5OcH4R7Cgbc3iy1l4nBSAD1ng4w5UN28kuW5RtYsJyQcpHn57aDxxPgOjsjTJbHS1
	 RQ2J03s6BYYsE0HR0lYo3KSVtBj9bq5Dpizc318BEzxb624LgE6oVuc8kuPJCwbXrq
	 SiSTtbdrMp2ZTUVbmKkAN/JI/EnH3fOjwmkT2wsokp3r+pKlQPlLobb2jVCPZwh/r0
	 q5U3EBxOOIQUQ==
Received: from smtp.sberdevices.ru (p-i-exch-a-m1.sberdevices.ru [172.24.196.116])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.sberdevices.ru (Postfix) with ESMTPS;
	Thu, 23 May 2024 13:46:36 +0300 (MSK)
Received: from p-i-exch-sc-m02.sberdevices.ru (172.16.192.103) by
 p-i-exch-a-m1.sberdevices.ru (172.24.196.116) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Thu, 23 May 2024 13:46:36 +0300
Received: from p-i-exch-sc-m02.sberdevices.ru ([fe80::10c3:6e04:fd07:c511]) by
 p-i-exch-sc-m02.sberdevices.ru ([fe80::10c3:6e04:fd07:c511%9]) with mapi id
 15.02.1118.040; Thu, 23 May 2024 13:46:36 +0300
From: Alexey Romanov <avromanov@salutedevices.com>
To: Conor Dooley <conor@kernel.org>
CC: "neil.armstrong@linaro.org" <neil.armstrong@linaro.org>,
	"clabbe@baylibre.com" <clabbe@baylibre.com>, "herbert@gondor.apana.org.au"
	<herbert@gondor.apana.org.au>, "davem@davemloft.net" <davem@davemloft.net>,
	"robh+dt@kernel.org" <robh+dt@kernel.org>,
	"krzysztof.kozlowski+dt@linaro.org" <krzysztof.kozlowski+dt@linaro.org>,
	"conor+dt@kernel.org" <conor+dt@kernel.org>, "khilman@baylibre.com"
	<khilman@baylibre.com>, "jbrunet@baylibre.com" <jbrunet@baylibre.com>,
	"martin.blumenstingl@googlemail.com" <martin.blumenstingl@googlemail.com>,
	"vadim.fedorenko@linux.dev" <vadim.fedorenko@linux.dev>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-amlogic@lists.infradead.org" <linux-amlogic@lists.infradead.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, kernel <kernel@sberdevices.ru>
Subject: Re: [PATCH v7 17/23] dt-bindings: crypto: meson: remove clk and
 second interrupt line for GXL
Thread-Topic: [PATCH v7 17/23] dt-bindings: crypto: meson: remove clk and
 second interrupt line for GXL
Thread-Index: AQHajBWjbcqi/hz3Ckugw/49eH+udbFpXY+AgCDP+ACAACFpgIAaY4MA
Date: Thu, 23 May 2024 10:46:35 +0000
Message-ID: <20240523104624.tr5omyxnzxsjkpai@cab-wsm-0029881.sigma.sbrf.ru>
References: <20240411133832.2896463-1-avromanov@salutedevices.com>
 <20240411133832.2896463-18-avromanov@salutedevices.com>
 <20240415-schnapps-plating-eb0895459004@spud>
 <20240506134754.jl633ncne7ct6szo@cab-wsm-0029881>
 <20240506-distrust-famine-6848f75dd3fe@spud>
In-Reply-To: <20240506-distrust-famine-6848f75dd3fe@spud>
Accept-Language: ru-RU, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-ID: <60740C6C7B2A8844930F23000BCA19F7@sberdevices.ru>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-KSMG-Rule-ID: 10
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Lua-Profiles: 185437 [May 23 2024]
X-KSMG-AntiSpam-Version: 6.1.0.4
X-KSMG-AntiSpam-Envelope-From: avromanov@salutedevices.com
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Info: LuaCore: 20 0.3.20 743589a8af6ec90b529f2124c2bbfc3ce1d2f20f, {Track_E25351}, {Tracking_from_domain_doesnt_match_to}, salutedevices.com:7.1.1;cab-wsm-0029881.sigma.sbrf.ru:5.0.1,7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;127.0.0.199:7.1.2;smtp.sberdevices.ru:5.0.1,7.1.1, FromAlignment: s
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean
X-KSMG-LinksScanning: Clean
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.0.1.6960, bases: 2024/05/23 07:54:00 #25244744
X-KSMG-AntiVirus-Status: Clean, skipped

Hi Conor,

On Mon, May 06, 2024 at 04:47:29PM +0100, Conor Dooley wrote:
> On Mon, May 06, 2024 at 01:48:01PM +0000, Alexey Romanov wrote:
> > On Mon, Apr 15, 2024 at 05:43:15PM +0100, Conor Dooley wrote:
> > > On Thu, Apr 11, 2024 at 04:38:26PM +0300, Alexey Romanov wrote:
> > > > GXL crypto IP isn't connected to clk and seconnd interrput line,
> > > > so we must remove them from dt-bindings.
> > >=20
> > > How does the device work without a clock?
> >=20
> > It's clocked by a common clock, the vendor didn't provide more
> > information. It doesn't have any special clock domains.
>=20
> So the hardware block does have a clock, which, even if it is a clock
> shared with other hardware blocks, makes your patch incorrect.
>=20
> Is the "blkmv" clock the shared clock?

I received accurate information from the vendor. Starting from GXL,
DMA engine is used for crypto HW and clock is hard weired to it (at RTL
level). That's why we have to remove it from device tree, because we can't
control it anyway.

I will add clarification about this in commit message in text patch
series.


>=20
> Cheers,
> Conor.
>=20
> > > > Fixes: 7f7d115dfb51 ("dt-bindings: crypto: Add DT bindings
> > > > documentation for amlogic-crypto")
> > > >=20
> > > > Signed-off-by: Alexey Romanov <avromanov@salutedevices.com>
> > > > ---
> > > >  .../bindings/crypto/amlogic,gxl-crypto.yaml         | 13 +--------=
----
> > > >  1 file changed, 1 insertion(+), 12 deletions(-)
> > > >=20
> > > > diff --git a/Documentation/devicetree/bindings/crypto/amlogic,gxl-c=
rypto.yaml b/Documentation/devicetree/bindings/crypto/amlogic,gxl-crypto.ya=
ml
> > > > index 948e11ebe4ee..d3af7b4d5f39 100644
> > > > --- a/Documentation/devicetree/bindings/crypto/amlogic,gxl-crypto.y=
aml
> > > > +++ b/Documentation/devicetree/bindings/crypto/amlogic,gxl-crypto.y=
aml
> > > > @@ -20,20 +20,11 @@ properties:
> > > >    interrupts:
> > > >      items:
> > > >        - description: Interrupt for flow 0
> > > > -      - description: Interrupt for flow 1
> > > > -
> > > > -  clocks:
> > > > -    maxItems: 1
> > > > -
> > > > -  clock-names:
> > > > -    const: blkmv
> > > > =20
> > > >  required:
> > > >    - compatible
> > > >    - reg
> > > >    - interrupts
> > > > -  - clocks
> > > > -  - clock-names
> > > > =20
> > > >  additionalProperties: false
> > > > =20
> > > > @@ -46,7 +37,5 @@ examples:
> > > >      crypto: crypto-engine@c883e000 {
> > > >          compatible =3D "amlogic,gxl-crypto";
> > > >          reg =3D <0xc883e000 0x36>;
> > > > -        interrupts =3D <GIC_SPI 188 IRQ_TYPE_EDGE_RISING>, <GIC_SP=
I 189 IRQ_TYPE_EDGE_RISING>;
> > > > -        clocks =3D <&clkc CLKID_BLKMV>;
> > > > -        clock-names =3D "blkmv";
> > > > +        interrupts =3D <GIC_SPI 188 IRQ_TYPE_EDGE_RISING>;
> > > >      };
> > > > --=20
> > > > 2.34.1
> > > >=20
> >=20
> >=20
> >=20
> >=20
> > --=20
> > Thank you,
> > Alexey



--=20
Thank you,
Alexey=
