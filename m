Received: from CHN02-BJS-obe.outbound.protection.partner.outlook.cn (mail-bjschn02on2139.outbound.protection.partner.outlook.cn [139.219.17.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2E20748F;
	Mon, 24 Jun 2024 02:41:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=139.219.17.139
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719196900; cv=fail; b=PZeor86cThBG6iDLrZX6KvnM98FgHj2fgd5tW6X9UxeA53Ll/TvDOnq7+4lKTgKc4tLHOqrLE/CurRYazIujkQW3HFAc9qdL2o/w6rBLifi9QqQ+v1m9/w6Ayc86YgJZseJyq3yP6gqGjBx2uryFHJIXJ9WwPQeiV8h/Zrstm68=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719196900; c=relaxed/simple;
	bh=budBRgJZxrthLSlMMHqt4+nNmyMa/pjmn/OfxD5FB/k=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=UQL1y3uTaMFvxy8LUTiG6+6AVIK/A/0AoiBbJDAqWfU6e3iYFlOy0ZdyeGRyThFdhv8vhMcCEo6l2C8F0XIAk9YntC3/bP1PPngn63h06Taf4QuJHcbofkXoZmAQGiP+yckQGaiDsjgNrEw1HM0CXwiomqvkrs3bX5DewxTI25g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=starfivetech.com; spf=pass smtp.mailfrom=starfivetech.com; arc=fail smtp.client-ip=139.219.17.139
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=starfivetech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=starfivetech.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CqU8VcJ/zmFhs8QJB/R4m9ZnfqVyT+HP7yZD0ZtPmISYwcRbPB4l5vhAVlNkM7d8IGaETx897SbL4zIuaWh6akJBosjDVk5vkUFiXLcmSrMcslOPmWNfYUCoA68o50yfVh92klHkmNrUy1SNNOkbAyFlyQKBitBinazRSYRhetyqkL8CAJCGaxxjjZsH85ZXIhlLzqD1azfTXmW0ZMMGsRGcDfewjhggBia7oQ8bMMRVcCbKeQ9aW6Z0zExBDZQxq2P7asFPIyFAJYRf/V7DnuYZAz5125en91zRfZ8aLjL15S0YafwqkpJQ1irjotZlJwD3HgvzRLSXH/B0oDA7Dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lmrtjs+D8t8ODM2uzDsZXQHQNpiuc1t3AHA/l/EEGbc=;
 b=LYSSQ4+cS0R2dSNSZkVPQiSQYgjaPuJ400zu3PagNY3URdY2t9VQElCb55GX78k24YmwFHN/vrWanxIskeFA1rFIsTm1+zyjZnOTHhotfQ+TVImVoKwIsml/itnbBYHRQIHwOlVrZ/4hGoyRyG3WcpubArOSEq1c1SnvB3bWCbD7nZLpCFPPoWZo0h+c7CzEZX5GI8YzGcYOhUE6/zjF5kP89YtLO0ZY1Z28LC8VDndSUYMq3jWgXADg+r15AXzIML5A+u+/TvdYeH6awjSS7YmKeDfTOm8XkbOMlw3E5UuX4adey29F2E2TeDUchU5y4IrqdsHIIL4aymYtruPyew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=starfivetech.com; dmarc=pass action=none
 header.from=starfivetech.com; dkim=pass header.d=starfivetech.com; arc=none
Received: from NT0PR01MB1182.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c510:10::10) by NT0PR01MB1247.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c510:f::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.28; Mon, 24 Jun
 2024 02:41:25 +0000
Received: from NT0PR01MB1182.CHNPR01.prod.partner.outlook.cn
 ([fe80::e3b:43f8:2e6d:ecce]) by NT0PR01MB1182.CHNPR01.prod.partner.outlook.cn
 ([fe80::e3b:43f8:2e6d:ecce%7]) with mapi id 15.20.7698.025; Mon, 24 Jun 2024
 02:41:25 +0000
From: JiaJie Ho <jiajie.ho@starfivetech.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: "David S . Miller" <davem@davemloft.net>, "linux-crypto@vger.kernel.org"
	<linux-crypto@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2] crypto: starfive - Align rsa input data to 32-bit
Thread-Topic: [PATCH v2] crypto: starfive - Align rsa input data to 32-bit
Thread-Index: AQHavW1BEPvIvt9q8kitzgkcW35dDbHSJImAgAQf1PA=
Date: Mon, 24 Jun 2024 02:41:25 +0000
Message-ID:
 <NT0PR01MB118296A432EFF03E02A6212B8AD42@NT0PR01MB1182.CHNPR01.prod.partner.outlook.cn>
