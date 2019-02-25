Return-Path: <SRS0=IhKu=RA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F555C43381
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Feb 2019 14:03:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E3AFA20663
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Feb 2019 14:03:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="j7Etmqfy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726669AbfBYODa (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 25 Feb 2019 09:03:30 -0500
Received: from mail-eopbgr50083.outbound.protection.outlook.com ([40.107.5.83]:35545
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726623AbfBYODa (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 Feb 2019 09:03:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GOccdN/eyIjoRVi9y5wuBz+sQBLSranOS/qB/dD1FmM=;
 b=j7EtmqfyM/3KTWNdyeut4EZif2Pepbw9ncG054EeSSAscjlXOBWMEsa9g0fyh/ZY/QlUFMYSPTLTNrQdDCt8kW7dbkAk/zmn10EtPaYxkT36LcxjeoFOSjJ8ub1Q1yuL4BR3pa3ScQiSpN6fQlDdw2Quq9mzrH7OjbyVK6dO2CY=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3598.eurprd04.prod.outlook.com (52.134.5.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1643.15; Mon, 25 Feb 2019 14:03:26 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::a49a:622c:f0f3:938e]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::a49a:622c:f0f3:938e%3]) with mapi id 15.20.1643.019; Mon, 25 Feb 2019
 14:03:26 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     "spencercw@gmail.com" <spencercw@gmail.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Chris Spencer <christopher.spencer@sea.co.uk>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [RFC 0/4] crypto: caam - Add i.MX8MQ support
Thread-Topic: [RFC 0/4] crypto: caam - Add i.MX8MQ support
Thread-Index: AQHUypZp75tEw9Td+kSfo3uYz5U/QA==
Date:   Mon, 25 Feb 2019 14:03:26 +0000
Message-ID: <VI1PR0402MB348578FE91831D11CDCC91D5987A0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20190222100613.2290-1-christopher.spencer@sea.co.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [86.34.165.90]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2d6f98c8-d5cf-489d-5feb-08d69b2a0360
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(4618075)(2017052603328)(7153060)(7193020);SRVR:VI1PR0402MB3598;
x-ms-traffictypediagnostic: VI1PR0402MB3598:
x-microsoft-exchange-diagnostics: =?us-ascii?Q?1;VI1PR0402MB3598;23:vUh2QG2KCLMY1HzANocoevtzf/z5MjVFGIBJBIL?=
 =?us-ascii?Q?ttLi/u1JjeAb5uAHFx4spqulIE45tTSQBD9s8pOzchF3qIL8hoA8suszK1Iu?=
 =?us-ascii?Q?qJhg7XPQfbnFYoCPsNjugBVwjGDJrMgYJpdgs3XuULmRtSp5RMLDIJVuhLwo?=
 =?us-ascii?Q?MhfZ7Udrzilh87+VUywjMaVvRQtkhk4I0IAksXzbm8qyGQSXwvdUuY0/0cxq?=
 =?us-ascii?Q?Iohs8W9A29sPmWwq87Iiap1NBCpiE2MOdUAX/m8vhHSAaPziOiiSAwzahp8L?=
 =?us-ascii?Q?Zm4uGtkcBKcKnrRN2z3ActA6S9jpybXWcD9SOyjzH9ntyoNEVGrE5xNUT3QY?=
 =?us-ascii?Q?EgJoo4L7QaMLjnJiSjq7Pgcc8qYdd4shv2FDxKOI/WAtG2YPbiHk1A6+l1Zc?=
 =?us-ascii?Q?FTVlStCtqL91l98ZFJzMrP7Kmq/lAexgjXxGAsKrsnuyNTb1Rqvjacf3xLlo?=
 =?us-ascii?Q?ElczmfFTXFGVo9eY455V6/Z/u/+4gmk1b+YIawasuOGOClfntKX/RVwJIinc?=
 =?us-ascii?Q?KgbxppzSeEl9UNStVKArxhiu5pLR+mK3IM1oC4oF82yEE1+cLHZqJnGMukGE?=
 =?us-ascii?Q?jchHzrqkRkJKA7biqS0RkD4S02FV/Nz2kNjEn0GZCe7QisuzbsL0pd74oYn0?=
 =?us-ascii?Q?LUwPu4Mo4AMwyqtPGKtGDD/ppzzuyn2OQkesl/Oxyt2hQwseOKEmUGKy69n9?=
 =?us-ascii?Q?Fe9cbPBErsAshDHIiFQtI98scHKRNAc6BEHdxXegM8jkC7aGD2whmnzUDK+W?=
 =?us-ascii?Q?bopRNDXWnTMoAsQggysPnRsYxz7HdUcbI+mQaUGsKtI4vdGUhCwDbEaCBuZD?=
 =?us-ascii?Q?gts4MnIhKj0J+iadwo+tewrPcbAzFR3WQxFiVWFZ7bx3Po4lF6zgKKyEq6vy?=
 =?us-ascii?Q?KlGmJ3jv/fs/lzDpcsbTPvOhbnIAH0XEnqQ3qeSQ9n4OdnvJ2UkmnE4YVzqL?=
 =?us-ascii?Q?Ns7s713x/I7Y0NnPf3eh/H/zjGrNHgBQnN+XaYEQraghi7hEaQWO2vzKR2ru?=
 =?us-ascii?Q?EmhF48LVpWJd5C23ZABhD/EtnutcRUFGN9k3wVo3KqvnX9z1s1+Z+WteDu8G?=
 =?us-ascii?Q?fTE+8ohve7qrrhLzLTQAafor01s7X0UsR95jr8IdTE70OK5bPUSVgI+5JhSS?=
 =?us-ascii?Q?dr1kXCkm3N/kasuGbspvb1V1UrpPcIGB113q7YTKcP4YyRLam15VAEHFlzp+?=
 =?us-ascii?Q?3pVxK3LBDVKmkSgEnr9ofHx7sMfMy2/B5SgCtsJQptyNvZAM8+hOc1VqEy8k?=
 =?us-ascii?Q?YClH70r/TVzhDjvlP7U9Vr3k3mvJXd1SsW9k3YemWlx2SCZP0gH6MGTRFJu8?=
 =?us-ascii?Q?x4Q=3D=3D?=
