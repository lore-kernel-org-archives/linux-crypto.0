Return-Path: <SRS0=W691=QV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC7DCC43381
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Feb 2019 20:57:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6CA802080A
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Feb 2019 20:57:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="gDyJbi1m"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726858AbfBNU50 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 14 Feb 2019 15:57:26 -0500
Received: from mail-eopbgr80079.outbound.protection.outlook.com ([40.107.8.79]:16468
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726328AbfBNU50 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 14 Feb 2019 15:57:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sPvIljEMcwZ1Dp+aW1pBfsz6i+4aKzDvi3xckTpFMYY=;
 b=gDyJbi1mbeo+VZwRLT+lQstHKVPAsP6cEyUlzAmeEzPz/x4xgLfDR6ix99vc8iZEvZPsVd+xoXAqhWOzINQHz0383jzjhv1h8+/IFR7HdLN9CEG4u9FAiziErO6uwG2cKYlMexLrhCEeaNzVaGuIDjXLJO47A4PFRsf4CZPUuq0=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3598.eurprd04.prod.outlook.com (52.134.5.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1622.16; Thu, 14 Feb 2019 20:57:22 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::f51e:1692:77db:b931]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::f51e:1692:77db:b931%6]) with mapi id 15.20.1622.016; Thu, 14 Feb 2019
 20:57:22 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Iuliana Prodan <iuliana.prodan@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH 0/4] crypto: caam - add ecb mode support
