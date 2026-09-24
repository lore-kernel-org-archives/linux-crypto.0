Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C60D4D8DA2
	for <linux-crypto@vger.kernel.org>; Thu, 24 Sep 2026 21:14:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790284460; cv=none; b=kHPJFchG9n0uKUKJE9cZf0J0HbsTHxSk3DUSNlgsxDOnOx+xtV+L8a2FZKg+6gYUwsHvHmowac1Y8ZgRdKUj535JTNLBDqC5cxWcTBKB74IBDVp+hcK5I63cxefs+RH8pWNzExockcFyXEeMEN/XRyVvTaBj2hZ6nsGYXT6LuYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790284460; c=relaxed/simple;
	bh=5X3f5LMt+1ktDBnXdlEqojvUHL8tu4LtqubxC2AZFIs=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kjNn1M4dc/mtvXwcur1Uy2qX9QGgms7jxd5Yvf8Vr46URZNWgQtIkScllJJshVu2EqG2ZgYnqY3OaSZEVLEoL+2nhriux0ASKIMZel/Kvq3LZ9fqFHK2QewqZRovS3pkdkCNWBFWHlZUil35hAGoS5pUaYVJcBeld9GYHVD0AFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OANeLJyg; arc=none smtp.client-ip=74.125.225.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OANeLJyg"
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49e6b885ef8so1637015e9.1
        for <linux-crypto@vger.kernel.org>; Thu, 24 Sep 2026 14:14:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790284453; x=1790889253; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=UP/G1wPiXPB9Uw9yyDuA781szVvayYuXNNrSB0GIav0=;
        b=OANeLJyggCoJL0Y0mnAzH/OJBlHW7iP/afJo20nRsWz/1BW3yqGh5JUcJnx9O9O8Rg
         91KSA7NIdU5yad3mtyIqWrSbf7XAN4TeBZNeDh19sKLCerUBqw+pfVHuwCHl/VIo/FCb
         xIOh/ZVdchChxCMrv/+6O2Z4LqpozdgL0WzjfjX6Ws9hIc4psc6CoxfA1NHtHSAh0auF
         pIo6H7rdjubFqvS11fnr8cZY/3Wo3vFiJXIK1jvjbGhQRCumVP/f2elOVjU14/si/NUl
         phdcM1q2k3YwncVnNhSytJdQJvqnZcADqZHxOu3x2gjIV8LyGxt84mslnGrljJtdwjhP
         c4cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790284453; x=1790889253;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UP/G1wPiXPB9Uw9yyDuA781szVvayYuXNNrSB0GIav0=;
        b=dnIFx4+S2F/bQNNsSFUY4Q0dlDnjARzspNZzPaB0P4yRQDQjPHoSBfN1g5nDaRKHDE
         SBuEL0yIuDZkiAGqZSlm1gj3FWDbXq0G3LhjrUm1L549ZyWdWCgTMliNzq8gwMYPg8rU
         YT69bY0QFsvFiZaNR7gVp1yONqmW1R4XciR4uQjMWppgjoFBDDdGgy90Qklb5/SrGOZd
         YV3lC+UrMmIghUQrXNS7zQkjYzwvJIIiI+ynNGeLJr52wwdAXy/DwB2Tb4B9bgu92deX
         V5Bjt6jMJKBJFASCUITG83JGNKGW+cH1TPJEsrvoXDfsCJhGoIbN1T1LehwIvUqQ8vTW
         Fzxw==
X-Forwarded-Encrypted: i=1; AKwUvBzGSjLWrl9UDrhHMJlUSWd9EV5aaNj5Ps6o0ge7Nz2hvvTPUiYvHyp3CrluQluB/5yBMsfwAK6PXcG9x38=@vger.kernel.org
X-Gm-Message-State: AFuF++k69LhSJC3woi+hEtqQ6fvw0iB4dysAMFt5SI80VQ6iGF5T/FSx
	C9c5lceOhyR8TKJp7n06GmXdnoXW+rZb9sJeFRdZ83FKb2YBDbr8kdKd
