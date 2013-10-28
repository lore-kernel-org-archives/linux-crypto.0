From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH] CPU Jitter RNG: inclusion into kernel crypto API and /dev/random
Date: Mon, 28 Oct 2013 17:15:38 +0100
Message-ID: <1433673.JyzufUuaAG@tauon>
References: <2579337.FPgJGgHYdz@tauon> <2049321.gMV6JUDze7@tauon> <20131028160623.GD15440@khazad-dum.debian.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Theodore Ts'o <tytso@mit.edu>,
	sandy harris <sandyinchina@gmail.com>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20131028160623.GD15440@khazad-dum.debian.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Montag, 28. Oktober 2013, 14:06:23 schrieb Henrique de Moraes 
Holschuh:

Hi Henrique,

>On Mon, 28 Oct 2013, Stephan Mueller wrote:
>> If it is accepted that the CPU Jitter RNG delivers entropy, the
>> latter
>> update may now allow us to get rid of storing the seed file during
>> shutdown and restoring it during the next boot sequence.
>
>That's a 4096-bit safety net (uncredited entropy) which at least Debian
>shall not remove.

That is correct, and I did not want have such safety net removed.

I have to correct my initial statement: there is a possibility where the 
CPU Jitter RNG may not deliver data: when the timer resolution is too 
coarse. Thus, please disregard my notion to remove the user space 
seeding.

My goal is that the entropy pools are filled with entropy at the time 
when they are created so that they will deliver good random data if the 
system has a high resolution timer (which is almost always the case as 
shown with my tests).

>
>I think Debian also dumps some low-entropy-per-bit crap into
>/dev/random during boot (again, not credited), such as the boot kernel
>logs.  We could increase the density of that entropy a lot using gzip
>-0 or something like that... is an uncredited low-entropy-per-bit dump
>into the pool detrimental to its quality?

Any mixing of data into the entropy pools can never diminish the 
entropy, but just further mix the data.

Note, a simple write of data into the device files will never update the 
entropy estimator that is behind the blocking of /dev/random. All that 
is done by the write to the device files is the mixing of the entropy 
pools of blocking_pool and nonblocking_pool (and not input_pool).

Ciao
Stephan
