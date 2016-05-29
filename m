From: Stephan Mueller <smueller@chronox.de>
Subject: Re: AES-NI: slower than aes-generic?
Date: Sun, 29 May 2016 21:51:59 +0200
Message-ID: <7574982.B7hkDJezet@positron.chronox.de>
References: <1567400.ZMFoPuCv2K@tauon.atsec.com> <4972668.UQ1QRNriDb@positron.chronox.de> <FEA29793-B67A-4C0D-A904-909A62BB3E65@azet.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Sandy Harris <sandyinchina@gmail.com>,
	Theodore Ts'o <tytso@mit.edu>
To: Aaron Zauner <azet@azet.org>, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:35082 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932373AbcE2TwD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 29 May 2016 15:52:03 -0400
In-Reply-To: <FEA29793-B67A-4C0D-A904-909A62BB3E65@azet.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Samstag, 28. Mai 2016, 07:28:25 schrieb Aaron Zauner:

Hi Aaron,

> Heya,
> 
> > On 27 May 2016, at 01:49, Stephan Mueller <smueller@chronox.de> wrote:
> > Then, the use of the DRBG offers users to choose between a Hash/HMAC and
> > CTR implementation to suit their needs. The DRBG code is agnostic of the
> > underlying cipher. So, you could even use Blowfish instead of AES or
> > whirlpool instead of SHA -- these changes are just one entry in
> > drbg_cores[] away without any code change.
> 
> That's a really nice change and something I've been thinking about for a
> couple of months as well. Then I came across tytso's ChaCha patches to
> urandom and was thinking ISA dependent switches between ciphers would make
> sense, i.e. you get AESNI performance when there's support.
> > Finally, the LRNG code is completely agnostic of the underlying
> > deterministic RNG. You only need a replacement of two small functions to
> > invoke the seeding and generate operation of a DRNG. So, if one wants a
> > Chacha20, he can have it. If one wants X9.31, he can have it. See section
> > 2.8.3 [1] -- note, that DRNG does not even need to be a kernel crypto API
> > registered implementation.
> It's valid criticism that the number of algorithms should be limited.
> Algorithmic agility is an issue and has caused many real-world security
> problems in protocols liberally granting crypto primitives to be chosen by
> the user isn't a good idea. We should think about algorithms that make
> sense. E.g. TLS 1.3 and HTTP/2 have been moving into this direction. TLS
> 1.3 will only allow a couple off cipher-suites as opposed to combinatorial
> explosion with previous iterations of the protocol.

I cannot agree more with you, if the attacker can choose the algo. However, I 
would think that a compile time selection of one specific algo is not prone to 
this issue. Also, the code of the LRNG provides a pre-defined set of DRBGs 
that should not leave any wish open. Hence, I am not sure that too many folks 
would change the code here.

Though, if folks really want to, they have the option to do so.
> 
> I'd suggest sticking to AES-CTR and ChaCha20 for DRNG designs. That should
> fit almost all platforms with great performance, keep code-base small etc.

Regarding the CTR DRBG: I did not make it default out of two reasons:

- it is not the fastest -- as I just found a drag on the CTR DRBG performance 
that I want to push upstream after closing the merge window. With that patch 
the CTR DRBG now is the fastest by orders of magnitude. So, this issue does 
not apply any more.

- the DF/BCC function in the DRBG is critical as I think it looses entropy 
IMHO. When you seed the DRBG with, say 256 or 384 bits of data, the BCC acts 
akin a MAC by taking the 256 or 384 bits and collapse it into one AES block of 
128 bits. Then he DF function expands this one block into the DRBG internal 
state including the AES key of 256 / 384 bits depending on the type of AES you 
use. So, if you have 256 bits of entropy in the seed, you have 128 bits left 
after the BCC operation.

Given that criticism, I am asking whether the use of the CTR DRBG with AES > 
128 should be used as default. Also, the CTR DRBG is the most complex of all 
three DRBGs (with the HMAC, the current default, is the leanest and cleanest).

But if folks think that the CTR DRBG should be made the default, I would 
listen and make it so.

