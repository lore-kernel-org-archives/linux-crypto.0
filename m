Return-Path: <SRS0=h947=VT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8188AC7618F
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Jul 2019 22:09:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2969221900
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Jul 2019 22:09:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="wgscN/xe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726358AbfGVWJJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 22 Jul 2019 18:09:09 -0400
Received: from mail-eopbgr740057.outbound.protection.outlook.com ([40.107.74.57]:54439
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726265AbfGVWJJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 22 Jul 2019 18:09:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m3anLtgWS6756GHK44nEqkWrCZJOD0i7WxmytQ435BCWRhMoD3y0CJraYxqlS+wDY9rSDkok6jYPlSuhk/dvbamDecaeNlpTR6NxDM2l/qbeNMxcLsrGSGV2YSq5STe7XX36DEocd2Et7Hi7a1ydzCNq6O+EWml1yiuAJycy/mMvU7qiPU/yBp6G9HohLPPHo5SooDdGBRkk743WfU3yrbZT6uMw9qmgnzrN8FchBxbWI0dc1qDKveTL5MJeUC4tDmsJWhdGZOXZxIGQCnhORakg6OTpkdoGg7ZR/EW+E+wHyiIXoI1rcYH47him22qNGeSvQisSxqR2NKuSjD+nVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M52CL17sfeurAJmx3qIDI+PnPLyr7s/dnq0N5oe/aOw=;
 b=KDfGUDFGpj0yh1yKyoEmpntzs79zcgCUNPJSzpvQKR2M87NNwNppYfCMpcCRAlibHi9VGLGLJxmBW0yyP1yCQ06GsxKnJF+5REyTOssPPJkNbHfKHVTSNRik76Xs5XPbZxhqlNz90+f5gp/0y7K9xqU2oyPYtmg6OxBSMG2i185W4YjaU9DMYVSYYStiG923ggV6llJ3CV25KzvQiDnaTLKZ6E23nSMeFpjkRSwCkuLWv6YCdEOL4rWaahL3Eo8lQm7j/0f8afPooBxPnv1lRmOFChMmHkRPwYylbLdeM9823xIND9uN0JgXZRvQDzEfh2YAjv2f1LwZvuTFgjJUaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=verimatrix.com;dmarc=pass action=none
 header.from=verimatrix.com;dkim=pass header.d=verimatrix.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M52CL17sfeurAJmx3qIDI+PnPLyr7s/dnq0N5oe/aOw=;
 b=wgscN/xe8EfLXfUYBHlUFzJl1qZtc0TvLGcxoNSdpsua+RLz5vBBXD7vDZV11H9KqR9v4HMOCycbJQ7UXhghleXEoohC7ia4UQq3/qpCT0FHRWt83bZGOneBm2eGDx4JGdC+jTkv2xjlEQQFNG3IHe2z9ReHbzih5KV3H9rxlyI=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB3245.namprd20.prod.outlook.com (52.132.175.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.16; Mon, 22 Jul 2019 22:09:03 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::68d7:2bbb:af61:2e69]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::68d7:2bbb:af61:2e69%6]) with mapi id 15.20.2094.017; Mon, 22 Jul 2019
 22:09:03 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Eric Biggers <ebiggers@kernel.org>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: Testmgr fuzz testing
