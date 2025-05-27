Received: from mail.actia.se (mail.actia.se [212.181.117.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD7ED1A2C3A;
	Tue, 27 May 2025 15:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.181.117.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748358801; cv=none; b=jXYnxuLr5/Z4JhTtcELpEgO/gjiLC2Yp6PpSZlYnWQN+HMAeDV00vofKKpZkB16R4ESq5Ko5nND7Bn83avuoJDoZgNXd3n6z7wYN8obbeNaHBq0v+my6jxwLTOoY3kbovvC5uhxJ/1vqlPleXSY55q9JmdoooJJn0HuEfM0uXRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748358801; c=relaxed/simple;
	bh=/6HsKmpYeh7BBRSy3oq0s0gEWHuFSPRy3eNF68VoKm8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ryzR1Ey/o1w/3YcNvyfapt/ILqJccDD4uXzRZTnT8ObvoXmJ/ZBuTqF0HNwoueV/z6STdztOaXwuLZirZu03FyhOMR6zi8yQMwVXmAVOlxcVJMYUJ5DouFjJlriler8A+U6cgYAXYKX0VXvQniyboz2qFjiCY3JWxRmDjlZdsAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=actia.se; spf=pass smtp.mailfrom=actia.se; arc=none smtp.client-ip=212.181.117.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=actia.se
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=actia.se
Received: from S036ANL.actianordic.se (10.12.31.117) by S036ANL.actianordic.se
 (10.12.31.117) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 27 May
 2025 17:13:06 +0200
Received: from S036ANL.actianordic.se ([fe80::e13e:1feb:4ea6:ec69]) by
 S036ANL.actianordic.se ([fe80::e13e:1feb:4ea6:ec69%3]) with mapi id
 15.01.2507.039; Tue, 27 May 2025 17:13:06 +0200
From: John Ernberg <john.ernberg@actia.se>
To: Krzysztof Kozlowski <krzk@kernel.org>
CC: =?iso-8859-2?Q?Horia_Geant=E3?= <horia.geanta@nxp.com>, Pankaj Gupta
	<pankaj.gupta@nxp.com>, Gaurav Jain <gaurav.jain@nxp.com>, Herbert Xu
	<herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, "Rob
 Herring" <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, "Conor
 Dooley" <conor+dt@kernel.org>, Shawn Guo <shawnguo@kernel.org>, Sascha Hauer
	<s.hauer@pengutronix.de>, Frank Li <Frank.li@nxp.com>, "Pengutronix Kernel
 Team" <kernel@pengutronix.de>, Fabio Estevam <festevam@gmail.com>, "Thomas
 Richard" <thomas.richard@bootlin.com>, "linux-crypto@vger.kernel.org"
	<linux-crypto@vger.kernel.org>, "devicetree@vger.kernel.org"
	<devicetree@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "imx@lists.linux.dev" <imx@lists.linux.dev>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 3/4] dt-bindings: crypto: fsl,sec-v4.0: Add power
 domains for iMX8QM and iMX8QXP
Thread-Topic: [PATCH v2 3/4] dt-bindings: crypto: fsl,sec-v4.0: Add power
 domains for iMX8QM and iMX8QXP
Thread-Index: AQHbztc04cnioEWzpkWd5kjCyMGVVLPl8CAAgACEVoA=
Date: Tue, 27 May 2025 15:13:06 +0000
Message-ID: <aDXWfe3I6Cun1PMI@w447anl.localdomain>
References: <20250527071552.1424997-1-john.ernberg@actia.se>
 <20250527071552.1424997-4-john.ernberg@actia.se>
 <15dcde73-3c0e-4cc9-934f-4dbabd92905e@kernel.org>
In-Reply-To: <15dcde73-3c0e-4cc9-934f-4dbabd92905e@kernel.org>
Accept-Language: en-US, sv-SE
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-esetresult: clean, is OK
x-esetid: 37303A2955B14453607D60
Content-Type: text/plain; charset="iso-8859-2"
Content-ID: <6C17C786C22F954BBFA46345487E8483@actia.se>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Hi Krzysztof,

On Tue, May 27, 2025 at 09:19:22AM +0200, Krzysztof Kozlowski wrote:
> On 27/05/2025 09:16, John Ernberg wrote:
> >=20
> > diff --git a/Documentation/devicetree/bindings/crypto/fsl,sec-v4.0.yaml=
 b/Documentation/devicetree/bindings/crypto/fsl,sec-v4.0.yaml
> > index 75afa441e019..a3c938eb553e 100644
> > --- a/Documentation/devicetree/bindings/crypto/fsl,sec-v4.0.yaml
> > +++ b/Documentation/devicetree/bindings/crypto/fsl,sec-v4.0.yaml
> > @@ -48,6 +48,9 @@ properties:
> >                - fsl,imx6ul-caam
> >                - fsl,sec-v5.0
> >            - const: fsl,sec-v4.0
> > +      - items:
> > +          - const: fsl,imx8qm-caam
>=20
> That's part of previous enum, no?
>=20
> > +          - const: fsl,sec-v4.0
> >        - const: fsl,sec-v4.0
> > =20
> >    reg:
> > @@ -77,6 +80,9 @@ properties:
> >    interrupts:
> >      maxItems: 1
> > =20
> > +  power-domains:
> > +    maxItems: 1
> > +
> >    fsl,sec-era:
> >      description: Defines the 'ERA' of the SEC device.
> >      $ref: /schemas/types.yaml#/definitions/uint32
> > @@ -108,6 +114,9 @@ patternProperties:
> >            - items:
> >                - const: fsl,sec-v5.0-job-ring
> >                - const: fsl,sec-v4.0-job-ring
> > +          - items:
> > +              - const: fsl,imx8qm-job-ring
>=20
> Combine with previous entry into enum.
>=20

I think I managed to confuse myself around how compatible enums work first =
time around, thanks for prompting me to look again, I hopefully understand =
better now.

Will take care of this for V3.

Thanks! // John Ernberg=