References: <20240613083942.760182-1-jiajie.ho@starfivetech.com>
 <ZnVmechLrqIKKFc0@gondor.apana.org.au>
In-Reply-To: <ZnVmechLrqIKKFc0@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=starfivetech.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: NT0PR01MB1182:EE_|NT0PR01MB1247:EE_
x-ms-office365-filtering-correlation-id: e8e418ac-8160-4d3a-7d59-08dc93f72453
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam:
 BCL:0;ARA:13230037|1800799021|41320700010|366013|38070700015;
x-microsoft-antispam-message-info:
 vgv6HRPcQo/CaMqe5l6tBjnxAI7VOOkA5jWzildFCMTuRB4G/UWZQqLYgVULkjVBGPcwWlAQhwCl+rF26xtSp8TWerC/b02YhCQOsM0JOm9ASTMHfRMXCcOmaVXqJYW4n5z1uk2VCszccYDItWW+GoK2ygzwPVOgXczRgdfAWwzpQuk+LGfNyhN0GtZ+MprRLtcztPXYEe1UIVxp1lOYpxfOd7xC/LFirvqgVwsh1jWlmLI2lIHwLFqERLntn9RDsg1gTMtJlnb8sARGtCCIMR7t2SJxEu+7vqmUwxHv4yxJ8kKJRIn+8m5PzH59kk6S0cOJm8dSPP6I8jVgVmkVk1rwr6cjwls1vAkcgxXndIrF+++K7OqTcLxF9lXceFDUI5Z8DqYfky0v5ysG2B7D5sVP2QZlwHHClwW89Qckpsm4LTg/FgB55wJBtdTkdwni1TWoOeo9/q0HqmsoqHK4+wlas5lSNgKgyigwkt3E7XinCmKIbdbUiqkrIuGmTbM/aUekI4q94FfK/DJhowy7A1cv2o21EQdpC+wCgYPp+HE5R1s+V2H5/POgebqpP6yHTt3pa7HBQ3j46Bn9PpZlftic7czjVPCLbMldh55nDoZb9nKndKq/X3iaQNxc1Be6
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:NT0PR01MB1182.CHNPR01.prod.partner.outlook.cn;PTR:;CAT:NONE;SFS:(13230037)(1800799021)(41320700010)(366013)(38070700015);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?uUMY4d0YE7ylp1iEwq8VBahIKic+eNJhKaxEd3PYgSkGMwYFwDeNprCfoRkH?=
 =?us-ascii?Q?gHsmhJrBpIrauND4U/pk8zfFLGZRJC97KkrRBuE+me8m3Iz8uVfyhdfUIr1Q?=
 =?us-ascii?Q?wsSytw9Ww/DjoJo67iQAg0OrnYWjt/NwQ0XXc8tcql74iZo/ZYRZhZuf5ude?=
 =?us-ascii?Q?z7UlzeDlByEOWs+dR51hM/sywFcKX5wVf5w630VNqlD4rouLw/nkciiCCLMn?=
 =?us-ascii?Q?7Xh2lYMES/GsohAdm4A/LqD39ceiuvgHHsBIibtSrvOAbHOzvIVJKqkCoTpk?=
 =?us-ascii?Q?uZffXz016l8blrRVGioNjv8dTJIMFMejkXoq45NX1abgbHqAHxh6zzj8gxdG?=
 =?us-ascii?Q?irvMedHI8a7jIjpNlDiAcw4LZM37LVd9qcNmzNypG9NXwQJJaqDhn5ZpHxk9?=
 =?us-ascii?Q?wLiVxV9R4iL4mgY4EHKPWSL2auf950y9bl3jPBYDy1SAZwGQFQt6I+Jqeebt?=
 =?us-ascii?Q?6r6GFdY0jyjBdYapgSjA4kzN4HklPtblWHqZo9X805ewfedBr+ePl+AQP7/J?=
 =?us-ascii?Q?V57ydtzh7BhUCS1LSm7Xo6VnNhM6bPGEtb/nImSR5E/KNuj5g2Nhbo2+UHvx?=
 =?us-ascii?Q?SRZ6R2bxSjrN0DcVW7E8ihwMKRZxd6mg5pAfgBidXSDSh8RrOC2XW4XgHsAW?=
 =?us-ascii?Q?qnVp48OSn190iKK1F1viEA2wrm9yv7GYKChuF8XldNM32n8ttjNS/EXklNAG?=
 =?us-ascii?Q?XU8oB6hR4RYIS+uyUO7SHmQGS7diAYKWV2ieNy8+mH2UqFGu9+J93qXE4cIN?=
 =?us-ascii?Q?O3qWKTA12TyU1OWXv7TMN1+mB8v3YxyK7CuXqr7NeAjhLhSSARy1O1AIR3yx?=
 =?us-ascii?Q?lIZHPSVId0n691tTJ71t4DOAC582CEOKOy8V9W6BxTwPGoaVY3KkYM0sOEOV?=
 =?us-ascii?Q?2zDDjIuokRAaR5M45vjHUaOjqQKoM1giH2Ljd8twJSKaRUgj7UH49gZjmgFK?=
 =?us-ascii?Q?Zn8BQGyrBgws+6v74HteCw6SIQaoORbHqQa7o/AcANalhl899db5/VSV3aJz?=
 =?us-ascii?Q?GNMa5thC7tquxYarxVJ8LAL7Gm9B3T8BK9DuMdKVqfP4XcL377XkvnJIAVIG?=
 =?us-ascii?Q?VdWnkecCc/XAnw8ADVQDZQOYPoT0L1/gZ0xV94GhSFDRlZwYG9saZa5BqWYy?=
 =?us-ascii?Q?49dN1dFINC0f3MFdy9srjDkYnEI9EzmSbaP4M6pzj5e0OFZrZiXhXAxWpkdo?=
 =?us-ascii?Q?ltIQM+N3K7hfeff5CMGoUrywe6jowqkckHbrYlpPIKDtwYp9iXrll8augqjb?=
 =?us-ascii?Q?2SJ1mFIKzfqu28/+8eThp7IIP6T4zTMyBDu90q+Yv4eruxInHlM8CuZMelIK?=
 =?us-ascii?Q?MfN+BoERRLVDil+h+gKVdTf1oJJqwVDos6JFmXsmM8uRDC8ylF07u9rShpTj?=
 =?us-ascii?Q?7rl/G52I/4SvftHBLryW3rn7qL1Tm2PnVXa4JguDOLgiUofifcAH51Kx7BF1?=
 =?us-ascii?Q?Y9izjZ9vharZF7XV/zzwukSHruqL5erCknJ9l59E4PRgcwqUE6pD6wrE40Rk?=
 =?us-ascii?Q?CS83d2WrsTr2gSSdTY62KBvcmMGQRomIT8RHyTLIfU1PKZ3nW9X40bj6icD6?=
 =?us-ascii?Q?BeaRLgeQwhvhl5MeLn0uCxEGHhJxtWJZP8ly0qh4?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: starfivetech.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: NT0PR01MB1182.CHNPR01.prod.partner.outlook.cn
