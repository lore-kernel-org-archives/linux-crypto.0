Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793577847;
	b=Ms/6lcyMCcBkWI+Pp0vTaSFG594USi3PSQ7wPPcw1TTANs6YOqvO0oV2PrvVbkTInnfa
	 ije7EL6s7a48fMtcHvIWXH7b+baY4TVQWL+4mC8R6G7zwrMN3FWj/YLfGEbYdYc+sodDX
	 b3jqRuxnWxkN6zViLX+bdUKhlOitbLoxMiVTMZaVL02GKBUR3ez79EnUtOeTUOSZa9fWP
	 MlEG7flep/BsaWzthZ5P0qKjvNVgWtjCtW/YV/LUHPKKDoSsDekjQEYGlHp6KK0PjyDDM
	 5ZVyPV38uiQTW3ohj27F1N9ia8M7JmVE4T3SZDo1WvcvSP1CHu1UKGS844nud4GU/8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793577847;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=Yht5EhO2fepanr/r7uFa+SNwGFcgYQP5fg401lDqyv0=;
	b=ofueHHgVgQg72PjiPfWF6yDT5PebGU8NSNJiIk9AcqWPmjOtUcMBdr/0oPXjY3OSGRvR
	 1HAb65j1cv4szJ4gJI4FUSCKum5C40SWaDRbNdvNye2yXQoxLrVBjH8KWytr0YxofMOJQ
	 9ZekhmHWpdb1YxBU9SZff1nLPFtJwqMyaQbx43l0lpE9zJd2+qvRsZKDnk7xuc7DGCm6k
	 HzOapnOQFfWalfGjdXcPOw6gKulbZjekIR2tGd73zKTJ8Bz5WYokPT54jq5mXAEeiq03h
	 wCz1Q+8sDI0VwXUK+fSUsWDhWtHLPKf/2bQ4ujLJey4sY+TOR43bXFPBfZDquvF/6ug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lgoWLjoC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id DEC39606A331;
	Mon,  2 Nov 2026 00:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lgoWLjoC
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 3CD281F00919;
	Mon,  2 Nov 2026 00:04:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793577846;
	bh=Yht5EhO2fepanr/r7uFa+SNwGFcgYQP5fg401lDqyv0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lgoWLjoC3Bl4vLFt/K7GfHSW1aV2rqlvD1tpNVc93ALT6CDzfOmecmkpcmwkck7Wg
	 kwuskCJvtzf+nqzJkV0rs45qAG5fRScDjV1OlB94FdXvdDvBD1Puh9uf8WXOOitBZw
	 GMG4PbddiAPIF1+MgXP1TuXgWq3U8E693UPuHMPPAKVsPzjslZV9Me4XJexXNpkWaX
	 sw16c5NmcUOLqcZl4OWq5MQHThPRoM89luj1NuHg+YAohHiWtsa3W2wvJBvGgckQIf
	 6xpawYvq3OGiSaVCqm9gYGLUTS7N9FDEDssI6TkZZCWMDz6G6lSUxH+hoEZFj1QTL8
	 spLF9uldDntbQ==
Date: Mon, 2 Nov 2026 02:04:02 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
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
Message-ID: <aufTcqW-DTB9Ofai@kernel.org>
References: <20261029232437.2581640-1-jarkko@kernel.org>
 <20261029232437.2581640-3-jarkko@kernel.org>
 <20261101232149.GC2689@quark>
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
In-Reply-To: <20261101232149.GC2689@quark>

On Sun, Nov 01, 2026 at 03:21:49PM -0800, Eric Biggers wrote:
> On Fri, Oct 30, 2026 at 01:24:10AM +0200, Jarkko Sakkinen wrote:
> > It is the sole user of this data structure,
> > which has during the age of LLMs transformed into a maintenance nightmare.
> 
> As I said on v3, this probably should be reworded to be more specific.
> Otherwise it sounds subjective, and it may become a weird Phoronix
> headline like "Linux awakens from associative array nightmare".
> See the sentence I suggested at
> https://lore.kernel.org/keyrings/20261027012952.GC2395@quark/

The point I'm trying to deliver is that the evaluation of the
implementation is not important overall.

Or like, we just need key-value that works well for sparse keys, not any
"special keyring aware" key-value store. Thus, having our own one and
maintaining that is not worth it.

I could just write that?

