Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6382EECAAD5
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Aug 2022 04:01:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229585AbiH3EBg (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 30 Aug 2022 00:01:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiH3EBd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Aug 2022 00:01:33 -0400
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (mail-tyzapc01on2124.outbound.protection.outlook.com [40.107.117.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26F717B1C1;
        Mon, 29 Aug 2022 21:01:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iJKwwurHpJ8xWdhlqbMZdLNdjkMaKRz1AHYwhHVEE4haVFdDaUdopVuFTjuW6kGh14vTzqhkZGlpsBdT6Fzs4szxDBlQmysTh4KLpoBXKD1WulgtuW9QilOs3SMPTaoYH8UCOrs6ECAv9TOADYIgt/er0aU9hqCpejJFZ4FXofObfVOG6QbbIeyuGFwiYCKCSTXch9t2cvErOBHqudcFy+hLJ1dCO5R0hKOlqtMS+4/CPoGg2z+aFfvXmSTTTSkeJbgDhK9Fw85S12XkTUfCa1ygA8OdVVomKoMdIWkLjM78tc6molF6s+PgkYLKfEIsO9UneXMBMa2ntPm50iQdKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j6xs6l1YkjZoIWPuWHqcntw9YMtun9edaBVzkGIdsmA=;
 b=W0UWnP2y1rpESVMxOvwK7mK9BhyIcULMlxjwA8QPlkJIsrnZOA2/ThnC8hNNRI51qdQYbruBnr4OxRIUJoU78eKoV9SXmWywYCe4cEMJrKN9yxdLgpIj3oGAX1F8WwWUdizi4YtuN8pRc3NAgkridmY/IrI/ZQzkvV+iAYbaYKinG4dC3L5FqJqwbxDCFGLV0YMTWFkVYVdk1N75M/dsIiDKJeblcb1imqQSw2kh4Y2hREc9Ih63V1YQa98NTayspkPeabGt+3xhjDWvbyxk+EL+FZgbAZiobjJcELPmQIa+HEuaboswCBbxQlI17FKrZi1MGeAFsS7JilL10Ph8Yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=aspeedtech.com; dmarc=pass action=none
 header.from=aspeedtech.com; dkim=pass header.d=aspeedtech.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aspeedtech.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j6xs6l1YkjZoIWPuWHqcntw9YMtun9edaBVzkGIdsmA=;
 b=J+UlC0gNYWj5Xpefu4IK/6QH3sr3hhizgMkwvQAOf7fXTBajyLbzO8nB1jtSjHxuwm4B8x+oguE6atj27Iypv4fvEXthA7Fsj6/xELk3ukaZuDm/OsB3K1kC8cjyukeP2O1fRvTLFwZTViExyRncR9W4aV85SFX7HFwu4OpLbwoz0bXu2hNNSTFhrVMppKU+x/sR2ba/i9nkHxYuNBzdrJPxi2EfCqkoTeDJjDEI7Lc4ii1NCwlQP4Evkf9iGkadXUpkxw7JDy4h6yQ3L64xa7+7C/UOkym64mRk5E2mQ2moiAwPX05+moP73r7VnurC3z72910MOWzIr3oWA01ErA==
Received: from TY2PR06MB3213.apcprd06.prod.outlook.com (2603:1096:404:97::16)
 by KL1PR0601MB4355.apcprd06.prod.outlook.com (2603:1096:820:67::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Tue, 30 Aug
 2022 04:01:23 +0000
Received: from TY2PR06MB3213.apcprd06.prod.outlook.com
 ([fe80::8dbe:4d03:e911:5a4]) by TY2PR06MB3213.apcprd06.prod.outlook.com
 ([fe80::8dbe:4d03:e911:5a4%5]) with mapi id 15.20.5566.015; Tue, 30 Aug 2022
 04:01:23 +0000
From:   Neal Liu <neal_liu@aspeedtech.com>
To:     Sun Ke <sunke32@huawei.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "joel@jms.id.au" <joel@jms.id.au>
CC:     "linux-aspeed@lists.ozlabs.org" <linux-aspeed@lists.ozlabs.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: RE: [PATCH] crypto: aspeed: fix return value check in
 aspeed_hace_probe()
Thread-Topic: [PATCH] crypto: aspeed: fix return value check in
 aspeed_hace_probe()
Thread-Index: AQHYvBzz+s4SK0W+PkG7juKv7paqKK3G0b0w
Date:   Tue, 30 Aug 2022 04:01:22 +0000
Message-ID: <TY2PR06MB3213B139F88D72C3EEED7A0780799@TY2PR06MB3213.apcprd06.prod.outlook.com>
References: <20220830031347.810217-1-sunke32@huawei.com>
In-Reply-To: <20220830031347.810217-1-sunke32@huawei.com>
Accept-Language: en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=aspeedtech.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 62b67c13-bdca-4d32-43bc-08da8a3c4d7c
x-ms-traffictypediagnostic: KL1PR0601MB4355:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XWJsXbVbQyvK3LdKWMnkKMI7Kvn6lZ5y7Rcbex4LAjBpp5ZAJlvvIZfyji+RmhdJ6k1JjpvQrKmV2Ul8ISWLqpn1/VjI+SN6O8/f62pA9UpziGKCRz5x/MVpQ0JZT9PP3bUpTBWFwXJbf8KuqvU0XcWuq7ywUghr7jus6RQ0g4P40fdPJyMY53BqVkfWp5bKNyEaxk9NWbVPOUq4JgZBpMiePorC0mc/qon2YDknq3euIJSb3exafuAabnVogqjarc2DXRklyc4tpZE7opnshCwl5KyotAcFQqsm+sdgIBKByjZmy/rPa2nJrPM2iDZkmmm73fHx2/5TvNrTpX59suAquao2nC/Vfcba5GNvZG84W6BZFLXjilpR8Dw1Qe9/+Cg4cd4Ie/jQaHGWd52/VRzLDwA8JvRCJHSPEuL0CkRJYK7cZa4y/fOmL5PzmES3wHm1gHdxdN2arBjIKf0rNTRXago1zHsxozdi39QsYg76BKc9/VOerzSVigN41majrSXeYWWoCDts6DoE1Z3iO2iPzI9i/mUs3SdxASkiFRu0bIJxzLX4FU6NlYDVgLjCvmjgQOuYYYGvhGiE+5+iyHyUKIlXrGitCngBzei46c6QOTRa9tRoEBMRynDtqj1StpiIakS3EVJWT4uhro7/dFj9UdiJ58ik9wDaLs8rtvWxE1na54kCwL+9JvQQDxKAZt9MY0GL9frHDzUYXLBJr4GpnAktpHOCDWY9MUgkQsf0BTIF+7akPTFWUCyyf9XYQ7QUdFywuMa3K4iucnKUgQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY2PR06MB3213.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(376002)(346002)(396003)(136003)(39850400004)(76116006)(5660300002)(478600001)(55016003)(7696005)(33656002)(52536014)(41300700001)(8936002)(53546011)(83380400001)(186003)(26005)(6506007)(9686003)(2906002)(86362001)(66556008)(122000001)(66476007)(316002)(110136005)(54906003)(38100700002)(38070700005)(4326008)(8676002)(66446008)(71200400001)(66946007)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?rCb5mQA9B3A9l1P0FK0zIwRnloVWk9Zmn1ik7Z3QvEJwP10RRj/Ir7cvcMIp?=
 =?us-ascii?Q?Q9nTe02uu6+rUNQlVdrpnlPf+5SnfMnnp+WNYWJpr/PgugMnU+u2mw3GnLQa?=
 =?us-ascii?Q?eZxsn9SR2nKF+QNW0U9KEw6XLJeB0BkR/p0tuv+dYCqWUyCtizzyFPAWFSZ2?=
 =?us-ascii?Q?r/Ij7WEEGO1hKqyuKq0UGTsmC9blCt2rgg0accTtp78EABh5MmO/vbtHL9Hx?=
 =?us-ascii?Q?9l71jNUXmV2HWNJPG1ep+KlCdpIaNSCQ2OnrzSsrJhW2bUuq2WvE0jSOV/jv?=
 =?us-ascii?Q?8gA2f9u770s1JCKVORbShNfyRsMsvAY+ycVD74EV57SwJ+blt5yJemQp4/zM?=
 =?us-ascii?Q?Jrb0eNC+lZHV18IOs/3slt92/pd/NOapJ5H8hJ6/3Y73M1r+wbHxMjaG+Hrs?=
 =?us-ascii?Q?74XLHz+JFpYzHeBSk/0ZobuYB0N8PaFLUqx0eZjxvyeBOkoRGcHid+7HahOj?=
 =?us-ascii?Q?0pkvingFCeKoUFzNXJTFrm6mSEZijFSXR9wnygb3su4bpFSxZeMkP8hVCwoU?=
 =?us-ascii?Q?fTwC7ejWqUCD6p6ehU6RPznq+I+ib7+/nHbkV7VTkSHmrUCiYGY2iyJ5Tt4I?=
 =?us-ascii?Q?Ex3gQhxBbGj4HlzPwiZX7XwTwuEkgQOwTNvEUrhZIZS1RUJ4pC+2upNWWPN8?=
 =?us-ascii?Q?3ITLODD/RStwx4KiOJVZyeMP2lVUOTnDUUTIWAJekGZdsng7ucaEsvEydJ4N?=
 =?us-ascii?Q?hHHUDTKbqjbU2/7So7Y2BcqA+s0A/L0lypJaVBxU8Q3RzEMIOK2626LqENZP?=
 =?us-ascii?Q?BbTfZEq6iFYUp7YkEcn7TtagsEmWM/kV/abhAzQCXvvRun7biVtOBDnERBaC?=
 =?us-ascii?Q?cJ88jYQ1PTKb/QO3r9tiXydS+lvARFjkrNSZn+N9spjawmSnOTsP44dr4RVg?=
 =?us-ascii?Q?Wz3nqq0MOHKHRE3bInhieHkxHVjq2C5CzMGtwOrs0TBmjxfcW0QYM5msW/4F?=
 =?us-ascii?Q?OOP97uCA3LJfCM7TrCe7DhMvHvp3E3FkHAFVKFhqAfFiyccuRCZ03PECrbLI?=
 =?us-ascii?Q?joVLnG/L6wHTKWIQOf2LMTk0JRWEb8zsFho1PQK8vX1LpocTXxy4GaaeHI/l?=
 =?us-ascii?Q?FtNyNvtU9GKXJ+dXQeYM20KAgqRXxqjDkZxo9bodeMxrfIjHlWQDjNEwWX1R?=
 =?us-ascii?Q?zKkRuvS7d853U1Wopk8u+VGCumKYAlJMydugQ29GEiTE3w25/rejC3NkRsv9?=
 =?us-ascii?Q?8WN8NW/c7l2xtQ7UdVp9Sa7p3z30908ZhNIU+cWipa6Vz9R2Phd1JvjiLL7t?=
 =?us-ascii?Q?qJfCdQ/msvhmE/B4NOLSijkMcZGFYPVWCz207UmGYgDXOzE3ihbxTt4u25hW?=
 =?us-ascii?Q?CVnQCdq1vrOvOVXza1d0Umh4Md/TP9tla/kZJ4vViA2kYAL2EIZZXdbvt7MD?=
 =?us-ascii?Q?QOhc2RlljzHG8hlfCokCfBn6sBwhPDQ1r5b4H6d6L0rdxLhYXkypXlii667+?=
 =?us-ascii?Q?PNNcNEqNtu778G5282Xp40ovzdgj7Z+RZqsPWc9vcUrtSdLkhOrxDptMj+CU?=
 =?us-ascii?Q?Ax/2kNKVPxkr3hn6WIXMp4Ww7sXgLTS250ikYfMQn0jb9VJs1POut5sZal9N?=
 =?us-ascii?Q?LgdGGd0zl/GB+l2rqmW7aaSK+nJ1yb3o7OymcPW1?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: aspeedtech.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY2PR06MB3213.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62b67c13-bdca-4d32-43bc-08da8a3c4d7c
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Aug 2022 04:01:22.8381
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43d4aa98-e35b-4575-8939-080e90d5a249
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Lifj2HHsEEdg3iJdObD9+Q8YDeU54lve2fwvtyrcFKxtMyrn4i8zu7E0T4GfwI/rrZmZc0gUZSTu0OInHDmHYA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR0601MB4355
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> -----Original Message-----
> From: Sun Ke <sunke32@huawei.com>
> Sent: Tuesday, August 30, 2022 11:14 AM
> To: Neal Liu <neal_liu@aspeedtech.com>; herbert@gondor.apana.org.au;
> davem@davemloft.net; joel@jms.id.au
> Cc: linux-aspeed@lists.ozlabs.org; linux-crypto@vger.kernel.org;
> linux-arm-kernel@lists.infradead.org; kernel-janitors@vger.kernel.org;
> sunke32@huawei.com
> Subject: [PATCH] crypto: aspeed: fix return value check in aspeed_hace_pr=
obe()
>=20
> In case of error, the function devm_ioremap_resource() returns
> ERR_PTR() not NULL. The NULL test in the return value check must be repla=
ced
> with IS_ERR().
>=20
> Fixes: 108713a713c7 ("crypto: aspeed - Add HACE hash driver")
> Signed-off-by: Sun Ke <sunke32@huawei.com>

Thanks for the fix.
Reviewed-by: Neal Liu<neal_liu@aspeedtech.com>

> ---
>  drivers/crypto/aspeed/aspeed-hace.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/crypto/aspeed/aspeed-hace.c
> b/drivers/crypto/aspeed/aspeed-hace.c
> index 4fefc9e69d72..3f880aafb6a2 100644
> --- a/drivers/crypto/aspeed/aspeed-hace.c
> +++ b/drivers/crypto/aspeed/aspeed-hace.c
> @@ -123,9 +123,9 @@ static int aspeed_hace_probe(struct platform_device
> *pdev)
>  	platform_set_drvdata(pdev, hace_dev);
>=20
>  	hace_dev->regs =3D devm_ioremap_resource(&pdev->dev, res);
> -	if (!hace_dev->regs) {
> +	if (IS_ERR(hace_dev->regs)) {
>  		dev_err(&pdev->dev, "Failed to map resources\n");
> -		return -ENOMEM;
> +		return PTR_ERR(hace_dev->regs);
>  	}
>=20
>  	/* Get irq number and register it */
> --
> 2.31.1

