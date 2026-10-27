Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793064595;
	b=3RkAUQvBvtItWfm+XKAqkvyYZb8oqdYfTHHupByGgVJkI44DFO//9zyMjl1jZodjTB2Y
	 y/ncqGy1h3G7n4m/Y4mryXYUxgYzkqpYAwvGKVBfxwqoAH/QF2FCDGftEP8PBm4AKrTOf
	 NlZtxqCyJ66DkcMhFiZ4vgwpGHn+QbKETLVFeDY5dG0n+crt0mj6hBrXWtusiGH8fAsQN
	 udhBkYbZ4woiC0vP3VSbAAlc0JDA/pcQt7LEgD3+4c+Z5wZx+nwrFKqwuKEipORzk1zrS
	 BXRUUSGsT+/gZfpxDoSlyY1Om1OXNdHqZVXvTJEjFdivl4VWhJyNzCpQlJy+Gf+E17g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793064595;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=p8YUEB5vAMRvOf5OeDQiiHc5kpIwmgv+KjmsEzv4j1k=;
	b=FiClMFd0rJZGKW5azlkB0+LtiRX5psZmopsyBBiGr7WutiGHPfQNazJPZrPP9OmtooUj
	 8OBN5xMjN5jNDL3mr52FdqBbSeYuJ8BoDvPE3JcQErW2U2qx7tu/bEqg7H8tV/YWqAG3p
	 BF2Cbmr5lgZZSkVMWH8/UHMx16zkcDUXu63a7MOmsR026XUCPqzMzgJgaTcLBn6Wv5NUL
	 vuCUrcbJD5756ZJcLKxkeZvYk3OS+YvE/wiiNXDDOWtmEQz9cjNJSsKlJ1MW+Y7JnuGy6
	 riOWqet1/8rX1P13IdgI3WwLQQAWa5bTsFhOlpUUT+ohQCx21QSPxFwiLsdeuGL/x4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VZEWej39;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7253606A31A;
	Tue, 27 Oct 2026 01:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VZEWej39
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 051491F01825;
	Tue, 27 Oct 2026 01:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793064594;
	bh=p8YUEB5vAMRvOf5OeDQiiHc5kpIwmgv+KjmsEzv4j1k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VZEWej39vk0mGD2cAHdjTJF3IluHxQpjZtp8dXoMrsX1F7c/nHw/e6tTcYjdaRu//
	 t3e0E+fX/yqoSX7KwrZhG0t0w/VrqCiQUh5dPEwtBwlsF7PA/r0zrFx9/CwC+3SyP/
	 WrUF97HskuCY+iuG+nUgnLaESUdEsFhu/a3LNa0rg1/FINO2gNw4TRhs27focvY4BN
	 xJqBiWteQaBpOBwrgAKNCVGB0k0lD+9lVPYcPoL4TdCoEdNfO0I/xvBasMBLjvnQRQ
	 JkvQd5H5k2Um09vaS7aXx8nVQ2ZD3QD9NX1s8OJwPUTHufStzYnm2pyfxWq4knMjS6
	 Yc7r8rLd2FOVw==
Date: Mon, 26 Oct 2026 18:29:52 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Jarkko Sakkinen <jarkko@kernel.org>
Cc: David Howells <dhowells@redhat.com>, keyrings@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Graf <tgraf@suug.ch>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	open list <linux-kernel@vger.kernel.org>,
	"open list:RHASHTABLE" <linux-crypto@vger.kernel.org>,
	"open list:SECURITY SUBSYSTEM" <linux-security-module@vger.kernel.org>
Subject: Re: [PATCH v3 5/6] KEYS: Replace assoc_array with rhashtable
Message-ID: <20261027012952.GC2395@quark>
References: <20261025001105.1824178-1-jarkko@kernel.org>
 <20261025001105.1824178-6-jarkko@kernel.org>
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
In-Reply-To: <20261025001105.1824178-6-jarkko@kernel.org>

On Sun, Oct 25, 2026 at 03:10:13AM +0300, Jarkko Sakkinen wrote:
> The keyring subsystem depends on assoc_array for searching keys by their
> description, type and domain. It is the sole user of this data structure,
> which has during the age of LLMs transformed into a maintenance nightmare.

Maybe reword to be more specific, like: "It is the sole user of this
data structure, which has 1700 lines of code with no test suite and has
had many bugs reported over the years, with LLMs now finding more."

