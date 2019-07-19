Return-Path: <SRS0=r9n1=VQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC74CC7618F
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Jul 2019 20:49:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7236B2186A
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Jul 2019 20:49:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="tDUI3iSF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728774AbfGSUtG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 19 Jul 2019 16:49:06 -0400
Received: from mail-eopbgr770043.outbound.protection.outlook.com ([40.107.77.43]:46499
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728525AbfGSUtG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 Jul 2019 16:49:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JNbFXopiN25ONA8atkmTRf+OKOP2zE5z1RKqeGRbY73Y8yx31tOfoAOHX7iUfGXAfm6MdyGP5XOmaADQ3Gp/V9tm4j/6GIKcanOqB7o1TnD1HI5mBl5RxLFNuDWAStAok3t8994azzmlWyQh4Q/fHJ+bcwJCnrb2xZJCBYVxM1qF2beJ5eMe1DWQVcWq7o5SbdClUwzpcWBySjF2VurVClczsZ44DglXrQeqUN9xLYTwSQ5XZEgO11miwr7w59Nc5yL6EIjWX/gR7kvfXfQUko1IBHwm1Wq6e+tAFRcgT1HFdWREqHO2C7WJCdwfzrGUXStQYt1jyenP70x/CJgoRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s4b+DpPvVU8+pKLIj2KwP5co8hVHzam4vTZxJdy/i84=;
 b=JjUwjam8IaHN+hJegpc4vRXaASgT3eDVRIjff0YTY65FhOhpGI0oi65azH3C4FiMpqCCfqGulFc+GMI2j8+iNt3kO1BaKb9oYHQRwH36nbmydNwVt2Cs3EXN5Y553XEvx8yTBWxoA4/VDGP+Rqk8QJ0667fH2+bdHQR1hP9PL/tbS8e8WVinVvt0rX5KKftOuaOy/Ds3B45ReWQLRhlHM/8URIqKEjS/KXzp3tXNdMNdpzBn4wRMsaw8OLnrfhgK5LwqAS9w6lsAeMdwtmR+lsLeIpzFFn9rf/x4g5FFphj0a6jmCF91hzDt5q85WNzBI4Ev/8RpBmhBAURf942S+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=verimatrix.com;dmarc=pass action=none
 header.from=verimatrix.com;dkim=pass header.d=verimatrix.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s4b+DpPvVU8+pKLIj2KwP5co8hVHzam4vTZxJdy/i84=;
 b=tDUI3iSFr0/gEY+RCF7POGNnQTh1YFx9z7ppBXXIL42bFAKWA/7gez7gc/AV+TWzwdvCWAvTOjM1pTrIWSzdb68TQ+nRqhyp3tvM3k8a9e1I4avPj5ccYGTJGh72RM7Eg0Ns0AdD/eT2mCcBnZT7um7QeoN07Lq2cjNYdq1jEAI=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB3021.namprd20.prod.outlook.com (52.132.173.78) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2073.14; Fri, 19 Jul 2019 20:49:03 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::68d7:2bbb:af61:2e69]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::68d7:2bbb:af61:2e69%6]) with mapi id 15.20.2094.013; Fri, 19 Jul 2019
 20:49:03 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Eric Biggers <ebiggers@kernel.org>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: ghash
Thread-Topic: ghash
Thread-Index: AdU+OcccbSpphUQDQMqR1uphPmes/wAE33+AAAYsZgAAAYlpgAAAwhCg
Date:   Fri, 19 Jul 2019 20:49:02 +0000
Message-ID: <MN2PR20MB2973FF077218AB3C2DF2E4A0CACB0@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <MN2PR20MB29737F1F60B3CBACBC4BD287CACB0@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190719161606.GA1422@gmail.com>
 <MN2PR20MB297309BE544695C1B7B3CB21CACB0@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190719195652.GC1422@gmail.com>
