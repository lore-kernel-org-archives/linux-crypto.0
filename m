From: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: Is ansi_cprng.c supposed to be an implmentation of X9.31?
Date: Tue, 2 Dec 2014 08:44:10 -0500
Message-ID: <20141202134410.GC3388@hmsreliant.think-freely.org>
References: <2758504.R15xM8Vjc0@tauon>
 <20141202053930.30892.qmail@ns.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: smueller@chronox.de, herbert@gondor.apana.org.au, jarod@redhat.com,
	linux-crypto@vger.kernel.org
To: George Spelvin <linux@horizon.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:40831 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752962AbaLBNoU (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 2 Dec 2014 08:44:20 -0500
Content-Disposition: inline
In-Reply-To: <20141202053930.30892.qmail@ns.horizon.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Dec 02, 2014 at 12:39:30AM -0500, George Spelvin wrote:
> > See Documentation/DocBook/crypto-API.tmpl in the cryptodev-2.6 tree. 
> > There you will find tons of documentation (which will be merged during 
> > 3.19-rc1)
> 
> Yes, I've been reading that.  It certainly helps a great deal, but
> still leaves me with some significant questions.
> 
> I started researching the crypto layer when I proposed using Dan
> Bernstein's SipHash elsewhere in the kernel and someone asked for a
> crypto API wrapper for it.  That seemed a simple enough request to me,
> but it's been a deeper rabbit hole than I expected.
> 
> I started reading the code to another keyed hash, michael_mic, as a model,
> but I'm stil trying to understand the intended difference between "struct
> crypto_shash" and "struct shash_desc", and in particular why both have
> a copy of the key.  The SHASH API documentation at
> 
> https://git.kernel.org/cgit/linux/kernel/git/herbert/cryptodev-2.6.git/tree/include/crypto/hash.h
> 
> isn't particularly enlightening.  If the crypto_shash were entirely
> read-only and the shash_desc were the entire volatile state, that would
> make sense, but as it is I'm confused about the design intent.
> 
Not sure what you're concerned about, or what you're even referencing.  A
struct crypto_shash is the object retured by crypto_alloc_shash, and represents
an instance of a synchronous hash algorithm:
struct crypto_shash {
        unsigned int descsize;
        struct crypto_tfm base;
};

The key is stored in the base.__crt_ctx part of the structure in a algorithm
specific manner.

The shash_desc structure represents a discrete block of data that is being
hashed.  It can be updated with new data, reset, finalized, etc.  It only points
to the crypto_hash structure that it is associated with (as it must, given that
the crypto layer needs to know what algorithm to use to hash the data and what
key to use).  But it doesn't store a second copy of the key on its own.

> (On a related point, the general lack of const declarations throughout the
> crypto layer has been a source of frustration.)
> 
So fix it.  Making large claims about what frustrates you about the code without
producing any fixes doesn't make people listen to you.
> 
> The other big issue I'm struggling with is how to get the tcrypt.ko module
> to print "ansi_cprng has passed its tests."  All it has produced for me
> so far is a few kilobytes of dmesg spam about ciphers which aren't even
> configured in my kernel.
> 
The tests only print out a pass fail notification in fips mode, that seems
pretty clear if you look at the alg_test function.

> After a few hours of trying to figure out what the alg and type parameters
> do, I gave up and cut and pasted the tests into prng_mod_init().

They're used to differentiate algorithms that can be used for multiple purposes.
See the CRYPTO_ALG_TYPE_* defines in crypto.h.  For the CPRNG, they do nothing
since an RNG is only an RNG.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
