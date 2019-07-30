Return-Path: <SRS0=RABd=V3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B2D4C433FF
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jul 2019 18:55:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AAD7C20679
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jul 2019 18:55:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="miEPWFHb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726165AbfG3SzM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 30 Jul 2019 14:55:12 -0400
Received: from mail-eopbgr00047.outbound.protection.outlook.com ([40.107.0.47]:62491
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726133AbfG3SzM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Jul 2019 14:55:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CkLa0cG9ElvLdpbaaAmxjeTRKPmKobI8AJUqcE53rjOXW9UxLzGveL8KisrWYiggy6Qmg9joUTlVpuh3YtBS820KXZd6QTbRnGFD29W9iMFn8Buf/XqF91f9OzIDeH8Age63kjWJscGZ1/fBrfd9eFV5/fzcsFFL0GZYJcRFckQ90TJtyEQYXWSKg5q3T6RmIyvULQYPhdGCzgsv+la1clVJGRtH/2NVPqt1M5e7VSq0Bnxs4vgMIWYnVcJXiwuPXHX5THGY1duBMNF6HaKqMC4D2f1pAWBCMINNP17XsiEU0ondFkSyngKxSG5/s8z2OJcgTEaKURzfAqp/3OZfgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jrZQOD7Y80mYhDWkVjsH8bSKEeQ/oql6Gb7mViOVj10=;
 b=FzWJvW4F51j4CXUg2herWTC4b35tRT9elY8MGw5XD+xtUn1XQP+oT60cADPitWTkG0wvM17ZyZ1x3ZBX651tIeB8U9+k66xYnoUQ4sHciicsiTemlR6LMYNLjk9v3m2jdF5eNPSLWAX5TJj09K3pQ1tZp+e2CId7Zrf9t7MHDGCG36fS5gDfBBWwpbVSILxAk87kDfHVx+AcZrYlXjdCsO1hcI801DNmmcI6RyPty9TopSfY1V32WiBSynffevAPvoHLsM71wn0PcsoEYeI32kXTh7ch81AtZU2okEk9mPCZd0RSRgooBrjq5TjgLyZTLCYDM48s1wzRwh4zutcsbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=nxp.com;dmarc=pass action=none header.from=nxp.com;dkim=pass
 header.d=nxp.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jrZQOD7Y80mYhDWkVjsH8bSKEeQ/oql6Gb7mViOVj10=;
 b=miEPWFHbTU8pasZZs8xkdty0a3vUpe9nILpTwheexlGGZqxFKdwoJfTNVE/m6OHl6PgkfJxWFDuFcUiYNqm5zckJS0QJfkTdyP93mZcwnJDowegK3WzG5NtahIjSsDNl2PsC9Wey8XSGMxAeDEn29i6NmK2rY+VNMxLLCe6k7ag=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3342.eurprd04.prod.outlook.com (52.134.8.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.14; Tue, 30 Jul 2019 18:55:08 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::7c64:5296:4607:e10]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::7c64:5296:4607:e10%5]) with mapi id 15.20.2094.017; Tue, 30 Jul 2019
 18:55:08 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Iuliana Prodan <iuliana.prodan@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH v2 1/2] crypto: gcm - helper functions for
 assoclen/authsize check
Thread-Topic: [PATCH v2 1/2] crypto: gcm - helper functions for
 assoclen/authsize check
Thread-Index: AQHVRwhObpCPFvDSeUqop2wwpsyVwA==
Date:   Tue, 30 Jul 2019 18:55:08 +0000
Message-ID: <VI1PR0402MB34854261466D187547AEB5CA98DC0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <1564482824-26581-1-git-send-email-iuliana.prodan@nxp.com>
 <1564482824-26581-2-git-send-email-iuliana.prodan@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [78.96.98.22]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 317b8ff0-0f1a-4705-c30f-08d7151f712f
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3342;
x-ms-traffictypediagnostic: VI1PR0402MB3342:
x-microsoft-antispam-prvs: <VI1PR0402MB334284054946A0C3E9BC767598DC0@VI1PR0402MB3342.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2887;
x-forefront-prvs: 0114FF88F6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(396003)(366004)(346002)(376002)(189003)(199004)(81166006)(81156014)(54906003)(110136005)(33656002)(8676002)(6436002)(76116006)(66066001)(86362001)(478600001)(66946007)(91956017)(558084003)(66446008)(66556008)(66476007)(186003)(8936002)(2906002)(229853002)(305945005)(5660300002)(7736002)(74316002)(316002)(9686003)(25786009)(6116002)(3846002)(71190400001)(64756008)(256004)(26005)(71200400001)(446003)(486006)(52536014)(44832011)(76176011)(476003)(55016002)(102836004)(7696005)(6506007)(53546011)(99286004)(14454004)(4326008)(68736007)(6246003)(53936002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3342;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: q8wJGKergj1wStEezFtAlSdGBpL6DxQw9XKPmgEEgKfVIfL3YApfJ6/fTJBDhOBEsDukARy1QdHmR8z07VFgGlMiz03cGa//68hhrpxnd9RzPRm1pGI8PQfkqQna4sD26c6ZOUGi9zCgBj8gS/Xv+lWduyMGUvEfFn6UV+etbsF6mSp5p6i47v//1ii62dW6CLrdgR0DZbZEmWwFVNQGfz4OCf2aKcP3A6wuxOz4GOAcj98KhZ0SwozJb7kJ+QNMsSFeSJ437ZSB0D0qGK+JKUQ96bAyvMKdEpBZrUGtdF00AwBhp8s1MUo2nKm97k0wwxbPKvIy2dMCTNEE4kZvYmh1EOkp1iLfY2S+Ii18KoQHSdJSRlfDCZNvzw2ZXdP1NMGkLwYu7s1SdAQEIb/4OxjwmFspTBZKJeIhrQwEjOo=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 317b8ff0-0f1a-4705-c30f-08d7151f712f
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jul 2019 18:55:08.2889
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: horia.geanta@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3342
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 7/30/2019 1:33 PM, Iuliana Prodan wrote:=0A=
> --- a/include/crypto/gcm.h=0A=
> +++ b/include/crypto/gcm.h=0A=
> @@ -1,8 +1,63 @@=0A=
>  #ifndef _CRYPTO_GCM_H=0A=
>  #define _CRYPTO_GCM_H=0A=
>  =0A=
> +#include <uapi/asm-generic/errno-base.h>=0A=
> +=0A=
This is new in v2 and I missed it initially.=0A=
=0A=
If needed, <linux/errno.h> should be used instead.=0A=
=0A=
Horia=0A=
