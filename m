Received: from fout-b3-smtp.messagingengine.com (fout-b3-smtp.messagingengine.com [202.12.124.146])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47F5A217F33;
	Mon,  3 Aug 2026 02:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.146
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785722444; cv=none; b=rwmNNzFmrxOlPK5X7ZVdzKFSNByqI9Jc2m1V6irUMOMu5H3kBrvi0vR8O11h1BWW5dcRuAodhb/q15xeoEzMmPpwZYc+egP0fgbrjyx0FSIrWNZQWmHjRJBrZzLVQpR2uz5JJGJ+sKHtmzf3pvuEvFr1+uR/TKUVpT9xmibSneo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785722444; c=relaxed/simple;
	bh=nvD4SW1DHFbXdGCxxulpv4bE120QUqu/514uop8/hfw=;
	h=Content-Type:MIME-Version:From:To:Cc:Subject:In-reply-to:
	 References:Date:Message-id; b=pqE8wc0ng5qYP4rk2nHP8wEKW6K5U41DXzaeYUXTtP6M1FdHIQOoitZP56ahpqr3p09qeDCCorABeiN7mrf+/z9xzg/kmff1qhJlUTHOdmjwoqF1wlw14eVvA4b4q5Sf16Stgk1eTtkBG4JiAirkSIstF5ov7VE8XWSiAW+IN4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net; spf=pass smtp.mailfrom=ownmail.net; dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b=WOeyUjVI; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=HdfMgR6R; arc=none smtp.client-ip=202.12.124.146
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ownmail.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b="WOeyUjVI";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="HdfMgR6R"
Received: from phl-compute-12.internal (phl-compute-12.internal [10.202.2.52])
	by mailfout.stl.internal (Postfix) with ESMTP id 19BC81D00087;
	Sun,  2 Aug 2026 22:00:41 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-12.internal (MEProxy); Sun, 02 Aug 2026 22:00:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:reply-to:subject:subject:to:to; s=fm3; t=
	1785722440; x=1785808840; bh=b1csc0Bi9PssIdzSjfNC0ye07hb5G0sz0h8
	wj5zyg8E=; b=WOeyUjVI7EBQOcLNRA/goHlilP2Ua2JVAZFaw+hyzUudasDNC3G
	rLYKOqHVyJrkKRGLODSWOcOncYyMJnFCMsXjWHi/FNCmSRizX4M8Q81xzkP9afCj
	fVRd1TPx68aL6Rn5ggbdjcI2F7Skl/zkekHcrjAzkKcwoTgiCLktHIMKBAV+5Wmx
	Whn5fzRaWJ582Aco9qiPAl3Kfsyiaz7p8VlPa9itmDpejSSmNYR7u9xPp7vC4rNm
	bEflGctSX1J6WjcMaMIV9Moq4jzU0CGFrf6i15b9gloDIvFnTOAQhgmfvWfDYOja
	hWTViJKjvgLOz7hTXgcTBk+7ej+FKI6RpCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1785722440; x=
	1785808840; bh=b1csc0Bi9PssIdzSjfNC0ye07hb5G0sz0h8wj5zyg8E=; b=H
	dfMgR6RatFgHD8hrLbXKurNyVelyCkblRHF/vuH3Wx6BjkHEvYuS/zGmtM3ECrbq
	19x/D2FYEaF3pumTHk+jxn+8lWoVpJBYlP645aVAX+ATgAWfXxbCwCF+QTedUyZC
	COBAfziM7zFgzJJzkXoMfEBmHX0ltzTeUG2MnxXuibqi2WJHgohfg2YGZb2SPno6
	IE7HnatZJlHkCTCJmdq0VVt4w8+1McJ2U8TTFAV8jRHCeIzKTuYywi9PZ2JX83Dr
	K/vdKKKW+GnhzvOJ3lOsDvQRUpYgh34joDA7MALClsJGR19pT7AqQi9nM8ceb02Q
	i4unTrpekzuagioCwXwnQ==
X-ME-Sender: <xms:R_ZvasHEfti39MGsY2oBcl4FG6P0R-H0uHbhKp1GfzPkGC3wkc3XTA>
    <xme:R_ZvaqThN-AuSkTpY-cdhF_UNwLDF9v4Yu1VO5QIazWuBiAkyXmM4TgNJfb8lR8i-
    Kn9ENJEIQGmquG77RuADDSHTpUtZBRp5y5EHMb_SnM6MGCX5FA>
