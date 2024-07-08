Received: from mx1.sberdevices.ru (mx2.sberdevices.ru [45.89.224.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BDE71DA303;
	Mon,  8 Jul 2024 10:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.89.224.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720435273; cv=none; b=HTj3Wg/eXVaW/cP/b/53FN+iaksW4YxlxlC9jpfuOEAafzXJuuIxJnZaSBBQvDJaYOiMWbAOFPPsIiUvsODOYJLTjGeIk/vtOBdos7pKSWs/GZ2Vdsj0/o2+q2pKnxa959B1v481ak5VxNTMjbuGBSJ1em7jZ8G7ap5CkfRuNJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720435273; c=relaxed/simple;
	bh=XskS0maRgQZBHDKIK+8SstCfUi84xbdyiEgDFbw91do=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=pqVi7qOig4bBFMme7NMc/iW34EEYnBkGoGUkrdllQm7frEjSE1LrX4ksEw6SVAq3Y7IrNpPx/Jk+frWjrsrX2c19YjtU/EIAnsHxbKZc/pTA2NBCyiyXbskmOkqpxsFAme6KcqaPbcSmhcKMlbkWKUzIl2QhXuBDJlTMy4rkjt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=salutedevices.com; spf=pass smtp.mailfrom=salutedevices.com; dkim=pass (2048-bit key) header.d=salutedevices.com header.i=@salutedevices.com header.b=si4lGhfo; arc=none smtp.client-ip=45.89.224.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=salutedevices.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=salutedevices.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=salutedevices.com header.i=@salutedevices.com header.b="si4lGhfo"
Received: from p-infra-ksmg-sc-msk02.sberdevices.ru (localhost [127.0.0.1])
	by mx1.sberdevices.ru (Postfix) with ESMTP id 622EC120008;
	Mon,  8 Jul 2024 13:33:41 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru 622EC120008
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=salutedevices.com;
	s=mail; t=1720434821;
	bh=kBbfq6zVIOZORkXhMU7x0H9PE5kCZaCWJAnTAIPXkmY=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version:From;
	b=si4lGhfoSQTWKP9/NbaYbHvz1faTyy/JNf1vI3yqVkRZayYWHD0xzEnShKSZ2tZrE
	 a6IloUlEQ8PY/QvFvgUp6SxqspX0cQirhGdr7EK7Gr9NJ/Cqq1ObfH7s4ssHLk+Fcd
	 daX9+ezpKZO2aF8WU1BoVM/v1Xaf+Kv5We7VFzajZDsJE4KImCpoS/d3WmZwMwQ1c+
	 v6hJRRJJZb1MPNuGq+LFkyyiW3JkGJZnHMJ0THBrA4gQGvaC9fX+Uf2YroFHT8kYFY
	 x3iuKAmuVw3i4UIpFU3z5+nQ5QI7MUcXW4Vcb8KKGsBKa0lyTB9yYxOgUAHofDp/UG
	 UZ+CVfBeS7faw==
Received: from smtp.sberdevices.ru (p-i-exch-sc-m02.sberdevices.ru [172.16.192.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.sberdevices.ru (Postfix) with ESMTPS;
	Mon,  8 Jul 2024 13:33:41 +0300 (MSK)
Received: from p-i-exch-sc-m02.sberdevices.ru (172.16.192.103) by
 p-i-exch-sc-m02.sberdevices.ru (172.16.192.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.40; Mon, 8 Jul 2024 13:33:40 +0300
Received: from p-i-exch-sc-m02.sberdevices.ru ([fe80::81d7:3d68:fdfd:518]) by
 p-i-exch-sc-m02.sberdevices.ru ([fe80::81d7:3d68:fdfd:518%9]) with mapi id
 15.02.1118.040; Mon, 8 Jul 2024 13:33:40 +0300
From: Alexey Romanov <avromanov@salutedevices.com>
To: Rob Herring <robh@kernel.org>
CC: "neil.armstrong@linaro.org" <neil.armstrong@linaro.org>,
	"clabbe@baylibre.com" <clabbe@baylibre.com>, "herbert@gondor.apana.org.au"
	<herbert@gondor.apana.org.au>, "davem@davemloft.net" <davem@davemloft.net>,
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
Subject: Re: [PATCH v8 17/23] dt-bindings: crypto: meson: correct clk and
 remove second interrupt line
Thread-Topic: [PATCH v8 17/23] dt-bindings: crypto: meson: correct clk and
 remove second interrupt line
Thread-Index: AQHauOTSAXN6fA211UWCwBG9LZMwhLHBZvKAgCs5hgA=
Date: Mon, 8 Jul 2024 10:33:40 +0000
Message-ID: <20240708103330.w2krusjlyoucsvcn@cab-wsm-0029881.sigma.sbrf.ru>
References: <20240607141242.2616580-1-avromanov@salutedevices.com>
 <20240607141242.2616580-18-avromanov@salutedevices.com>
 <20240610222827.GA3166929-robh@kernel.org>
In-Reply-To: <20240610222827.GA3166929-robh@kernel.org>
Accept-Language: ru-RU, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-ID: <79D38F7E409215488E684887CF215ECF@sberdevices.ru>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-KSMG-Rule-ID: 10
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Lua-Profiles: 186370 [Jul 08 2024]
X-KSMG-AntiSpam-Version: 6.1.0.4
X-KSMG-AntiSpam-Envelope-From: avromanov@salutedevices.com
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Info: LuaCore: 21 0.3.21 ebee5449fc125b2da45f1a6a6bc2c5c0c3ad0e05, {Track_E25351}, {Tracking_from_domain_doesnt_match_to}, smtp.sberdevices.ru:7.1.1,5.0.1;cab-wsm-0029881.sigma.sbrf.ru:7.1.1,5.0.1;127.0.0.199:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;salutedevices.com:7.1.1, FromAlignment: s
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean
X-KSMG-LinksScanning: Clean
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.0.1.6960, bases: 2024/07/08 09:16:00 #25900162
X-KSMG-AntiVirus-Status: Clean, skipped

Hi Rob,

thank you for the review.

On Mon, Jun 10, 2024 at 04:28:27PM -0600, Rob Herring wrote:
> On Fri, Jun 07, 2024 at 05:12:36PM +0300, Alexey Romanov wrote:
> > GXL and newer SoC's uses the DMA engine (not blkmv) for crypto HW.
> > Crypto HW doesn't actually use the blkmv clk. At RTL level, crypto
> > engine is hard weired to a clk81 (CLKID_CLK81).
>=20
> typo.
>=20
> >=20
> > Also, GXL crypto IP isn't to seconnd interrput line. So we must
>=20
> 2 more typos. Spell checkers exist. Use them instead of me please.
>=20
> I think you forgot the word 'connected' too.

Yep, sorry, I will fix all typos.

>=20
> > remove it from dt-bindings.
>=20
>=20
> So did this binding not work at all?=20

Yes.

> Are there any users?=20

No.

> You need a bit=20
> more justification for an ABI breaking change.

I will add more clarification information in commit message in V9.

>=20
> >=20
> > Fixes: 7f7d115dfb51 ("dt-bindings: crypto: Add DT bindings
> > documentation for amlogic-crypto")
>=20
> This line should not be wrapped.
> >=20
>=20
> Drop the blank line.
>=20
> > Signed-off-by: Alexey Romanov <avromanov@salutedevices.com>
> > ---
> >  .../bindings/crypto/amlogic,gxl-crypto.yaml          | 12 +++++++-----
> >  1 file changed, 7 insertions(+), 5 deletions(-)
> >=20
> > diff --git a/Documentation/devicetree/bindings/crypto/amlogic,gxl-crypt=
o.yaml b/Documentation/devicetree/bindings/crypto/amlogic,gxl-crypto.yaml
> > index 948e11ebe4ee..aff6f3234dc9 100644
> > --- a/Documentation/devicetree/bindings/crypto/amlogic,gxl-crypto.yaml
> > +++ b/Documentation/devicetree/bindings/crypto/amlogic,gxl-crypto.yaml
> > @@ -20,13 +20,15 @@ properties:
> >    interrupts:
> >      items:
> >        - description: Interrupt for flow 0
> > -      - description: Interrupt for flow 1
> > =20
> >    clocks:
> >      maxItems: 1
> > =20
> >    clock-names:
> > -    const: blkmv
> > +    const: clk81
>=20
> Clocks are supposed be named local to the block like what function or=20
> part of the block they clock. This sounds like something global.=20
>=20
> With only 1 clock, I'd just drop the name altogether.

I think I have to remove clock-names field in V9.

>=20
> > +
> > +  power-domains:
> > +    maxItems: 1
> > =20
> >  required:
> >    - compatible
> > @@ -46,7 +48,7 @@ examples:
> >      crypto: crypto-engine@c883e000 {
> >          compatible =3D "amlogic,gxl-crypto";
> >          reg =3D <0xc883e000 0x36>;
> > -        interrupts =3D <GIC_SPI 188 IRQ_TYPE_EDGE_RISING>, <GIC_SPI 18=
9 IRQ_TYPE_EDGE_RISING>;
> > -        clocks =3D <&clkc CLKID_BLKMV>;
> > -        clock-names =3D "blkmv";
> > +        interrupts =3D <GIC_SPI 188 IRQ_TYPE_EDGE_RISING>;
> > +        clocks =3D <&clkc CLKID_CLK81>;
> > +        clock-names =3D "clk81";
> >      };
> > --=20
> > 2.34.1
> >=20

--=20
Thank you,
Alexey=
