Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2041.outbound.protection.outlook.com [40.107.21.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B63E0381D9;
	Wed,  3 Jul 2024 05:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.21.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719985529; cv=fail; b=IhK8MNg6j/NLiN4targlJOOV7zm2iFCyOr21cBeyUFCJGlePQzve7EERlsZNbqCRpJTM+elS9fc/3tbciLDXrl6KDPc1uDuvXa5MGTQ8PiaWTuJq+5B7cDJ21+XPxrn58DRxKLAi+tGJ8WVpbcZXJHDRyG31O+PB81YBe51/Kkc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719985529; c=relaxed/simple;
	bh=GjSb/xhaZX9VGw9dXNmiBDQnQ392SvnvTTRZO9XVgCU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=PRDIBqdhwImynDIepn6IeVjH+mYLnb4j3JSizI5K2opLPqbD2FkFIXMlSINQb6TvjvB2dryLb9vHKbDLG0CBWeYjDJJz0MINVkhPZVisdyeHNi1eFaJ1NkmuLV8gCNmMoOXvaEtmAhQE61NaxM4iytFxGRrp6DyuyqdcgR00aaA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com; spf=pass smtp.mailfrom=nxp.com; dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b=Ou3MUn++; arc=fail smtp.client-ip=40.107.21.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="Ou3MUn++"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CIHYJ2a4SqJ/r4Ab3eRBkvqoEs5CSuN3dTiVTSzSPVtCt1zUl3gtLxjeKFnSZB6nUIc5eo555SUttSYsvottOrTCt428p/1kxeeoe1gvCojQgLCGRbBU7H/UZtplVQ7oi5uXWvjCVoP6qWsGgG5DZBdJ8RXjcjXTUPVeUqarZQxsKdyphEM2Kav/Zzq7nsXd7Ahes597uqMPQbY14OLYTgeeoxd6TM1vFBWIzUO2XemlIL+1S4e+tHCQCip1P56Z7nXAWzD5CpcIvVWMiwcwc31n46fajqig45MyqzAOK+HnyNML2LCfIpW+PhPZmK+wXNu2gc+UQNLFp3KySHb8gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g3D0E4F2vXtp8lCbpLAnyY5wqTTAjhx6wv++DDP6d1E=;
 b=hr40RFCAg5AB96tabKbGUo89mzWIaLnuybiSklflpPqSP5iBc//VcLf36yblQHPcERXGkdUWLMcMhKMe11spy5MhSALILNShsq49ehsLTXQ5pAoaPO8MJIec0YcCFKi90BK+7A6tL6ap+5uY/IbKvLCO0GQR4EUKoNNH3d6Hwgv2usgt2h8lu0i6S6XSXLjRi+/Qn0VwEqrk2rdtsczpEjDCQ+L3mgqQHyaDdu9+mamUHnZBhXgpRwnqNEz1AhIs6I4qMUnxvqm/kxAM6/LdFmXynumvrKQuSToBF9dbaqwNqzQgAfY9g2xIF1GPvn9iWmN2kQuoirUiUqL3RvdZ7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g3D0E4F2vXtp8lCbpLAnyY5wqTTAjhx6wv++DDP6d1E=;
 b=Ou3MUn++jP+lHzwDQwht6Q4cPPQOuPspL5WEYeSI+6VC7SWsx3HeOwQXIQfYZCDXFIzxr1l/LMlc+2Nto44KBzMuU7CI0ssP4H5pTFTYLA1v4DlBeGIpCNTQdjZMJnEzf4+0rfg13Qg+bZCo2On4POnxNDLn/AUcj/c9CjwL2rs=
Received: from AM0PR04MB6004.eurprd04.prod.outlook.com (2603:10a6:208:11a::11)
 by PA4PR04MB7517.eurprd04.prod.outlook.com (2603:10a6:102:e0::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7719.32; Wed, 3 Jul
 2024 05:45:23 +0000
Received: from AM0PR04MB6004.eurprd04.prod.outlook.com
 ([fe80::cce:19af:927c:36b]) by AM0PR04MB6004.eurprd04.prod.outlook.com
 ([fe80::cce:19af:927c:36b%3]) with mapi id 15.20.7741.017; Wed, 3 Jul 2024
 05:45:23 +0000
From: Gaurav Jain <gaurav.jain@nxp.com>
To: Breno Leitao <leitao@debian.org>, "kuba@kernel.org" <kuba@kernel.org>,
	Horia Geanta <horia.geanta@nxp.com>, Pankaj Gupta <pankaj.gupta@nxp.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, Herbert Xu
	<herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>
CC: "horms@kernel.org" <horms@kernel.org>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [EXT] [PATCH net-next v3 4/4] crypto: caam: Unembed net_dev
 structure in dpaa2
Thread-Topic: [EXT] [PATCH net-next v3 4/4] crypto: caam: Unembed net_dev
 structure in dpaa2
Thread-Index: AQHazLGebJwNbqWlTUypjU271qfbYbHkfcJg
Date: Wed, 3 Jul 2024 05:45:23 +0000
Message-ID:
 <AM0PR04MB600485850F153B6792CA8C0DE7DD2@AM0PR04MB6004.eurprd04.prod.outlook.com>
References: <20240702185557.3699991-1-leitao@debian.org>
 <20240702185557.3699991-5-leitao@debian.org>
In-Reply-To: <20240702185557.3699991-5-leitao@debian.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM0PR04MB6004:EE_|PA4PR04MB7517:EE_
x-ms-office365-filtering-correlation-id: 4969cebb-f07e-4ca5-5664-08dc9b235568
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?Pzj3EGB+CcD1JzrQmPgOzIN9yCcwvzKmITVsJJ1OzWFeKCxkKQXACLas50ee?=
 =?us-ascii?Q?ALhX3R0UnG+HVinmGKnoYevbiuTq1gpPJG3YRSc8fX8YPsxup97KFnfVf5Ji?=
 =?us-ascii?Q?AKbQUSm0rblrUvTEoe9UF03csciOyzT7Vud72UrbtT19ypm1TE7CVmebapj7?=
 =?us-ascii?Q?yWqLV0+4Vedlpodbzo7888T8IlDCoC6HC2NrcCH8gcG/JfgkBEPJnUGNMSpD?=
 =?us-ascii?Q?++obUu7wyvHjyhkU7uGTmZECO1RkPKi9RnKZSKiad1gJWfFStU4ll55t8pqP?=
 =?us-ascii?Q?BihqQfZYbJUm3rkUzzI6Y7aGGo/9/W+FwIGa7cBXjAn0lCgXp1R8Fm9JMLor?=
 =?us-ascii?Q?psr2D04GPztemFVkP98eT49xL4T5Q5WzRPtMORJWswPWc0fQXqoB58eibG93?=
 =?us-ascii?Q?m6CKkSqptevhsjOxH9cZ9xyoJHFfclh9f8PBwqlqLyGtc7c/vLogOz2qpOru?=
 =?us-ascii?Q?yQyofG7KaCbYWhsta58wrISz9Q6I4hxem9Y7mhK4ooRJIzv0CxSPKUNgpPtD?=
 =?us-ascii?Q?njztf3SJmUEQMC1Y3ipCE35IKIx4PqCfeyn9s0C/jYwQXf/8ccEXYLrXU5aa?=
 =?us-ascii?Q?bHneO3wRsXH+g8PjEeZAeus1pNKvMaRw6hxdbZ0tpB1D3ja6FajxivJB0BYn?=
 =?us-ascii?Q?CuiKEZWmGBCeboLwQQQJVKOX7XTYoFVZ69NVfSMc4UTQjuHmwIN7tr36kEYY?=
 =?us-ascii?Q?gX3WxHyANM95XotimdY6pTpWOLmrv2kMJRWo0YZbsAnBs/06308V6peXHV9z?=
 =?us-ascii?Q?NeXOtA+eVAJaJm2Xaxx9Ze+s+BFvEVoquHQJ+CfF8cSZkh0NuETSqeY/pIZ2?=
 =?us-ascii?Q?ujc1s8Yrm0BNVxsJU3+tnfFqW/yU/7TmwovJowkf4APFervXZNIzyBOwAZmp?=
 =?us-ascii?Q?ukt/JKIHLEfj9rL0T/tet86bYY5tSL5SDlZeeoYuVLAj3o0HCdp1nSvCBUbV?=
 =?us-ascii?Q?YE/KObgdGNgdZsDTjseskcypqRHy4/ugndpS7wZOJ2oQdKhlCUPlTIYQhz3M?=
 =?us-ascii?Q?DIjT4mf+cxwt0pNW9ldLlTgf1/ASMCRDA3sORTjKF41pERYRconPS2XZhneQ?=
 =?us-ascii?Q?WemTo+klM+ohcTXm0RkfTc5evjkU4BHuzmAqgasx0JAwYyVtBVhnVdvEICyN?=
 =?us-ascii?Q?eelukRUWhnKnTSgOBCL8bJN869zluw9bjI56YQJxw/WkvMR33P4FcCGogN/3?=
 =?us-ascii?Q?b2cjXZN5dGnL0iZk58pSQGbQVQGIfD1DoKgXQU8ACH9ZrT6JmYqciV4t+cMV?=
 =?us-ascii?Q?5T+91YoAJL3OZnfh909lyZ5WophsFcVe8XTcMWT3yADBV5JR3+iRUmJx/RZD?=
 =?us-ascii?Q?uZMN4ZVD1qbZUpmWpucNHWBoAQDKdLqMs1O24ZFBDTJpu1wSW/1byfwiiOea?=
 =?us-ascii?Q?RMahWOk=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6004.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?6B7A1hcg0QyTxQAs5ddcRK6CBvKLLaufTt9g1McIZzSxb2ck11Wyl8ltYV3x?=
 =?us-ascii?Q?beEtcpz74ASnSN82qPhim76pL57DeE58fpIxMK5SQZ2wswGETNm1ZiHqX8ju?=
 =?us-ascii?Q?JZn7stLdk8+AJCSM0BXaFI5MwUMSnJC4rQ2W8ndjh7m6i3U8YJeIdU4lBH+j?=
 =?us-ascii?Q?AbVQHjbL380upAtDA2E0QKTLdKE3yTZYYILk9TpayIUtnFss5+C6GJT6pAOa?=
 =?us-ascii?Q?lEMcPsa1rkjo77x9Thl01mFs0wqhVCbZ7mzfBT0O72ZZjVryyOutTx1zvuNk?=
 =?us-ascii?Q?7WOamNwr1I2GusxD2bhiAwoSyericiMaF0Yr0OQv5TiEYPRpvW2hwygoarjM?=
 =?us-ascii?Q?CkD99IsKeT70pWru8PDuSaemcPKXl72NfozudchOEUGltzQdbck9Wl7FJwM1?=
 =?us-ascii?Q?rDOBgPQsBzaG0qx17fH0euJOQzqoQbFMLtPYh719GaEx3289BiBIhr72wahe?=
 =?us-ascii?Q?ZEtmJEzaeGWCvOAnuQJdw/Xdk/3JVyCvihRDk2v6yOS/50UDthAAqpZ4RjZn?=
 =?us-ascii?Q?V1gIsoELO3Tygr+/mzmu29DL+KQ04ZrnKVrVY3BJjHGYGlb5IWTQyexwYQiM?=
 =?us-ascii?Q?szczjbBj0sg9Dou2qZuS4TwC/mMlO/YEQJ9S0PuJjeM01vQofU3NlbIAdxAh?=
 =?us-ascii?Q?OxdyC3da6jEjSDoSDCPMSRzGWFwo5EbxetOuIRtSk3cEKFxiFLp39um36p+z?=
 =?us-ascii?Q?2qHTKsRAwODn/SqpOb33vpQHmG3f/BnKxWOoDLoaxAOFDouAPqL9WvexG+Wi?=
 =?us-ascii?Q?mP/SLSW0oE1DWCnIvol3dMGASGxiCs4JkvY08aEj9pEg7NwtOZwGq+2PoVm7?=
 =?us-ascii?Q?yI+U5EJk4qMzUerU2DCUlgDnyLiYFtF0qAcUwCZzmdQLIpi0X7UAmLaIa4m3?=
 =?us-ascii?Q?HcDFG/eIjnCwT6GY2D3TALFT8LfZdMNC+WrzkChCJ02YloueerhXda17xia+?=
 =?us-ascii?Q?BEk2xVU6QYOmu09j1g0+fGG8Mjc/aUxJ3vxH4HxQALQwMHuELWr/Yr23Cw50?=
 =?us-ascii?Q?/v6v61B1NQNnK/k75Bm0iwFlD1M6YdotdSLgjCor6gHFU2lNqghQI4lXlg+o?=
 =?us-ascii?Q?d8UW/x7q+CYfyW5lanHKOOj0thAp5qCl3cMKCdMeIjyoGYAm45blwfRDiJFI?=
 =?us-ascii?Q?yHNN1fnOagT/v6RkNmQa5oPnyLCDu5GxC4BufOsIAfnFCqId81oDo50sfcnP?=
 =?us-ascii?Q?HlPPZETN9CXacx5x3sYvXnp2scQX5JVDRp1M8KYdK6f1ENpnydwbYU+m93/e?=
 =?us-ascii?Q?2UWvD2xhtupeR1OfaXIy/4OqNbniPhrOtHNQsNtVZ3k2vvMi0FurX1WjG2FR?=
 =?us-ascii?Q?EFL5vuS+JE7lYi300pwHS5S1K974QyMvUxuGUr4DrYYpAHmb1A7hlVVpjX1+?=
 =?us-ascii?Q?4BNUsgR9EBmNtUsQYtog/8Zh3c0X2sFox3oz2gDjUABOnap36k3L6rqy1bwN?=
 =?us-ascii?Q?8HVYWuxBOIAbZGE7oHprfljvZNLgQ4kaudR4Bl2aSYyaQifYnsX/nXx+9Uvr?=
 =?us-ascii?Q?B8jbakfQqqrNN6PO+GGR/x+Xrq5awBCIFzS58NnmWUOHdU5vv5x1sFDS5FhT?=
 =?us-ascii?Q?cQ9hIIRwYEdq3gr9kulEJyOEs4lYmS5fptKzeEnk?=
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
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6004.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4969cebb-f07e-4ca5-5664-08dc9b235568
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jul 2024 05:45:23.8452
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Rl9yENygivjLjzw6uSNbkmdYwomz5Myx4ALx0rprd32HAlh+N03cVra8TsNLHsrqxmKPi0OOqqlkDhopnqPEew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB7517

Hi Breno

> -----Original Message-----
> From: Breno Leitao <leitao@debian.org>
> Sent: Wednesday, July 3, 2024 12:26 AM
> To: kuba@kernel.org; Horia Geanta <horia.geanta@nxp.com>; Pankaj Gupta
> <pankaj.gupta@nxp.com>; Gaurav Jain <gaurav.jain@nxp.com>; linux-
> crypto@vger.kernel.org; Herbert Xu <herbert@gondor.apana.org.au>; David S=
.
> Miller <davem@davemloft.net>
> Cc: horms@kernel.org; netdev@vger.kernel.org; linux-kernel@vger.kernel.or=
g
> Subject: [EXT] [PATCH net-next v3 4/4] crypto: caam: Unembed net_dev
> structure in dpaa2
>
> Caution: This is an external email. Please take care when clicking links =
or opening
> attachments. When in doubt, report the message using the 'Report this ema=
il'
> button
>
>
> Embedding net_device into structures prohibits the usage of flexible arra=
ys in the
> net_device structure. For more details, see the discussion at [1].
>
> Un-embed the net_devices from struct dpaa2_caam_priv_per_cpu by convertin=
g
> them into pointers, and allocating them dynamically. Use the leverage
> alloc_netdev_dummy() to allocate the net_device object at
> dpaa2_dpseci_setup().
>
> The free of the device occurs at dpaa2_dpseci_disable().
>
> Link:
> https://lore.kernel/
> .org%2Fall%2F20240229225910.79e224cf%40kernel.org%2F&data=3D05%7C02%7
> Cgaurav.jain%40nxp.com%7C5748b86d20dc4be03e0b08dc9ac8bfae%7C686ea1d
> 3bc2b4c6fa92cd99c5c301635%7C0%7C0%7C638555434196331223%7CUnknow
> n%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWw
> iLCJXVCI6Mn0%3D%7C0%7C%7C%7C&sdata=3DLtDEO2Ko6WFFfip9iyj%2BQycgsBE
> LG3barb9byRSxQCg%3D&reserved=3D0 [1]
> Signed-off-by: Breno Leitao <leitao@debian.org>
> ---
>  drivers/crypto/caam/caamalg_qi2.c | 28 +++++++++++++++++++++++++---
> drivers/crypto/caam/caamalg_qi2.h |  2 +-
>  2 files changed, 26 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/crypto/caam/caamalg_qi2.c
> b/drivers/crypto/caam/caamalg_qi2.c
> index a4f6884416a0..207dc422785a 100644
> --- a/drivers/crypto/caam/caamalg_qi2.c
> +++ b/drivers/crypto/caam/caamalg_qi2.c
> @@ -4990,11 +4990,23 @@ static int dpaa2_dpseci_congestion_setup(struct
> dpaa2_caam_priv *priv,
>         return err;
>  }
>
> +static void free_dpaa2_pcpu_netdev(struct dpaa2_caam_priv *priv, const
> +cpumask_t *cpus) {
> +       struct dpaa2_caam_priv_per_cpu *ppriv;
> +       int i;
> +
> +       for_each_cpu(i, cpus) {
> +               ppriv =3D per_cpu_ptr(priv->ppriv, i);
> +               free_netdev(ppriv->net_dev);
> +       }
> +}
> +
>  static int __cold dpaa2_dpseci_setup(struct fsl_mc_device *ls_dev)  {
>         struct device *dev =3D &ls_dev->dev;
>         struct dpaa2_caam_priv *priv;
>         struct dpaa2_caam_priv_per_cpu *ppriv;
> +       cpumask_t clean_mask;
>         int err, cpu;
>         u8 i;
>
> @@ -5073,6 +5085,7 @@ static int __cold dpaa2_dpseci_setup(struct
> fsl_mc_device *ls_dev)
>                 }
>         }
>
> +       cpumask_clear(&clean_mask);
>         i =3D 0;
>         for_each_online_cpu(cpu) {
>                 u8 j;
> @@ -5096,15 +5109,23 @@ static int __cold dpaa2_dpseci_setup(struct
> fsl_mc_device *ls_dev)
>                         priv->rx_queue_attr[j].fqid,
>                         priv->tx_queue_attr[j].fqid);
>
> -               ppriv->net_dev.dev =3D *dev;
> -               INIT_LIST_HEAD(&ppriv->net_dev.napi_list);

napi_list is not needed anymore? There is no mention in commit.

Regards
Gaurav Jain
> -               netif_napi_add_tx_weight(&ppriv->net_dev, &ppriv->napi,
> +               ppriv->net_dev =3D alloc_netdev_dummy(0);
> +               if (!ppriv->net_dev) {
> +                       err =3D -ENOMEM;
> +                       goto err_alloc_netdev;
> +               }
> +               cpumask_set_cpu(cpu, &clean_mask);
> +               ppriv->net_dev->dev =3D *dev;
> +
> +               netif_napi_add_tx_weight(ppriv->net_dev, &ppriv->napi,
>                                          dpaa2_dpseci_poll,
>                                          DPAA2_CAAM_NAPI_WEIGHT);
>         }
>
>         return 0;
>
> +err_alloc_netdev:
> +       free_dpaa2_pcpu_netdev(priv, &clean_mask);
>  err_get_rx_queue:
>         dpaa2_dpseci_congestion_free(priv);
>  err_get_vers:
> @@ -5153,6 +5174,7 @@ static int __cold dpaa2_dpseci_disable(struct
> dpaa2_caam_priv *priv)
>                 ppriv =3D per_cpu_ptr(priv->ppriv, i);
>                 napi_disable(&ppriv->napi);
>                 netif_napi_del(&ppriv->napi);
> +               free_netdev(ppriv->net_dev);
>         }
>
>         return 0;
> diff --git a/drivers/crypto/caam/caamalg_qi2.h
> b/drivers/crypto/caam/caamalg_qi2.h
> index abb502bb675c..61d1219a202f 100644
> --- a/drivers/crypto/caam/caamalg_qi2.h
> +++ b/drivers/crypto/caam/caamalg_qi2.h
> @@ -81,7 +81,7 @@ struct dpaa2_caam_priv {
>   */
>  struct dpaa2_caam_priv_per_cpu {
>         struct napi_struct napi;
> -       struct net_device net_dev;
> +       struct net_device *net_dev;
>         int req_fqid;
>         int rsp_fqid;
>         int prio;
> --
> 2.43.0

