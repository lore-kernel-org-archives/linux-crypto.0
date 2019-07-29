Return-Path: <SRS0=zv6R=V2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58464C433FF
	for <linux-crypto@archiver.kernel.org>; Mon, 29 Jul 2019 22:31:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 231D0206DD
	for <linux-crypto@archiver.kernel.org>; Mon, 29 Jul 2019 22:31:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="C743H7qm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727959AbfG2Wbp (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 29 Jul 2019 18:31:45 -0400
Received: from mail-eopbgr710041.outbound.protection.outlook.com ([40.107.71.41]:63488
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726937AbfG2Wbp (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 29 Jul 2019 18:31:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P7XFsCY0cpKn65ws0sEpu1bCUIZbdjlCnREbpWiJs/7DvgCM2t02TH50D25M5nWvsvwC0FnO8uYCjNftA4jCNBILjh6d/Q7xeTzivooBvUz2toYXuo1Ce/z7E9c5edt4xQASaEuTmN/FVNJfCVhYMPFNdgDVHsv9cKToM0KTu8HMtC/m+e0HgwguUCTe4u3iHM1IPZ/8AOwKbdMV80x3lP8vZ1EEqpACpYoaQvbR54HcaaRxDwEU5FJlarr6p9M/1nF+TRJHKs7lJt+d4zcJSTRfPzEDmL/3JZ8kGk7KdqQs0U4f5RyhhdWDbKpoW1IPePh2FWKgEct28zyIpKWrsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P8Ozki8DTtNsNoFOjsPWg/ogWoAO5ERRDl2Pfdcewdo=;
 b=fjdaYte7zRrNAppYb7OudbQo6gsRqZLDVNY4n8ZnrLBawWT9eA6XiHfenDW/hJyD3RCudt1RODXprTEd3jjpaTA7tYgjxMi1fAHWagLB3vNXuJwWZcwX+AYVck9ebjZhevxep8AjLk0BbU4vWCA2kVfCiS600RaXosxY506LbAhtnAC7D1Ht/JBBxNO7j+Ye/hnd0Z+rpfv7UVft42cyYz5qV3lCfpfZPyCadCC+pFrwHhFc0Ggv/AKzVjcGdxzPVEZtPw7c4zLmqUWxBWPUwRenW2qi9zxHvjAcLYTq0n7es//E2DhW2CcjeVDKNM7jC/afsf92rpvwgz1hF51nVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=verimatrix.com;dmarc=pass action=none
 header.from=verimatrix.com;dkim=pass header.d=verimatrix.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P8Ozki8DTtNsNoFOjsPWg/ogWoAO5ERRDl2Pfdcewdo=;
 b=C743H7qmdkXsUS76Xgo6M0Kj4ihQOwnCJcpouzd8pZCEX5ozUum4Qc203ZH24AxhA+oXNtTdg3X2GH8/Kes+4dNZi18fCfo2bUvEux3b/hov6XmL0KiGRE86nW+WAICvZ8Ag8LGNgEQgjDqBxOUdOedSDjfBWC7bka7yrGb4OY4=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB2912.namprd20.prod.outlook.com (10.255.7.33) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.16; Mon, 29 Jul 2019 22:31:40 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1%7]) with mapi id 15.20.2115.005; Mon, 29 Jul 2019
 22:31:40 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Eric Biggers <ebiggers@kernel.org>
CC:     Pascal van Leeuwen <pascalvanl@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [PATCH] crypto: testmgr - Improve randomization of params for
 AEAD fuzz testing
Thread-Topic: [PATCH] crypto: testmgr - Improve randomization of params for
 AEAD fuzz testing
Thread-Index: AQHVQgvgfaiGsuGw40GmRhVVq3++o6bgUEIAgAD6YHCAAH8wsIAAJ3QAgABBfZA=
Date:   Mon, 29 Jul 2019 22:31:40 +0000
Message-ID: <MN2PR20MB297313D5D2CF1E8D33CB5C71CADD0@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <1563960917-8236-1-git-send-email-pvanleeuwen@verimatrix.com>
 <20190728173040.GA699@sol.localdomain>
 <MN2PR20MB29737962BC74CCA790470C0BCADD0@MN2PR20MB2973.namprd20.prod.outlook.com>
 <MN2PR20MB2973D5FCC4F9724833FB8DADCADD0@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190729182313.GC169027@gmail.com>
