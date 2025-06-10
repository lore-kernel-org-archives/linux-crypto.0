Received: from AS8PR03CU001.outbound.protection.outlook.com (mail-westeuropeazon11012031.outbound.protection.outlook.com [52.101.71.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE0947083C;
	Tue, 10 Jun 2025 05:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.71.31
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749534929; cv=fail; b=EfbNZAdXKvB03+ddvhmalLkHLN+1x+Qp0QKbQczDN5KbBXiRJ7hoYIqZYoKmT4bNJRPDIDHxMdoUxq4cD+an1tPFDQsDcH+KMCp/tO+sceCVONQVdIiKpKrbECDe7kS4sJUKwinawws1DQ0aEIsoEZDOVJNRlvnKZWXp0JLSEuc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749534929; c=relaxed/simple;
	bh=xxrLcgKRscidFx2kNQnGexVe6iKhmZ3jLx9FT/Sozfc=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=D6wEWLXTq4SFSF/gD8NCqovNPjIULIRPO0quF/NJNPkHKndwIiiHU/1u6yYEPsclupqaEHH9C4UZxJn0Z80Vu5VnbTKo5Km6umJluO+tnH5w514Z2Ra/JjrquYShjorbCbHLFTKvoi2R771fgFK+BYScdq0HeQQWM+2U+c8zu1Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com; spf=pass smtp.mailfrom=nxp.com; dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b=LI1TQP0N; arc=fail smtp.client-ip=52.101.71.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b="LI1TQP0N"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IEe0zd9kXpsI2I68tPQHUCybAcZD2pi9eWtgTthhM4dXt0T8yGbk/+2DpIaQz5wXnNcva9+yhUQ55hYI7QoKhICvvC/tapLjoIQvxGgsBjQ2NuwPs7XDjdLciGhsTecVfl1j/fbBUFm4DqO/DiNsa9mspc/QwWy9PbxOD2Zuxh5ND39aBpkB3vKYN5FF6T1fLMDSNRzbGTHPeWYRnL0BhUs4FO9KiMi+zZO+j0/GTvWF1J1qdUuOXAItGl3tGqoKqSr6h0RhTCpgmo/nIlPPXg332K81SkabT/t4lmdSO8quF0F4MQwIdxJP9wf1eGyecDptqHFahA/eVcfpTcKYFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VJJiCEYUZ4zj6zh8JDwj6A0me5/fNZZ9hALenFMJPGw=;
 b=RVoGtnVsl8Ru0bzveUW2sbUGFc73CiPXTbWtHaZfsRzt2ZtrOu4hdEpWyEVTCu/G53TPolfspv5yTZGwSmeNoOidE2MldYCYqNDD41Mg9s5U1h2jeuZjuOit1pjiC6yhq+bmbvXOf9N06rZfpApKDuGA8AE2FCBKLNpcpCOu1wAz16uBSx4HTC+d34bfAWo1RYT/6A1o1iyUQ9Lx+AGI2KBZ6k5CVxleW9REIAoT+txRgTEJlsRIl88Bwuz7hO0Gbq/yH8FpiZQ0bNumT1tnnP0y8fP2eEVM7ScmT5stZG4hlZLy3VLqr1gwcMgsgns6PplYnTSUbrwrfSMEih7L3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VJJiCEYUZ4zj6zh8JDwj6A0me5/fNZZ9hALenFMJPGw=;
 b=LI1TQP0Nfrz6MkEqeJ7ClicttnLbaBuuq9oOCy2TwPOci+NGojEGeC57JSAYXcTqv+uhBsz8iZOHttiplPnXasShUbXlpGWbb783fCmxELGwkqn4xnYz9lc5E2Aw/B/JGzLlT6OIcwc5XDqhiOlL7jsiGqOxCB984jfxnJ0RCLQ6L8oznZt5sdqd1v2XUlJ4nCGNcH+uT8Hj+WnS+C1MqPSD6gTrn/wzQ8e2FvbMT8vGksHMmbSFjcvf2ODXGx0e57iRGSHQsTCWVpkbF0/KB/O+9RNYUCkZxuLs3dxVtvLwmIF08XWjOqCvIqnZxnZ8rOHVrrke4IRVfZkI+cdjpQ==
Received: from PAXPR04MB8301.eurprd04.prod.outlook.com (2603:10a6:102:1c5::16)
 by GV2PR04MB11422.eurprd04.prod.outlook.com (2603:10a6:150:2b2::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8813.24; Tue, 10 Jun
 2025 05:55:23 +0000
Received: from PAXPR04MB8301.eurprd04.prod.outlook.com
 ([fe80::85de:cf79:69cf:4833]) by PAXPR04MB8301.eurprd04.prod.outlook.com
 ([fe80::85de:cf79:69cf:4833%3]) with mapi id 15.20.8813.024; Tue, 10 Jun 2025
 05:55:23 +0000
From: Meenakshi Aggarwal <meenakshi.aggarwal@nxp.com>
To: Gaurav Jain <gaurav.jain@nxp.com>, "herbert@gondor.apana.org.au"
	<herbert@gondor.apana.org.au>, "davem@davemloft.net" <davem@davemloft.net>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] crypto: caam - Set DMA alignment explicitly
Thread-Topic: [PATCH] crypto: caam - Set DMA alignment explicitly
Thread-Index: AQHb1TmIn/rd5TTIBUO5sR+yGK98O7P0QxIAgAeq3mA=
Date: Tue, 10 Jun 2025 05:55:23 +0000
Message-ID:
 <PAXPR04MB83017021568C4B43DDB039B68E6AA@PAXPR04MB8301.eurprd04.prod.outlook.com>
References: <20250604101446.3993932-1-meenakshi.aggarwal@nxp.com>
 <DB9PR04MB8409F4DE065B0EBFD9B45D2CE76FA@DB9PR04MB8409.eurprd04.prod.outlook.com>
In-Reply-To:
 <DB9PR04MB8409F4DE065B0EBFD9B45D2CE76FA@DB9PR04MB8409.eurprd04.prod.outlook.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PAXPR04MB8301:EE_|GV2PR04MB11422:EE_
x-ms-office365-filtering-correlation-id: 72aad7c5-5012-4bfd-aaa7-08dda7e363e5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|376014|7053199007|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?JFHDmoLZ8aR7MNoG/JLIPMBy8HpsDSd7VZi7+AsG48mLmL7HmdCUgUfV5Wsd?=
 =?us-ascii?Q?2LJcnRDT6LciqhKJWQuko9SXo3dbIl/tQ+vsqnHLjkfIcV342EZPQedfFYZx?=
 =?us-ascii?Q?2fqfE6cZLcK1BkO9n5E8GrQaFxAEhPNKcKvESOFJLfGjKxtJfYus1wKZ5y6a?=
 =?us-ascii?Q?dSCzv9bWRUno2iiq/Mg9SZ1zfeNpesbAsiLSsZZO31nD/8n64fex4aFHMTp0?=
 =?us-ascii?Q?muQpnNBtHaq2er8SqSe4WapuPQhWY9cD/jplTgmlTzE4nYyxsgTUOMa8o7nW?=
 =?us-ascii?Q?zM2BdhLgEsQi4rp2nZjrN1V6XkD3yPAPxOAEh4UuzNjAWd7O8TwDWrzdopqa?=
 =?us-ascii?Q?UAEpB2yokOes4L8nWJUw7RFV3VFHOQE8c6qdsp/vfEVTNPI4DNMFfIwI8x+O?=
 =?us-ascii?Q?mGiox6C8UeQKwhO3NQNBYbyOY7v12WZfOMIOhepOGrCPf/Bxw1p5oc7fDQEP?=
 =?us-ascii?Q?Dh/wwAn0dOd2KLY6gtB5h13TZvJ5R2jT9vNU0MkE9wPPOdzIWZ+YvvvepReE?=
 =?us-ascii?Q?6+nJkGS2NxlYJQrH3XDKwQbBAnaqDxk+w7LRsZsCXZR/met+rmU5wAtm81Sw?=
 =?us-ascii?Q?uRyI77v/cf2qWuR0iOSb7dlfyKUyqwChxUyfSsehwhWxdwqoPb9qBu4UfgpI?=
 =?us-ascii?Q?GawQQyOFY8fkN5PlrKxRr+B6I3HJTKLf/QGV3ImB+ZDmKmdeP14C05r7l4IH?=
 =?us-ascii?Q?QQSQ7KWmbpK1WmBlfOWDX5CcBgqWtSmL1HrgigySBgyw8KlDnwhCbrYVSO1P?=
 =?us-ascii?Q?5hZjVTElJTlP4ZOX/Mdoo1s4HnABYW799XiD4gNAlnFKfFEYgllXdRiV2OU7?=
 =?us-ascii?Q?PUc4xNPWNNyg3b5QmDdRgPu/6nL3c6u8ahWoTCnh7St7iUgCigQpVsnjvkmc?=
 =?us-ascii?Q?P+vBrYrhJylCPUBn7fR2C4/DSRQ3I+BAPOHRILtpbOEJpeg9AmHDXnj0KG/N?=
 =?us-ascii?Q?SdNFf3kkVsfc6Svb+3JkKvBuZCPP9Y+9s7tSyt5k6oiIyUaL12+s7WMdCEOK?=
 =?us-ascii?Q?yKsXxb1XMhjDTvG8nNAOyCjF5wFusvjy5P5dn4oMU1we/c3qKio7/MNsZLy7?=
 =?us-ascii?Q?ANDnbyfaw0w5VzvYQGTeQz8Woje1k9rmKpwCpPrS1q7CGyE/ULh+hOGO+y9h?=
 =?us-ascii?Q?omty5SdHGW2WZ28BHx2ck6HpPVfvZU6sLDq+7AXRpIaAhsOSPAl64A/kFxuN?=
 =?us-ascii?Q?yfdmfBgBqeHviXga7hGo7KM32mP8CNTNc20hrxihTyequjnzdkserOI1QqzJ?=
 =?us-ascii?Q?jw9s0qnqxQAmr4PPQWO/834IKK2FJh4CLsjvAvYlU64nPStgtN9vnj91ZW00?=
 =?us-ascii?Q?8WnX7+NS26Xg+cxFtD2MhE/48mamTE38NP+/ev8Hor673Z7VFw6Kqg2tL5iZ?=
 =?us-ascii?Q?xnraUYtNUHKduvjreeBr2VQFRuLeq3BykH3LUl72WPDuTlZoQ+751lVZ7F0N?=
 =?us-ascii?Q?80fC9O1lYwrafDhZ2HBC5qaXHUWVMC6UruyZ6vl7DzCbexdkJU1/xPQ95V7y?=
 =?us-ascii?Q?y9yYxckzsL8x05k=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB8301.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?Sy2czCBWloQVq1h1C5oGXirMsiaeg35WOhj+ndZTUOgHPBYkUR4D2YO3r+WE?=
 =?us-ascii?Q?lLPFGR55Q03qZXyEASBZhvr20b6eeLr/pSdCY2VjVbQrHHyg4zLbOuju08G3?=
 =?us-ascii?Q?GCg8XgNcl3g1/4hxtf8uGOxtVBwrOF/zVfNHKpZc93zWtvtu0zMdE+PiV/Xu?=
 =?us-ascii?Q?sDhtR1rfNxo5RdSM6fyIgho/pGJrECBKDnnydz4qM+/PbOKm/Z5XGf0xgGbU?=
 =?us-ascii?Q?xhzSei2uzia+tNUT+s9pcW8tjsaXnkKUU4v4EO+fzWo7/4bUIWcWy+n56v1q?=
 =?us-ascii?Q?LjwanxY/5ul7TKOHw0RrLrRp+J1e3oAl18efPkqA7j2ioHesSRGrl0r+9OpU?=
 =?us-ascii?Q?jIhb0WK+rh2IqH6fx4IXVIA5l8qyspla6NqXJP9Z0Z9cgOwGYkG38+pHOB9n?=
 =?us-ascii?Q?s8jSBxdwNx/XPRkX20G8inYGefUVPzGwn9EqwZmraxaBdpLnIIS8mP+/x0Ua?=
 =?us-ascii?Q?1ukItjqMx3JCff6fYPpmqnFFA9XtBIXIWWNXDRtGsUKzfvp9DeH9wC8mbC8Z?=
 =?us-ascii?Q?znNKLbS8f+QLtN4FCuWq78nb7UbXEiRAiN7Q+I3VsapCm6XrkfGTrZP2aYy0?=
 =?us-ascii?Q?n/KUbUh4PqPtkpsQumgNTiQdrwEieUd8OPOIZKbpCF9KRo61ERz/8zCt4tya?=
 =?us-ascii?Q?bjKpfM3YXAE8k04J8A1HzsTrEx92A8dc0+nA4szxXp2YzhAYDl6Q6vDKKG8l?=
 =?us-ascii?Q?mgYLT7Eqjgzac5tcq8qIcTXiTUFKnHdeblYIonkPc+ScgyZLfkApT6Z+nEHK?=
 =?us-ascii?Q?OO4WpGp1Gqd4OdjrJKvQnmOjM8iIcEj6Zlv2oe5b4WPWB33FABkK9ThS+xgg?=
 =?us-ascii?Q?xRwFbbyo/AS0GeEVTVWyVHbBGv8abZvAPjpNtAUXdRHJ/2HUrkrUrsz4U5sG?=
 =?us-ascii?Q?v1Ez40FsMkhibqeNUbpGOyyvFVs3OA3yMwgf9Qgx72aqyikafjh1N047rKkY?=
 =?us-ascii?Q?1TPyp2p0a6GWxaRfZVAutPiXG5NuHWZb7VuNJzn3W4ww9V2iRuhYqYfHIx0B?=
 =?us-ascii?Q?oaSGTHt3Yfmhu37kNS+j9z0SKC23pkzOGdICLU0kD1sNzlBaVsWy8/dZMz9F?=
 =?us-ascii?Q?PjEDotx/4V8biOPH/2fW1F2hqkt+DQha1GMLVZQXwXnLJQYWDd3T95AdfoVD?=
 =?us-ascii?Q?DkD49iR8D3g5NLxizZc5ftefN2ig9hAU645aJRNaFqRQ+yWWPufptaqQ+6/l?=
 =?us-ascii?Q?a0u6Ws1fhHBjAFN3/4w/LkeOMw7JmSUdCVooIqyX9whVoRrI4yHUwCtOE/SG?=
 =?us-ascii?Q?wBADfpaxHIQqVJ/GtC2ToSZi77ZQJaY5x8CkSueQAx593szTUviFRjbA2ITy?=
 =?us-ascii?Q?tDsnsLquJ8ytTfCXrX1d98W3ev92tgxmZDtdtx722lma2okVQjRuxW9gBA92?=
 =?us-ascii?Q?xmGpBrizlZDubgfTUNM8EE4oRbc3YOWkbd8amIvLrj6BfhdxtRtSPBwQMxbU?=
 =?us-ascii?Q?1LmdAGbXKGgWR2FwssQ7AdaGWpufmO2zgDV0H/TwMHBH2qvWpWLBSYKvk+Yl?=
 =?us-ascii?Q?fXxhP7sjseQ0oFA/BuLQXoBZjpgTLqqHM+aKZ46wTVxcxfDdmzOh0IDx5v+n?=
 =?us-ascii?Q?6ebDsQbNgom+zS7r525OFDLoI5gnwtRVXabvdwO9yM54kEdh8rL5mlOL9Ese?=
 =?us-ascii?Q?/A=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB8301.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72aad7c5-5012-4bfd-aaa7-08dda7e363e5
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jun 2025 05:55:23.1848
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yC+HWpzc9VlOUCTMaC77gtPSb4nXyQUqkAJftxrH+uWupPk6JgkAcaSOzgrodl750W3SRQwHt85IVEPQSeGFR/7MG6cF7aeJ8jaylQ7/rF8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR04MB11422

Hi Herbert,

Please accept if no further comments.

Thanks,
Meenakshi

> -----Original Message-----
> From: Gaurav Jain <gaurav.jain@nxp.com>
> Sent: 05 June 2025 14:20
> To: Meenakshi Aggarwal <meenakshi.aggarwal@nxp.com>;
> herbert@gondor.apana.org.au; davem@davemloft.net; linux-
> crypto@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: RE: [PATCH] crypto: caam - Set DMA alignment explicitly
>=20
> Reviewed-by: Gaurav Jain <gaurav.jain@nxp.com
>=20
> > -----Original Message-----
> > From: Meenakshi Aggarwal <meenakshi.aggarwal@nxp.com>
> > Sent: Wednesday, June 4, 2025 3:45 PM
> > To: Gaurav Jain <gaurav.jain@nxp.com>; herbert@gondor.apana.org.au;
> > davem@davemloft.net; linux-crypto@vger.kernel.org; linux-
> > kernel@vger.kernel.org
> > Cc: Meenakshi Aggarwal <meenakshi.aggarwal@nxp.com>
> > Subject: [PATCH] crypto: caam - Set DMA alignment explicitly
> >
> > From: Meenakshi Aggarwal <meenakshi.aggarwal@nxp.com>
> >
> > Few DMA alignment were missed in the original patch.
> >
> > Fixes: 4cb4f7c11dee ("crypto: caam - Set DMA alignment explicitly")
> >
> > Signed-off-by: Meenakshi Aggarwal <meenakshi.aggarwal@nxp.com>
> > ---
> >  drivers/crypto/caam/caamalg.c    | 22 +++++++++++-----------
> >  drivers/crypto/caam/caamalg_qi.c |  4 ++--
> >  2 files changed, 13 insertions(+), 13 deletions(-)
> >
> > diff --git a/drivers/crypto/caam/caamalg.c
> > b/drivers/crypto/caam/caamalg.c index 2cfb1b8d8c7c..81dfbe436c20
> > 100644
> > --- a/drivers/crypto/caam/caamalg.c
> > +++ b/drivers/crypto/caam/caamalg.c
> > @@ -980,7 +980,7 @@ static void aead_crypt_done(struct device *jrdev,
> > u32 *desc, u32 err,
> >  			    void *context)
> >  {
> >  	struct aead_request *req =3D context;
> > -	struct caam_aead_req_ctx *rctx =3D aead_request_ctx(req);
> > +	struct caam_aead_req_ctx *rctx =3D aead_request_ctx_dma(req);
> >  	struct caam_drv_private_jr *jrp =3D dev_get_drvdata(jrdev);
> >  	struct aead_edesc *edesc;
> >  	int ecode =3D 0;
> > @@ -1020,7 +1020,7 @@ static void skcipher_crypt_done(struct device
> > *jrdev,
> > u32 *desc, u32 err,  {
> >  	struct skcipher_request *req =3D context;
> >  	struct skcipher_edesc *edesc;
> > -	struct caam_skcipher_req_ctx *rctx =3D skcipher_request_ctx(req);
> > +	struct caam_skcipher_req_ctx *rctx =3D skcipher_request_ctx_dma(req);
> >  	struct crypto_skcipher *skcipher =3D crypto_skcipher_reqtfm(req);
> >  	struct caam_drv_private_jr *jrp =3D dev_get_drvdata(jrdev);
> >  	int ivsize =3D crypto_skcipher_ivsize(skcipher); @@ -1309,7 +1309,7 @=
@
> > static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
> >  	struct crypto_aead *aead =3D crypto_aead_reqtfm(req);
> >  	struct caam_ctx *ctx =3D crypto_aead_ctx_dma(aead);
> >  	struct device *jrdev =3D ctx->jrdev;
> > -	struct caam_aead_req_ctx *rctx =3D aead_request_ctx(req);
> > +	struct caam_aead_req_ctx *rctx =3D aead_request_ctx_dma(req);
> >  	gfp_t flags =3D (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
> >  		       GFP_KERNEL : GFP_ATOMIC;
> >  	int src_nents, mapped_src_nents, dst_nents =3D 0, mapped_dst_nents =
=3D
> > 0; @@ -1445,7 +1445,7 @@ static struct aead_edesc
> > *aead_edesc_alloc(struct aead_request *req,  static int
> > aead_enqueue_req(struct device *jrdev, struct aead_request *req)  {
> >  	struct caam_drv_private_jr *jrpriv =3D dev_get_drvdata(jrdev);
> > -	struct caam_aead_req_ctx *rctx =3D aead_request_ctx(req);
> > +	struct caam_aead_req_ctx *rctx =3D aead_request_ctx_dma(req);
> >  	struct aead_edesc *edesc =3D rctx->edesc;
> >  	u32 *desc =3D edesc->hw_desc;
> >  	int ret;
> > @@ -1541,7 +1541,7 @@ static int aead_do_one_req(struct crypto_engine
> > *engine, void *areq)  {
> >  	struct aead_request *req =3D aead_request_cast(areq);
> >  	struct caam_ctx *ctx =3D
> > crypto_aead_ctx_dma(crypto_aead_reqtfm(req));
> > -	struct caam_aead_req_ctx *rctx =3D aead_request_ctx(req);
> > +	struct caam_aead_req_ctx *rctx =3D aead_request_ctx_dma(req);
> >  	u32 *desc =3D rctx->edesc->hw_desc;
> >  	int ret;
> >
> > @@ -1614,7 +1614,7 @@ static struct skcipher_edesc
> > *skcipher_edesc_alloc(struct skcipher_request *req,  {
> >  	struct crypto_skcipher *skcipher =3D crypto_skcipher_reqtfm(req);
> >  	struct caam_ctx *ctx =3D crypto_skcipher_ctx_dma(skcipher);
> > -	struct caam_skcipher_req_ctx *rctx =3D skcipher_request_ctx(req);
> > +	struct caam_skcipher_req_ctx *rctx =3D skcipher_request_ctx_dma(req);
> >  	struct device *jrdev =3D ctx->jrdev;
> >  	gfp_t flags =3D (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
> >  		       GFP_KERNEL : GFP_ATOMIC;
> > @@ -1778,7 +1778,7 @@ static int skcipher_do_one_req(struct
> > crypto_engine *engine, void *areq)  {
> >  	struct skcipher_request *req =3D skcipher_request_cast(areq);
> >  	struct caam_ctx *ctx =3D
> > crypto_skcipher_ctx_dma(crypto_skcipher_reqtfm(req));
> > -	struct caam_skcipher_req_ctx *rctx =3D skcipher_request_ctx(req);
> > +	struct caam_skcipher_req_ctx *rctx =3D skcipher_request_ctx_dma(req);
> >  	u32 *desc =3D rctx->edesc->hw_desc;
> >  	int ret;
> >
> > @@ -1828,7 +1828,7 @@ static inline int skcipher_crypt(struct
> > skcipher_request *req, bool encrypt)
> >
> >  	if (ctx->fallback && ((ctrlpriv->era <=3D 8 && xts_skcipher_ivsize(re=
q)) ||
> >  			      ctx->xts_key_fallback)) {
> > -		struct caam_skcipher_req_ctx *rctx =3D
> > skcipher_request_ctx(req);
> > +		struct caam_skcipher_req_ctx *rctx =3D
> > skcipher_request_ctx_dma(req);
> >
> >  		skcipher_request_set_tfm(&rctx->fallback_req, ctx->fallback);
> >  		skcipher_request_set_callback(&rctx->fallback_req,
> > @@ -3639,10 +3639,10 @@ static int caam_cra_init(struct
> > crypto_skcipher
> > *tfm)
> >  		}
> >
> >  		ctx->fallback =3D fallback;
> > -		crypto_skcipher_set_reqsize(tfm, sizeof(struct
> > caam_skcipher_req_ctx) +
> > +		crypto_skcipher_set_reqsize_dma(tfm, sizeof(struct
> > +caam_skcipher_req_ctx) +
> >  					    crypto_skcipher_reqsize(fallback));
> >  	} else {
> > -		crypto_skcipher_set_reqsize(tfm, sizeof(struct
> > caam_skcipher_req_ctx));
> > +		crypto_skcipher_set_reqsize_dma(tfm, sizeof(struct
> > +caam_skcipher_req_ctx));
> >  	}
> >
> >  	ret =3D caam_init_common(ctx, &caam_alg->caam, false); @@ -3659,7
> > +3659,7 @@ static int caam_aead_init(struct crypto_aead *tfm)
> >  		 container_of(alg, struct caam_aead_alg, aead.base);
> >  	struct caam_ctx *ctx =3D crypto_aead_ctx_dma(tfm);
> >
> > -	crypto_aead_set_reqsize(tfm, sizeof(struct caam_aead_req_ctx));
> > +	crypto_aead_set_reqsize_dma(tfm, sizeof(struct
> caam_aead_req_ctx));
> >
> >  	return caam_init_common(ctx, &caam_alg->caam, !caam_alg-
> > >caam.nodkp);  } diff --git a/drivers/crypto/caam/caamalg_qi.c
> > b/drivers/crypto/caam/caamalg_qi.c
> > index 65f6adb6c673..9aa2d6d97f22 100644
> > --- a/drivers/crypto/caam/caamalg_qi.c
> > +++ b/drivers/crypto/caam/caamalg_qi.c
> > @@ -1435,7 +1435,7 @@ static inline int skcipher_crypt(struct
> > skcipher_request *req, bool encrypt)
> >
> >  	if (ctx->fallback && ((ctrlpriv->era <=3D 8 && xts_skcipher_ivsize(re=
q)) ||
> >  			      ctx->xts_key_fallback)) {
> > -		struct caam_skcipher_req_ctx *rctx =3D
> > skcipher_request_ctx(req);
> > +		struct caam_skcipher_req_ctx *rctx =3D
> > skcipher_request_ctx_dma(req);
> >
> >  		skcipher_request_set_tfm(&rctx->fallback_req, ctx->fallback);
> >  		skcipher_request_set_callback(&rctx->fallback_req,
> > @@ -2524,7 +2524,7 @@ static int caam_cra_init(struct crypto_skcipher
> *tfm)
> >  		}
> >
> >  		ctx->fallback =3D fallback;
> > -		crypto_skcipher_set_reqsize(tfm, sizeof(struct
> > caam_skcipher_req_ctx) +
> > +		crypto_skcipher_set_reqsize_dma(tfm, sizeof(struct
> > +caam_skcipher_req_ctx) +
> >  					    crypto_skcipher_reqsize(fallback));
> >  	}
> >
> > --
> > 2.25.1

