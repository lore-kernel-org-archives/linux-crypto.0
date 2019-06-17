Return-Path: <SRS0=Ym9l=UQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E79B2C31E5D
	for <linux-crypto@archiver.kernel.org>; Mon, 17 Jun 2019 15:28:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CA26B2182B
	for <linux-crypto@archiver.kernel.org>; Mon, 17 Jun 2019 15:28:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725863AbfFQP2T convert rfc822-to-8bit (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 17 Jun 2019 11:28:19 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:44885 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726331AbfFQP2T (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 17 Jun 2019 11:28:19 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-214-il9BSCFIPjqk3b60HcUCPg-1; Mon, 17 Jun 2019 16:28:16 +0100
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Mon, 17 Jun 2019 16:28:15 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Mon, 17 Jun 2019 16:28:15 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Herbert Xu' <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>
CC:     Kees Cook <keescook@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Vitaly Chikunov <vt@altlinux.org>,
        "Gilad Ben-Yossef" <gilad@benyossef.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] crypto: testmgr - reduce stack usage in fuzzers
Thread-Topic: [PATCH] crypto: testmgr - reduce stack usage in fuzzers
Thread-Index: AQHVJRzgXZ6zGpiwtkazfAn7xAaGHKaf9HVg
Date:   Mon, 17 Jun 2019 15:28:15 +0000
Message-ID: <139bf69c4d35449d9b3c9265458bab42@AcuMS.aculab.com>
References: <20190617132343.2678836-1-arnd@arndb.de>
 <20190617140435.qjzcouaqzepaicf4@gondor.apana.org.au>
 <CAK8P3a07Vcqs+6Rs2Ckq_itWfGKUv+_pdgdis9eSujCGHQgFkQ@mail.gmail.com>
 <20190617142419.yw4w5w344tf6ozrb@gondor.apana.org.au>
 <CAK8P3a0G2K4u-Sh495O7_nfc6zydtZBTOJcq19g3YYQA2ZMKFA@mail.gmail.com>
 <20190617145624.p6alck5m6bqaswgp@gondor.apana.org.au>
In-Reply-To: <20190617145624.p6alck5m6bqaswgp@gondor.apana.org.au>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: il9BSCFIPjqk3b60HcUCPg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Herbert Xu
> Sent: 17 June 2019 15:56
> On Mon, Jun 17, 2019 at 04:54:16PM +0200, Arnd Bergmann wrote:
> >
> > Just converting the three testvec_config variables is what I originally
> > had in my patch. It got some configurations below the warning level,
> > but some others still had the problem. I considered sending two
> > separate patches, but as the symptom was the same, I just folded
> > it all into one patch that does the same thing in four functions.
> 
> Just curious, how bad is it with only moving testvec_config off
> the stack?

This all reminds me of some code I wrote a long time ago (1984?)
that worked out the maximum stack use for a system by processing
all the .o files to find out which functions called which at what
stack depth and adding everything up.
That system had no indirect calls and no recursion, but the worst
stack use was always in diagnostic prints in obscure error paths.

My guess is that the same is true for the Linux kernel.
While getting rid of large on-stack buffers fixes the obvious cases
full analysis is needed to guarantee the stack won't overflow.
Doing that requires some method for determining the stack use
of indirect calls - which really requires knowing which type of
function is actually being called from each place.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

