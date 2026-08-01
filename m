Received: from fout-b3-smtp.messagingengine.com (fout-b3-smtp.messagingengine.com [202.12.124.146])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BAB331E830;
	Sat,  1 Aug 2026 11:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.146
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785582762; cv=none; b=mvqNiNBFaGLhtnEQ/cFeDsHeZNuw1VEChVW+DG8pxE76HLKeueAyLlmMwr3m3RmlI7zAIriL5aN8bkd7fHrTQTM1X3x5jpa6T2EXB1xtbF8Wky7LroytRzxxbbu9yRSUgayUU1RhU35pGfj7PioO6+5FiDVDMX9CI0y2ra6qa+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785582762; c=relaxed/simple;
	bh=HxlOSEMEbayaCX00YkbzTAPVC4sssXcy99jrqbbvCS0=;
	h=Content-Type:MIME-Version:From:To:Cc:Subject:In-reply-to:
	 References:Date:Message-id; b=JSPNslRU/myKPK+uMT7VsHPBRbI9lHj/CnONfTowSwkdS85tCEW81pOx53zS+QTA4bhhcWx5quVt3l9BQJotTFkGWCwtwi0QhYeIyaRfCDvhZ6iqYogsvzxQUMc2mEYDgGo8Mvj8jStMdZXxDBMXIGAsevbYHi+Wbowg9Du+JK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net; spf=pass smtp.mailfrom=ownmail.net; dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b=gK6n7qan; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=L3tsBOvi; arc=none smtp.client-ip=202.12.124.146
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ownmail.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b="gK6n7qan";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="L3tsBOvi"
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.stl.internal (Postfix) with ESMTP id C93181D000AB;
	Sat,  1 Aug 2026 07:12:38 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Sat, 01 Aug 2026 07:12:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:reply-to:subject:subject:to:to; s=fm2; t=
	1785582758; x=1785669158; bh=EhIaAmrMi2Y854D/hycBGKZCjGf2JESWmbk
	QP2FZIZQ=; b=gK6n7qanHf0+d9Qq3sD1+SBilbADrV6Uolj/F+NBKBNU4fWTWal
	p0AcTzHGgAOXCgFj6VIsitN7Vw3v3Whw1BLLpIbJpgt6ZK+GmBz9njBe8RqRyCv4
	w8ak2bLSGG9tBYXEV9/xTH7tmeTXzujSLSe1vVUrg+7lgYNaY8hs0yR5Bz9o9Fug
	iPKeJLVd+KuFnaQLfl7uywd0FQo+NA+PteiAakpzUkBFCvfsHrMwzT+yIQmTck4/
	0MupvQph8altQHTMkT4NAjeZdVbu0qkhIKzQ2VCQfpBYk1oa2SU7BAkhRNeL9otp
	ITMYD6bT3j1f8ii+TP91mkbeO2GNoi1dbpQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1785582758; x=
	1785669158; bh=EhIaAmrMi2Y854D/hycBGKZCjGf2JESWmbkQP2FZIZQ=; b=L
	3tsBOviLb9qImuIEOeQhciCjr5HZm1jNbMllZIFr3KAnN3xer4n5qGAQTEm8RrQJ
	KGuFcMWy+dDY5uWi1aWzR5nREToQKuSoRHWMuKfa2F/EGfkDNkLfS/s3FAjLNYVk
	0yWeOEe3iB5MVxYFrqtEEsp49YgeONDT8BQrUhmsNzDyp/DbWv6jtjrV9/4Zw1iA
	D8lskPXWYPdFOFmnr1XS9osNkiHv4LBsRGy/sWpbzZt9MxnvLI7bBt2vEchVN35h
	ECd9sYm5Xkj3uXGhutSsQ09zsOIhphQD2CTRcQ99mK934TKw6H3O1JqSUY8J78i4
	x0MuVGGGiXmn88jZmZplQ==
