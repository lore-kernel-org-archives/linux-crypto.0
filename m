From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v4 0/6] Seeding DRBG with more entropy
Date: Mon, 04 May 2015 07:40:12 +0200
Message-ID: <9802019.GiEn27gNxE@tauon>
References: <1626703.0h1HzJAx4d@tachyon.chronox.de> <20150503205834.GJ10014@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: herbert@gondor.apana.org.au, Paul Bolle <pebolle@tiscali.it>,
	Andreas Steffen <andreas.steffen@strongswan.org>,
	Sandy Harris <sandyinchina@gmail.com>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34699 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752201AbbEDFkQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 4 May 2015 01:40:16 -0400
In-Reply-To: <20150503205834.GJ10014@thunk.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Sonntag, 3. Mai 2015, 16:58:34 schrieb Theodore Ts'o:

Hi Theodore,

>On Sun, May 03, 2015 at 05:33:00PM +0200, Stephan Mueller wrote:
>> The patch set adds an in-kernel /dev/random equivalent that was discussed
>> with Ted Ts'o last July -- see [2] and [3]. A test module for testing the
>> asynchronous operation of the in-kernel /dev/random is given with the code
>> below.
>> 
>> Ted: shall we really create and maintain a new entropy pool (the
>> kernel_pool), or should the in-kernel /dev/random logic draw directly from
>> the input_pool? In other words, shall we drop the first patch and update
>> the 2nd patch to use input_pool? Also, I would not recommend using the
>> blocking_pool as this would mix kernel and user land operation.
>
>I'd drop the 3rd pool, and just simply block until the non-blocking

So, you have no concern to use the same pool that is also used by user land?

>pool has been initialized.  That's now considered the best practice
>for userspace programs, which is to use getrandom(2), which by default
>will block until the nonblocking pool has been initialized with an
>estimated 128 bits of entropy, and after that point, all of the kernel
>users should be quite satisfied with cryptographic entropy.

I am not sure that this approach is helpful, because the suggested approach 
implies using a seeded DRNG and the used get_random_bytes already operates as 
a (not always seeded) DRNG. If we have a blocking interface in the kernel, I 
would recommend to make it identical to /dev/random. With the suggested 
seeding approach for DRBG, we definitely have seed data available to start 
with. Therefore, re-seeding it from another seeded DRNG (i.e. the nonblocking 
pool after it is initialized) may not give us too much extra.

Therefore, may I propose to link the in-kernel blocking API to the blocking 
pool and have it behave exactly like /dev/random?
>
>Certainly from the perspective of the perspective of a NIST evaluator
>for a DRBG, using if they're happy using jitterentropy as a noise
>source, they should be quite happy using the non-blocking pool as a
>noise source, so long as it has been properly initialized.

They should definitely be happy with that. Even more so, when it is clear that 
the DRBG is re-seeded once information theoretical entropy is available.

Personally, I feel that only considering the blocking_pool as a good source of 
entropy because it is constantly seeded with information theoretical entropy 
makes not much sense as that entropy is always and only used for mechanisms 
that only exhibit computational strength and *not* information theoretical 
strength. But I deviate from the topic and do not want to start another 
entropy discussion. :-)
>
>As far as the concern of user space being able to block a kernel user
>"indefinitely", in practice I really don't think that's going to be an
>issue as far as boot-time initialization is concerned.  In practice
>the urandom pool gets 128 bits of entropy *very* quickly, as in,
>before the boot process is finished.

Just as an FYI: the word "very" does not apply in all cases. I am about to 
draft an email about that subject in the near future. But the problem is that 
on SSD systems or virtual machines, the disk is no source of randomness any 
more starting with 3.18 where all non-rotational block devices are not used as 
a seed source any more. We only have interrupts which initialize the 
nonblocking pool much later (in my Haswell systems around the time index of 
20). There are other problems that I would like to report separately.

[...]
>
>(And if the attacker is able to inject arbitrary programs running
>during the init sequence, they are almost certainly running as root,
>and you've got other problems.)

No objections on the last statement :-)


Ciao
Stephan
