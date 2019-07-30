Return-Path: <SRS0=RABd=V3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C057C0650F
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jul 2019 10:27:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 30D2420651
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jul 2019 10:27:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="YB6veKMV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728663AbfG3K13 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 30 Jul 2019 06:27:29 -0400
Received: from mail-eopbgr770044.outbound.protection.outlook.com ([40.107.77.44]:59876
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727156AbfG3K13 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Jul 2019 06:27:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PkEyKCAbiD3hHJ64cdgZ7Ix8iiMmyUcmcYxqr47W3Q/T7tNcqp5WhS8pIwPb+bpLtOpV1KYfHS94s81lCIaAHvzW5yrkIU5yKYEndj/3WLJnPxXt81jtjerI9J3kY7Wpjlhu2fWwVbfk2RYGzWOLGQzibT1JSdEhpn8QsVdWhenkWKgYUJ6Uj/MUbTbA82h9uyAfNWQTlGOfdA9g0wTLQOQwz5uYSuIUokGSIgAKxBih4T9dn7DMT736XMcqJnO29Pg++6yplPtosre/Z+CcnjqgGpqJZXSQvTVYv3L8kAQ3ivkq2Vwt+F8Cc3ad3aZjEiAeG/k2LneWxUR+4Kmkaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=62s+4zzujMgWHRt6D11Se7N4H57KxM6HcixkoziNXcA=;
 b=BnpUoiTyfrPdLQZuupekXWiXI7KNzBP1ZVIebLnbAF2y+BnpJzagJLznGendXFmAH8Pn3VnqAVZmE875+QfDKkBgA91vp508eRI88CrR6ZXST04xVmn3cE6H/IAuHh2r4/qwitbZv7zqYdBbDxomFsr/68vJ0e7r4/U+vPmTlInYud5SF+Qm57ZUARx8bG68p2m0jiyycq85ZRTEoxhxr9rwXZRzKZOIFL1bWFD1zKB/BfJfLjBY+INK51c541pzZst5qr5jKvE3qMGLzRq2dLGVvhflcGx0z4bIbah7dJ7x2wV52EuJc8OGUDCsgKwBZ+9MZbIlYEWqKGoG3yHjkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=verimatrix.com;dmarc=pass action=none
 header.from=verimatrix.com;dkim=pass header.d=verimatrix.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=62s+4zzujMgWHRt6D11Se7N4H57KxM6HcixkoziNXcA=;
 b=YB6veKMVyIFz8Fy4K9y4FCzCnDRJYECAFGA2RyDzcbSldnMm+Lpv/yuz9mmhvhuAkaGO1ufylU+qPOHJTqBqL9JcFwcTGz0Swf6PLUcLCKyvhAhkZej2iEgYjyO1AdesBr5YRsoI3h5ilvSq1uOMhMeD3NG1lohc+vJbNRdVtCw=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB3088.namprd20.prod.outlook.com (52.132.174.25) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.10; Tue, 30 Jul 2019 10:27:26 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1%7]) with mapi id 15.20.2115.005; Tue, 30 Jul 2019
 10:27:26 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Antoine Tenart <antoine.tenart@bootlin.com>,
        Pascal van Leeuwen <pascalvanl@gmail.com>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [PATCH] crypto: inside-secure - Fix null ptr derefence on rmmod
 for macchiatobin
Thread-Topic: [PATCH] crypto: inside-secure - Fix null ptr derefence on rmmod
 for macchiatobin
Thread-Index: AQHVQ8/iMgPRTLq6dkWB1iRsEnMin6bi1VCAgAAlDcA=
Date:   Tue, 30 Jul 2019 10:27:26 +0000
Message-ID: <MN2PR20MB2973F225CFE1CBA34C83ACFBCADC0@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <1564155069-18491-1-git-send-email-pvanleeuwen@verimatrix.com>
 <20190730081203.GB3108@kwain>
