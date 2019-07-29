Return-Path: <SRS0=zv6R=V2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DF81C433FF
	for <linux-crypto@archiver.kernel.org>; Mon, 29 Jul 2019 16:10:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EACD1206BA
	for <linux-crypto@archiver.kernel.org>; Mon, 29 Jul 2019 16:10:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="aAX4BRTa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727534AbfG2QKt (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 29 Jul 2019 12:10:49 -0400
Received: from mail-eopbgr710052.outbound.protection.outlook.com ([40.107.71.52]:16275
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726869AbfG2QKt (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 29 Jul 2019 12:10:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FsR6LpSndulp8GT4ti1b0XT1M3w7LM2E9usj8mofG85/gFTWVba8LG0aOZhy3fuWOkxjauyd565djVGaqG24wSkiIvZxTjP1Qvmv0lrfthFLSlj+YcVNJB73SUqrWQndZnLwNzzQd2J77XH1kHCS84MHSOuvh3w9whSgGTyGtVKsTMaeFO6SETZG+SBpPvwpNEOmn5T+mWm/JqlCKfoaWr4xSSCcOEhiT4wmnQDtFWibN2sdV13wUegXz29/d0fBak1OX1bCeKzNaEgA3SvwXhl/cWKODkgtIBNwQZrbESwq+ugK+mfiDYPePNLNonwkKqAnMBxhi2MKaj7SVsnQhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VV1dTEM2ivHrNmmIJdl6PXfeJEl5rcbhbEgz9YNm10c=;
 b=ORYWvHpFP6+/UVuyEaIjWUNIPz9tlj9I+Fo+rFFdgnI/4Jj65xkndtgvbSCEH8VnJfY0OmMak68wJz6LpHazpLD9BSRrBgTBTb/hNWPEh0fFlPb7VzZhP92bXodD5ib+7P+4d5FZXohp/xs6XyLeu060qaFCit31hbDNMK0OJSI191iQVXyr6jjrPORCnWsxlF7t95jJvw6kPQNh7jfWk3iLg4t0mplx2rRK8Xo/0uvSMW8mgcvvgcM3vW+XVSjbPoVqW3klifSgAOUwV8RdmpDH+AK5QSIwvGTaOojXFGWSZS6nBFM7fT7f/Ur4C8lDH0msmdcVuEWbXs43Z8msBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=verimatrix.com;dmarc=pass action=none
 header.from=verimatrix.com;dkim=pass header.d=verimatrix.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VV1dTEM2ivHrNmmIJdl6PXfeJEl5rcbhbEgz9YNm10c=;
 b=aAX4BRTaUqlucMsPLHEyLUgLgajq7IFk/HpTYoCM8pTifPm4vsDrkytefFN0vzyG5JjPUmmzS7GXZ4C1SQPJH9rOpANYvKpDjqPZ0sdLPZ1zz0IAjYMZ3DIQRrVt0roYUpXkEHOXYQRanGnwVYZhjizsGJ70NBnG1hKkRnUCsuA=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB2365.namprd20.prod.outlook.com (20.179.146.27) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.14; Mon, 29 Jul 2019 16:10:07 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1%7]) with mapi id 15.20.2115.005; Mon, 29 Jul 2019
 16:10:07 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Pascal van Leeuwen <pascalvanl@gmail.com>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [PATCH] crypto: testmgr - Improve randomization of params for
 AEAD fuzz testing
Thread-Topic: [PATCH] crypto: testmgr - Improve randomization of params for
 AEAD fuzz testing
Thread-Index: AQHVQgvgfaiGsuGw40GmRhVVq3++o6bgUEIAgAD6YHCAAH8wsA==
Date:   Mon, 29 Jul 2019 16:10:06 +0000
Message-ID: <MN2PR20MB2973D5FCC4F9724833FB8DADCADD0@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <1563960917-8236-1-git-send-email-pvanleeuwen@verimatrix.com>
 <20190728173040.GA699@sol.localdomain>
 <MN2PR20MB29737962BC74CCA790470C0BCADD0@MN2PR20MB2973.namprd20.prod.outlook.com>