In-Reply-To: <20190729182313.GC169027@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bc1f2405-5090-49f5-5a24-08d7147486f8
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR20MB2912;
x-ms-traffictypediagnostic: MN2PR20MB2912:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MN2PR20MB29121643CDA213FC7CFFC029CADD0@MN2PR20MB2912.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 01136D2D90
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(39850400004)(376002)(136003)(346002)(366004)(199004)(189003)(13464003)(66556008)(81156014)(11346002)(86362001)(55016002)(68736007)(6916009)(4326008)(478600001)(9686003)(446003)(476003)(25786009)(6506007)(229853002)(6436002)(2906002)(33656002)(486006)(76176011)(15974865002)(102836004)(7696005)(76116006)(8676002)(66066001)(305945005)(256004)(54906003)(64756008)(316002)(6116002)(7736002)(53546011)(52536014)(3846002)(66946007)(66476007)(81166006)(71190400001)(26005)(99286004)(8936002)(71200400001)(6246003)(66446008)(74316002)(186003)(53936002)(14454004)(5660300002)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB2912;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: K+v6oTqnjfK5JN04CTdUuNw6GWmbfz6MWezmj43/+/sOm10wzttgkRjSJDCJoXwkr+zprP3lm0YkRlX5K0JtgVC4PhleLd6nXHRWQa5JVyapSqdqxOGFn9/AT9HtOwj1SCqnbufKCaZJiv9+aUTgfIlfRRKtsWZvDZulj3umSrXynoMQmx/aHE2YA8201R4jIzHzUCImHZ8NreF2yMVAQVlIlrUpKH+jX8JsORbnq6WlVOcgnGC9KHm9/PfT7KbzsizoZBi+Z3GWnK+DxTBsSwYwxAP1Y4f/YcHo0JMI4jR8FqEVb4wvp0kko9s6iQIGP/K4Cct6zqTthrPQAXMwGS2O5TB/bLQWrf7XEqSEjNRFZRj6w4fkYCqWs2TpoQlk45pu2E0PKcQwN3z4AVIYyKl23UVK2lnpMiR58P3gAEM=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc1f2405-5090-49f5-5a24-08d7147486f8
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jul 2019 22:31:40.8180
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvanleeuwen@verimatrix.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB2912
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> -----Original Message-----
> From: Eric Biggers <ebiggers@kernel.org>
> Sent: Monday, July 29, 2019 8:23 PM
> To: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
> Cc: Pascal van Leeuwen <pascalvanl@gmail.com>; linux-crypto@vger.kernel.o=
rg;
> herbert@gondor.apana.org.au; davem@davemloft.net
> Subject: Re: [PATCH] crypto: testmgr - Improve randomization of params fo=
r AEAD fuzz testing
>=20
> On Mon, Jul 29, 2019 at 04:10:06PM +0000, Pascal Van Leeuwen wrote:
> > Hi Eric,
> >
> > > -----Original Message-----
> > > From: linux-crypto-owner@vger.kernel.org <linux-crypto-owner@vger.ker=
nel.org> On Behalf
> Of
> > > Pascal Van Leeuwen
> > > Sent: Monday, July 29, 2019 11:11 AM
> > > To: Eric Biggers <ebiggers@kernel.org>; Pascal van Leeuwen <pascalvan=
l@gmail.com>
> > > Cc: linux-crypto@vger.kernel.org; herbert@gondor.apana.org.au; davem@=
davemloft.net
> > > Subject: RE: [PATCH] crypto: testmgr - Improve randomization of param=
s for AEAD fuzz
> > > testing
> > >
> > > Hi Eric,
> > >
> > > Thanks for your feedback!
> > >
> > > > -----Original Message-----
> > > > From: Eric Biggers <ebiggers@kernel.org>
> > > > Sent: Sunday, July 28, 2019 7:31 PM
> > > > To: Pascal van Leeuwen <pascalvanl@gmail.com>
> > > > Cc: linux-crypto@vger.kernel.org; herbert@gondor.apana.org.au; dave=
m@davemloft.net;
> > > Pascal Van Leeuwen
> > > > <pvanleeuwen@verimatrix.com>
> > > > Subject: Re: [PATCH] crypto: testmgr - Improve randomization of par=
ams for AEAD fuzz
> > > testing
> > > > >
> > > > > +struct len_range_set {
> > > > > +	const struct len_range_sel *lensel;
> > > > > +	unsigned int count;
> > > > > +};
> > > > > +
> > > > >  struct aead_test_suite {
> > > > >  	const struct aead_testvec *vecs;
> > > > >  	unsigned int count;
> > > > >  };
> > > > >
> > > > > +struct aead_test_params {
> > > > > +	struct len_range_set ckeylensel;
> > > > > +	struct len_range_set akeylensel;
> > > > > +	struct len_range_set authsizesel;
> > > > > +	struct len_range_set aadlensel;
> > > > > +	struct len_range_set ptxtlensel;
> > > > > +};
> > > > > +
> > > > >  struct cipher_test_suite {
> > > > >  	const struct cipher_testvec *vecs;
> > > > >  	unsigned int count;
> > > > > @@ -143,6 +156,10 @@ struct alg_test_desc {
> > > > >  		struct akcipher_test_suite akcipher;
> > > > >  		struct kpp_test_suite kpp;
> > > > >  	} suite;
> > > > > +
> > > > > +	union {
> > > > > +		struct aead_test_params aead;
> > > > > +	} params;
> > > > >  };
> > > >
> > > > Why not put these new fields in the existing 'struct aead_test_suit=
e'?
> > > >
> > > > I don't see the point of the separate 'params' struct.  It just con=
fuses things.
> > > >
> > > Mostly because I'm not that familiar with C datastructures (I'm not a=
 programmer
