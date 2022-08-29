Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A113BC0502F
	for <linux-crypto@archiver.kernel.org>; Mon, 29 Aug 2022 02:09:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbiH2CJQ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 28 Aug 2022 22:09:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiH2CJO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 28 Aug 2022 22:09:14 -0400
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (mail-tyzapc01on2106.outbound.protection.outlook.com [40.107.117.106])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 228D42F007
        for <linux-crypto@vger.kernel.org>; Sun, 28 Aug 2022 19:09:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LWF6OguZJc8QJnMv6QHOR0hQsEtYlEB2kIiRGwJP4ON4yF2V68J3Y9rb///bLhNFI3Hf34wIutHCZYkpPPtC3UaTjceO37Pt5ve4JIo/tT85Qn7o5i5+LwZPY28sk1XxaQbMWiNEp+g7YbEXJ/M0EApOwumziD1TRc3kPTXcKeAOlxjyah/yBDCToT9b72Z2INuLxpDPALt8GmXdzPFYXgb5rhsBRH90IAO5/S7MjzH+MOWRpWlU65WiompvIwZbIfOC1OQXkhne1iQ/6EAtjA+f+K6JssIu6ZEUIE9JQyujf1BH3YHLLEc94puTcw+II0yLOck9CzJs55gxKkowlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IzG5ZyX7cpWShwiA7LubFd1eBfxKhXO5XXpZ3/FFC70=;
 b=nZUVeNImHYtCUqk6Ph5NmMGnrk0bS3cvbOSgpQvdzvnf/AooVKz+Fd+gf8Mr3iRY09D2o2m2cwZ7FlRQVAX/ADK5ixsXbxj8XbtalTzXDtFN7tHhK4NVtfrooWEnT+zjCEqWTOn1F7ppn6UdY1xJljIfyLwNn6HbrRNcXU0BjjmdqRzI9ky2EF8xqIfTqfnXzQMY556OnQ0QHK/jeVEV6OCuX9MjzjN02dHyKAm2Htif1X/6A05I95kQPC4MJwaVTKzNEFDme/u52iL4ZSr5HbggIG6wa5B9xJzcISKZ2OX6jInAEI2Cmoo2j5LHmlztVLo0D0JLRxrSN9uX1QK2Hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=aspeedtech.com; dmarc=pass action=none
 header.from=aspeedtech.com; dkim=pass header.d=aspeedtech.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aspeedtech.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IzG5ZyX7cpWShwiA7LubFd1eBfxKhXO5XXpZ3/FFC70=;
 b=FYy5VQygFSfs4IGz+Pw39BlSOCgv/se1NBY/XfRZzmROT780AQC32hazvbQR638V8yQVmowCB/3lXpcWHmIjH31X+kt7rLAm9i3GCUiOzmqioWEZs8GK5a+y2PNG1wn2ixu/U07zpuT0fxQt+OEp3mAZqqj7QEZEocymGh+XIH4OlUv6GRngJmuwD84IvN38DxLyugfMYuWC/mDUEE1GTZ76RqjbdfsGfe4PGsu4Tjy6qp9/B4t3JkSlNyHOGqJQ90DXTEg1Df8JKLeORCnqMRyy7gEvcQC44MXNoFfjbw/dbBl8UIEWHwlkSCD1GKIqx8ht4EtUU+w2dSlkQ8vGjg==