In-Reply-To: <MN2PR20MB29737962BC74CCA790470C0BCADD0@MN2PR20MB2973.namprd20.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 17537149-6268-4d7c-b3e7-08d7143f393f
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR20MB2365;
x-ms-traffictypediagnostic: MN2PR20MB2365:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MN2PR20MB236586B3CAF9F5D7DAC692F4CADD0@MN2PR20MB2365.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 01136D2D90
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(136003)(39850400004)(366004)(396003)(199004)(189003)(13464003)(76116006)(478600001)(81156014)(81166006)(66066001)(76176011)(7696005)(256004)(11346002)(8676002)(33656002)(186003)(52536014)(4326008)(66556008)(66476007)(66946007)(64756008)(66446008)(55016002)(476003)(74316002)(5660300002)(9686003)(71200400001)(71190400001)(446003)(25786009)(26005)(486006)(53936002)(15974865002)(6116002)(3846002)(2940100002)(6436002)(7736002)(68736007)(8936002)(102836004)(305945005)(99286004)(53546011)(86362001)(6246003)(110136005)(54906003)(316002)(6506007)(229853002)(2906002)(14454004)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB2365;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: tpZ7+MpstIb9d9RM46UHZFCh+aXgCajPhVh6MCEyOUYWhGbIjwFLq5OHNa5DjGvFhgl3IIvbaQFvPbtlJd/Ha6CeyBYTlNnFOVcHkUQk5twT5qHzd/a/oAPdJ2Alk7mMVPSdl+HlPpWcLuAeNqJqfRN/9B/xrmWW57O3d5nWXK08oazz1z7ZdneSrpQPZGZR2iSmMbRIbek8OWJtfK19x6pG5MqAotjh6NJ/ht/b8GR5vzH1ZtgA+FBZxRM9dzKOHiOK398EJBjQTWwm/DXFeFiY/0O820AZ47waaXclIUtWcQhcyYEyhZNpT2Rwqojkblh/N6HIVxmGGIJrtGLYEN4M4L4mmp7+GDh586Z5rOYjaY/jNapEzX2+hzPgdT60V9N3er6sOeAj3RdwEvwaIcHtYimFQdWDdE0qR33JVYY=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17537149-6268-4d7c-b3e7-08d7143f393f
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jul 2019 16:10:06.8408
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvanleeuwen@verimatrix.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB2365
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Eric,

> -----Original Message-----
> From: linux-crypto-owner@vger.kernel.org <linux-crypto-owner@vger.kernel.=
org> On Behalf Of
> Pascal Van Leeuwen
> Sent: Monday, July 29, 2019 11:11 AM
> To: Eric Biggers <ebiggers@kernel.org>; Pascal van Leeuwen <pascalvanl@gm=
ail.com>
> Cc: linux-crypto@vger.kernel.org; herbert@gondor.apana.org.au; davem@dave=
mloft.net
> Subject: RE: [PATCH] crypto: testmgr - Improve randomization of params fo=
r AEAD fuzz
> testing
>=20
> Hi Eric,
>=20
> Thanks for your feedback!
>=20
> > -----Original Message-----
> > From: Eric Biggers <ebiggers@kernel.org>
> > Sent: Sunday, July 28, 2019 7:31 PM
> > To: Pascal van Leeuwen <pascalvanl@gmail.com>
> > Cc: linux-crypto@vger.kernel.org; herbert@gondor.apana.org.au; davem@da=
vemloft.net;
> Pascal Van Leeuwen
> > <pvanleeuwen@verimatrix.com>
> > Subject: Re: [PATCH] crypto: testmgr - Improve randomization of params =
for AEAD fuzz
> testing
> > >
> > > +struct len_range_set {
> > > +	const struct len_range_sel *lensel;
> > > +	unsigned int count;
> > > +};
> > > +
> > >  struct aead_test_suite {
> > >  	const struct aead_testvec *vecs;
> > >  	unsigned int count;
> > >  };
> > >
> > > +struct aead_test_params {
> > > +	struct len_range_set ckeylensel;
> > > +	struct len_range_set akeylensel;
> > > +	struct len_range_set authsizesel;
> > > +	struct len_range_set aadlensel;
> > > +	struct len_range_set ptxtlensel;
> > > +};
> > > +
> > >  struct cipher_test_suite {
> > >  	const struct cipher_testvec *vecs;
> > >  	unsigned int count;
> > > @@ -143,6 +156,10 @@ struct alg_test_desc {
> > >  		struct akcipher_test_suite akcipher;
> > >  		struct kpp_test_suite kpp;
> > >  	} suite;
> > > +
> > > +	union {
> > > +		struct aead_test_params aead;
> > > +	} params;
> > >  };
> >
> > Why not put these new fields in the existing 'struct aead_test_suite'?
> >
> > I don't see the point of the separate 'params' struct.  It just confuse=
s things.
> >
> Mostly because I'm not that familiar with C datastructures (I'm not a pro=
grammer
> and this is pretty much my first serious experience with C), so I didn't =
know how
> to do that / didn't want to break anything else :-)
>=20
> So if you can provide some example on how to do that ...
>=20
Actually, while looking into some way to combine these fields into=20
'struct aead_test_suite':  I really can't think of a way to do that that
would be as convenient as the current approach which allows me to:

- NOT have these params for the other types (cipher, comp, hash etc.), at
  least for now
- NOT have to touch any declarations in the alg_test_desc assignment that
  do not need this
- conveniently use a macro line __LENS (idea shamelessly borrowed from
  __VECS) to assign the struct ptr / list length fields pairs

If you know of a better way to achieve all that, then feel free to teach
me. But, frankly I do not see why having 1 entry defining the testsuite=20
and  a seperate entry defining the fuzz test parameters would necessarily
be confusing? Apart from 'params' perhaps not being a really good name,=20
being too generic and all, 'fuzz_params' would probably be better?

> > - Eric
>=20
> Regards,
> Pascal van Leeuwen
> Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
> www.insidesecure.com

Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com
