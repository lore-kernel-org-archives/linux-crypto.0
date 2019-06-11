Return-Path: <SRS0=vn8P=UK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C051C4321B
	for <linux-crypto@archiver.kernel.org>; Tue, 11 Jun 2019 09:56:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6070E212F5
	for <linux-crypto@archiver.kernel.org>; Tue, 11 Jun 2019 09:56:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="d6W435il"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729018AbfFKJ4p (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 11 Jun 2019 05:56:45 -0400
Received: from mail-eopbgr80077.outbound.protection.outlook.com ([40.107.8.77]:1856
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727726AbfFKJ4p (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 11 Jun 2019 05:56:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P2+iRFvcKX/B0Fgo8rl2Va9Wr5wecC2g8skImnvvOt4=;
 b=d6W435ilLK7PLGLjYDS65kjb9XWAWxAHO/05QG3z/K6WUnla3HS1p8YmhKuYy8XqN5MpO0Gr+vM5Y2JanNOk2Dy4OQeCdFLvKHPM+rTxjnlrHLgJ9SXaScnh2UB3g1OlVhFSOwLnO4mFFhE7olIqKc9A88WZ+jHZRm5uSIHz4Ik=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3677.eurprd04.prod.outlook.com (52.134.15.19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.15; Tue, 11 Jun 2019 09:56:41 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::ccaf:f4a1:704a:e745]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::ccaf:f4a1:704a:e745%4]) with mapi id 15.20.1965.017; Tue, 11 Jun 2019
 09:56:41 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     Chris Spencer <christopher.spencer@sea.co.uk>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Cory Tusar <cory.tusar@zii.aero>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Abel Vesa <abel.vesa@nxp.com>,
        dl-linux-imx <linux-imx@nxp.com>,
        "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>
Subject: Re: [PATCH v2 1/4] crypto: caam - do not initialise clocks on the
 i.MX8
Thread-Topic: [PATCH v2 1/4] crypto: caam - do not initialise clocks on the
 i.MX8
Thread-Index: AQHVHWwGsMxFSBPcUUWzlXHZD6TwyA==
Date:   Tue, 11 Jun 2019 09:56:40 +0000
Message-ID: <VI1PR0402MB34855AC8C617A3D7A584A1B798ED0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20190607200225.21419-1-andrew.smirnov@gmail.com>
 <20190607200225.21419-2-andrew.smirnov@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1e8d4328-fb86-46c4-d806-08d6ee531a5d
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3677;
x-ms-traffictypediagnostic: VI1PR0402MB3677:
x-microsoft-antispam-prvs: <VI1PR0402MB3677CB501F7CA9E8DBD6238098ED0@VI1PR0402MB3677.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 006546F32A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(366004)(39860400002)(346002)(396003)(136003)(189003)(199004)(4744005)(66066001)(3846002)(4326008)(52536014)(2906002)(74316002)(81156014)(6116002)(71200400001)(81166006)(71190400001)(8936002)(305945005)(55016002)(229853002)(7736002)(8676002)(478600001)(14454004)(2501003)(6436002)(66476007)(110136005)(66446008)(66556008)(476003)(53936002)(5660300002)(64756008)(316002)(102836004)(25786009)(54906003)(9686003)(76116006)(86362001)(66946007)(256004)(446003)(73956011)(53546011)(68736007)(76176011)(6246003)(33656002)(26005)(186003)(7696005)(6506007)(486006)(99286004)(44832011);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3677;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 4uFTjBb6zhrXMfmPlFhHOYmNtCiQlApNIOx70ctP1hwMNDQ67bZ+/atSKi20MNYngJ5dBvxqUUaQT4erMpdgwQN3I4kPZIMBXRcnQQY/El7bahjEJiTHxzyYHyHkQsJPlKn/5B8O/XDjaAejlQ1aHbIPF0v0mGPiYnsTz3L+PlK1YRW3kvXkQ9fnWubkTPlQ6i+tiRKelx+BghBpz+XD4dnbjIed2iVODQQ8bX4sWkP5bUyIYGD0cFAxQqHD00lhn79Ol3u2iSc0XPci6VS/7LevdcoZxoCFawBdJBHdOcN3vuQfqHSqTx3OiAtbQnDAta2739fWAolNnA0EECRO5PbzjkhGmqC71nruW33bw2Eou21L7eZfV79CFtfk4jg42DVw3olSD5pDLCBvSw4VZRpgR343ejwtvoVaLzGwDoE=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e8d4328-fb86-46c4-d806-08d6ee531a5d
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jun 2019 09:56:40.9638
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: horia.geanta@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3677
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 6/7/2019 11:03 PM, Andrey Smirnov wrote:=0A=
> From: Chris Spencer <christopher.spencer@sea.co.uk>=0A=
> =0A=
> There are no clocks that the CAAM driver needs to initialise on the=0A=
> i.MX8.=0A=
> =0A=
RM lists 5 clocks for CAAM module (instance.clock): caam.aclk, caam.ipg_clk=
,=0A=
caam.ipg_clk_s, caam_exsc.aclk_exsc, caam_mem.clk=0A=
				=0A=
Wouldn't it be better to have these clocks in DT, instead of relying that t=
heir=0A=
root clocks (ccm_ahb_clk_root, ccm_ipg_clk_root) are critical / always on?=
=0A=
=0A=
Thanks,=0A=
Horia=0A=
=0A=
