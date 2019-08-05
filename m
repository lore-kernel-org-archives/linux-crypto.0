Return-Path: <SRS0=2Ix1=WB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB295C0650F
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Aug 2019 09:49:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A1C112086D
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Aug 2019 09:49:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="QLN0I/QL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727225AbfHEJtf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 5 Aug 2019 05:49:35 -0400
Received: from mail-eopbgr700089.outbound.protection.outlook.com ([40.107.70.89]:24545
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726880AbfHEJte (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Aug 2019 05:49:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WFPfUKqF85EEVR43r5mfHbsFhRMRfG/FQvEg8J+l2uuI+3JUqTv6xKpfJtVjG0FLeX7KxRJW/cJ/OseIxeKQ43X5f5p5AvstZIQhtJIkNKfma7t4TEkU3SWAE3B10Fxt45dYE6bUbT2YLJ+Yoe3e/bKCr0XEoSZpKcQHtQyBVSzv8VHC8mgMPTyqdJz0U7+x05DblsB+RQEJsSF7dDKhGFumlK0WZv344a3cklO+tw5XbYq24l4qijieQ2TGxuJqVft88p6xbbYcvGklsDGGCo8juDsFEBwxuNfAJ6akAhCYWWDwSrmR3Kfsz7xqiVFpL0JuMhK/XL5sBKL8gdvCnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zw2bpnX5XpOrtE3a2rEvD7H+II3d4f1lRbCE/45ndto=;
 b=QKHRBxB14rXuQfvKV2wEDkbl+uOlysE5tK/7nZ5fcy/djGmDjhyL/X1xtxTt/z21qFQ+7almosdEqBwV++wLE3RrIoPZSE8ZPLcYZxdkrEnjd1L0l2p/CG2H1V8n1PcLaWFguNjTQT2a/PfnJMwgUIQoP3h6tkMpYDgQgGhr+spOhbWwHYyHxlh2gqhDmTspWIwp2q8AOckZPEmsyKXi+Kr3iCe5vgii9NJbC90KhGl7msVKmIYm4XLXKmuSpa5xICde+0L8FDRBnjrzjaZXksxSyyQ5/IlSHD+u4UqdIY2fKgqJPXMWpX8IQ/k2r8kXjpB9RfrCrbB5vSJE6Aaq2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=verimatrix.com;dmarc=pass action=none
 header.from=verimatrix.com;dkim=pass header.d=verimatrix.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zw2bpnX5XpOrtE3a2rEvD7H+II3d4f1lRbCE/45ndto=;
 b=QLN0I/QLf3gcZMlIT8OQihmPpgioOo8+cChR55bsfnKAK3ntCEFkBhXvfS/x8VGTIEdzuxyzVIMbQRRHsWKe/l9ATj3uGVJvdbh7oMjVUA7TmN9cRAKBOs9hXXypf7VGd3+zp6oAxP8G0u1kPGpysKjihE1EV7E5KuEGTeuJhmM=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB2368.namprd20.prod.outlook.com (20.179.144.212) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2136.13; Mon, 5 Aug 2019 09:49:32 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1%7]) with mapi id 15.20.2136.018; Mon, 5 Aug 2019
 09:49:32 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Antoine Tenart <antoine.tenart@bootlin.com>
CC:     Pascal van Leeuwen <pascalvanl@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [PATCHv3 3/4] crypto: inside-secure - add support for PCI based
 FPGA development board
Thread-Topic: [PATCHv3 3/4] crypto: inside-secure - add support for PCI based
 FPGA development board
Thread-Index: AQHVR711tx55pVdXREWH70DJWI7+XKbsQiUAgAACcwCAAAcGAIAACtHg
Date:   Mon, 5 Aug 2019 09:49:32 +0000
Message-ID: <MN2PR20MB2973232FA339C75E010877A2CADA0@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <1564586959-9963-1-git-send-email-pvanleeuwen@verimatrix.com>
 <1564586959-9963-4-git-send-email-pvanleeuwen@verimatrix.com>
 <20190805083602.GG14470@kwain>
 <MN2PR20MB29735954E5670FE3476F18B6CADA0@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190805090956.GI14470@kwain>
