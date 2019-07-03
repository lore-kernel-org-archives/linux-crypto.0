Return-Path: <SRS0=EZcf=VA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A77C9C0650E
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jul 2019 13:54:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7C78D218A3
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jul 2019 13:54:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="BHBR0Hx+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725944AbfGCNyJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 3 Jul 2019 09:54:09 -0400
Received: from mail-eopbgr80085.outbound.protection.outlook.com ([40.107.8.85]:35716
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726255AbfGCNyI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Jul 2019 09:54:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ghtVbsMHPGtBZ95j3U48EUaMVh20TgmVWugutbpb8bg=;
 b=BHBR0Hx+HMQOE23oXN+uv5bkVxdqQ1LB5utBLo70lUO0tXpeu7ATtFD4BzO2Dr7Qa+XiaxQfBhBWkJTP+5zU95qh9SdSfeDPwmT49deavYHcWtwmLmLKxmi7sW/d7qrZ0PPvpz3joSa/ZwFkKatAw3MsxzObpV/+ZigELMSR6ag=
Received: from VI1PR04MB5055.eurprd04.prod.outlook.com (20.177.50.140) by
 VI1PR04MB3006.eurprd04.prod.outlook.com (10.170.228.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2032.20; Wed, 3 Jul 2019 13:54:05 +0000
Received: from VI1PR04MB5055.eurprd04.prod.outlook.com
 ([fe80::d83:14c4:dedb:213b]) by VI1PR04MB5055.eurprd04.prod.outlook.com
 ([fe80::d83:14c4:dedb:213b%5]) with mapi id 15.20.2032.019; Wed, 3 Jul 2019
 13:54:05 +0000
From:   Leonard Crestez <leonard.crestez@nxp.com>
To:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Horia Geanta <horia.geanta@nxp.com>
CC:     Chris Spencer <christopher.spencer@sea.co.uk>,
        Cory Tusar <cory.tusar@zii.aero>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 02/16] crypto: caam - simplify clock initialization
Thread-Topic: [PATCH v4 02/16] crypto: caam - simplify clock initialization
Thread-Index: AQHVMXdIXfeYpJiLM0ubBrQgfG+rsA==
Date:   Wed, 3 Jul 2019 13:54:05 +0000
Message-ID: <VI1PR04MB5055EFBE9ED3AB87BBA8096AEEFB0@VI1PR04MB5055.eurprd04.prod.outlook.com>
References: <20190703081327.17505-1-andrew.smirnov@gmail.com>
 <20190703081327.17505-3-andrew.smirnov@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=leonard.crestez@nxp.com; 
x-originating-ip: [82.144.34.2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1cad2871-6e01-496c-6319-08d6ffbde9c3
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR04MB3006;
x-ms-traffictypediagnostic: VI1PR04MB3006:
x-microsoft-antispam-prvs: <VI1PR04MB30069ECF4BEDA23F935AF8A9EEFB0@VI1PR04MB3006.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:264;
x-forefront-prvs: 00872B689F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(39860400002)(346002)(396003)(366004)(189003)(199004)(229853002)(186003)(6506007)(102836004)(26005)(5660300002)(256004)(76176011)(7696005)(54906003)(4744005)(99286004)(74316002)(6436002)(53546011)(9686003)(110136005)(68736007)(7736002)(6116002)(2906002)(305945005)(8936002)(4326008)(3846002)(2501003)(33656002)(446003)(8676002)(81166006)(86362001)(53936002)(6246003)(64756008)(66446008)(66556008)(66476007)(66946007)(44832011)(316002)(66066001)(6636002)(55016002)(81156014)(25786009)(71200400001)(71190400001)(73956011)(52536014)(486006)(478600001)(76116006)(91956017)(476003)(14454004);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB3006;H:VI1PR04MB5055.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: /AqH5Q5N5qFnqneVIgTi/DrvTzZ4xubtWIwra+4Hp+wq2wwl5vSc0hNaG6wJveVZqFRXOQhPw39HEy27+HC2tej+Cg/KgTIBfB2eZyQNVMOipxEbKbHDNomeCeJBEEZjBs6CdkspXYI352GFriC9YaETETxxERiVbshHDWPMYM0Y/jCMdiduT78//G7oto4cwLW14eP4USWLL4sTD+29wIH6qZVn0wcQz7lkf/6y/LIU1LvoQfq+17AoYt5fwZtZCH7xEXy9plXhKUrQuc7Lqe1aUCYw+tiX66frWQLY1oJW7jwwJcl++HqVZaOJ2mKZTFXLtIADy0vkkDdoPjrUvJAGWDxz/TPJvtvi0yHoSjaEZlj0pkPFt8I0aSw3YbMHCOIoU2spo5wuluqhvg2kiLHuR8gG0Sd+oBpf552IZVg=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1cad2871-6e01-496c-6319-08d6ffbde9c3
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jul 2019 13:54:05.3962
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: leonard.crestez@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3006
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 7/3/2019 11:14 AM, Andrey Smirnov wrote:=0A=
> Simplify clock initialization code by converting it to use clk-bulk,=0A=
> devres and soc_device_match() match table. No functional change=0A=
> intended.=0A=
> =0A=
> Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>=0A=
=0A=
Reviewed-by: Leonard Crestez <leonard.crestez@nxp.com>=0A=
=0A=
This data-driven approach is much easier to understand.=0A=
