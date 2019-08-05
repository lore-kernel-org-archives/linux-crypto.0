Return-Path: <SRS0=2Ix1=WB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81B6DC0650F
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Aug 2019 13:02:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4260E206C1
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Aug 2019 13:02:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="mD0sd1VN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726508AbfHENCN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 5 Aug 2019 09:02:13 -0400
Received: from mail-eopbgr780040.outbound.protection.outlook.com ([40.107.78.40]:12222
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726559AbfHENCM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Aug 2019 09:02:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ChyzfWg+UFQ/+WFxdjBBDGxPEo2vFrxTc1rKXH43k2n+tmSUjDsuyMHo8jbOiGxoSZ+z0ved2xYZe7cYpWNSEiIYZGjM4oDtYJu+cqeuNanccZtFr7hN08hg5Crr0+wSUtoXF2QmZRYritCojSeT8LQ7Hf/RSdCAa+yXHed6nP+Ge+q7ugbKG3TTjuaMN4aG14hUvRJlt9XSytpil1hU20/N9DlFNXG17KV0mVUAARVS/gclyLUKrDv9wFf6VNYEo1FVPm7c4GyeXQ5utAW3LBaP83M183NhPyPS5SbfFdd0CFCmcsnM3v2Ng6Llu8MP7BryiCJqHwq75WEwowPmDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=44BwcEpVjK/UULmFsh5XNCVa8L136Vo5Wcmg/uuQ7c0=;
 b=DFTit3DmMhg7y6vWganPqK+Gk7rHpWNNgzxE4J9K4A6lAJA+UkR4YJb49TKRhlR8E3yHB/ib8KmV72HDqxd1EQdOdlI4wuNcHdSL5Mum9vXoHlLx6J6Fv789WrBuMt5ZeB82t+pp942CzsOKLJhueT0CvOcWyBlutEyINX1noTyujM2Avo9NIpKxcmgsFHXfmaDjPeJMTc23hhnhNz3cIscULyZ1YQGeDs0wW+SkhDorvkgEwEKLyLOyfqY7SdE08cqKn+Sf+f20De84/584f1oSPD995cocYnARSRkVHnMojdzxqaSKtUfyulBfEm5yBjCV8+1FW7YDk+3bT60pdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=verimatrix.com;dmarc=pass action=none
 header.from=verimatrix.com;dkim=pass header.d=verimatrix.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=44BwcEpVjK/UULmFsh5XNCVa8L136Vo5Wcmg/uuQ7c0=;
 b=mD0sd1VN83OosfyHEW4kky0J6fqzDLRf9ob4Wh5i1QhXXjo4jzmsvA9bwXeFvp8lJ0CGGSb7/nnPT4uJkG9jba31MqzW11A2w0FPZZgAQvqz1Lcc2Z7QbfbjKo0BXUIXm3jY24Dj9xHRxPVKkvL/QJYs3bDlrTb6Ld2X9mNuLBQ=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB2718.namprd20.prod.outlook.com (20.178.254.76) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2136.16; Mon, 5 Aug 2019 13:02:08 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1%7]) with mapi id 15.20.2136.018; Mon, 5 Aug 2019
 13:02:08 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Antoine Tenart <antoine.tenart@bootlin.com>
CC:     Pascal van Leeuwen <pascalvanl@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [PATCHv3 4/4] crypto: inside-secure - add support for using the
 EIP197 without vendor firmware
Thread-Topic: [PATCHv3 4/4] crypto: inside-secure - add support for using the
 EIP197 without vendor firmware
Thread-Index: AQHVR7116MJ9FzpBkkuhb1mvd6XCi6bsSuqAgAADriCAAAlyAIAAAZgwgAAtpQCAAARUoA==
Date:   Mon, 5 Aug 2019 13:02:08 +0000
Message-ID: <MN2PR20MB2973ECE2AB0598E32E088EDECADA0@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <1564586959-9963-1-git-send-email-pvanleeuwen@verimatrix.com>
 <1564586959-9963-5-git-send-email-pvanleeuwen@verimatrix.com>
 <20190805090725.GH14470@kwain>
 <MN2PR20MB29730648846013A67753624ECADA0@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190805095424.GJ14470@kwain>
 <MN2PR20MB2973944BBF39EB11537E3163CADA0@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190805124328.GK14470@kwain>