In-Reply-To: <20190805090956.GI14470@kwain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c2a953fa-be62-49bb-2c2f-08d7198a37c4
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR20MB2368;
x-ms-traffictypediagnostic: MN2PR20MB2368:
x-ms-exchange-purlcount: 2
x-microsoft-antispam-prvs: <MN2PR20MB2368C94ACC47E8A217C26DD2CADA0@MN2PR20MB2368.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 01208B1E18
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(39840400004)(346002)(396003)(136003)(376002)(51914003)(189003)(199004)(13464003)(14454004)(316002)(476003)(3846002)(2906002)(186003)(8936002)(6116002)(6916009)(11346002)(74316002)(99286004)(68736007)(446003)(6436002)(54906003)(478600001)(53936002)(6506007)(4326008)(26005)(229853002)(305945005)(102836004)(66066001)(486006)(966005)(66556008)(6246003)(64756008)(25786009)(5660300002)(76116006)(53546011)(9686003)(6306002)(71200400001)(71190400001)(7736002)(86362001)(52536014)(33656002)(7696005)(15974865002)(81156014)(66476007)(55016002)(256004)(8676002)(76176011)(66446008)(66946007)(81166006)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB2368;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 0H/k1ms7Sk59Csfc2gv1rXbvIuGpWsGK/BYp0pOJ0nPkJ95J8atkOOC5Hj4BGR+TyJL3fKGQL+i/KZbhY/e8QWAWNpIL3E/Yd6j7OWt/ScUdFgSae3Mn1VgPWi8W7JFeRJ0F3LUleptpc+hIs24YvVx2sQ2AnmWtEVallR3i8hbkdjXRvmFm53SogpgFXTQlcXxLXV1Dy5DkHe3pKv9GYztJMQzOUJk/d52WiTv7Z3JcwBCyiJBgSwWr7VmJRjZiqf/7dRNWTWzgSnMP7njQ0HYI9f9QdNQDqzOLlGzOIqcOwlau7KygTfVRdni6vCQYHlHXsyEBwqq4ZgJH3G/QBJzFiPeS2F2t7h/76YUwd5TmMMHbNOCEBNhmNGC0yvvwOackYgz+P+yk4cr01VkQUMOxFguz8f9DxSQk/S6EEUA=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2a953fa-be62-49bb-2c2f-08d7198a37c4
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Aug 2019 09:49:32.6579
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvanleeuwen@verimatrix.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB2368
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> -----Original Message-----
> From: Antoine Tenart <antoine.tenart@bootlin.com>
> Sent: Monday, August 5, 2019 11:10 AM
> To: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
> Cc: Antoine Tenart <antoine.tenart@bootlin.com>; Pascal van Leeuwen
> <pascalvanl@gmail.com>; linux-crypto@vger.kernel.org; herbert@gondor.apan=
a.org.au;
> davem@davemloft.net
> Subject: Re: [PATCHv3 3/4] crypto: inside-secure - add support for PCI ba=
sed FPGA
> development board
>=20
> Hi Pascal,
>=20
> On Mon, Aug 05, 2019 at 08:47:42AM +0000, Pascal Van Leeuwen wrote:
> >
> > Thanks for the review and I agree with all of your comments below.
> > So I'm willing to fix those but I'm a bit unclear of the procedure now,
> > since you acked part of the patch set already.
> >
> > Should I resend just the subpatches that need fixes or should I resend
> > the whole patchset? Please advise :-)
>=20
> You should add my Acked-by tag on the first two patches (below your SoB
> tag), and then yes please resubmit the whole series.
>=20
Ok, will do, thanks!

> Thanks!
> Antoine
>=20
> --
> Antoine T=E9nart, Bootlin
> Embedded Linux and Kernel engineering
> https://bootlin.com

Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com