X-ME-Received: <xmr:R_ZvaqaaNGlFbZ-gb5Nlmau_W7T99AF5cRmtjDOhb3XytnyZFHiJlriCgXQrKs42KBwmXJ6Md0oHLgSLtlOU61vkkcn_2uU>
X-ME-Proxy-Cause: dmFkZTEfxBXaQQ2c+J4kJFXYlS7IKH6MrdfIx3SMCIqo1UULebfNRTvW2KOc8md56fScSm
    O2PvdzTvTuRZj8K2qgfCcvV+lYfCjN3LH3RNPK5NaUZw37qfVwex0fPM8Ayc8H/CfAfZPl
    oqd/qN1UpmL4AUl6Gs6ttum5xU9UrIGI4y6okZSIK8a/xPYyBh6AkmeRVJoDEMzAWSUmkd
    QdKaHKD0uheUeHD2IKul4f/9q2r7QpeVmyFKWXPx/WmulfuqwmPevCr+QMqkkue1/qItsj
    6RuUUJL/JbZyF3MS17MNhxVVw7T5/352sUDFpfHSF2xxf1Nad9jAG4aXvZPjxK+gETLGV+
    mIOXe90FztwjJgWeoIcm2e+nVtfGreF8LSaB1BJNq2T+btkV6ejXjj8PoQWOVgTHOcQLdK
    vefYwDrSEM4wHrb3cuG+fErFXzaMG/IbFBhYYCtmmp7jZZJH0TVNZ+a/RQSXm3GeWOPTbC
    enPKi9Dd5AsR9TSmH/v9+0Vhu8XEM231rgt7+31Do/GjvBMW8/plVRYHdP1Y31675oGlFV
    WU78iO/rHzwL75kGpMsr8oz8FV48Ob8Q4hsEcGi4kWQ7uS3go1VdtRmMnp4oy3Dg5y/xMl
    r+3NZKm90aAmIsF/A4MZ4h1ouxTlcIq7YPsknwam/as8Rp8vtIHgEtIWI4xw
X-ME-Proxy: <xmx:R_Zvat2yAKVcyo3l7JcfZG5AKYCYNg6sr__cKeDnECOAPlB6K3HJaw>
    <xmx:R_ZvalqywTSvollyIN4G1Z1pPKIxziU1ghFtOIaaLtRzOv_eEltOug>
    <xmx:R_ZvakOzeWv4VIb2qfhEXsefjJ8ML4vMq-wz9eHSOOu3-8MRZ-ktqA>
    <xmx:R_Zvamq-SelIgfNrtPrM36hD3re0PMaV4d21BETtjCxo4JBzY2lOqQ>
    <xmx:SPZvarwLdRNg36lppqy7JtwuKBO44o0U7xjSqXJqKDURlo6USJcdzdAC>
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 2 Aug 2026 22:00:35 -0400 (EDT)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: NeilBrown <neilb@ownmail.net>
To: "Quanye Yang" <quanyemostima@gmail.com>
Cc: "Thomas Graf" <tgraf@suug.ch>, "Herbert Xu" <herbert@gondor.apana.org.au>,
 "Andrew Morton" <akpm@linux-foundation.org>,
 "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 syzbot+ef8d17bae14efb960935@syzkaller.appspotmail.com
Subject:
 Re: [PATCH] rhashtable: use per-init-site lockdep classes for bucket locks
In-reply-to:
 <CABcBDJuSd=tjfcQoDxVgRrYw0UKu0HPcWDC4H10uOmR8--fE2Q@mail.gmail.com>
References:
 <20260801-fix-rhashtable-bucket-lockdep-v1-1-15a0f8ae094c@gmail.com>
  <178558275123.3252194.11769833511956588358@noble.neil.brown.name>
  <CABcBDJuSd=tjfcQoDxVgRrYw0UKu0HPcWDC4H10uOmR8--fE2Q@mail.gmail.com>
Date: Mon, 03 Aug 2026 12:00:32 +1000
Message-id: <178572243204.3252194.4367547703856027885@noble.neil.brown.name>
Reply-To: NeilBrown <neil@brown.name>

