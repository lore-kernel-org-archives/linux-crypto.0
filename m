Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2B34C05027
	for <linux-crypto@archiver.kernel.org>; Mon, 13 Feb 2023 01:48:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229476AbjBMBst (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 12 Feb 2023 20:48:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjBMBss (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 12 Feb 2023 20:48:48 -0500
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (mail-tyzapc01on2093.outbound.protection.outlook.com [40.107.117.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F98FEB7E
        for <linux-crypto@vger.kernel.org>; Sun, 12 Feb 2023 17:48:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Po7Sbw+qNLwZI4iANLBmVM+Bj56WfFXbGH9OadVAU0zuJcCRUoLVMHjgn5+ir5b2WzRwz3v6JHN8uxN2MU/s/CRBMUV+vPp4wTklo1RtCYzqWZLY8955R1Abs+Tm4x8Wg7QjZbfaY1aOvT50DB6ax0NkOO8ScSCZPSC6STfPHDILPwLH4uDM2E9vbNvHMJAYC+J/s5DsPahO/USn2BrhoP3V/zqJm79iwVuVZhtycPzqXH0BIK7DNODlAdpqVmsJaj3GLMns9pgKLJqcvs/g2A1HfC6OyrExsopAXYdJlWKHv3+mzJM1N2HIizSTUS3XyYoL64q6T5sgQv0VHdmykA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UxLoBiPLmR1+Px60LxYQ3Epo7GDFNSOyzlfsj8qIkJ4=;
 b=KTHp0TEBeODp56h4/HRiAuRPjsmY6bbYsbGMehAwOrA9nZIr88c+N8GN4/grQlEYiCwXQ1X3mlirUxuHA07uv7fwAzkdrNJMsOCiQsmllrACrsw1pRztuD29NJ0NRuMruhKEWRtSufQCNKWVM10LepDJScQfNtzQB3jKGxTdSc7hESTwvB5EDK7qmzY6hJaq3aWGbqvZ3gP+lwFx8qCG+TV0iCsGasZyXf87TtKrm7u6t9kOVisnsZ+oMjx8FOQS8WeSMalIKUpaEwrcpL513u1YzLSSpVJPzO6GAgrPEl5nn3C3JDOxB7xDDkREd+oTqA1Wv60qAQUlqISza/mUAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=aspeedtech.com; dmarc=pass action=none
 header.from=aspeedtech.com; dkim=pass header.d=aspeedtech.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aspeedtech.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UxLoBiPLmR1+Px60LxYQ3Epo7GDFNSOyzlfsj8qIkJ4=;
 b=C1x1Dnj5Mu8z5OfEIzq3QwqV+PML6bkHRWTrz+doO5/rHCC8fZLw9Mim4aU1LL2Txbe1dd87Cn5HOjNk5JKNcAouCc/9E/enVXEf4RlxlIb/tu5nwIoCHT4tAduSlLsu7m+YO5btD3vDPJsUYRn0teXkq3KzzevznfjM6NTK1danvleGw+7UX7XrQmE75p2YBB16Fjoqlr/77bavtVI+Z17AR4Gn/EMwz7AiFo06wn8Etf5f76QFQvbw1S9rKcCkvRlv0hoJ6b8StklRszpu3sJS6aA1GF+00CGJj+isEU2NWA9ZxNhO3Kwc1w8r6JAzmwUmx6GIW+owLgyKOzbo2g==
Received: from TY2PR06MB3213.apcprd06.prod.outlook.com (2603:1096:404:97::16)
 by TYZPR06MB3997.apcprd06.prod.outlook.com (2603:1096:400:25::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.9; Mon, 13 Feb
 2023 01:48:40 +0000
Received: from TY2PR06MB3213.apcprd06.prod.outlook.com
 ([fe80::b113:70f9:7dc9:543f]) by TY2PR06MB3213.apcprd06.prod.outlook.com
 ([fe80::b113:70f9:7dc9:543f%7]) with mapi id 15.20.6086.017; Mon, 13 Feb 2023
 01:48:40 +0000
From:   Neal Liu <neal_liu@aspeedtech.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Joel Stanley <joel@jms.id.au>,
        Andrew Jeffery <andrew@aj.id.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "linux-aspeed@lists.ozlabs.org" <linux-aspeed@lists.ozlabs.org>
Subject: RE: [PATCH] crypto: aspeed - Fix modular aspeed-acry
Thread-Topic: [PATCH] crypto: aspeed - Fix modular aspeed-acry
Thread-Index: AQHZPTPOz63YKu8QIkKM6cbL7zYuJq7MIA0Q
Date:   Mon, 13 Feb 2023 01:48:40 +0000
Message-ID: <TY2PR06MB3213FAE443DC7F66CC3438CB80DD9@TY2PR06MB3213.apcprd06.prod.outlook.com>
References: <Y+YRKdWUA4jjoUZ2@gondor.apana.org.au>
In-Reply-To: <Y+YRKdWUA4jjoUZ2@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=aspeedtech.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TY2PR06MB3213:EE_|TYZPR06MB3997:EE_
x-ms-office365-filtering-correlation-id: 680446d4-80f7-4a0f-81d3-08db0d646eaa
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Bh0yefv39WbxT0pHJiNWO4zZm/S/ABsK0LGcL8980NTAXb/E7woSAKjH4dfUsCWaML0G9EAPXbv4QvrvRu3NZrfJaUsOk1aBfEfYK935YWAnwGzl6uwx9AE5TqwQ1yOX9uHscDu9BRAEuM6UI3HSdccqTlzjxQ696y7rVLglOM/8xq73vT+/QOJ4vnet/0a3rQtdNMSHr+b7kb9Bj2vFE+HsOeoqGTR1IpoWh8D+uS6i3n85gHkdXV+Ro51sjVR/U/2SehGTMFLaIk8Dxgh0FCKag1nludtoz5dSRqHo5dxVgGR6gJX5m1M+wL1K14bMd5JQ8kMPkbyiEMgjgedCWVt5KEbMnbZQZFCnZsv8B81IAl294GsLDTLkCP4eX8JUfQ3nqWKFhuZHuNRFEk6EsF39BFfxpT4WFTJIfXW8juOkbC7GZC6dhxhzaf7tIyk6s+LYmpoS3DhFEadCa27ZbMdWU8Z5NKwTdmGNdJqQkXAD6A9kxYp6Y8pdfvOU80z6vcnf22OOI7Dk4IxESDYJ7Dy76Ht2Lix9bB2hAZlk7AqAxyto4iKC+mI0qdEZm89pUgMkFwYrFJ2u+aN7ZquqFvuRAhFWelQBTA/a53kLz+9h+g8vroQGBLtaOTOWG1zVd5X2l/rQWyyKwH+PwhB7l6buJQihasp4V7fuBll5YrnVer1MeoXern+2rhgY/QYnukMTC7XV41+iDPneCH0XQoq7lcaZa2RLqc737ltSOAk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY2PR06MB3213.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(346002)(136003)(39830400003)(396003)(376002)(451199018)(86362001)(316002)(71200400001)(110136005)(26005)(6506007)(9686003)(186003)(478600001)(33656002)(966005)(55016003)(7696005)(2906002)(8936002)(38100700002)(4744005)(52536014)(38070700005)(41300700001)(76116006)(5660300002)(8676002)(66446008)(66556008)(66476007)(122000001)(64756008)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?l9DjIrm9Vvf30Nz/1y2BSxojGu74NRT7hsnkGf/vm17FUNuXYDRfmwUpLsgL?=
 =?us-ascii?Q?c0ipVJuWaJk+LW99P/I6mD32rsFPUKJ3kGxKRmQbMUYQ8sbwmUc+tTQgMY5w?=
 =?us-ascii?Q?dMFp/OKj0khojT/S83aAu3VWHSecQimmJN3Ddydl563FCgKFuAVv6lTjeUCZ?=
 =?us-ascii?Q?qbU+ZvNxMwDnColKkbRSghR7Wh96OpXjleFUemROecrkrAzz4Wm/LOp4A+pM?=
 =?us-ascii?Q?25tChBWE5cA6+t0PazENRGbH1FLqakqpQZY7wfFMqxMkl6qMThtNlOKpt/1M?=
 =?us-ascii?Q?ZJcwUCF0yHbQRk28eggpjUi3HaDrWrzli20JSEc7hy869LVfyPum+D0VEqqJ?=
 =?us-ascii?Q?k2tHeoRkr7L8XJj45qxR16JhNdKs2XhSDFg4h7AEzTcjogiKUNCxwaxjSo3h?=
 =?us-ascii?Q?CChzSwe7621Ms07U1jM54Bdhbs3e5UkCoh7ojHv0BCtgjVUDz0bJsmhJyPQT?=
 =?us-ascii?Q?bEQfgH3H6moTdHvssKD2qKzxPThW2IPQDI6pk6gqXye1QatjdfPuvPf8AYWL?=
 =?us-ascii?Q?2ETHkfMDne8hqjBa5+XNk7lTCDiTm39t2aAtlT5KzPVfMFG67ElZ7RrKkf+y?=
 =?us-ascii?Q?7GC6tpEoSoZpGHeUPVIP+Hd1a1STm/RN1boZsJ6RJoT3R8aPj5Mf/2FFQaKu?=
 =?us-ascii?Q?vTG84Jh96xJuPb9sv/SQuwWg/iD7HpwpP3o56G7D7nBOk26BxnUaf7KGlkRu?=
 =?us-ascii?Q?fi3L4u/ruKSBhLxMPGBWpa+ZtS38Krc+e9CpcoQYxlhk7CXT8piG/8LJsyPE?=
 =?us-ascii?Q?VCvCc4K0ugvUM89jN0N6AwBRoI5nGJeuvhETQLaiP4LneyfahsBCG3GuK8U+?=
 =?us-ascii?Q?UCsseauwGDsS+z41FSXgdRdtXU/A/QQdPvRZLfVhJwpQnaZWKgGYSIBvbztT?=
 =?us-ascii?Q?XpOnrY/amx4/zM5Y0kpkkJGqM/dBExmUqulbo9PA2qbQxPM+k6wLjOVFe4ai?=
 =?us-ascii?Q?PB7s1yIUBAKAbxt01cNTbZp/rjJvn+kjHFf+bZMIyhCskfWvbWmiWzMPQQ60?=
 =?us-ascii?Q?IOf79vWi6FT4J+w+Ew+3NyqmFnUwP1Ka6quUpv5qj+W9e1Jq/dWNJrKQlf8c?=
 =?us-ascii?Q?JronV2nGUQRw3gTbuPHQzWcy9bn48b2FzQTqvwfettsDRsjek/TFC3KW28LA?=
 =?us-ascii?Q?f0uiez7+FihyCGm0vpB2Y+U1AaddwBNS6eOW3aPLf0vaZyArcJq9kSfHk54N?=
 =?us-ascii?Q?S+kpT2pScqlNGDROuvA2qww/tWbZvxfpABbH74pg5QXFIcE9frEio6nmuagS?=
 =?us-ascii?Q?ZgZpmPDp/RNPVgPFeDrzGXG5HolbM7iY+buq1jJRz8pN8zYM2aSawIWkO4Ue?=
 =?us-ascii?Q?hQa596XKY72AwoR20xcAeSc5uImbtoJX/wq/kw5VIk0ON2yDFxSPIg0/SwD0?=
 =?us-ascii?Q?Ksx6XPGN4MXt4ixQkinJa1yliA2XdyQab4NSOe1sZf2MMvATeASOR2Jlz7cU?=
 =?us-ascii?Q?apWGTKTkREeVHcoWzl3+6l/E5xGY/okI9+1yMKX+WJ4tOnt/+fFn9EJ/L77q?=
 =?us-ascii?Q?LdXzUTf5WQeW5T6hVez8RUioOy0CpkmS5dHDitUFcqSfZPXX3EWbOLP28PbQ?=
 =?us-ascii?Q?5ojCzntw8mIjPcjWe+WdtsfdpVR2JaKU1nbmuB9F?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: aspeedtech.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY2PR06MB3213.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 680446d4-80f7-4a0f-81d3-08db0d646eaa
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Feb 2023 01:48:40.7303
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43d4aa98-e35b-4575-8939-080e90d5a249
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JBnpsCdEZbBCAMnPC/G4VafySvrJw8r0Myf0NmNkFdZOqA1NQlB+ELgJ79rMicfoj4Utdu2i/kZBdMaHIlFBJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR06MB3997
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> When aspeed-acry is enabled as a module it doesn't get built at all.  Fix=
 this
> by adding it to obj-m.
>=20
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Reviewed-by: Neal Liu <neal_liu@aspeedtech.com>
=20
> diff --git a/drivers/crypto/aspeed/Makefile b/drivers/crypto/aspeed/Makef=
ile
> index 24284d812b79..15862752c053 100644
> --- a/drivers/crypto/aspeed/Makefile
> +++ b/drivers/crypto/aspeed/Makefile
> @@ -6,4 +6,6 @@ aspeed_crypto-objs :=3D aspeed-hace.o	\
>  		      $(hace-hash-y)	\
>  		      $(hace-crypto-y)
>=20
> -obj-$(CONFIG_CRYPTO_DEV_ASPEED_ACRY) +=3D aspeed-acry.o
> +aspeed_acry-$(CONFIG_CRYPTO_DEV_ASPEED_ACRY) +=3D aspeed-acry.o
> +
> +obj-$(CONFIG_CRYPTO_DEV_ASPEED) +=3D $(aspeed_acry-y)
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au> Home Page:
> http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