In-Reply-To: <20190719195652.GC1422@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0d429048-2641-41fa-d655-08d70c8a888b
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR20MB3021;
x-ms-traffictypediagnostic: MN2PR20MB3021:
x-ms-exchange-purlcount: 2
x-microsoft-antispam-prvs: <MN2PR20MB30218B11F86399797E99CCE2CACB0@MN2PR20MB3021.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 01039C93E4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39850400004)(396003)(376002)(346002)(366004)(136003)(189003)(199004)(13464003)(8676002)(76116006)(66446008)(7696005)(3846002)(64756008)(66476007)(66066001)(66556008)(66946007)(55016002)(76176011)(186003)(221733001)(52536014)(6116002)(6506007)(4326008)(26005)(102836004)(53546011)(486006)(8936002)(68736007)(14454004)(6306002)(476003)(81156014)(25786009)(446003)(81166006)(6436002)(478600001)(53936002)(9686003)(14444005)(3480700005)(71200400001)(15974865002)(2906002)(99286004)(7736002)(7116003)(256004)(6246003)(74316002)(54906003)(5660300002)(966005)(11346002)(229853002)(6916009)(86362001)(33656002)(305945005)(316002)(71190400001)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB3021;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: r+g6LGR2+Y0jTNgICezULNVo3lSGP7lSMNqpjBhnELXuNluE8r3hyDu6N+KZ4oF4zBiozV2BQLFVNX5OKnMtkPdof7HrvRad38AjmiE3cJfe1MULOAN/DQnt7T9mVJCh0IJ+UUw29aMsleVwW95ucliB/Nex6LdodkQdKrQbtkA6qEKVIxobxZdRsxu6BSn6R5d6VWBhFI93dum6u/SGr6z0p7Cj6/UnsHy7QDS/YupykmObMnOBh+4l33tIC+JMSOQI5a4DUHTBx1qnHvUpAr8nF+Q7q1MvH0m6fmUup5qhXsgRrdmNTImIBU2QNqHD+de/b19zJhvzwj/srdew9dAp/fPpKhGBCv5H2Yvaok3HIGdI6Bns+b5Klw1KMmR70xPkHcIdz4JrS8hPEpgq6aFR5uuR5gpTF87rfN0QFzo=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d429048-2641-41fa-d655-08d70c8a888b
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jul 2019 20:49:02.9641
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvanleeuwen@verimatrix.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB3021
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Eric,

> -----Original Message-----
> From: linux-crypto-owner@vger.kernel.org <linux-crypto-owner@vger.kernel.=
org> On Behalf Of Eric Biggers
> Sent: Friday, July 19, 2019 9:57 PM
> To: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
> Cc: linux-crypto@vger.kernel.org; Herbert Xu <herbert@gondor.apana.org.au=
>; davem@davemloft.net
> Subject: Re: ghash
>=20
> Hi Pascal,
>=20
> On Fri, Jul 19, 2019 at 07:26:02PM +0000, Pascal Van Leeuwen wrote:
> > > -----Original Message-----
> > > From: linux-crypto-owner@vger.kernel.org <linux-crypto-owner@vger.ker=
nel.org> On Behalf Of Eric Biggers
> > > Sent: Friday, July 19, 2019 6:16 PM
> > > To: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
> > > Cc: linux-crypto@vger.kernel.org; Herbert Xu <herbert@gondor.apana.or=
g.au>; davem@davemloft.net
> > > Subject: Re: ghash
> > >
> > > On Fri, Jul 19, 2019 at 02:05:01PM +0000, Pascal Van Leeuwen wrote:
> > > > Hi,
> > > >
> > > > While implementing GHASH support for the inside-secure driver and w=
ondering why I couldn't get
> > > > the test vectors to pass I have come to the conclusion that ghash-g=
eneric.c actually does *not*
> > > > implement GHASH at all. It merely implements the underlying chained=
 GF multiplication, which,
