From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH] CPU Jitter RNG: inclusion into kernel crypto API and /dev/random
Date: Tue, 05 Nov 2013 13:25:40 +0100
Message-ID: <4763730.CsXSbevC1J@tauon>
References: <2579337.FPgJGgHYdz@tauon> <3537770.iLHXPOXMiU@tauon> <20131103233207.GA5105@amd.pavel.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Theodore Ts'o <tytso@mit.edu>,
	sandy harris <sandyinchina@gmail.com>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Pavel Machek <pavel@ucw.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20131103233207.GA5105@amd.pavel.ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Montag, 4. November 2013, 00:32:07 schrieb Pavel Machek:

Hi Pavel,

>Hi!
>
>> Another friend of mine mentioned that he assumes the rise and fall
>> times of transistors varies very slightly and could be the main
>> reason for the jitter. I do not think that this is really the case,
>> because our gates that form the CPU instructions comprise of many
>> transistors. The combined raise/fall jitter should cancel each other
>> out.
>
>Plus, there's clock that should make sure that this jitter does not
>matter.
>
>> >There should be way to extract entropy more directly from various
>> >oscillator effects, no?
>> 
>> I am working a different way of measuring such oscillator effects by
>> using the high-resolution timer of the CPU and measure it with a
>> Jiffies-based snapshotting window. So, here I would combine two
>> timers
>> that are differently generated. If their frequencies would be
>> relative
>> prime to each other, we would measure a direct oscillator effect.
>
>I guess main problem is machines that do not have high-resolution
>timer on the CPU (rdtsc). They do not get enough entropy during boot,
>and the hell breaks loose.

That is right. That is also why I try to use the clocksource framework 
if the get_cycles righ-resolution timer is not available.
>
>But they usually _do_ have RTC or other clock, not driven by CPU
>oscilator. Good.
>
>What about just
>
>while (!enough_entropy) {
>      cur_time = read_rtc();
>      simulated_tsc = 0;
>      while (cur_time == read_rtc())
>      	    simulated_tsc++;
>      gain_entropy_from(simulated_tsc)
>}

That is an interesting piece of code -- what would you do in the 
gain_entropy_from function?
>
>(Where enough_entropy should be something like 128 bits).
>
>This should work, we know why it works (drift between rtc and cpu
>clock) and it does _not_ need rdtsc-style fast source.
>
>Disadvantage is that it burns cpu, but, well, you only need 128

That disadvantage should be no problem, because at the time we need 
entropy, burning some CPU cycles are ok. Encryption burns even more CPU 
cycles :-)

>bits. Asuming the rtc used has 100Hz resolution, enough entropy should
>be collected in under 2 seconds. That's acceptable adition to time it
>takes generating ssh keys on slow cpu.
>									
Pavel


Ciao
Stephan
