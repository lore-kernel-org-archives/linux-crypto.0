Return-Path: <SRS0=S8oY=Z7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43BDDC43603
	for <linux-crypto@archiver.kernel.org>; Mon,  9 Dec 2019 16:23:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1A8E220692
	for <linux-crypto@archiver.kernel.org>; Mon,  9 Dec 2019 16:23:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="SuSZ1JmG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726509AbfLIQXu (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 9 Dec 2019 11:23:50 -0500
Received: from mail-eopbgr50069.outbound.protection.outlook.com ([40.107.5.69]:13223
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726230AbfLIQXt (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 9 Dec 2019 11:23:49 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mjgzkqI21y6+YMtqta7/qsyX1kRLS8wWOt6P3DkuGiSx7ZF/UOnqlo2mU5nxl6UqmNiZuqc8p0x8/LIPTL5fr9fhJHIiEqWw4ZkJ3NPTFQOr0rUo+cQqX/8ovX2FPwwnQ1SZsqe0dGwJFCulAN2cCe9rIkHHvR2RKyjNNXQV2qO4oXp523wf8RDQqUPiKiqxHTfB7idiOsV722uhxyCf1TSQ/QN+Agr0dvIYsMOgvtXqOxLkYyvXYPNamf8d42uCOMq6nfojckIMONa3XBU7SOD9u2HIq/hNmjXr+VflW+Op0nrbNFeqLJ831pPHI1Nejx6plAboEpMhKAJ8LimR1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ARkJL02bUXCsuU3ALtKlXcZrlZw2MlKqgqxzAK+beJM=;
 b=LqtNB2WGAiNBwRTNk5zeK+X8utNZbGNboYXQ+XiwWp9SlNeUxfx95FBLToKq+LpEF4i//yOpRkyNysDKUC83hT6NJMCamZ+SuFaKdQYR+zP1hakHnBngwWSQF6MHsQqDa6ATQ6NwSUTE4iPtdOxKfZZZVvaLLwG/NVA82V5FmQ5C9w2Gbiw1gXGHgHtCH7eR3JeP07w5ycG37Kuv2q10qHicJi7Rz+bk7GKlhsNgjhicXpqJ/fPr5vSmR7YcdrmccC/5V9vHkai7oAXS/vqpETbVwIAjMkM6aT5wzr+zKuOHBnfQKGzrU3j41jn02MECvnaQ9uMNj9+tyFR5eaxoIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ARkJL02bUXCsuU3ALtKlXcZrlZw2MlKqgqxzAK+beJM=;
 b=SuSZ1JmGjmBJVw5YbEHKyZ+HVtTka1HtbyfpjpKEWuFITqWeGEBnRPoHxkvMNGsnRn+sKyDtcyolQakhj1xPRftXEzzY3FytoRhHBqsvSTma1d6cH1R+y6iE7/ukxMCeLE79Qzcx5VqWsbLU2nvKDF/sR07kFO1Nr/ojUKJowVI=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 DB7SPR01MB0012.eurprd04.prod.outlook.com (52.135.141.161) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.12; Mon, 9 Dec 2019 16:23:45 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::64c8:fba:99e8:5ec4]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::64c8:fba:99e8:5ec4%6]) with mapi id 15.20.2516.018; Mon, 9 Dec 2019
 16:23:45 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Adam Ford <aford173@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        dl-linux-imx <linux-imx@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] arm64: dts: imx8mm: Add Crypto CAAM support
Thread-Topic: [PATCH 2/2] arm64: dts: imx8mm: Add Crypto CAAM support
Thread-Index: AQHVp9DMEHInO4wSqU+tSt6Rx6I4SQ==
Date:   Mon, 9 Dec 2019 16:23:45 +0000
Message-ID: <VI1PR0402MB348586BEDA9BE13CEB10C75698580@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20191130225153.30111-1-aford173@gmail.com>
 <20191130225153.30111-2-aford173@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 6346c512-2a42-49ca-46eb-08d77cc429be
x-ms-traffictypediagnostic: DB7SPR01MB0012:|DB7SPR01MB0012:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7SPR01MB00128994075675E07E14ACC898580@DB7SPR01MB0012.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 02462830BE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(396003)(346002)(366004)(376002)(189003)(199004)(9686003)(7416002)(55016002)(52536014)(71190400001)(64756008)(54906003)(110136005)(66556008)(71200400001)(229853002)(66446008)(305945005)(33656002)(76116006)(91956017)(66946007)(66476007)(478600001)(316002)(5660300002)(6506007)(7696005)(86362001)(8936002)(44832011)(186003)(4326008)(4744005)(26005)(8676002)(53546011)(2906002)(81166006)(81156014)(32563001);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7SPR01MB0012;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3v7Mg2eBxrwqFCr8SLr6v+kro3ylsTGTgAYquN58+Up88RowdPvyCQWCRlHaeWO1FXtCay78bpvUOfPn2dBF/12vr1y1aIhp5HkAA+8BmQKJ0Ylizy8QxafbxPsDbr7lkK1UnO6uBNacdAVMR0qUH6nJArRZRYcjGI0i9YbJ1JzscomZf56u2AorRuLiYYeg3FqAo+cmKJeRtszmkXSlj7IoFjt70+JgJiMhrgKer2n/kPwo3UKWsEutniYMqcW/jMBqqRkOMmfXGokrKfeVezfizK3OVRyn4vENE+dpeuWcgWYAE2EaZYCiASr7GrayPgx6zoB447s9BVXT0KVSuIsg3C6auXG2XXJ5vbYULOEOxurIENCU8GeZ8ja+p6VzADmOVukDR6OlRYyuR8JNMK7q/MySiMBvzApGnRzxTEnJD/zwjmsQ6TMqDF147pndnoTETaKN+8PUHUsmK2hTltp6qGiRh75Bc4dFunTTY5I=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6346c512-2a42-49ca-46eb-08d77cc429be
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Dec 2019 16:23:45.0475
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +XW79rgrmm0mt1k7JDXpoBMn5wE9bz37Vp7XmRv7vRBV44UXnXANL+BZPeyPskOmbm0d4H67w6okZ8Y7WzKK/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7SPR01MB0012
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 12/1/2019 12:52 AM, Adam Ford wrote:=0A=
> The i.MX8M Mini supports the same crypto engine as what is in=0A=
> the i.MX8MQ, but it is not currently present in the device tree,=0A=
> because it may be resricted by security features.=0A=
> =0A=
What exactly are you referring to?=0A=
=0A=
> This patch places in into the device tree and marks it as disabled,=0A=
> but anyone not restricting the CAAM with secure mode functions=0A=
> can mark it as enabled.=0A=
> =0A=
Even if - due to export control regulations - CAAM is "trimmed down",=0A=
it loses only the encryption capabilities (hashing etc. still working).=0A=
=0A=
Again, please clarify what you mean by "secure mode functions",=0A=
"security features" etc.=0A=
=0A=
Horia=0A=
