From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH] CPU Jitter RNG: inclusion into kernel crypto API and /dev/random
Date: Wed, 06 Nov 2013 13:51:17 +0100
Message-ID: <9172761.DO0L6FkY0c@tauon>
References: <2579337.FPgJGgHYdz@tauon> <4306229.ErfOL470s2@tauon> <20131106124354.GJ14235@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Pavel Machek <pavel@ucw.cz>, sandy harris <sandyinchina@gmail.com>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Nicholas Mc Guire <der.herr@hofr.at>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20131106124354.GJ14235@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Mittwoch, 6. November 2013, 07:43:54 schrieb Theodore Ts'o:

Hi Theodore,

>On Wed, Nov 06, 2013 at 12:49:45PM +0100, Stephan Mueller wrote:
>> Here is a quote from his answer to my question whether he was able to
>> identify the root cause:
>> 
>> "its inherent in the microtiming of Hardware and there is nothing you
>> can do about it if you want the root cause is quantum physics"
>
>That's unfortunate, since it leaves open the question of whether this
>jitter is something that could be at least somewhat predictable if you
>had a lot more information about the internal works of the CPU or
>not....

I do not understand that answer: I thought we are talking about the 
search of non-predictable noise sources. If you cannot predict the 
sequence even if you have the state of the CPU, that is what we are 
looking for, is it not?

Besides, how on earth shall an attacker even gain knowledge about the 
state of the CPU or disable CPU mechanisms? Oh, I forgot, your NSA guy. 
But if he is able to do that, all discussions are moot because he simply 
disables any noise sources by flipping a bit, reads the memory that is 
used to hold the state of the RNG or just overwrites the memory 
locations where data is collected, because the general protection 
mechanisms offered by the kernel and the underlying hardware are broken.

Also, does your answer mean you would disregard radioactive decay that 
is not predictable due to quantum physics and Heisenberg?

Ciao
Stephan
