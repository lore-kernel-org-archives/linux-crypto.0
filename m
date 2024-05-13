Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2066.outbound.protection.outlook.com [40.107.21.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DD612EB07;
	Mon, 13 May 2024 06:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.21.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715580595; cv=fail; b=ZNPdocdgnIXy+38nOozA+aJBOeOHXTwRvCAz7RmFoWg3hOgJFlqjyVr9A/A+diH8axAWV5/QmP75sO0//pTON1xIEGxxkFtHv14faRaezWzbJ65bXdXQMUK6NJoFM3goNioDBwwYUygNMbgZfeRkLb2UBzi/on9OOrk0ua3YRDI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715580595; c=relaxed/simple;
	bh=F9i7oJofwy9wIEfuXO3nE57aNxlXD5fNNgTXHPrM08o=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=YCffNtymaC6Io/5yWf0+T+wgp+xTiz4n5nNx8xQ6SV5CGRUQJIFHAeDQtQX1hx/zKj/0txYndIxWMjFaK5Zp+IZNWWmpXOMKo81qtMvSZDXQAfW1rQtAn+U/SSIijqmkNf9pGHbRxmS/pfc8XDBYlFlvXL/RjQ/JQ6BNj0VjasA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com; spf=pass smtp.mailfrom=nxp.com; dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b=AqcYyHWh; arc=fail smtp.client-ip=40.107.21.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="AqcYyHWh"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bki0rv/ZWImSb0Q74Ans7Pe4fZdCAl5//VQWTYU5D5D3O/Gkolbpdh8pUHv3Jp96ZJezWI8qqvUuuNt0j5fTVqLbscsTjQ0z2GPUAedvYL/SOOvza3/AYrx9nbHLGmJEbt/Kj+nx6io1w0ddnxBmIPhXhRQrz1cZnHZJH8w6z7URyTjDypdpgX0P6d+pfEfWHXLlQZyE8aFn1QMvsM1ef0O3gFarOmmGWuJrPJg4RQmUxSa6IhY+bgwgmuEhKpiRZkCfA/idDeix2Cs073WpoKKEyU5wyhycdNc5l9UBR9BcQh7iSHJ3oYlDunu3oU71IpcU5jSaeToYbxsHKqSR8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8YWN/6PYNNRFz0Rq6H6t3Y23q4UhsxMobOeZFe1uXAs=;
 b=VNyTrC3KE/qlxvV9p+ZFSUXIFHJJ4oDmubmZvttwbRl3oBhOHHDZI1Dxz4SvE7OXbiyzUwNOiAggHd9HNK0Yyj/NgzvfDyxt2jQ03xs1b9j/+9fiW8U5/GoX5AyytJbZBjgFj4HBBPeD/HihNeRF2QNo7SR1VKZYjLn4cXOkVCwu5ke+HBubiCLWVFvF6hrvz9ICW4nBfX802qtT/PXu9wGeNejMfzbUz4j5vsQ7eP9H2HseN+OYTwkmAJNJsE970f/EhFNJgdUc+gIQlCyMKdzEAMYy7QockRSeTjwyg+f58M6BVA6zZ4D9XHsfMz42Fvu29hx1VTtdtgF5TEIpew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8YWN/6PYNNRFz0Rq6H6t3Y23q4UhsxMobOeZFe1uXAs=;
 b=AqcYyHWh9ovqNOmMuaGSsc9VUCb4BON+1Zya7tKCsD3zl3kL/1hlN6MYLUYu+s3OK5ULE7siNmj14/rG4bAlLWVyJpOER0pA5xvEkfJjhr67AkJ26lIhOylXOwJriq1IFZMDBcRE6fGkucSaIiEQKZuarCkn5h1WNZ4rf7A+fF0=
Received: from AM9PR04MB8604.eurprd04.prod.outlook.com (2603:10a6:20b:43b::21)
 by PA4PR04MB9568.eurprd04.prod.outlook.com (2603:10a6:102:26e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55; Mon, 13 May
 2024 06:09:50 +0000
Received: from AM9PR04MB8604.eurprd04.prod.outlook.com
 ([fe80::e751:223e:aa3d:5827]) by AM9PR04MB8604.eurprd04.prod.outlook.com
 ([fe80::e751:223e:aa3d:5827%4]) with mapi id 15.20.7544.052; Mon, 13 May 2024
 06:09:49 +0000
From: Pankaj Gupta <pankaj.gupta@nxp.com>
To: Gaurav Jain <gaurav.jain@nxp.com>, Horia Geanta <horia.geanta@nxp.com>,
	Varun Sethi <V.Sethi@nxp.com>, "herbert@gondor.apana.org.au"
	<herbert@gondor.apana.org.au>, "davem@davemloft.net" <davem@davemloft.net>,
	Iuliana Prodan <iuliana.prodan@nxp.com>, "linux-crypto@vger.kernel.org"
	<linux-crypto@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, dl-linux-imx <linux-imx@nxp.com>
Subject: RE: [PATCH v3 1/2] caam: init-clk based on caam-page0-access
Thread-Topic: [PATCH v3 1/2] caam: init-clk based on caam-page0-access
Thread-Index: AQHaj7/jd4TDxURXIUidF1KPvahm+7GU2IkA
Date: Mon, 13 May 2024 06:09:49 +0000
Message-ID:
 <AM9PR04MB86046A94F0CF06AFFE5DE3B895E22@AM9PR04MB8604.eurprd04.prod.outlook.com>
References: <20240416053303.421259-1-pankaj.gupta@nxp.com>
 <20240416053303.421259-2-pankaj.gupta@nxp.com>
In-Reply-To: <20240416053303.421259-2-pankaj.gupta@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM9PR04MB8604:EE_|PA4PR04MB9568:EE_
x-ms-office365-filtering-correlation-id: 10acd133-89b9-4f08-63ef-08dc73134c29
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|376005|1800799015|366007|38070700009;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?isA8xBkJQnK+X1VTCJUK4WXbppUBXnwOO7amuA5qca2PniRFukx8+3BcUb2I?=
 =?us-ascii?Q?KUfvMvRVDnsFLpWXU1uR8QGnp/2nAcrsK3emAjn6g9Bpl9J4Wj0RWn3j8/EG?=
 =?us-ascii?Q?trU8KtXG/spfH136QoKqYo8b9S5MQLHnuXFH+QTHnplz9TOAv6bwx18pL2jv?=
 =?us-ascii?Q?lb0Wq/OYfaIT2+klqiiV+ohsq8OLakLSFAOpI2SRBB7kFaFdKhuECtoZdpOT?=
 =?us-ascii?Q?ZdhrDoN5OhkfGd4y3ISWlm4S7DDTVYe+vhtblKVqGqqXZ+twvX+hjB8byxym?=
 =?us-ascii?Q?EOmSXDtRnobX4yq+je4Pji+b/nUNXuZthIH1ZDDuTjlNxroTyHy+3B9LrhY1?=
 =?us-ascii?Q?jEAt0nQttSu1RImk1W57wF1u2PRE8w/Og8Xh6XuLFpK/ke1bOhZIkcfe/GuA?=
 =?us-ascii?Q?kQOJHkd02So7/XDhC4wYYrUlrKAoOpMMvj/VaWAKsLUDO+UCEozwIuWd1a1r?=
 =?us-ascii?Q?spjBGFJfi/JrUEejKF1c18/l0HIHD7ksvem3XsQESpAc5jocqIcmZtU5TwBj?=
 =?us-ascii?Q?ZsZrh+SD9jS90Nd4jO2G3dzQbLymDf6ELte1QRWG/mYPGcsNgLvONDcgQJRx?=
 =?us-ascii?Q?ShgjbHEbQVTkaA3BOt0oJd8KNUtNd0mSNsXcmHBh7yZ1cbblBqqKlOxik+xY?=
 =?us-ascii?Q?uXtnb01n82JD6FysMZLQrz9HJUwyCTDIIo5nPdatJlweT2hGRMeLFCvSRc26?=
 =?us-ascii?Q?2+i7YWmVX4LG/eVuSNMeFL+AFdOxwR4Z0MAbgBtsl6h4yrHJ4/LhNBSMzlv1?=
 =?us-ascii?Q?1vmTp98HIdSzO5qVxOx1U9F3SmbTx1T0yr/exoTXyDYt92r5dYhcgDth/gho?=
 =?us-ascii?Q?9vIBWeUSzZgQK+19B99wxB7s9ibC8Cgy4o/Q8NK9Sw//H2H/VONTB0Igv2Pb?=
 =?us-ascii?Q?ZfE5llnGW4ca2cPE/4dRbkzoCUCRv3dk/zZHUduJewzepRx8/klh5CLIK/CJ?=
 =?us-ascii?Q?VoObKU0i0wHjCs0gMYLgr7M+uceAyHkhV3MQvj7k7Cw4tUB7ZxBpw6yKAFNK?=
 =?us-ascii?Q?tunwop0Odrq2wb5hgEJRd+rBV6tr1h1P46aizTrCwXPTQ9Jh+S4VfFu4aPvU?=
 =?us-ascii?Q?Cz2qCq6d6G3p6ZrG7il1+yumoUTcpySRm3C1by21pWiAksJwzdeFOE2UMZWd?=
 =?us-ascii?Q?yiC3+3NkXe0akklIsLOn3ckvWqMQjUNsCxj8jl+FJY0MXoYipAn7oXNoVSNG?=
 =?us-ascii?Q?glJjWVjMbkJeIPMEiofV4vT8ifjf5JCt+q5RptABp9Thw77lUievIUL0bscK?=
 =?us-ascii?Q?bb2+oylvm7iQVEgEGWik2thazuyStkdamwVRrLxJhhEh87GNGy7AUHcGnUzW?=
 =?us-ascii?Q?swHPxS8lWXVBy8s4FdTxxUfw89pZ3RmJI2sb7Ni4cfQRYA=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8604.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?ER5QDCX2Pz1gDXRomwoBchqU938BPIeZL7xFRMK03knOE7t2mLIaZoA6XzyI?=
 =?us-ascii?Q?+5XCZXxQD5xQ6ZjovqBR/8cYoYqGT57k0xQqYsOzuU7SoEQ12KCMZ49jRKEv?=
 =?us-ascii?Q?tP2ielXh6PDCy9AHa+t32kB982n1Xop//SJ76s9wSefrDTV7YtW+slXxqY1Z?=
 =?us-ascii?Q?XzK+XqvVgIIO8geh4/tjXuPHKhvJAHwjzGKEOroZW/V+xbg3MVY75DDveEO1?=
 =?us-ascii?Q?DXDel5fPjfBYeMI8xvuxDqIMBBDQkFBIFtnTNnTV31KZNrGJKsblZvuPtlDj?=
 =?us-ascii?Q?JEC0uegcOpgQyKVnbMjCCHQiirCdXucPdUy6VF8RnG6DyWDXiWZec+Qwg1i0?=
 =?us-ascii?Q?Y3WOfbvAzzN3Gub5kl8rF4GqTRB3lJZqyqnLsGcsapjqXehO88p8TF3SuEz8?=
 =?us-ascii?Q?f0+KQ2PzBfk4GxiEGqq8hVnaO/U1U30EDk+PMPmRYVN7kwUbUJFNB87+yoIC?=
 =?us-ascii?Q?spoKw5SXFOV6xw34FLqNUzkVnasdjXB244JBTLjoEvEUITLxUkyFMntGrNze?=
 =?us-ascii?Q?tVyv1k/KH6vjZKLGt5v//XrDaB3QQtBwKwb7nuCao1SipGlXE1E/Fsb8t6MT?=
 =?us-ascii?Q?i7w9lvwycJOutCf7F7poVp8RHDBFCcS+HCizaiwC52y8tM+XLTOKl9yqAVPF?=
 =?us-ascii?Q?vChSP7iLN4Aj7LX3p+mNxBoJrb3r1jqTbzB9lhqYgLahY7cEyCnC+YbB/hAT?=
 =?us-ascii?Q?IUMriczl0T4GJuT1r3rQ9nxtbNRDNh91ZnUIPxBwSjuSpBEXkO9M/a2sazR3?=
 =?us-ascii?Q?ruEN0RfJSxA+Lk4l0jnq6HS85e9ydLS8ElD4EgtBNJhUqj+QJvKQdMmhDQEk?=
 =?us-ascii?Q?NfrR6SXN5UzE2BhqI/ThOVQDUBuhOyiRweXD51zPs0+n+sTRY+kAru6ZfTFt?=
 =?us-ascii?Q?yNw4QAFdZyBVCkDCyVhMZEpgvca+qT8q9ENhMDSDKbBCGAFFLO92IsTxRUC1?=
 =?us-ascii?Q?Ury7Xi0Wf5oLdeWHud2tZwOnwYE6Tr79TVL4p29tOIVBJvdjxwA37QNAvReu?=
 =?us-ascii?Q?j1rywXagGhss2WBu6HwBdr8quiO+0sP0b+Sd0WViGCDSQytp5atd9iE3D7QU?=
 =?us-ascii?Q?P1C3tIw7zN73SlwfaHIyi1Mht7vwMl/bavMADN31/IFsIdkVzg+oZOrl9DTH?=
 =?us-ascii?Q?oadFPJ6jhqO3Y9GSsTw9K+C463ps+jTEE46qp5iZ27UfIr5Cf4SwtNzvXQ1T?=
 =?us-ascii?Q?KkVE8Z4dewD/MU/TFDcLHqlMEE550J2qFvzwwqYbq2nTuiMo6oUVJyb0unG0?=
 =?us-ascii?Q?CsW+MA4fpeK6ZtgcOQ0KBGQu570TIdoAv9dFHmFrL/y8pGZNheEnRqAvaA4H?=
 =?us-ascii?Q?xZoMOLu2oh9LI2zTOK4/agHR5+JGbRV+UDrk3gmNnviPVbyPaK4FALe14VHz?=
 =?us-ascii?Q?/WXmXx2NAGOtc1ubN4cYeStoZrI2GVdlUupoXHLpMRE5WTiCdE+2zJFIF6hv?=
 =?us-ascii?Q?1DQAXUxBf4/ZAqFZmCKup/WkoiMr7IIEnT6a8xxsOsbZTPBrYJ6VQkrcmMjM?=
 =?us-ascii?Q?HIFDnbV1dtupDlwodcq14kw6CwkzzjLoN+EKawbzDiIaDzGPt957CMLBn5t7?=
 =?us-ascii?Q?0KELM8ODc8S15bAElU7tnDNo628IzvntwttO56PF?=
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
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8604.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10acd133-89b9-4f08-63ef-08dc73134c29
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 May 2024 06:09:49.9036
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: js1bhQRG7uY3zWyIW3LEIP6i02K8L0eOV2jYPKY/1FLBlu6l4DRsGz9Rx3qmjcXA1a7Zl85bfqEG9kGKa7GicA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB9568

If there are no further comments, request Herbert to merge the patch-set.

Regards
Pankaj


> -----Original Message-----
> From: Pankaj Gupta
> Sent: Tuesday, April 16, 2024 11:05 AM
> To: Gaurav Jain <gaurav.jain@nxp.com>; Horia Geanta
> <horia.geanta@nxp.com>; Varun Sethi <V.Sethi@nxp.com>;
> herbert@gondor.apana.org.au; davem@davemloft.net; Iuliana Prodan
> <iuliana.prodan@nxp.com>; linux-crypto@vger.kernel.org; linux-
> kernel@vger.kernel.org; dl-linux-imx <linux-imx@nxp.com>
> Cc: Pankaj Gupta <pankaj.gupta@nxp.com>
> Subject: [PATCH v3 1/2] caam: init-clk based on caam-page0-access
>=20
> CAAM clock initializat is done based on the basis of soc specific info st=
ored in
> struct caam_imx_data:
> - caam-page0-access flag
> - num_clks
>=20
> CAAM driver needs to be aware of access rights to CAAM control page i.e.,
> page0, to do things differently.
>=20
> Signed-off-by: Pankaj Gupta <pankaj.gupta@nxp.com>
> ---
>  drivers/crypto/caam/ctrl.c | 18 ++++++++++++++++--
>  1 file changed, 16 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c inde=
x
> bdf367f3f679..247d42aa32df 100644
> --- a/drivers/crypto/caam/ctrl.c
> +++ b/drivers/crypto/caam/ctrl.c
> @@ -512,6 +512,7 @@ static const struct of_device_id caam_match[] =3D
> {  MODULE_DEVICE_TABLE(of, caam_match);
>=20
>  struct caam_imx_data {
> +	bool page0_access;
>  	const struct clk_bulk_data *clks;
>  	int num_clks;
>  };
> @@ -524,6 +525,7 @@ static const struct clk_bulk_data caam_imx6_clks[] =
=3D
> {  };
>=20
>  static const struct caam_imx_data caam_imx6_data =3D {
> +	.page0_access =3D true,
>  	.clks =3D caam_imx6_clks,
>  	.num_clks =3D ARRAY_SIZE(caam_imx6_clks),  }; @@ -534,6 +536,7 @@
> static const struct clk_bulk_data caam_imx7_clks[] =3D {  };
>=20
>  static const struct caam_imx_data caam_imx7_data =3D {
> +	.page0_access =3D true,
>  	.clks =3D caam_imx7_clks,
>  	.num_clks =3D ARRAY_SIZE(caam_imx7_clks),  }; @@ -545,6 +548,7 @@
> static const struct clk_bulk_data caam_imx6ul_clks[] =3D {  };
>=20
>  static const struct caam_imx_data caam_imx6ul_data =3D {
> +	.page0_access =3D true,
>  	.clks =3D caam_imx6ul_clks,
>  	.num_clks =3D ARRAY_SIZE(caam_imx6ul_clks),  }; @@ -554,6 +558,7
> @@ static const struct clk_bulk_data caam_vf610_clks[] =3D {  };
>=20
>  static const struct caam_imx_data caam_vf610_data =3D {
> +	.page0_access =3D true,
>  	.clks =3D caam_vf610_clks,
>  	.num_clks =3D ARRAY_SIZE(caam_vf610_clks),  }; @@ -860,6 +865,7
> @@ static int caam_probe(struct platform_device *pdev)
>  	int pg_size;
>  	int BLOCK_OFFSET =3D 0;
>  	bool reg_access =3D true;
> +	const struct caam_imx_data *imx_soc_data;
>=20
>  	ctrlpriv =3D devm_kzalloc(&pdev->dev, sizeof(*ctrlpriv), GFP_KERNEL);
>  	if (!ctrlpriv)
> @@ -889,17 +895,25 @@ static int caam_probe(struct platform_device
> *pdev)
>=20
>  		reg_access =3D !ctrlpriv->optee_en;
>=20
> -		if (!imx_soc_match->data) {
> +		if (imx_soc_match->data) {
>  			dev_err(dev, "No clock data provided for i.MX SoC");
>  			return -EINVAL;
>  		}
>=20
> +		imx_soc_data =3D imx_soc_match->data;
> +		reg_access =3D reg_access && imx_soc_data->page0_access;
> +		/*
> +		 * CAAM clocks cannot be controlled from kernel.
> +		 */
> +		if (!imx_soc_data->num_clks)
> +			goto iomap_ctrl;
> +
>  		ret =3D init_clocks(dev, imx_soc_match->data);
>  		if (ret)
>  			return ret;
>  	}
>=20
> -
> +iomap_ctrl:
>  	/* Get configuration properties from device tree */
>  	/* First, get register page */
>  	ctrl =3D devm_of_iomap(dev, nprop, 0, NULL);
> --
> 2.34.1

