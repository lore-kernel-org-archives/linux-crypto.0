Return-Path: <SRS0=YWhG=TP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91C05C04E87
	for <linux-crypto@archiver.kernel.org>; Wed, 15 May 2019 14:24:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 636D42070D
	for <linux-crypto@archiver.kernel.org>; Wed, 15 May 2019 14:24:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="nLxXMy09"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726821AbfEOOYF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 15 May 2019 10:24:05 -0400
Received: from mail-eopbgr70040.outbound.protection.outlook.com ([40.107.7.40]:35796
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726098AbfEOOYF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 15 May 2019 10:24:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SOjwZMSmfxO4wtNW6MlG9sdzVI4mtmRgijXh6zsftZk=;
 b=nLxXMy09kmXn7KQWr5IwoOL8XtwCYHSfbcvzCP9+g/w0FQtdjZElsDtMVx0s2wbA8bIdeXwX0db0+tPU6YqYUiq9MjF8PaQo2Sqm4w/5KA4xKBTRYysXtEf+gkLLz6jX3gPxA/R53t+Mm6k7/YFEpZhb6cpzIo5ABkEcx1XXnqA=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB2911.eurprd04.prod.outlook.com (10.175.24.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1878.21; Wed, 15 May 2019 14:24:00 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::dd3c:969d:89b9:f422]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::dd3c:969d:89b9:f422%4]) with mapi id 15.20.1878.024; Wed, 15 May 2019
 14:24:00 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Iuliana Prodan <iuliana.prodan@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH v3] crypto: caam - strip input without changing crypto
 request
Thread-Topic: [PATCH v3] crypto: caam - strip input without changing crypto
 request
Thread-Index: AQHVCyaguwFNZWWr4kKcDDftCl1gCA==
Date:   Wed, 15 May 2019 14:24:00 +0000
Message-ID: <VI1PR0402MB3485EC92E27ECD4501587B4998090@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <1557928856-9550-1-git-send-email-iuliana.prodan@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 028d9fdb-30f7-48e0-b19b-08d6d940f97e
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB2911;
x-ms-traffictypediagnostic: VI1PR0402MB2911:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <VI1PR0402MB2911C1E989211449A80B102498090@VI1PR0402MB2911.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2201;
x-forefront-prvs: 0038DE95A2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(346002)(39860400002)(136003)(366004)(376002)(189003)(199004)(446003)(66066001)(8676002)(66446008)(64756008)(81166006)(66556008)(66476007)(76116006)(81156014)(476003)(2906002)(9686003)(8936002)(66946007)(73956011)(6306002)(486006)(966005)(52536014)(305945005)(14454004)(86362001)(44832011)(53936002)(74316002)(55016002)(3846002)(4744005)(6116002)(5660300002)(316002)(54906003)(6436002)(110136005)(478600001)(99286004)(25786009)(53546011)(6246003)(7736002)(68736007)(229853002)(71190400001)(71200400001)(6506007)(26005)(7696005)(256004)(14444005)(4326008)(6636002)(76176011)(33656002)(102836004)(186003)(473944003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB2911;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: j8xNFIWTiJFpm4ByPSZLcS8DgRu4sJvfE9RbjP2fpKe+80/y++vMr3GbrqCUkeiz/MzU0MmnYeoar+G6ZEuAdD7lHDZYvNlSW0/VEe8pluK80hfn5Wt1vhpN0B6C+9SRgd7I9UA5wcolNh6ssZo37X71xBsnlKMQNjoUJZwX7KpZRX7RRkRkIMzZ8NZwLeFl4vltlzWD2iGEeltKE0p6rR9qIcqBjA5fC5Ja9cfS1W8O4FkG8u/ZFbSw6K3jjVTFSuW6uA2LuweU8SsyqIPgUiQ4xFfTdiDBdUH2ZIqsJrd/uhcz+JJW3wUTrShEpLGtnC0HbN+TuySdSsltojL6t9BeOjSKPYEacpDaSb/jTQk09kf0Ngm2NvTkRu6yiBWNbCnXLVBKesaML/PPiTY/4/gSQFBZhXNP9vJB9xelOgo=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 028d9fdb-30f7-48e0-b19b-08d6d940f97e
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 May 2019 14:24:00.5437
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2911
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 5/15/2019 5:01 PM, Iuliana Prodan wrote:=0A=
> For rsa and pkcs1pad, CAAM expects an input of modulus size.=0A=
> For this we strip the leading zeros in case the size is more than modulus=
.=0A=
> This commit avoids modifying the crypto request while stripping zeros fro=
m=0A=
> input, to comply with the crypto API requirement. This is done by adding=
=0A=
> a fixup input pointer and length.=0A=
> =0A=
> Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>=0A=
Reviewed-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
=0A=
Herbert,=0A=
=0A=
Just to avoid any confusion, this should be applied on top of=0A=
[v2,1/2] crypto: caam - fix pkcs1pad(rsa-caam, sha256) failure because of=
=0A=
invalid input=0A=
https://patchwork.kernel.org/patch/10944593/=0A=
=0A=
Thanks,=0A=
Horia=0A=
