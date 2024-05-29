Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2078.outbound.protection.outlook.com [40.107.102.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7137515CD71;
	Wed, 29 May 2024 06:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716965627; cv=fail; b=Xwtlc4/eDXicNCMAC/oywROENSTWTupoko7jekXfqNi/NUkYn9trkVk8+PV23xQ1CLRGhQmXUuwRWaboPus9L/gMLXMvaevCtntsWSaYhMPw4gU4SQmX/JGsRPB8rycehdySVDEtW+QI8Rp3kG31OTLuJIPa6nArTOKu5SYrAkI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716965627; c=relaxed/simple;
	bh=CQRUxFKEXxQkDwGj3fWYn7gg0t6bDi1H1Gf7Yf4tRw0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=gIrSv9sUg+kTP8aVzUyVbi+pGTAjalytXNsZFt7dOEucnfw7Rm+9FBsKpUxaoRjfQPOEYBM1OTpJHD0VA62L1rLjpFULB7ZKRAwNPqIho8qA0Aw3GK7ZHnkUGCvG6QlpCKgeEjxhe1QMG84StgEybSPwcwy+mJ3FNNhE8WgNW5c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=mI/vITbO; arc=fail smtp.client-ip=40.107.102.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="mI/vITbO"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hARR8p/+2EwJhymXEplySgjGjm9ySEPRHFEQrraClhOz2sW2gK4XVgeRTRw/NFxNwWwkVlsb0tPbfe/2M2nE3n6fBaPPwmSRzQfdu1fQQxjE7/NlcNNaD9xWedhqaKKoCFqiMVwFv+MvPqNUkyTqIDifbf81ncVq17tJRK4CjAODGte5zG7IGlu/dDMzgDE3wQirr9+1LxwULiSx9LIUdto35JPBxJVfaxV6cqZrI3A9IwWelVndxIwU+BwSN4L7iC1RZgCqJ73pstM7C5K3m0hVBod2nw8HL9TSk3EeWkhcQ3iqqQLlE3hHzOFiPiAQAuKl1wbfXYbbMlMEQYL/Ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CQRUxFKEXxQkDwGj3fWYn7gg0t6bDi1H1Gf7Yf4tRw0=;
 b=fNemHhbVltufTIzNxL83Rz5/iOfau9nP29z58CgUudJobuaviIuGh3deS/15soVxQgls953GHamnTfKsztny4ZfcFmX/NOVJl9f+bkHqYtKX582e6fwSLJIAuSvjf53NL3+X8FJ0d8Z7l6285lZGhc6cA9fPq3MNf5KiW+LuXxY9pj3lGafc/rsS0JpAI81wD2UGA6gVrZPatwYy4pqYlL/PPoCdrIcqCmgGQ6CYKuKxN/MfihqjrzK3XWdFB8nRiG4V+c8yzukZ4JmXAOTVJ3kaE2NtaVP85z121kecnTIZz03NPYwuUiRnI+Qr3jo8ZzQFlX2u5wQAZWEklHiCbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CQRUxFKEXxQkDwGj3fWYn7gg0t6bDi1H1Gf7Yf4tRw0=;
 b=mI/vITbOXRD2rfKn1EZ/TQ//fjDBJwaMKSalTU5zX60ai4gy81uzZRXRD5CRZBR7omxxFgIBI0D7COkpYM/nT+2mAE40Rfwm/8/YAvdkXrN6so1xyPaKcnuGBTB8l9Kvlm/SsvBgOoY5Dp/Ug5FqjHEs7Xwi54RTd2Oa6od6QnQm4aTPgvtFLwJFbLGZPrmIg+Odn7Vkdla7BSquFcdX9QDg7q70frcPEkb3TZWfHGVxLya+Cih42XeAnoABUmyUMACF7Jnl8cFEf9gqgG3ykK6B1ZX32GiIscnvg3uOH4yxhuJusuypavZqL25cqkcaX8FGYwQm8zE424tX/i4HRg==
Received: from SJ1PR12MB6339.namprd12.prod.outlook.com (2603:10b6:a03:454::10)
 by SJ0PR12MB7081.namprd12.prod.outlook.com (2603:10b6:a03:4ae::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.30; Wed, 29 May
 2024 06:53:42 +0000
Received: from SJ1PR12MB6339.namprd12.prod.outlook.com
 ([fe80::e696:287d:3f92:3721]) by SJ1PR12MB6339.namprd12.prod.outlook.com
 ([fe80::e696:287d:3f92:3721%5]) with mapi id 15.20.7633.017; Wed, 29 May 2024
 06:53:42 +0000
From: Akhil R <akhilrajeev@nvidia.com>
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>, Herbert Xu
	<herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>,
	Thierry Reding <thierry.reding@gmail.com>, Jon Hunter <jonathanh@nvidia.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: RE: [PATCH] crypto: tegra - Remove an incorrect iommu_fwspec_free()
 call in tegra_se_remove()
Thread-Topic: [PATCH] crypto: tegra - Remove an incorrect iommu_fwspec_free()
 call in tegra_se_remove()
Thread-Index: AQHarrZLeawWiYOujkiA3zLjv6FXT7GtyrXA
Date: Wed, 29 May 2024 06:53:42 +0000
Message-ID:
 <SJ1PR12MB633943D654272A0612695F1DC0F22@SJ1PR12MB6339.namprd12.prod.outlook.com>
References:
 <ea775b351a3dbe4cef4056ea89da25084f73df22.1716650050.git.christophe.jaillet@wanadoo.fr>
In-Reply-To:
 <ea775b351a3dbe4cef4056ea89da25084f73df22.1716650050.git.christophe.jaillet@wanadoo.fr>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR12MB6339:EE_|SJ0PR12MB7081:EE_
x-ms-office365-filtering-correlation-id: 9d3a83d4-8631-4f32-42ff-08dc7fac13c7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|366007|376005|1800799015|38070700009;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?f/dK++5faVUCcDtBthlaKPne8dcL8PAmPLLXzWc/6n55Rk4wr5jfDAaZr9DI?=
 =?us-ascii?Q?mNfjyjgqqI1Fj03Lq7ndsqC+3zy4h9LJxOEdvCA2vvCXAzKybNCdI6hUMMs8?=
 =?us-ascii?Q?+4PdqU20TU0qwx1BGOSpaYHgHTe8tpPTuCGJ0GHfUP4phVBJR0eO+Y7+GwNH?=
 =?us-ascii?Q?VruAmo/Hrd4yzbTM2U2Fz6WQ+LtkYFMcq7eL+2MNSD9OIkACnFzIgEf5rqVJ?=
 =?us-ascii?Q?BSl1N7hP2PZBqqpwbVVbuiqPwPe59JJAoAz+TaJ6QCRLZR0xAZdc0fBLL5rF?=
 =?us-ascii?Q?/jOCfPHbf0vwzEbg6qKg6BWdJ7W4SGUeLWoSId8I6tGE+HtbzokddzThtMhm?=
 =?us-ascii?Q?uSGmcYg91e6ofi59wIELk/RemxA8Vgl6BxF1KkZ4qomwiSSplCRkO9w9kC/X?=
 =?us-ascii?Q?sBbfMTW83BQOcjmqNi7/P5pJvTMO3/aClOF70h8xEmFbiTgTZiCgMKqeTCz6?=
 =?us-ascii?Q?OnaTYnLcIt86NPICzZHr7qE34ZtiJ2+v2of+q4nOxsVSHcCja1K0LB8+MwJ+?=
 =?us-ascii?Q?L4SYWHZwvspKvOYrI+X+PurMQ1lBoziEZfSBa5UfhJBIqi6SArztnw99GzwA?=
 =?us-ascii?Q?XrkBXZSdBTqJNR7qpiEue1qBPdWP2lz+kBL1rTDRs6ziDV5HNlXgSgA0sJbC?=
 =?us-ascii?Q?6YF24cNHMV4lCr7taDKAuYFAv8pgRgBIcseRMSExCebqY2vI/K1MQqMYdBCQ?=
 =?us-ascii?Q?urNTOPxRUyTq8LRY+GfTDopJcX+Gwj/U2o1ya5G3EysKWhamg8MXMTqqU3Hz?=
 =?us-ascii?Q?DMCgk6Gjvoyp6H0IPa3S64GSmwzKk7/k3qtrMw4CCpaUlrfGFUMZjHd2bTJM?=
 =?us-ascii?Q?hC1Ik1YRKZOxxnn+qyvhXLkHwUAIOMVV5ntvK1hBx5rJCAtHW2YDgPzdlH0C?=
 =?us-ascii?Q?XKAtCaeGfNS7beWPXkPtuDHq81U1btQJiG8SvkNjGCX8Dwa4n+PgV+XLu12R?=
 =?us-ascii?Q?VLmWu1o8qkDYcPCs9QiyTSnZc1rJZSHXSDxgLpy4mT8KfUv7hryuza3dfUKP?=
 =?us-ascii?Q?Ujuekr2oNOJYoKzdpkaTU5tFfujB7N4JminS0bhtfMSQ+6b7R9uDaomgTOS6?=
 =?us-ascii?Q?tq3Hcm6dXcN5YsMVbmaop2B9b+YCaqJSdzibzpRzAM2ErdeRNu5fbqS8baZj?=
 =?us-ascii?Q?EgFJtIimw6RufxDow702MkpY1ld1pGSoKx8fz1FvrFVj4onZBNyx/ckd9Zsr?=
 =?us-ascii?Q?nPlVBZIrMW6h0KqSXnuJdOsFyhOOKMbJVELVk3PIUI0wb1jHEMNjAYk9JggZ?=
 =?us-ascii?Q?kRis+BKG4ZCsdG9y5YSalwlSR0nW1/l1hmHotCaa8yBN7ITecGaFAdYqrPx8?=
 =?us-ascii?Q?i8VGOhZXNGfAnwYdI4m4Sn4KzulpwKesmHeeITieYrIg3w=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6339.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?UbzZyYCBOmWpkh9BcMUPVF/xss2iU10KKXObq8B9TCOKPrD2ktiZjL6oBIa2?=
 =?us-ascii?Q?yUSYGxBLM76Ixf0YHEhDVTqZzG9UuwioFOYiSAEpXN6xVF5HRTXL6tEI4GSz?=
 =?us-ascii?Q?qln9At0FuD0rCHGVudJOjhkQwQY9G7f6R2lZWuV1+oJ7LQfmgcOBAxLywHsx?=
 =?us-ascii?Q?JKYFXZFLjyGHrWk5gTvurAQgXVTaahA49XCfeiKCb2rzQjLVwSBV+L8G+RYY?=
 =?us-ascii?Q?RVIOmqAhgtuQdScp3fGB85HWCplyYIoT0/sJCYhE1LMtEIk3QzxFO0dlT8if?=
 =?us-ascii?Q?+4fEaZVv08JqBXejbE0z6sLC7Tzb7fYNpfF3rV8an4dN+gg+FeIAbt17nu3l?=
 =?us-ascii?Q?5eEQ/tBhWVMwilrHL8PJgyugB3FlIYm0Nj2F5l8bvR+j9HHYY0e96T935hkR?=
 =?us-ascii?Q?lX1k0mmIwoj3lKADSe9/9JPzJX4aIomOTDFFDixL+GCcdUDjFl5fi8qLZs9B?=
 =?us-ascii?Q?Ojy9vy69fH9ADFwM6UsVEJJB5ko1C5X4qCYy0kxQxuomKpF9JfGfJXhAmKS0?=
 =?us-ascii?Q?Z1c7y25PB8DEeklrnlpfWVJ/6FLGc4MiKnoECQsRcbcvdwGpv6ovPpYOQNsq?=
 =?us-ascii?Q?Yl6JD4hPlvrAaBha2gD/sod0BkIBJPIw6mozDL8kKGy34pQg6GfVVR0Spf9m?=
 =?us-ascii?Q?gh4HNSpW9D2LRuS5HPoF8Y4lOBOg1ZwU6eo5X8oaVUGktDylTYZQr0+ugi5P?=
 =?us-ascii?Q?E/MATmvIki9/FwtKVaMy0UFOODfVHp5JNX89UG2wkWCQK5YbZ+xF2FBGZGmp?=
 =?us-ascii?Q?dAV7Gn5NhoKnymK0TPngjpBVzzM5S+qbfvgFOwUvChnQXDJHMnO9qiFHF5An?=
 =?us-ascii?Q?4VHEhj8zLj9KKK4mTU8c0EFLyr99JYl51fY2DEZMfU5uw+9smagSTllRuL25?=
 =?us-ascii?Q?XHODfV0GNIVrr7JwaWWiFsOgedoeNZLqdvYZ+UO0RwzjiXQ4zB+v2scqxzJ/?=
 =?us-ascii?Q?dRq1H0M96dRHv66quH036AjUbft7O/gTbAh63xkVq1HoCD78VyDXs+KxmZzp?=
 =?us-ascii?Q?rgVcoRdoUl2YzIdM6LL/Vco9Wnodj52WA8JDIF7LqLOTfeqg/ezTXECvD+6U?=
 =?us-ascii?Q?CoSuVjqf4axQtC6cREQmN5MWyL9uLNEyztK/z/8Xf588cxkMAeYubq2GaKmq?=
 =?us-ascii?Q?qF9oM2PJOZJB4fs9w7wl5O3eN7U0/30G4ZJ6OQ8wFuMZag/Pwsz6udZoAQ8Q?=
 =?us-ascii?Q?128K6If6Y+pr2p7YHb4y1L5OZhnN2B7id7IiKtK9aEd8m3EOHX96XIzuTSR9?=
 =?us-ascii?Q?kk3RPgwua56A+iTlcVfPOwOYpCb2E8719lES86S1f2e9m8NEwud/FupbUcqt?=
 =?us-ascii?Q?6H99a2M9CxowuWaKfvnvnXoS82+CgJqqUU+sZ+wVptLUOcSIL350iZqfTzTe?=
 =?us-ascii?Q?nmpW728DQpCV+C1frU5mfT0pNIdQIhiPndZ0P5a12DI1XjJozCFi5zU939/E?=
 =?us-ascii?Q?Nv7so1hiNwyeJKRUffuSdJLm3FBFohGxtitQQYZ8oytLU/ttZRj0r+Lq60O7?=
 =?us-ascii?Q?pHc6AJNxDbAlxn99BDN8v42QmYRM/fxJH1EqamYi3vMa+RH9KlroYTU4HexU?=
 =?us-ascii?Q?QQhzlogs8vMtwado2tpXqH3gD/r7W7UtKeraGeCB?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6339.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d3a83d4-8631-4f32-42ff-08dc7fac13c7
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 May 2024 06:53:42.2665
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VArepHBIJ5K5HWW26phhkM21hOheyWmv3Y7dwxjSrxJlMK5wRcXPvl1htMcvftc0NvnArmLLsmnLemabjr66Lw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB7081

> The only iommu function call in this driver is a
> tegra_dev_iommu_get_stream_id() which does not allocate anything and does
> not take any reference.
>=20
> More-over, what is freed is "se->dev" which has been devm_kzalloc()'ed in=
 the
> probe.

I did not completely understand what is being tried to convey here.
If I understand it right, iommu_fwspec_free() does not do anything
with the "devm_kzalloc"ed variable.=20

It would probably be a good idea to remove this line from the commit messag=
e.

>=20
> So there is no point in calling iommu_fwspec_free() in the remove functio=
n.
>=20
> Remove this incorrect function call.
>=20
> Fixes: 0880bb3b00c8 ("crypto: tegra - Add Tegra Security Engine driver")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