Thread-Topic: Testmgr fuzz testing
Thread-Index: AdVAdUj98zKx4A/DSr+aRU+NlJJ9GQAMhNWAAAk8USA=
Date:   Mon, 22 Jul 2019 22:09:03 +0000
Message-ID: <MN2PR20MB2973E558C4C8732708EF3A06CAC40@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <MN2PR20MB2973F2047FCE9EA5794E7DF7CAC40@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190722160603.GA689@sol.localdomain>
In-Reply-To: <20190722160603.GA689@sol.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d3695e5c-e507-4c16-9153-08d70ef134df
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR20MB3245;
x-ms-traffictypediagnostic: MN2PR20MB3245:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MN2PR20MB3245FDA8E4EF970E1B605732CAC40@MN2PR20MB3245.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 01068D0A20
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(39850400004)(136003)(366004)(346002)(396003)(13464003)(52314003)(189003)(199004)(66946007)(52536014)(81156014)(76116006)(81166006)(66556008)(5660300002)(66446008)(8676002)(14454004)(66476007)(8936002)(4326008)(64756008)(3846002)(55016002)(9686003)(6246003)(71190400001)(71200400001)(68736007)(53936002)(3480700005)(229853002)(86362001)(15974865002)(305945005)(76176011)(7736002)(74316002)(66066001)(316002)(54906003)(102836004)(256004)(2906002)(6436002)(446003)(14444005)(25786009)(11346002)(33656002)(53546011)(7116003)(6116002)(486006)(6506007)(6916009)(26005)(7696005)(476003)(99286004)(478600001)(186003)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB3245;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: UfAbocMNHYJ3F4HghjvXYQ4uKg1MJTMFx6RJW6FStwLiEOcyVxtN5j8KXNjUvGkPNZ4XzGd7vCcCJ0a+V+l6oOdT/LOwakLJJ8J4JXEZLHY+uG0Ck1Yst2ku2dscKXGKn/fiDy5EtMQT65LDZHc+AxrhhRuJ5SHQllj8uKU2jrnWt51sLMNvqTXthOq02Xic+n7EH/7Y0IRugl6JnTqMOKWPqwKo5BNx2Nl0JYxqPfjk7JvOWS3eadSBLF4LIe1eu+NszKRGUmLQXfTtWCtO9Rz73WyW7EgwS3VkGM2B5oDuR87JNm6Oy3xV7qft3rbAtXR1YT8AflTSlwf1R78u4YpOHS8KkWlbpsU9Iam+y8Ou32hd7jbkTZHNpU7GNdmGVEtZw39d++2XlNAVYAMf5AG0557obyYdw2Ji4Utipw0=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3695e5c-e507-4c16-9153-08d70ef134df
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jul 2019 22:09:03.1329
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvanleeuwen@verimatrix.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB3245
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> -----Original Message-----
> From: Eric Biggers <ebiggers@kernel.org>
> Sent: Monday, July 22, 2019 6:06 PM
> To: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
> Cc: linux-crypto@vger.kernel.org; Herbert Xu <herbert@gondor.apana.org.au=
>; davem@davemloft.net
> Subject: Re: Testmgr fuzz testing
>=20
> Hi Pascal,
>=20
> On Mon, Jul 22, 2019 at 10:27:22AM +0000, Pascal Van Leeuwen wrote:
> > Eric,
> >
> > While fixing some issues in the inside-secure driver reported by the fu=
zz, I noticed that the
> > results are actually not repeatable: odds are  high that on the next ru=
n, the error case is
> > actually not hit anymore since they're typically very specific  corner =
cases.
> >
> > There's 2 problems with that:
> > a) Without repeatability, I cannot verify whether my fix actually worke=
d. In fact, I cannot
> > even verify with any certainty that any modification I do won't fail so=
mewhere else :-(
> > b) Odds are very significant that important corner cases are not hit by=
 the fuzzing
> >
> > Issue a) is usually solved by making the random generation deterministi=
c, i.e. ensure
> > you seed it with a known constant and pull the random numbers strictly =
sequentially.
> > (you may or may not add the *option* to  pull the seed from some true r=
andom source)
> >
> > Issue b) would be best solved by splitting the fuzz testing into two pa=
rts, a (properly
> > constrained!) random part and a part with fixed known corner cases wher=
e you use
> > constant parameters (like lengths and such) but depend on the generic i=
mplementation
> > for the actual vector generation (as specifications usually don't provi=
de vectors for
> > all interesting corner cases but we consider the generic implementation=
 to be correct)
> >
>=20
> Sure, it's not always repeatable, but that's the nature of fuzz testing. =
=20
>
No. It's not repeatable *at all*. The odds of getting the exact same sequen=
ce of random
numbers should approach zero, assuming that random generator is half decent=
 and=20
properly seeded with another (true?) random value.=20

For us hardware engineers, (constrained) random testing is our bread and bu=
tter.
Given the design complexity we're dealing with today and the fact that any =
serious bug may=20
actually put us out of business (considering mask costs and respin turnarou=
nd), it's the only=20
way to cope. So I have many years of experience and I can assure you that b=
eing "not always
repeatable" does not NEED to be the "nature of fuzz testing".  As one of th=
e first things you=20
learn (the hard way) is to log the random seed(s) and make them controllabl=
e ... somehow.
Because nothing is as frustrating as finding a bug after days of simulation=
 and then
