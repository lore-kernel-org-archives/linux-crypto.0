Return-Path: <SRS0=XUD9=VU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFF12C7618F
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Jul 2019 00:56:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9997F2199C
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Jul 2019 00:56:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="rHUX3aVF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726312AbfGWA4o (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 22 Jul 2019 20:56:44 -0400
Received: from mail-eopbgr750055.outbound.protection.outlook.com ([40.107.75.55]:10373
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730587AbfGWA4o (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 22 Jul 2019 20:56:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jx/NSMLhuopW0KKZUcdoxDIjpu9QAaW44yOWtU4hxe2V8rt7J23UedomjGbg1dVgGab6LwTl7hZztXQTSt4oKoc2JnOy7FkdqNZ1urHYLDkPX4Q4q4p00aOxZZyQ21GsKXuE/8bGmthVEuo+/IsJO+HMYd+Re19avDaD9zrydDfmQAY9hLYBhlI435V99pScvy5t27/c8GheVSQWV4TlsxnXpbwpm8UZtE8qqhafognjjzaUlOOQmsZ4FC8f8PMRdsYI5sJudDaFblZEzLW+NX9np65nSWpy3hk0HOuz/DAoKyHaM3//Eg8dX0sGjyIDU/PP90FeMn0eUv5JfVzWVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HGnX13bFQMDogtJsZohxJDjCsC0/Uv6bITx4zbFdIlQ=;
 b=nBWYhgvO5yJCDwDptCDWq7ngva/wdcW+3TifTW6bblArlhgljBqf4tiG2XmB1DywIU/Y+nw9zKunPgohowZAo2LReWsGqSDHUYx4dJnXoT5o/iVkpICYkKQgrRr9G5BJpieemBKummtekBnm5yz3WGy0YdQa6YsMhJ/hzLbyNfUKx05dp2Sz8VIB/aWCU6+aA9wMP5v4rOUiDQrkCSPxphvyL5exQklCp+j3DPjw4TVGpE5UC7z7lGbkxy1k8EJawjiqYi86hNzPuQGvj4MNUlYMuoFjXMOLzyoKC6Lico4ih+JoylWSVjK0g1accJCEwmgO/qiDEJqsWvbEJ3Bacw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=verimatrix.com;dmarc=pass action=none
 header.from=verimatrix.com;dkim=pass header.d=verimatrix.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HGnX13bFQMDogtJsZohxJDjCsC0/Uv6bITx4zbFdIlQ=;
 b=rHUX3aVFe0shpC4EGYHtmhHvBIrJ2TvxXOX5ai5URwDWmN0wcQ75yo9K7OVshcVn85z6/aJP/C2u4SDDDQZm3bVH8G+6S3GpoX+kC+Zl5NsjKOwDuG3TYpgO+qCrkxHeR2xT33iUe6dqOx5WrZlXWRJg60+KrqIxmlU9vM8plUw=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB3231.namprd20.prod.outlook.com (52.132.175.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.14; Tue, 23 Jul 2019 00:56:36 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::68d7:2bbb:af61:2e69]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::68d7:2bbb:af61:2e69%6]) with mapi id 15.20.2094.017; Tue, 23 Jul 2019
 00:56:36 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Eric Biggers <ebiggers@kernel.org>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: Testmgr fuzz testing
Thread-Topic: Testmgr fuzz testing
Thread-Index: AdVAdUj98zKx4A/DSr+aRU+NlJJ9GQAMhNWAAAk8USAABXSXAAAARZlg
Date:   Tue, 23 Jul 2019 00:56:36 +0000
Message-ID: <MN2PR20MB297309E29BFDFA5C6377BEBECAC70@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <MN2PR20MB2973F2047FCE9EA5794E7DF7CAC40@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190722160603.GA689@sol.localdomain>
 <MN2PR20MB2973E558C4C8732708EF3A06CAC40@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190722230641.GA22126@gmail.com>
