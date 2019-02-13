Return-Path: <SRS0=2+RY=QU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09816C282CA
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Feb 2019 18:45:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D3F8E20811
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Feb 2019 18:45:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="gb/shXhX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405423AbfBMSpY (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 13 Feb 2019 13:45:24 -0500
Received: from mail-eopbgr130083.outbound.protection.outlook.com ([40.107.13.83]:50352
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2406234AbfBMSpW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 13 Feb 2019 13:45:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gTf65DmJMr6wm+2ZNFhNaaUdcrARfpB6Lr3vnNQTAag=;
 b=gb/shXhXTx64dNCJju/caF9A6FsCYFfJbUxkwDpDirc/KXws933FLVC9dzOLnL4XWpquK5ce8olwDKrmJoXD6CZIiQXBrSAjlYQ53jBe1gEHy+1nK3pbnjfSzb0xiETIvIttwePwtOtouXve8YHfwQffrObIlNsLupyYXC83WE0=
Received: from HE1PR0402MB3484.eurprd04.prod.outlook.com (10.167.126.13) by
 HE1PR0402MB3531.eurprd04.prod.outlook.com (10.167.126.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1601.22; Wed, 13 Feb 2019 18:45:16 +0000
Received: from HE1PR0402MB3484.eurprd04.prod.outlook.com
 ([fe80::7d94:a064:b55b:b28a]) by HE1PR0402MB3484.eurprd04.prod.outlook.com
 ([fe80::7d94:a064:b55b:b28a%5]) with mapi id 15.20.1601.023; Wed, 13 Feb 2019
 18:45:16 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Eric Biggers <ebiggers@kernel.org>,
        Iuliana Prodan <iuliana.prodan@nxp.com>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH 0/4] crypto: caam - add ecb mode support
Thread-Topic: [PATCH 0/4] crypto: caam - add ecb mode support
Thread-Index: AQHUv7VcNE62/1rs10eCj4efK3X83A==
Date:   Wed, 13 Feb 2019 18:45:16 +0000
Message-ID: <HE1PR0402MB3484556884375681E3E81BE998660@HE1PR0402MB3484.eurprd04.prod.outlook.com>
References: <1549633810-10380-1-git-send-email-iuliana.prodan@nxp.com>
 <20190209215219.GA688@sol.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [192.88.166.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d05aabdd-dbec-4057-58e9-08d691e36552
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(4618075)(2017052603328)(7153060)(7193020);SRVR:HE1PR0402MB3531;
x-ms-traffictypediagnostic: HE1PR0402MB3531:
x-microsoft-exchange-diagnostics: =?us-ascii?Q?1;HE1PR0402MB3531;23:UI1GUdy6554e+n4l4Kcn9MlYERdg0mDX2sLUFkC?=
 =?us-ascii?Q?jCB/MvnZjdA/gzWLz4lfLUqO3CoswRxNHnD2+yk6E3qS0+TTn9b9RuEGTMG5?=
 =?us-ascii?Q?vAdYMGSkZfgWeaG9CAMoNAwBOMV3lAffDyVD0ZQweLM9dRpVZXZ+P+1kpoWJ?=
 =?us-ascii?Q?YrsyHZZlBVRaEKwhumGP72ARh2s11gHOtn6sQQB9IWHhJv1kURN2SXCEbt+M?=
 =?us-ascii?Q?Sxxltuj6rDggiXnW8W4XvEHDQF45tLK3e7Dbjf4CZkGmOI7lXARMS7FRiNcn?=
 =?us-ascii?Q?GqlzKtBfJqFxA0SJMcrXNRvHSoC2znCWP+IqfnBJN4YMVwn+/9LieYqsUTF3?=
 =?us-ascii?Q?wWLD7RbIFTQgF008vRLIR2A7KOWTk8nSQ89KsFxWc07xZaj1y1AJxvkrLsGp?=
 =?us-ascii?Q?jfWyDQ8r9NQjiuP5ePNuy7Y3M5tSHJCyKioSFFkbPA9u9EkDII8Vsm4OacjT?=
 =?us-ascii?Q?E2i52bCHH2mmN7u9gIWqWtzCGQMgfo19SEHt376KXj8wftzBntorkR7yuccF?=
 =?us-ascii?Q?ZYwIlGztKrdBJ52UcQ1kSJn8ZWVkOP5Vs1CzJ0vqSTGMXorHBbLukYuVpttO?=
 =?us-ascii?Q?kdu55Yj0ysWWNKs1PpbJgrou6P7wrvjX1j5PRebDKCs2ZlFBrqtgpu9Z268N?=
 =?us-ascii?Q?LM60v5AQKCqA4uDFnRmy1pgPf0eStVPSwPVT7S8DdCxPqn4+4HOvFAEnHUHm?=
 =?us-ascii?Q?qdvTOGprT9Lt3w8f1nmz3jsyux2snSOpU/0o6XNwXVDrc852pwmu0Ykc88Hj?=
 =?us-ascii?Q?qsQdkM86cu+bwTFvxJHBpUtUJ0RU21KXrkVapWYjEJ3MIVP8U5p+jL2c+/xe?=
 =?us-ascii?Q?5e2yyk/hkG8Flz0LTnoE1hw2mmJBkeSjOKC4yqlgm/DGnN46MyyrVz4XTMxL?=
 =?us-ascii?Q?h+GJ+u9SGY1AafGuM8naxpikyQffDfZqOoUxb0fzaG1OclWVl6ywssC85lsx?=
 =?us-ascii?Q?rDaD/OMtAM47Edu01LbS912+d97OY1TVwwhsyLB9WzrP1esdrLNExWdL7+lR?=
 =?us-ascii?Q?eAX1Z+ExbeNEzp8B7UkOL9PwoK8gqSNMNiTfSKlUHI5xUELXUYrJMdHF+31n?=
 =?us-ascii?Q?HJ8K7nrS1ceB43soX3B696ehINhSSjzM+RrNIq7oBh4qxzzEBeImf8tpkvhk?=
 =?us-ascii?Q?TKUGWm1tH9WDBbPw53N05UBBvDTFqDMgfwI7Yunz1zPN7jIONPz67DUWEDk+?=
 =?us-ascii?Q?BxuUJoKj8iF19+1vG3BdvTUF6vpQvSTcQHniDJUbtWZThHFYc1AaXWhdXcA?=
 =?us-ascii?Q?=3D=3D?=
x-microsoft-antispam-prvs: <HE1PR0402MB353123CAED225C98FFF2923A98660@HE1PR0402MB3531.eurprd04.prod.outlook.com>
x-forefront-prvs: 094700CA91
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(136003)(366004)(396003)(39860400002)(346002)(189003)(199004)(446003)(4744005)(186003)(6636002)(6436002)(26005)(476003)(54906003)(316002)(478600001)(110136005)(33656002)(68736007)(97736004)(256004)(53546011)(66066001)(229853002)(44832011)(2906002)(53936002)(71190400001)(486006)(6506007)(71200400001)(102836004)(9686003)(86362001)(55016002)(6246003)(74316002)(76176011)(81166006)(4326008)(6116002)(105586002)(305945005)(8676002)(106356001)(25786009)(81156014)(8936002)(7736002)(14454004)(99286004)(7696005)(3846002);DIR:OUT;SFP:1101;SCL:1;SRVR:HE1PR0402MB3531;H:HE1PR0402MB3484.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: iH9idUxusNJnMB6g5vNdNF34lHKv6LzCCQn8xSt1r92O1XdWU4uPUUJNlVsI/yrHtCcJuAirC/LDaXXfC1CPcc6LDSlgHthkwpdcrbeUI9fJAgqBh96C1v5n8ifojCnlQ4aAH6SU38agsWoTDzo8Iue7AShI4VlvGsmgH48IQzUUhyNcqBRPi6sfmyjGxcHOrI4QnBTGM40imbCB5c293UD+Z+POdtfjqjW67qLGocEQv9D1B5A9WOp3y0oTHqQESNj/nadATiwQRSR9fdXjzjutiT3TD7g6sxBVcfkD4pli6GhDhF+GKh8UmrDG5FAapcGSVI+4mh+agtBkT27XMGZ2D6wvUr3U7nh9WrCkTlviYIfocw7540rXX1J2QCK75df1/Wxs66ViPED46YnmAPjPl4RQ8MrUHNd7tUGULWM=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d05aabdd-dbec-4057-58e9-08d691e36552
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Feb 2019 18:45:16.1742
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0402MB3531
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2/9/2019 11:52 PM, Eric Biggers wrote:=0A=
> Do you have an actual use case for adding more DES, 3DES, and ARC4=0A=
> implementations, or are you simply adding them because the hardware happe=
ns to=0A=
> supports it?  These old ciphers are insecure, so IMO more implementations=
 should=0A=
> only be added if there is a real use case where they're absolutely needed=
.=0A=
> =0A=
One legit use case is PIN encryption in Point of Sale solution.=0A=
=0A=
Horia=0A=
