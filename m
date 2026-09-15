Received: from fout-a5-smtp.messagingengine.com (fout-a5-smtp.messagingengine.com [103.168.172.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3789B3B0590;
	Tue, 15 Sep 2026 21:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789506393; cv=none; b=Ly9Srj13PbvHZiG28v9EwadOIhAmLz2KBb6zqUIFPtAoYUAWCcXpuhHVo1TGR+LwHa58w6i6wy3nx4fzUgHqri/+Gz5hRwFBrvjHGUl94paKGIlzUttO8CVsAbGsA3N2u0IV4ow5/Qh5SykIf8kpnFkrciTYi5+wI2e5OqNs0t0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789506393; c=relaxed/simple;
	bh=g3K+lfhUgnaE/mezC2FggeKY+3skAs7DftoJWFLXh1w=;
	h=Content-Type:MIME-Version:From:To:Cc:Subject:In-reply-to:
	 References:Date:Message-id; b=cHy07d2dj9v9jkNFX+waYqFAN/Ogzh0Sa6wqrUUOnmyTISB63BP2YaJKmkAmVW8o22EiEQslgdrn9fXoKrsS0wXfuLG/ZZzcGQM14kkq5ctIad7vd8JO+o/Iql7fZtOTNCbIaNdc6dbsApN2VLbGjKF0c/Ld26DfTIfL613hkao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net; spf=pass smtp.mailfrom=ownmail.net; dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b=CgGIkxKc; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=abZOEX13; arc=none smtp.client-ip=103.168.172.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ownmail.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b="CgGIkxKc";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="abZOEX13"
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.phl.internal (Postfix) with ESMTP id 17D99EC0E47;
	Tue, 15 Sep 2026 17:06:27 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Tue, 15 Sep 2026 17:06:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:reply-to:subject:subject:to:to; s=fm1; t=
	1789506387; x=1789592787; bh=pSGhn5yb2ykQHa2+aS4x0aFSjk4p7/mwMgu
	lDmeHEfI=; b=CgGIkxKcPckL2520PVEYtzWYJetiw5vFeYlNNv2vp5Mfb22pxYH
	Z3AeutYDYz64s+5TK1RqBcmA7RbBREX8wPxvh0584SPPYew3QgpjBlPo2/dhmZgT
	mTBOasxxH9hAwXvde0rydO48NfddKivQLtx56ZwL7Iz1gXzFRod4tNozprjoXIGo
	9mpXIvxQ3cO/HdQb/TETSh+JQKks6rL1i/18pQOl6vJn2eWcICSZ56wTx5PQKJBF
	HC+XLRRzPVok8DzJEs2ARwLoBKwD16bUKgD8449V/5qSKZHxdhMwpg2s0KWpXyJ4
	7Ce0hxV9e+jfjB7/VGOZBkK6nB0WQB9xJwQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1789506387; x=
	1789592787; bh=pSGhn5yb2ykQHa2+aS4x0aFSjk4p7/mwMgulDmeHEfI=; b=a
	bZOEX13veVaxfTH9bLCCccEDlmcfsW+SWN7V0AGCUl/u0pgbbhYhgWYCS6fmUYHq
	oC7hUo+tUXrM7xhiwtXRGCwujKPeYxNOt27vlaDZ+9URcD/CQ/A2RuM7B+Y9DmRK
	YLaq853LOAnvCGxb3570NqstfkkmXTHeov9gt2Xbvf4SxpSNz3s5uMlNzVL2YP0O
	zWlwcLEltPsbZcpPLa2iMTXaPou7GaPNmZdwFmgfL8Wa+CVf8/l4th6cas1euomi
	sLSCZfnlGTEl6f3K4pUqzTW9vUDLEbOU2P4AbGhMoquTQ/3AuO8vrODQ5bOfKuXg
	3GmqEOFube8t0WXZA5Bxw==
X-ME-Sender: <xms:UbOparFGbSXihTaj0SLZ6yYMKW7RA2xkA36-P3YSOKl-itdh0OZAMg>
    <xme:UbOpavR8GdsKOZsh3fxLA59J8vYUUrFCKR6qbyM8laze54yY7_wUQSg3NscupXVBk
    7yd9yaFSm1ulNvNjniFNf7lQC5aYVsCztGgeLN_itTbOhWwkQ>
X-ME-Received: <xmr:UbOpaiO-_KpZOlsKebvR0-rsMkr2DNIRjVhVaoZ293TZj5QbzEcYhTKY_s2fyWbpmg>
X-ME-Proxy-Cause: dmFkZTGla0jEqEOCi/nzNPCoo0ScIh2JaZoq/4ebKgNohM8wDfdyIavrkNjshsND0P8tAs
    YhtJcgxY8ykXaMgTLV/PAPKJBCPJIZajcIR5EweJMqjOb2vZSnR4CeIgVRzxWmJX/xFJn7
    1a4tUOzgCBFodCqSJZaKfGFB6cgCAYzxBzIwS63QgFT6wWVOBcy9MDzMapV05p1KdzDuei
    j95DMmwaNUq7OLYkcjLYuUzH5HXYPbN7fSaJSeC8pvuikyYJkizg+ZIgbsAxuNyEKs8hFp
    WBrrz0c1CjdAGYnAIwfX5V7HPHVKo17fBEA3/JW5/KyDlNhLH7gvRkzZhrP1FhlvukvsqI
    ZJr5IQgxcnkpH6PeJTjjIg0oXlGXXkgjB13qbSnrrgppM61DAq1jmz15SmDbdLzhSILo6G
    32KR8G+HesNpe+GCrZb8WvmDpiXfpJ2kv4NUy+SdqWyAhWsYNrVN7m9KyrJWkiTLSp4xCe
    cKTabAmHjfZmAKKJRR44NmeaSKN4MlpmYoGYRFbJR44ZIC+5rVQDqWFOoEvA4/Wzqa4oNn
    sYDwXvRPqdHIhqFKIZNR3bIrvTS/IBtFf75SfzaHkirF4Thyhe7ujZ7RBdXkwtXUghdgqC
    VZMXofDt33LkpijoWqrkvU0sk2xgnbY295PQnKCGfdY8d4uQ7Q5c/BeGAsRA
X-ME-Proxy: <xmx:UbOpagOfaqcQ-p9_U2E_Bv59vZp6XZHuDujeIgGZbIFCODBdt4HLXQ>
    <xmx:UbOpasFaZV5WbjePIApkS6hC5XK4LZl1rpuQ7wEXrmZzV2qYR5m1ow>
    <xmx:UbOpaqPhbsXQPsPmLDVCFXjBp5nxyOsYRA2_Qmtx1-sSRITQWLnneA>
    <xmx:UbOpauvMfj7bSQ-vW5v9T23uRHHxzrYkPZPPp4oc6yipNh9Lgz-XHA>
    <xmx:U7OpalEEvf1Cb9epx-tleNX3emopc13DaR9ZdGM8ccS9zbAaf7Y8qtDp>
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 15 Sep 2026 17:06:20 -0400 (EDT)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: NeilBrown <neilb@ownmail.net>
To: "Herbert Xu" <herbert@gondor.apana.org.au>
Cc: "Eric Dumazet" <edumazet@google.com>,
 "Shin'ichiro Kawasaki" <shinichiro.kawasaki@wdc.com>,
 "syzbot" <syzbot+4d0e4d2db6dfde01b52f@syzkaller.appspotmail.com>,
 bridge@lists.linux.dev, davem@davemloft.net, horms@kernel.org,
 idosch@nvidia.com, kuba@kernel.org, linux-kernel@vger.kernel.org,
 netdev@vger.kernel.org, pabeni@redhat.com, razor@blackwall.org,
 steffen.klassert@secunet.com, syzkaller-bugs@googlegroups.com,
 "Thomas Graf" <tgraf@suug.ch>, linux-crypto@vger.kernel.org,
 "quanyeyang" <quanyemostima@gmail.com>
Subject: Re: [PATCH] rhashtable: Use separate lockdep keys for each lock
In-reply-to: <aqjf7LNmE6InABpw@gondor.apana.org.au>
References: <6aa5fcf6.f2639fcc.29487d.0048.GAE@google.com>
  <aqi7fpazv2KDDdvn@shinmob>
  <CANn89iJd0QnoDo0tjrFED2myec38U8joyqR05d6BVnJ-sX=NVg@mail.gmail.com>
  <aqjf7LNmE6InABpw@gondor.apana.org.au>
Date: Wed, 16 Sep 2026 07:06:16 +1000
Message-id: <178950637640.207413.1725604371084195628@noble.neil.brown.name>
Reply-To: NeilBrown <neil@brown.name>

On Tue, 15 Sep 2026, Herbert Xu wrote:
> On Mon, Sep 14, 2026 at 09:06:49PM -0700, Eric Dumazet wrote:
> >
> > Try to revert 4333ab90aaae ("rhashtable: use private lockdep class for
> > all locks.")
>=20
> Yes this is indeed buggy.  I know nothing about lockdep but Gemini
> reckons that it should use separate keys instead of different
> depths which seems fair enough:
>=20
> ---8<---
> Use separate lockdep keys for the different types of locks in
> rhashtable (mutex, spin lock, and bucket locks).  They are
> separate and not normally nested with respect to each other.
>=20
> Also move the rhashtable_init/rhltable_init kdoc to the header
> file as that's where the macros are defined.
>=20
> Fixes: 4333ab90aaae ("rhashtable: use private lockdep class for all locks.")
> Reported-by: syzbot+4d0e4d2db6dfde01b52f@syzkaller.appspotmail.com
> Assisted-by: Gemini:gemini-3.6-flash
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

That's a much better approach - thanks for that.

Reviewed-by: NeilBrown <neil@brown.name>

Thanks,
NeilBrown


>=20
> diff --git a/include/linux/rhashtable-types.h b/include/linux/rhashtable-ty=
pes.h
> index 0e1b172a4f6c..afbc12ba71f5 100644
> --- a/include/linux/rhashtable-types.h
> +++ b/include/linux/rhashtable-types.h
> @@ -70,6 +70,14 @@ struct rhashtable_params {
>  	rht_obj_cmpfn_t		obj_cmpfn;
>  };
> =20
> +struct rhashtable_lockdep_keys {
> +#ifdef CONFIG_LOCKDEP
> +	struct lock_class_key lock_key;
> +	struct lock_class_key mutex_key;
> +	struct lock_class_key bucket_key;
> +#endif
> +};
> +
>  /**
>   * struct rhashtable - Hash table handle
>   * @tbl: Bucket table
> @@ -141,24 +149,77 @@ struct rhashtable_iter {
> =20
>  int __rhashtable_init_noprof(struct rhashtable *ht,
>  		    const struct rhashtable_params *params,
> -		    struct lock_class_key *key);
> +		    struct rhashtable_lockdep_keys *keys);
>  #define rhashtable_init_noprof(ht, params)				\
>  ({									\
> -	static struct lock_class_key __key;				\
> +	static struct rhashtable_lockdep_keys __keys;			\
>  									\
> -	__rhashtable_init_noprof(ht, params, &__key);			\
> +	__rhashtable_init_noprof(ht, params, &__keys);			\
>  })
> +
> +/**
> + * rhashtable_init - initialize a new hash table
> + * @ht:		hash table to be initialized
> + * @params:	configuration parameters
> + *
> + * Initializes a new hash table based on the provided configuration
> + * parameters. A table can be configured either with a variable or
> + * fixed length key:
> + *
> + * Configuration Example 1: Fixed length keys
> + * struct test_obj {
> + *	int			key;
> + *	void *			my_member;
> + *	struct rhash_head	node;
> + * };
> + *
> + * struct rhashtable_params params =3D {
> + *	.head_offset =3D offsetof(struct test_obj, node),
> + *	.key_offset =3D offsetof(struct test_obj, key),
> + *	.key_len =3D sizeof(int),
> + *	.hashfn =3D jhash,
> + * };
> + *
> + * Configuration Example 2: Variable length keys
> + * struct test_obj {
> + *	[...]
> + *	struct rhash_head	node;
> + * };
> + *
> + * u32 my_hash_fn(const void *data, u32 len, u32 seed)
> + * {
> + *	struct test_obj *obj =3D data;
> + *
> + *	return [... hash ...];
> + * }
> + *
> + * struct rhashtable_params params =3D {
> + *	.head_offset =3D offsetof(struct test_obj, node),
> + *	.hashfn =3D jhash,
> + *	.obj_hashfn =3D my_hash_fn,
> + * };
> + */
>  #define rhashtable_init(...)	alloc_hooks(rhashtable_init_noprof(__VA_ARGS_=
_))
> =20
>  int __rhltable_init_noprof(struct rhltable *hlt,
>  		  const struct rhashtable_params *params,
> -		  struct lock_class_key *key);
> +		  struct rhashtable_lockdep_keys *keys);
>  #define rhltable_init_noprof(hlt, params)				\
>  ({									\
> -	static struct lock_class_key __key;				\
> +	static struct rhashtable_lockdep_keys __keys;			\
>  									\
> -	__rhltable_init_noprof(hlt, params, &__key);			\
> +	__rhltable_init_noprof(hlt, params, &__keys);			\
>  })
> +
> +/**
> + * rhltable_init - initialize a new hash list table
> + * @hlt:	hash list table to be initialized
> + * @params:	configuration parameters
> + *
> + * Initializes a new hash list table.
> + *
> + * See documentation for rhashtable_init.
> + */
>  #define rhltable_init(...)	alloc_hooks(rhltable_init_noprof(__VA_ARGS__))
> =20
>  #endif /* _LINUX_RHASHTABLE_TYPES_H */
> diff --git a/include/linux/rhashtable.h b/include/linux/rhashtable.h
> index 6c5e6d9accba..ec853c1b9af3 100644
> --- a/include/linux/rhashtable.h
> +++ b/include/linux/rhashtable.h
> @@ -328,8 +328,7 @@ static inline unsigned long rht_lock_nested(struct buck=
et_table *tbl,
> =20
>  	local_irq_save(flags);
>  	bit_spin_lock(0, (unsigned long *)bucket);
> -	/* subclass 0 is used for ->lock and 1 for ->mutex. 2+ for bitlocks */
> -	lock_acquire_exclusive(&tbl->dep_map, subclass+2, 0, NULL, _THIS_IP_);
> +	lock_acquire_exclusive(&tbl->dep_map, subclass, 0, NULL, _THIS_IP_);
>  	return flags;
>  }
> =20
> diff --git a/lib/rhashtable.c b/lib/rhashtable.c
> index 5da0e53a8d42..918f15a2ac69 100644
> --- a/lib/rhashtable.c
> +++ b/lib/rhashtable.c
> @@ -432,7 +432,7 @@ static void rht_deferred_worker(struct work_struct *wor=
k)
>  	int err =3D 0;
> =20
>  	ht =3D container_of(work, struct rhashtable, run_work);
> -	mutex_lock_nested(&ht->mutex, 1);
> +	mutex_lock(&ht->mutex);
> =20
>  	tbl =3D rht_dereference(ht->tbl, ht);
>  	tbl =3D rhashtable_last_table(ht, tbl);
> @@ -1122,51 +1122,9 @@ static u32 rhashtable_jhash2(const void *key, u32 le=
ngth, u32 seed)
>  	return jhash2(key, length, seed);
>  }
> =20
> -/**
> - * rhashtable_init - initialize a new hash table
> - * @ht:		hash table to be initialized
> - * @params:	configuration parameters
> - *
> - * Initializes a new hash table based on the provided configuration
> - * parameters. A table can be configured either with a variable or
> - * fixed length key:
> - *
> - * Configuration Example 1: Fixed length keys
> - * struct test_obj {
> - *	int			key;
> - *	void *			my_member;
> - *	struct rhash_head	node;
> - * };
> - *
> - * struct rhashtable_params params =3D {
> - *	.head_offset =3D offsetof(struct test_obj, node),
> - *	.key_offset =3D offsetof(struct test_obj, key),
> - *	.key_len =3D sizeof(int),
> - *	.hashfn =3D jhash,
> - * };
> - *
> - * Configuration Example 2: Variable length keys
> - * struct test_obj {
> - *	[...]
> - *	struct rhash_head	node;
> - * };
> - *
> - * u32 my_hash_fn(const void *data, u32 len, u32 seed)
> - * {
> - *	struct test_obj *obj =3D data;
> - *
> - *	return [... hash ...];
> - * }
> - *
> - * struct rhashtable_params params =3D {
> - *	.head_offset =3D offsetof(struct test_obj, node),
> - *	.hashfn =3D jhash,
> - *	.obj_hashfn =3D my_hash_fn,
> - * };
> - */
>  int __rhashtable_init_noprof(struct rhashtable *ht,
> -		    const struct rhashtable_params *params,
> -		    struct lock_class_key *key)
> +			     const struct rhashtable_params *params,
> +			     struct rhashtable_lockdep_keys *keys)
>  {
>  	struct bucket_table *tbl;
>  	size_t size;
> @@ -1176,13 +1134,11 @@ int __rhashtable_init_noprof(struct rhashtable *ht,
>  		return -EINVAL;
> =20
>  	memset(ht, 0, sizeof(*ht));
> -	/* mutex_lock must use nesting level 1 */
> -	mutex_init_with_key(&ht->mutex, key);
> +	mutex_init_with_key(&ht->mutex, &keys->mutex_key);
>  	spin_lock_init(&ht->lock);
> -	/* spin_lock can use nesting level 0 */
> -	lockdep_set_class(&ht->lock, key);
> +	lockdep_set_class(&ht->lock, &keys->lock_key);
>  #ifdef CONFIG_LOCKDEP
> -	ht->lockdep_key =3D key;
> +	ht->lockdep_key =3D &keys->bucket_key;
>  #endif
>  	memcpy(&ht->p, params, sizeof(*params));
> =20
> @@ -1236,22 +1192,13 @@ int __rhashtable_init_noprof(struct rhashtable *ht,
>  }
>  EXPORT_SYMBOL_GPL(__rhashtable_init_noprof);
> =20
> -/**
> - * rhltable_init - initialize a new hash list table
> - * @hlt:	hash list table to be initialized
> - * @params:	configuration parameters
> - *
> - * Initializes a new hash list table.
> - *
> - * See documentation for rhashtable_init.
> - */
>  int __rhltable_init_noprof(struct rhltable *hlt,
>  			   const struct rhashtable_params *params,
> -			   struct lock_class_key *key)
> +			   struct rhashtable_lockdep_keys *keys)
>  {
>  	int err;
> =20
> -	err =3D __rhashtable_init_noprof(&hlt->ht, params, key);
> +	err =3D __rhashtable_init_noprof(&hlt->ht, params, keys);
>  	hlt->ht.rhlist =3D true;
>  	return err;
>  }
> diff --git a/lib/test_rhashtable.c b/lib/test_rhashtable.c
> index 85a615e74591..b767a38a74f9 100644
> --- a/lib/test_rhashtable.c
> +++ b/lib/test_rhashtable.c
> @@ -477,7 +477,7 @@ static unsigned int __init print_ht(struct rhltable *rh=
lt)
> =20
>  	ht =3D &rhlt->ht;
>  	/* Take the mutex to avoid RCU warning */
> -	mutex_lock_nested(&ht->mutex, 1);
> +	mutex_lock(&ht->mutex);
>  	tbl =3D rht_dereference(ht->tbl, ht);
>  	for (i =3D 0; i < tbl->size; i++) {
>  		struct rhash_head *pos, *next;
> --=20
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
>=20

