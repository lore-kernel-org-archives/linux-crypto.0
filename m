Received: from CHN02-BJS-obe.outbound.protection.partner.outlook.cn (mail-bjschn02on2124.outbound.protection.partner.outlook.cn [139.219.17.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4D517F48A;
	Mon, 10 Jun 2024 12:23:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=139.219.17.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718022217; cv=fail; b=Q4xVSFFLl2VjgDcTS1WqrAPuI5IayjvaFSkQIN3DbTQ0EmEK6hbTvKgYm8/xdatC+geshWfZleWeARQjXihC4CCTkyfUA+O9L8azS4AFYiAUjzcRl33SJeIKHmme/89urE6z0HpWI5rYkcYMq1EfBDuAQP3JUBnwmVps+GarX0c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718022217; c=relaxed/simple;
	bh=2zkiMCN7j4M5uhJBNcVvMXEk0E+MoxQQ4BJ69uZoxWw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Zwa3N37S6WPoF79BhNRBNB5lqvw1at7fsjW+bOShcgbKt9alzjw3QH8I8sNHr059SnSnpR09xjicvurshyYVLXDJZ6jM/uEoGU7Merk2FfKtEyXjVVO8+YvnvvGS4jROv0PWsinWEu3Ow/1I9xeg8lHU+7XuQGwAPh4qSPuL6m4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=starfivetech.com; spf=pass smtp.mailfrom=starfivetech.com; arc=fail smtp.client-ip=139.219.17.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=starfivetech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=starfivetech.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NwFa+LunUCP/JepPw86XaPvlc+y570pxzuuTE9pCpyAa7jyfiDESqRr4X5XnZ6psF0Tn3Z1SYUYr4ia0D9QJmh89xgqjZvCzzOdUS8G5VFcNmCWY8Ro8STxMMgNULEw9Yr7d8luKYaf1UTE7BA+y5lkDUUxg0vTnJTGh0VcvxjTJWyxlbQHLnqwXQlHiQw+yHzviDSu8cKBAKvjcfS6Aud+3RsO8IExuoKSqxCc8x1DHBh3R4Gruba26oN67gczt94eXz+U+5F9zy6EBxmkIDaF4kSrixqzQwnaSQ3cc//VV7YSO7/Cwf4UkXcqx83IyhQrczuWQY7HU69kow21bpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C+i68n4PcEK9IxlrYtAMXyoQqav7R47SOqu+rLkGf4Y=;
 b=JR6OrFzxbvTBC0O1+XBKaN5AL+C8seTdXE5g7dAuWVLgCVwCoQ+Vavgv5zhgFsfh5np00lcCWdbI4ncDjizzih6IKXMhaGFzzGbkKYvfuVL80cCO3U+AeEjf2MuDYJrNn1B1uZlHr7bYCQIS5OAhYTSHh3VSjOdyNaMMcbVapPuzBEOebmyV3M3aAfR7vC6W9h2McBAjrLd0l8v/UnL4XYcdq2YKgkQmgxTefJ5jmv0jtHiM3p1ykJSuDAe5XQQvcyP0HVmCPnw7IDNveEvgWrOAKtJTSE73o3Wf8pwx0A0HXqO2Hxq2FCvsQJM6uPL9Tizb8aQjH1JKIt6kNCLEPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=starfivetech.com; dmarc=pass action=none
 header.from=starfivetech.com; dkim=pass header.d=starfivetech.com; arc=none
Received: from NT0PR01MB1182.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c510:10::10) by NT0PR01MB1152.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c510:12::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.39; Mon, 10 Jun
 2024 10:50:14 +0000
Received: from NT0PR01MB1182.CHNPR01.prod.partner.outlook.cn
 ([fe80::e3b:43f8:2e6d:ecce]) by NT0PR01MB1182.CHNPR01.prod.partner.outlook.cn
 ([fe80::e3b:43f8:2e6d:ecce%7]) with mapi id 15.20.7611.039; Mon, 10 Jun 2024
 10:50:14 +0000
From: JiaJie Ho <jiajie.ho@starfivetech.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: "David S . Miller" <davem@davemloft.net>, "linux-crypto@vger.kernel.org"
	<linux-crypto@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] crypto: starfive - Align rsa input data to 32-bit