x-microsoft-antispam-prvs: <VI1PR0402MB359840FF50C6DD9C10DF1A04987A0@VI1PR0402MB3598.eurprd04.prod.outlook.com>
x-forefront-prvs: 095972DF2F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(396003)(136003)(366004)(346002)(376002)(199004)(189003)(6246003)(486006)(105586002)(74316002)(44832011)(66066001)(53936002)(76176011)(2501003)(446003)(4326008)(33656002)(14454004)(4744005)(8936002)(476003)(9686003)(99286004)(55016002)(106356001)(7696005)(478600001)(2906002)(6436002)(3846002)(6636002)(86362001)(53546011)(6116002)(97736004)(6506007)(71190400001)(26005)(71200400001)(68736007)(102836004)(186003)(81166006)(8676002)(54906003)(5660300002)(110136005)(256004)(81156014)(7736002)(25786009)(305945005)(229853002)(316002)(52536013);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3598;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: BaOvhFXKBWsRfYJmFWDwz+0d7YqrTJ4HIv9lbphyojtbI2jeIIODs+Kjjfy/RpWIM3ZxIb8t+tOyhfHXt3JM3oTZY/mVMI+gIFDMkojO+WG7reW1tWvqDlOf2qhoIVglP6CSbDZQ4n2bj5ZG5WV0lb2BtFFGvQFjVE5EgLL3zEBTI6NSwm7XhqWdbaMLnnylAp4btxdvZoxHeE0hCLoNYjoiwMgOXp7c5C+OazslY/UJVsB0VnrSs2di89RN3GZzfXaJA+nGZskpp2tviJ7DyOoMBBJl0p83C3WEPCsmTeXR3N0NG8u5nRYSz8AqZQWJJ1wqWUm3HXP/DKjwTJC1xPe7Y8o+Pt04MLbVfmaWDIR2BRLZKF+ZihQ0No+EwiYqs3OeJ/iVFDH/fh/9Yrd/CMp4aDOAn8JvP+QNbxXLuAY=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d6f98c8-d5cf-489d-5feb-08d69b2a0360
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Feb 2019 14:03:26.5632
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3598
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2/22/2019 12:07 PM, spencercw@gmail.com wrote:=0A=
> From: Chris Spencer <christopher.spencer@sea.co.uk>=0A=
> =0A=
> This patch series adds support for the i.MX8MQ to the CAAM driver. This=
=0A=
> is mostly adapted from corresponding changes in the NXP repo. The=0A=
> patches are based on v5.0-rc7.=0A=
> =0A=
The code looks *very* similar to what was developed by NXP.=0A=
Why have you stripped off the S-O-Bs?=0A=
=0A=
Horia=0A=