X-Gm-Gg: AYBFou3fxnGYT3SR2lxWOKowsP8khP0kh6dr4J2HvsYg27O46P1vhiiLjhjd6shBaWX
	hu9EUUoDprfvb4sH+YrraTUZ6nluBaVJXWPrmdQeuLhcHgrbub1GnnEXViaIUqf/6h3t2poQa8M
	3XtsrKoQo8lRTCHs+ilCk88dH/LMmyHkJnHCTyuvDlf8w508s3N/Sbb7JT5Q/Cym8IZq8qn0r6j
	X2Lm/TyHHnTzl/FDS3G1L/+C6O4nabhngmuEk7bRT7+NwPAuiPZcSnJ7IbzfcWkmUg5DNvdHck8
	TW6We9B2aYY4OYjqRSgrCwH0WTpCIsjaYazwkqQl8GR2kXSjDIzmkfuYK/xfolzzArZ4XPQ+DLt
	lJvbEKHchVzxEzxx5/fnDIPASeDWziTeP2k7knYOPDS53K174LQQNu3oxsGJm1uhEuQs7YIH/hQ
	+kTL2mQZ7qXJQmyXeV3ap3l/gM/IduOvQpwBU+XHqo/JVWfYTpEoyWbMtWV5dWD26SNTDq2msSm
	/k7C3eHLGuuWKBOmBTheTLhMPCCII6OdpI=
X-Received: by 2002:a05:600c:3b1b:b0:49c:de80:b833 with SMTP id 5b1f17b1804b1-49fe66c8a1emr68629125e9.2.1790284453344;
        Thu, 24 Sep 2026 14:14:13 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fef4fc959sm10167455e9.2.2026.09.24.14.14.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2026 14:14:12 -0700 (PDT)
Date: Thu, 24 Sep 2026 22:14:11 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Herbert Xu
 <herbert@gondor.apana.org.au>, justinstitt@google.com,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 llvm@lists.linux.dev, morbo@google.com, nathan@kernel.org,
 ndesaulniers@google.com, Thomas Graf <tgraf@suug.ch>,
 nickolay.lysenko@gmail.com, peterz@infradead.org, rostedt@goodmis.org,
 sched-ext@lists.linux.dev, tj@kernel.org
Subject: Re: [PATCH] rhashtable: specialize default comparison for constant
 parameters
Message-ID: <20260924221411.0fad5501@pumpkin>
In-Reply-To: <20260924184733.2317353-1-usama.arif@linux.dev>
References: <20260924184733.2317353-1-usama.arif@linux.dev>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 24 Sep 2026 11:47:33 -0700
Usama Arif <usama.arif@linux.dev> wrote:

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
> 
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

That looks strange to me.
If ht->p.key_len/offset can be different from params.key_len/offset I can't
see why that shouldn't happen when params is constant.
If ht->p is likely to be a pointer to the associated params, you are passed
the params, they match and params is constant then you can optimise.
But that needs the address compare in the calling code (outside any look).

David 

>  }
>  
>  /* Internal function, do not use. */
> @@ -632,7 +642,7 @@ static __always_inline struct rhash_head *__rhashtable_lookup(
>  		rht_for_each_rcu_from(he, __rht_ptr_rcu(bkt, freq), tbl, hash) {
>  			if (params.obj_cmpfn ?
>  			    params.obj_cmpfn(&arg, rht_obj(ht, he)) :
> -			    rhashtable_compare(&arg, rht_obj(ht, he)))
> +			    rhashtable_compare(&arg, rht_obj(ht, he), params))
>  				continue;
>  			return he;
>  		}
> @@ -797,7 +807,7 @@ static __always_inline void *__rhashtable_insert_fast(
>  		if (!key ||
>  		    (params.obj_cmpfn ?
>  		     params.obj_cmpfn(&arg, rht_obj(ht, head)) :
> -		     rhashtable_compare(&arg, rht_obj(ht, head)))) {
> +		     rhashtable_compare(&arg, rht_obj(ht, head), params))) {
>  			pprev = &head->next;
>  			continue;
>  		}
> diff --git a/lib/rhashtable.c b/lib/rhashtable.c
> index 6362896e4f099..9d9f03b59c823 100644
> --- a/lib/rhashtable.c
> +++ b/lib/rhashtable.c
> @@ -548,7 +548,7 @@ static void *rhashtable_lookup_one(struct rhashtable *ht,
>  		if (!key ||
>  		    (ht->p.obj_cmpfn ?
>  		     ht->p.obj_cmpfn(&arg, rht_obj(ht, head)) :
> -		     rhashtable_compare(&arg, rht_obj(ht, head)))) {
> +		     rhashtable_compare(&arg, rht_obj(ht, head), ht->p))) {
>  			pprev = &head->next;
>  			continue;
>  		}
> @@ -710,7 +710,8 @@ static struct rhash_head *__rhashtable_next_in_table(
>  		rht_for_each_rcu(he, tbl, b) {
>  			bool match = params.obj_cmpfn
>  				     ? !params.obj_cmpfn(&arg, rht_obj(ht, he))
> -				     : !rhashtable_compare(&arg, rht_obj(ht, he));
> +				     : !rhashtable_compare(&arg, rht_obj(ht, he),
> +						   params);
>  			if (found) {
>  				if (match)
>  					continue;

