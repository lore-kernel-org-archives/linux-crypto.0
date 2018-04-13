From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH 1/5] random: fix crng_ready() test
Date: Fri, 13 Apr 2018 07:38:30 +0200
Message-ID: <1699469.KmO53oa8XU@tauon.chronox.de>
References: <20180413013046.404-1-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        stable@kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180413013046.404-1-tytso@mit.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Freitag, 13. April 2018, 03:30:42 CEST schrieb Theodore Ts'o:

Hi Theodore,

> The crng_init variable has three states:
> 
> 0: The CRNG is not initialized at all
> 1: The CRNG has a small amount of entropy, hopefully good enough for
>    early-boot, non-cryptographical use cases
> 2: The CRNG is fully initialized and we are sure it is safe for
>    cryptographic use cases.
> 
> The crng_ready() function should only return true once we are in the
> last state.
> 
Do I see that correctly that getrandom(2) will now unblock after the 
input_pool has obtained 128 bits of entropy? Similarly for 
get_random_bytes_wait.

As this seems to be the only real use case for crng_ready (apart from 
logging), what is the purpose of crng_init == 1?

Ciao
Stephan
