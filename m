Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D3E7C388F7
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Nov 2020 09:13:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B703920857
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Nov 2020 09:13:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726200AbgKMJNf convert rfc822-to-8bit (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 13 Nov 2020 04:13:35 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:41694 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726184AbgKMJNe (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Nov 2020 04:13:34 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-220-PqFSW9A9PH2BcaJY30TEYQ-1; Fri, 13 Nov 2020 09:13:25 +0000
X-MC-Unique: PqFSW9A9PH2BcaJY30TEYQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Fri, 13 Nov 2020 09:13:24 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Fri, 13 Nov 2020 09:13:24 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Nathan Chancellor' <natechancellor@gmail.com>,
        Christian Lamparter <chunkeey@gmail.com>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Nick Desaulniers <ndesaulniers@google.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "clang-built-linux@googlegroups.com" 
        <clang-built-linux@googlegroups.com>
Subject: RE: [PATCH] crypto: crypto4xx - Replace bitwise OR with logical OR in
 crypto4xx_build_pd
Thread-Topic: [PATCH] crypto: crypto4xx - Replace bitwise OR with logical OR
 in crypto4xx_build_pd
Thread-Index: AQHWuT2oUlZMOSIiOk6Ynob79/7MV6nFxI1w
Date:   Fri, 13 Nov 2020 09:13:24 +0000
Message-ID: <a163bb51881149eaa13461a93b3e45bd@AcuMS.aculab.com>
References: <20201112200702.1664905-1-natechancellor@gmail.com>
 <1f5e8575-ab7e-59ea-6be7-0340df4d31c5@gmail.com>
 <20201112214904.GA3194701@ubuntu-m3-large-x86>
In-Reply-To: <20201112214904.GA3194701@ubuntu-m3-large-x86>
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

From: Nathan Chancellor
> Sent: 12 November 2020 21:49
> 
> On Thu, Nov 12, 2020 at 10:21:35PM +0100, Christian Lamparter wrote:
> > Hello,
> >
> > On 12/11/2020 21:07, Nathan Chancellor wrote:
> > > Clang warns:
> > >
> > > drivers/crypto/amcc/crypto4xx_core.c:921:60: warning: operator '?:' has
> > > lower precedence than '|'; '|' will be evaluated first
> > > [-Wbitwise-conditional-parentheses]
> > >                   (crypto_tfm_alg_type(req->tfm) == CRYPTO_ALG_TYPE_AEAD) ?
> > >                   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ^
> > > drivers/crypto/amcc/crypto4xx_core.c:921:60: note: place parentheses
> > > around the '|' expression to silence this warning
> > >                   (crypto_tfm_alg_type(req->tfm) == CRYPTO_ALG_TYPE_AEAD) ?
> > >                                                                           ^
> > >                                                                          )
> > > drivers/crypto/amcc/crypto4xx_core.c:921:60: note: place parentheses
> > > around the '?:' expression to evaluate it first
> > >                   (crypto_tfm_alg_type(req->tfm) == CRYPTO_ALG_TYPE_AEAD) ?
> > >                                                                           ^
> > >                   (
> > > 1 warning generated.
> > >
> > > It looks like this should have been a logical OR so that
> > > PD_CTL_HASH_FINAL gets added to the w bitmask if crypto_tfm_alg_type
> > > is either CRYPTO_ALG_TYPE_AHASH or CRYPTO_ALG_TYPE_AEAD.
> > Yes. This probably wasn't spotted earlier since the driver doesn't make
> > use of CRYPTO_ALG_TYPE_AHASH (yet). This is because the hash accelerator
> > setup cost was never worth it.
> >
> > > Change the operator so that everything works properly.
> > I'm curious if this is true. Is there a way to break this somehow on purpose?
> 
> I do not really have a way to validate that statement, I just figured
> that the operator being wrong meant that something could go wrong that
> was not intended.
> 
> > I've extracted the code from line 921 and added the defines
> > (the CRYPTO_ALG_... from the current 5.10-rc3 crypto.h and the PD_CTL_
> > from crypto4xx_reg_def.h) and replaced the u32 with uint32_t
> > so it runs in userspace too:
> >
> > --- crypto4xx_test.c ---
> > /* test study - is it possible to break the | vs || in crypto4xx's code */
> >
> > #include <stdio.h>
> > #include <stdint.h>
> >
> > #define CRYPTO_ALG_TYPE_AEAD 	0x00000003
> > #define CRYPTO_ALG_TYPE_AHASH	0x0000000f
> > #define PD_CTL_HASH_FINAL	(1<<4) /* Stand-in for BIT(4) */
> > #define PD_CTL_HOST_READY	(1<<0) /* BIT(0) */
> >
> > uint32_t func_with_bitwise_or(uint32_t alg_type)
> > {
> > 	return PD_CTL_HOST_READY |
> > 		((alg_type == CRYPTO_ALG_TYPE_AHASH) |
> > 		 (alg_type == CRYPTO_ALG_TYPE_AEAD) ?
> > 			PD_CTL_HASH_FINAL : 0);
> > }
> 
> Looking at this more, I think the only reason that the code works as is
> is because PD_CTL_HOST_READY is 1 AND CRYPTO_ALG_TYPE_AHASH is not used.
> 
> (alg_type == CRYPTO_ALG_TYPE_AEAD) ? PD_CTL_HASH_FINAL : 0 is evaluated
> first, which results in either PD_CTL_HASH_FINAL or 0.
> 
> Then (alg_type == CRYPTO_ALG_TYPE_AHASH) is evaluated, which is
> evaluated to either 0 or 1.
> 
> Then we mask everything together:
> 
> PD_CTL_HOST_READY | (0 || 1) | (PD_CTL_HOST_READY || 0)

The result is the same for both | and || as they are both higher
priority than ?: (which is only higher priority than ,).

The () around the == aren't needed (except to stop the compiler
bleating). The bitwise | is lower priority than == because it
existed before || and K&R didn't change the priority when they
added || (I think they've said later they wished they had.)

The () around the entire ?: clause are needed.

So the code is the same as:
	rval = PD_CTL_HOST_READY;
	if (alg_type == CRYPTO_ALG_TYPE_AHASH | alg_type == CRYPTO_ALG_TYPE_AEAD)
		rval |= PD_CTL_HASH_FINAL;
	return rval;

Using | may well generate faster code (no branches).

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

