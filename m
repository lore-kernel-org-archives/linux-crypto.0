Received: from CHN02-SH0-obe.outbound.protection.partner.outlook.cn (mail-sh0chn02on2111.outbound.protection.partner.outlook.cn [139.219.146.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0773EF4FA;
	Wed, 12 Jun 2024 03:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=139.219.146.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718163028; cv=none; b=EIL3nzmO0dXVmdeYV7M6DlH5S0SRF8njznfLKbTUuKMmU8JmEvXUpgIOOPrwlTbGt8x7iuojRgV/ltwqTESRKqT49tg+sQ2EcwLhXrzblz14Bnw2ganDnV6yjdevQzk76Y8XJWu2fWTOgeydepZvSM/tZvua6qtsTwhG8V6v6WU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718163028; c=relaxed/simple;
	bh=kLKAbzi0xsqXvRGTpQFmPAYjqFrDThP5VWGEQnR2Icw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=UtdBKit8mDuFyg6FUwvp1lIezUypelhUnmcOZxtgE5trEtwLdfAnZ3qZjLf16EG/KvFB88T/KFNCCYc6fm3Xcp3N8BK6VWMsiyWc5qWUBzRKkZTBAXW68/j3y6yU34Yj6TZNpcAqf7n+0j7xPHC6O8qK82U0mwn3u5BjFJ4kwAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=starfivetech.com; spf=pass smtp.mailfrom=starfivetech.com; arc=none smtp.client-ip=139.219.146.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=starfivetech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=starfivetech.com
Received: from NT0PR01MB1182.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c510:10::10) by NT0PR01MB1023.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c510:2::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.38; Wed, 12 Jun
 2024 02:58:19 +0000
Received: from NT0PR01MB1182.CHNPR01.prod.partner.outlook.cn
 ([fe80::e3b:43f8:2e6d:ecce]) by NT0PR01MB1182.CHNPR01.prod.partner.outlook.cn
 ([fe80::e3b:43f8:2e6d:ecce%7]) with mapi id 15.20.7611.039; Wed, 12 Jun 2024
 02:58:18 +0000
From: JiaJie Ho <jiajie.ho@starfivetech.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: "David S . Miller" <davem@davemloft.net>, "linux-crypto@vger.kernel.org"
	<linux-crypto@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] crypto: starfive - Align rsa input data to 32-bit
Thread-Topic: [PATCH] crypto: starfive - Align rsa input data to 32-bit
Thread-Index: AQHasV7JGIR2o9Gsw0quf+yEyIC5HbG8Na+AgAdOR4A=
Date: Wed, 12 Jun 2024 02:58:18 +0000
Message-ID:
 <NT0PR01MB11824BA0DD4F7C638A91E80C8AC02@NT0PR01MB1182.CHNPR01.prod.partner.outlook.cn>
References: <20240529002553.1372257-1-jiajie.ho@starfivetech.com>
 <ZmLsK9Apy9NwNEQi@gondor.apana.org.au>
In-Reply-To: <ZmLsK9Apy9NwNEQi@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=starfivetech.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: NT0PR01MB1182:EE_|NT0PR01MB1023:EE_
x-ms-office365-filtering-correlation-id: 00809498-56e6-4ffe-bcac-08dc8a8b8364
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam:
 BCL:0;ARA:13230032|41320700005|366008|1800799016|38070700010;