In-Reply-To: <20190722230641.GA22126@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8850dfbe-337c-403b-b024-08d70f089d0b
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR20MB3231;
x-ms-traffictypediagnostic: MN2PR20MB3231:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MN2PR20MB3231082E3370316C634D53ABCAC70@MN2PR20MB3231.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 0107098B6C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(136003)(346002)(396003)(376002)(39850400004)(189003)(52314003)(13464003)(199004)(476003)(186003)(446003)(11346002)(53546011)(102836004)(76176011)(26005)(6506007)(316002)(66556008)(71190400001)(5660300002)(99286004)(54906003)(7696005)(52536014)(3846002)(33656002)(14454004)(25786009)(256004)(6116002)(66476007)(66446008)(71200400001)(478600001)(64756008)(30864003)(3480700005)(86362001)(14444005)(66946007)(76116006)(6436002)(6246003)(2906002)(15974865002)(74316002)(7736002)(55016002)(8936002)(81166006)(81156014)(305945005)(66066001)(68736007)(229853002)(486006)(7116003)(6916009)(4326008)(53936002)(8676002)(9686003)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB3231;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: wdLojr/mgG31qNuL1//NcOVEW0rc9ERgYop3Ukq4WBTCdkSm4rWDFsDN7F+RE0kLUrglU7AtBNAwji6ujSbbcriV1GfdrCHOciaKtZQgDFVNKTrSoRZxfCk7yWQBpQZ/d3VuWQlKWbWP8yxSMFFyrkunog4kSSahLHJSzvftU1h7OL6cHWEAEcEd9rLjvY7SVnrqkPfkAZHfd8dek0d2dr5+Vk57NYo43esICfqB1RovuZfGrVsTWg6n0URAQ9g+QPBEm1gvREomqcWZdQfmDmvV6l+EjOUNF7Vt8UH4bWOJ3f5IdzR9+fI4nEH8Kw7tNRAIVra/lRlBIrU63ejf+VAwL1mZ19rrgYkdB6Jtbx7ermZiaTho2DgLbTVD6YhbzpogugCLGRl57RSses505lZNAAueKXT1txdu+Pw+uYM=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8850dfbe-337c-403b-b024-08d70f089d0b
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2019 00:56:36.3169
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvanleeuwen@verimatrix.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB3231
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> -----Original Message----
> From: Eric Biggers <ebiggers@kernel.org>
> Sent: Tuesday, July 23, 2019 1:07 AM
> To: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
> Cc: linux-crypto@vger.kernel.org; Herbert Xu <herbert@gondor.apana.org.au=
>; davem@davemloft.net
> Subject: Re: Testmgr fuzz testing
>=20
> > >
> > > Sure, it's not always repeatable, but that's the nature of fuzz testi=
ng.
> > >
> > No. It's not repeatable *at all*. The odds of getting the exact same se=
quence of random
> > numbers should approach zero, assuming that random generator is half de=
cent and
> > properly seeded with another (true?) random value.
> >
> > For us hardware engineers, (constrained) random testing is our bread an=
d butter.
> > Given the design complexity we're dealing with today and the fact that =
any serious bug may
> > actually put us out of business (considering mask costs and respin turn=
around), it's the only
> > way to cope. So I have many years of experience and I can assure you th=
at being "not always
> > repeatable" does not NEED to be the "nature of fuzz testing".  As one o=
f the first things you
> > learn (the hard way) is to log the random seed(s) and make them control=
lable ... somehow.
> > Because nothing is as frustrating as finding a bug after days of simula=
tion and then
> > not being able to reproduce it with waves and debugging enabled ...
> >
> > >We *could* start with a constant seed, but then all the random numbers=
 would change
