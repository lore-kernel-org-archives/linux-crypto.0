Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793575312;
	b=VNKn8+PVJCIx+iO3Z8IBwqcqd8yIjmPXxo2xtqZOPZKVV+KYSKLWQ8MmWFvEnFK23hXu
	 mumoGZ9LJpGcXDHJz6gYTpWV/yyXInVvKRDZTCJ2ta3aoSi9rkFZ/mv7DZpRsmzhbLMoR
	 dP7MNAuSOlI4ZERW1jC3cT9b9NP+4QbOaZTOuYBG5mU0ca3mXjOClN5bdo9lyg//btOp0
	 f2vwFR8irS9UejJvZXbZw8+bPQ6RiBxh1ItoTmoYQCsdSeMJVDjwARBA87Jn143kAF3Mb
	 jeg5i1BvN5MfWWU0JKxYHFcg2qR3ZzP6XCLypKqT1eAIxVQFnwlFn6NSZ9GT9TYgIIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793575312;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=Dk72iN7SVxUD+KiFtk3ED/m2rnC0xL8gpFKUthTaqew=;
	b=0ovNf7yGABPZwfuHqt9GWKOSftAi/dQ1hZ3w13ztqeJ2TegGblD+yjan9GTmI0ZEBU6u
	 IDm5pxPgbdGYJ7xmuXjMW2pQ3hXuytA5ckCA5Q1oTYZ+ylDjd0V8rsVJbvEPdbmB/q+YJ
	 yxK89Yn2iz64QSGgnw+rlWSn9GQEm6sQUHT7HoEBYMQmda62vh4OML0+Lzi1CNbp1W4xa
	 gLZRu1XI0bsLbKZQ502PbkFGOTSGlvXFAU0tEsvyT7lK6mzMgOfA19OgqK/bhfz/7313z
	 6cIJAbBhbly0kFrb43FOZFRBsnhUycVPeLCeTN05hXyK7IrOTEC65S+eDajeYM9SFMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bcPWCVl4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2E87606A324;
	Sun,  1 Nov 2026 23:21:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bcPWCVl4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE9F51F00919;
	Sun,  1 Nov 2026 23:21:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793575311;
	bh=Dk72iN7SVxUD+KiFtk3ED/m2rnC0xL8gpFKUthTaqew=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bcPWCVl4m4dl6rBvpQ5YYD26P8ZH6xm9Nx8NuFtIgnHX5QJfES6cAt2qzqYAHWQT6
	 LpfeWojwQSv6R+i+1rZjoY9SSg5PYjam+msSPwBXzwL8ZGb+n+OHhlTr2qFnq6Ypt7
	 GR8Xtci6SZiyml/TDAO02G3UASFlZQrGCGCdnMEzpFYsIhJPoLRGczDOZbfhM+EGiJ
	 2hE6d7xVnm6pgnrvYDR9Z4X7zn5MJEJA3AkQ5Qgv+I16QOwPnhqwlKu5ZN1ZIr1e7+
	 8lq9yb1mPIVDcBCWyx86lVQM0/CIRFS5tkFM52LnOraRGYgYxM36rFfJcgqqDEKinz
	 naKb829A7V4Iw==
Date: Sun, 1 Nov 2026 15:21:49 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Jarkko Sakkinen <jarkko@kernel.org>
Cc: David Howells <dhowells@redhat.com>, keyrings@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Lukas Wunner <lukas@wunner.de>, Ignat Korchagin <ignat@linux.win>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	"open list:ASYMMETRIC KEYS" <linux-crypto@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>,
	"open list:SECURITY SUBSYSTEM" <linux-security-module@vger.kernel.org>
Subject: Re: [PATCH v4 2/3] KEYS: Replace assoc_array with rhashtable
Message-ID: <20261101232149.GC2689@quark>
References: <20261029232437.2581640-1-jarkko@kernel.org>
 <20261029232437.2581640-3-jarkko@kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261029232437.2581640-3-jarkko@kernel.org>

On Fri, Oct 30, 2026 at 01:24:10AM +0200, Jarkko Sakkinen wrote:
> It is the sole user of this data structure,
> which has during the age of LLMs transformed into a maintenance nightmare.