x-microsoft-antispam-message-info:
 6BoecWKvpDpVjmNu8LUkwK6zwPA9uEmbO3qvlGVeHNPr88Q9UPxSlDZMUjw58AWJnrwYfhs2Zh5ccZ9HoM+d0g8N8BCcCP70ckGMXG2ArZW0cUreNEtFa+zGqVQZSDMksfDL7ALEVQ2rAxGiVLWaPVRPxVFo26IdR9hThbZJ/tapYhfMjTsRxW0Vgimfw7APubWSGBq68t2chXuQ8KBiKyGEj5v3d4MLnmWiGIrC6a/SgqmV3oZinRYLi75Z4XHbUfmNY4/ju9XQ88cOpClh2Zf6cMnBTathTx2f0Myct4rVhRSvV2aotUZBLVOclzfAcc4m3XRHGylEYhvqz9J2i6nzvL53hrvafM+s0d7PuVahljwjEWWnFs0aoEu814cYQXoYCbNc8VydbxoS40ay9/HGJBg40w0JW1LzX/UOYLujQHcLuF7WOpAeqZkYf1kx15JAogA+ulL6Yzjd/Rn7rsxYRelx1WBqQMSTX2o1QXezp/rjZrNiux73dDKQUR4SzQx95rWwTBr8gqhexduGQPl4P1tb2j7nI8gAq4JfjRBjNDHAUD049odPvPI+noJdEJ1fm75igpEHmJ95rltB2/wIIC/ARtWdeojnx19ZkMrwnIP89o6YDYHdr57CSjws
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:NT0PR01MB1182.CHNPR01.prod.partner.outlook.cn;PTR:;CAT:NONE;SFS:(13230032)(41320700005)(366008)(1800799016)(38070700010);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?lW/5V8zycOjf4o3J2rWMKA2F98T1zCsR2wFwRdkDT7UF3xLDlq/K1UrIkzf+?=
 =?us-ascii?Q?nImXyR1pmQYkhR5ydxcIQv+8OK7BrFkxbhyBWTpkS5bFhZ6Pu1026UODyBkb?=
 =?us-ascii?Q?nMjpYLqbHeE7EAHZhIwK5CdkFsJ36jwc+sd1HfO/vAvax1nn6sSzVBF1Sn+7?=
 =?us-ascii?Q?IYddaf7Q4olGZhc9ts8hPiYHVIrdGXTWxGtQSaVM/mz4YYJkKqDkTfe1De3T?=
 =?us-ascii?Q?4mv/IFgUC5I2SsBYHBVkM9AbglbWeANKO0nZCDKETFutIbXuomB1qNAKxSfS?=
 =?us-ascii?Q?oJz8eGU5hK20i2rC6IQ5PlI71I0wvyBT248/zFzw7b9LiJno0MxV+ANv/TBY?=
 =?us-ascii?Q?nrkbLz3svKZNIlypsHz+9V6+ofMyLYA9ndi8iezs1S3qTqCMBBgOI0PVzaD/?=
 =?us-ascii?Q?UD6K2WenHXoO9ZxfQE1Q4c26OGioV3YU7ViHc57tmJ1O8n/55t9fPDDtD+J2?=
 =?us-ascii?Q?/qZ8tbrnILUEbhz3LFG1h2zElb1U+ovuA45mdpRhVd4l8RTt9qQMGGiPfXvS?=
 =?us-ascii?Q?frFfeoMlJ/idYfIYtTaRCQ4X6WTvsQFDXqiy2sCV6/Z5l4QEg92ZKfYJMbQY?=
 =?us-ascii?Q?iuD+2cge3CzN16JRvYjAJHzv+WAFPzzobJU+DE0Llww/vdpkMnj3g6JbTz2n?=
 =?us-ascii?Q?iIH9uZ4cpTOpZ+wM2L4dIHlO8EJR1tgqJr5zmiHprnUf8xfxsSJtp7CzbAeB?=
 =?us-ascii?Q?ICFAuFUkCCNxBqUuGrFWzzjbpql1y5ZvlPO13wmk5X7pk0MZDqq9efBH1CKC?=
 =?us-ascii?Q?UzIBNkR0RO464z6vFl0s76IknFzwg2qEirEV3rmkwrfEC/05dFGumVctr3Fa?=
 =?us-ascii?Q?JCqWcngVM+f8bPOrgudJ1X+DAgYE7IP99RVOecz8ygUxBOAhxu+V7+E0M3C7?=
 =?us-ascii?Q?isrM1qZa6nCclaFayixMPF3+t1bB2QGKlGfRLC3sCbJ9BP0YuSLhbRh8yyCH?=
 =?us-ascii?Q?9lKiuKytL6E9+KvX1RTGSnHe8e2TWB4B9930dSGSWw+9xysxMNknAoVGAcXv?=
 =?us-ascii?Q?eP8v+9dOexvaY9GxGZcMTnjsOyQsidMJkRKj8Zy37jRI6PiPFKK+XCN4a/qi?=
 =?us-ascii?Q?QA/U3sIE5j+/RzwQTiisq6FpUxrMSb4GC5PMJKnVsjcPkk+jKe13z/s9ApGa?=
 =?us-ascii?Q?ZS9dLdAsbMiHTNRQT/uVIegi8a+AtFA88mo1vO+8X9DRADBkDgdZennYFNUN?=
 =?us-ascii?Q?7HbIbWtgcxauAYJoH7DaodhgcjvjlpArb1zrwDezsPQQxRUr88tlJS1YxjM6?=
 =?us-ascii?Q?D5GCfuKFnVvuwHAj4SM9UGEPzkhqGagMBfCQudSTgL4LsTfash7zeedQEvuT?=
 =?us-ascii?Q?RV9IlhgdyQHsa1Ay2DzfsjPm2+7Vi/GRo+RX5Oia3cLEGjm3SyNmOFJwzsNF?=
 =?us-ascii?Q?QFnUijbvCpFazexgZdEeuzLYMknu/RxCPIS7Uk/uFKcvNW3n5YtUnuK3/3N9?=
 =?us-ascii?Q?Yj4o4kbVQvBf9a90xPi76P+jmdut5tIPlz4zdldtAeLSOM9oQjOUNIfx6IYV?=
 =?us-ascii?Q?SWZSE9oyKwUUYDTAjXBPtziEqm5TT/Zqt81ma2j1swPTm3xw/qCGilu1CAkm?=
 =?us-ascii?Q?AtZjThcg9XBYrlUubaO2d5VO5aADxb+ZfuQ02jcXhN8T/qPQvjt2Zkjnjw+W?=
 =?us-ascii?Q?lA=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 00809498-56e6-4ffe-bcac-08dc8a8b8364
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jun 2024 02:58:18.9125
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 06fe3fa3-1221-43d3-861b-5a4ee687a85c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zt44A0KgQ86sjgO5RCVvzzLEJsp44L3oqx1hcRqmIHeWozRqbmLtbCmTU8BtDzhKYVzZjZvxJFm8nbxai4Sqo0xMZ1emJYbEvJybZOQRS1Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: NT0PR01MB1023