> 
> There's now heavily optimised assembly in OpenSSL for ChaCha20 if you want
> to take a look:
> https://github.com/openssl/openssl/tree/master/crypto/chacha/asm But as
> mentioned in the ChaCha/urandom thread: architecture specific optimisation
> may be painful and error-prone.

I personally am not sure that taking some arbitrary cipher and turning it into 
a DRNG by simply using a self-feeding loop based on the ideas of X9.31 
Appendix A2.4 is good. Chacha20 is a good cipher, but is it equally good for a 
DRNG? I do not know. There are too little assessments from mathematicians out 
there regarding that topic.

Hence, I rather like to stick to DRNG designs that have been analyzed by 
different folks.

> > Bottom line, I want to give folks a full flexibility. That said, the LRNG
> > code is more of a logic to collect entropy and maintain two DRNG types
> > which are seeded according to a defined schedule than it is a tightly
> > integrated RNG.
> > 
> > Also, I am not so sure that simply taking a cipher, sprinkling some
> > backtracking logic on it implies you have a good DRNG. As of now, I have
> > not seen assessments from others for the Chacha20 DRNG approach. I
> > personally would think that the Chacha20 approach from Ted is good. Yet
> > others may have a more conservative approach of using a DRNG
> > implementation that has been reviewed by a lot of folks.
> > 
> > [1] http://www.chronox.de/lrng/doc/lrng.pdf
> 
> Currently reading that paper, it seems like a solid approach.

There was criticism on the entropy maintenance. I have now reverted it to the 
classical, yet lockless, LFSR approach. Once the merge window closes, I will 
release the new version.
> 
> I don't like the approach that user-space programs may modify entropy. It's
> a myth that `haveged` etc. provide more security, and EGDs have been barely
> audited, usually written as academic work and have been completely
> unmaintained. I regularly end up in randomness[sic!] discussions with core
> language maintainers [0] [1] - they seem to have little understanding of
> what's going on in the kernel and either use /dev/random as a seed or a
> Userspace RNG (most of which aren't particularly safe to begin with --
> OpenSSL is not fork safe [2] [3], a recent paper found weaknesses in the
> OpenSSL RNG at low entropy state leaking secrets [4] et cetera). This seems
> to be mostly the case because of the infamous `random(4)` man-page. With
> end-users (protocol implementers, core language designers,..) always
> pointing to upstream, which - of course - is the Linux kernel.

Point taken, but I cannot simply change the existing user space interface. 
Hence, I modified it such that the data does not end up in some entropy pool, 
but is mixed into the DRBGs which are designed to handle date with and without 
entropy.
> 
> I can't really tell from the paper if /dev/random would still be blocking in
> some cases? If so that's unfortunate.

It is blocking, that is its nature: one bit of output data from /dev/random 
shall be backed by one bit of entropy from the noise sources. As the noise 
sources are not fast, it will block.

However, the /dev/urandom is now seeded with 256 bits of entropy very fast 
during boot cycle. Hence, if you use getrandom(2) which blocks until the 256 
bits of initial seed is reached, you should be good for any standard 
cryptographic purposes.

With the new up-and-coming release of the LRNG code, I also provide an updated 
documentation. That documentation contains a test of the entropy contained in 
the first 50 interrupt events after boot. With that test I record the timing 
of the first 50 interrupts for a test batch of 50,000 boots. That test shall 
demonstrate that the basic entropy estimate behind the LRNG is sound even 
during boot times. Hence, I think that when the LRNG defines that the DRBG 
behind /dev/urandom is seeded with 256 bits of entropy, it really received 
that amount of entropy.
 
> 
> Thanks for your work on this,
> Aaron
> 
> [0] https://bugs.ruby-lang.org/issues/9569
> [1] https://github.com/nodejs/node/issues/5798
> [2]
> https://emboss.github.io/blog/2013/08/21/openssl-prng-is-not-really-fork-sa
> fe/ [3] https://wiki.openssl.org/index.php/Random_fork-safety
> [4] https://eprint.iacr.org/2016/367.pdf


Ciao
Stephan