Thread-Topic: [PATCH] crypto: starfive - Align rsa input data to 32-bit
Thread-Index: AQHasV7JGIR2o9Gsw0quf+yEyIC5HbG8Na+AgASvG1A=
Date: Mon, 10 Jun 2024 10:50:14 +0000
Message-ID:
 <NT0PR01MB1182521792A1CB004CB525648AC62@NT0PR01MB1182.CHNPR01.prod.partner.outlook.cn>
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
x-ms-traffictypediagnostic: NT0PR01MB1182:EE_|NT0PR01MB1152:EE_
x-ms-office365-filtering-correlation-id: d402d2ea-b383-49a7-5eb3-08dc893b1be8
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam:
 BCL:0;ARA:13230031|1800799015|366007|41320700004|38070700009;
x-microsoft-antispam-message-info:
 ifqerDVo5jHv7wYjZBnm7UruiFRf2xrZTHVtvTFtL4ESYvyyODblFPRE9MWHrLJ8ipq6b0z4ARKajgmJb5Ts/40Pt04ZuuJQhP6nlTkqgWQyB/twdqyyIcUEqTMkmVjp64BB6KkBktWtIhY+zXm+IT5cImlwwEcbz4hAJuDUET+ZHeOjCNivia/rnVr7Rkbvn9JnSGBotL53nJ4ABIBF99r4KaQBzDiI8O8XKTugQgSix520Rm9dGxbn93cDYC7bh+Qqg3d2suS+/X7FHHmETcGqDSkvgB2bkR5PmF3BSI3OF2v8KCtW2atYYJnJkzZ9hlr6j7D7/JVRM0cipb9l+mqrMHX2BR0n2KxVuz867E4be0RnyjBiGPew5OjOEvk/AVmXgXox4OhOYbneP/K30tcZ86E6YHa/FaCeOAIKEhuQrTLwNH0vMdPZys4/oO8b+uXJWGBElNwImO93YFXz9aN/I+xB6qT7KZBbDOOh3v3sMzh8/z2s8xFZYLAP8b8+MvyBdyymFLkzat0XpNrtUzTbgQ7MNA3bKhV4G5SS6gWjC3+RH81OE5RaijAP+nCbdKM0GkgDWGsNh8Y061+kQ24ZVk7PPvrHCh3DRYdfqCKxETan/WXsWZ38JwO2FVdM
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:NT0PR01MB1182.CHNPR01.prod.partner.outlook.cn;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(41320700004)(38070700009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?SgOQ/NBo2DlQTtfBo22E3i0x8e4r7XND6Bnhy13FKxOQ0MZSRG/tg4ONBgPp?=
 =?us-ascii?Q?B8/TrCbkj/9U0PoDKq3LcnITXYrExW9cH5XSyG4jasJ36VlymYH+H0/4ItUi?=
 =?us-ascii?Q?24eIuoN7zo01P6DSCFpWFKrCejRUsvGEFVzyTIazxqGBUE7dK+2YvwOqcQJ3?=
 =?us-ascii?Q?smCPtyqyCklTPKfSzctjanFzozOiayIyoAsfuW653WyeQB4Bb1paBeq0v+0M?=
 =?us-ascii?Q?IvxDqo7LX8bVtORldrcgtpfYsJ4p1x+dVvkQBTf4r3p9AD5vEF08h0tJJu0w?=
 =?us-ascii?Q?BL+Xp12KEGUD2iBDNHXRNbYVRfHMsSveLv1rM8aUNfep4cXBXeZd+g78RHHU?=
 =?us-ascii?Q?maqZ9SZa7blBD1GjYOVwZEaT7qt8jhez6e1qK8yba+HJ+d+a0qZiWIEF5fPf?=
 =?us-ascii?Q?az01+26dQJqtCUp4T7vC/xEgqeAuBCFGJos5J+vyIIvPo4ektV8YegEOIdEY?=
 =?us-ascii?Q?AcuuRW2r1KIXTt4IdpiOONmO75Of4q8m2sdm/99Ofvn1AVqwOYa2Xl3zwkxZ?=
 =?us-ascii?Q?EQrWGyDeDe1JGzFzE/kCSSBAwrjN4LSoSmzFFH37Z1A+M3Fuj0gZHJu+2xL7?=
 =?us-ascii?Q?rqbMx3/86tkrDr0BUDkzva9hhN5g4WTuaOHyEt87kehM8ZsOixN3VBJvWM8B?=
 =?us-ascii?Q?OsRvcp/DdT93OUjp02yLh6HoexKS8wGofIfjzHMMC94BQaKsaqxu5tiB53uh?=
 =?us-ascii?Q?MJ4I01NTtYQ/++Z3S1INkZTyuGi4248zhko2pIZ1k+iviFelUsphv+ipqiZT?=
 =?us-ascii?Q?o/uxbiatYkU+8kuaPOB6QzL+Lz1luL1Dyl11VjAWjMkALoYxWtGhVCuCShmD?=
 =?us-ascii?Q?rr38OiTrqB9c/+c8zGGdhYjZMGLiJGCslfWEhvdlhAhBbSM7BYjmhis9RF0r?=
 =?us-ascii?Q?MXF138tvcGt9ZsLuWWvXs3GtuR5WfEBij5aJqQCGMLL1EfTNsGzgj+QFWqyb?=
 =?us-ascii?Q?3vqmHZ/XZQSlLafbrJZz+wT6c7xSxi+mKLRxo+7mOpJO7q8EMl1wzj5BERiU?=
 =?us-ascii?Q?RvR7TEByomJwiGy8nR+Wf7nN8BnIwV5fkn3qOZNclmyaAJgxe8ZmIX+WWIGa?=
 =?us-ascii?Q?dbFaH6seQUzixLfbVwdj48hBefYXfISSugqr34h5PnTpFail+jiDFiond38k?=
 =?us-ascii?Q?rye9NYOkAIpTVyj5ThghYTwfMDX6nbTsWQ5SxziEoznDhIjP6A7M8750X0Lc?=
 =?us-ascii?Q?uyhOzrLsP4HiyycLpb3DY0DOcdndtgqanYRwKp9G73VCw5RiBKGC/+8F3o9m?=
 =?us-ascii?Q?7rMGpMC6D1Xa0msCy13kr3hZQHTZSc4pXPrlpWrVXwlf6GYYtcc3xv0261jA?=
 =?us-ascii?Q?4QZdT2yy/P0gyZA2agLr6PwewwclZVrAJ6qKWwtHjpYRWAP5iKFiH7E6ahs3?=
 =?us-ascii?Q?YW4WZ4uBQWtjuArLLLDrBfw1LTeQsD4daf7RwfgXd1v0HajiQWSwL9bpsI1j?=
 =?us-ascii?Q?jyrMJCjMp/d9tYp4UiVD/GURYlKZHoc0X3j1PPhmmlnFyqSRctRySzgKsbYo?=
 =?us-ascii?Q?4G+t/3jagwyAXbLFbws8b63Kmmx+auLbvRNcnSnLai4PFLe15vTUwC9o5X26?=
 =?us-ascii?Q?aJwDtxdyDUE8FlervRIGZT9GQnn2pfwF6cVGtJo20/eYo6Womb0Chbq+RcMf?=
 =?us-ascii?Q?4g=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: d402d2ea-b383-49a7-5eb3-08dc893b1be8
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jun 2024 10:50:14.3850
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 06fe3fa3-1221-43d3-861b-5a4ee687a85c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YiIdxS/iQWCwd3mFZ3taeGRyS63rIw+xu/gRYMZmWvqTo6BrrxWXtIoDGZxVd+RqFYc7GcNvCoqvdWURw2v3styNPw/TkQSW+VxNb1/meGQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: NT0PR01MB1152

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

I'll update this in the next version.
Thanks for reviewing this.

Best regards,
Jia Jie