As I said on v3, this probably should be reworded to be more specific.
Otherwise it sounds subjective, and it may become a weird Phoronix
headline like "Linux awakens from associative array nightmare".
See the sentence I suggested at
https://lore.kernel.org/keyrings/20261027012952.GC2395@quark/

> assoc_array is replaced with three new data types:

Well, 'struct keyring_edit' is the odd one out, since it replaces
'struct assoc_array_edit', not 'struct assoc_array'.  It is also
temporary transactional state.

It would be clearer to say that the replacement for 'struct assoc_array'
is 'struct keyring_index'.  Then describe what that contains (which
would include mentioning 'struct keyring_link').

It would also be worth mentioning explicitly that this is a significant
negative diff in the keyrings subsystem, since correctly integrating
with assoc_array was quite complex.

Overall I suggest de-emphasizing the rhashtable in the commit message
slightly, given that it's just one piece of the new implementation.
After all, it could have been a basic custom hashtable instead, and
other high-level details of this commit would still be the same.

> Jhashes used by rhashtable are rehashed from the SipHash digests of the
> search keys and links.

The commit message should mention explicitly whether there are any
userspace-visible behavior changes or not.

KEYCTL_READ now outputs in insertion order, not hash order, right?  And
likewise for the search order of sibling keyrings.  Those differences
should be fine, but they should be mentioned.  Any other changes?

> -/*
> - * Hash a key type, domain and description.  KEYCTL_READ exposes the tree's
> - * traversal order, so no part of the index may contain kernel addresses.
> + * Hash a key type, domain and description.
>   */
>  static void hash_key_type_and_desc(struct keyring_index_key *index_key)
>  {
> -	const unsigned level_shift = ASSOC_ARRAY_LEVEL_STEP;
> -	const unsigned long fan_mask = ASSOC_ARRAY_FAN_MASK;
>  	static siphash_key_t hash_key __read_mostly;
> -	unsigned long hash;
>  	u64 acc;
>  
>  	get_random_once(&hash_key, sizeof(hash_key));
>  	acc = siphash(index_key->description, index_key->desc_len, &hash_key);
> -	acc = siphash_3u64(index_key->type_id, index_key->domain_id, acc,
> -			   &hash_key);
> -
> -	/* Fold the hash down to 32 bits if need be. */
> -	hash = acc;
> -	if (ASSOC_ARRAY_KEY_CHUNK_SIZE == 32)
> -		hash ^= acc >> 32;
> -
> -	/* Squidge all the keyrings into a separate part of the tree to
> -	 * ordinary keys by making sure the lowest level segment in the hash is
> -	 * zero for keyrings and non-zero otherwise.
> -	 */
> -	if (index_key->type != &key_type_keyring && (hash & fan_mask) == 0)
> -		hash |= (hash >> (ASSOC_ARRAY_KEY_CHUNK_SIZE - level_shift)) | 1;
> -	else if (index_key->type == &key_type_keyring && (hash & fan_mask) != 0)
> -		hash = (hash + (hash << level_shift)) & ~fan_mask;
> -	index_key->hash = hash;
> +	index_key->hash = siphash_3u64((uintptr_t)index_key->type,
> +				       (uintptr_t)index_key->domain_tag,
> +				       acc, &hash_key);

There should be a comment here that explains why it's safe to hash the
pointers and truncate the hash value.  It is clear to me but will not be
to others.  Here is what I suggested on v1:

        /*
         * Compute a SipHash value of the description, type pointer, and domain
         * tag pointer using a per-boot random key.
         *
         * Note that using the pointers as input to the hash is safe, since
         * SipHash is a cryptographically secure pseudorandom function.  Thus
         * the hash values don't leak any information about the pointers.
         *
         * Similarly, truncating the SipHash values to the required 32 bits is
         * also safe.  No "folding" step is needed.
         */

Side note: keyring.c now uses jhash as well, so it should include
<linux/jhash.h> explicitly rather than rely on transitive inclusion.

- Eric
