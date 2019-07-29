Return-Path: <SRS0=zv6R=V2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B33EBC7618E
	for <linux-crypto@archiver.kernel.org>; Mon, 29 Jul 2019 15:29:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 832B7216C8
	for <linux-crypto@archiver.kernel.org>; Mon, 29 Jul 2019 15:29:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="svYMTYg4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388058AbfG2P3o (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 29 Jul 2019 11:29:44 -0400
Received: from mail-eopbgr70080.outbound.protection.outlook.com ([40.107.7.80]:10451
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387854AbfG2P3m (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 29 Jul 2019 11:29:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VL7zQWWddgOmQJw13s9iu4Aq1TejNfiDTQuBhO/ISASuzKHq8k9K4FxfaLZtghhp7Q1kF3RQYKINMhB5PknOx7EHDfl4KpdHlHeEfUQfsaU9ctK3pUxN9evxBU8XS2VEYpUtrbJjznOGCuGT7GO9/zS8bKfcAN7tiKMK+YS9W8yf0ABxFSu5JgB6EJ23Zjgj0M0fmKSPXRzY2Wg1UZUUIv9JXnPk0TGqakwXe5D9eD+2OElqUqMNqrKrINmOuYL4kxh97t/+17pvNbWz3CohFS5e5MNd0D98kDjzOCk1pzQNqO36jE0Sj6NXW3GCwa7oPWhX3x8EP1cePJQVZlN+RQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HSZSVZWilgBQX88P0WqXdqHiSal/rNN+OHJljliFfXk=;
 b=Kn86z2IAk+LEIs+sIhrB8Mk8jHfKCJEioFgKGyifYiAaX2qUzmCOj/OJTZeTMq7a8lzoK40KjQQ1Dvk80n+4ay2NkU0FiWDoH8NHtfKv39ZjczaU8worQJ7TiHVEvsu+8bjFwy/c0ND2031aRWebjPtgYIpSy+bZPF+9JB0fyt2KtMjcuc0ZTOJ/5nqmxaF7MYCXemQwoyRTbGRgu66bVj6fTvsF6b1W0eLGD9t8R/sUuyeAxX8mGYNzUg8FK5WU+xOo270siWgli0W3UvHnh6Mr8jT5E1R4ubEIA0wPh/3Zhoe8KgjHt70KAyDXh1FGpPG7lV5KY+YDev0JH+PJtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=nxp.com;dmarc=pass action=none header.from=nxp.com;dkim=pass
 header.d=nxp.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HSZSVZWilgBQX88P0WqXdqHiSal/rNN+OHJljliFfXk=;
 b=svYMTYg4R8lps5v+8L7hX1vvVn2rGQKlFAKjltT3KC+QT6IfPUdPsoTIFZ7m1oZam3Z0lWNE73fWGnOU9+83fYcHzUW6K2uTydjrtKeWpW5Py0O0gvVCPm939MzNO7Jfk/qPwlLiFnHLSDaFqimVVqpbv76Kl71JQlHI37Wpevk=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3343.eurprd04.prod.outlook.com (52.134.8.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.13; Mon, 29 Jul 2019 15:29:36 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::7c64:5296:4607:e10]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::7c64:5296:4607:e10%5]) with mapi id 15.20.2094.017; Mon, 29 Jul 2019
 15:29:36 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     Chris Spencer <christopher.spencer@sea.co.uk>,
        Cory Tusar <cory.tusar@zii.aero>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Leonard Crestez <leonard.crestez@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH v6 05/14] crytpo: caam - make use of iowrite64*_hi_lo in
 wr_reg64
Thread-Topic: [PATCH v6 05/14] crytpo: caam - make use of iowrite64*_hi_lo in
 wr_reg64
