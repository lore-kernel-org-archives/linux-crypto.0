From: Stephan Mueller <smueller@chronox.de>
Subject: Re: AES-NI: slower than aes-generic?
Date: Thu, 26 May 2016 20:49:39 +0200
Message-ID: <4972668.UQ1QRNriDb@positron.chronox.de>
References: <1567400.ZMFoPuCv2K@tauon.atsec.com> <CACXcFmnFn_BDv_xLra-gfSTsOP-diTwtvU4_TndLAv+WuXG4DQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Stephan Mueller <stephan.mueller@atsec.com>,
	linux-crypto@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
To: Sandy Harris <sandyinchina@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34862 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932127AbcEZStm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 26 May 2016 14:49:42 -0400
In-Reply-To: <CACXcFmnFn_BDv_xLra-gfSTsOP-diTwtvU4_TndLAv+WuXG4DQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 26. Mai 2016, 14:20:19 schrieb Sandy Harris:

Hi Sandy,
> 
> Why are you using AES? Granted, it is a reasonable idea, but when Ted
> replaced the non-blocking pool with a DBRG, he used a different cipher
> (I think chacha, not certain) and I think chose not to use the crypto
> library implementation to avoid kernel bloat.
> 
> So he has adopted on of your better ideas. Why not follow his
> lead on how to implement it?

Using the kernel crypto API one can relieve the CPU of the crypto work, if a 
hardware or assembler implementation is available. This may be of particular 
interest for smaller systems. So, for smaller systems (where kernel bloat is 
bad, but where now these days more and more hardware crypto support is added), 
we must weigh the kernel bloat (of 3 or 4 additional C files for the basic 
kernel crypto API logic) against relieving the CPU of work.

Then, the use of the DRBG offers users to choose between a Hash/HMAC and CTR 
implementation to suit their needs. The DRBG code is agnostic of the 
underlying cipher. So, you could even use Blowfish instead of AES or whirlpool 
instead of SHA -- these changes are just one entry in drbg_cores[] away 
without any code change.

Finally, the LRNG code is completely agnostic of the underlying deterministic 
RNG. You only need a replacement of two small functions to invoke the seeding 
and generate operation of a DRNG. So, if one wants a Chacha20, he can have it. 
If one wants X9.31, he can have it. See section 2.8.3 [1] -- note, that DRNG 
does not even need to be a kernel crypto API registered implementation.

Bottom line, I want to give folks a full flexibility. That said, the LRNG code 
is more of a logic to collect entropy and maintain two DRNG types which are 
seeded according to a defined schedule than it is a tightly integrated RNG.

Also, I am not so sure that simply taking a cipher, sprinkling some 
backtracking logic on it implies you have a good DRNG. As of now, I have not 
seen assessments from others for the Chacha20 DRNG approach. I personally 
would think that the Chacha20 approach from Ted is good. Yet others may have a 
more conservative approach of using a DRNG implementation that has been 
reviewed by a lot of folks.

[1] http://www.chronox.de/lrng/doc/lrng.pdf

Ciao
Stephan