> > > and this is pretty much my first serious experience with C), so I did=
n't know how
> > > to do that / didn't want to break anything else :-)
> > >
> > > So if you can provide some example on how to do that ...
> > >
> > Actually, while looking into some way to combine these fields into
> > 'struct aead_test_suite':  I really can't think of a way to do that tha=
t
> > would be as convenient as the current approach which allows me to:
> >
> > - NOT have these params for the other types (cipher, comp, hash etc.), =
at
> >   least for now
>=20
> > - NOT have to touch any declarations in the alg_test_desc assignment th=
at
> >   do not need this
> > - conveniently use a macro line __LENS (idea shamelessly borrowed from
> >   __VECS) to assign the struct ptr / list length fields pairs
> >
> > If you know of a better way to achieve all that, then feel free to teac=
h
> > me. But, frankly I do not see why having 1 entry defining the testsuite
> > and  a seperate entry defining the fuzz test parameters would necessari=
ly
> > be confusing? Apart from 'params' perhaps not being a really good name,
> > being too generic and all, 'fuzz_params' would probably be better?
> >
>=20
> Doesn't simply putting the fields in 'struct aead_test_suite' work?
>=20
Depends on your definition of "work". Obviously, you could define the data
structure like that and eventually make it work. But it would make the=20
initialization of it a lot less convenient. Or at least, with my limited C
coding skills, I don't see how to make it as convenient as it is now.
So it would require a lot of work on rewriting that part of the code, for
zero actual benefit (IMHO).

But actual *implementation* suggestions are welcome ...

> The reason the current approach confuses me is that it's unclear what sho=
uld go
> in the aead_test_suite and what should go in the aead_test_params, both n=
ow and
> in the future as people add new stuff.  They seem like the same thing to =
me.
>=20
aead_test_suite is the actual fixed test suite
fuzz_params are the parameters for fuzz testing

Frankly, I fail to see what would be so confusing about that, compared to
most other stuff I've seen that certainly wasn't immediately obvious to me.
Of course, some comments to further clarify could be added.

> - Eric

Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com