Thread-Index: AQHVPLPZuXz6nKwNWUa1sVwtAoTZEA==
Date:   Mon, 29 Jul 2019 15:29:36 +0000
Message-ID: <VI1PR0402MB3485A34CA7FE29F53D3C273298DD0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20190717152458.22337-1-andrew.smirnov@gmail.com>
 <20190717152458.22337-6-andrew.smirnov@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: decbe59b-f0bc-487f-c41b-08d714399049
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3343;
x-ms-traffictypediagnostic: VI1PR0402MB3343:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <VI1PR0402MB334365C316297C39A9926DE898DD0@VI1PR0402MB3343.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 01136D2D90
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(39860400002)(136003)(366004)(346002)(396003)(199004)(189003)(476003)(14444005)(229853002)(8676002)(6506007)(25786009)(44832011)(53546011)(6116002)(55016002)(53936002)(316002)(81156014)(2501003)(486006)(3846002)(6306002)(478600001)(45080400002)(102836004)(186003)(76176011)(81166006)(446003)(6246003)(8936002)(7696005)(71190400001)(26005)(71200400001)(99286004)(4326008)(9686003)(66066001)(14454004)(52536014)(86362001)(74316002)(68736007)(7736002)(54906003)(6436002)(110136005)(76116006)(66946007)(33656002)(91956017)(66446008)(66556008)(64756008)(66476007)(2906002)(256004)(305945005)(5660300002)(966005);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3343;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: MZwKiA3UW2AP1oTMoT/8zjHSZuOTy3i13jayPzoEa2Bw6q9ewTJ+YMWgmNmAMWi6g7njK3uHSnirtdkRAl0TXqUI3KGgk3JXiWBV6xlqzbT0/ugSqmwSZKkpJ4BYIJpfvNOj+APtsSn/RLjWGuG5xpvcBsJ+XSy7L4z5evcyxljwvsqPjAceDOykNl6EkWWnBNHHn7QGDd/rr4pwm3uclmtZq9pNNj2MqWtJve3mMBNukpJ/tf1zaxYpkZaOgLxtyCVqlmlM4eydPlnyMRWvuIrraq2Bits4tNqZn8SwKFO7v0BOp8RXIIPtj6gBLK/ifDkQjkprSVHKgBCTkh9pp+cDEmrY+r1DrvpuyjSxlRPmglMZsiAOKEGVZb1agSRmTVCT+WoqxtWC2123kpGLEdDpyq9JPDh0lJRNTJqzxt4=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: decbe59b-f0bc-487f-c41b-08d714399049
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jul 2019 15:29:36.1460
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: horia.geanta@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3343
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 7/17/2019 6:25 PM, Andrey Smirnov wrote:=0A=
> In order to be able to unify 64 and 32 bit implementations of=0A=
> wr_reg64, let's convert it to use helpers from=0A=
> <linux/io-64-nonatomic-hi-lo.h> first. Here are the steps of the=0A=
> transformation:=0A=
> =0A=
> 1. Inline wr_reg32 helpers:=0A=
> =0A=
> 	if (!caam_imx && caam_little_end) {=0A=
> 		if (caam_little_end) {=0A=
> 			iowrite32(data >> 32, (u32 __iomem *)(reg) + 1);=0A=
> 			iowrite32(data, (u32 __iomem *)(reg));=0A=
> 		} else {=0A=
> 			iowrite32be(data >> 32, (u32 __iomem *)(reg) + 1);=0A=
> 			iowrite32be(data, (u32 __iomem *)(reg));=0A=
> 		}=0A=
> 	} else {=0A=
> 		if (caam_little_end) {=0A=
> 			iowrite32(data >> 32, (u32 __iomem *)(reg));=0A=
> 			iowrite32(data, (u32 __iomem *)(reg) + 1);=0A=
> 		} else {=0A=
> 			iowrite32be(data >> 32, (u32 __iomem *)(reg));=0A=
> 			iowrite32be(data, (u32 __iomem *)(reg) + 1);=0A=
> 		}=0A=
> 	}=0A=
> =0A=
> 2. Transfrom the conditionals such that the check for=0A=
> 'caam_little_end' is at the top level:=0A=
> =0A=
> 	if (caam_little_end) {=0A=
> 		if (!caam_imx) {=0A=
> 			iowrite32(data >> 32, (u32 __iomem *)(reg) + 1);=0A=
> 			iowrite32(data, (u32 __iomem *)(reg));=0A=
> 		} else {=0A=
> 			iowrite32(data >> 32, (u32 __iomem *)(reg));=0A=
> 			iowrite32(data, (u32 __iomem *)(reg) + 1);=0A=
> 		}=0A=
> 	} else {=0A=
> 		iowrite32be(data >> 32, (u32 __iomem *)(reg));=0A=
> 		iowrite32be(data, (u32 __iomem *)(reg) + 1);=0A=
> 	}=0A=
> =0A=
> 3. Invert the check for !caam_imx:=0A=
> =0A=
> 	if (caam_little_end) {=0A=
> 		if (caam_imx) {=0A=
> 			iowrite32(data >> 32, (u32 __iomem *)(reg));=0A=
> 			iowrite32(data, (u32 __iomem *)(reg) + 1);=0A=
> 		} else {=0A=
> 			iowrite32(data >> 32, (u32 __iomem *)(reg) + 1);=0A=
> 			iowrite32(data, (u32 __iomem *)(reg));=0A=
> 		}=0A=
> 	} else {=0A=
> 		iowrite32be(data >> 32, (u32 __iomem *)(reg));=0A=
> 		iowrite32be(data, (u32 __iomem *)(reg) + 1);=0A=
> 	}=0A=
> =0A=
> 4. Make use of iowrite64* helpers from <linux/io-64-nonatomic-hi-lo.h>=0A=
> =0A=
> 	if (caam_little_end) {=0A=
> 		if (caam_imx) {=0A=
> 			iowrite32(data >> 32, (u32 __iomem *)(reg));=0A=
> 			iowrite32(data, (u32 __iomem *)(reg) + 1);=0A=
> 		} else {=0A=
> 			iowrite64(data, reg);=0A=
> 		}=0A=
> 	} else {=0A=
> 		iowrite64be(data, reg);=0A=
> 	}=0A=
> =0A=
> No functional change intended.=0A=
> =0A=
> Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>=0A=
Reviewed-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
=0A=
Just to clarify one thing.=0A=
=0A=
For a previous patch I mentioned:=0A=
> To be consistent with CAAM engine HW spec: in case of 64-bit registers,=
=0A=
> irrespective of device endianness, the lower address should be read from=
=0A=
> / written to first, followed by the upper address.=0A=
https://lore.kernel.org/linux-crypto/VI1PR0401MB259145C2DFDB5E4084EA5DFC98D=
20@VI1PR0401MB2591.eurprd04.prod.outlook.com/=0A=
=0A=
I've checked again and actually there is no limitation wrt. the order in wh=
ich=0A=
the two 32-bit parts of 64-bit registers are read from / written to,=0A=
except for performance counters (only available on DN parts, not on i.MX).=
=0A=
However, performance counters do not user {rd,wr}_reg64 and should be fixed=
=0A=
separately.=0A=
=0A=
In conclusion, it's ok to use either hi_lo or lo_hi semantics (which is _da=
ta_=0A=
semantics btw).=0A=
It makes more sense for this patch to include io-64-nonatomic-hi-lo.h since=
=0A=
that's what regs.h currently uses.=0A=
=0A=
Horia=0A=
