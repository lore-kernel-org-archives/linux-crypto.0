Return-Path: <SRS0=1oRy=R4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D342C43381
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Mar 2019 09:12:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 38BD22087E
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Mar 2019 09:12:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=insidesecure.onmicrosoft.com header.i=@insidesecure.onmicrosoft.com header.b="dcrCppo4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730129AbfCYJL4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 25 Mar 2019 05:11:56 -0400
Received: from mail-eopbgr40115.outbound.protection.outlook.com ([40.107.4.115]:63911
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730147AbfCYJL4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 Mar 2019 05:11:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=insidesecure.onmicrosoft.com; s=selector1-insidesecure-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=otqbGjQ5VZXU7J94Oj4IOkXAzDVZCGXkF2hlJal94uY=;
 b=dcrCppo4leWuOx7k0XvVsRRI4Ix07Pb3I5BKFTEOG4LTDchSTt/lD1znx9pCirIX2dabiQRe1jkSI5vpsUwUtu6lYZ5hU4PqqLEYqipO7YUeMLkRVJZ9USrGe4HixXZ7FIj9BvCArGM95WCR3ZY4cQbvyWoDVEvyGIeMmJ+6Nvc=
Received: from AM5PR0901MB1155.eurprd09.prod.outlook.com (10.167.221.149) by
 AM5PR0901MB1554.eurprd09.prod.outlook.com (10.168.160.14) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1730.15; Mon, 25 Mar 2019 09:10:08 +0000
Received: from AM5PR0901MB1155.eurprd09.prod.outlook.com
 ([fe80::3ce1:45ba:90be:a0e5]) by AM5PR0901MB1155.eurprd09.prod.outlook.com
 ([fe80::3ce1:45ba:90be:a0e5%4]) with mapi id 15.20.1730.019; Mon, 25 Mar 2019
 09:10:08 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "linux-fscrypt@vger.kernel.org" <linux-fscrypt@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Paul Crowley <paulcrowley@google.com>,
        Greg Kaiser <gkaiser@google.com>,
        Samuel Neves <samuel.c.p.neves@gmail.com>,
        Tomer Ashur <tomer.ashur@esat.kuleuven.be>,
        Martin Willi <martin@strongswan.org>
Subject: RE: [PATCH 0/17] Add zinc using existing algorithm implementations
Thread-Topic: [PATCH 0/17] Add zinc using existing algorithm implementations
Thread-Index: AQHU4HhqZ0R+rbz2UECo8a5sYsqDyKYXSJ6AgAClUACABAkE8A==
Date:   Mon, 25 Mar 2019 09:10:08 +0000
Message-ID: <AM5PR0901MB1155FD05113D6DC79A6274CED25E0@AM5PR0901MB1155.eurprd09.prod.outlook.com>
References: <20190322062740.nrwfx2rvmt7lzotj@gondor.apana.org.au>
 <CAKv+Gu_mgyzqUCeb+wke--8Gn8YbjOb8jyrSgFr3-tcNP8ccEQ@mail.gmail.com>
 <CAHk-=wg2LJ5qQ0B2y+_6Ue62SBP4h9MLxLvn89bfcP7Cp2ac6A@mail.gmail.com>
In-Reply-To: <CAHk-=wg2LJ5qQ0B2y+_6Ue62SBP4h9MLxLvn89bfcP7Cp2ac6A@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@insidesecure.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5dc1040e-4d46-494e-5b9e-08d6b101ad8a
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(2017052603328)(7153060)(7193020);SRVR:AM5PR0901MB1554;
x-ms-traffictypediagnostic: AM5PR0901MB1554:
x-microsoft-antispam-prvs: <AM5PR0901MB1554097FBF9A373BEB1570C8D25E0@AM5PR0901MB1554.eurprd09.prod.outlook.com>
x-forefront-prvs: 0987ACA2E2
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39840400004)(136003)(366004)(346002)(396003)(376002)(199004)(52314003)(189003)(71200400001)(71190400001)(229853002)(14444005)(256004)(6246003)(68736007)(14454004)(6436002)(446003)(11346002)(486006)(3846002)(6116002)(55016002)(66066001)(9686003)(476003)(105586002)(186003)(106356001)(53936002)(102836004)(2906002)(74316002)(478600001)(4326008)(305945005)(52536014)(7736002)(86362001)(54906003)(8676002)(25786009)(81156014)(5660300002)(110136005)(81166006)(316002)(76176011)(33656002)(6506007)(99286004)(7696005)(97736004)(7416002)(8936002)(26005);DIR:OUT;SFP:1102;SCL:1;SRVR:AM5PR0901MB1554;H:AM5PR0901MB1155.eurprd09.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: insidesecure.com does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: jnq6N/6cXK39CksiE8ulheajRInTSlwEpcJ+WVbfWr579ZVKqbpdk6iO2IY6dkqKmkcbYKkVq0t0F32mFVGwHgnTvV2QnRmVyPp9So8cs5cnRwHIZjJYpCxTUAFIvV0QN/lwt3EDTNCLA5rwTIlqrlhjTzNtTVp6T4F5jCnCgHSzyeYYOnIxeJbuU/t924XY0pGnzIYYGp+52M9DtVk2eBfS9+eqYz+yGCxMT9T3oK66eV/YEsscdHRJ4wsft+7/oG/QkgFHghly7KasChmfxitrhF3PMONOq+fKkRV7URxQs1pT1QPqfHya3L8aBDZ+pIVeuSQjLTTEsWFTetnshx7ttiX2TZjrrdQUNKN3oETwCAhkLilxRldiWZ7Y88wW5mJ82zrcIWpB8mAn8h7bh0vd2Lkmt7Y2V00ZSDPR0EE=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: insidesecure.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5dc1040e-4d46-494e-5b9e-08d6b101ad8a
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Mar 2019 09:10:08.2251
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3c07df58-7760-4e85-afd5-84803eac70ce
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR0901MB1554
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

