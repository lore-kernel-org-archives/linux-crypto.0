From: Nick Kossifidis <mickflemm@gmail.com>
Subject: Re: [PATCH 2/2] ath9k: export HW random number generator
Date: Sat, 7 Nov 2015 17:39:21 -0600
Message-ID: <CAFtRNNyWzRKQbq1wa8=6V=tOQzB3g9jEBLhAO7iSchNAzf=fkQ@mail.gmail.com>
References: <1436946847-10909-1-git-send-email-miaoqing@qca.qualcomm.com>
	<a8b787bd17d94e8899bf1be6131165b2@NASANEXM01E.na.qualcomm.com>
	<55B60BC9.8040800@rempel-privat.de>
	<3945775.m5HblJPgiO@tauon.atsec.com>
	<8738043ith.fsf@kamboji.qca.qualcomm.com>
	<3ec13417acdc48628adaedb68d259b9c@NASANEXM01E.na.qualcomm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Kalle Valo <kvalo@codeaurora.org>,
	Stephan Mueller <smueller@chronox.de>,
	"Sepehrdad, Pouyan" <pouyans@qti.qualcomm.com>,
	"Jacobson, David" <djacobso@qti.qualcomm.com>,
	Oleksij Rempel <linux@rempel-privat.de>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Theodore Ts'o" <tytso@mit.edu>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"nhorman@tuxdriver.com" <nhorman@tuxdriver.com>
