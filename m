From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: [PATCH 0/2] RNG: Add Pseudo Random Number Generator to kernel
Date: Fri, 4 Jul 2008 10:44:15 +0200
Message-ID: <20080704084415.GA17212@Chamillionaire.breakpoint.cc>
References: <20080703201924.GA5237@hmsendeavour.rdu.redhat.com> <20080703203955.GA13654@Chamillionaire.breakpoint.cc> <87iqvmsfpa.fsf@basil.nowhere.org> <20080704021028.GA7484@hmsreliant.think-freely.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: Andi Kleen <andi@firstfloor.org>, linux-crypto@vger.kernel.org,
	herbert@gondor.apana.org.au, davem@davemloft.net
To: Neil Horman <nhorman@tuxdriver.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:41170 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751844AbYGDIoV (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 4 Jul 2008 04:44:21 -0400
Content-Disposition: inline
In-Reply-To: <20080704021028.GA7484@hmsreliant.think-freely.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Neil Horman | 2008-07-03 22:10:28 [-0400]:

>On Fri, Jul 04, 2008 at 01:36:33AM +0200, Andi Kleen wrote:
>> Sebastian Siewior <linux-crypto@ml.breakpoint.cc> writes:
>> >
>> > Anything wrong with get_random_bytes()?
>> > Whats the advantage over get_random_bytes()?
>> 
>> get_random_bytes() is not a _pseudo_ random number generator,
>> it doesn't have a seed and you cannot get repeatable sequences
>> out of it.
>> 
>> random32.c is though, but currently it's not reseedable either.
>> I needed a true reseedable prng a few times too so this
>> would be useful, although i guess random32.c could have been
>> fixed. But perhaps there's a need for a more cryptographically
>> strong PRNG too.
>> 
>> -Andi
>I've not looked at random32.c specifically, but I wrote this module specifically
>to be FIPS 140 compliant, which requires several things, including, but not
>limited to the use of the AES and DES3 ciphers.  The details of the requirements
>that I wrote it to are found in ANSI X9.31, you can find it here:
Do you want a repeatable random number generator or just to be FIPS140
compliant (for instance for a certificate thing)?

>http://csrc.nist.gov/groups/STM/cavp/documents/rng/931rngext.pdf
I take a look on that.

>
>Best
>Neil

Sebastian
