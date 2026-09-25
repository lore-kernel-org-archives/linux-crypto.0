Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F2611A267;
	Fri, 25 Sep 2026 00:04:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790294686; cv=none; b=BJ745ajz1MNmrHKmui6Y1oWi1CKpB6FGiTHtozviErynmiJLl9dtmPt7IKGIReKmfSXsHrBxKM5ahFtU1+1CD+p+y+XyA0zMHMZp2+3dZ5wWru5GyCIj6/u2bW7PT7fCyX7tTYFLcTZUj6N4J2czakztpkAvUmVomiFL45CM504=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790294686; c=relaxed/simple;
	bh=HvsBmvYUBmw+Sy2UkGl81oqHKz8g4fZqaJXTq9WZ5Oo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R1PtpkS59ndx+eIEbUndCvNqJMgk82IlDuvxggg/dd/CBZpseURXDakab/QZ1mwhVxe+lQnj8fiWErAX4GlhAnKekMv1RCkjgyRu0nO664tj/nTI7sUpmhGaU9L/ArT16pjnZ+qSqoahkhVyg7OGbZbFHumWIJNOEqtdIkB6jzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=PG4XNaZL; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="PG4XNaZL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=GvrPeFIm2JKZW2zlPW0AMx8ld3eL9qOjcIbpnfOK7W4=; 
	b=PG4XNaZLPb+yZu/5jr6EvKnkqL5Tx9cTnbufAjN+Bnh0U58qf3qsFw+lq9IqnfzaPh5ahJpW/rX
	LvJcLDEHrpCZH0k06qFdyO1qaQaTXeVXa2UQIBZwqz0nIPzNSfzJmMu/gwPws8iVoncVtE0JAFiXh
	1SUgxpAlNX3L4tPIL8DK6qu2mx1xbEcFtJezq8MDEsMruaQmIOBvjs/3XOQ0501khN6WI0QBMVTHT
	/7wZStfm8bfNAkORMm3TNXpTAgIyGJgWeQp+ZhGwnX7TjGCsShHS/45B00rfMPeFO+9VA+SLQH2FK
	TcSy/DQBMGTCD0DBIJ9SScOM0GYSGhB6bhEg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x9tQP-000000003eW-42jT;
	Fri, 25 Sep 2026 08:04:27 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 25 Sep 2026 10:04:25 +1000
Date: Fri, 25 Sep 2026 10:04:25 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, justinstitt@google.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev, morbo@google.com, nathan@kernel.org,
	ndesaulniers@google.com, Thomas Graf <tgraf@suug.ch>,
	nickolay.lysenko@gmail.com, peterz@infradead.org,
	rostedt@goodmis.org, sched-ext@lists.linux.dev, tj@kernel.org
Subject: Re: [PATCH] rhashtable: specialize default comparison for constant
 parameters
Message-ID: <arW6ibT1RkVCqTdT@gondor.apana.org.au>
References: <20260924184733.2317353-1-usama.arif@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924184733.2317353-1-usama.arif@linux.dev>

On Thu, Sep 24, 2026 at 11:47:33AM -0700, Usama Arif wrote:
> The inline lookup and insert helpers receive the rhashtable parameters by
> value. With a static const parameter block, key_offset and key_len are
> compile-time constants at the call site.
> 
> The default comparison throws that information away by reading both fields
> back from ht->p. Fixed-size keys consequently load the parameters and call
> bcmp() for every object in the bucket, even when the compiler could use
> scalar comparisons instead.
> 
> The commit "sched_ext: Specialize the DSQ hashtable compare" [1] resulted
> in a 2.9x faster DSQ lookup after replacing this path for its u64 key
> with a scalar comparison. Doing that through obj_cmpfn requires every
> fixed-key user to provide its own callback.
> 
> Pass the call-site parameters to rhashtable_compare(), as
> rht_key_get_hash() already does. Use them when key_len is a compile-time
> constant. Retain the ht->p path for dynamic parameter blocks. A constant
> zero key_len continues to take the runtime length from ht->p.key_len.
> 
> This specializes the default comparison for all fixed-size users. With
> Clang 22 on x86-64, bcmp() disappears from sched_ext, mac80211, NFSd,
> TIPC, NFQUEUE, VFS superblock, pidfs, SysV IPC and hardware-breakpoint
> table paths. The affected build_policy.o, sta_info.o and nfsd filecache.o
> text shrinks by 512, 400 and 352 bytes respectively. Four- and eight-byte
> keys become direct scalar comparisons; six-byte MAC addresses become a
> four-byte and a two-byte comparison.
> 
> Measure the VFS case with ustat() on a mounted ramfs. This exercises
> user_get_super() and its super_dev lookup. Across ten interleaved baseline
> and patched VM boot pairs, with five 3 million call samples per boot, the
> average per-boot median latency drops from 477.2 to 462.6 ns per call, or
> 3.0%. All ten pairs improved.
> 
> No functional change intended.
> 
> [1] https://lore.kernel.org/all/20260921171928.1639407-1-usama.arif@linux.dev/
> 
> Suggested-by: Mykola Lysenko <nickolay.lysenko@gmail.com>
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> ---
>  include/linux/rhashtable.h | 20 +++++++++++++++-----
>  lib/rhashtable.c           |  5 +++--
>  2 files changed, 18 insertions(+), 7 deletions(-)

Nice work, I'm glad that someone is looking at the assembly :)

> diff --git a/include/linux/rhashtable.h b/include/linux/rhashtable.h
> index 57a2a29bef0e8..c9872965b753c 100644
> --- a/include/linux/rhashtable.h
> +++ b/include/linux/rhashtable.h
> @@ -598,13 +598,23 @@ static inline void rht_assign_unlock(struct bucket_table *tbl,
>  	for (pos = list; pos && rht_entry(tpos, pos, member);		\
>  	     pos = rcu_dereference_all(pos->next))
>  
> -static inline int rhashtable_compare(struct rhashtable_compare_arg *arg,
> -				     const void *obj)
> +/*
> + * Use constant params from inlined callers to specialize memcmp(). If params
> + * isn't constant, it must be equal to ht->p.
> + */
> +static __always_inline int rhashtable_compare(struct rhashtable_compare_arg *arg,
> +					      const void *obj,
> +					      const struct rhashtable_params params)
>  {
>  	struct rhashtable *ht = arg->ht;
>  	const char *ptr = obj;
>  
> -	return memcmp(ptr + ht->p.key_offset, arg->key, ht->p.key_len);
> +	if (!__builtin_constant_p(params.key_len))
> +		return memcmp(ptr + ht->p.key_offset, arg->key,
> +			      ht->p.key_len);
> +
> +	return memcmp(ptr + params.key_offset, arg->key,
> +		      params.key_len ? : ht->p.key_len);

If there is no obj_cmpfn then there is no obj_hashfn.  If there
is no obj_hashfn then params.key_len must be non-zero.  So this
could become unconditional, perhaps with a comment.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