To: "Pan, Miaoqing" <miaoqing@qti.qualcomm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qg0-f45.google.com ([209.85.192.45]:33906 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753495AbbKGXjX (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 7 Nov 2015 18:39:23 -0500
In-Reply-To: <3ec13417acdc48628adaedb68d259b9c@NASANEXM01E.na.qualcomm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello all,

That was partially my intention too when I submitted
2aa56cca3571fd08c0c38f3e2d4bb0bfb3def3c5 which mixes FFT measurements
to the entropy pool without providing any estimation on entropy
(entropy estimation is the wrong approach, read the papers on fortuna
for more information on that). I believe that this approach is better
than mine because FFT data is too much (high throughput) and may have
a negative impact on the pool when mixed like this (even without the
entropy count) so Kale please revert my patch also (I was about to
submit a request for reverting it and writing something similar when
this thread came up). I believe that exporting the card as a hw rng
and letting a userspace helper do the whitening and the post
processing is the proper approach.

The idea behind exposing a device as a hw random number generator is
not that it's output is ready to be used. It's just an entropy source.
Almost every entropy source has some bias and no it's not always
expected from a hw rng to do whitening on it's own, it's actually more
secure to get the raw data and perform the whitening yourself because
if what you get from the hw rng is already being post-processed then
there is no way to know if someone has hidden a backdoor there (that
was the big discussion about Intel's RDRAND and the possibility of an
NSA backdoor in there -it could just be AES on CTR mode with a known
key/iv-, we get whitened data so we don't know if we can trust them).
A userspace helper is needed for proper whitening and statistical
analysis (and no fips is not enough, try dieharder and ent and then go
for more custom stuff) because we should keep the kernel clean. That's
what rngd was supposed to do (do the whitening on userspace and then
submit it back to the kernel's pool).

What's wrong with exporting the atheros cards as a hw random number
generator ? Is the recently added jitter RNG (currently exposed as an
RNG through the CryptoAPI) any better ? Does it have stronger entropy
claims ? It just passes the statistical tests, it doesn't mean it has
good "randomness" (let me remind you hpa's comments on HAVEGEd on
LinuxCon 2012), a CPU is a deterministic system, the fact that there
are many parameters on this system -not on all CPUs by the way, not
everything out there is a cisc with branch prediction etc- turns it to
a very complex system to analyze (chaotic behavior) which is good
enough for what we want but it doesn't compare to an actual physical
phenomenon such as E/M noise (btw a type of "jitter" is already mixed
on the /dev/random's entropy pool since 2013 when I submitted this
http://lkml.iu.edu/hypermail/linux/kernel/1211.2/00863.html -again
with no entropy estimation and only by using timers- but it's not
random in any way, it's just "too complicated to analyze" -that's what
hpa also told about HAVEGEd and I totally agree with him-).

The truth is that it's very hard to get good quality entropy in a way
that's guaranteed e.g. even in the atheros's case an attacker can bias
the RNG by hitting the card with a sine wave signal on the IF, only
quantum phenomena such as photon detection -e.g. through radioactive
decay- or even better measurements of the void based on Heisenberg's
uncertainty principle can be truly classified as random and not
always, we still have Bell's correlations such as entanglement -so
e.g. something that seems random to us locally might not be random to
the attacker, our system might be entangled with the attacker's
system-. Even the current hw rngs supported by the framework might
provide non-random data in case of hw failure (think of an RNG based
on avalanche effect with a broken diode), that's why we should always
do extensive post-processing and kernel is not the place for that.

Some more comments here: I see people trusting HAVEGEd and entropy
from sound cards, video cards etc and even provide some "proof" about
how good that is. It's all wrong ! First of all there is no definition
of randomness, if we could define randomness it wouldn't be random any
more (we 'd have some information about it), there is only the
uncertainty principle. Second you can't have claims on entropy bounds
because such systems behave differently under different circumstances
or different configurations. HAVEGEd for example gathers entropy based
on the assumption that we have context switching and a complex CPU so
that it's too complicated to guess what's running on the system (again
no strong claims on entropy bounds it's just "it's messy enough, it
passes the tests, so it's ok"). Try running it on a real-time system
with a single process and you can say goodbye to any entropy claims.
Sound cards ? If you don't properly configure your sound card (even in
the case of having nothing connected on the mic, just gathering
thermal noise from the resistor) you 'll end up with no entropy at all
! Most sound cards have a noise cancellation system or they have a
volume threshold so they won't give anything below that (all zeroes,
no entropy), others will "loop" the signal when you raise the volume
enough and while you think that you get something random, you actually
get the same signal "looped" multiple times due to interference
between the input and output (so again no entropy claims can be made).
Video cards or web cams ? It depends on what they see, put a strong
light on them and again your entropy claims are invalid.

Trying to estimate the entropy is also very hard because you can only
measure the entropy from your point of view, not the attacker's. Take
a simple AES on CTR mode with a known key/iv to the attacker. You can
get its output, run your entropy estimator and find it full of entropy
but what looks random to you it won't be random to the attacker and
that's why we care about "high quality" randomness right ? It's for
cryptographic / security purposes, otherwise /dev/urandom is more than
enough (actually is good enough for crypto most of the times too).

So please let's stop arguing about what is random, more random, higher
quality random etc. We have an entropy source here, let's use it.
We'll never be able to know how good it is anyway.


2015-07-31 3:39 GMT-05:00 Pan, Miaoqing <miaoqing@qti.qualcomm.com>:
> +Pouyan & David.
>
> -----Original Message-----
> From: Kalle Valo [mailto:kvalo@codeaurora.org]
> Sent: Friday, July 31, 2015 3:09 PM
> To: Stephan Mueller
> Cc: Oleksij Rempel; Pan, Miaoqing; linville@tuxdriver.com; linux-wireless@vger.kernel.org; Theodore Ts'o; linux-crypto@vger.kernel.org; nhorman@tuxdriver.com
> Subject: Re: [PATCH 2/2] ath9k: export HW random number generator
>
> Stephan Mueller <smueller@chronox.de> writes:
>
>>>-rw-rw-r-- 1 lex lex 2564096 Jul 27 11:36 hwrng.out
>>>-rw-rw-r-- 1 lex lex 2468394 Jul 27 11:36 hwrng.out.bz2
>>>
>>>Do i understand it correctly, in case of hwrng bzip was able to find
>>>enough pattern to compressed the data? Even with format overhead?
>>>
>>>I'm no an expert, help of an expert would be welcome, added some more
>>>people to CC
>>
>> This one does not look good for a claim that the RNG produces white
>> noise. An RNG that is wired up to /dev/hwrng should produce white
>> noise. Either by having an appropriate noise source or by conditioning
>> the output of the noise source.
>>
>> When conditioning the output, you have to be careful about the entropy claim.
>> For example, you cannot state that the data stream from your noise
>> source has close to one bit of entropy for each obtained bit. Thus,
>> the conditioner must ensure that the data from the noise source is
>> collected and its entropy is maintained and accumulated.
>>
>> However, the hwrandom framework does not provide any conditioning
>> logic. And I would say that such conditioner logic should not reside
>> in a driver either. I would say that the discussed RNG does not seem
>> fit for hooking it up with the hwrandom framework.
>
> Based on the discussion I'm going to revert this patch, at least for now.
>
> --
> Kalle Valo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
GPG ID: 0xEE878588
As you read this post global entropy rises. Have Fun ;-)
Nick
