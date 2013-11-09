From: Clemens Ladisch <clemens@ladisch.de>
Subject: Re: [PATCH] CPU Jitter RNG: inclusion into kernel crypto API and
 /dev/random
Date: Sat, 09 Nov 2013 23:04:07 +0100
Message-ID: <527EB157.70109@ladisch.de>
References: <2579337.FPgJGgHYdz@tauon> <9172761.DO0L6FkY0c@tauon> <20131107010357.GC1950@opentech.at> <4606253.6dPOReUPaz@tauon>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Nicholas Mc Guire <der.herr@hofr.at>,
	Theodore Ts'o <tytso@mit.edu>, Pavel Machek <pavel@ucw.cz>,
	sandy harris <sandyinchina@gmail.com>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4606253.6dPOReUPaz@tauon>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Stephan Mueller wrote:
> Am Donnerstag, 7. November 2013, 02:03:57 schrieb Nicholas Mc Guire:
>> On Wed, 06 Nov 2013, Stephan Mueller wrote:
>>> Besides, how on earth shall an attacker even gain knowledge about the
>>> state of the CPU or disable CPU mechanisms? Oh, I forgot, your NSA
>>> guy. But if he is able to do that, all discussions are moot because
>>> he simply disables any noise sources by flipping a bit, reads the
>>> memory that is used to hold the state of the RNG or just overwrites
>>> the memory locations where data is collected, because the general
>>> protection mechanisms offered by the kernel and the underlying
>>> hardware are broken.
>>
>> No need to gain knowledge of the internal CPU state itt would be
>> sufficient to be able to put the CPU in a sub-state-space in which
>> the distribution is shifted. it may be enough to reduce the truely
>> random bits of some key only by a few bits to make it suceptible to
>> brute force attacks.
>
> Note, the proposed RNG contains an unbias operation (the Von-Neumann
> unbiaser) which is proven to remove any bias when it is established that
> the individual observations are independent. And the way the
> observations are generated ensures that they are independent.

"Independent" does not mean that your own code avoids reusing data from
the previous loop iteration; it means that the _entire_ process that
generates the bits is not affected by any memory of the past.

The observations are derived from the internal CPU state, which is *not*
reset between measurements.


Regards,
Clemens
