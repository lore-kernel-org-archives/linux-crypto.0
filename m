Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2040.outbound.protection.outlook.com [40.107.20.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1128A25760;
	Mon, 18 Nov 2024 09:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.20.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731922274; cv=fail; b=eat+e5UC2F/evLAWSzST7dxdmc/oIl4khFSsGrj2crEdNrXTKiPUOU17Kh1XZjUT45vsPBMUPVNI/bxtSsGZYD44CAVF+1dA04L8V5+XQkWwAQCU8gCCH4l1ZxMzcOsE0SaHOE7t9uo4l2Ce4P5GMVM81WNz4VHzkhtXxZtOPZs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731922274; c=relaxed/simple;
	bh=qHUh0pghp0MZ1K1sLiLFwzBxnVC7aUXOP9S3TUzIYfA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=hO1zbm7ug6AVI+MZg16FzdG7oXqtOrF7rHEjKGylsEOGkQItlfZoozASyxrt6ZHoKW6srg7gARN8upwakg5axSB+0aUXowW+/oujaEc8ybpRW6olXFgKJgYOp2GnalE++AykZDVOYwj779GTDMvniYXiYrMZ6hZzmAcARGdQ0ac=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com; spf=pass smtp.mailfrom=nxp.com; dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b=ZEvguqNX; arc=fail smtp.client-ip=40.107.20.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b="ZEvguqNX"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YGmd7641N5UiGEc0wV+A903yw2o+0Z7dZCpTM+JoqUMqYteXke0N7HfamPHDE7Mqj20aMKfeez5lqppZraJ3giFtXu1mfQe7Oon7TTSkC5EdbvKIU4yh9Xlo9xorHgTR6nxuFKkU0vx0PPWY5W5yK/Ulb+DEndLYwtc1zOHNa26oNl0J9OE9h+ZC7feresYr+5SBQ3Lp3fpxi6oJ5qXpew1ENTX92RstogjFQUUWWB467myHwfrKcdk+CqSwVB4Dr8EcGL2QmH6tJCbMTY7Op2g9MMURZyx68C7UT1uM0blZl7BdSID6ujv93QQ+UIuYN1sDZxUQz6V2zlQpT4Z3sA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+F9th1cRA0LBSfCt+oAbOzzz5HmE6n+LTQyzqzn+S78=;
 b=RwVrcsNmVrDqRNFcOnv7D/2koP634SZU5knZMWOlK0YnPymUYIHBWQZZhsxu5GEtODf/6ZVcgYcPhJFiGIH/Cx2K2KOGBaxwia8CisFR4Le9rpLTmOuTgmDjQY/qDGd1w+cB9qfi3fI3ihdd6vdaaKmcx/P3jpaI84/f9UgUOlLqVhS4eUBPge7mcJwmljBhE47RCebuqKiI5W3Er1d1TfvtoJbzyDIPuK3y0JGYcP5zDNDFT/l1k1JW2qML7sD7ioKOUDOnbHrL4N4/JUZ23Zjpy9M+QLlEmSdPyuhOOXsAko0Vz11DNVFsAdRJ1EMVqmv3SgbwJsHUDyby2Vj+LA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+F9th1cRA0LBSfCt+oAbOzzz5HmE6n+LTQyzqzn+S78=;
 b=ZEvguqNXfERUnJqhnKehtXrqS7fMS3iaZiMvI6cLYCFoUkdEaHHjrNdSz2S2AxnIjvfeLJXH9WMPhd/tJghNjZcngcOY3+g1Y+Bu1XcvOhRAvkaLizTKrufOVnfzjBkmY1bVfPbbUwbECf46T306HpF8WVdzp4FxhAsCMqHRUMGN5VwqvdbVegvg7bROWfFg5aAEkaQqihWyX3+zVZew6v7lxiaLbguBfU6/NVQiRpa2Voxj81JMQtG/50btXSBQPWgUDRlmsx9qwIlA2MSqK6L06U6hwvjEU+iDwnthbJ9xUvwKjZiXXD8tv01ORIDkuBAcKXMEuFZcUrZ/0iCsSQ==
Received: from DB9PR04MB8409.eurprd04.prod.outlook.com (2603:10a6:10:244::6)
 by DU4PR04MB10648.eurprd04.prod.outlook.com (2603:10a6:10:586::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.22; Mon, 18 Nov
 2024 09:31:07 +0000
Received: from DB9PR04MB8409.eurprd04.prod.outlook.com
 ([fe80::1436:d8ba:25b8:1637]) by DB9PR04MB8409.eurprd04.prod.outlook.com
 ([fe80::1436:d8ba:25b8:1637%3]) with mapi id 15.20.8158.023; Mon, 18 Nov 2024
 09:31:06 +0000
From: Gaurav Jain <gaurav.jain@nxp.com>
To: Ahmad Fatoum <a.fatoum@pengutronix.de>, Horia Geanta
	<horia.geanta@nxp.com>, Pankaj Gupta <pankaj.gupta@nxp.com>, Herbert Xu
	<herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>,
	Silvano Di Ninno <silvano.dininno@nxp.com>, Varun Sethi <V.Sethi@nxp.com>,
	Meenakshi Aggarwal <meenakshi.aggarwal@nxp.com>, Sahil Malhotra
	<sahil.malhotra@nxp.com>, Nikolaus Voss <nikolaus.voss@haag-streit.com>
CC: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Pengutronix
 Kernel Team <kernel@pengutronix.de>
Subject: RE: [EXT] Re: [PATCH] crypto: caam - use JobR's space to access page
 0 regs
Thread-Topic: [EXT] Re: [PATCH] crypto: caam - use JobR's space to access page
 0 regs
Thread-Index: AQHbNDLCDWLDusYcd0ahxOrmX4dKwbKyAD2AgArNUHA=
Date: Mon, 18 Nov 2024 09:31:06 +0000
Message-ID:
 <DB9PR04MB8409AC6672B7A209ABC8F9DAE7272@DB9PR04MB8409.eurprd04.prod.outlook.com>
References: <20241111121020.4013077-1-gaurav.jain@nxp.com>
 <93e915b3-ef8e-4b98-aa7f-7759ae0b3091@pengutronix.de>
In-Reply-To: <93e915b3-ef8e-4b98-aa7f-7759ae0b3091@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DB9PR04MB8409:EE_|DU4PR04MB10648:EE_
x-ms-office365-filtering-correlation-id: 3559069f-394f-40b6-1c7c-08dd07b3bab2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|1800799024|366016|921020|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?sC6FhPUgcCd/eQe9i918y0/NCmT+NfVYqxR3XLOPwahsCk8Epr7U2+qe5iZ6?=
 =?us-ascii?Q?qoaUwpmm3+GJnH3zd8tdtDU+uCYMxT1wy3LJvWxqwzvbHkmjBpH2QEsft5hw?=
 =?us-ascii?Q?c7ZIo7ayn0SAxOI3SVbtf1ItH1vfHinsnCbg22w0WGIzJ2Hpz/PrkaCTlYBw?=
 =?us-ascii?Q?khRRBicFZ0pVD+EsQeJe4ik/o7F0MhJeYBEFGm1ZoreYIuf2r11vCgAUc0ck?=
 =?us-ascii?Q?2C/sMT1GLzWBtxrQnJB9rAMWX4hyxurC/Pr0zrFfMTvuWqsBaQ3w/KyjCbLW?=
 =?us-ascii?Q?MwLUf737AB6Naoq8I54hpFZRpfLxO3NmRCCtMVrE5pPl3SP9XaZ0s7Lca3Nb?=
 =?us-ascii?Q?NqUaGAEW+esRJmtPtLyRn++xq/BLHOQrVVBlT8Pajvi3KEMBXExDqYUfED/x?=
 =?us-ascii?Q?hw74VZAFtEVB3rQcPOTqnxXpuiD6a5wq1kBwYQWBbYM4erz/00q49TUku9CK?=
 =?us-ascii?Q?lxT1TkaJUa54P9NLnl4yTuryuqMFl0+TN2fC3ivmaWDykJ3MdN7mSSav0W8O?=
 =?us-ascii?Q?Tt+XhUZp0g48aiQYdZv0l7IPzAAxDcxWNkFQUVc5Fk/mNrQebC6oRKrxTz9q?=
 =?us-ascii?Q?GVUO1ZkFOnOvdhOQMegpUDTDJIOxBS/Ac0IhyWBi4KCgc+b1Vmp3B9utaAu4?=
 =?us-ascii?Q?AX5t/OmuDx2mCc5iPV678xMwFnYLnnHkc8yAwQoW6sPCoHZOIRhT4odexBGM?=
 =?us-ascii?Q?Xndhi6jX0XsgLqiqRtkCY/JTkuJkoi5jwy/x9Dv1ZXmmQ3MEvkf9bnIvgj44?=
 =?us-ascii?Q?1GkX476by2NmOdfX/mzCAtWqZGX11LUb1QfE86AZDclTXQqVAxwK2Gfo/9/i?=
 =?us-ascii?Q?sFj+xfy0/WTIK1WrfENzQwCh7Gwank51Azixw/tZrzZm8wRpgy5Z3lsIKo9P?=
 =?us-ascii?Q?8ut/gUoDO70IDqZQp4YOiSLyjlc50lmeXuMsOi8ugdZfAiIga5rzMWjav9sB?=
 =?us-ascii?Q?UJKGWN5Q2c+PfJPSpjSztw3oayOrl0yQHiZqsGlFl6TPQhQVvHhkYhe1L/lM?=
 =?us-ascii?Q?Ats0fr2ntaBz7+kkTDoGq9hu1OJOpIc8boYmJtM5n1hJqfdjZqDXONH5OsBi?=
 =?us-ascii?Q?8OoLHrcUwT3CG7zCONo/ARRF+1I9fD4FoT/tABR8M5kDaBk1Nn4o611f3ud/?=
 =?us-ascii?Q?3u/Q6KpmXiT4kRRrsYmbnFZl4MRfOG/VWMpjbIwvIqs97y7QkJ8VDIe7V2HB?=
 =?us-ascii?Q?OC1tmYgObL7eFjiGCDGVLYB2GD7hTs0bMTSGlJDizddA5ZI70Jwu/osyRd7z?=
 =?us-ascii?Q?SH/qSfAIALx0/GOOeRcT3F7Y2jGwsTmB9JPGpVJu/JazgZiFlnfAuRuTsySF?=
 =?us-ascii?Q?E2MyuCeOA6R2gEtb3dNanSWDttdCF2vhz1DuPl8B31vMB5WfPCXLZZmpxmLp?=
 =?us-ascii?Q?qteY/IMjy6aaWMPTesRemZZ4ujvU?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8409.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(921020)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?QMesBmPdUT04AtouJoWWAbzjtD2mquUPJiOvbgi/OgkmW/2P3m1akz43HobZ?=
 =?us-ascii?Q?lLhRYdbDJRNTZg64sYN9xFH12GqTng4E43tQy7Um0KgnFfsxMO59V27P2u0S?=
 =?us-ascii?Q?HMknLqfnHloim2zFr+APLPDYuB72mDCtkfAa8CopsHxe0lgawWnOh5z/IAEY?=
 =?us-ascii?Q?ZcfT2wiWWPMWpeZtu2UZbz0ibyUlKnEnonNpCx7CKuE+zgJVfgfvDFGhrqo0?=
 =?us-ascii?Q?VsNaNhnpS/Xc3/pTUY+o4koHvbyns01HZBBrVkUwPAf3C0X0bKB1Q3pTOoVE?=
 =?us-ascii?Q?n6zsNZKvoi0VLzPJqkgf4SEja7ROprpo3+kTYhlAeBMbcSOV+gArX6Shd7Yr?=
 =?us-ascii?Q?UVrSRXqDOI9Y5151Lz2alVp8iP3L+xChB6v+PF0VZKG2aab13LqtKIOay7JU?=
 =?us-ascii?Q?Zbqhl6UtY7lhpKXF1PM7Q0/v9lvMZPp2yVA/kddSVoV+lGjQ7fkPDhsBYfyj?=
 =?us-ascii?Q?07GMbUF7O/CwL9eKSUcrUu6wXTYotprXo2zVp50Dtbzqc5uthLj5AvkoB3lN?=
 =?us-ascii?Q?ShYpzsRZBsO4rTOZ404Wxq1L+kN518+ToFeE94s8KwJB6IIYUOb9Kq7k2r5d?=
 =?us-ascii?Q?oBQTD5etkBBl8ZHwgOXm7AvY0ipl1MHnlUZP6LTaTRFzlseVXby4GHNYnhlV?=
 =?us-ascii?Q?VgaCcQTwtmy6a9KQ+cLWkTCXMYYaV36+y3gmpuzWPucBptuJEYsQnBGbU67B?=
 =?us-ascii?Q?kYp92+79UCuP6HwNTxytQRyAtMDH72pYDWV9kDrbcbj2cPs+DhCuaos4er5T?=
 =?us-ascii?Q?CniC3JB9wJ96FpE0bK2R11pXZ+NksESNRP7EXMm6FBNc88cHRfqmEebonTdJ?=
 =?us-ascii?Q?gPJ0JNBPru9ZQuzH7psPOxjHxJID+EaWmZVAmLRJcz3KrQKSGKp+Zl5+EkZS?=
 =?us-ascii?Q?RK09QP1QwQFCbcCWa1gdOhD/1eCizGzIT00JPfcvK+FsOHeE7PoK3lLHw1uS?=
 =?us-ascii?Q?X5dCdWNqkbPsCdcU8YQ5ccOJUz9O8/3UI4N1fXdLn9dvTsly3eQogNQ8sfFM?=
 =?us-ascii?Q?2ssGGm3i8DM4nQtkiu3tULHH4qbxnDkYO4CTkk/ilN+znVdQa55QHTnh6Pju?=
 =?us-ascii?Q?smlJd341XVyh5i/Ez//vtk+24E4CC/FuleaEoIoUMfMBFM6PKjzqDhuqgvOJ?=
 =?us-ascii?Q?vSxKmTHK2i7oW7wkQICcpLvE1cUG+iMRIYgydNWoJAf2jZpgjBfUy2ADZxTM?=
 =?us-ascii?Q?e1LCs8iw7L83t2CdqSZlusdvi7tltZNYUSVybuCxKgrX1A/7HbyPbhoJKQh0?=
 =?us-ascii?Q?6KZLOURrsG/5GwBKQFQD+kynNCmG/gvZ1v+ZoNR6RdGFHX0/4ZoXFeg1f//f?=
 =?us-ascii?Q?Ff4332aSQL84S2y2ADkdAUJmp3KHJXY1PRUOse37qGJSu19ghN4AmoyWTQUy?=
 =?us-ascii?Q?+x5nCX748oG7g3soSrlU2pnYtm0soo4myuB3ZUluXX3xboYsbpA1rvgmCiW2?=
 =?us-ascii?Q?yzsL1U+yo3cvFoeX5oWY2lp0uHUmWHNAzAQYHDRrLDoUp1EoUbvXcU6H1n9P?=
 =?us-ascii?Q?tPzy5gkopRN63xpalztGf5tx0b7j7sMaw13sv3YAuBf/vMzIFTkgzjJ0MmXm?=
 =?us-ascii?Q?lprVVwLiYagXivrheIUvDypOxKmfvMVq7TeLpKjf?=
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
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB8409.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3559069f-394f-40b6-1c7c-08dd07b3bab2
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Nov 2024 09:31:06.8871
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Jp4N27k5RJX/jlYUX5M9mvYyXQ8I9VyvoNb3i96AGxZMBtKZ2j8hOcwiIhkZGa59Hhcu1jaNNYSkzCdAx4DjoA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU4PR04MB10648

Hello Ahmad

> -----Original Message-----
> From: Ahmad Fatoum <a.fatoum@pengutronix.de>
> Sent: Monday, November 11, 2024 5:52 PM
> To: Gaurav Jain <gaurav.jain@nxp.com>; Horia Geanta
> <horia.geanta@nxp.com>; Pankaj Gupta <pankaj.gupta@nxp.com>; Herbert
> Xu <herbert@gondor.apana.org.au>; David S . Miller
> <davem@davemloft.net>; Silvano Di Ninno <silvano.dininno@nxp.com>;
> Varun Sethi <V.Sethi@nxp.com>; Meenakshi Aggarwal
> <meenakshi.aggarwal@nxp.com>; Sahil Malhotra
> <sahil.malhotra@nxp.com>; Nikolaus Voss <nikolaus.voss@haag-streit.com>
> Cc: linux-crypto@vger.kernel.org; linux-kernel@vger.kernel.org; Pengutron=
ix
> Kernel Team <kernel@pengutronix.de>
> Subject: [EXT] Re: [PATCH] crypto: caam - use JobR's space to access page=
 0
> regs
>=20
> Caution: This is an external email. Please take care when clicking links =
or
> opening attachments. When in doubt, report the message using the 'Report
> this email' button
>=20
>=20
> Hello Guarav,
>=20
> Thanks for your patch.
>=20
> On 11.11.24 13:10, Gaurav Jain wrote:
> > Access to controller region is not permitted.
>=20
> It's permitted on most of the older SoCs. Please mention on which SoCs th=
is
> is no longer true and which SoCs you tested your change on.
Yes, it is permitted on iMX6/7/8M SoCs but not on iMX8DXL/QM/QXP/8ULP.
>=20
> > use JobR's register space to access page 0 registers.
> >
> > Fixes: 6a83830f649a ("crypto: caam - warn if blob_gen key is
> > insecure")
>=20
> Did the CAAM even support any of the SoCs, where this doesn't work
> anymore back when the code was mainlined?
Yes, for all SECO/ELE based SoCs, CAAM page 0 is not accessible from Non se=
cure world.
>=20
> > Signed-off-by: Gaurav Jain <gaurav.jain@nxp.com>
> > ---
> >  drivers/crypto/caam/blob_gen.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/crypto/caam/blob_gen.c
> > b/drivers/crypto/caam/blob_gen.c index 87781c1534ee..079a22cc9f02
> > 100644
> > --- a/drivers/crypto/caam/blob_gen.c
> > +++ b/drivers/crypto/caam/blob_gen.c
> > @@ -2,6 +2,7 @@
> >  /*
> >   * Copyright (C) 2015 Pengutronix, Steffen Trumtrar
> <kernel@pengutronix.de>
> >   * Copyright (C) 2021 Pengutronix, Ahmad Fatoum
> > <kernel@pengutronix.de>
> > + * Copyright 2024 NXP
> >   */
> >
> >  #define pr_fmt(fmt) "caam blob_gen: " fmt @@ -104,7 +105,7 @@ int
> > caam_process_blob(struct caam_blob_priv *priv,
> >       }
> >
> >       ctrlpriv =3D dev_get_drvdata(jrdev->parent);
> > -     moo =3D FIELD_GET(CSTA_MOO, rd_reg32(&ctrlpriv->ctrl-
> >perfmon.status));
> > +     moo =3D FIELD_GET(CSTA_MOO,
> > + rd_reg32(&ctrlpriv->jr[0]->perfmon.status));
>=20
> I believe your change is correct, but I would prefer that ctrlpriv gets a
> perfmon member that is initialized in caam_probe to either &ctrlpriv->ctr=
l-
> >perfmon.status or &ctrlpriv->jr[0]->perfmon.status and then the code her=
e
> would just use &ctrlpriv->perfmon->status.
>=20
> This would simplify code not only here, but also in caam_ctrl_rng_init.
As already communicated by Horia, a separate patch is good to cover this.

Thanks
Gaurav
>=20
> Thanks,
> Ahmad
>=20
>=20
> >       if (moo !=3D CSTA_MOO_SECURE && moo !=3D CSTA_MOO_TRUSTED)
> >               dev_warn(jrdev,
> >                        "using insecure test key, enable HAB to use
> > unique device key!\n");
>=20
>=20
> --
> Pengutronix e.K.                           |                             =
|
> Steuerwalder Str. 21                       |
> https://eur01.safelinks.protection.outlook.com/?url=3Dhttp%3A%2F%2Fwww.
> pengutronix.de%2F&data=3D05%7C02%7Cgaurav.jain%40nxp.com%7C758768
> 98a8044b366f4808dd024b7740%7C686ea1d3bc2b4c6fa92cd99c5c30163
> 5%7C0%7C0%7C638669245367988594%7CUnknown%7CTWFpbGZsb3d8e
> yJFbXB0eU1hcGkiOnRydWUsIlYiOiIwLjAuMDAwMCIsIlAiOiJXaW4zMiIsIkFOIj
> oiTWFpbCIsIldUIjoyfQ%3D%3D%7C0%7C%7C%7C&sdata=3DaaQ65iMsvuHn3q
> 0bo5UU%2FYU7Fpyw3El7wNVHd%2BMNee0%3D&reserved=3D0  |
> 31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    =
|
> Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 =
|
