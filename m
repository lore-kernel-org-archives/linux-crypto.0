From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [RFC][PATCH] Entropy generator with 100 kB/s throughput
Date: Sun, 10 Feb 2013 13:25:58 +0100
Message-ID: <511791D6.7000600@chronox.de>
References: <51157686.9000404@chronox.de> <20130209180629.GD8091@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Theodore Ts'o <tytso@mit.edu>, linux-crypto@vger.kernel.org,
	lkml <linux-kernel@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:47718 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754173Ab3BJM0D (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 10 Feb 2013 07:26:03 -0500
In-Reply-To: <20130209180629.GD8091@thunk.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 09.02.2013 19:06:29, +0100, Theodore Ts'o <tytso@mit.edu> wrote:

Hi Ted,

thank you for the review.
> On Fri, Feb 08, 2013 at 11:04:54PM +0100, Stephan Mueller wrote:
>> * an array of statistical test suites pass the output of the entropy
>> collector
>>   (again, the output is not mangled with cryptography)
> You're not mangling the output with cryptography, but you are doing
> some mangling in jitterentropy_cpu_jitter().
>
> So let's be clear about what the heart of your entropy source is:
>
> You're getting the nanoseconds out of clock_gettime(CLOCK_REALTIME),
> and then mixing it using XOR and a ROL(3) into a 64-bit buffer, and
> interspersing the calls to clock_gettime() with schedule().

Correct.
>
> So what a code breaker at the NSA would probably try to do first is t=
o
> measure is whether there is any kind of bias or non-entropy in the
> nanoseconds returned by CLOCK_REALTIME after calls to schedule().  If
> they can find any kind of bias, they can use that to calculate what
> kind of patterns or non-random bits might end up showing up after you
> do your non-cryptographic mangling.

I thought I have countered such possibility already with the following =
2
concepts:

1. Before entropy is extracted from the pool, at the minimum 9 * 16
clock measurements (we have 16 rounds in jitterentropy_cpu_jitter and a=
t
least 9 rounds in jitterentropy_gen_entropy due to the entropy
calculation and the limit of 7 bits of entropy per round) are fed into
the pool with the strong possibility of more. The number of measurement=
s
mixed into the pool depends on the amount of entropy the heuristic
applies to the time needed to perform the 16 rounds of measurements and
the previous delta.

2. The entropy heuristic is measuring the delta of deltas to calculate
the entropy -- and thus implicitly how often the 16 clock measurements
are applied. With the use of deltas of deltas (i.e. kind of the 2nd
derivation of the absolute time measurements), the code implies 0 bit o=
f
entropy for evenly spaced time measurements (i.e. no jitter) and time
measurements with a too coarse timer.
>
> For that reasons, what I would suggest doing first is generate a
> series of outputs of jitterentropy_get_nstime() followed by
> schedule().  Look and see if there is any pattern.  That's the proble=
m
> with the FIPS 140-2 tests.  Passing those tests are necessary, but

Note, I am not using FIPS 140-2 tests as there are none. I try to use
the tests NIST and the German BSI would require when you come along wit=
h
an RNG for validation. In addition, I use the dieharder test suite with
its tons of tests.

> *NOT* sufficient to prove that you have a good cryptographic
> generator.  Even the tiniest amount of post-processing, even if they
> aren't cryptographic, can result in an utterly predictable series of
> numbers to pass the FIPS 140-2 tests.

Thank you very much for the suggestions. I will perform the suggested t=
est.

On the other hand the entropy generator is intended to serve as a seed
source for the DRNGs. One of the goals I tried to achieve is ease of us=
e
without the possibility to misuse the implementation. With that in mind=
,
for the kernel implementation, I guess jitterentropy_read_entropy shoul=
d
not be exported with EXPORT_SYMBOL and should be static.

This change implies that in the kernel only the DRNGs are accessible
where the strong DRNG (jitterentropy_strong_drng) should conceptually b=
e
as strong as blocking_pool (without the blocking nature) and the regula=
r
DRNG (jitterentropy_reg_drng) is conceptually the equivalent to
nonblocking_pool which is guaranteed to be reseeded.

Thanks
Stephan
>
> Regards,
>
> 						- Ted
>
> --=20
> Ciao
> Stephan
>
> atsec information security GmbH, Steinstra=DFe 70, 81667 M=FCnchen, G=
ermany
> P: +49 89 442 49 830 - F: +49 89 442 49 831
> M: +49 172 216 55 78 - HRB: 129439 (Amtsgericht M=FCnchen)
> GF: Salvatore la Pietra, Staffan Persson
> atsec it security news blog - atsec-information-security.blogspot.com
>
> --=20
> | Cui bono? |