I think practical QA reasons dictate this change more than anything
related to the kernel internals in-depth. E.g., it's great that 
whenever any bug is fixed in rhashtable that fix also improves
keyring too. And that objectively attenuates the LLM hit rate.

> 
> > assoc_array is replaced with three new data types:
> 
> Well, 'struct keyring_edit' is the odd one out, since it replaces
> 'struct assoc_array_edit', not 'struct assoc_array'.  It is also
> temporary transactional state.
> 
> It would be clearer to say that the replacement for 'struct assoc_array'
> is 'struct keyring_index'.  Then describe what that contains (which
> would include mentioning 'struct keyring_link').
> 
> It would also be worth mentioning explicitly that this is a significant
> negative diff in the keyrings subsystem, since correctly integrating
> with assoc_array was quite complex.
> 
> Overall I suggest de-emphasizing the rhashtable in the commit message
> slightly, given that it's just one piece of the new implementation.
> After all, it could have been a basic custom hashtable instead, and
> other high-level details of this commit would still be the same.

These are good points. I have not clearly paid enough attention to the
commit messages.

> 
> > Jhashes used by rhashtable are rehashed from the SipHash digests of the
> > search keys and links.
> 
> The commit message should mention explicitly whether there are any
> userspace-visible behavior changes or not.
> 
> KEYCTL_READ now outputs in insertion order, not hash order, right?  And
> likewise for the search order of sibling keyrings.  Those differences
> should be fine, but they should be mentioned.  Any other changes?

Keyrings are prepended, keys are appended, and while linking a key a
match with type, description and domain retains its place.

Right now any other major changes don't come to mind but yeah that
can be broken down a bit.

> 
> > -/*
> > - * Hash a key type, domain and description.  KEYCTL_READ exposes the tree's
> > - * traversal order, so no part of the index may contain kernel addresses.
> > + * Hash a key type, domain and description.
> >   */
> >  static void hash_key_type_and_desc(struct keyring_index_key *index_key)
> >  {
> > -	const unsigned level_shift = ASSOC_ARRAY_LEVEL_STEP;
> > -	const unsigned long fan_mask = ASSOC_ARRAY_FAN_MASK;
> >  	static siphash_key_t hash_key __read_mostly;
> > -	unsigned long hash;
> >  	u64 acc;
> >  
> >  	get_random_once(&hash_key, sizeof(hash_key));
> >  	acc = siphash(index_key->description, index_key->desc_len, &hash_key);
> > -	acc = siphash_3u64(index_key->type_id, index_key->domain_id, acc,
> > -			   &hash_key);
> > -
> > -	/* Fold the hash down to 32 bits if need be. */
> > -	hash = acc;
> > -	if (ASSOC_ARRAY_KEY_CHUNK_SIZE == 32)
> > -		hash ^= acc >> 32;
> > -
> > -	/* Squidge all the keyrings into a separate part of the tree to
> > -	 * ordinary keys by making sure the lowest level segment in the hash is
> > -	 * zero for keyrings and non-zero otherwise.
> > -	 */
> > -	if (index_key->type != &key_type_keyring && (hash & fan_mask) == 0)
> > -		hash |= (hash >> (ASSOC_ARRAY_KEY_CHUNK_SIZE - level_shift)) | 1;
> > -	else if (index_key->type == &key_type_keyring && (hash & fan_mask) != 0)
> > -		hash = (hash + (hash << level_shift)) & ~fan_mask;
> > -	index_key->hash = hash;
> > +	index_key->hash = siphash_3u64((uintptr_t)index_key->type,
> > +				       (uintptr_t)index_key->domain_tag,
> > +				       acc, &hash_key);
> 
> There should be a comment here that explains why it's safe to hash the
> pointers and truncate the hash value.  It is clear to me but will not be
> to others.  Here is what I suggested on v1:
> 
>         /*
>          * Compute a SipHash value of the description, type pointer, and domain
>          * tag pointer using a per-boot random key.
>          *
>          * Note that using the pointers as input to the hash is safe, since
>          * SipHash is a cryptographically secure pseudorandom function.  Thus
>          * the hash values don't leak any information about the pointers.
>          *
>          * Similarly, truncating the SipHash values to the required 32 bits is
>          * also safe.  No "folding" step is needed.
>          */
> 
> Side note: keyring.c now uses jhash as well, so it should include
> <linux/jhash.h> explicitly rather than rely on transitive inclusion.

+1

> 
> - Eric

Br, Jarkko