On Sun, 02 Aug 2026, Quanye Yang wrote:
> On Sat, Aug 01, 2026 at 07:12:00PM +0000, NeilBrown wrote:
> > This seems like a band-aid rather than a proper fix.
> >
> > Surely attaching a BPF program to lock_release() has potential for
> > causing all sorts of lockdep related problems.  Any lock that the BPF
> > program takes can trigger something, and I find it unlikely that
> > rhashtable is the only part of BPF code that takes a lock.
> >
> > Maybe the tracepoint needs to disable lockdep while the BPF handler is
> > running, or something like that.
> >
> > But I would need a much stronger argument before I could be happy with
> > this patch.
>=20
> Thanks for the review.
>=20
> I agree that attaching BPF to lock_release() is a sharp edge: the
> tracepoint runs before __lock_release(), so the lock is still on the
> lockdep held stack, and any lock taken by the BPF program becomes a
> dependency edge.  Whether that instrumentation path should be isolated
> from lockdep is a broader question, and I don't claim this patch solves
> it.
>=20
> But the syzbot warning at hand is not BPF-specific.  It is a false
> positive from modeling every rhashtable bucket lock with one global
> lock_class_key.  Different rhashtable instances have different physical
> bitlocks; nesting them is not recursive locking of the same lock.

This is common practice in the kernel.
All dentries for all filesystems have a d_lock with the same lock_class.
All block devices have a bd_holder_lock mutex with the same lock_class.
All kobjects have a list_lock with the same lock_class.

>=20
> I can reproduce the same "possible recursive locking detected" without
> any BPF / lock tracepoint:
>=20
>   1. init two tables at distinct rhashtable_init() call sites (ht_a, ht_b)
>   2. prefill so the insert path walks a non-empty bucket chain
>   3. in ht_a's obj_cmpfn (called under ht_a's bucket bitlock), call
>      rhashtable_lookup_insert_key() on ht_b

Yes you *can* do that, but why *would* you do that?
The obj_cmpfn is meant to be an idempotent compare function.
We make no particular promises about when it will be called.
So making a change to anything in that function is ill-advised at best.
I don't think we have any interest in making change which would allow
an obj_cmpfn() to make changes to a different rhashtable.

>=20
> That is enough to hit the warning on an unpatched kernel.  So disabling
> lockdep around the BPF handler would only silence one trigger for this
> class-modeling bug; it would not fix the underlying incorrect lock class
> sharing, and it would also hide real lock-order problems on that path
> (including the callback-under-bucket-lock cases that 149212f07856 wanted
> lockdep to see).

I think the main reason we added the lockdep tracking was to justify
that switching from spinlocks to bitlock didn't lose anything important.
It wouldn't be completely inappropriate to take a lock in an obj_cmpfn,
but I wouldn't normally expect it.

>=20
> The per-init-site bucket key follows the same approach as 060d4e94b8d4
> did for ht->mutex: keep one class per init site (and across resize of
> that table via SINGLE_DEPTH_NESTING), rather than one class for the
> entire kernel.

Hmmm.. I think that patch might have been a poor choice.