>  struct key_tag {
>  	struct rcu_head		rcu;
> @@ -118,18 +118,7 @@ struct key_tag {
>  struct keyring_index_key {
>  	/* [!] If this structure is altered, the union in struct key must change too! */
>  	unsigned long		hash;			/* Hash value */

As I suggested before, I think the hash field (here and in struct key)
should be changed to u32, since that is all that is used now.  Also, the
SipHash value can just be truncated from 64 bits to 32 instead of
"folded".  Also, the pointers can be used directly in the computation
once again, now that they're no longer needed for the assoc_array key.
(And that means the domain_id and type_id can be removed.)

Are those simplifications planned for follow-up commits, maybe?

> +static int keyring_obj_cmpfn(struct rhashtable_compare_arg *arg,
> +			     const void *obj)
> +{
> +	const struct keyring_link *link = obj;
> +	const struct key *key = rcu_dereference_check(link->key, true);

This probably should use keyring_link_key(), which should be moved up to
earlier in the file.  Or rcu_dereference(), since it looks like this is
always called under the RCU lock.

> +static void keyring_index_free(struct key *keyring)
> +{
> +	struct keyring_index *index = keyring_index_locked(keyring);
> +
> +	if (!index)
> +		return;
> +
> +	rcu_assign_pointer(keyring->index, NULL);
> +	queue_rcu_work(system_dfl_wq, &index->rcu_work);

It's queue_rcu_work() rather than call_rcu() because
rhashtable_destroy() can sleep, right?  Commenting that might help.

> +static struct keyring_index *keyring_get_index(struct key *keyring)
> +{
> +	struct keyring_index *links __free(kfree) =
> +		keyring_index_locked(keyring);
> +	int ret;
> +
> +	if (links)
> +		return_ptr(links);
> +
> +	links = kzalloc_obj(struct keyring_index);
> +	if (!links)
> +		return ERR_PTR(-ENOMEM);
> +	ret = rhashtable_init(&links->ht, &keyring_link_params);
> +	if (ret < 0)
> +		return ERR_PTR(ret);
> +
> +	INIT_LIST_HEAD(&links->list);
> +	INIT_RCU_WORK(&links->rcu_work, keyring_index_free_work);
> +	rcu_assign_pointer(keyring->index, links);
> +	return_ptr(links);
> +}

Assigning the live index to a __free variable is kind of weird (even
though return_ptr handles it).  I think it would be simpler without
scoped cleanup here:

static struct keyring_index *keyring_get_index(struct key *keyring)
{
	struct keyring_index *links = keyring_index_locked(keyring);
	int ret;

	if (links)
		return links;

	links = kzalloc_obj(struct keyring_index);
	if (!links)
		return ERR_PTR(-ENOMEM);
	ret = rhashtable_init(&links->ht, &keyring_link_params);
	if (ret < 0) {
		kfree(links);
		return ERR_PTR(ret);
	}

	INIT_LIST_HEAD(&links->list);
	INIT_RCU_WORK(&links->rcu_work, keyring_index_free_work);
	rcu_assign_pointer(keyring->index, links);
	return links;
}

> +void __key_link(struct key *keyring, struct key *key, struct keyring_link *edit[2])
>  {
> +	struct keyring_index *index = keyring_index_locked(keyring);
> +	int ret = 0;
> +
>  	__key_get(key);
> -	assoc_array_insert_set_object(*_edit, keyring_key_to_ptr(key));
> -	assoc_array_apply_edit(*_edit);
> -	*_edit = NULL;
> +	rcu_assign_pointer(edit[0]->key, key);
> +
> +	if (edit[1]) {
> +		ret = rhashtable_replace_fast(&index->ht, &edit[1]->node,
> +					      &edit[0]->node, keyring_link_params);
> +		if (ret)
> +			goto out;

rhashtable_replace_fast() shouldn't fail here, but if it does, we should
put the reference to the key that was taken earlier in the function:

		if (WARN_ON(ret)) {
			key_put(key);
			return;
		}

(That would replace the 'out' label and its WARN_ON.)

>  void __key_link_end(struct key *keyring,
>  		    const struct keyring_index_key *index_key,
> -		    struct assoc_array_edit *edit)
> +		    struct keyring_link *edit[2])
>  	__releases(&keyring->sem)
>  	__releases(&keyring_serialise_link_lock)
>  {
> +	struct keyring_link *link = edit[0];
> +
>  	BUG_ON(index_key->type == NULL);
>  	kenter("%d,%s,", keyring->serial, index_key->type->name);
>  
> -	if (edit) {
> -		if (!edit->dead_leaf) {
> +	if (link) {
> +		if (!edit[1]) {
>  			key_payload_reserve(keyring,
>  				keyring->datalen - KEYQUOTA_LINK_BYTES);
> +			WARN_ON(rhashtable_remove_fast(&keyring_index_locked(keyring)->ht,
> +						       &link->node,
> +						       keyring_link_params));
> +			call_rcu(&link->rcu, keyring_link_free_rcu);
> +		} else {
> +			kfree(link);
>  		}
> -		assoc_array_cancel_edit(edit);
> +
> +		edit[0] = NULL;
> +		edit[1] = NULL;
>  	}

How about replacing 'struct keyring_link *edit[2]' with a named struct?
It's kind of hard to remember what [0] and [1] are.

- Eric