> > > > I understand, is convenient as a building block for e.g. aes-gcm bu=
t is is NOT the full GHASH.
> > > > Most importantly, it does NOT actually close the hash, so you can t=
rivially add more data to the
> > > > authenticated block (i.e. the resulting output cannot be used direc=
tly without external closing)
> > > >
> > > > GHASH is defined as GHASH(H,A,C) whereby you do this chained GF mul=
tiply on a block of AAD
> > > > data padded to 16 byte alignment with zeroes, followed by a block o=
f ciphertext padded to 16
> > > > byte alignment with zeroes, followed by a block that contains both =
AAD and cipher length.
> > > >
> > > > See also https://en.wikipedia.org/wiki/Galois/Counter_Mode
> > > >
> > > > Regards,
> > > > Pascal van Leeuwen
> > > > Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
> > > > www.insidesecure.com
> > > >
> > >
> > > Yes that's correct.  The hash APIs don't support multi-argument hashe=
s, so
> > > there's no natural way for it to be "full GHASH".  So it relies on th=
e caller to
> > > format the AAD and ciphertext into a single stream.  IMO it really sh=
ould be
> > > called something like "ghash_core".
> > >
> > > Do you have some question or suggestion, or was this just an observat=
ion?
> > >
> > Well, considering it's pretending to be GHASH I was more less consideri=
ng this a bug report ...
> >
> > There's the inherent danger that someone not aware of the actual implem=
entation tries to
> > use it as some efficient (e.g. due to instruction set support) secure a=
uthentication function.
> > Which, without proper external data formatting, it's surely not in its =
current form. This is
> > not something you will actually notice when just using it locally for s=
omething (until
> > someone actually breaks it).
>=20
> You do understand that GHASH is not a MAC, right?  It's only a universal
> function. =20
>
It's a universal keyed hash. Which you could use as a MAC, although, admitt=
edly,
it would be rather weak, which is why the tag is usually additionally encry=
pted.
(which you could do externally, knowing that that's needed with GHASH)
In any case, the crypto API's ghash does not do what you would expect of a =
GHASH.

> Specifically, "almost-epsilon-XOR-universal".  So even if there was a
> more natural API to access GHASH, it's still incorrect to use it outside =
of a
> properly reviewed crypto mode of operation.  IOW, anyone using GHASH dire=
ctly as
> a MAC is screwed anyway no matter which API they are using, or misusing.
>=20
"Anyone" may actually know what they're doing. But rely on ghash being GHAS=
H ...
So this is a rather lame argument.

> >
> > And then there was the issue of wanting the offload it to hardware, but=
 that's kind of hard
> > if the software implementation does not follow the spec where the hardw=
are does ...
> >
> > I think more care should be taken with the algorithm naming - if it has=
 a certain name,
> > you expect it to follow the matching specification (fully). I have alre=
ady identified 2 cases
> > now (xts and ghash) where that is not actually the case.
> >
>=20
> If you take an (AD, Ctext) pair and format it into a single data stream t=
he way
> the API requires, then you will get the result defined by the specificati=
on.  So
> it does follow the specification as best it can given the API which takes=
 a
> single data stream.  As I said though, I think "ghash_core" would be a be=
tter
> name.  Note that it was added 10 years ago; I'm not sure it can actually =
be
> renamed, but there may be a chance since no one should be using it direct=
ly.
>=20
Ok, I understand that it's legacy so maybe we should keep it as is.
It's terribly confusing though - I spent days trying to get my acceleration=
 to
work (i.e. pass testmgr) only to realise after reverse engineering the gene=
ric=20
implementation that it's not really ghash at all.

I guess the real problem is that this information can currently only be=20
obtained by fully reverse engineering the implementation. And I'm a firm
believer in the natural order of things: programmers write code, compilers=
=20
read code, not the other way around ...

> So are you proposing that it be renamed?  Or are you proposing that a mul=
ti
> argument hashing API be added?  Or are you proposing that universal funct=
ions
> not be exposed through the crypto API?  What specifically is your constru=
ctive
> suggestion to improve things?
>=20
I guess my constructive suggestion *for the future* would be to be more car=
eful
with the naming. Don't give something a "known" name if it does not comply =
with
the matching specification. Renaming stuff now is probably counter-producti=
ve,
but putting some remarks somewhere (near the actual test vectors may work?)
about implementation x not actually being known entity X would be nice.
(Or even just some reference on where the test vectors came from!)

Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com

