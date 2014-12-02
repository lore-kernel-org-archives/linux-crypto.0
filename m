From: "George Spelvin" <linux@horizon.com>
Subject: Re: Is ansi_cprng.c supposed to be an implmentation of X9.31?
Date: 2 Dec 2014 00:39:30 -0500
Message-ID: <20141202053930.30892.qmail@ns.horizon.com>
References: <2758504.R15xM8Vjc0@tauon>
Cc: herbert@gondor.apana.org.au, jarod@redhat.com,
	linux-crypto@vger.kernel.org, nhorman@tuxdriver.com
To: linux@horizon.com, smueller@chronox.de
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ns.horizon.com ([71.41.210.147]:24241 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754288AbaLBFjb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 2 Dec 2014 00:39:31 -0500
In-Reply-To: <2758504.R15xM8Vjc0@tauon>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

> See Documentation/DocBook/crypto-API.tmpl in the cryptodev-2.6 tree. 
> There you will find tons of documentation (which will be merged during 
> 3.19-rc1)

Yes, I've been reading that.  It certainly helps a great deal, but
still leaves me with some significant questions.

I started researching the crypto layer when I proposed using Dan
Bernstein's SipHash elsewhere in the kernel and someone asked for a
crypto API wrapper for it.  That seemed a simple enough request to me,
but it's been a deeper rabbit hole than I expected.

I started reading the code to another keyed hash, michael_mic, as a model,
but I'm stil trying to understand the intended difference between "struct
crypto_shash" and "struct shash_desc", and in particular why both have
a copy of the key.  The SHASH API documentation at

https://git.kernel.org/cgit/linux/kernel/git/herbert/cryptodev-2.6.git/tree/include/crypto/hash.h

isn't particularly enlightening.  If the crypto_shash were entirely
read-only and the shash_desc were the entire volatile state, that would
make sense, but as it is I'm confused about the design intent.

(On a related point, the general lack of const declarations throughout the
crypto layer has been a source of frustration.)


The other big issue I'm struggling with is how to get the tcrypt.ko module
to print "ansi_cprng has passed its tests."  All it has produced for me
so far is a few kilobytes of dmesg spam about ciphers which aren't even
configured in my kernel.

After a few hours of trying to figure out what the alg and type parameters
do, I gave up and cut and pasted the tests into prng_mod_init().