> > > every time anyone made any minor change to the fuzz tests anyway.
> > >
> > Yes, this is a well known fact: any change to either the design, the te=
st environment or
> > the test itself may affect the random generation and cause different be=
havior.
> > Which may be a problem if you want to hit a specific case with 100% cer=
tainty - in
> > which case you should indeed make a dedicated test for that instead.
> > (but usually, you don't realise the corner case exists until you first =
hit it ...)
> >
> > *However* this is NOT relevant to the repeatability-for-debugging situa=
tion, as in
> > that case, you should should not change *anything* until you've thoroug=
hly root-
> > caused the issue. (or created a baseline in your source control system =
such that you
> > can always go back to the *exact* situation  that caused the error).
> > This is (hardware) verification 101.
>=20
> I meant repeatable in the sense that the same bug is hit, even if the gen=
erated
> test case is not 100% identical.
>=20
It may not need to be 100% identical, sure, but I would still assert that t=
he odds
of hitting the same obscure corner case bug may not be as high as you might=
 hope.
And for me,  "repeatable" means that I can *depend* on hitting it and don't=
 need
to be "lucky" on the next boot. My recent personal experiences are not so g=
ood :-(

What's more tricky: now I implemented a fix. So my *expectation* is that it=
 passes.
And it actually does. But does that mean my fix *really* worked? Or am I ju=
st not
hitting the relevant corner case anymore? Perhaps even due to my change its=
elf
influencing the random generation? How do I possibly know for sure?'

I may end up submitting a patch that does not work at all. It may even intr=
oduce a
new corner case issue that's not hit either. If there's a lot of people out=
 there
trying my patch I may have a reasonable chance one of them finds the proble=
m,
but fact of the matter is, AFAIK, I only have one person able to try my pat=
ches.

> Anyway, you're welcome to send a patch changing the fuzzing code to use a
> constant seed, if you really think it would be useful and can provide pro=
per
> justification for it.  I'm not sure why you keep sending these long rants=
, when
> you could simply send a patch yourself.
>=20
Ok, oops, I did not mean for that to be a rant.  And I'm usually pretty ver=
bose, so=20
feel free to TL;DR :-)

