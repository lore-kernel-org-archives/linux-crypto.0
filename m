Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F11B4C6FA82
	for <linux-crypto@archiver.kernel.org>; Fri, 23 Sep 2022 10:15:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231458AbiIWKPe (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 23 Sep 2022 06:15:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229962AbiIWKPd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 23 Sep 2022 06:15:33 -0400
Received: from APC01-PSA-obe.outbound.protection.outlook.com (mail-psaapc01on2121.outbound.protection.outlook.com [40.107.255.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F663765C
        for <linux-crypto@vger.kernel.org>; Fri, 23 Sep 2022 03:15:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gPpoBKGse0/e/Xif/Hcq40dm+sR+oMzTxlBTD0AmgCgRCjQomUcWmOAl1Io+fSR4YsJRe8fQmQ/G0kjjndUzq4Nr88gF704QkT+ygNQO0L9SNXN64gmvA3UJQAduP1/MB++o+aIh7WC1aIBiM9NNXNhFaSCtwlDltXTSyEFwK7pPw0YjSUn+5AlFW9+8WV+WPDuqZSWD6NQBh7pQPDOJKhIv5uGe+Pjwmt6dFO1NK2nLvXRDhNCAndbsumflYDXApKHG45hUrfzgZvoegCRGh/hIQZeHpffoyWvuOIi32tez+cSyuo8DoMadAKsPswIV/EHANTQhBdaW5/enKiBEfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=84zJGPwslLul/YRPTOIUiPEKcTf8eHcYbedq55jrd3A=;
 b=m0ygO6gyngwLAS3oKbe1InHa0BqvqtAeVzDGtZ9Pu9uRZQh7MxGPxztiO7RDnP8iKdXWfBMFbjWD1aXtkxZ2KJjk6yb9MinWedpocnhzvB/bklGSP0SBvK3B8/T25m8BbIKDoPhmH1rc97mCdi2MBE6/lfylExuUoCdk8nrLWkPdWmupQBouaEn/B/PNA7MiDj5TIviDH2abdaOB6Gl+lwxvk9e9anP2EGSa5dlpyn1d2jFdB22B4YFAlR22ZC4lKhs5+adfiAGTV3XpliCkEVfljGMcFyzb6OOL9c8EC2RFxVY5rbs7Lf98lhLS294eSQc07HYs7QulnY3f1W0Iew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=aspeedtech.com; dmarc=pass action=none
 header.from=aspeedtech.com; dkim=pass header.d=aspeedtech.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aspeedtech.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=84zJGPwslLul/YRPTOIUiPEKcTf8eHcYbedq55jrd3A=;
 b=mZxtdPznwDVd6PJhH22IIdpV3O0Qzm1QRg6AqKOMVltmmFAZMhPni/k/JMnelxu3Vb8VT90/M3hMbtDBhHXMAdMBahh+6S0xB2IISBTO7kQc39axaOe45s7k1Xssyi+7SVvXXlUVgolkZKZ2PEkktZUbR1kxIvN0PfDXZ0NXgOfet0qxL60SNMVHZnJOk5+BwPaGp/359X+Go67AFnG1ij3FT3PCVxvPu6NpH9r4CsbE6p4wB3KBdnT21xcExfvCpQTF/1SXwmkSWY5xZCZPKQEsBzZ626iSxyh908YM8ipc4Y2rZsGjqhUdncezJzVr6RY0rtwzbJObZ2rf1f514Q==
Received: from HK0PR06MB3202.apcprd06.prod.outlook.com (2603:1096:203:87::17)
 by SI2PR06MB4073.apcprd06.prod.outlook.com (2603:1096:4:f5::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5654.20; Fri, 23 Sep 2022 10:15:23 +0000
Received: from HK0PR06MB3202.apcprd06.prod.outlook.com
 ([fe80::ecfc:64d3:aa40:f00b]) by HK0PR06MB3202.apcprd06.prod.outlook.com
 ([fe80::ecfc:64d3:aa40:f00b%6]) with mapi id 15.20.5654.016; Fri, 23 Sep 2022
 10:15:23 +0000
From:   Neal Liu <neal_liu@aspeedtech.com>
To:     Shang XiaoJing <shangxiaojing@huawei.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "joel@jms.id.au" <joel@jms.id.au>,
        "andrew@aj.id.au" <andrew@aj.id.au>,
        "linux-aspeed@lists.ozlabs.org" <linux-aspeed@lists.ozlabs.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH -next] crypto: aspeed - Remove redundant dev_err call
Thread-Topic: [PATCH -next] crypto: aspeed - Remove redundant dev_err call
Thread-Index: AQHYzy7BVRa5ZEilMki2NU7nDjE7P63sy+dg
Date:   Fri, 23 Sep 2022 10:15:23 +0000
Message-ID: <HK0PR06MB320294D6E2A61F85F4276EE780519@HK0PR06MB3202.apcprd06.prod.outlook.com>
References: <20220923100159.15705-1-shangxiaojing@huawei.com>
In-Reply-To: <20220923100159.15705-1-shangxiaojing@huawei.com>
Accept-Language: en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=aspeedtech.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: HK0PR06MB3202:EE_|SI2PR06MB4073:EE_
x-ms-office365-filtering-correlation-id: 3be3a671-a5cb-4469-d9db-08da9d4c8722
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WBvroKHtQ4UlYqlv9lUCRQbFAnRlx1Eh49Uw0FTxx5icMbWDdf1lLNUrieHUGC9buK7VEnZ6HasaQXMP5xdxCjfBzZZbxe/MM8ApmcYP2LSq8/CSVUNy0626L8vlCN5aQzvUX1P7V9sx8mFDVOwhxn3LCnVImn31pI12NYsFKgCAeZz4Mq+kv2UL2KB7pLYUC3VtrNUrs42Vgc6mXRovtdfYLifPsZv9UtQT9tzhxIBOfjYESPXPHqJmYhTiyIb6j10jFKCkGcsN54/Z8qAGTNDsDVNCOhy0xerMpL8/xJ8pKx2WNvi8B4190X/qmprqIPKqyocCHKzNs8eNd9lr5o0NcSSE/pBpyDsJlwSOFrUPZFkwSuWy29e8nJP4FYArUmWb4zgFzywaXuuH54x4gl+qpnks3jiliDQO8QgSnC+9vJwm5GQdaanxh9egqVmUkjlnmhJtkLNpxyAG2a7GkUhefVSSs0Hkcd210Ip6/lGrYW27ibYo0H/ed5Gx5kIk43ftb9O6rwtR88kOJiVgLm02nWpLOJ/9+Zon/yWYNGK/v0KFTfRWhNobKUjSL8ZpN7brvdGeM9mxc4E0R2kLc9jjCRls/Kjy9lnnq7LF1uZQVP+fO9xJZi89iVQJjxHmcrxS7WfdpuYIGC157bLlFGqu/6JFbDSqjqFtsN06d692Avx3y8IwwtbDJ3tcX3ZXd8yJyiDcLvvExngnnp0p75e8/DmyL+MFOD2MDRHpiFdOvUQfku1u39SWpq8COZyawAng7ecNW51bPQlVq06cxhPpn4/Ts7FJ20pb5ihM/io=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HK0PR06MB3202.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(346002)(39850400004)(136003)(396003)(366004)(451199015)(86362001)(9686003)(2906002)(478600001)(26005)(33656002)(110136005)(316002)(71200400001)(55016003)(122000001)(83380400001)(38100700002)(8676002)(52536014)(186003)(8936002)(41300700001)(5660300002)(66446008)(66556008)(38070700005)(66946007)(76116006)(66476007)(64756008)(7696005)(966005)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?uLKg6D+3Y6hJMNSjHjXEVD6A5NvO7hBmElxIW8yvqv7emVSEdyHgv92p0Lo/?=
 =?us-ascii?Q?Db8ZOTHS1NOrPxySeA+6C7ZkMxQQuUx/pgY0AQjeRoqCuWzUQWiAhpMUsxin?=
 =?us-ascii?Q?Ob8lRLaJeuUV+TtouBWggnvPmO3S2C7XRV6x3BsPmoO8zMA5/Y8lofvkYa8i?=
 =?us-ascii?Q?rQ7onn9fU9pGm7xH/h6gXSpIQWMS40+nAi51NWN00k80YaLa5oAK+heqQyV2?=
 =?us-ascii?Q?h+5j4D5sK+pqkAVSS7ofP+aIlob+ZQ9WtA5FXnBBdLTSkS7PZLObG1qcy656?=
 =?us-ascii?Q?tvL0+2cKAjbEwWnGjdSRg0RqUQa8w+JlSI7oOqRj+n8/Lr2NJvmBSyny1441?=
 =?us-ascii?Q?igpSNnEiW3gpMNlyFoVtjs5kQPQj0m8OoIoH0fX1OdFvSzZsCj2tq5YIASjd?=
 =?us-ascii?Q?hvcCFiWrH3+yJng5x2We0qz470gMDKnYUfO1dNoXKj3LTic3BsLU41R7MEsj?=
 =?us-ascii?Q?UiU85aDkC5Q/DHvLC/BhTgKseQf0HU6lJMD5DNCKweD7C3/Gr9Gyls0dx1xS?=
 =?us-ascii?Q?iXv75Ay/p8AjwxPGYxzi3QBnBkyfQuLPzdB6ByNJTT6rviRZP8cHhFKxSDbd?=
 =?us-ascii?Q?PV6pzsXSPu7qoj5V0o/kigWNreJhtu/DaBN5BOSTTE5f/H0d/0EPL14zH0ny?=
 =?us-ascii?Q?M8Si0qE7pMjiIZ18oKju9xm78OQVPnPxkxpSlthJybnpNJw1ZRX5BQiaX+qO?=
 =?us-ascii?Q?g8X8pPxgn2ILtgArcYsrQrpvvTO4YjAENVG59x2gAvc7CleUUV7uqH7fN3T+?=
 =?us-ascii?Q?MzwoaCR5GXG8Bi6GuCtYDpBvaX+LWnSnauQ0S5+FonkwMRcoALX0Fwvq9dqF?=
 =?us-ascii?Q?dzDMzCJGyl2c+/r1EAhcTlG0aFXSNsc6DO4tLxnb2V+rQGCTiitwxQwbd7E0?=
 =?us-ascii?Q?/hQPUEr5jO3g+v/sWs7adC+oS7w2FYzvRtNG7jHPhQe90L2eU42xHLqU8wQY?=
 =?us-ascii?Q?dHL4OzimreuPPPFgU1jtU2As1jjVNL6ade3N/Oms2hTLGjEB/3vGcKTihgUP?=
 =?us-ascii?Q?UevrMmX9CQZsN3KHWYq2sJjzSeAGHxhW8rYzHVVwmlcd1G61OpZq2yNNMRSN?=
 =?us-ascii?Q?E4rwoFJHRtCynKBKgLoLobJURhgkydRYF2++PQOQ+ZKpraqJey3cwru1pOIb?=
 =?us-ascii?Q?cU66R+WDLJuahB5HH9jXrJRVhIu4P4i6i08/jgaVujWNvMzuv/O3jUPRAFHX?=
 =?us-ascii?Q?I/09cK6PiNbvjnbTXd0PFbEq4yBCHk9jGE1lIffz0dbIzpv2YPQBjddGl+VG?=
 =?us-ascii?Q?tYXLpRy/hSh9VsYL2uXOnV0I7X1o0d1GORd02fyFUt4X+jCPu4v9deIZp20G?=
 =?us-ascii?Q?Zj9t/Z7XJy1GNGetKVWoEZdxAk9N4Lg6yaW3sDP7d//B/VOdbGZ5Vru5clvS?=
 =?us-ascii?Q?KHqykvpAzwTLJrHl2Ylisu9gmj+BtmA19j7NzWocG1O74C+0F3jZVEmKdFUB?=
 =?us-ascii?Q?rnAUb3VXfFys12j4gcTetI3X+VWc4QGWi+L5D07bUNT/N6JNKip54wccM50r?=
 =?us-ascii?Q?FhBcmyPqncfGcD1vZklX5wogUAUpLdX3NlpQ/jMLrvhS//Bk4a8Ktcma2GIg?=
 =?us-ascii?Q?XIvA1sIJ1mCAhCllF4vHNWjwOokPP7f1IB1VFaVH?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: aspeedtech.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: HK0PR06MB3202.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3be3a671-a5cb-4469-d9db-08da9d4c8722
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Sep 2022 10:15:23.6161
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43d4aa98-e35b-4575-8939-080e90d5a249
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RN+2wepURjxceqMCuwJzFN7D8sSorT6M3HW8EK4cLtJzC6GHH74WqOUM3AXWfItE/evPc8B6SUiwuCWAQkCGYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SI2PR06MB4073
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> devm_ioremap_resource() prints error message in itself. Remove the dev_er=
r
> call to avoid redundant error message.
>=20
> Signed-off-by: Shang XiaoJing <shangxiaojing@huawei.com>
> ---
>  drivers/crypto/aspeed/aspeed-hace.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>=20
> diff --git a/drivers/crypto/aspeed/aspeed-hace.c
> b/drivers/crypto/aspeed/aspeed-hace.c
> index 3f880aafb6a2..e05c32c31842 100644
> --- a/drivers/crypto/aspeed/aspeed-hace.c
> +++ b/drivers/crypto/aspeed/aspeed-hace.c
> @@ -123,10 +123,8 @@ static int aspeed_hace_probe(struct platform_device
> *pdev)
>  	platform_set_drvdata(pdev, hace_dev);
>=20
>  	hace_dev->regs =3D devm_ioremap_resource(&pdev->dev, res);
> -	if (IS_ERR(hace_dev->regs)) {
> -		dev_err(&pdev->dev, "Failed to map resources\n");
> +	if (IS_ERR(hace_dev->regs))
>  		return PTR_ERR(hace_dev->regs);
> -	}
>=20
>  	/* Get irq number and register it */
>  	hace_dev->irq =3D platform_get_irq(pdev, 0);
> --
> 2.17.1

Similar patch just be proposed few days ago.
https://patchwork.kernel.org/project/linux-crypto/patch/20220920032118.6440=
-1-yuehaibing@huawei.com/

