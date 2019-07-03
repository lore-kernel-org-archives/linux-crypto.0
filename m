Return-Path: <SRS0=EZcf=VA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F8B6C0650E
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jul 2019 13:51:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 40D5221850
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jul 2019 13:51:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="F7bhBp4b"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725944AbfGCNvV (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 3 Jul 2019 09:51:21 -0400
Received: from mail-eopbgr00044.outbound.protection.outlook.com ([40.107.0.44]:61006
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725943AbfGCNvV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Jul 2019 09:51:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s2mSe+b7wNO0CxfTOhQmarb46NeTm9G0eXlk4fgdyJw=;
 b=F7bhBp4bFQ8SYcXqjaaqdDn0waaPkaoGlsgZ5I4hEzAOkjSejUf2APksWv2cmc5v59YncOjT+Y2A3nmuDbWm1QqM8joV7L8fPLKlRYZ0t4M36dYMxGuwJVL0VyUafRnEi6UEqSm85urK4GiW88ddJDDvYUUJiLTRT7P/mlljORE=
Received: from VI1PR04MB5055.eurprd04.prod.outlook.com (20.177.50.140) by
 VI1PR04MB5648.eurprd04.prod.outlook.com (20.178.125.221) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2032.20; Wed, 3 Jul 2019 13:51:17 +0000
Received: from VI1PR04MB5055.eurprd04.prod.outlook.com
 ([fe80::d83:14c4:dedb:213b]) by VI1PR04MB5055.eurprd04.prod.outlook.com
 ([fe80::d83:14c4:dedb:213b%5]) with mapi id 15.20.2032.019; Wed, 3 Jul 2019
 13:51:17 +0000
From:   Leonard Crestez <leonard.crestez@nxp.com>
To:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        Horia Geanta <horia.geanta@nxp.com>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Chris Spencer <christopher.spencer@sea.co.uk>,
        Cory Tusar <cory.tusar@zii.aero>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 03/16] crypto: caam - move tasklet_init() call down
Thread-Topic: [PATCH v4 03/16] crypto: caam - move tasklet_init() call down
Thread-Index: AQHVMXdGY7YVraimN0KG3E6/ZzGQWw==
Date:   Wed, 3 Jul 2019 13:51:16 +0000
Message-ID: <VI1PR04MB505565EC5520F4820E234A84EEFB0@VI1PR04MB5055.eurprd04.prod.outlook.com>
References: <20190703081327.17505-1-andrew.smirnov@gmail.com>
 <20190703081327.17505-4-andrew.smirnov@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=leonard.crestez@nxp.com; 
x-originating-ip: [82.144.34.2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: af6df985-4c44-418b-1098-08d6ffbd8558
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR04MB5648;
x-ms-traffictypediagnostic: VI1PR04MB5648:
x-microsoft-antispam-prvs: <VI1PR04MB5648129F53E1527C61D555E1EEFB0@VI1PR04MB5648.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-forefront-prvs: 00872B689F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(39860400002)(366004)(376002)(136003)(396003)(199004)(189003)(478600001)(76176011)(25786009)(7696005)(110136005)(99286004)(5660300002)(9686003)(102836004)(54906003)(229853002)(6506007)(68736007)(66556008)(91956017)(64756008)(6436002)(73956011)(52536014)(66476007)(66946007)(6636002)(53546011)(316002)(26005)(66446008)(76116006)(6246003)(486006)(446003)(74316002)(4326008)(86362001)(8676002)(7736002)(44832011)(66066001)(33656002)(2906002)(81166006)(81156014)(14454004)(14444005)(6116002)(3846002)(476003)(8936002)(71190400001)(71200400001)(186003)(53936002)(305945005)(256004)(55016002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB5648;H:VI1PR04MB5055.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Ih9HYL9NM9JlmsOPztgTiLh9CwOYwEjRXbns49LkcUn+BdSsxzV3HZYGmXjm8ON9fEw9l/myTWzGqLw7IMPK53OC1uGXu9U+kZVoCoy4iRDmmrviy0DrZ7//TsckHNyXhGMtqo6hZOR74nOZngBrRPmCee55vfmG0zRgxpA0ebzyTdLtPrREkNemWs2sewecTbIzKl7JySXGGQ2Yv7mQu4qHwTOPR1nryMzvR2Xen00f4z+8DasMBt1shmx4f7ryitqrnlI2+q3P5FQIvO7MFrZ4r/nLseQII9eaTzCuOKmNUbRrvDm7/xJd3b4qMpZhE19lZ+06b8o3cIz094e/xjJXPFZEut/hxnsG+BlPZwRp8kF3ZsRHyxLJpugbKEtKWzqdRAWNiBqsX3wvNMHcn/tT4b2dSdd4U6TzmP0/5Is=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af6df985-4c44-418b-1098-08d6ffbd8558
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jul 2019 13:51:16.8687
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: leonard.crestez@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5648
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 7/3/2019 11:14 AM, Andrey Smirnov wrote:=0A=
> Move tasklet_init() call further down in order to simplify error path=0A=
> cleanup. No functional change intended.=0A=
> =0A=
> diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c=0A=
> index 4b25b2fa3d02..a7ca2bbe243f 100644=0A=
> --- a/drivers/crypto/caam/jr.c=0A=
> +++ b/drivers/crypto/caam/jr.c=0A=
> @@ -441,15 +441,13 @@ static int caam_jr_init(struct device *dev)=0A=
>   =0A=
>   	jrp =3D dev_get_drvdata(dev);=0A=
>   =0A=
> -	tasklet_init(&jrp->irqtask, caam_jr_dequeue, (unsigned long)dev);=0A=
> -=0A=
>   	/* Connect job ring interrupt handler. */=0A=
>   	error =3D request_irq(jrp->irq, caam_jr_interrupt, IRQF_SHARED,=0A=
>   			    dev_name(dev), dev);=0A=
>   	if (error) {=0A=
>   		dev_err(dev, "can't connect JobR %d interrupt (%d)\n",=0A=
>   			jrp->ridx, jrp->irq);=0A=
> -		goto out_kill_deq;=0A=
> +		return error;=0A=
>   	}=0A=
=0A=
The caam_jr_interrupt handler can schedule the tasklet so it makes sense =
=0A=
to have it be initialized ahead of request_irq. In theory it's possible =0A=
for an interrupt to be triggered immediately when request_irq is called.=0A=
=0A=
I'm not very familiar with the CAAM ip, can you ensure no interrupts are =
=0A=
pending in HW at probe time? The "no functional change" part is not obvious=
.=0A=
=0A=
--=0A=
Regards,=0A=
Leonard=0A=