X-MS-Exchange-CrossTenant-Network-Message-Id: e8e418ac-8160-4d3a-7d59-08dc93f72453
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2024 02:41:25.5237
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 06fe3fa3-1221-43d3-861b-5a4ee687a85c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 77EuecdHACBLbmrl2mPA0p36ovTplh7irsoTCXu6xHutPAkzyrRX4u/sXaNKNNAXrjOmYjN83db1DUVw1gCI7bvFsMywZMPdUCiVep7N2dw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: NT0PR01MB1247

> > @@ -217,12 +218,11 @@ struct starfive_cryp_request_ctx {
> >  	struct scatterlist			*out_sg;
> >  	struct ahash_request			ahash_fbk_req;
> >  	size_t					total;
> > -	size_t					nents;
> >  	unsigned int				blksize;
> >  	unsigned int				digsize;
> >  	unsigned long				in_sg_len;
> >  	unsigned char				*adata;
> > -	u8 rsa_data[] __aligned(sizeof(u32));
> > +	u8 rsa_data[STARFIVE_RSA_MAX_KEYSZ];
>=20
> I think you should retain the aligned attribute.

I'll add this back in the next version.

> > @@ -74,14 +73,13 @@ static int starfive_rsa_montgomery_form(struct
> > starfive_cryp_ctx *ctx,  {
> >  	struct starfive_cryp_dev *cryp =3D ctx->cryp;
> >  	struct starfive_cryp_request_ctx *rctx =3D ctx->rctx;
> > -	int count =3D rctx->total / sizeof(u32) - 1;
> > +	int count =3D (ALIGN(rctx->total, sizeof(u32)) >> 2) - 1;
>=20
> This is a bit confusing.  Perhaps use 4 instead of sizeof(u32), i.e.
>=20
> 	int count =3D (ALIGN(rctx->total, 4) / 4) - 1;
>=20

Will update this too.

> >  	int loop;
> >  	u32 temp;
> >  	u8 opsize;
> >
> >  	opsize =3D (bit_len - 1) >> 5;
> >  	rctx->csr.pka.v =3D 0;
> > -
>=20
> Please do not make unrelated changes like this.

Got it. I'll remove it and the unrelated changes in the next version.
Thanks for review this patch.

Best regards,
Jia Jie

