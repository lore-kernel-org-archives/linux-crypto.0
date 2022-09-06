Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A2F7ECAAA1
	for <linux-crypto@archiver.kernel.org>; Tue,  6 Sep 2022 09:18:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238274AbiIFJSG (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 6 Sep 2022 05:18:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239622AbiIFJRe (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 6 Sep 2022 05:17:34 -0400
Received: from APC01-PSA-obe.outbound.protection.outlook.com (mail-psaapc01on2094.outbound.protection.outlook.com [40.107.255.94])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70E5D1B7A5
        for <linux-crypto@vger.kernel.org>; Tue,  6 Sep 2022 02:16:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kURbGULg9cxzTVLcUW+lzTyXV0UpkckydhZiRud/yBufpaxT17GnDP0hfNTXePafegWF+lFi3Zog5R1GZjnUzsjl4Yln4GlpoJEQMTv/nrR9axcbF6TzCq+Q1Gc7I95kPAeqDBf9fEEtnc/K65S0q1X6c/aF4ob5uMX8qoGH9Kv+L0YTlc8oeIXdmdi/jZ6WmYy/ihKi5I+xfohd1WiaPposhXiy4eQ/vAoW87ax+/3iMeZ/wxhp1vx+Fxlvfzp4YZ0ussuvpAnQ3maBS0seIUZPrAkq2cc6UPBN3nNU3MbJLj2QjNdTzFAV4PTNa6IkDVhma0WUbziH1N+lxe+JdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UB/RQQfuGF1TmDPZSHfqmAmQcawLxnyF0pM9+/vj4vY=;
 b=OQhNScodL+UXJ1j7ym2OO5jwVuWxXrAqYKas8YQE/VaUNbR0QnmXjtfVp6K8D8/igpNiADTmuSgLYggBEluMabfRlPumrRb08NkPlmHAJuKwWjwzdeDIj5+18kBhj6TgIl61+bMSERKgTOSeu72xltldtrNr1y4ILuEJSwsfMXt6h7Elup1k+fwO5+wikFaWatnp3GoQOOk2tlOneI7FeVkFF3rwhvdS6Xu/Es6LaJEInWJjg1o/mBMsSq3NuVRm9SgSkPl2rlHaK02xajMwOSbXaCLjEJXbOMraEuHpSGkj6XOrLQtjsIDj0EWr+LLESv7dur2T3DCWO0v+GxmEww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=aspeedtech.com; dmarc=pass action=none
 header.from=aspeedtech.com; dkim=pass header.d=aspeedtech.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aspeedtech.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UB/RQQfuGF1TmDPZSHfqmAmQcawLxnyF0pM9+/vj4vY=;
 b=T3JHuLVJOXvoHZnKbteQ986avFppODeNm/b+62wGWYqoWNrkiXHq4RYUzQ77cwBX0Ip4fAW4sqTPY+rKBfpgL7KAXtt03AZ2XZFKFetO2i/3a7O9CiO5e68jNvhr3Hx8fAQpaIlOIFeNBVpvNChvUXx9Nr0QaYv2OdmzqgobSotQtdk5F8F17Om/msD7Z2gUZxzQ8qIerCoaNq1gtKTjbTdn/rAsa4pJBdJ2GUkABuhVpdPvDjHgd+Qe4jYULU+y55wBSvHq8rkpsoTOajAd1ZPslhbPyo4wKSnbWJT331BQtCYJW1n4FMXo0h3qinyJdzLKjPYJn6cSP0Azl2nSuQ==
Received: from HK0PR06MB3202.apcprd06.prod.outlook.com (2603:1096:203:87::17)
 by SI2PR06MB3946.apcprd06.prod.outlook.com (2603:1096:4:ea::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.11; Tue, 6 Sep
 2022 09:16:41 +0000
Received: from HK0PR06MB3202.apcprd06.prod.outlook.com
 ([fe80::7c44:6fe1:af1:7b42]) by HK0PR06MB3202.apcprd06.prod.outlook.com
 ([fe80::7c44:6fe1:af1:7b42%5]) with mapi id 15.20.5588.016; Tue, 6 Sep 2022
 09:16:40 +0000
From:   Neal Liu <neal_liu@aspeedtech.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: RE: [PATCH] crypto: aspeed - Fix sparse warnings
Thread-Topic: [PATCH] crypto: aspeed - Fix sparse warnings
Thread-Index: AQHYwa5R0oADyVsSxUi0eWok0/J/Ca3SHx4A
Date:   Tue, 6 Sep 2022 09:16:40 +0000
Message-ID: <HK0PR06MB3202CEC6FB202BD2D0D76388807E9@HK0PR06MB3202.apcprd06.prod.outlook.com>
References: <YxbVH33BOJk2T+rT@gondor.apana.org.au>
In-Reply-To: <YxbVH33BOJk2T+rT@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=aspeedtech.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 94107fb2-c1c6-4128-1c8d-08da8fe88226
x-ms-traffictypediagnostic: SI2PR06MB3946:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: z/SHGxZNIKWzedsjnhyGRdK/gy/WdaQKS6azstF+TDjHh4M3+jYwjGMBhJ8Ax4o2FL8XezDOIXokedGhGxHDshHkiX2LXOjXyo0IxEwT7jadRX+ImdbtdV1KF5g0AFnOeC/gGetA0FODa8aJNqEJUmIB41PIJnY81TTHCxLKeDTO0yyHUBXvRkOkFOsRVjGps86id4Q6kcuZ4U1SY4+ojCNvTflCr8GDydLQsnDJ1oIfCRg6WLP78fE6adPi7yAhSjDZmI2GsmYlobNZ6MtEidSKmhABoMb3dYcO9XNukzEEQr/LtXEqN2G++T4t3J1XBylGDVCTCEi79tlnfO5115dM38+wTusRD4gKY17qrjdH61ylIvicBtBrK/r8rspWVtly2gKIBLYoZT+4Srkj2DGC3wFHeqeuvHt/UcArTj6MNDMGjPma7wV5+JEfWL+fZxUMjenhL2ikMkWOGK4TEI94bo4cbT/jZerJHUdkub2q5V1ousV3MvkisUCLGd0xIBeTE+j6qxeZhe3NtilUxVmpjqqg9j5h4wu56QyJKFRlF8XRoV3UXv42xN7OSFnma5Kkj6K/bqOvkpnhsF4/Q2a3LSrmzme7iZO/f9ZJiVBz3zbGcUcyKa+xwKsiQgQ1n6wTMO5ntIE2orZ6Sr5uvdrdB2oP5dCwfojIc/6uYZ3VP8ZmvxxFFnQ1iU/Xo7qDPxHiz+wQJ0bsv5dEf8c8Zk1FiKbNYQRutJvzrh3gRIkH+jPdDhFV59pJ8w87xkGbWAdfpsPiZeKNghM0dHQ4dciJ5II7xPNdt4MtIeMycT0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HK0PR06MB3202.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(346002)(366004)(39850400004)(376002)(136003)(966005)(33656002)(66556008)(83380400001)(66446008)(76116006)(478600001)(66476007)(4326008)(8676002)(86362001)(64756008)(66946007)(41300700001)(26005)(38070700005)(53546011)(6506007)(9686003)(7696005)(52536014)(8936002)(186003)(5660300002)(316002)(2906002)(71200400001)(38100700002)(6916009)(55016003)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?XUChTjzB27wyEHBlxGmA/yPyPfPxh1TD57ZO+c39d3o1C67ehjtoDzM5zY9T?=
 =?us-ascii?Q?fokO2LWuDVoBc8tTtRBrr2S4k7Abn4iJlI7UdLWL48feGblYtC11NtYmJPVa?=
 =?us-ascii?Q?Fe/7tKAE99KAxpDRUWih34HcP9sjpCgTf9BNNOCYFL299AJRJaCeFxCuv5wF?=
 =?us-ascii?Q?MzMqZmQ1/jp+2v0e+AG4RL73QTxNeT2QcIyCC4PXQjV/AUkObdodkq2dPXqu?=
 =?us-ascii?Q?JxfBkzsh+21dl6ynjZJU7G2wIa44mUekbgN20/2G43xBtIQt5ScBvKm7hfN4?=
 =?us-ascii?Q?2LYkhkxWxdpgYidTa2nYcRpjB2xu8441kXFCu03zstkXchFaP0nHh9M/C6pn?=
 =?us-ascii?Q?HMyN6C+I2Ust9XZopYv2Ce5PFvTYZP5TGvv+eLTtKdPfNx7i5MvACkN0+W4N?=
 =?us-ascii?Q?2fB6pFXb0zNbehKw/BeGM9UxkU60etvSZz4phaIC20nVvfkBCKOtEpGf/+z1?=
 =?us-ascii?Q?oOXql0+2PQko9pdDLkKWLg3z/Y4TFLWSzHOh741M/UHfnblX5vqMLI6HYj6L?=
 =?us-ascii?Q?zCYXtG1oPrF97GmOZXibChqP+LqR4pzKeHMfZouLhFpVerlRu5RCpNz2hoNe?=
 =?us-ascii?Q?XlwOg2kPOUjDr0ud4rSLAKBZ5tyqOOxCQst6UKBzL8rZG245vLaViPBse1jO?=
 =?us-ascii?Q?yxM6EBAwMwbrIl7T0zUVjgFs9JzWF6SXmC+Jc48x7ZGK/CzVrkTZgk2O3DJt?=
 =?us-ascii?Q?ZlpqNbjOWpKmVzlXxZR297qj+IJA+QqRyEwbZIm53ZL4umAwMDe6fFrfZ3KJ?=
 =?us-ascii?Q?FjTuQx2bqlmQ3DZ2mC5j+M8l4r+DtaXxVzQue+yPExm84bBvbYKBsi2EYP3c?=
 =?us-ascii?Q?EhAMUitvetwDKM5QMZ5DZgZf0qFvVXm3rmSVK64otcQJcyWYKT904YHwqUdY?=
 =?us-ascii?Q?mPA9jHSmB4fshoJE0NOMu+neUaDuGFchZgvSQP0Ln7I4AnCXQJAKpCUCHYcv?=
 =?us-ascii?Q?p7tr+bPd4XTwYcvwd1wLGdAJXvddTBHy65R1ZqP5FnC+QlklrASo/GCqz20e?=
 =?us-ascii?Q?RodXb0/+V2qNnFkbzctNbTFEe4fdkfAelTsC0jaYhfB6BK1Q3BsZ45i/P6xY?=
 =?us-ascii?Q?L2dQSa9Z3ZtlYaTej+mBamq4jsgVpZHdLx41rNy+GjtMTurB5YXv6+z30o7O?=
 =?us-ascii?Q?L1QkV0nZQaNQ0PmA+Z85nBcKMZC8aap3dQo9zokSOdSxwfTnojgkFSyVEdb5?=
 =?us-ascii?Q?4AzCmG/9mCBUHmm2C+DOWhD+mUR1hoRF3mFzEI50NyNb90Tn/J8+UEoHRNXY?=
 =?us-ascii?Q?BrMCzE9Ys8mcdBfCT1GxRbmIWQOEHojKa6g60W6YjsCMiXty4hlCzhPe6Dpw?=
 =?us-ascii?Q?tlDGuxmiTJS+OgwsoVSFgJ/WHLm2elF6HpX/QFxYqyyyVpcH19aCUCOqbhcX?=
 =?us-ascii?Q?kwW9QH3WCgvytt/hQJy3T2QD5T+WdmxaOAZdceP/aj5a20qMROzGJlPtJJ5y?=
 =?us-ascii?Q?DPbMlAlln4m/Of5TRMStJ3Wlf44fNYrriAG1A/W+HXi4WJriJkzMbRNcXn2U?=
 =?us-ascii?Q?hVEelhpWLhdtf19vaqfXIm2jowhz4xdfnTIjvETBrTFOuV+M4C+8+trOoYOw?=
 =?us-ascii?Q?ek7O7ury17PggGSRBxJk5kgdxj+JdZDcZDOOE8Nx?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: aspeedtech.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: HK0PR06MB3202.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94107fb2-c1c6-4128-1c8d-08da8fe88226
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Sep 2022 09:16:40.4754
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43d4aa98-e35b-4575-8939-080e90d5a249
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hglMQW2XpPpfAvbPdXVyXBhovufRWIh6OpDBVgZCwQJ+sRP9Vx8dEzbPRIPnHY0yj0oWwlzQQWznvWANAgG+zg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SI2PR06MB3946
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> -----Original Message-----
> From: Herbert Xu <herbert@gondor.apana.org.au>
> Sent: Tuesday, September 6, 2022 1:06 PM
> To: Neal Liu <neal_liu@aspeedtech.com>
> Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
> Subject: [PATCH] crypto: aspeed - Fix sparse warnings
>=20
> This patch fixes a bunch of bit endianness warnings and two missing stati=
c
> modifiers.
>=20
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

LGTM, thanks.

Reviewed-by: Neal Liu <neal_liu@aspeedtech.com>

> diff --git a/drivers/crypto/aspeed/aspeed-hace-crypto.c
> b/drivers/crypto/aspeed/aspeed-hace-crypto.c
> index ba6158f5cf18..ef73b0028b4d 100644
> --- a/drivers/crypto/aspeed/aspeed-hace-crypto.c
> +++ b/drivers/crypto/aspeed/aspeed-hace-crypto.c
> @@ -258,21 +258,20 @@ static int aspeed_sk_start_sg(struct
> aspeed_hace_dev *hace_dev)
>  	total =3D req->cryptlen;
>=20
>  	for_each_sg(req->src, s, src_sg_len, i) {
> -		src_list[i].phy_addr =3D sg_dma_address(s);
> +		u32 phy_addr =3D sg_dma_address(s);
> +		u32 len =3D sg_dma_len(s);
>=20
> -		if (total > sg_dma_len(s)) {
> -			src_list[i].len =3D sg_dma_len(s);
> -			total -=3D src_list[i].len;
> -
> -		} else {
> +		if (total > len)
> +			total -=3D len;
> +		else {
>  			/* last sg list */
> -			src_list[i].len =3D total;
> -			src_list[i].len |=3D BIT(31);
> +			len =3D total;
> +			len |=3D BIT(31);
>  			total =3D 0;
>  		}
>=20
> -		src_list[i].phy_addr =3D cpu_to_le32(src_list[i].phy_addr);
> -		src_list[i].len =3D cpu_to_le32(src_list[i].len);
> +		src_list[i].phy_addr =3D cpu_to_le32(phy_addr);
> +		src_list[i].len =3D cpu_to_le32(len);
>  	}
>=20
>  	if (total !=3D 0) {
> @@ -290,21 +289,20 @@ static int aspeed_sk_start_sg(struct
> aspeed_hace_dev *hace_dev)
>  		total =3D req->cryptlen;
>=20
>  		for_each_sg(req->dst, s, dst_sg_len, i) {
> -			dst_list[i].phy_addr =3D sg_dma_address(s);
> -
> -			if (total > sg_dma_len(s)) {
> -				dst_list[i].len =3D sg_dma_len(s);
> -				total -=3D dst_list[i].len;
> +			u32 phy_addr =3D sg_dma_address(s);
> +			u32 len =3D sg_dma_len(s);
>=20
> -			} else {
> +			if (total > len)
> +				total -=3D len;
> +			else {
>  				/* last sg list */
> -				dst_list[i].len =3D total;
> -				dst_list[i].len |=3D BIT(31);
> +				len =3D total;
> +				len |=3D BIT(31);
>  				total =3D 0;
>  			}
>=20
> -			dst_list[i].phy_addr =3D cpu_to_le32(dst_list[i].phy_addr);
> -			dst_list[i].len =3D cpu_to_le32(dst_list[i].len);
> +			dst_list[i].phy_addr =3D cpu_to_le32(phy_addr);
> +			dst_list[i].len =3D cpu_to_le32(len);
>=20
>  		}
>=20
> @@ -731,7 +729,7 @@ static void aspeed_crypto_cra_exit(struct
> crypto_skcipher *tfm)
>  	crypto_free_skcipher(ctx->fallback_tfm);
>  }
>=20
> -struct aspeed_hace_alg aspeed_crypto_algs[] =3D {
> +static struct aspeed_hace_alg aspeed_crypto_algs[] =3D {
>  	{
>  		.alg.skcipher =3D {
>  			.min_keysize	=3D AES_MIN_KEY_SIZE,
> @@ -1019,7 +1017,7 @@ struct aspeed_hace_alg aspeed_crypto_algs[] =3D {
>  	},
>  };
>=20
> -struct aspeed_hace_alg aspeed_crypto_algs_g6[] =3D {
> +static struct aspeed_hace_alg aspeed_crypto_algs_g6[] =3D {
>  	{
>  		.alg.skcipher =3D {
>  			.ivsize		=3D AES_BLOCK_SIZE,
> diff --git a/drivers/crypto/aspeed/aspeed-hace-hash.c
> b/drivers/crypto/aspeed/aspeed-hace-hash.c
> index 0a44ffc0e13b..7f7f289fceb7 100644
> --- a/drivers/crypto/aspeed/aspeed-hace-hash.c
> +++ b/drivers/crypto/aspeed/aspeed-hace-hash.c
> @@ -208,6 +208,9 @@ static int aspeed_ahash_dma_prepare_sg(struct
> aspeed_hace_dev *hace_dev)
>  	}
>=20
>  	if (rctx->bufcnt !=3D 0) {
> +		u32 phy_addr;
> +		u32 len;
> +
>  		rctx->buffer_dma_addr =3D dma_map_single(hace_dev->dev,
>  						       rctx->buffer,
>  						       rctx->block_size * 2,
> @@ -218,36 +221,35 @@ static int aspeed_ahash_dma_prepare_sg(struct
> aspeed_hace_dev *hace_dev)
>  			goto free_rctx_digest;
>  		}
>=20
> -		src_list[0].phy_addr =3D rctx->buffer_dma_addr;
> -		src_list[0].len =3D rctx->bufcnt;
> -		length -=3D src_list[0].len;
> +		phy_addr =3D rctx->buffer_dma_addr;
> +		len =3D rctx->bufcnt;
> +		length -=3D len;
>=20
>  		/* Last sg list */
>  		if (length =3D=3D 0)
> -			src_list[0].len |=3D HASH_SG_LAST_LIST;
> +			len |=3D HASH_SG_LAST_LIST;
>=20
> -		src_list[0].phy_addr =3D cpu_to_le32(src_list[0].phy_addr);
> -		src_list[0].len =3D cpu_to_le32(src_list[0].len);
> +		src_list[0].phy_addr =3D cpu_to_le32(phy_addr);
> +		src_list[0].len =3D cpu_to_le32(len);
>  		src_list++;
>  	}
>=20
>  	if (length !=3D 0) {
>  		for_each_sg(rctx->src_sg, s, sg_len, i) {
> -			src_list[i].phy_addr =3D sg_dma_address(s);
> -
> -			if (length > sg_dma_len(s)) {
> -				src_list[i].len =3D sg_dma_len(s);
> -				length -=3D sg_dma_len(s);
> +			u32 phy_addr =3D sg_dma_address(s);
> +			u32 len =3D sg_dma_len(s);
>=20
> -			} else {
> +			if (length > len)
> +				length -=3D len;
> +			else {
>  				/* Last sg list */
> -				src_list[i].len =3D length;
> -				src_list[i].len |=3D HASH_SG_LAST_LIST;
> +				len =3D length;
> +				len |=3D HASH_SG_LAST_LIST;
>  				length =3D 0;
>  			}
>=20
> -			src_list[i].phy_addr =3D cpu_to_le32(src_list[i].phy_addr);
> -			src_list[i].len =3D cpu_to_le32(src_list[i].len);
> +			src_list[i].phy_addr =3D cpu_to_le32(phy_addr);
> +			src_list[i].len =3D cpu_to_le32(len);
>  		}
>  	}
>=20
> @@ -913,7 +915,7 @@ static int aspeed_sham_import(struct ahash_request
> *req, const void *in)
>  	return 0;
>  }
>=20
> -struct aspeed_hace_alg aspeed_ahash_algs[] =3D {
> +static struct aspeed_hace_alg aspeed_ahash_algs[] =3D {
>  	{
>  		.alg.ahash =3D {
>  			.init	=3D aspeed_sham_init,
> @@ -1099,7 +1101,7 @@ struct aspeed_hace_alg aspeed_ahash_algs[] =3D {
>  	},
>  };
>=20
> -struct aspeed_hace_alg aspeed_ahash_algs_g6[] =3D {
> +static struct aspeed_hace_alg aspeed_ahash_algs_g6[] =3D {
>  	{
>  		.alg.ahash =3D {
>  			.init	=3D aspeed_sham_init,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au> Home Page:
> http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
