Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013059.outbound.protection.outlook.com [40.93.201.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6E3F2E6116;
	Tue, 11 Nov 2025 11:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762862263; cv=fail; b=SAr7dgSaUwkCArR1UVcm+6tNcTsAArvG/MyZUh/07GlxS5zCyfY4/OUDLK5zDcDg47uIeHnj545QDY5puvLv5l/VGcN46rsbC7Nle5VIQKxN4Nl+odCMzNR6PCjp5QmR/GPslowJTOqRMOgqQilnvzoWZpvSLRrG6iDFJJdBPRg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762862263; c=relaxed/simple;
	bh=tuINL1204aLA0U87P30t2uEfGr4xr8haaFF5FWN3BAg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=YtIdIM/6oqPMKAh2QGojPiZukoFX1CgwZrzD3wJEldpRDMv6+5IWyIvzhkIs8Le1mFS7NgHWdSTwFpiaeMB0n20A+V1R0KtICZ/otSbTtmTbfXpl0bn+cseKzuvrHYOrNfmVNB1KdnOAc0ZsnJrOdpU4pU2L+FhCGGZjteoJoiw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=b3CDMYOh; arc=fail smtp.client-ip=40.93.201.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="b3CDMYOh"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=e6Sb27Nr7nE3HVJbPlgtjzEPG2ioxHvYM87fZk/y7imNNgnpAOJwVyqN1hRZ7G55R9IwINNr6q9QV4Sx/OIJhsQkbeIwxax4WNAkAX7BAjEvUJAA9LDRjnpGpqhr7Roolh1CV7URHQ0At4YcCVC43/hAQ4vNwvfOiwf39UhLkFIoOSVk+BFlPw7vyRtk2/gWPNyNOewB8EzxGK1ZG3+LFzp8o95sf05utzXq5tY+7OIWxH+5tQN/uWAZA8Xn4ifln6pL/Bkd04wIsJslgrGjKAVtLmYWXmlYEydj+BZ5ufjFw37i8aITFmnHjzeL2/HC8kmZ3jwdvHiTH/3Cf+ypvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n/+DpLeTqUhzHXwi6k7Py2elVbJHKKOt0rAE1jaDZVo=;
 b=DTBbixIyb256GxYq5pamEhD56AxEcnTkMZF/MrZCiwicZ3yKQZGrwEOs1Eox9FTqomairkXhDIZ8fsYOYvzI1yWIeSn7bD/0ljEbRUiqIPHaYMZLJ/efkV2Pr8AbC5prHHazowkjUi2aOdXHk2lPTCssangjCljuG2x1qUIf18qPtof+5+98M5NS2qFyAlO+i1y2mZifwWGlFCHjc/eA9k7c19wAMlXWUIx312Q/jpKGqRCVOyfb9zll7fOuosbTaXSgM13Mie9UiCZbTMK1q5qjTxE1HBLBq1eNq+4hscjTjVoqSO21UN33sgHV5Fv0C1D0BeqyqVTUSanoOg0RoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n/+DpLeTqUhzHXwi6k7Py2elVbJHKKOt0rAE1jaDZVo=;
 b=b3CDMYOh+SDg+TCUYgdhftpxCpo2See48D4KzbhoJpfRWBPczlKLWEb/77Ut3EnNagLlH5ROVl/WzEOgSP1b3i/wxf1OeVnnvU8mw+l5cMqQSubpwCUfxntt0Fl4XdOVRQEap6jbgFN4SmiO0Dr4rZYGxP0LTrCnliDIh2cPQjw=
Received: from DS0PR12MB9345.namprd12.prod.outlook.com (2603:10b6:8:1a9::10)
 by PH7PR12MB6858.namprd12.prod.outlook.com (2603:10b6:510:1b4::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.16; Tue, 11 Nov
 2025 11:57:33 +0000
Received: from DS0PR12MB9345.namprd12.prod.outlook.com
 ([fe80::65ab:d63c:7341:edbb]) by DS0PR12MB9345.namprd12.prod.outlook.com
 ([fe80::65ab:d63c:7341:edbb%2]) with mapi id 15.20.9320.013; Tue, 11 Nov 2025
 11:57:33 +0000
From: "Jain, Harsh (AECG-SSW)" <h.jain@amd.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: "davem@davemloft.net" <davem@davemloft.net>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, "robh@kernel.org"
	<robh@kernel.org>, "krzk+dt@kernel.org" <krzk+dt@kernel.org>,
	"conor+dt@kernel.org" <conor+dt@kernel.org>, "Botcha, Mounika"
	<Mounika.Botcha@amd.com>, "Savitala, Sarat Chand"
	<sarat.chand.savitala@amd.com>, "Simek, Michal" <michal.simek@amd.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "Buddhabhatti, Jay"
	<jay.buddhabhatti@amd.com>
Subject: RE: [PATCH 09/15] crypto: zynqmp-aes-gcm: Fix setkey operation to
 select HW keys
Thread-Topic: [PATCH 09/15] crypto: zynqmp-aes-gcm: Fix setkey operation to
 select HW keys
Thread-Index: AQHcSL4fwl9HB3A2vEaDmA0sI135SrTlG3sAgAhWX/A=
Date: Tue, 11 Nov 2025 11:57:33 +0000
Message-ID:
 <DS0PR12MB934525C9192C679D5AE681DD97CFA@DS0PR12MB9345.namprd12.prod.outlook.com>
References: <20251029102158.3190743-1-h.jain@amd.com>
 <20251029102158.3190743-10-h.jain@amd.com>
 <aQwlEgMlYr8EPrTo@gondor.apana.org.au>
In-Reply-To: <aQwlEgMlYr8EPrTo@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_Enabled=True;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_SetDate=2025-11-11T11:52:35.0000000Z;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_Name=AMD
 Internal Distribution
 Only;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_ContentBits=3;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_Method=Standard
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR12MB9345:EE_|PH7PR12MB6858:EE_
x-ms-office365-filtering-correlation-id: 0d405bea-009b-4e26-86d4-08de21197fcd
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700021;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?0nso2AWOkKKY5z2+Iq/56q3DSkWGmqHWCBITLfFKuhasvoCqEjexoqVcbTbz?=
 =?us-ascii?Q?0FdNXBLlY6kj+Uht1yszNzYAHxeGMVsy+JvzGZq6p5TA/n31sad+DQkQBivd?=
 =?us-ascii?Q?yZrNnsDAJ2/eZJ70jY8JzQUP0BMa1ZG31pw8XFXYwcXn9D4aN/eP5xJ4iGsH?=
 =?us-ascii?Q?OBPEEKWYxh/MVrU8A55xFi3B1lgXsoiP3RjHzXiq6J8IM41ioH0QS37c3/JM?=
 =?us-ascii?Q?rSri8OwHB4wgYKE2Nr1yO/PNyIXK+9bZMG7CBWHIPTHCWc95oeNyHdWat/2M?=
 =?us-ascii?Q?+1fpeVJiV5Oq+EoB8vFKiS2UldSHHGWPHmlpyVHL9fMgrCft1qjxAtRDVsEo?=
 =?us-ascii?Q?nBvryGv/hg2KYF6aEd6TXITSlLy/RNT+3GG4RsEdRU/rLeu4rv5m4aAlEthS?=
 =?us-ascii?Q?u+BWmj+HbNbB55nRF2ulQrcveoD/ghwl6BrXilv76KZoX3scvP4t1LcYGXQh?=
 =?us-ascii?Q?NBe8EVkh9GTvMQh1lH19t7L/0Ge5j8X9X5ptZ2VhzsTBIjS0d6TrwlYjhWkp?=
 =?us-ascii?Q?3sj6TkiJvL3HyvOG4lyNwjKic4cc/fZIJkcHlEzYLgyimn8ttv1Vjk6KCC/E?=
 =?us-ascii?Q?8wbc+JlVG0Pl5Wg2Do4WWI5MBhDFjJ2v2tU954kJQckHZCgG8HuGQA9OeABd?=
 =?us-ascii?Q?GXCNuOD3OIiOvyRtt4oDWY8vol2cS3z5Wzk7SS1pT/kdF/J3wy4IUAg5UYoJ?=
 =?us-ascii?Q?cpjvKmm1InryoY+GJYo4uL9Lm1KqS/uRY+k9i1RiY6K/zy4SkIX7qAo7rHt8?=
 =?us-ascii?Q?lHCVuoVUUX9HRGp7lHN9Z9GGBOI8ufT/K2FO3hSeOMg0MC7AQr7R5AsaECZ+?=
 =?us-ascii?Q?1NBwY1xhohrgI3iliC6akMc+nDyrP56wdV6PB9GBAn5le/vCyepId5Q/VpEZ?=
 =?us-ascii?Q?4hOWQnt7oEBBant3s0einaEFu/D376YLSxpSoT458YzN3sIoPAJNc+NW+pB7?=
 =?us-ascii?Q?wSSUr/WTEXuhp95elrKji8J6m3344Gv4i6hcsyakZq+hRXav8NBBdfm9i4ef?=
 =?us-ascii?Q?yjvcv56yZDIRG9g3iZEE5VutTyeKdg0sDzQ7aEtBXVvvqq5Pk/+cL+ZrIBJE?=
 =?us-ascii?Q?86laPt3Z5bJFS8Wjgx9ZTxkofMrDh89xQ9O0S+fGwSwkjoV/qM1bMPF0Lumt?=
 =?us-ascii?Q?YgIy8gAcvff/tnXV7stmJiLfdtA3U/4FemSoUKrnDfpWZlsI87lS8pWHdE2y?=
 =?us-ascii?Q?8zr/AgJD+8yRVb4eIgBNv/NHJYN3sdGe/Bm8VUQvuh+XOYJWOYsgtLEYPjqH?=
 =?us-ascii?Q?32PCx0ZKjpP6WxekfB//K6OxX3pFTYGSeQd9mAb/VNpeq8qXy1PtO/Baek8m?=
 =?us-ascii?Q?RMa9Lh0wr/volp/Fw/ywJVsIC4z8pcse/qM49Wri4nUnKDzjJm7HF5JV4pye?=
 =?us-ascii?Q?c+sBkphez6nyBFAgJg2ZYXnE98RCduV7WgTyYJNLsGbkDUo6PelAwAlqbTB8?=
 =?us-ascii?Q?OehO/TsBxgGynmHliDvVCSggilvHq/miHUm97/JkqLjK5iyjO7dNbQ=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB9345.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?qoDcF9NqUbBF4unBTy4oOD5jFm7/gv9KKBYrqRNtIvyNEgVeLtpJqyiqsnrH?=
 =?us-ascii?Q?nRk9K0RA8uyXNQ3GKle7FhsopTTEgMgQaahq0MHSTOOntEgd4IsKx3mkQVFU?=
 =?us-ascii?Q?utrGEtc2zvMONKMZfYWRTcUTS2UkP3VCvKT+L1HNeD8YEuyh2KyyUgp6L+QW?=
 =?us-ascii?Q?C3UwSPY5TdDK4g74byFdeTVDHH76NWovL5itV83hRHBMryaHbDD/IHgDQehn?=
 =?us-ascii?Q?LnWcQ5oG7wjJzsN2fnV1V5MfQf5J3tAQl3yAGnQ2WAAqHf1Qe/W+rh2ORt1w?=
 =?us-ascii?Q?t+uVHy5f0/TxxiYZmvKuj5bylHCkxDQJyqEs7Tsu6qw1kbRCdAbdJKyoT9Mb?=
 =?us-ascii?Q?/iV9NxcIY6DnVqmVANWovWaAmjXwIXBL9qt4mbvjplFpE/hBoZ5/qpaobxCu?=
 =?us-ascii?Q?l2gTZ1fpTP4GoINBJI7AtAngmg6stvSI0TuJjx943j9zjMEjOIoNWUcQAGyf?=
 =?us-ascii?Q?Xnv132g1wNn8V1PBcAU97uFZAXS5PvQIXEY7JsLKrp/yH/RG/JFuniCFYS8X?=
 =?us-ascii?Q?FvokwR514UW3tCkZJQHq/HnEYK1m2Hxfoomd4i81D2srwh9ivNCI5L4bRlJJ?=
 =?us-ascii?Q?sNlZE/VbF/VTl+1JcTU/E6ttzLmus2gCKH72QGN111W5BWgXGT8+tkNrgT0g?=
 =?us-ascii?Q?qM4t0+DhqPg16/JRIL8IXnHeyE0ToJnHvX6umydod2zQwa68x6ibKW1UudKW?=
 =?us-ascii?Q?Kz2h48lew2cAzW71wP0RKCFm9svO1qU4np2z/bpb23sK2uwkHBbzA2W6pp8R?=
 =?us-ascii?Q?0hEm1EXQ1rf6/GXR3KvNnv4+onU4t2iaHE/2vC43+S+uquSoLebFNuE9362+?=
 =?us-ascii?Q?/u0lVLws6JSBP6TlUPt/BEbmsrydKQ+L0NgsrQUF9d93R6Xvgk/wiOVXA4jU?=
 =?us-ascii?Q?qZt/XcP7IRq6rAehqVyu8Zz89tNwkZ2JfOFG33DYyO73YsuOQhZr0yj6lnGq?=
 =?us-ascii?Q?+ZPaiZHPR59z5UoT7iiSPttHnnUxwPyVftcsvPU9Q8KlmChQcpX6uFrM7I2L?=
 =?us-ascii?Q?d5onfFJFchswkIHfVyU4zoDbr9KN8DjD/gO8Ys8kXVuoWVT9/HqNiST/U8W+?=
 =?us-ascii?Q?0tL1bJxMsPDhObW5oC5PA1ESbwFYQUw4rWEq/o32x/0MQ3lp3wTe98Ic5Jbh?=
 =?us-ascii?Q?VdfmHVZUcAo00IdM/Ruf7edX46Rn4N2xERpyfruXnLLMQRIq5BCImH0fj+r+?=
 =?us-ascii?Q?dSiy7wqU5jIeceJGJiGM39ol3aLOjseHwHcP37TaHyBKX8FBcADkiT5EZBkN?=
 =?us-ascii?Q?HFnthBWOepWKRoZ4HA/DE6a7aRgU1s3ndnG23oer8I2QbOTnRGfL2wDI4d4g?=
 =?us-ascii?Q?Nio488g1zzi2LqaiKFapPSiM9HclUEnOPJllByfRr+XqS6BwucS1CtIcXch5?=
 =?us-ascii?Q?ax7KzKajE6dd0+EK0t25d/TFmVW4jLGZiOiF/fnMVcb5+iJcBrXajd37uvIV?=
 =?us-ascii?Q?L7YwVeOTUHtPZ6SpdC/MyAT/h4TFKFslDKcGZa+7koGH5u4lQGa3yVxQe2M1?=
 =?us-ascii?Q?bTMOdH3WKFvhzMnXwF9ZmW+nQlO8Iacdj3uzo8Cz+OcDLmapxm8QA66Ugfif?=
 =?us-ascii?Q?F9FzWNIPDdpD/a6WuZI=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB9345.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d405bea-009b-4e26-86d4-08de21197fcd
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Nov 2025 11:57:33.4676
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WEKrFCK1wuuDjMa9ku++pXCqzb/CvYcrLEge6zTzo8B3023CCCLdLM1j1OUHV944
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6858

[AMD Official Use Only - AMD Internal Distribution Only]

> -----Original Message-----
> From: Herbert Xu <herbert@gondor.apana.org.au>
> Sent: Thursday, November 6, 2025 10:03 AM
> To: Jain, Harsh (AECG-SSW) <h.jain@amd.com>
> Cc: davem@davemloft.net; linux-crypto@vger.kernel.org;
> devicetree@vger.kernel.org; robh@kernel.org; krzk+dt@kernel.org;
> conor+dt@kernel.org; Botcha, Mounika <Mounika.Botcha@amd.com>; Savitala,
> Sarat Chand <sarat.chand.savitala@amd.com>; Simek, Michal
> <michal.simek@amd.com>; linux-arm-kernel@lists.infradead.org; Buddhabhatt=
i, Jay
> <jay.buddhabhatti@amd.com>
> Subject: Re: [PATCH 09/15] crypto: zynqmp-aes-gcm: Fix setkey operation t=
o select
> HW keys
>
>
>
> On Wed, Oct 29, 2025 at 03:51:52PM +0530, Harsh Jain wrote:
> > Currently keylen 1 is used to select hw key. There are -ve self test
> > which can fail for setkey length 1. Update driver to use 4 bytes
> > with magic number to select H/W key type.
> >
> > Signed-off-by: Harsh Jain <h.jain@amd.com>
> > ---
> >  drivers/crypto/xilinx/zynqmp-aes-gcm.c | 94 ++++++++++++++++----------
> >  1 file changed, 60 insertions(+), 34 deletions(-)
>
> The hardware key support should be registered under the name paes
> instead of aes.  Grep for paes in drivers/crypto for examples.

Sure, Will check and update the driver accordingly.

>
> > @@ -218,32 +220,42 @@ static int zynqmp_aes_aead_setkey(struct
> crypto_aead *aead, const u8 *key,
> >                                 unsigned int keylen)
> >  {
> >       struct crypto_tfm *tfm =3D crypto_aead_tfm(aead);
> > -     struct zynqmp_aead_tfm_ctx *tfm_ctx =3D
> > -                     (struct zynqmp_aead_tfm_ctx *)crypto_tfm_ctx(tfm)=
;
> > +     struct zynqmp_aead_tfm_ctx *tfm_ctx =3D crypto_tfm_ctx(tfm);
> > +     struct xilinx_hwkey_info hwkey;
> >       unsigned char keysrc;
> > +     int err;
> >
> > -     if (keylen =3D=3D ZYNQMP_KEY_SRC_SEL_KEY_LEN) {
> > -             keysrc =3D *key;
> > +     if (keylen =3D=3D sizeof(struct xilinx_hwkey_info)) {
> > +             memcpy(&hwkey, key, sizeof(struct xilinx_hwkey_info));
> > +             if (hwkey.magic !=3D XILINX_KEY_MAGIC)
> > +                     return -EINVAL;
> > +             keysrc =3D hwkey.type;
> >               if (keysrc =3D=3D ZYNQMP_AES_KUP_KEY ||
> >                   keysrc =3D=3D ZYNQMP_AES_DEV_KEY ||
> >                   keysrc =3D=3D ZYNQMP_AES_PUF_KEY) {
> > -                     tfm_ctx->keysrc =3D (enum zynqmp_aead_keysrc)keys=
rc;
> > -             } else {
> > -                     tfm_ctx->keylen =3D keylen;
> > +                     tfm_ctx->keysrc =3D keysrc;
> > +                     tfm_ctx->keylen =3D sizeof(struct xilinx_hwkey_in=
fo);
> > +                     return 0;
> >               }
> > -     } else {
> > +             return -EINVAL;
> > +     }
> > +
> > +     if (keylen =3D=3D ZYNQMP_AES_KEY_SIZE && tfm_ctx->keysrc =3D=3D
> ZYNQMP_AES_KUP_KEY) {
> >               tfm_ctx->keylen =3D keylen;
> > -             if (keylen =3D=3D ZYNQMP_AES_KEY_SIZE) {
> > -                     tfm_ctx->keysrc =3D ZYNQMP_AES_KUP_KEY;
> > -                     memcpy(tfm_ctx->key, key, keylen);
> > -             }
> > +             memcpy(tfm_ctx->key, key, keylen);
> > +     } else if (tfm_ctx->keysrc !=3D ZYNQMP_AES_KUP_KEY) {
> > +             return -EINVAL;
> >       }
> >
> >       tfm_ctx->fbk_cipher->base.crt_flags &=3D ~CRYPTO_TFM_REQ_MASK;
> >       tfm_ctx->fbk_cipher->base.crt_flags |=3D (aead->base.crt_flags &
> >                                       CRYPTO_TFM_REQ_MASK);
> >
> > -     return crypto_aead_setkey(tfm_ctx->fbk_cipher, key, keylen);
> > +     err =3D crypto_aead_setkey(tfm_ctx->fbk_cipher, key, keylen);
> > +     if (!err)
> > +             tfm_ctx->keylen =3D keylen;
>
> You can't have a fallback when there is a hardware key.  How did
> the fallback not return an error here?

We have two types of key registers
1) Registers to save user supplied keys like ZYNQMP_AES_KUP_KEY
2) Register Where H/W internally generates the keys like ZYNQMP_AES_DEV_KEY=
 and ZYNQMP_AES_PUF_KEY

Fallback is for 1), because driver has saved key in private ctx and can be =
fallback to S/W.

>
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

