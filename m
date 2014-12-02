From: "George Spelvin" <linux@horizon.com>
Subject: Re: Is ansi_cprng.c supposed to be an implmentation of X9.31?
Date: 2 Dec 2014 14:43:05 -0500
Message-ID: <20141202194305.11304.qmail@ns.horizon.com>
References: <20141202134410.GC3388@hmsreliant.think-freely.org>
Cc: herbert@gondor.apana.org.au, jarod@redhat.com,
	linux-crypto@vger.kernel.org, smueller@chronox.de
To: linux@horizon.com, nhorman@tuxdriver.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ns.horizon.com ([71.41.210.147]:54529 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S933211AbaLBTnH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 2 Dec 2014 14:43:07 -0500
In-Reply-To: <20141202134410.GC3388@hmsreliant.think-freely.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

> Not sure what you're concerned about, or what you're even referencing.

Sorry for the confusion, but it's genuine.  See below for what I think is
the solution.

> The shash_desc structure represents a discrete block of data that is
> being hashed.  It can be updated with new data, reset, finalized, etc.
> It only points to the crypto_hash structure that it is associated with
> (as it must, given that the crypto layer needs to know what algorithm
> to use to hash the data and what key to use).  But it doesn't store a
> second copy of the key on its own.

Er, I saw the following code:

static int michael_setkey(struct crypto_shash *tfm, const u8 *key,
			  unsigned int keylen)
{
	struct michael_mic_ctx *mctx = crypto_shash_ctx(tfm);

	const __le32 *data = (const __le32 *)key;

	if (keylen != 8) {
		crypto_shash_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
		return -EINVAL;
	}

	mctx->l = le32_to_cpu(data[0]);
	mctx->r = le32_to_cpu(data[1]);
	return 0;
}

and thought "okay, the key is in mctx->l and mctx->r."

Then I saw

static int michael_init(struct shash_desc *desc)
{
	struct michael_mic_desc_ctx *mctx = shash_desc_ctx(desc);
	struct michael_mic_ctx *ctx = crypto_shash_ctx(desc->tfm);
	mctx->pending_len = 0;
	mctx->l = ctx->l;
	mctx->r = ctx->r;

	return 0;
}

and thought "the key is being copied from the ctx to the desc.  Why
the heck are they doing it in two steps?"

I spent a long time trying to figure out why there were two separate
layers, as it looked like

struct michael_mic_ctx {
	u32 l, r;
};

was a strict subset of

struct michael_mic_desc_ctx {
	u8 pending[4];
	size_t pending_len;

	u32 l, r;
};

and thus the former was unnecessary.

(Another code optimization that jumps out at me: given that pending_len
is strictly between 0 and 3, using a 64-bit size_t unnecessarily bloats
the context structure to 24 bytes.  Shrinking it to 32 bits would reduce
the context to 16 bytes, and given that at most three bytes of pending[]
are ever used, except transiently in the update() function, pending_len
could be stored in pending[3] and and the context shrunk to 12 bytes.)


I'm thinking that the confusion comes from my unfortunate choice of
which file to start reading and the peculiar way that michael_mic's key
is more like an IV, so there is neither key scheduling nor persistent
access to it.


== My guess as to how this works ==

(If I say anything wrong, please correct me!)

A ctx is an abstraction of a (scheduled) key.  With symmetric ciphers,
it's very common to have a complex key set up (I'm looking at you, twofish)
which can be re-used for multiple messages/packets/whatever.

It has to be an opaque object because it might correspond to some
state in a hardware acclerator, with the software swapping keys in
and out like virtual memory.

A desc is the abstraction of an IV.  It handles chaining and block
boundaries, to encrypt/hash/transform a stream/bvec/sk_buff of data.

The reason for the separation is that multiple descs may simultaneously
access the same ctx.

This is okay because the ctx reference is conceptually read-only.
(If there's swapping of hardware contexts going on behind the curtain,
the ctx may not be entirely immutable, but it's like a cache: you're
not supposed to notice the difference.)

There are some cases, like ECB, where a desc is a ridiculously thin
wrapper and seems like overkill, but it's there to provide a consistent
interface.

(Design choice: a single ctx can handle both encryption and decryption.
For algorithms that have different key schedules for the two directions,
it has to waste the space even if the cipher is only being used forward.)

>> (On a related point, the general lack of const declarations throughout the
>> crypto layer has been a source of frustration.)
 
> So fix it.  Making large claims about what frustrates you about the
> code without producing any fixes doesn't make people listen to you.

I'm happy to!  It's just a large, invasive, change and I wonder how welcome
it is.  Maybe there's a reason for the omission that I'm not seeing?

You know the aphorism "never attribute to malice that which can be
adequately explained by stupidity"?  Well, there's a follow-on, which
says be careful attributing to someone else's stupidity that which
can be adequately explained by your own.

It's a pattern I go through frequently, and I think others do too:
my initial reaction is "what the @#$@# is this $#!+?", but I try to
consider whether the fault is actually mine before speaking aloud (or
hitting "send", as the case may be).

If it's soemthing that annoys you too and you just haven't gotten around
to fixing it, I'd be delighted!

I just wanted to start with something smaller in scope, confined to
a single source file, where I felt like I understood the implications
better.

>> The other big issue I'm struggling with is how to get the tcrypt.ko module
>> to print "ansi_cprng has passed its tests."  All it has produced for me
>> so far is a few kilobytes of dmesg spam about ciphers which aren't even
>> configured in my kernel.

> The tests only print out a pass fail notification in fips mode, that seems
> pretty clear if you look at the alg_test function.

There are two major call paths from tcrypt_mod_init.

tcrypt_mod_init
-> do_alg_test
   -> crypto_has_alg
      -> crypto_alg_mod_lookup
         -> crypto_larval_lookup

tcrypt_mod_init
-> do_test
   -> tcrypt_test
      -> alg_test
         -> alg_find_test
         -> alg_test_cipher
         -> alg_test_descs[i].test
            -> alg_test_{aead,cipher,skcipher,comp,pcomp,hash,crc32c,...}

The second path, which seems to be broad testing, doesn't seem to print
anything on success, but I was hoping there was something on the first
path if I asked for a specific algorithm.  But that code path led me
far outside the "test" source files and I got lost chasing call chains
trying to find actual tests.

Hopefully you can see how, starting from the top, one might hope that
the first call path would lead to a single-algorithm test, which might
print more detailed informations.

I added a printk to alg_test_cprng() and got that to print after a while.
I just had so many errors in the logs about

> alg: hash: Failed to load transform for wp512: -2
> alg: hash: Failed to load transform for wp384: -2
> alg: hash: Failed to load transform for wp256: -2
> alg: skcipher: Failed to load transform for ecb(tnepres): -2
> alg: skcipher: Failed to load transform for ecb(anubis): -2
> alg: skcipher: Failed to load transform for cbc(anubis): -2
> alg: hash: Failed to load transform for tgr192: -2
> alg: hash: Failed to load transform for tgr160: -2
> alg: hash: Failed to load transform for tgr128: -2
> alg: skcipher: Failed to load transform for pcbc(fcrypt): -2
> alg: skcipher: Failed to load transform for ecb(camellia): -2

That I wasn't sure it if it actually ran the test I wanted, or had
already bailed out due to too many errors.