> On Wed, May 29, 2024 at 08:25:53AM +0800, Jia Jie Ho wrote:
> > Hardware expects RSA input plain/ciphertext to be 32-bit aligned.
> > Allocate aligned buffer and shift data accordingly.
> >
> > Signed-off-by: Jia Jie Ho <jiajie.ho@starfivetech.com>
> > ---
> >  drivers/crypto/starfive/jh7110-cryp.h |  3 +--
> > drivers/crypto/starfive/jh7110-rsa.c  | 17 ++++++++++-------
> >  2 files changed, 11 insertions(+), 9 deletions(-)
> >
> > diff --git a/drivers/crypto/starfive/jh7110-cryp.h
> > b/drivers/crypto/starfive/jh7110-cryp.h
> > index 494a74f52706..eeb4e2b9655f 100644
> > --- a/drivers/crypto/starfive/jh7110-cryp.h
> > +++ b/drivers/crypto/starfive/jh7110-cryp.h
> > @@ -217,12 +217,11 @@ struct starfive_cryp_request_ctx {
> >  	struct scatterlist			*out_sg;
> >  	struct ahash_request			ahash_fbk_req;
> >  	size_t					total;
> > -	size_t					nents;
> >  	unsigned int				blksize;
> >  	unsigned int				digsize;
> >  	unsigned long				in_sg_len;
> >  	unsigned char				*adata;
> > -	u8 rsa_data[] __aligned(sizeof(u32));
> > +	u8					*rsa_data;
>=20
> You didn't explain why this is moving from a pre-allocated buffer to one =
that's
> allocated on the run.  It would appear that there is no reason why you ca=
n't
> build the extra space used for shifting into reqsize.
>=20
Hi Herbert,

Can I fix the buffer length of the pre-allocated buffer to 256 bytes instea=
d of
the current variable length buffer?=20

-        u8 rsa_data[] __aligned(sizeof(u32));
+       u8 rsa_data[STARFIVE_RSA_MAX_KEYSZ];

That's the maximum length supported by the hardware and=20
most applications now use rsa2048 and above.

Thanks,
Jia Jie
