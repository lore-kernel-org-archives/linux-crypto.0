Return-Path: <SRS0=RABd=V3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13CBAC433FF
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jul 2019 14:01:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BB687206E0
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jul 2019 14:01:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="VxhqR18Y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729523AbfG3OBt (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 30 Jul 2019 10:01:49 -0400
Received: from mail-eopbgr710082.outbound.protection.outlook.com ([40.107.71.82]:42432
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727323AbfG3OBt (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Jul 2019 10:01:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mhEszgS6wS1gJMkkOQTkmfWl9xQz5SP122bGidueBN10R7j1Dfq77E5TerVsg733s0fJ+jcY3lSHPaiwCe6B6lZ3l3npKkXHtNeqaukC8qKD6sDMrkNIgOc3r8Z+utVlKYG/2+vwtPVlQCuGL8nuURl6T4jl+RqspCYmNbnJ9/HsFQXb0u6+c2bDGP7v9kT9wKaE/VxSnFx4EbFX9ivepPS0qk5rj+9QNOZtC1KBGEgaC6TnKJB7oSHBpOhyGV4nNahQZRcmVelOKF60Po1asjQohE+Udwmi8Vq6tWtJ3OYOF9vIo4IBk4HHh/+Hv+nNmSsDu5uDVO07uU0Az/qozw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bu58fsBV851B9cM2UkM6f4tTk98YX1UOn9foxIfzmG8=;
 b=UyZecbV33MNYDbj3v0ARkS4vtTgKc05kjeP6MYMm6Ehdu9/aeHUExU9pFd7824NOIT0giZw61LG491zCyuUqoVBo4mpZ2eLyhSrWxCqjiTNLDhW+TsV25qzPziWPtjgGQ0jWbq++TD2hR+DZ2PIGmH7YfFW0Ma+E1SC9kyKcmz5AiXH8tSY0A8UuVa29Bjx0ol2tlG4rUCbmZDSpibx152MglQar42ui2Kt5KMQhgpI9kChlSyFn2d0SQWnDYbyGqXQcJcyaiSWusMXHPMMfc83Bg2XkOefK/CAwFwIR5vTlQBq/9tCaIND2jdC5fgV9rfNaqVi47IAg0u6O2cMMTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=verimatrix.com;dmarc=pass action=none
 header.from=verimatrix.com;dkim=pass header.d=verimatrix.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bu58fsBV851B9cM2UkM6f4tTk98YX1UOn9foxIfzmG8=;
 b=VxhqR18Y1r3uY2WsNBk1sFYuozC45C0/HLVysniA+6r1rblktpXR4diG4/UheQ2I0QePAXhXRWgg3aXmJ5azdqN3Q0imdm1y44o81ckXmbcAbAwq3ixoPLprTvTlwvgViu1gnJSvVHdV4yR8/zaEgmw5CYpYUbuCAHbFdvKSGvE=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB3280.namprd20.prod.outlook.com (52.132.175.205) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.13; Tue, 30 Jul 2019 14:01:46 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1%7]) with mapi id 15.20.2115.005; Tue, 30 Jul 2019
 14:01:46 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Pascal van Leeuwen <pascalvanl@gmail.com>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [PATCH 1/3] crypto: inside-secure - add support for
 authenc(hmac(sha1),cbc(des3_ede))
Thread-Topic: [PATCH 1/3] crypto: inside-secure - add support for
 authenc(hmac(sha1),cbc(des3_ede))
Thread-Index: AQHVMwaxl7vezQ4XF0yNrfTnczMQM6bc8rsAgAAGFCCABl5P0A==
Date:   Tue, 30 Jul 2019 14:01:46 +0000
Message-ID: <MN2PR20MB297366400B400A2BD77A0BCFCADC0@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <1562309364-942-1-git-send-email-pvanleeuwen@verimatrix.com>
 <1562309364-942-2-git-send-email-pvanleeuwen@verimatrix.com>
 <20190726121938.GC3235@kwain>
 <MN2PR20MB2973B64FD27EA16A6FADBAFBCAC00@MN2PR20MB2973.namprd20.prod.outlook.com>
