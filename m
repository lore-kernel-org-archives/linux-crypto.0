Received: from mail.actia.se (mail.actia.se [212.181.117.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2367D26C385;
	Thu, 29 May 2025 09:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.181.117.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748511726; cv=none; b=iCwRufOfKB7KEDDDw+HXpBHFBBDzACYOE7ZgVjn2b9nHNqLZ7sLnRU4uH3PzuP0FvJwO7m4d1jdeKMQJ8kwwx1OndWYGbK63o1ZTYtYTQnztlBw39uDV8Gl+LOsX6effvwyJrlGoVUxbRivVnkTf+owLlH1KlFiwHk4TBygKFV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748511726; c=relaxed/simple;
	bh=bAH8EM/gjf3gnkT94CNwWdhrV11ZTppR7UdhRKVzj50=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=AHlxoEu0BDWflSxGh8sBiNamiRle7MrrP8vPS+eJhAvT4mSJiPldoJOqDdjOix9rLmVqAqmxqrQcbURNVTkdA49uHNpNxoIBf1d/ncjhjELzWrNssVaG0UNex3bmu7IAMKDUfGVj8Z722VjPhMQ39yBNvWVE7pZ6oF76uOe8UK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=actia.se; spf=pass smtp.mailfrom=actia.se; arc=none smtp.client-ip=212.181.117.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=actia.se
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=actia.se
Received: from S036ANL.actianordic.se (10.12.31.117) by S035ANL.actianordic.se
 (10.12.31.116) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 29 May
 2025 11:42:02 +0200
Received: from S036ANL.actianordic.se ([fe80::e13e:1feb:4ea6:ec69]) by
 S036ANL.actianordic.se ([fe80::e13e:1feb:4ea6:ec69%3]) with mapi id
 15.01.2507.039; Thu, 29 May 2025 11:42:02 +0200
From: John Ernberg <john.ernberg@actia.se>
To: Frank Li <Frank.li@nxp.com>
CC: =?iso-8859-2?Q?Horia_Geant=E3?= <horia.geanta@nxp.com>, Pankaj Gupta
	<pankaj.gupta@nxp.com>, Gaurav Jain <gaurav.jain@nxp.com>, Herbert Xu
	<herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, "Rob
 Herring" <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, "Conor
 Dooley" <conor+dt@kernel.org>, Shawn Guo <shawnguo@kernel.org>, Sascha Hauer
	<s.hauer@pengutronix.de>, Pengutronix Kernel Team <kernel@pengutronix.de>,
	Fabio Estevam <festevam@gmail.com>, Thomas Richard
	<thomas.richard@bootlin.com>, "linux-crypto@vger.kernel.org"
	<linux-crypto@vger.kernel.org>, "devicetree@vger.kernel.org"
	<devicetree@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "imx@lists.linux.dev" <imx@lists.linux.dev>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 3/4] dt-bindings: crypto: fsl,sec-v4.0: Add power
 domains for iMX8QM and iMX8QXP
Thread-Topic: [PATCH v3 3/4] dt-bindings: crypto: fsl,sec-v4.0: Add power
 domains for iMX8QM and iMX8QXP
Thread-Index: AQHbz97TDhLekXOKbkmerT2PfEO8vrPoAHkAgAE6HYA=
Date: Thu, 29 May 2025 09:42:02 +0000
Message-ID: <aDgr6Sc-7CafIr_i@w447anl.localdomain>
References: <20250528144259.2603914-1-john.ernberg@actia.se>
 <20250528144259.2603914-4-john.ernberg@actia.se>
 <aDckaszTLMcUdIiY@lizhi-Precision-Tower-5810>
In-Reply-To: <aDckaszTLMcUdIiY@lizhi-Precision-Tower-5810>
Accept-Language: en-US, sv-SE
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-esetresult: clean, is OK
x-esetid: 37303A2956B14453637562
Content-Type: text/plain; charset="iso-8859-2"
Content-ID: <A07E64761B5D8A4895653371B0A38C92@actia.se>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Hi Frank,

On Wed, May 28, 2025 at 10:57:46AM -0400, Frank Li wrote:
> On Wed, May 28, 2025 at 02:43:07PM +0000, John Ernberg wrote:
> > NXP SoCs like the iMX8QM, iMX8QXP or iMX8DXP use power domains for
> > resource management.
> >
> > Allow specifying them for such SoCs.
>=20
> suggest comment:
>=20
> Add compatible string fsl,imx8qm-caam, and allow power-domains for it. Ke=
ep
> the same restriction for others.

Ack.

>=20
> >
> > Signed-off-by: John Ernberg <john.ernberg@actia.se>
> >
> > ---
> >
> > v3:
> >  - Fix warnings discovered by Rob Herring's bot
> >  - Declare the compatibles correctly (Krzysztof Kozlowski)
> >
> > v2:
> >  - Adjust commit message (Frank Li)
> >  - Only allow power-domains when compatible with imx8qm (Frank Li)
> > ---
> >  .../bindings/crypto/fsl,sec-v4.0.yaml         | 45 ++++++++++++++++++-
> >  1 file changed, 44 insertions(+), 1 deletion(-)
> >
> > diff --git a/Documentation/devicetree/bindings/crypto/fsl,sec-v4.0.yaml=
 b/Documentation/devicetree/bindings/crypto/fsl,sec-v4.0.yaml
> > index 75afa441e019..a4ada0e2d97c 100644
> > --- a/Documentation/devicetree/bindings/crypto/fsl,sec-v4.0.yaml
> > +++ b/Documentation/devicetree/bindings/crypto/fsl,sec-v4.0.yaml
> > @@ -46,6 +46,7 @@ properties:
> >        - items:
> >            - enum:
> >                - fsl,imx6ul-caam
> > +              - fsl,imx8qm-caam
>=20
> suggest add fsl,imx8qxp-caam, fsl,imx8dxl-caam also

While I know the DXL comes with the CAAM, I don't have access to any boards
with a DXL on it nor the DXL security manual. So I cannot validate any
changes I would make for the DXL variant.

I propose to keep the DXL out of this patch set, is that ok for you?

I'll add a compat for the QXP in V4.

Thanks! // John Ernberg

>=20
> Frank=
