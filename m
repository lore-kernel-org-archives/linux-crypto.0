From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [ANNOUNCE] /dev/random - a new approach (code for 4.11-rc1)
Date: Sat, 18 Mar 2017 17:36:36 +0100
Message-ID: <1562063.6VeVDMHaV5@positron.chronox.de>
References: <2785457.pDyvZpZC2q@positron.chronox.de> <4792500.irvFnm0WRl@positron.chronox.de> <CAH8yC8nHEQfZCf0j0rcW9KV-DNzkv-Sowch4ROK07HXzT5bFCA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: LKML <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org
To: noloader@gmail.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:58108 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751087AbdCRQgo (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 18 Mar 2017 12:36:44 -0400
In-Reply-To: <CAH8yC8nHEQfZCf0j0rcW9KV-DNzkv-Sowch4ROK07HXzT5bFCA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Samstag, 18. März 2017, 14:43:18 CET schrieb Jeffrey Walton:

Hi Jeffrey,

> > I am not sure how this statement relates to the quote above. RDSEED is the
> > CBC-MACed output of the flip-flop providing the raw noise.
> > 
> > RDRAND is the output of the SP800-90A CTR DRBG that is seeded by the
> > CBC-MAC that also feeds RDSEED. Thus, RDSEED is as fast as the noise
> > source where RDRAND is a pure deterministic RNG that tries to be
> > (re)seeded as often as possible.
> > 
> > Both instructions are totally unrelated to the SP800-90A DRBG available to
> > the Linux kernel.
> 
> SP800-90A requires an entropy source to bootstrap the Hash, HMAC and
> CTR generators. That is, the Instantiate and Reseed functions need an
> approved source of entropy. Both RDRAND and RDSEED are approved for
> Intel chips. See SP800-90A, Section 8.6.5
> (http://csrc.nist.gov/publications/nistpubs/800-90A/SP800-90A.pdf).

I am aware that SP800-90A makes the claim of having an approved noise source. 
But as of now, there is no such thing.

NIST is aware of that issue. To cover that issue during a FIPS 140-2 
validation, you have to prove your noise sources to be compliant to SP800-90B. 
I performed such noise source assessments as part of the FIPS 140-2 
validations of the Intel Sunrise Point or the Qualcomm HW DRBG FIPS 140-2 
validations. Also, I completed such assessments for the FIPS 140-2 validations 
of the legady /dev/random covering numerous Linux-based cryptographic modules 
over the last couple of years.

To get a glimpse of how such assessments for FIPS 140-2 are conducted, please 
have a look at the assessment [1] section 5.3.2.1 starting on page 72 in the 
lower half (note that I was the main author of this study). To be honest, the 
assessment in [1] section 5.5 was the main motivation for my LRNG 
implementation.

That said, [2] section 3.4.1, starting at page 34 bottom, you see the same 
SP800-90B test approach that was equally accepted by NIST during formal FIPS 
140-2 validations of other noise sources. Hence, I would conclude that my 
suggested implementation of the noise source is appropriate for a DRBG to be 
compliant to section 8.6.5 of SP800-90A.

But you mention a very important topic: is it and how is it ensured that the 
DRBG is appropriately seeded. This issue is discussed in [2] section 2.1 which 
explains the initial, minimal and full seeded stages of the DRBG.

[1] https://www.bsi.bund.de/SharedDocs/Downloads/DE/BSI/Publikationen/Studien/
ZufallinVMS/Randomness-in-VMs.pdf

[2] http://www.chronox.de/lrng/doc/lrng.pdf

Ciao
Stephan
