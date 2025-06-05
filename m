Received: from AS8PR03CU001.outbound.protection.outlook.com (mail-westeuropeazon11012061.outbound.protection.outlook.com [52.101.71.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5686C7E1;
	Thu,  5 Jun 2025 08:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.71.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749113382; cv=fail; b=WIpnDCiw8XpL4HBkAHmkJMFMBNyWggeYc5rsloGfjS0jvrxa8KqxoQrClP2jL3MaoUeXaGS7ND8SMhaGuaq1g83NFUoWRMPwU7f2qwgK/anoPLBRLWuoLWnD90JuuBRYFaDEjL7kp8ep/r1ztbFzk1qu/fBgRBwHQjxalrzYN9g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749113382; c=relaxed/simple;
	bh=Z0C4/Nacr9BJ+tHwN6ZyVBCHXR4em61TmanWwocXE+k=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=MERzNOz+9VFwene6gX5zX1ER8uVigBL1QN5dubp4Xu+Pw0jgEEfDW/XP2cxiEplQWdl6yVqdGwho7r7JZkJy42wtv3lSQ6r9Kbn+nFZrdwszIay1zqHbhymTthTpSy0dIgqlAhtfW+px5GG3Ygd/gD6e6UpQFyKNJebL51ggbNY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com; spf=pass smtp.mailfrom=nxp.com; dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b=fE4QoAnH; arc=fail smtp.client-ip=52.101.71.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b="fE4QoAnH"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=L2iV3lGZP8e8vGZnWHxwkU7aF+BKhJCbP+5gP09x/fbVxKBicDs4W8TcwFwOzqomZpwhuw+bgRnf1Ea7iCxm9cqRsFEwBykB/Jbhf5wWPfhL0p3cj0ml9WKZOuXkYAh8h/UQSnLdFfq6Opr/PRHAjrbnZQvFjz85tLACv2G0BGfCpSrWAa14BDZNiK6nKdyDsZZLhCgd5hPyKdcFqrcovd2DGR4kGwev2Ik5YvS7JsiAFF0ONRQ20dKDATPgize+7v6zLyUQjX6cc4pbRYbyB0WVOXuIT4Rm70rIsMdz825F6wafPoUkJ1LJ8CLGVkgFIGtQ9mFE2uSEJvQ8XbUisg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uisRWVu8MVaUFRZUVNKQ+z0gG1fMm1NHu7TKgkHy4kU=;
 b=cQn5C6cxWagRKr3bxEi/mi3o97cwh41V4Y+CFP04PV0aS4ThHO14/KU1VViuVn2WUuiDe5R4Y9WtsgosoHpS8742AcDc3OvzZuVMeB3xczMO0tGaHtXyTsQMfNFYQ5LVexCD7K17/PjyIod7n0CPuGy/91B0WRX6xfXW0GiVscnsz5ztxXGNkOkeojZl7hKJdjwOKRio7iiW+p9ghgY1Z+FFblonxyG3N+lKsOixWI5EwKbbb8vXkeKhYMzVzkhCgs+GanrzumSe5nfn8eDd461lIn0YoubuX6g9aD4xLH5TQuRL2ECv8H+SV0MW5+fYr5oucLZHrjAowki83ra/eA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uisRWVu8MVaUFRZUVNKQ+z0gG1fMm1NHu7TKgkHy4kU=;
 b=fE4QoAnHxWTmUk0TfchVj3l7z8qFU4HZedIh82NiUbNHX774FPOvVS8/LMyg2VEncWZB1XQORy/c4C9X1VoG5WxVNxePnjIJgTXEc8pT+Giff8dnGaAey5XgMX8Go3J7tKom9g832zlUQm304gOFSZI5/mtKvpu6Ak4mUp39M1PssaEHlnFarhM4wUwco2SSlWGSChj5LcBohvuHR++0U3ou66LRinlepUY4tO6anMuR79I9ulq6+x5cnczkhrpf0vX6Vn1d7sb9m5I3aqa2WLoYXdoXi9abku7CzEqsZ1X6eoPJvJDMUt1/8k0in46cz4gMvMHtLcQ+Pjj8tu1Ziw==
Received: from DB9PR04MB8409.eurprd04.prod.outlook.com (2603:10a6:10:244::6)
 by AM8PR04MB7762.eurprd04.prod.outlook.com (2603:10a6:20b:241::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.34; Thu, 5 Jun
 2025 08:49:34 +0000
Received: from DB9PR04MB8409.eurprd04.prod.outlook.com
 ([fe80::1436:d8ba:25b8:1637]) by DB9PR04MB8409.eurprd04.prod.outlook.com
 ([fe80::1436:d8ba:25b8:1637%3]) with mapi id 15.20.8813.018; Thu, 5 Jun 2025
 08:49:34 +0000
From: Gaurav Jain <gaurav.jain@nxp.com>
To: Meenakshi Aggarwal <meenakshi.aggarwal@nxp.com>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"davem@davemloft.net" <davem@davemloft.net>, "linux-crypto@vger.kernel.org"
	<linux-crypto@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] crypto: caam - Set DMA alignment explicitly
Thread-Topic: [PATCH] crypto: caam - Set DMA alignment explicitly
Thread-Index: AQHb1TmJnegIOh8JikW+CmFDbvUZV7P0Qwgg
Date: Thu, 5 Jun 2025 08:49:34 +0000
Message-ID:
 <DB9PR04MB8409F4DE065B0EBFD9B45D2CE76FA@DB9PR04MB8409.eurprd04.prod.outlook.com>
References: <20250604101446.3993932-1-meenakshi.aggarwal@nxp.com>
In-Reply-To: <20250604101446.3993932-1-meenakshi.aggarwal@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DB9PR04MB8409:EE_|AM8PR04MB7762:EE_
x-ms-office365-filtering-correlation-id: 681345d3-2f5b-4225-19c7-08dda40de520
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|376014|366016|7053199007|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?RWnWKhcu8CsjhVM52m8SeRz18PMJx7Nm2n3MpGuakw7Ozn/Xoj/FFmRIFObC?=
 =?us-ascii?Q?0P+iyVORPNVLvrJV3W3LPNS2rtcGOubJyU4YcIOaXQi8+SlTvsRvY6+3PcYE?=
 =?us-ascii?Q?RZ1W9FDOrqHK0wZHclgUiwQlA2WE6F1OJCLyK/ILBunYGiOpT15HqfnGtF9h?=
 =?us-ascii?Q?eKbceqaU918sPROIlCx1pe/KUU/BadPXl3nhGePLsl7gctGjXbbOmDiUlXPx?=
 =?us-ascii?Q?jsUOz5ifr+Nhy580u7w/97/gy6UwI3QYlzJRclpGgWudfQoeuZRLisdabKFX?=
 =?us-ascii?Q?DAIv5NyLU8KSMIEWzRLnZ+POnZVbq1DJ7WMteUob4QB0gEg4F+dnNjRfL5NT?=
 =?us-ascii?Q?9mQIr4IFzFAVOzGsWPbftkLQJ43YngdkQRBOH1NdecySyCeE6tC6hIor9Cdl?=
 =?us-ascii?Q?ApiUv8bEWoRqEUrqhldDi2Ei9xrYISdlNato9X98PPK2U8c3cPrDYNF+SVCR?=
 =?us-ascii?Q?lC/3Q99K/uCYOXIJR3DLlFW3uCPkqYy19znBpPgLAg4DaGf36hlVJjs1tjAA?=
 =?us-ascii?Q?eSz9GkNy3k1MC2FyZ8e9N1RQ24AxbQ1PMXtEqJWrpJVojqEOf3V4t+b5teAK?=
 =?us-ascii?Q?LdUNmWIkOfEdpIzwk2K80rAUkpwUUKxJYkJfHI0rAVE1Lk92aBPg4i/FfCao?=
 =?us-ascii?Q?y0RJkFi3y+33wW28Dn8ZZfgEotSfVeAise9AvVg3jMUR+wZB7L9IZn9uooTI?=
 =?us-ascii?Q?IzLXB4w0OZPOjtE1mHmmb7mCQfxidq102N0RG0vqgp2Z9+JZhJKlvsKuD70q?=
 =?us-ascii?Q?qQSw4sTfhYmHUDgwkkHJTbL5pLqYht3bOB9NGdtQco/yrn1iAitCbw6Y3noB?=
 =?us-ascii?Q?K/+h20cRT7SbGGMlp549Z/Qs0OVVDtH3BXgJCFuO3zz7zx0czMhj8jk7nZWs?=
 =?us-ascii?Q?3mNttIb8JJ5FbtvnfodX3aLycWe3TON1zsEODz3dQgWVQls0jBpAvdOyBfaZ?=
 =?us-ascii?Q?OBegZuz1lsTSSKRa2sUYDZ1thb0GSvqeGdLXMtBjm4WBLzFLd1DVuIQcaLea?=
 =?us-ascii?Q?+Un4NUl2GdScJsDNQu2uIHbhllVjnZBH5Ct0DiJs9RG46biGe8q+15qeMjid?=
 =?us-ascii?Q?khoOS2nNxQNHk5X0ht/jEpPCFr3AbizleigR8xa2NumcNyVAbQym9ZoV3nGR?=
 =?us-ascii?Q?FJzjF64Ye9dh0CbFiMFEMsAetXZj6PKO2jxF+QAJKhjb+lKGKxsHZUIUrisR?=
 =?us-ascii?Q?4ji+Ga9IGLp5r3ya/C2ia+KUg5MotVehWRdAi7jXIvCPd1lJKpwa8lFSLg0P?=
 =?us-ascii?Q?v0ERUQ+s6iXbYwYLqP9XAF2frjpx49mvxLrhoCQSKZRfpugOg/+ev2bJkW2j?=
 =?us-ascii?Q?ih9LbK+MTB0J/cFpUc3YxyV5sU3mhgUcRSsV0x43a+PJ8mYLlb9y1ZLYJoRy?=
 =?us-ascii?Q?C/AQmcgRhakRawOZQeeJ1YlzutdacorYJNMdGhaerTZVL241D+TN0S6BPEm0?=
 =?us-ascii?Q?+DwRRnVN4Wus4lWTW9WBcu/4JtkbKqD1AM7ZbxwgjwVNQzWSKVoWG8dPObUy?=
 =?us-ascii?Q?PXqajVD/ywu3nGc=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8409.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?0JP2vnbNpv5rcjGC+cKb4fmtW7GYeCojDJKPaX/ec6u84FL7krzdSsaSJc9C?=
 =?us-ascii?Q?wWsTsWjhg9Hyk2czpWzkZGdGGRa8LJXCa/9dPiR8zCy/GIVZQHKPDVzL6wv4?=
 =?us-ascii?Q?demlpcX8zA73X/JN1vbwztTj3ypXuHPkx632z6LA3sOjXmz0QBrfV+tP5Xir?=
 =?us-ascii?Q?GjaVdlBosb6fZ1Dec144adq1lA4I+7gFNjBiE6eYQusMUEw2Og4ZF81eZ8N7?=
 =?us-ascii?Q?B/MnWEe1f5V4064bFHdUbJu3fHMQoEB6hpoLLt7mZop9rgnp4a/tHa2cHOaP?=
 =?us-ascii?Q?iM8ldEqqNsdJUL0PPYtwDldqxubVUVVnjjNR2eSa6cxItJ4wVxyWmSrlUlES?=
 =?us-ascii?Q?eHd/S3vteGNbePrXi2dJXeLp/I8VtTZ/+Jp+HMVQXETdqm0sxFcMdVFEADOB?=
 =?us-ascii?Q?4+UveyHzRIVW5WKkdPP35QmFOBHQCBo/rbbSzVzA55F/9tymim3cu4tOIdEM?=
 =?us-ascii?Q?q/wV5BiU8HVr+gbH44xkWaBWuxIB09otzLjDCS0y2zMznWyz7Sf95jak3Ubi?=
 =?us-ascii?Q?xrqIUmvw79oawWi21iuIEmPjjjtV7GDNUq73GeE60AW20MBqJhMo8QNzi/Bn?=
 =?us-ascii?Q?KNOjvzy+kP1Mg3yRWmQAIefM06F1ZAK3jIvlSSwWL1CsHklxJ97V5Zw0ypP7?=
 =?us-ascii?Q?2xFYLMW70Yd6wYzAKTsB+thPn0MkvmZ+gQqzkclMavRSSC4VzlEEmsNtGJKT?=
 =?us-ascii?Q?HfkVChNfFS7TXsBbVYyXqvsVBWlFLA9YnU0xKfHZpf4F6tcVc/nq80vw5jXd?=
 =?us-ascii?Q?9pyZGPWtpaq7nlmgK7XP+D/+LdKGvyi5LvIwL48wA772JWoXzW0cWM8ax4Rr?=
 =?us-ascii?Q?s9PwXFbstGqc7yGa/6yiwhi+/MI4eieHRfWP1E3aLMReTC7g6D0u1n7pxZj6?=
 =?us-ascii?Q?r1WK1j6Lw6b53yGarORw05hdY2TpGJUgKJiCFN5n8YavdUexhcjLO4Nv+Ajs?=
 =?us-ascii?Q?o4diNciQvLpy9KoOmJc4F+dsqKpmlkAkJpBwaC00L/DCIc7utxGlgKX3JEOX?=
 =?us-ascii?Q?h/u7A9JQSYF+9wf+W913yHy5xWYgpZWkwMTAIvip1sPHgGnQounVy4snDmWH?=
 =?us-ascii?Q?o3KLJJ/49A6UD6SkBauP//i/6tMKDn5AQl40Ucufh8wHTHB057xTFicyQU+F?=
 =?us-ascii?Q?4AiShxahmgk3Xol965CgHMqAFkoq8MZgkDJWCGSXbdbISjAL4Sn8wN6DxGo4?=
 =?us-ascii?Q?xxAW2CCewALPyQpEPszS7dksgOZxO56hCpRQEIdPlj5BTmVed+0v+IqOoCJ0?=
 =?us-ascii?Q?UjbCQn7GtSHfQKR3oLtPylM5gYubpg70/mQNJ0oIIbRQ2GVUD76s8MsbGlvN?=
 =?us-ascii?Q?EPSJyew2cYNKzxP43nGufhX/7B7aMYnit+YHsk+mEsqxsBhe4tfjCAkVCd2a?=
 =?us-ascii?Q?fKREoRihBT4cJMxuoUXtgqBEqU8eBXl9iX85lGo1gfrLxLWb/dB7Cdih5gjJ?=
 =?us-ascii?Q?n0YRutji2D6pKYKFL962lsnngAuYMecVpcfo5QbX/Tq+7wvCKw0dpYnZ6bIn?=
 =?us-ascii?Q?tt72dbgebUlWrc2YnqkP2YJ2BRSQ2+SkuHkTrTTC8TCGdALnCDKcjacaSQtA?=
 =?us-ascii?Q?ba7KM0Y+aBHt6pRtfaWa/oB2aV7Ibtme9yy4733q?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 681345d3-2f5b-4225-19c7-08dda40de520
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jun 2025 08:49:34.1699
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ahq6WrHb8utuuT/hMiX4C/GORavoegr+tX4Kmq/6C/yU4nLF7GkspX7y7fvK99rh2BY7M3k3g6XBl15W7uPZhA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7762

Reviewed-by: Gaurav Jain <gaurav.jain@nxp.com

> -----Original Message-----
> From: Meenakshi Aggarwal <meenakshi.aggarwal@nxp.com>
> Sent: Wednesday, June 4, 2025 3:45 PM
> To: Gaurav Jain <gaurav.jain@nxp.com>; herbert@gondor.apana.org.au;
> davem@davemloft.net; linux-crypto@vger.kernel.org; linux-
> kernel@vger.kernel.org
> Cc: Meenakshi Aggarwal <meenakshi.aggarwal@nxp.com>
> Subject: [PATCH] crypto: caam - Set DMA alignment explicitly
>=20
> From: Meenakshi Aggarwal <meenakshi.aggarwal@nxp.com>
>=20
> Few DMA alignment were missed in the original patch.
>=20
> Fixes: 4cb4f7c11dee ("crypto: caam - Set DMA alignment explicitly")
>=20
> Signed-off-by: Meenakshi Aggarwal <meenakshi.aggarwal@nxp.com>
> ---
>  drivers/crypto/caam/caamalg.c    | 22 +++++++++++-----------
>  drivers/crypto/caam/caamalg_qi.c |  4 ++--
>  2 files changed, 13 insertions(+), 13 deletions(-)
>=20
> diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.=
c
> index 2cfb1b8d8c7c..81dfbe436c20 100644
> --- a/drivers/crypto/caam/caamalg.c
> +++ b/drivers/crypto/caam/caamalg.c
> @@ -980,7 +980,7 @@ static void aead_crypt_done(struct device *jrdev, u32
> *desc, u32 err,
>  			    void *context)
>  {
>  	struct aead_request *req =3D context;
> -	struct caam_aead_req_ctx *rctx =3D aead_request_ctx(req);
> +	struct caam_aead_req_ctx *rctx =3D aead_request_ctx_dma(req);
>  	struct caam_drv_private_jr *jrp =3D dev_get_drvdata(jrdev);
>  	struct aead_edesc *edesc;
>  	int ecode =3D 0;
> @@ -1020,7 +1020,7 @@ static void skcipher_crypt_done(struct device *jrde=
v,
> u32 *desc, u32 err,  {
>  	struct skcipher_request *req =3D context;
>  	struct skcipher_edesc *edesc;
> -	struct caam_skcipher_req_ctx *rctx =3D skcipher_request_ctx(req);
> +	struct caam_skcipher_req_ctx *rctx =3D skcipher_request_ctx_dma(req);
>  	struct crypto_skcipher *skcipher =3D crypto_skcipher_reqtfm(req);
>  	struct caam_drv_private_jr *jrp =3D dev_get_drvdata(jrdev);
>  	int ivsize =3D crypto_skcipher_ivsize(skcipher); @@ -1309,7 +1309,7 @@
> static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
>  	struct crypto_aead *aead =3D crypto_aead_reqtfm(req);
>  	struct caam_ctx *ctx =3D crypto_aead_ctx_dma(aead);
>  	struct device *jrdev =3D ctx->jrdev;
> -	struct caam_aead_req_ctx *rctx =3D aead_request_ctx(req);
> +	struct caam_aead_req_ctx *rctx =3D aead_request_ctx_dma(req);
>  	gfp_t flags =3D (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
>  		       GFP_KERNEL : GFP_ATOMIC;
>  	int src_nents, mapped_src_nents, dst_nents =3D 0, mapped_dst_nents =3D =
0;
> @@ -1445,7 +1445,7 @@ static struct aead_edesc *aead_edesc_alloc(struct
> aead_request *req,  static int aead_enqueue_req(struct device *jrdev, str=
uct
> aead_request *req)  {
>  	struct caam_drv_private_jr *jrpriv =3D dev_get_drvdata(jrdev);
> -	struct caam_aead_req_ctx *rctx =3D aead_request_ctx(req);
> +	struct caam_aead_req_ctx *rctx =3D aead_request_ctx_dma(req);
>  	struct aead_edesc *edesc =3D rctx->edesc;
>  	u32 *desc =3D edesc->hw_desc;
>  	int ret;
> @@ -1541,7 +1541,7 @@ static int aead_do_one_req(struct crypto_engine
> *engine, void *areq)  {
>  	struct aead_request *req =3D aead_request_cast(areq);
>  	struct caam_ctx *ctx =3D
> crypto_aead_ctx_dma(crypto_aead_reqtfm(req));
> -	struct caam_aead_req_ctx *rctx =3D aead_request_ctx(req);
> +	struct caam_aead_req_ctx *rctx =3D aead_request_ctx_dma(req);
>  	u32 *desc =3D rctx->edesc->hw_desc;
>  	int ret;
>=20
> @@ -1614,7 +1614,7 @@ static struct skcipher_edesc
> *skcipher_edesc_alloc(struct skcipher_request *req,  {
>  	struct crypto_skcipher *skcipher =3D crypto_skcipher_reqtfm(req);
>  	struct caam_ctx *ctx =3D crypto_skcipher_ctx_dma(skcipher);
> -	struct caam_skcipher_req_ctx *rctx =3D skcipher_request_ctx(req);
> +	struct caam_skcipher_req_ctx *rctx =3D skcipher_request_ctx_dma(req);
>  	struct device *jrdev =3D ctx->jrdev;
>  	gfp_t flags =3D (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
>  		       GFP_KERNEL : GFP_ATOMIC;
> @@ -1778,7 +1778,7 @@ static int skcipher_do_one_req(struct crypto_engine
> *engine, void *areq)  {
>  	struct skcipher_request *req =3D skcipher_request_cast(areq);
>  	struct caam_ctx *ctx =3D
> crypto_skcipher_ctx_dma(crypto_skcipher_reqtfm(req));
> -	struct caam_skcipher_req_ctx *rctx =3D skcipher_request_ctx(req);
> +	struct caam_skcipher_req_ctx *rctx =3D skcipher_request_ctx_dma(req);
>  	u32 *desc =3D rctx->edesc->hw_desc;
>  	int ret;
>=20
> @@ -1828,7 +1828,7 @@ static inline int skcipher_crypt(struct skcipher_re=
quest
> *req, bool encrypt)
>=20
>  	if (ctx->fallback && ((ctrlpriv->era <=3D 8 && xts_skcipher_ivsize(req)=
) ||
>  			      ctx->xts_key_fallback)) {
> -		struct caam_skcipher_req_ctx *rctx =3D
> skcipher_request_ctx(req);
> +		struct caam_skcipher_req_ctx *rctx =3D
> skcipher_request_ctx_dma(req);
>=20
>  		skcipher_request_set_tfm(&rctx->fallback_req, ctx->fallback);
>  		skcipher_request_set_callback(&rctx->fallback_req,
> @@ -3639,10 +3639,10 @@ static int caam_cra_init(struct crypto_skcipher
> *tfm)
>  		}
>=20
>  		ctx->fallback =3D fallback;
> -		crypto_skcipher_set_reqsize(tfm, sizeof(struct
> caam_skcipher_req_ctx) +
> +		crypto_skcipher_set_reqsize_dma(tfm, sizeof(struct
> +caam_skcipher_req_ctx) +
>  					    crypto_skcipher_reqsize(fallback));
>  	} else {
> -		crypto_skcipher_set_reqsize(tfm, sizeof(struct
> caam_skcipher_req_ctx));
> +		crypto_skcipher_set_reqsize_dma(tfm, sizeof(struct
> +caam_skcipher_req_ctx));
>  	}
>=20
>  	ret =3D caam_init_common(ctx, &caam_alg->caam, false); @@ -3659,7
> +3659,7 @@ static int caam_aead_init(struct crypto_aead *tfm)
>  		 container_of(alg, struct caam_aead_alg, aead.base);
>  	struct caam_ctx *ctx =3D crypto_aead_ctx_dma(tfm);
>=20
> -	crypto_aead_set_reqsize(tfm, sizeof(struct caam_aead_req_ctx));
> +	crypto_aead_set_reqsize_dma(tfm, sizeof(struct caam_aead_req_ctx));
>=20
>  	return caam_init_common(ctx, &caam_alg->caam, !caam_alg-
> >caam.nodkp);  } diff --git a/drivers/crypto/caam/caamalg_qi.c
> b/drivers/crypto/caam/caamalg_qi.c
> index 65f6adb6c673..9aa2d6d97f22 100644
> --- a/drivers/crypto/caam/caamalg_qi.c
> +++ b/drivers/crypto/caam/caamalg_qi.c
> @@ -1435,7 +1435,7 @@ static inline int skcipher_crypt(struct skcipher_re=
quest
> *req, bool encrypt)
>=20
>  	if (ctx->fallback && ((ctrlpriv->era <=3D 8 && xts_skcipher_ivsize(req)=
) ||
>  			      ctx->xts_key_fallback)) {
> -		struct caam_skcipher_req_ctx *rctx =3D
> skcipher_request_ctx(req);
> +		struct caam_skcipher_req_ctx *rctx =3D
> skcipher_request_ctx_dma(req);
>=20
>  		skcipher_request_set_tfm(&rctx->fallback_req, ctx->fallback);
>  		skcipher_request_set_callback(&rctx->fallback_req,
> @@ -2524,7 +2524,7 @@ static int caam_cra_init(struct crypto_skcipher *tf=
m)
>  		}
>=20
>  		ctx->fallback =3D fallback;
> -		crypto_skcipher_set_reqsize(tfm, sizeof(struct
> caam_skcipher_req_ctx) +
> +		crypto_skcipher_set_reqsize_dma(tfm, sizeof(struct
> +caam_skcipher_req_ctx) +
>  					    crypto_skcipher_reqsize(fallback));
>  	}
>=20
> --
> 2.25.1

