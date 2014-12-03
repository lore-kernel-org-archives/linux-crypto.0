From: "George Spelvin" <linux@horizon.com>
Subject: Re: [PATCH 00/17] Multiple changes to crypto/ansi_cprng.c
Date: 3 Dec 2014 15:27:53 -0500
Message-ID: <20141203202753.7691.qmail@ns.horizon.com>
References: <20141203111311.GC23296@hmsreliant.think-freely.org>
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	smueller@chronox.de
To: linux@horizon.com, nhorman@tuxdriver.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ns.horizon.com ([71.41.210.147]:48167 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751482AbaLCU1z (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 3 Dec 2014 15:27:55 -0500
In-Reply-To: <20141203111311.GC23296@hmsreliant.think-freely.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

> So, generally speaking I'm ok with most of this I think,

One open issue... I thought you had said that the non-determinsitic
version was not in the current X9.31 and I had the impression that it
wasn't wanted.  I've got reorganized patch series that gets rid of that
and just tweaks the comments.

I'm happy to put it back, of course.  Or just hold off until Herbert
chimes in with an opinion.

As an example of the reorganization, now the comment for patch 4 in the
series is a bit clearer:

    crypto: ansi_cprng - Eliminate ctx->I and ctx->last_rand_data
    
    Careful use of the other available buffers avoids the need for
    these, shrinking the context by 32 bytes.
    
    Neither the debug output nor the FIPS-required anti-repetition check
    are changed in the slightest.

(That's because I change the debug output in patches 2 and 3, to make
this more-sensitive patch easier to review.)

> but before it goes anywhere, it really needs to pass the NIST and FIPS
> test vectors.  Can you do that please and post the results?

It of course passes the ones in testmgr.h, and I can add the others from
http://csrc.nist.gov/groups/STM/cavp/documents/rng/RNGVS.pdf
and
http://csrc.nist.gov/groups/STM/cavp/documents/rng/rngtestvectors.zip

I didn't know there were separate FIPS test vectors for this PRNG;
can you give me a clue where to find them?


I'm also not sure what "the results" look like.  As I mentioned previously,
I have been unable to figure out how to make the tcrypt code print anything
in the event of a successful test, so its output is the empty string.

I am using my own version which prints "cprng: Test %d passed", and
I can turn debugging on, but the 10000-round MCT produces an annoying
amount of output in that case.

(Note to self: teach test_cprng to test odd-sized reads, since that was
a previous bug source and I'm touching that code some more.)

> I'm fine with changing the output, as I don't think anything
> particularly relies on the format, but I can't speak for others.

The current debug output for the first 5 testmgr.h tests (the 6th is
omitted) is follows, but obviously things get reconfirmed right at
the end.

getting 16 random bytes for context ffff88042ce41b18
Calling _get_more_prng_bytes for context ffff88042ce41b18
DT = e6b3be782a23fa62d71d4afbb0e922f9
V = 80000000000000000000000000000000
I = 92640cf08d302f2550ea3d73d1985385
V^I = 12640cf08d302f2550ea3d73d1985385
R = 59531ed13bb0c05584796685c12f7641
R^I = cb371221b680ef70d4935bf610b725c4
V' = 2ac489ad47640b6d86380229e769adc3
DT' = e6b3be782a23fa62d71d4afbb0e922fa
Returning new block for context ffff88042ce41b18
returning 16 from get_prng_bytes in context ffff88042ce41b18
cprng: Test 0 passed
getting 16 random bytes for context ffff88042ce41b18
Calling _get_more_prng_bytes for context ffff88042ce41b18
DT = e6b3be782a23fa62d71d4afbb0e922fa
V = c0000000000000000000000000000000
I = b30a8cba1c4cd3a14af7d9db9488f5f0
V^I = 730a8cba1c4cd3a14af7d9db9488f5f0
R = 7c222cf4ca8fa24c1c9cb641a9f3220d
R^I = cf28a04ed6c371ed566b6f9a3d7bd7fd
V' = fcbd61e7c51dd167624c56cb97b4c66d
DT' = e6b3be782a23fa62d71d4afbb0e922fb
Returning new block for context ffff88042ce41b18
returning 16 from get_prng_bytes in context ffff88042ce41b18
cprng: Test 1 passed
getting 16 random bytes for context ffff88042ce41b18
Calling _get_more_prng_bytes for context ffff88042ce41b18
DT = e6b3be782a23fa62d71d4afbb0e922fb
V = e0000000000000000000000000000000
I = d761699cc3de4a90234c62eec2479cd9
V^I = 3761699cc3de4a90234c62eec2479cd9
R = 8aaa003966675be529142881a94d4ec7
R^I = 5dcb69a5a5b911750a584a6f6b0ad21e
V' = ef2c1fbf609a68f8fe5110636bf4bf6a
DT' = e6b3be782a23fa62d71d4afbb0e922fc
Returning new block for context ffff88042ce41b18
returning 16 from get_prng_bytes in context ffff88042ce41b18
cprng: Test 2 passed
getting 16 random bytes for context ffff88042ce41b18
Calling _get_more_prng_bytes for context ffff88042ce41b18
DT = e6b3be782a23fa62d71d4afbb0e922fc
V = f0000000000000000000000000000000
I = 048ecb25943e8c31d614cd8a23f13f84
V^I = f48ecb25943e8c31d614cd8a23f13f84
R = 88dda456302423e5f69da57e7b95c73a
R^I = 8c536f73a41aafd4208968f45864f8be
V' = 48893b71bce400b65e21ba378a0ad570
DT' = e6b3be782a23fa62d71d4afbb0e922fd
Returning new block for context ffff88042ce41b18
returning 16 from get_prng_bytes in context ffff88042ce41b18
cprng: Test 3 passed
getting 16 random bytes for context ffff88042ce41b18
Calling _get_more_prng_bytes for context ffff88042ce41b18
DT = e6b3be782a23fa62d71d4afbb0e922fd
V = f8000000000000000000000000000000
I = 3a6a1754bdf6f844e53662990cadc492
V^I = c26a1754bdf6f844e53662990cadc492
R = 052592466179d2cb78c40b140a5a9ac8
R^I = 3f4f8512dc8f2a8f9df2698d06f75e5a
V' = ac4b23c4fb1e85098d9927afa617ad88
DT' = e6b3be782a23fa62d71d4afbb0e922fe
Returning new block for context ffff88042ce41b18
returning 16 from get_prng_bytes in context ffff88042ce41b18
cprng: Test 4 passed
self_test: err 0
prng_mod_init: err 0


>> I noticed the "unsigned char" vs "u8" issue, but didn't make the change
>> as I didn't think the readailility improvement was worth the code churn.

> You just sent a 17 patch series of clean up and were worried about code churn
> converting an unsigned char to a u8?

Yes, it does sound funny like that, but I meant that I have no trouble
reading the types as synonyms, so the improvement is very small, and it's
the ratio.

More simply, "I noticed, but it didn't make me itch enough."

Once I got deep enough into it, perhaps I should have re-evaluated.

>> Should I convert all the buffers and function prototypes,

> If you want to sure.  u8 probably makes more sense for the buffers here as our
> intent is to treat them as an array of byte values.

I had a look at <linux/crypto.h>, which uses u8 for everything, so I've
already changed everything to that.


Thank you for your time and effort looking at this!