Commit 09ae540e1d5c ("rhashtable: drop ht->mutex in rhashtable_free_and_destr=
oy()")

landed about the same time and removed the problem instead of hiding it.

NeilBrown


>=20
> Happy to share the small local reproducer if that helps.
>=20
> On Sat, Aug 1, 2026 at 7:12=E2=80=AFPM NeilBrown <neilb@ownmail.net> wrote:
> >
> > On Sat, 01 Aug 2026, quanyemostima@gmail.com wrote:
> > > From: quanyeyang <quanyemostima@gmail.com>
> > >
> > > All bucket tables currently share a single lockdep class. This makes
> > > lockdep conflate bucket locks from unrelated rhashtable instances.
> > >
> > > A BPF program attached to lock_release can expose this when pidfs
> > > inserts a pid. The tracepoint runs before lockdep removes the pidfs
> > > bucket lock from the task's held-lock stack. Deleting an element from
> > > a BPF RHASH map then acquires a bucket lock belonging to a different
> > > rhashtable. Since both tables use the same class, lockdep reports
> > > possible recursive locking.
> >
> > This seems like a band-aid rather than a proper fix.
> >
> > Surely attaching a BPF program to lock_release() has potential for
> > causing all sorts of lockdep related problems.  Any lock that the BPF
> > program takes can trigger something, and I find it unlikely that
> > rhashtable is the only part of BPF code that takes a lock.
> >
> > Maybe the tracepoint needs to disable lockdep while the BPF handler is
> > running, or something like that.
> >
> > But I would need a much stronger argument before I could be happy with
> > this patch.
> >
> > NeilBrown
> >
> >
> > >
> > > Declare a separate bucket lock class key at each rhashtable_init() and
> > > rhltable_init() call site, alongside the mutex class key. Store the
> > > bucket key in struct rhashtable so tables created during resize keep
> > > using the same class.
> > >
> > > A targeted reproducer triggers the warning reliably before this change.
> > > After the change, the nested BPF RHASH deletion still executes, but
> > > lockdep no longer reports recursive locking.
> > >
> > > Fixes: 149212f07856 ("rhashtable: add lockdep tracking to bucket bit-sp=
in-locks.")
> > > Reported-by: syzbot+ef8d17bae14efb960935@syzkaller.appspotmail.com
> > > Closes: https://syzkaller.appspot.com/bug?extid=3Def8d17bae14efb960935
> > > Assisted-by: Cursor:GPT-5.6 Sol
> > > Signed-off-by: quanyeyang <quanyemostima@gmail.com>
> > > ---
> > >  include/linux/rhashtable-types.h | 20 ++++++++++++++------
> > >  lib/rhashtable.c                 | 19 +++++++++++++------
> > >  2 files changed, 27 insertions(+), 12 deletions(-)
> > >
> > > diff --git a/include/linux/rhashtable-types.h b/include/linux/rhashtabl=
e-types.h
> > > index 57c11ec9dc64..4dea91a49ec8 100644
> > > --- a/include/linux/rhashtable-types.h
> > > +++ b/include/linux/rhashtable-types.h
> > > @@ -82,6 +82,7 @@ struct rhashtable_params {
> > >   * @mutex: Mutex to protect current/future table swapping
> > >   * @lock: Spin lock to protect walker list
> > >   * @nelems: Number of elements in table
> > > + * @bucket_lock_key: Per-init-site lockdep class for bucket bit-locks
> > >   */
> > >  struct rhashtable {
> > >       struct bucket_table __rcu       *tbl;
> > > @@ -94,6 +95,7 @@ struct rhashtable {
> > >       struct mutex                    mutex;
> > >       spinlock_t                      lock;
> > >       atomic_t                        nelems;
> > > +     struct lock_class_key           *bucket_lock_key;
> > >  #ifdef CONFIG_MEM_ALLOC_PROFILING
> > >       struct alloc_tag                *alloc_tag;
> > >  #endif
> > > @@ -138,23 +140,29 @@ struct rhashtable_iter {
> > >
> > >  int __rhashtable_init_noprof(struct rhashtable *ht,
> > >                   const struct rhashtable_params *params,
> > > -                 struct lock_class_key *key);
> > > +                 struct lock_class_key *mutex_key,
> > > +                 struct lock_class_key *bucket_key);
> > >  #define rhashtable_init_noprof(ht, params)                           \
> > >  ({                                                                   \
> > > -     static struct lock_class_key __key;                             \
> > > +     static struct lock_class_key __mutex_key;                       \
> > > +     static struct lock_class_key __bucket_key;                      \
> > >                                                                       \
> > > -     __rhashtable_init_noprof(ht, params, &__key);                   \
> > > +     __rhashtable_init_noprof(ht, params, &__mutex_key,              \
> > > +                              &__bucket_key);                        \
> > >  })
> > >  #define rhashtable_init(...) alloc_hooks(rhashtable_init_noprof(__VA_A=
RGS__))
> > >
> > >  int __rhltable_init_noprof(struct rhltable *hlt,
> > >                 const struct rhashtable_params *params,
> > > -               struct lock_class_key *key);
> > > +               struct lock_class_key *mutex_key,
> > > +               struct lock_class_key *bucket_key);
> > >  #define rhltable_init_noprof(hlt, params)                            \
> > >  ({                                                                   \
> > > -     static struct lock_class_key __key;                             \
> > > +     static struct lock_class_key __mutex_key;                       \
> > > +     static struct lock_class_key __bucket_key;                      \
> > >                                                                       \
> > > -     __rhltable_init_noprof(hlt, params, &__key);                    \
> > > +     __rhltable_init_noprof(hlt, params, &__mutex_key,               \
> > > +                            &__bucket_key);                          \
> > >  })
> > >  #define rhltable_init(...)   alloc_hooks(rhltable_init_noprof(__VA_ARG=
S__))
> > >
> > > diff --git a/lib/rhashtable.c b/lib/rhashtable.c
> > > index d459bef245f4..e047ad912f0e 100644
> > > --- a/lib/rhashtable.c
> > > +++ b/lib/rhashtable.c
> > > @@ -189,7 +189,6 @@ static struct bucket_table *bucket_table_alloc(stru=
ct rhashtable *ht,
> > >       struct bucket_table *tbl =3D NULL;
> > >       size_t size;
> > >       int i;
> > > -     static struct lock_class_key __key;
> > >
> > >       tbl =3D alloc_hooks_tag(ht->alloc_tag,
> > >                       kvmalloc_node_align_noprof(struct_size(tbl, bucke=
ts, nbuckets),
> > > @@ -205,7 +204,12 @@ static struct bucket_table *bucket_table_alloc(str=
uct rhashtable *ht,
> > >       if (tbl =3D=3D NULL)
> > >               return NULL;
> > >
> > > -     lockdep_init_map(&tbl->dep_map, "rhashtable_bucket", &__key, 0);
> > > +     /*
> > > +      * Keep all bucket tables belonging to the same rhashtable in the
> > > +      * per-init-site lock class, including tables created during resi=
ze.
> > > +      */
> > > +     lockdep_init_map(&tbl->dep_map, "rhashtable_bucket",
> > > +                      ht->bucket_lock_key, 0);
> > >
> > >       tbl->size =3D size;
> > >
> > > @@ -1162,7 +1166,8 @@ static u32 rhashtable_jhash2(const void *key, u32=
 length, u32 seed)
> > >   */
> > >  int __rhashtable_init_noprof(struct rhashtable *ht,
> > >                   const struct rhashtable_params *params,
> > > -                 struct lock_class_key *key)
> > > +                 struct lock_class_key *mutex_key,
> > > +                 struct lock_class_key *bucket_key)
> > >  {
> > >       struct bucket_table *tbl;
> > >       size_t size;
> > > @@ -1172,7 +1177,8 @@ int __rhashtable_init_noprof(struct rhashtable *h=
t,
> > >               return -EINVAL;
> > >
> > >       memset(ht, 0, sizeof(*ht));
> > > -     mutex_init_with_key(&ht->mutex, key);
> > > +     mutex_init_with_key(&ht->mutex, mutex_key);
> > > +     ht->bucket_lock_key =3D bucket_key;
> > >       spin_lock_init(&ht->lock);
> > >       memcpy(&ht->p, params, sizeof(*params));
> > >
> > > @@ -1237,11 +1243,12 @@ EXPORT_SYMBOL_GPL(__rhashtable_init_noprof);
> > >   */
> > >  int __rhltable_init_noprof(struct rhltable *hlt,
> > >                          const struct rhashtable_params *params,
> > > -                        struct lock_class_key *key)
> > > +                        struct lock_class_key *mutex_key,
> > > +                        struct lock_class_key *bucket_key)
> > >  {
> > >       int err;
> > >
> > > -     err =3D __rhashtable_init_noprof(&hlt->ht, params, key);
> > > +     err =3D __rhashtable_init_noprof(&hlt->ht, params, mutex_key, buc=
ket_key);
> > >       hlt->ht.rhlist =3D true;
> > >       return err;
> > >  }
> > >
> > > ---
> > > base-commit: 0131b508c0e2489eac6e121135988f6eeb716f19
> > > change-id: 20260801-fix-rhashtable-bucket-lockdep-95e25abebeea
> > >
> > > Best regards,
> > > --
> > > quanyeyang <quanyemostima@gmail.com>
> > >
> > >
> > >
> > >
> >
>=20

