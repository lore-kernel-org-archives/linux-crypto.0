From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v2 00/25] Multiple changes to crypto/ansi_cprng.c
Date: Mon, 15 Dec 2014 07:14:43 +0100
Message-ID: <4224700.3m7VJgkz0U@tachyon.chronox.de>
References: <20141214203738.20811.qmail@ns.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	nhorman@tuxdriver.com
To: George Spelvin <linux@horizon.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:55044 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750781AbaLOGOs (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 15 Dec 2014 01:14:48 -0500
Received: from tachyon.chronox.de
	by mail.eperm.de with [XMail 1.27 ESMTP Server]
	id <SC4CF> for <linux-crypto@vger.kernel.org> from <smueller@chronox.de>;
	Mon, 15 Dec 2014 07:14:44 +0100
In-Reply-To: <20141214203738.20811.qmail@ns.horizon.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Sonntag, 14. Dezember 2014, 15:37:38 schrieb George Spelvin:

Hi George,

> In an earlier conversation with Neil, I had an idea that I'd like
> your opinion on.
> 
> I still think whether true-random mode is wanted is up in the air,
> but if it is, a better way to proide it would be to create a separate
> crypto_alg for it, with a smaller seed size (no DT seed) and its own name.
> 
In my personal view, there is no need for such rather non-deterministic 
behavior. The reasons are several-fold:

- one who wants non-deterministic operation goes straight to get_random_bytes 
or uses stdrng in a normal system. This RNG is built for that purpose. Though, 
get_random_bytes is logically /dev/urandom. If somebody wants to have an in-
kernel /dev/random implementation, I have one available. When I come around, I 
want to make that in-kernel /dev/random as a seed source for my DRBG. That in-
kernel /dev/random would be a good seed source for the X9.31 too -- and here 
you should put your effort into, IMHO. 

- the non-determinism you get from get_random_int is very weak. If you start 
thinking about the information theoretical entropy behind that function that 
is used once in a while, you may not get much entropy. Please, please, please, 
I do not want to start a discussion around entropy -- I will not participate 
in such discussion :-)

- the deterministic RNGs are cryptographically strong. Thus, when you seed 
them with a good noise source like get_random_bytes, you will get good random 
numbers. Ensure proper reseeding and you will be on the safe side.

Thus, I am questioning whether such slightly non-deterministic RNG would be 
used.

> But I have no idea what name to use.  Any suggestions?  And a FIPS
> version, too?

There is no FIPS version of a non-deterministic RNG. Either deterministic or 
die (the SP800-90B death).

-- 
Ciao
Stephan