In-Reply-To: <MN2PR20MB2973B64FD27EA16A6FADBAFBCAC00@MN2PR20MB2973.namprd20.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1470a7d2-fe9d-4bb0-19c9-08d714f6757c
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR20MB3280;
x-ms-traffictypediagnostic: MN2PR20MB3280:
x-ms-exchange-purlcount: 2
x-microsoft-antispam-prvs: <MN2PR20MB328008064F0FC0AB113D8C7ACADC0@MN2PR20MB3280.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0114FF88F6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(346002)(39850400004)(396003)(366004)(199004)(189003)(13464003)(81156014)(81166006)(8936002)(102836004)(66476007)(6506007)(53546011)(66556008)(76116006)(53936002)(7696005)(4326008)(68736007)(966005)(476003)(486006)(6116002)(66946007)(3846002)(6436002)(446003)(11346002)(6306002)(55016002)(66574012)(2906002)(15974865002)(478600001)(64756008)(76176011)(8676002)(25786009)(6246003)(71190400001)(33656002)(14454004)(186003)(71200400001)(66446008)(54906003)(110136005)(99286004)(66066001)(9686003)(229853002)(305945005)(316002)(86362001)(74316002)(256004)(52536014)(7736002)(26005)(5660300002)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB3280;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 2KE9xbpxBP+36ilTtxOrrK6fW4xdrI7G0Yy/IWGtR5m7zr6c963uWVl3CDp7ZH958ZbPymtQsNS+DM4Jpo5NMSTUBn1d3gAahzjt/yOas/BraLfRzJ/xTmv9ROz4+gecZDU0FtDGiDuyzc9EG+oQddylP1JMWsMqrI6PON6Om9wYmWucstuq4JEuTesmD7raSQgypjLSu4CaE4DogJENf6oD4g6NPQ35Jjr2kojFM2dn4cC+KTcpliUi1EH9+ZrdFIRiI/vVLczLNjhCDEW6MBm4nS10a7+YIZ6s4jphzMqdAsCgC/PiuSbRIFRIkBw1eQJQPl/4MCMAP++phUXuN/ksd2mcCeWxxH1J7AMe1EdlcAlHpdEVIDHK4VYbqMLCqfOuX0bn/YR0V04/4kO5eK27LIB85sP94/P18qvXf74=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1470a7d2-fe9d-4bb0-19c9-08d714f6757c
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jul 2019 14:01:46.1192
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvanleeuwen@verimatrix.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB3280
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> -----Original Message-----
> From: linux-crypto-owner@vger.kernel.org <linux-crypto-owner@vger.kernel.=
org> On Behalf Of
> Pascal Van Leeuwen
> Sent: Friday, July 26, 2019 2:57 PM
> To: Antoine Tenart <antoine.tenart@bootlin.com>; Pascal van Leeuwen <pasc=
alvanl@gmail.com>
> Cc: linux-crypto@vger.kernel.org; herbert@gondor.apana.org.au; davem@dave=
mloft.net
> Subject: RE: [PATCH 1/3] crypto: inside-secure - add support for
> authenc(hmac(sha1),cbc(des3_ede))
>=20
> Antoine,
>=20
>=20
> > > +	.alg.aead =3D {
> > > +		.setkey =3D safexcel_aead_setkey,
> > > +		.encrypt =3D safexcel_aead_encrypt_3des,
> > > +		.decrypt =3D safexcel_aead_decrypt_3des,
> > > +		.ivsize =3D DES3_EDE_BLOCK_SIZE,
> > > +		.maxauthsize =3D SHA1_DIGEST_SIZE,
> > > +		.base =3D {
> > > +			.cra_name =3D "authenc(hmac(sha1),cbc(des3_ede))",
> > > +			.cra_driver_name =3D "safexcel-authenc-hmac-sha1-cbc-des3_ede",
> >
> > You could drop "_ede" here, or s/_/-/.
> >
> Agree the underscore should not be there.
> Our HW does not support any other form of 3DES so EDE doesn't
> really add much here, therefore I will just remove "_ede" entirely.
>
Actually, while looking into fixing this, I noticed that this=20
naming style is actually consistent with the already existing
3des ecb and cbc ciphersuites, e.g.: "safexcel-cbc-des3_ebe",
so for consistency I would then suggest keeping it (or=20
change the other 2 3des references at the same time, but I
don't know if that would break any legacy dependency).

>=20
> > Apart from those small comments, the patch looks good.
> >
> > Thanks!
> > Antoine
> >
> > --
> > Antoine T=E9nart, Bootlin
> > Embedded Linux and Kernel engineering
> > https://bootlin.com
>=20

Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com