As someone who has been working on crypto acceleration hardware for the bet=
ter
part of the past 20 years, I feel compelled to respond to this, in defence =
of
the crypto API (which we're really happy with ...).

> And honestly, I'm 1000% with Jason on this. The crypto/ model is hard to =
use,
> inefficient, and completely pointless when you know what your cipher or
> hash algorithm is, and your CPU just does it well directly.
>
> > we even have support already for async accelerators that implement it,
>
> Afaik, none of the async accelerator code has ever been worth anything on
> real hardware and on any sane and real loads. The cost of going outside t=
he
> CPU is *so* expensive that you'll always lose, unless the algorithm has b=
een
> explicitly designed to be insanely hard on a regular CPU.
>
The days of designing them *specifically* to be hard on a CPU are over, but
nevertheless, due to required security properties, *good* crypto is usually
still hard work for a CPU.
Especially *asymmetric* crypto, which can easily take milliseconds per oper=
ation
even on a high-end CPU. You can do a lot of interrupt processing in a milli=
second
Now some symmetric algorithms (AES,SHA,GHASH) have actually made it *into*
the CPU, somewhat changing the landscape, but:
a) That's really only a small subset of the crypto being used out there.
   There's much more to crypto than just AES, SHA and GHASH.
b) This only applies to high-end CPU's. The large majority of embedded CPU'=
s do
   not have such embedded crypto instructions. This may change, but I don't
   really expect that to happen soon.
c) You're still keeping a big, power-hungry CPU busy for a lot of cycles do=
ing
   some fairly trivial work.

> (Corollary: "insanely hard on a regular CPU" is also easy to do by making=
 the
> CPU be weak and bad. Which is not a case we should optimize for).
>

Linux is being used a lot for embedded systems which usually DO have fairly
weak CPU's. I would argue that's exactly the case you SHOULD optimize for,
as that's where you can *really* still make the difference as a programmer.