I did have a quick look at the random generation to see if I could fix the =
seed but=20
it currently seems to be global per CPU, not just for testmgr, so probably =
no=20
guarantee to get the same sequence inside testmgr even if I do manage to fi=
x=20
that seed (but I didn't try yet).

To give you an honest answer on that last question: lack of time and skills=
.
I'm not a software engineer and my boss merely tolerates me working on the=
=20
driver, so I can only spend idle cycles on this.

> >
> > > In my experience the bugs found by the fuzz tests tend to be found wi=
thin a
> > > couple hundred iterations, so are seen within a few boots at most wit=
h the
> > > default fuzz_iterations=3D100, and are "always" seen with fuzz_iterat=
ions=3D1000.
> > > Raising fuzz_iterations to 10000 didn't find anything else.
> > >
> > That may be because you've been working mostly with software implementa=
tions
> > which were already in pretty good shape to begin with. Hardware tends t=
o have
> > many more (tricky) corner cases.
> > The odds of hitting a specific corner case in just 100 or 1000 vectors =
is really not
> > as high as you may think. Especially if many of the vectors being gener=
ated are
> > actually illegal and just test for proper error response from the drive=
r.
> >
> > Just try to compute the (current) odds of getting an AAD length and cip=
her text
> > length that are zero at the same time. Which is a relevant corner case =
at least for
> > our hardware. In fact, having the digestsize zero at the same time as w=
ell is yet
> > another corner case requiring yet another workaround. The odds of those=
 3
> > cases colliding while generating random lengths over a decent range are=
 really,
> > really slim.
> >
> > Also, how fast you can reboot depends very much on the platform you're
> > working on. It quickly becomes annoying if rebooting takes minutes and =
plenty
> > of manual interaction. Speaking from experience.
> >
> > > If you find otherwise and come across some really rare case, you shou=
ld either
> > > add a real test vector (i.e. not part of the fuzz tests) for it,
> > >
> > The problem with "generating a test vector for it" is that it requires =
a known-
> > good reference implementation, which is usually hard to find. And then =
you
> > have to convert it to testmgr.h format and add it there manually. Which=
 is both
> > cumbersome and will cause testmgr.h (and kernel size) to explode at som=
e point.
> >
> > While in the overal majority of cases you don't really care about the i=
nput data
> > itself at all, so it's fine to generate that randomly, what you care ab=
out are things
> > like specific lengths, alignments, sizes, IV (counter) values and combi=
nations thereof.
> >
> > Also, adding those as "normal" test vectors will cause the normal boot =
produre to
> > slow to a crawl verifying  loads of obscure corner cases that are reall=
y only relevant
> > during development anyway.
> >
> > And why bother if you have the generic implementation available to do a=
ll
> > this on-the-fly and only with the extra tests enabled, just like you do=
 with the full
> > random vectors?
> >
> > It was just a crazy idea anyway, based on a real-life observation I mad=
e.
>=20
> Being too lazy to add a test vector isn't really an excuse
>
Lazyness has very little to do with it. Adding generated vectors to testmgr=
.h just
feels like a waste of effort and space, as you could generate them on-the-f=
ly.
(if the generic implementation is known to be good for those cases)

> , and it won't bloat
> the kernel size or boot time unless you add a massive number of test vect=
ors or
> if they use very large lengths.=20
>
It will increase the kernel size and boot time.  Beyond what threshold that=
 will be=20
considered bloat is in the eye of the beholder I suppose. And some corner c=
ases
(i.e. length restrictions, hash block size boundaries, counter sizes, ...) =
may indeed=20
require significant lengths, so with so many cipher suites that adds up qui=
ckly.

> We could even make certain test vectors
> conditional on CONFIG_CRYPTO_MANAGER_EXTRA_TESTS if it's an issue...
>=20
Ok, I guess that would solve the bloat issue as well (not counting testmgr.=
h itself).

> >
> > > or you should
> > > update the fuzz tests to generate the case more often so that it's li=
kely to be
> > > hit with the default fuzz_iterations=3D100.
> > >
> > Running just 10 times more iterations is really not going to be suffici=
ent to hit
> > the really tricky *combinations* of parameters, considering the ranges =
of the
> > individual parameters. Just do some statistics on that and you'll soon =
realise.
> >
> > Just some example for the AEAD corner case I mentioned before:
> >
> > The odds of generating a zero authsize are 1/4 * 1/17 =3D 1/68. But tha=
t will still
> > need to coincide with all other parameters (including key sizes) being =
legal.
> > So there already, your 100 iterations come short.
> >
> > A zero length AAD *and* plaintext happens only once every 8000+ vectors=
.
> > And that also still has to coincide with key sizes etc. being legal. So=
 there even
> > 10000 iterations would not be enough to be *sure* to hit that.
> >
> > To have some reasonable shot at hitting the combination those two cases
> > you'd need well over a million iterations ...
> >
> > > I don't think it's necessary to split
> > > the fuzz testing into 2 parts; instead we just need to boost the prob=
ability of
> > > generating known edge cases (e.g. see what generate_random_bytes() al=
ready does).
> > >
> > I guess somehow tweaking the random generation such that the probabilit=
y of
> > generating the interesting cases becomes *significantly* higher would w=
ork too.
> > To me, that's just implementation detail though.
> >
>=20
> Like I said, if you encounter bugs that the fuzz tests should be finding =
but
> aren't, it would be really helpful if you added test vectors=20
>
The only vectors I have easy access to are the ones we use to verify our HW=
.
And that's exactly the problem here - these are often cases that we don't f=
ormally=20
support with our HW and require driver workarounds. Hence, I don't have
those vectors readily available.

> for them and/or
> updated the fuzz tests to generate those cases more often. =20
>
Sounds like a plan, but easier said than done ... relevant corner cases may
differ from cipher suite to cipher suite so you need some way to control th=
e
random generation of the various parameters from alg_test_descs[x].
But OK, fair enough, I'll try and see if I can come up with something mysel=
f ...=20
if I can find some cycles to actually work on that ... don't hold you breat=
h for it.

> I was simply
> pointing out that to do the latter, we don't really need to split the tes=
ts into
> 2 parts; it would be sufficient just to change the probabilities with whi=
ch
> different things are generated.  Note that the probabilities can be condi=
tional
> on other things, which can get around the issue where a bunch of small
> independent probabilities are multiplied together.
>=20
> - Eric

Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com