In-Reply-To: <20190805124328.GK14470@kwain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0a2ed2e1-aa8e-419d-547c-08d719a51f65
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:MN2PR20MB2718;
x-ms-traffictypediagnostic: MN2PR20MB2718:
x-ms-exchange-purlcount: 2
x-microsoft-antispam-prvs: <MN2PR20MB2718A16BE0E74413D374ABDBCADA0@MN2PR20MB2718.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 01208B1E18
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(396003)(136003)(366004)(39850400004)(199004)(189003)(13464003)(26005)(446003)(11346002)(66066001)(966005)(66446008)(66556008)(14454004)(9686003)(6306002)(66476007)(478600001)(52536014)(6916009)(5660300002)(55016002)(64756008)(66946007)(76116006)(4326008)(305945005)(7736002)(68736007)(33656002)(6246003)(25786009)(66574012)(76176011)(81166006)(86362001)(81156014)(8676002)(99286004)(3846002)(6116002)(53936002)(229853002)(2906002)(6436002)(54906003)(15974865002)(8936002)(316002)(14444005)(71190400001)(71200400001)(256004)(53546011)(6506007)(74316002)(186003)(486006)(7696005)(476003)(102836004)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB2718;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: TSunTznLrZc3woFuQ7BLXe3cBwL2NYy7lxfjHk5O9NzsiMIdlepoyXmHN40Pp46/sEqNcaMcGZ8QOwgJm6Y2RZxL6+t0hJ+NIm34NxAoPR4ShWvgPr++4JvL1UjDRj9rmnHfyq5Qt5kVmZsULR7oNXj85AID9It9BPnY53k/f6wEswDNGINuLptIuqO3B0k69CQ6Q5SsagSa7zMNO1nIH+mTloGX87J8XN1SEyt7UKXDRJoRFzzEpqS/7SEPI90nAnDoj/xocnGE8j5PSQSLJS/KzWLb1Y7peny5VE3yfCXdtrp8p36F/jPBDog4Ay0yhEQIucHYhmModC+GJ0cclY/Ax7TjGEs6tZREjIAkwCorNO22d7LPeGLuJrkqN/m3C5bBDsrloU523+h8DSs35qbl3gcEGmI8IGv2JCaYlas=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a2ed2e1-aa8e-419d-547c-08d719a51f65
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Aug 2019 13:02:08.2347
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvanleeuwen@verimatrix.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB2718
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> -----Original Message-----
> From: Antoine Tenart <antoine.tenart@bootlin.com>
> Sent: Monday, August 5, 2019 2:43 PM
> To: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
> Cc: Antoine Tenart <antoine.tenart@bootlin.com>; Pascal van Leeuwen
> <pascalvanl@gmail.com>; linux-crypto@vger.kernel.org; herbert@gondor.apan=
a.org.au;
> davem@davemloft.net
> Subject: Re: [PATCHv3 4/4] crypto: inside-secure - add support for using =
the EIP197
> without vendor firmware
>=20
> On Mon, Aug 05, 2019 at 10:12:07AM +0000, Pascal Van Leeuwen wrote:
> > > From: Antoine Tenart <antoine.tenart@bootlin.com>
> > > On Mon, Aug 05, 2019 at 09:48:13AM +0000, Pascal Van Leeuwen wrote:
> > > > > On Wed, Jul 31, 2019 at 05:29:19PM +0200, Pascal van Leeuwen wrot=
e:
> > > > > >
> > > > > > -	/* Release engine from reset */
> > > > > > -	val =3D readl(EIP197_PE(priv) + ctrl);
> > > > > > -	val &=3D ~EIP197_PE_ICE_x_CTRL_SW_RESET;
> > > > > > -	writel(val, EIP197_PE(priv) + ctrl);
> > > > > > +	for (pe =3D 0; pe < priv->config.pes; pe++) {
> > > > > > +		base =3D EIP197_PE_ICE_SCRATCH_RAM(pe);
> > > > > > +		pollcnt =3D EIP197_FW_START_POLLCNT;
> > > > > > +		while (pollcnt &&
> > > > > > +		       (readl_relaxed(EIP197_PE(priv) + base +
> > > > > > +			      pollofs) !=3D 1)) {
> > > > > > +			pollcnt--;
> > > > >
> > > > > You might want to use readl_relaxed_poll_timeout() here, instead =
of a
> > > > > busy polling.
> > > > >
> > > > Didn't know such a thing existed, but I also wonder how appropriate=
 it
> > > > is in this case, condering it measures in whole microseconds, while=
 the
> > > > response time I'm expecting here is in the order of a few dozen nan=
o-
> > > > seconds internally ... i.e. 1 microsecond is already a *huge* overk=
ill.
> > > >
> > > > The current implementation runs that loop for only 16 iterations wh=
ich
> > > > should be both more than sufficient (it probably could be reduced
> > > > further, I picked 16 rather arbitrarily) and at the same time take =
so
> > > > few cycles on the CPU that I doubt it is worthwhile to reschedule/
> > > > preempt/whatever?
> > >
> > > Your choice, I was just making a suggestion :)
> > >
> > After reading the implementation code, I think using it with a
> > sleep_us value of 0 and a time-out value of 1 may be reasonable here,
> > as time-out means some serious error that shouldn't normally happen.
> > I just wouldn't want any microsecond delays for the "normal" case.
>=20
> Using this function that is designed to sleep with a delay of 0 and
> designed to timeout with a value of 1 does not seem to follow what the
> function is designed for :) It could work but I would suggest to keep
> the polling as it is in the patch in this case.
>=20
Ok, will do. Does that mean that patch 4/4 is good as is?
i.e. can I add an "Acked-by: Antoine Tenart" line when I resubmit?

> Thanks,
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