> The whole "external accelerator" model is odd. It was wrong. It only make=
s
> sense if the accelerator does *everything* (ie it's the network card), an=
d
> then you wouldn't use the wireguard thing on the CPU at all, you'd have a=
ll
> those things on the accelerator (ie a "network card that does WG").
>
> One of the (best or worst, depending on your hangups) arguments for
> external accelerators has been "but I trust the external hardware with th=
e
> key, but not my own code", aka the TPM or Disney argument.  I don't think
> that's at all relevant to the discussion either.
>
> The whole model of async accelerators is completely bogus. The only crypt=
o
> or hash accelerator that is worth it are the ones integrated on the CPU c=
ores,
> which have the direct access to caches.
>
NOT true. We wouldn't still be in business after 20 years if that were true=
.

> And if the accelerator is some tightly coupled thing that has direct acce=
ss to
> your caches, and doesn't need interrupt overhead or address translation e=
tc
> (at which point it can be worth using) then you might as well just consid=
er it
> an odd version of the above. You'd want to poll for the result anyway,
> because not polling is too expensive.
>
It's HARD to get the interfacing right to take advantage of the acceleratio=
n.
And that's exacly why you MUST have an async interface for that: to cope wi=
th
the large latency of external acceleration, going through the memory subsys=
tem
and external buses as - as you already pointed out - you cannot access the =
CPU
cache directly (though you can be fully coherent with it).
So to cope with that latency, you will need to batch queue and pipeline you=
r
processing. This is not unique to crypto acceleration, the same principles
apply to e.g. your GPU as well. Or any HW worth anything, for that matter.

What that DOES mean is that external crypto accelerators are indeed useless=
 for
doing the occasional crypto operation, it really only makes sense for strea=
ming
and/or bulk use cases, such as network packet or disk encryption. And for
operations that really take significant time, such as asymmetic crypto.
For the occasional symmetric crypto operation, by all means, do that on the=
 CPU
using a very thin API layer for efficiency and simplicity. This is where Zi=
nc
makes a lot of sense - I'm not against Zinc at all. But DO realise that whe=
n
you go that route, you forfeit any chances of benefitting from acceleration=
.

Ironically, for doing what Wireguard is doing - bulk packet encryption - th=
e
async crypto API makes a lot more sense than Zinc. In Jason's defense, as
far as I know, there is no Poly/Chacha HW acceleration out there yet, but I
can assure you that that situation is going to change soon :-)
Still,  I would really recommend running Wireguard on top of crypto API.
How much performance would you really lose by doing that? If there's
anything wrong with the efficiency of the crypto API implementation of
P/C, then just fix that.

> Just a single interrupt would completely undo all the advantages you got
> from using specialized hardware - both power and performance.
>
We have done plenty of measurements, on both power and performance, to prov=
e
you wrong there. Typically our HW needs *at least* a full order of a magnit=
ude
less power to do the actual work. The CPU load for handing the interrupts e=
tc.
tends to be around 20%. So assuming the CPU goes to sleep for the other 80%
of the time,  the combined solution would need about 1/3rd of the power of =
a
CPU only solution. It's one of our biggest selling points.

As for performance - in the embedded space you can normally expect the cryp=
to
accelerator to be *much* faster than the CPU subsystem as well. So yes, big
multi-core multi-GHz Xeons can do AES-GCM extremely fast and we'd have a ha=
rd
time competing with that, but that's not the relevant use case here.

> And that kind of model would work just fine with zinc.

>
> So an accelerator ends up being useful in two cases:
>
>  - it's entirely external and part of the network card, so that there's n=
o extra
> data transfer overhead
>
There are inherent efficiency advantages to integrating the crypto there, b=
ut
it's also very inflexible as you're stuck with a particular, usually very l=
imited,
implementation. And it doesn't fly very well with current trends of Softwar=
e
Defined Networking and Network Function Virtualization.
As for data transfer overhead: as long as the SoC memory subsystem was desi=
gned
to cope with this, it's really irrelevant as you shouldn't notice it.

>  - it's tightly coupled enough (either CPU instructions or some on-die ca=
che
> coherent engine) that you can and will just use it synchronously anyway.
>
> In the first case, you wouldn't run wireguard on the CPU anyway - you hav=
e a
> network card that just implements the VPN.
>
The irony here is, that network card would probably be an embedded system r=
unning
Linux on an embedded CPU, offloading the crypto operations to our accelerat=
or ...
Most smart NICs are architected that way.

Pascal van Leeuwen,
Silicon IP Architect @ Inside Secure
