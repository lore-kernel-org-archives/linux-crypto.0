From: chandramouli narayanan <mouli@linux.intel.com>
Subject: Re: v3.17-rc5: alg: skcipher: Test 4 failed on encryption for
 ctr-aes-aesni
Date: Wed, 24 Sep 2014 15:23:56 -0700
Message-ID: <1411597436.2324.5.camel@pegasus.jf.intel.com>
References: <87sijti8kh.fsf@kima.orebokech.com>
	 <87fvfr2v3w.fsf@kima.orebokech.com>
	 <20140917112911.GA2129@gondor.apana.org.au>
	 <CA+rthh-oZQhT0eAney-T0jkSTxB51-qRWofi7omfCcD5J0-9gQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	James Guilford <james.guilford@intel.com>,
	Sean Gulley <sean.m.gulley@intel.com>,
	Romain Francoise <romain@orebokech.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Mathias Krause <minipli@googlemail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:19696 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750821AbaIXWQn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 24 Sep 2014 18:16:43 -0400
In-Reply-To: <CA+rthh-oZQhT0eAney-T0jkSTxB51-qRWofi7omfCcD5J0-9gQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, 2014-09-22 at 00:28 +0200, Mathias Krause wrote:
> On 17 September 2014 13:29, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> > On Tue, Sep 16, 2014 at 10:01:07PM +0200, Romain Francoise wrote:
> >> On Mon, Sep 15, 2014 at 10:36:46AM +0200, Romain Francoise wrote:
> >> > I upgraded from v3.16 to v3.17-rc5 and the ctr-aes-aesni encryption test
> >> > fails, which makes my IPsec tunnels unhappy (see trace below). Before I
> >> > start bisecting (2cddcc7df8fd3 is probably my first guess), is this
> >> > already known?
> >>
> >> > Sep 15 08:07:56 silenus kernel: [   35.137145] alg: skcipher: Test 4 failed on encryption for ctr-aes-aesni [...]
> >>
> >> Update: reverting 2cddcc7df8 ("crypto: aes - AES CTR x86_64 "by8" AVX
> >> optimization") fixes this. This machine is Sandy Bridge (Core i7-2600),
> >> and the problem doesn't seem to occur with the exact same kernel image
> >> on Ivy Bridge (Xeon E3-1240v2).
> >
> > Thanks for bisecting.  If we can't fix this quickly then we should
> > just revert it for now.
> >
> 
> [Adding James and Sean as they're stated as "contact information"]
> 
> I compared the implementation against the original code from Intel
> referenced in the source file and found a few differences. But even
> after removing those, the code still generates the same error. So if
> Chandramouli does not come up with something, we should revert it, as
> the reference implementation from Intel is a) either wrong or b) used
> wrongly in the Linux kernel.
> 
> What might be worth noting, the failing test uses an IV value of
> "\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFD",
> or, in other words, a counter value that'll wrap after processing
> three blocks. The Crypto++ implementation explicitly states, it can
> handle the wrap around (see [1]). Dumping the IV before and after the
> cryptomgr tests shows, the "by8" implementation only handles the lower
> 32 bit as a counter. Looking at RFC 3686, it defines the "counter
> block" as a 128 bit combination of nonce, IV and a 32 bit counter
> value. It also defines the initial value of the counter part (1) and
> how it should be incremented (increment the whole counter block, i.e.
> the 128 bit value). However, it also states that the maximum number
> blocks per packet are (2^32)-1. So, according to the RFC, the wrap
> around cannot happen -- not even for the 32 bit part of the counter
> block. However the other aesni-backed implementation does handle the
> wrap around just fine. It does so by doing the increment on a integer
> register so it can use the carry flag to detect the wrap around.
> Changing the "by8" variant would be straight forward, but I fear
> performance implications... :/
> 
> Looking back at the test vector, even if it might be inappropriate for
> IPsec, it is still valid for AES-CTR in the general case. So IMHO the
> "by8" implementation is wrong and should be fixed -- or reverted, for
> that matter.

It will take some time for me to debug this issue. Is there a list of
test vectors to debug with?

thanks
-mouli
> 
> James, Sean: Have you observed any interoperability problems with the
> Intel reference implementation for the AVX by8 variant of AES-CTR?
> Especially, have you tested the code for wrapping counter values?
> 
> 
> Regards,
> Mathias
> 
> [1] http://www.cryptopp.com/wiki/CTR_Mode
