Return-Path: <SRS0=VsuX=XG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84A2FECDE20
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Sep 2019 15:32:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 468F8206CD
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Sep 2019 15:32:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="xH2DFau7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727581AbfIKPcQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 11 Sep 2019 11:32:16 -0400
Received: from mail-eopbgr740080.outbound.protection.outlook.com ([40.107.74.80]:59503
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726510AbfIKPcQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 11 Sep 2019 11:32:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J8Aie3Sszw/yHinmYHPq4Yt7lu/taK+B/JxoSJINvHH75MpdAgFUqkasQk4+3RBvSSTeJSbcXdcChGGKPhtJ2Ie7hggQz9FNHRpbMtPISGmbxXvQqvgFWLJD3wEmAT2/+/9XaK6+SV0PYVuf0zDQcptmb93O1pvRVtV+lMCjrrFW7cIf6QrdxkOZDj+VnYgk7OsZ5Oya2pDFltuTIvzb1rFfkB6CHKX3p3FH4/RK8LnFR920wZwtiE/mmySaUqpJR180r2MQanQypxXErs8/ytcJ7lZJlyaHbBsKBtrON6+VjwiJycW+scM71wZzU+9T8nnrGLZbDPcNYo8eUk1N1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qf7pPuRvD659KxxVe04aqfDx8v75PGo8Y1/MRgWPYOo=;
 b=bqNwjZW9+MUlNsebpqbU29ZZF9xxCrY6LAvt3wKUlaKFQEjF2+rXKqzs6JZjkG7bAfxBw2d5EnJTShWCKOXghvMWFFvtCBhnGNZ99uSIMcTlwzOz2rc7OuZcvrcdzakNwqKyRRGMkRzjXum4UaVQ7/PFxreNXVgE7Fx9cR1dKxZSQplR/du+U253wMtCZk4sFs7S92zTknPhbm7VqQit8+O9/kdzzgd8N4uV6ysyUvp5D8bN7B+e7b6alhOanQLDBb7HI00M7czFyhCAtI82o3YG2l5MWwW1nTx7o26yHI309orYZV43oitzrnnBek8MXHRYt1LxzlkJvpfqcteFHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=verimatrix.com; dmarc=pass action=none
 header.from=verimatrix.com; dkim=pass header.d=verimatrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qf7pPuRvD659KxxVe04aqfDx8v75PGo8Y1/MRgWPYOo=;
 b=xH2DFau7b6mVKD/LpB9kqkK/+s4zJnJdZIiusAwGplKDyHwA9njGXAlLD0cSIr2ZllzvFZOVcL3iKCrL5j1j0VIPISN89//FjTBAroaGdSLBAIESWQ3gYIp1FRw0uL8EXf97879Qy2KD2qK7e93TBWYCFjeKTI5YRaQyza6u2og=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB2238.namprd20.prod.outlook.com (20.179.145.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.18; Wed, 11 Sep 2019 15:32:12 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::6d07:5f09:97bf:c717]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::6d07:5f09:97bf:c717%7]) with mapi id 15.20.2241.022; Wed, 11 Sep 2019
 15:32:12 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Antoine Tenart <antoine.tenart@bootlin.com>
CC:     Pascal van Leeuwen <pascalvanl@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [PATCH 1/2] crypto: inside-secure - Added support for the
 CHACHA20 skcipher
Thread-Topic: [PATCH 1/2] crypto: inside-secure - Added support for the
 CHACHA20 skcipher
Thread-Index: AQHVZ+4odBpV2XL9NUuE4Wxeg5/uy6clK6gAgAAWOSCAAVdTgIAAAv+g
Date:   Wed, 11 Sep 2019 15:32:12 +0000
Message-ID: <MN2PR20MB2973D04A6A9BA62A8E0861B4CAB10@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <1568126293-4039-1-git-send-email-pvanleeuwen@verimatrix.com>
 <1568126293-4039-2-git-send-email-pvanleeuwen@verimatrix.com>
 <20190910173246.GA14055@kwain>
 <MN2PR20MB297383846FB390299EFEA0C3CAB60@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190911152107.GA5492@kwain>
In-Reply-To: <20190911152107.GA5492@kwain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f892ea25-ba13-440f-f356-08d736cd37a9
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR20MB2238;
x-ms-traffictypediagnostic: MN2PR20MB2238:
x-ms-exchange-purlcount: 2
x-microsoft-antispam-prvs: <MN2PR20MB2238D716D6DF753EFE093BC3CAB10@MN2PR20MB2238.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0157DEB61B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(366004)(39850400004)(396003)(376002)(199004)(189003)(13464003)(55016002)(64756008)(102836004)(6506007)(7736002)(8936002)(53546011)(6306002)(305945005)(33656002)(9686003)(81166006)(81156014)(26005)(8676002)(256004)(186003)(52536014)(2906002)(316002)(54906003)(66476007)(66946007)(66446008)(74316002)(66556008)(3846002)(6116002)(476003)(486006)(71190400001)(71200400001)(76176011)(7696005)(11346002)(99286004)(5660300002)(15974865002)(478600001)(14454004)(6916009)(966005)(6246003)(76116006)(229853002)(4326008)(6436002)(66066001)(25786009)(86362001)(446003)(53936002)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB2238;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: SA28pkLXkvnaJ0BsGAabX4oUNDqk9bzbT4k4efJ5wgZLQhdpuuYC/K0U2+ojoL6Kov7uWLVu4K+0M2Z0ObIktWZvp0oMjwtmR7ZzU8TK8iOI0Kny6rXJLh+xV5dyRSgQPpzkVJZZncvKfm9IUmQY7AcXJez19OQ31eFfooXcJOACDI8Q0Re5pKeMsGyvsvAggCKcr7T0sk8rqhpoJAZBBCYrE5tME8cBuNaFd+Dc6F0RiLnh1ReBnj2gBqp7J0ftXRa2frcAuoqcwJpqhqm8z0eIiNjQ850H84urqkRXMfmEFvUIZ57BXYgVwCTOoCazd2HtQE7YNqb9P8zdPIaVrcHXezo7/BG9il01KPiF4p4noOtATKBu5SQ1QCuDPvCgn+0SfWYD8n2zqWIP/K9twMFiMiELrH7V9uuMzssmjVE=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f892ea25-ba13-440f-f356-08d736cd37a9
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Sep 2019 15:32:12.4775
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lVRSbBnjflDvuARXP1UMrMnK/4bZwLFdPyavriKIfQxmkSJTPN5e0QGVhx/NF/Bna5Ygh4ck49LqLfaLnxIRw9yCatl7uxj6HkspLXaHS04=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB2238
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> -----Original Message-----
> From: Antoine Tenart <antoine.tenart@bootlin.com>
> Sent: Wednesday, September 11, 2019 5:21 PM
> To: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
> Cc: Antoine Tenart <antoine.tenart@bootlin.com>; Pascal van Leeuwen
> <pascalvanl@gmail.com>; linux-crypto@vger.kernel.org; herbert@gondor.apan=
a.org.au;
> davem@davemloft.net
> Subject: Re: [PATCH 1/2] crypto: inside-secure - Added support for the CH=
ACHA20 skcipher
>=20
> Hello Pascal,
>=20
> On Tue, Sep 10, 2019 at 06:58:18PM +0000, Pascal Van Leeuwen wrote:
> > > On Tue, Sep 10, 2019 at 04:38:12PM +0200, Pascal van Leeuwen wrote:
> > > > @@ -112,7 +123,7 @@ static void safexcel_cipher_token(struct safexc=
el_cipher_ctx
> *ctx, u8
> > > *iv,
> > > >  			block_sz =3D DES3_EDE_BLOCK_SIZE;
> > > >  			cdesc->control_data.options |=3D EIP197_OPTION_2_TOKEN_IV_CMD;
> > > >  			break;
> > > > -		case SAFEXCEL_AES:
> > > > +		default: /* case SAFEXCEL_AES */
> > >
> > > Can't you keep an explicit case here?
> > >
> > If I do that, the compiler will complain about SAFEXCEL_CHACHA20 not
> > being covered. And Chacha20 won't even make it this far, so it doesn't
> > make much sense to add that to the switch.
> >
> > I suppose an explicit case plus an empty default would be an alternativ=
e?
> > But I figured the comment should suffice to remind anyone working on th=
at
> > switch statement what it should really do. I'm fine with either approac=
h.
>=20
> Yes, please use an explicit case and an empty default.
>=20
OK, will do

> Thanks,
> Antoine
>=20
> --
> Antoine T=E9nart, Bootlin
> Embedded Linux and Kernel engineering
> https://bootlin.com

Thanks,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com