not being able to reproduce it with waves and debugging enabled ...

>We *could* start with a constant seed, but then all the random numbers wou=
ld change
> every time anyone made any minor change to the fuzz tests anyway.
>=20
Yes, this is a well known fact: any change to either the design, the test e=
nvironment or
the test itself may affect the random generation and cause different behavi=
or.
Which may be a problem if you want to hit a specific case with 100% certain=
ty - in
which case you should indeed make a dedicated test for that instead.
(but usually, you don't realise the corner case exists until you first hit =
it ...)

*However* this is NOT relevant to the repeatability-for-debugging situation=
, as in
that case, you should should not change *anything* until you've thoroughly =
root-
caused the issue. (or created a baseline in your source control system such=
 that you
can always go back to the *exact* situation  that caused the error).
This is (hardware) verification 101.

> In my experience the bugs found by the fuzz tests tend to be found within=
 a
> couple hundred iterations, so are seen within a few boots at most with th=
e
> default fuzz_iterations=3D100, and are "always" seen with fuzz_iterations=
=3D1000.
> Raising fuzz_iterations to 10000 didn't find anything else.
>=20
That may be because you've been working mostly with software implementation=
s
which were already in pretty good shape to begin with. Hardware tends to ha=
ve=20
many more (tricky) corner cases.
The odds of hitting a specific corner case in just 100 or 1000 vectors is r=
eally not
as high as you may think. Especially if many of the vectors being generated=
 are
actually illegal and just test for proper error response from the driver.

Just try to compute the (current) odds of getting an AAD length and cipher =
text
length that are zero at the same time. Which is a relevant corner case at l=
east for
our hardware. In fact, having the digestsize zero at the same time as well =
is yet=20
another corner case requiring yet another workaround. The odds of those 3=20
cases colliding while generating random lengths over a decent range are rea=
lly,
really slim.

Also, how fast you can reboot depends very much on the platform you're=20
working on. It quickly becomes annoying if rebooting takes minutes and plen=
ty
of manual interaction. Speaking from experience.

> If you find otherwise and come across some really rare case, you should e=
ither
> add a real test vector (i.e. not part of the fuzz tests) for it,=20
>
The problem with "generating a test vector for it" is that it requires a kn=
own-
good reference implementation, which is usually hard to find. And then you
have to convert it to testmgr.h format and add it there manually. Which is =
both
cumbersome and will cause testmgr.h (and kernel size) to explode at some po=
int.

While in the overal majority of cases you don't really care about the input=
 data
itself at all, so it's fine to generate that randomly, what you care about =
are things=20
like specific lengths, alignments, sizes, IV (counter) values and combinati=
ons thereof.

Also, adding those as "normal" test vectors will cause the normal boot prod=
ure to
slow to a crawl verifying  loads of obscure corner cases that are really on=
ly relevant
during development anyway.=20

And why bother if you have the generic implementation available to do all=20
this on-the-fly and only with the extra tests enabled, just like you do wit=
h the full=20
random vectors?

It was just a crazy idea anyway, based on a real-life observation I made.

> or you should
> update the fuzz tests to generate the case more often so that it's likely=
 to be
> hit with the default fuzz_iterations=3D100. =20
>
Running just 10 times more iterations is really not going to be sufficient =
to hit
the really tricky *combinations* of parameters, considering the ranges of t=
he
individual parameters. Just do some statistics on that and you'll soon real=
ise.

Just some example for the AEAD corner case I mentioned before:

The odds of generating a zero authsize are 1/4 * 1/17 =3D 1/68. But that wi=
ll still
need to coincide with all other parameters (including key sizes) being lega=
l.
So there already, your 100 iterations come short.

A zero length AAD *and* plaintext happens only once every 8000+ vectors.
And that also still has to coincide with key sizes etc. being legal. So the=
re even
10000 iterations would not be enough to be *sure* to hit that.

To have some reasonable shot at hitting the combination those two cases
you'd need well over a million iterations ...

> I don't think it's necessary to split
> the fuzz testing into 2 parts; instead we just need to boost the probabil=
ity of
> generating known edge cases (e.g. see what generate_random_bytes() alread=
y does).
>=20
I guess somehow tweaking the random generation such that the probability of=
=20
generating the interesting cases becomes *significantly* higher would work =
too.
To me, that's just implementation detail though.

Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com