X-ME-Sender: <xms:pdRtar0W1qqeyoQoCB8o3GHN3uTbqdCEstCzIL8d759tNtZyiqXugQ>
    <xme:pdRtavAxXv81CIbL1zNGWz-uSP6oq0ghHlTp_qZg7bGI2PGtM5ck9ae5w39H3MgEN
    fHDG0A6d9q5yhsAaTqGPlg9Ji12tV7PCGnWcLpYQ1CgtKUd4P4>
X-ME-Received: <xmr:pdRtagITuQaNBsgZRqMElxLSghnXd49Cxh7utbATQkZl2AW57OMZ4AmSk_k6qpcPgHLNTEum7rSZU4aGBwIxvcTMJz9WWc0>
X-ME-Proxy-Cause: dmFkZTFeI9ULmdvgwngOOXaK/d6nPNN2wznXKw7trtnGLpL2nzCTrne4rRev40ScbnRQKC
    VPf7HezdWr16bYnNgjXpyq1yEC5k6UdifBV5BAgWPq8uqcBZJlAaL8OnGyn5burOExQ7yY
    eqrxzGKQLSvvqHYWaQaKwaefv8bQImWg3xY20pEpIpha+WK5aR8OF0yJ0QJb+fdblVb9JI
    6MhmHOpGeZ4tIhOrM71dVKEhPmI6JMF8xuaEZhD00bZ29istt9HAGihQWYPQCpkIpgefQu
    isHzPa0nYvFVT9Fn/eFtDZEko8pzQQx854zCHBRRFWQPF3iABKhKTWBbO5a6+7HjFqFKlu
    5II9+vSoTyCGvrxz14nI9YvatK3fZvTbF3QNjMYvb3ubsfjrs/q8a8L7I+1OZtKQgwKK+a
    IYckvWo1QY4ohlJSSll59WCb+b9x4bwjeZJqfMd3rxEVAFDvEi8nEH+TT+JNP7Fg/0IZTP
    fYUrBUobcNwd+yAYPR7cSpYgOiIFS0xyofh8oCFMqk602T8F6AkY+XKjZfvDHvhItMkGtd
    YdmKba+35lDq9reAh549AvMO6OegXObaSAxM4m2P7/j6ir7nqjaQBC4Sikjwskpsy/Et2M
    phUbZNnoITdAN/f5hfB6uPw8AN89K28/ielTAeqC9+mUWKIHPgyZfshiApYw
X-ME-Proxy: <xmx:pdRtagmaWneu0F4dRSSrBjhClihfX7sGB6Y4k-YgrK8PssuCt-z6QQ>
    <xmx:pdRtahaoSs99bDG_ANIej4-LLg9bEokul4XtTC2W1fXaABKBoC_tRw>
    <xmx:pdRtak884dUHWro0OSxDYlNGucVbxGGivv0dxj4MhnrY56JBQYZvjg>
    <xmx:pdRtaobgj_s6L7z90eHNV2JYGkRHdIM3eQWQusrEOkm7nQGqDgEZ0Q>
    <xmx:ptRtagamKvLDjFb-XTXEIfiVjcMaQSkha_bltoWGyc34rUzhFnlqRMG5>
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 1 Aug 2026 07:12:34 -0400 (EDT)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: NeilBrown <neilb@ownmail.net>
To: quanyemostima@gmail.com
Cc: "Thomas Graf" <tgraf@suug.ch>, "Herbert Xu" <herbert@gondor.apana.org.au>,
 "Andrew Morton" <akpm@linux-foundation.org>,
 "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 syzbot+ef8d17bae14efb960935@syzkaller.appspotmail.com,
 "quanyeyang" <quanyemostima@gmail.com>
Subject:
 Re: [PATCH] rhashtable: use per-init-site lockdep classes for bucket locks
In-reply-to:
 <20260801-fix-rhashtable-bucket-lockdep-v1-1-15a0f8ae094c@gmail.com>
References:
 <20260801-fix-rhashtable-bucket-lockdep-v1-1-15a0f8ae094c@gmail.com>
Date: Sat, 01 Aug 2026 21:12:31 +1000
Message-id: <178558275123.3252194.11769833511956588358@noble.neil.brown.name>
Reply-To: NeilBrown <neil@brown.name>