Thread-Topic: [PATCH 0/4] crypto: caam - add ecb mode support
Thread-Index: AQHUv7VcNE62/1rs10eCj4efK3X83A==
Date:   Thu, 14 Feb 2019 20:57:21 +0000
Message-ID: <VI1PR0402MB3485805892E12B4D2D820AA298670@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <1549633810-10380-1-git-send-email-iuliana.prodan@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [192.88.166.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1b2fd1db-c79b-476b-b0dc-08d692bf03e7
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(4618075)(2017052603328)(7153060)(7193020);SRVR:VI1PR0402MB3598;
x-ms-traffictypediagnostic: VI1PR0402MB3598:
x-microsoft-exchange-diagnostics: =?iso-8859-2?Q?1;VI1PR0402MB3598;23:geB+v229mwQYAbiOqzGU0kbQvzL2Rz510r+jQ?=
 =?iso-8859-2?Q?qSSCI7nQPBw1TgNaCuPnN9qwEdzcsiB7TPbnzfVs5+QfWwTIyCrb+7NB1k?=
 =?iso-8859-2?Q?kwYWt6SSvBZ+xY0SYLWp7EfxZIPvBCM5ZzUiJw+qOlAUzUIH3fRuM6spe+?=
 =?iso-8859-2?Q?n0ugVUTeUA/6QvCQ4QB2kh2MpwAZNj4qm3GROP5p2D8jj3GIF9FgUUF6Bh?=
 =?iso-8859-2?Q?nfodcD6psPF99BZh47GMP6sepoBL/8Tk/GloNNjHc/1I23t+Wsf/F+R2SZ?=
 =?iso-8859-2?Q?gDCI7jnVqROzM+M6x8g1OCgnpV2YmCY2vaGBTDKy53E6TwmItNeY73QyY2?=
 =?iso-8859-2?Q?CGMf5MqeXB2MoGWTsopMid9PfozRwOlrNu7zqrv4kIZDiLqLGYYlBIz6Ji?=
 =?iso-8859-2?Q?LV18JdU/gEKvQN27n1L2g6j5VeFRm0B3iV7Up+tY3QSzOmo+rYGhNi171U?=
 =?iso-8859-2?Q?voI5+h68Mtiszqkp3gx7T22DXP/b2FpXDcTbceUlWLopvHDXm7LPO1j5Mj?=
 =?iso-8859-2?Q?EpslUjK/CqGWagisakzjwJpynT898rv3pF8FL7+YNp84pmmiA3ptJ+BAeD?=
 =?iso-8859-2?Q?+f0DHSc02710qI3usdnnoAiDMQ/jvQ4cye0aWHx0wJsJ72toHziUnYlPh/?=
 =?iso-8859-2?Q?xlm5da59A9rwqHcHrHM8UXuxS1nFeOToHhieHX0TqqaVkkntQhtlUQVSjD?=
 =?iso-8859-2?Q?j5k9YtMS4bqR8PxIxiAfkyRbHE6hQt1SaAx7TO1i64l//ATK7jBTaoaF5o?=
 =?iso-8859-2?Q?El9zuZYUKvU64c7bKDYBEOWHX0EtQBZQd52FcgjsiQZLpddzbJuki6oe1F?=
 =?iso-8859-2?Q?FWICG0PJP6qJyKvditLqJ/+fmunshkUa9DHG5hp+DBMK0eq3HZi4c1avo4?=
 =?iso-8859-2?Q?Cwltzu/7XXOCwbGbaY+a0OYbTasGw7OrEF6abgOvmDASPhCl5wnr+n8Xwd?=
 =?iso-8859-2?Q?2NNz/7tyYVjbW2HqBH3PBRFRqTfEkMGbtDuhM2GGQJSuaCJdEr9P2t8dbN?=
 =?iso-8859-2?Q?ZHQbUoARxitjbroK2JmpsxUWOgo7CyfQP91bWo2zyaxM1on2Ir9q05rfWm?=
 =?iso-8859-2?Q?/7qZOMjVHAzJokDfSQyv9yx7xLrBvn3m/KUqQxk4Fp54+6Rl0NqikxRWAA?=
 =?iso-8859-2?Q?1qElcRhAx+JrJwOrnZSKPCtzbXDB3H+0e73/c14GarI1OwuHBy9HVy+31J?=
 =?iso-8859-2?Q?O1nnajS3ksWFguju7PP06chrDbPNPM1vug1mxPAIGDPfwegLqJpSYBC+2L?=
 =?iso-8859-2?Q?MvbVS3fnNBCpGIT6pPtl9c5/v3qs6gw2f4Fmrumqw=3D=3D?=
x-microsoft-antispam-prvs: <VI1PR0402MB3598953AA24BDE6A4579D28F98670@VI1PR0402MB3598.eurprd04.prod.outlook.com>
x-forefront-prvs: 09480768F8
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(396003)(39860400002)(366004)(136003)(376002)(189003)(199004)(99286004)(305945005)(6436002)(53546011)(6506007)(229853002)(102836004)(105586002)(7736002)(71190400001)(33656002)(2906002)(71200400001)(26005)(478600001)(55016002)(7696005)(86362001)(76176011)(53936002)(6636002)(3846002)(9686003)(14454004)(558084003)(6116002)(74316002)(476003)(25786009)(486006)(66066001)(68736007)(81156014)(8676002)(81166006)(44832011)(316002)(110136005)(8936002)(6246003)(256004)(186003)(97736004)(4326008)(54906003)(446003)(106356001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3598;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: F9kovUFWd5o7NlF7q/hmplLBsjdVUGWdnujBa9dBUCokNqoN5x140LbnQr0ikHbhn6DyvFmNXxrthKsQY46mR2p4SQQJqGXZRZ7n90rIlMtNP/V05falVRdxBJYJZRf6UrauuzAqPjC5zzuC/0bR/kiHUnZZTJYpeQM0icZBdLF9K7phQhBVipAh8W14KvZFeFJGjH+fmuBf7vOVnb7q4uK8ON9Yj/9SNVKeu78vY+3UHaBZYzRRFvkjwEaAUcumWXF5Zm0/7hZLch6enoMgbbx918UzsrXvU0fwiONVWVyHnJA3bt7Dkw5Dt5WKbDhlOIWzByxOpcah6hqzwVCh3ki6tVg2ArUFnc5NeqbGgq5D3DKMoLyjVEnPtxPbs6LrsLou9jmV0DU4gUZmBckWXieHhe9CyZfg5pmx3VlwxUA=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b2fd1db-c79b-476b-b0dc-08d692bf03e7
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Feb 2019 20:57:21.9807
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3598
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2/8/2019 3:51 PM, Iuliana Prodan wrote:=0A=
> This patch set adds ecb mode support for aes, des, 3des and arc4 ciphers.=
=0A=
> skcipher implementation is reused, making sure to handle the no IV case.=
=0A=
> =0A=
For the series:=0A=
Reviewed-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
=0A=
Thanks,=0A=
Horia=0A=
