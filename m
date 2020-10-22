Return-Path: <SRS0=kAoH=D5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72FBDC4363A
	for <linux-crypto@archiver.kernel.org>; Thu, 22 Oct 2020 08:20:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 22B60223BF
	for <linux-crypto@archiver.kernel.org>; Thu, 22 Oct 2020 08:20:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2895030AbgJVIUH convert rfc822-to-8bit (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 22 Oct 2020 04:20:07 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:54405 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2895027AbgJVIUG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 22 Oct 2020 04:20:06 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-268-iKw_O9GSOxWai6mk4juzFg-1; Thu, 22 Oct 2020 09:20:01 +0100
X-MC-Unique: iKw_O9GSOxWai6mk4juzFg-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Thu, 22 Oct 2020 09:20:01 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Thu, 22 Oct 2020 09:20:01 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Eric Biggers' <ebiggers@kernel.org>,
        Arvind Sankar <nivedita@alum.mit.edu>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 6/6] crypto: lib/sha - Combine round constants and
 message schedule
Thread-Topic: [PATCH v2 6/6] crypto: lib/sha - Combine round constants and
 message schedule
Thread-Index: AQHWqCytsF/IXICPKESRSNEpjVVK3amjPs5A
Date:   Thu, 22 Oct 2020 08:20:01 +0000
Message-ID: <d272bd02d90343e8a92821ff457609f8@AcuMS.aculab.com>
References: <20201020203957.3512851-1-nivedita@alum.mit.edu>
 <20201020203957.3512851-7-nivedita@alum.mit.edu>
 <20201022043450.GC857@sol.localdomain>
In-Reply-To: <20201022043450.GC857@sol.localdomain>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


From: Eric Biggers
> Sent: 22 October 2020 05:35
> 
> On Tue, Oct 20, 2020 at 04:39:57PM -0400, Arvind Sankar wrote:
> > Putting the round constants and the message schedule arrays together in
> > one structure saves one register, which can be a significant benefit on
> > register-constrained architectures. On x86-32 (tested on Broadwell
> > Xeon), this gives a 10% performance benefit.
> >
> > Signed-off-by: Arvind Sankar <nivedita@alum.mit.edu>
> > Suggested-by: David Laight <David.Laight@ACULAB.COM>
> > ---
> >  lib/crypto/sha256.c | 49 ++++++++++++++++++++++++++-------------------
> >  1 file changed, 28 insertions(+), 21 deletions(-)
> >
> > diff --git a/lib/crypto/sha256.c b/lib/crypto/sha256.c
> > index 3a8802d5f747..985cd0560d79 100644
> > --- a/lib/crypto/sha256.c
> > +++ b/lib/crypto/sha256.c
> > @@ -29,6 +29,11 @@ static const u32 SHA256_K[] = {
> >  	0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208, 0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2,
> >  };
> >
> > +struct KW {
> > +	u32 K[64];
> > +	u32 W[64];
> > +};
> 
> Note that this doubles the stack usage from 256 to 512 bytes.  That's pretty
> large for kernel code, especially when compiler options can increase the stack
> usage well beyond the "expected" value.
> 
> So unless this gives a big performance improvement on architectures other than
> 32-bit x86 (which people don't really care about these days), we probably
> shouldn't do this.

IIRC the gain came from an odd side effect - which can probably
be got (for some compiler versions) by other means.

> FWIW, it's possible to reduce the length of 'W' to 16 words by computing the
> next W value just before each round 16-63,

I was looking at that.
You'd need to do the first 16 rounds then rounds 17-63 in a second
loop to avoid the conditional.
The problem is that it needs too many registers.
You'd need registers for 16 W values, the 8 a-h and a few spare.

...

Looking closely each round is like:
        t1 = h + e1(e) + Ch(e, f, g) + 0x428a2f98 + W[0];
        t2 = e0(a) + Maj(a, b, c);
        h = t1 + t2;   // Not used for a few rounds
        d += t1;       // Needed next round
So only needs 4 of the state variables (e, f, g, h).
The next round uses d, e, f and g.
So with extreme care d and h can use the same register.
Although I'm not sure how you'd get the compiler to do it.
Possibly making state[] volatile (or using READ/WRITE_ONCE).
So the last two lines become:
        state[7] = t1 + t2;
        d = state[3] + t1;
That might stop the x86 (32bit) spilling registers.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