In-Reply-To: <20190730081203.GB3108@kwain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 68d14a26-061e-4cce-e191-08d714d884b3
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR20MB3088;
x-ms-traffictypediagnostic: MN2PR20MB3088:
x-ms-exchange-purlcount: 3
x-microsoft-antispam-prvs: <MN2PR20MB3088540C7E60068346B07807CADC0@MN2PR20MB3088.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0114FF88F6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(39850400004)(366004)(376002)(346002)(13464003)(189003)(199004)(55016002)(53936002)(446003)(76116006)(71200400001)(52536014)(66066001)(53546011)(478600001)(6436002)(6506007)(966005)(64756008)(66556008)(11346002)(7736002)(6306002)(229853002)(2906002)(14454004)(74316002)(26005)(66476007)(66946007)(66446008)(102836004)(3846002)(54906003)(316002)(110136005)(25786009)(81166006)(5660300002)(476003)(9686003)(6116002)(86362001)(99286004)(66574012)(256004)(68736007)(8676002)(76176011)(486006)(8936002)(81156014)(305945005)(6246003)(71190400001)(15974865002)(4326008)(33656002)(7696005)(186003)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB3088;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: cADfO89lFxvc7XZxAbeC77jtjzXnDYdgIptllkUS1T2kaf1gZ+Ygvyg+S9VmcavxworagCL6hs2kUlWzLJ7jR5/QBtr96SexZAAq5F0NWuv1PD/1cOuUTUNLeWhfevkShWuaQreGnaJksqKZ2kucUDuNvQEXo41gT83BoA4VygH54aQrGcMy1BsktKoEDChRmY75OLKPFdFrA2fd5WtRHEHZLQN6j08VTK+5rpADyGOdn+fP9SurO3Qvhvd81uiSV8O3sIjH5LjVjGFYA8msP5GXl3KWP279cJ7Tn9XA3TyweVQ1TgVM8O/rUBoeGNuv+cZRQhO3Pg10w/L3VaEbPRddg1z0vOtjMPnD3jo+3PiJJa1XWOiJmmvMX0vzggb0KTN5RHaEoXmRKzaSTwBrdOmthS8sO62CmSeu4epwg38=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68d14a26-061e-4cce-e191-08d714d884b3
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jul 2019 10:27:26.6638
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvanleeuwen@verimatrix.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB3088
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

-----Original Message-----
> From: Antoine Tenart <antoine.tenart@bootlin.com>
> Sent: Tuesday, July 30, 2019 10:12 AM
> To: Pascal van Leeuwen <pascalvanl@gmail.com>
> Cc: linux-crypto@vger.kernel.org; antoine.tenart@bootlin.com; herbert@gon=
dor.apana.org.au;
> davem@davemloft.net; Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
> Subject: Re: [PATCH] crypto: inside-secure - Fix null ptr derefence on rm=
mod for
> macchiatobin
>=20
> Hi Pascal,
>=20
> On Fri, Jul 26, 2019 at 05:31:09PM +0200, Pascal van Leeuwen wrote:
> > This small patch fixes a null pointer derefence panic that occurred whe=
n
> > unloading the driver (using rmmod) on macchiatobin due to not setting
> > the platform driver data properly in the probe routine.
> >
> > Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
>=20
> As this is a fix you should add a Fixes: tag so that the patch gets
> applied to stable trees. You can have a look at what this tag looks like
> at: https://www.kernel.org/doc/html/latest/process/submitting-patches.htm=
l
>=20
As you already figured out by now, this patch just fixes something
that was broken by one of my earlier patches (which has not been
applied just yet). So I don't think it applies to stable trees.

> > ---
> >  drivers/crypto/inside-secure/safexcel.c | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/i=
nside-
> secure/safexcel.c
> > index 45443bf..423ea2d 100644
> > --- a/drivers/crypto/inside-secure/safexcel.c
> > +++ b/drivers/crypto/inside-secure/safexcel.c
> > @@ -1274,6 +1274,8 @@ static int safexcel_probe(struct platform_device =
*pdev)
> >  	priv->dev =3D dev;
> >  	priv->version =3D (enum safexcel_eip_version)of_device_get_match_data=
(dev);
> >
> > +	platform_set_drvdata(pdev, priv);
> > +
>=20
> This is already done in safexcel_probe(), near the end of the function.
> I think you should remove the second call, to avoid setting the platform
> driver data twice.
>=20
Well, actually, my first patch that you are reviewing right now
accidentally removed that other call to platform_set_drvdata ...

> Out of curiosity, why calling platform_set_drvdata() earlier in the
> probe fixes unloading the driver with rmmod?
>=20
Not really. As long as it does get set somewhere :-)

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

