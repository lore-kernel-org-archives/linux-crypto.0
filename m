Return-Path: <SRS0=H1lS=EA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75BA1C388F7
	for <linux-crypto@archiver.kernel.org>; Sun, 25 Oct 2020 18:51:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C1AD22260
	for <linux-crypto@archiver.kernel.org>; Sun, 25 Oct 2020 18:51:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1418299AbgJYSvX convert rfc822-to-8bit (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 25 Oct 2020 14:51:23 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:43977 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1418298AbgJYSvX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 25 Oct 2020 14:51:23 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-211-jt4E6GO0NJaVgBLGtth6tQ-1; Sun, 25 Oct 2020 18:51:18 +0000
X-MC-Unique: jt4E6GO0NJaVgBLGtth6tQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Sun, 25 Oct 2020 18:51:18 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Sun, 25 Oct 2020 18:51:18 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Arvind Sankar' <nivedita@alum.mit.edu>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Eric Biggers" <ebiggers@google.com>
Subject: RE: [PATCH v4 6/6] crypto: lib/sha256 - Unroll LOAD and BLEND loops
Thread-Topic: [PATCH v4 6/6] crypto: lib/sha256 - Unroll LOAD and BLEND loops
Thread-Index: AQHWqtuIw2smrl1NBkSqLe7bNPuvsKmonqLg
Date:   Sun, 25 Oct 2020 18:51:18 +0000
Message-ID: <05150bdb3a4c4b2682ab9cb8fb2ed411@AcuMS.aculab.com>
References: <20201025143119.1054168-1-nivedita@alum.mit.edu>
 <20201025143119.1054168-7-nivedita@alum.mit.edu>
In-Reply-To: <20201025143119.1054168-7-nivedita@alum.mit.edu>
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

From: Arvind Sankar
> Sent: 25 October 2020 14:31
> 
> Unrolling the LOAD and BLEND loops improves performance by ~8% on x86_64
> (tested on Broadwell Xeon) while not increasing code size too much.

I can't believe unrolling the BLEND loop makes any difference.

Unrolling the LOAD one might - but you don't need 8 times,
once should be more than enough.
The LOAD loop needs a memory read, memory write and BSWAP per iteration.
The loop control is add + compare + jmp.
On sandy bridge and later the compare and jmp become a single u-op.
So the loop has the read, write (can happen together) and 3 other u-ops.
That won't run at 1 clock per iteration on Sandy Bridge.
However just unroll once and you need 4 non-memory u-op per loop iteration.
That might run at 2 clocks per 8 bytes.

Fiddling the loop to remove the compare (ie run from -64 to 0)
should merge the 'add' and 'jnz' into a single u-op.
That might be enough to get the 'rolled up' loop to run in 1 clock
on sandy bridge, certainly on slightly later cpu.

That is theoretical for intel cpu sandy bridge onwards.
I've an i7-7700 (Kaby Lake?) that I belive has an extra
instruction pipeline and might run the initial loop in 1 clock.

I don't have any recent AMD cpu, nor any ARM or PPC ones.
But fully out-of-order cpu are likely to be similar.

One of the other test systems I've got is an Atom C2758.
This 8 core but mostly in-order.
Running sha256_transform() on that tend to give one of two
TSC counts, one of which is double the other!
That is pretty consistent even for 100 iterations.

WRT patch 5.
On the C2758 the original unrolled code is slightly faster.
On the i7-7700 the 8 unroll is a bit faster 'hot cache',
but slower 'cold cache' - probably because of the d-cache
loads for K[].

Non-x86 architectures might need to use d-cache reads for
the 32bit 'K' constants even in the unrolled loop.
X86 can use 'lea' with a 32bit offset to avoid data reads.
So the cold-cache case for the old code may be similar.

Interestingly I had to write an asm ror32() to get reasonable
code (in userspace). The C version the kernel uses didn't work.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

