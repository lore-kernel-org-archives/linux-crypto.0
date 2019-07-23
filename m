Return-Path: <SRS0=XUD9=VU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFB92C7618B
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Jul 2019 15:48:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9A02B2239F
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Jul 2019 15:48:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="MBrM7vj9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731557AbfGWPsd (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 23 Jul 2019 11:48:33 -0400
Received: from mail-eopbgr30073.outbound.protection.outlook.com ([40.107.3.73]:28732
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729331AbfGWPsd (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 23 Jul 2019 11:48:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tkpl6P6OeRWX1fOapEC4N101o2Ca2vtSfx2LPBjRhYnQ63OD5w12c2l7lw90w74GWY75M5sDrJeqt61pem1PQDBXounBjTwZrozBXt3C0Ii7YV3NYvZFrqB9wbIk+lzRX1+I8YyXcJyglytE4BTIAuWhAuMDFMMNDlpou1B+k0wCpwG7GACv4RYBTqebwoRYXbwsncb6bcODEop+GbjUhbcFKGgvHE4g+ePNBJTzeJ1PWlFcBxkzOtPHWeKbCIhFBhG4lCQo2sXujGCr6Oxl5MN/5wZ4KXl8lgITsnf2IKIuUI1dQziPqyj7fWlSUHXsH7Ch2ykl3fH1YsZiyoBU2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/D5mnu6SKJcynWkYkxZJGkJvB0EWVXoXHrd0SKK7yQ4=;
 b=jV5dZrbMW1zYxv+r3bCJKHT5xO1WZDO+3z+gsy2cQLOVEZWIJ4n2ZenHfts2fDULC2NOZ1DLgP8wuX3LCSLHg8N7/cT+3V9s9Mq/CG4yWqeEAXV80RBj5aHx5k0c4kFdA/mz5Ihrl59qwO9jm9UYI3fC8W3KJNXU073KdurMKK1A2U1vjC9R+vyHqDrM4ErPv/cJ4LGI/OluPTdvOu4AdAYZGaki5y6Lmo9sAU/G5e0B45g/sW7OeEN3J/EYHswLlo8MpguixQ2ciHnCguN3/m1WQj0MpoikYzG2O3W5qFr+hMByzchIEh+jRzj7e7ftUg7+eZdccQLmvILtaMVc/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=nxp.com;dmarc=pass action=none header.from=nxp.com;dkim=pass
 header.d=nxp.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/D5mnu6SKJcynWkYkxZJGkJvB0EWVXoXHrd0SKK7yQ4=;
 b=MBrM7vj9Ab5zSi128L51Z4lA0SMkHmyp6TjSxra25Xi+HFWNvAE8qpHlDJYEziWzgYC93tucqXtNP3j8RmY92z9I5h0Lh2XPTjMq6hCkuUPRLwsoH44oi5Dqx8BhdnTEqiNsSHPVALjb3VSZK14xACzGNtDsJXUlvzktZQbFvuk=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3533.eurprd04.prod.outlook.com (52.134.4.26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.14; Tue, 23 Jul 2019 15:48:29 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::7c64:5296:4607:e10]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::7c64:5296:4607:e10%5]) with mapi id 15.20.2094.017; Tue, 23 Jul 2019
 15:48:29 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     Cory Tusar <cory.tusar@zii.aero>, Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 03/14] crypto: caam - convert caam_jr_init() to use
 devres
Thread-Topic: [PATCH v6 03/14] crypto: caam - convert caam_jr_init() to use
 devres
Thread-Index: AQHVPLPcUxrnBEKL8kyOLFbxAefUTw==
Date:   Tue, 23 Jul 2019 15:48:29 +0000
Message-ID: <VI1PR0402MB34856895D579E44278DEDECE98C70@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20190717152458.22337-1-andrew.smirnov@gmail.com>
 <20190717152458.22337-4-andrew.smirnov@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [78.96.98.22]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 58d6c5c3-560e-436c-56f9-08d70f853562
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3533;
x-ms-traffictypediagnostic: VI1PR0402MB3533:
x-microsoft-antispam-prvs: <VI1PR0402MB3533F9A477FF21A6233BDF7D98C70@VI1PR0402MB3533.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 0107098B6C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(346002)(39860400002)(396003)(366004)(189003)(199004)(71190400001)(99286004)(44832011)(486006)(71200400001)(53936002)(4326008)(86362001)(6246003)(8936002)(81166006)(316002)(54906003)(110136005)(256004)(5660300002)(81156014)(4744005)(476003)(76116006)(66476007)(91956017)(66946007)(229853002)(446003)(66556008)(66446008)(64756008)(9686003)(55016002)(14454004)(6116002)(6436002)(7736002)(52536014)(2906002)(74316002)(3846002)(66066001)(186003)(25786009)(6506007)(478600001)(7696005)(76176011)(68736007)(53546011)(102836004)(8676002)(2501003)(33656002)(26005)(305945005);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3533;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: sonGvmc0OvyYccb7vAZWXameoeixS/8HSDnwxPm9B3Gk3HzxRtILV9rJUW1A0VWiiDB4oCYFTJf6cVqjgpQhMZ1MUCiv2ImAKV9KjqcX8dzAhle1hG8/z1CpnF1qUK+o+MBT+yQIeal5MQbxrQjCA+GslTpf2LFCemTTcxaHD2hu8EnqC5hioHoZEqYYkDXjNG0gOV8CPm3NACUvCFd5oCcTLvtTMD7ubzvyUa1aVL5/2Tbqpu/cDpRuyJXWaJ8QO2V6TSarvkkSwHW/8zdlFDnIgDK9BYuzSw+Xvu/D1EgW3TibAlTWQApgjspnBeqdcGMkAR/DJSU9jIGjaS2ktbBtYqFcsqP2LwT1OaTvrKWuh/p5bFCowWQ0zHcTjqNnyNbLVOu7nep9zTc5OXNDSvLjrbz1OKh1ASr9eYywSJw=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58d6c5c3-560e-436c-56f9-08d70f853562
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2019 15:48:29.5469
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: horia.geanta@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3533
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 7/17/2019 6:25 PM, Andrey Smirnov wrote:=0A=
> Use deveres to allocate all of the resources in caam_jr_init() (DMA=0A=
> coherent and regular memory, IRQs) drop calls to corresponding=0A=
> deallocation routines. No functional change intended.=0A=
> =0A=
> Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>=0A=
Reviewed-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
=0A=
Thanks,=0A=
Horia=0A=