Received: from TY2PR06MB3213.apcprd06.prod.outlook.com (2603:1096:404:97::16)
 by PU1PR06MB2376.apcprd06.prod.outlook.com (2603:1096:803:3a::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.19; Mon, 29 Aug
 2022 02:09:06 +0000
Received: from TY2PR06MB3213.apcprd06.prod.outlook.com
 ([fe80::8dbe:4d03:e911:5a4]) by TY2PR06MB3213.apcprd06.prod.outlook.com
 ([fe80::8dbe:4d03:e911:5a4%5]) with mapi id 15.20.5566.015; Mon, 29 Aug 2022
 02:09:05 +0000
From:   Neal Liu <neal_liu@aspeedtech.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: RE: [PATCH] crypto: aspeed - Enable compile testing
Thread-Topic: [PATCH] crypto: aspeed - Enable compile testing
Thread-Index: AQHYuTvIINMY8ZD8XkeyoeOFd1bYXK3FJgig
Date:   Mon, 29 Aug 2022 02:09:05 +0000
Message-ID: <TY2PR06MB321331654C0016FBF85E337B80769@TY2PR06MB3213.apcprd06.prod.outlook.com>
References: <Ywio+53/JNNpoNhU@gondor.apana.org.au>
In-Reply-To: <Ywio+53/JNNpoNhU@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=aspeedtech.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 24837c46-db79-415b-60a8-08da8963734e
x-ms-traffictypediagnostic: PU1PR06MB2376:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pvITKShw1JJEQYanwSHEUJt5qw/vQdpmZLPFFciIoo8TMXjxzG97CkaOWMIciEDVavubnIUeQWTwInNoWNubgemFnXDx4Zpcq2Nhz/FeVBTB5V9sXW2LBM6bIZuP17O9ab1Wk9sc7RvcLmUpMVcCwxJU1D1pYKxTJMC6Fw0zybazqvfKzfQpGNpPpQYtnT2SInPz5u16tXtPEHzp6yyPh1MgpdFeADd4oChWw05wLHDazUARFQvah9ssUkn+UI6IezBC5MQcXb/pxcc0VzXPTG+gzmZV8f+ToI+qXqKhm91y3Uxu+hJTfXLuWy9oqk2alRtmXJlsH8vVRvDu6rtVxLq/LNjVj2OXYLUMvFLRdX3I3kOKQ+WhAimMlRcbh9JrB2U2XEIEf7Q0VRw9virLTvEk7WGzVAXqXhwxTiGvzfzpFRGoUTiSasOfMILhEk39eLrhU+d9YifpJBRCx50kevcySr8a0/gO8bDMKk+TslemVbDxVGVjZhrUPRHkDLvGZ7JMP9+wN8rdV5XFAsYRdJ3+6P59Ot4nBXwqH/nzCyPW1x4b8XzMvCOdys4uqiYJlFSOFB7IAeLOak3JBP0AtK3Hg7d+1kvxlLMDVOhAiuq0FBnjIPRgdyvAOAFDIQEfHHiSIYuYV3MVIZlfV2c8NdFcd7RSXlilXj3zcO4Gq7AnzEcW9gIBZnQ38VyuF9Bw+0BVtPFiOotpgyxFPDtMWfYBWn3HTKRzALuVBPYA5gz5n6ePNkxTEYFaqnSOb/u7E/3aGtIV94iw4MBSZzZt0Eq7mgbK5HSjroxWpPRbQY8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY2PR06MB3213.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(366004)(396003)(39830400003)(376002)(136003)(53546011)(6506007)(9686003)(7696005)(86362001)(38070700005)(26005)(33656002)(122000001)(186003)(71200400001)(478600001)(41300700001)(966005)(83380400001)(52536014)(55016003)(8676002)(66946007)(66476007)(64756008)(66446008)(316002)(110136005)(76116006)(66556008)(5660300002)(8936002)(4744005)(38100700002)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?364B0kESRwLAziT9QFpxVWuvdJ4eSBZtH/yGAwicFahwQUkK1Ebz8t6njfu7?=
 =?us-ascii?Q?5JbUyglAIa6VPt7WTlG/cPRpY8rYz71gNBieSyvlj28i67EuqkGf9qUdBgou?=
 =?us-ascii?Q?9WlM9oAxHv4k4DreTsAnTCfNJhG9Q2tffyfuliFDrl3+I0j6xuSvxX5Ln9uE?=
 =?us-ascii?Q?TskiqLkoLnTCxWPCEeoOIszEs49H9LklYh31bBxmNO1R7bqh/FYxU3+bBkvN?=
 =?us-ascii?Q?xIPN2BYOeWTvtA0mvg1g/p12n3J0QMe3y2qV/s87xLWi6m7VVNt8Sj/gKbP5?=
 =?us-ascii?Q?oTd6g0ZhG0RkG8ywtPizdCoJmlPFxvQajzeRPEu9wXmjAklQC0W+l2OHbnpq?=
 =?us-ascii?Q?1CqcZaIv37+K5MRx+q0hkooG1iBrBjwJjsDm2iDfBB0/Os8MKIMgS72/97oS?=
 =?us-ascii?Q?2t7NmiskdSIgXx3TYjjJwjJSRk0WB/CvaxddWbTXf0aXNB9jjb+2rnGdhaRL?=
 =?us-ascii?Q?smU/4k4qmSgGdwm/v1ihXPdkBzZ7rbEnJfLY4AletYRrwkXP/G9EYEpAqZWX?=
 =?us-ascii?Q?57j1u4/q/7e/vV78KnjDf/5Far7LTrihMQo+VMONfMbKpHRYnvGs2weKx4p4?=
 =?us-ascii?Q?/1Y/MBqR//zeqYLtthMzXMsL13DaGc/PFuUDMPnJETegInSja89SdozC4D8x?=
 =?us-ascii?Q?t0lwPDOnsXvYqQm8ppQ9HSRwd3zqfXFjA5obkYsAsyVOPx7PrsesRFy/3r8y?=
 =?us-ascii?Q?PXHa6erACIosFKInEasJpAej26TEBy2hob3clFjuMuXb7XHF41lcRvBfpRI3?=
 =?us-ascii?Q?6kcMLNwCvGvF2u5iaSZgxipk8GOvx91s8Sr2UCkxtVBAtZHme63CU/OZLxIV?=
 =?us-ascii?Q?x+ZbeNnxx08ThP/VBtDiRpZ/6zeJOAQZPARUCeHM36Q1vnewNF10UriCJu8V?=
 =?us-ascii?Q?LILgjXTCVwz4Rbr2QPUvFeQi2NqTaB+iR3rx+BztGD6z+M48rRnJpyah04P/?=
 =?us-ascii?Q?3zCboeEHDjJGPW9riiKv7T7Ew+Nn6FuWkbbc/zjPJRz5U+s6RPZGoK7x/GIK?=
 =?us-ascii?Q?DaB2slJmGzpZ938C6luuTpMEcjj4mAFP1yRE14h5VvUwDzi+HspISshgubsb?=
 =?us-ascii?Q?rVfg14jwOIcHFFN+3yvJmE7qfmddYGhQx7htJBmglsP8pnQgM0RZ3zjc7vWx?=
 =?us-ascii?Q?3r/VHAFBMG37RDkWFduAZHoRIoCJfpBQB2sumEH7CCDKo93K5e1rnWR5SNm4?=
 =?us-ascii?Q?J8yfWk3lSdzkcFMxFn/X6UO0fH08G3nCB6+rpW1nn0wUOzP+oJyLfgQAe4r5?=
 =?us-ascii?Q?hj5htzWFb4fqQavB5YnlBLwrhS/nDeOmmBidHRCIwqFd47Su3msjXawjMEqs?=
 =?us-ascii?Q?9PLXe2Zl4yzXAEneTCM2ycll/J2ZK3xMiHkoBCMVG6lbxSgLlRBJIuiDgf86?=
 =?us-ascii?Q?iTaaeQQCqusQ4LY3zCSCIdir+pnouQnrar5iHa+SkgKUU2wZyNwv6GHiSrrq?=
 =?us-ascii?Q?/qekY78Q0gdb0UtYGfWfImhwXNqeelsMkPGAfGxx53XdqykQZS2/ZtLfcSWd?=
 =?us-ascii?Q?VFBkAnOTmtG984MrAsSUiQw8/v6Wn86OHJ8b2HChy2UmZDW5Ep/etNEMKhqk?=
 =?us-ascii?Q?E2LfKGSgBz8zeFvqrJpABtFTA8kZ4QT4CC5xou7J?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: aspeedtech.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY2PR06MB3213.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24837c46-db79-415b-60a8-08da8963734e
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Aug 2022 02:09:05.5161
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43d4aa98-e35b-4575-8939-080e90d5a249
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: m3IsiNv+nw3xd9ctuhNaW1+7u8BhGVvfB2zYuAiUcl2PkbwPEngzYy4rGZzrhGBfClEu9UKqEEFKlQ0rF8DTNg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PU1PR06MB2376
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> -----Original Message-----
> From: Herbert Xu <herbert@gondor.apana.org.au>
> Sent: Friday, August 26, 2022 7:06 PM
> To: Neal Liu <neal_liu@aspeedtech.com>; Linux Crypto Mailing List
> <linux-crypto@vger.kernel.org>
> Subject: [PATCH] crypto: aspeed - Enable compile testing
>=20
> This driver compile tests just fine.
>=20
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Reviewed-by: Neal Liu <neal_liu@aspeedtech.com>

>=20
> diff --git a/drivers/crypto/aspeed/Kconfig b/drivers/crypto/aspeed/Kconfi=
g
> index 001bf2e09a72..ae3eb0eb57f6 100644
> --- a/drivers/crypto/aspeed/Kconfig
> +++ b/drivers/crypto/aspeed/Kconfig
> @@ -1,6 +1,6 @@
>  config CRYPTO_DEV_ASPEED
>  	tristate "Support for Aspeed cryptographic engine driver"
> -	depends on ARCH_ASPEED
> +	depends on ARCH_ASPEED || COMPILE_TEST
>  	help
>  	  Hash and Crypto Engine (HACE) is designed to accelerate the
>  	  throughput of hash data digest, encryption and decryption.
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au> Home Page:
> http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
