From: Stephan Mueller <smueller@chronox.de>
Subject: Re: random: Wake up all getrandom(2) callers when pool is ready
Date: Thu, 21 May 2015 10:36:47 +0200
Message-ID: <9183463.XNhR7e5TNc@tauon>
References: <3340545.QDDPvU7BuN@tachyon.chronox.de> <9182932.rX0DhQWPrJ@tachyon.chronox.de> <20150521081953.GA22301@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: pebolle@tiscali.nl, andreas.steffen@strongswan.org, tytso@mit.edu,
	sandyinchina@gmail.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150521081953.GA22301@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Donnerstag, 21. Mai 2015, 16:19:54 schrieb Herbert Xu:

Hi Herbert,

>On Thu, May 21, 2015 at 09:55:17AM +0200, Stephan Mueller wrote:
>> So, I will create a 2nd wait queue in random.c for uninterruptible waits,
>> change the get_blocking_random_bytes back to void and use wait_event to
>> wait
>> for the initialization.
>
>Hold your horses.  You don't need a second queue, you just need to
>change wake_up_interruptible to wake_up.

A simple change to wake_up is not working -- I already checked. But the 
proposed wake_up_all does the trick.


Ciao
Stephan