On Sat, 01 Aug 2026, quanyemostima@gmail.com wrote:
> From: quanyeyang <quanyemostima@gmail.com>
>=20
> All bucket tables currently share a single lockdep class. This makes
> lockdep conflate bucket locks from unrelated rhashtable instances.
>=20
> A BPF program attached to lock_release can expose this when pidfs
> inserts a pid. The tracepoint runs before lockdep removes the pidfs
> bucket lock from the task's held-lock stack. Deleting an element from
> a BPF RHASH map then acquires a bucket lock belonging to a different
> rhashtable. Since both tables use the same class, lockdep reports
> possible recursive locking.

This seems like a band-aid rather than a proper fix.

Surely attaching a BPF program to lock_release() has potential for
causing all sorts of lockdep related problems.  Any lock that the BPF
program takes can trigger something, and I find it unlikely that
rhashtable is the only part of BPF code that takes a lock.

Maybe the tracepoint needs to disable lockdep while the BPF handler is
running, or something like that.

But I would need a much stronger argument before I could be happy with
this patch.

NeilBrown


>=20
> Declare a separate bucket lock class key at each rhashtable_init() and
> rhltable_init() call site, alongside the mutex class key. Store the
> bucket key in struct rhashtable so tables created during resize keep
> using the same class.
>=20
> A targeted reproducer triggers the warning reliably before this change.
> After the change, the nested BPF RHASH deletion still executes, but
> lockdep no longer reports recursive locking.
>=20
> Fixes: 149212f07856 ("rhashtable: add lockdep tracking to bucket bit-spin-l=
ocks.")
> Reported-by: syzbot+ef8d17bae14efb960935@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3Def8d17bae14efb960935
> Assisted-by: Cursor:GPT-5.6 Sol
> Signed-off-by: quanyeyang <quanyemostima@gmail.com>
> ---
>  include/linux/rhashtable-types.h | 20 ++++++++++++++------
>  lib/rhashtable.c                 | 19 +++++++++++++------
>  2 files changed, 27 insertions(+), 12 deletions(-)
>=20
> diff --git a/include/linux/rhashtable-types.h b/include/linux/rhashtable-ty=
pes.h
> index 57c11ec9dc64..4dea91a49ec8 100644
> --- a/include/linux/rhashtable-types.h
> +++ b/include/linux/rhashtable-types.h
> @@ -82,6 +82,7 @@ struct rhashtable_params {
>   * @mutex: Mutex to protect current/future table swapping
>   * @lock: Spin lock to protect walker list
>   * @nelems: Number of elements in table
> + * @bucket_lock_key: Per-init-site lockdep class for bucket bit-locks
>   */
>  struct rhashtable {
>  	struct bucket_table __rcu	*tbl;
> @@ -94,6 +95,7 @@ struct rhashtable {
>  	struct mutex                    mutex;
>  	spinlock_t			lock;
>  	atomic_t			nelems;
> +	struct lock_class_key		*bucket_lock_key;
>  #ifdef CONFIG_MEM_ALLOC_PROFILING
>  	struct alloc_tag		*alloc_tag;
>  #endif
> @@ -138,23 +140,29 @@ struct rhashtable_iter {
> =20
>  int __rhashtable_init_noprof(struct rhashtable *ht,
>  		    const struct rhashtable_params *params,
> -		    struct lock_class_key *key);
> +		    struct lock_class_key *mutex_key,
> +		    struct lock_class_key *bucket_key);
>  #define rhashtable_init_noprof(ht, params)				\
>  ({									\
> -	static struct lock_class_key __key;				\
> +	static struct lock_class_key __mutex_key;			\
> +	static struct lock_class_key __bucket_key;			\
>  									\
> -	__rhashtable_init_noprof(ht, params, &__key);			\
> +	__rhashtable_init_noprof(ht, params, &__mutex_key,		\
> +				 &__bucket_key);			\
>  })
>  #define rhashtable_init(...)	alloc_hooks(rhashtable_init_noprof(__VA_ARGS_=
_))
> =20
>  int __rhltable_init_noprof(struct rhltable *hlt,
>  		  const struct rhashtable_params *params,
> -		  struct lock_class_key *key);
> +		  struct lock_class_key *mutex_key,
> +		  struct lock_class_key *bucket_key);
>  #define rhltable_init_noprof(hlt, params)				\
>  ({									\
> -	static struct lock_class_key __key;				\
> +	static struct lock_class_key __mutex_key;			\
> +	static struct lock_class_key __bucket_key;			\
>  									\
> -	__rhltable_init_noprof(hlt, params, &__key);			\
> +	__rhltable_init_noprof(hlt, params, &__mutex_key,		\
> +			       &__bucket_key);				\
>  })
>  #define rhltable_init(...)	alloc_hooks(rhltable_init_noprof(__VA_ARGS__))
> =20
> diff --git a/lib/rhashtable.c b/lib/rhashtable.c
> index d459bef245f4..e047ad912f0e 100644
> --- a/lib/rhashtable.c
> +++ b/lib/rhashtable.c
> @@ -189,7 +189,6 @@ static struct bucket_table *bucket_table_alloc(struct r=
hashtable *ht,
>  	struct bucket_table *tbl =3D NULL;
>  	size_t size;
>  	int i;
> -	static struct lock_class_key __key;
> =20
>  	tbl =3D alloc_hooks_tag(ht->alloc_tag,
>  			kvmalloc_node_align_noprof(struct_size(tbl, buckets, nbuckets),
> @@ -205,7 +204,12 @@ static struct bucket_table *bucket_table_alloc(struct =
rhashtable *ht,
>  	if (tbl =3D=3D NULL)
>  		return NULL;
> =20
> -	lockdep_init_map(&tbl->dep_map, "rhashtable_bucket", &__key, 0);
> +	/*
> +	 * Keep all bucket tables belonging to the same rhashtable in the
> +	 * per-init-site lock class, including tables created during resize.
> +	 */
> +	lockdep_init_map(&tbl->dep_map, "rhashtable_bucket",
> +			 ht->bucket_lock_key, 0);
> =20
>  	tbl->size =3D size;
> =20
> @@ -1162,7 +1166,8 @@ static u32 rhashtable_jhash2(const void *key, u32 len=
gth, u32 seed)
>   */
>  int __rhashtable_init_noprof(struct rhashtable *ht,
>  		    const struct rhashtable_params *params,
> -		    struct lock_class_key *key)
> +		    struct lock_class_key *mutex_key,
> +		    struct lock_class_key *bucket_key)
>  {
>  	struct bucket_table *tbl;
>  	size_t size;
> @@ -1172,7 +1177,8 @@ int __rhashtable_init_noprof(struct rhashtable *ht,
>  		return -EINVAL;
> =20
>  	memset(ht, 0, sizeof(*ht));
> -	mutex_init_with_key(&ht->mutex, key);
> +	mutex_init_with_key(&ht->mutex, mutex_key);
> +	ht->bucket_lock_key =3D bucket_key;
>  	spin_lock_init(&ht->lock);
>  	memcpy(&ht->p, params, sizeof(*params));
> =20
> @@ -1237,11 +1243,12 @@ EXPORT_SYMBOL_GPL(__rhashtable_init_noprof);
>   */
>  int __rhltable_init_noprof(struct rhltable *hlt,
>  			   const struct rhashtable_params *params,
> -			   struct lock_class_key *key)
> +			   struct lock_class_key *mutex_key,
> +			   struct lock_class_key *bucket_key)
>  {
>  	int err;
> =20
> -	err =3D __rhashtable_init_noprof(&hlt->ht, params, key);
> +	err =3D __rhashtable_init_noprof(&hlt->ht, params, mutex_key, bucket_key);
>  	hlt->ht.rhlist =3D true;
>  	return err;
>  }
>=20
> ---
> base-commit: 0131b508c0e2489eac6e121135988f6eeb716f19
> change-id: 20260801-fix-rhashtable-bucket-lockdep-95e25abebeea
>=20
> Best regards,
> -- =20
> quanyeyang <quanyemostima@gmail.com>
>=20
>=20
>=20
>=20

