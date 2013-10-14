From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH] CPU Jitter RNG: inclusion into kernel crypto API and /dev/random
Date: Mon, 14 Oct 2013 16:40:54 +0200
Message-ID: <3593500.a7fOuGKlEX@tauon>
References: <2579337.FPgJGgHYdz@tauon> <CACXcFm=3Ee1+HGYRpsjhFMwqn2t15qAZNnMpZ8jOsE_HkB2CPg@mail.gmail.com> <CACXcFmnDjSWHrU-4dR=Nb5n-9t=0PmM9Bc_pOFMTi3eotR2g6A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Theodore Ts'o <tytso@mit.edu>, LKML <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org
To: Sandy Harris <sandyinchina@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:60391 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755699Ab3JNOlG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 14 Oct 2013 10:41:06 -0400
Received: from tauon.localnet
	by mail.eperm.de with [XMail 1.27 ESMTP Server]
	id <S15E> for <linux-crypto@vger.kernel.org> from <smueller@chronox.de>;
	Mon, 14 Oct 2013 16:40:55 +0200
In-Reply-To: <CACXcFmnDjSWHrU-4dR=Nb5n-9t=0PmM9Bc_pOFMTi3eotR2g6A@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Montag, 14. Oktober 2013, 10:14:00 schrieb Sandy Harris:

Hi Sandy,

>On Mon, Oct 14, 2013 at 9:38 AM, Sandy Harris <sandyinchina@gmail.com> 
wrote:
>> Stephan Mueller <smueller@chronox.de> wrote:
>>> Can you please help me understand why you think that a whitening
>>> function (cryptographic or not) is needed in the case of the CPU
>>> Jitter RNG, provided that I can show that each individual bit
>>> coming from the folding operation has one bit of entropy?
>> 
>> Basically, sheer paranoia. I'd mix and whiten just on general
>> principles. Since efficiency is not a large concern, there is little
>> reason not to.
>> 
>> On the other hand, most RNGs use a hash because they need
>> to distill some large amount of low-entropy input into a smaller
>> high-entropy output. With high input entropy, you do not need
>> the hash and can choose some cheaper mixer.
>
>You could use strong mixing/whitening:
>
>Feed into random(4) and let it do the mixing.

That is exactly the goal with the patch found in patches/linux-3.9-
random.patch in the code distribution.

And that approach is exactly what I do in the linking code / patches for 
other crypto libs:

- kernel crypto API

- OpenSSL (implementation as an Engine that uses the internal DRNGs or a 
hook into RAND_poll that implements the seeding for the DRNGs)

- libgcrypt (hook into the seeding of the DRNGs)

>
>Use some early outputs from your RNG to key an AES
>instance. Then encrypt later outputs; this gives a 64 in 64
>out mixer that is cryptographically strong but perhaps a bit
>slow in the context.

That is exactly what the SP800-90A CTR DRBG or the X9.31 does. As these 
DRNGs are available for different crypto libs, I am simply reusing them 
with the crypto lib linking code.
>
>Alternately, quite a few plausible components for fast cheap
>mixing are readily available.

Thank you for the references. I have seen that in your maxwell(8) 
documentation. But again, I do not re-invent the wheel with the CPU 
Jitter RNG and therefore skipped the whitening step based on the reasons 
above.

Another thing: when you start adding whitening functions, other people 
are starting (and did -- thus I added section 4.3 to my documentation) 
to complain that you hide your weaknesses behind the whiteners. I simply 
want to counter that argument and show that RNG produces white noise 
without a whitener.

Ciao
Stephan
