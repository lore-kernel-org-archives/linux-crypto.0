Received: from mail-pj2-f11.google.com (mail-pj2-f11.google.com [74.125.227.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60BE030146C
	for <linux-crypto@vger.kernel.org>; Mon,  3 Aug 2026 14:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.227.139
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785767911; cv=pass; b=pegqTiDo33pOQYLerdd5VZ2kcwAd4WMW6MF6DIrlETH95V8qJL+7SDdtd9/uDhnrMi6U5fag80mmkrPYF+/uhglnJyDSHn5wvrWkvas+1zMEEPNDgUPbFihs6W3BnMRM+6A1jJnCuPzEqCczDZbB89hXAMhRP5Pumk5HQLTzJTA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785767911; c=relaxed/simple;
	bh=B+vUJmBEMQsBWh/Im+3VS/KjzjCeXO0kq2gL4VURGkU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FvbLEUqMiGIhbhnTYdr0AKgV8c0ZOd9mti1OhGpSK7LH+GB9pk0XhxBuAZ3+bPCVu7YcZsK2+UXrMdfQ1OkQMIz8R4k9N2HO8UqneZdRM5h/5lpyP1eLpXpiuKhVC8jb4B6+0UmdZQ5mzhhbVgS0rvFLmUf3g+qdHOx6dme2Uuc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JAd/5R0P; arc=pass smtp.client-ip=74.125.227.139
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JAd/5R0P"
Received: by mail-pj2-f11.google.com with SMTP id 98e67ed59e1d1-38dbe53179bso959957a91.0
        for <linux-crypto@vger.kernel.org>; Mon, 03 Aug 2026 07:38:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785767908; cv=none;
        d=google.com; s=arc-20260327;
        b=kyk/G0IUGwFHscGxNC509i8nJscP/TTvlVbXu94+hwejMzfGQOl+EWKBSvFc4geO3I
         tkEmGyybIKolu4A9B0fntwNE9xy2Ok8IUEMRSDhG/ONvs1L/zi1wPaZoQYcrnwo/9+ZJ
         hr0bEkvGB/DwFlRd6OHXCGY8uQMEda4cTQYChdYSr9BpWNzDaGoL18go2Oyu2fKFpOas
         FLFJvPRrS1COgW4FKxHDlLQ7N3PZqLG/2K2vwLjcKdEO4Ok4gIhR/iY6SPjbbXV2mLX1
         3ZOPiQuXYpvqBCJtA1Vwy54RoOGbYvti8OfVTnSt3LFko6gaKhLmnpHhb/os5F7RGw5m
         4+6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=t/XXcO0TWbkyJHu8Z3YgcXtVFJ+7Aoz5ByzD0OhmRrY=;
        fh=JKmf5uWIdFASsVwlL9sq/ykXtRhAHhSQhZJBdAgj+oM=;
        b=Zv872SibEET0OEdjdDqiDv0J9GwfS6HWODXfugs9kwJcx/LLx+Y2GJj8oF6OyW5/hq
         UsJNIKfuCajXtrZBHGHoPTTW8ga7FeJ4dB0RZ5DX9QjW2xx6yDARSEF0QW/C1xjATiBa
         ll0sbcA0ns8HJMckWsfZ18M6n5lLFPHrlzbO6XjGi8tvBwf7gpb6q5tYQvahsF5lluN4
         JnHDc2k5ckJEarQTVba2sAXvOW68kHoR6Hod/Gm525A/H8egnOZKyJBIoiByPF4415oI
         RC9cErnzcW1yC8a0NCU53y+DszCFPOWqZFI3QlemDbppdxbL4vQ0edUjTBvWZO0PHWNA
         A/TA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785767908; x=1786372708; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=t/XXcO0TWbkyJHu8Z3YgcXtVFJ+7Aoz5ByzD0OhmRrY=;
        b=JAd/5R0PFTXnZ9HuVyGCekWQ6aF4uHErJ2ppgA+midYx/xK+a1BBVPx72h0cYkb1Qk
         3kT1iu1U7VeV+hu6q6wd3clnY7zERzb5SLpHemcQyeVVj1F7hJgggAhyCYd/TRk5O6LR
         hlz5rJMkXDbgdFJm3q2kEd5FBAGVCJvMouJnld79w9axAu4iAxhcHTGVRr2nHKOQWaEj
         S28kYrEFqrNzbqkKlsVxQVk/KWp80vGq/hs8AjA6624BxTkqE0PW4c95sPh1LNIeoXSH
         rR5Dx4I2Dx8Vn5nuFOU8Yz5Ee1948dwUaRqcUUsr63fbSAtyoKHaIyjz8ELxiE2BCqpN
         XMUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785767908; x=1786372708;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=t/XXcO0TWbkyJHu8Z3YgcXtVFJ+7Aoz5ByzD0OhmRrY=;
        b=TPD1XtMcFl2U7qaaPtkQjXHnSi3obPhPYj+/xg01+B5ZKHhrSh47UlZGh3+dHSH4Or
         WE8iRKTZkO2IbrpHaWPrFL8vfMimUH/nDdcpxFMvbLpk2+Tw5bAebGYxgAQYx/F0VmcJ
         kCKDfP5/5LuHgad8bYmignDNEwSrBzg4NCkD6TY63dbYxst17aktUPVW42PCCFzTCbVw
         K+GANALQrZrjayUEKQwOuXcmkqdap2FTd1uqF8IAqO/Ud2obp+FmrAhsgv8Wu55r0iTg
         haF1hU3Z40Xrl5FgBwyZg1Sl4SVqWiccSSqcY6wH3yQ8p0FKwoo3Racb5WWd/XB63wMF
         +uHQ==
X-Forwarded-Encrypted: i=1; AHgh+RpBCovxETRejaNFYkjjOZrW+kvHTH7ntIlKBfYe4bP4XN5CmsJg7ddJNJRA8UZMDWex6jPL+nR1MXS9FBg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxuv0e4YiU9My6e0pO9OeYCgoFi3fxWL6S2ni/UH7Tbq5o6hrBj
	34TnEdeiN4HO63nnlHTDP+4mDoMsyosMyXI8lFC8aNQ4aff9FhPvM2f2UrxhiHDELu9PnzoW5J9
	tEsnhiwHxlJrvJ7QkB0rUz9+c+XEwVb4Q9H0LXzqQqw==
X-Gm-Gg: AR+sD11t+Rm0513LCUMJEGiMaiZglxM7RL0T/5SjF/Za+lIjfWWvzk5JClnGj7tFjL3
	7CNQcJsrdhuqM4BUmjAAYF18EKgY3trMkv7Mx0k6+tiiePQPXDjprKGMGJYKObo01qccHCeRL7X
	BegQQwHQfPWi+mQvNmWwnS7yrkVf5ZyxlXpaN685vIQWiodkaFca4aZ4zdd5tyIwA23kTndFVVo
	tQ0zNYJ4TfXL0IM44tRoxM2g3xjtAbzofbEGb+TCwhyH2LAT//6GoSE44EQv1sda+CO4YfhdqYJ
	dztT7/jQiT6/aQYhh07VTvMhi+WkBrbYZ12Yuz0+GkW5HQ==
X-Received: by 2002:a17:90b:3a8e:b0:38e:c232:9d3f with SMTP id
 98e67ed59e1d1-38fbc3f09e8mr9205322a91.5.1785767907520; Mon, 03 Aug 2026
 07:38:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260801-fix-rhashtable-bucket-lockdep-v1-1-15a0f8ae094c@gmail.com>
 <178558275123.3252194.11769833511956588358@noble.neil.brown.name>
 <CABcBDJuSd=tjfcQoDxVgRrYw0UKu0HPcWDC4H10uOmR8--fE2Q@mail.gmail.com> <178572243204.3252194.4367547703856027885@noble.neil.brown.name>
In-Reply-To: <178572243204.3252194.4367547703856027885@noble.neil.brown.name>
From: Quanye Yang <quanyemostima@gmail.com>
Date: Mon, 3 Aug 2026 22:38:15 +0800
X-Gm-Features: AUfX_myhpuj0ONaBxCbLIgjqqNhz01vZJrCVPw_JRwnjsgnHVpv_WE0gmVMIOSY
Message-ID: <CABcBDJu_5qLeH=XN_2ZHHTfjAkt4Sjiqu2w9nvF4K6eoRnBzog@mail.gmail.com>
Subject: Re: [PATCH] rhashtable: use per-init-site lockdep classes for bucket locks
To: NeilBrown <neil@brown.name>
Cc: Thomas Graf <tgraf@suug.ch>, Herbert Xu <herbert@gondor.apana.org.au>, 
	Andrew Morton <akpm@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot+ef8d17bae14efb960935@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 03 Aug 2026, NeilBrown wrote:
> This is common practice in the kernel.
> All dentries for all filesystems have a d_lock with the same lock_class.
> All block devices have a bd_holder_lock mutex with the same lock_class.
> All kobjects have a list_lock with the same lock_class.

Fair enough =E2=80=94 that matches d_lock / bd_holder_lock / kobject list_l=
ock.
The per-init-site split was the wrong tool here.

> The obj_cmpfn is meant to be an idempotent compare function.
> We make no particular promises about when it will be called.

Right =E2=80=94 the obj_cmpfn reproducer isn't a realistic case to shape th=
e
lock modeling around.

> Commit 09ae540e1d5c ... removed the problem instead of hiding it.

That's the takeaway: remove the problem rather than paper over the
class modeling.

So I'm dropping this rhashtable patch, and taking the direction you
suggested =E2=80=94 disable lockdep around the BPF handler on lock_release =
=E2=80=94 as
a separate RFC:

https://lore.kernel.org/all/20260803-fix-lock-tracepoint-bpf-lockdep-v1-1-9=
1fb7afb526a@gmail.com/

Thanks for the review.

quanyeyang

On Mon, Aug 3, 2026 at 10:00=E2=80=AFAM NeilBrown <neilb@ownmail.net> wrote=
:
>
> On Sun, 02 Aug 2026, Quanye Yang wrote:
> > On Sat, Aug 01, 2026 at 07:12:00PM +0000, NeilBrown wrote:
> > > This seems like a band-aid rather than a proper fix.
> > >
> > > Surely attaching a BPF program to lock_release() has potential for
> > > causing all sorts of lockdep related problems.  Any lock that the BPF
> > > program takes can trigger something, and I find it unlikely that
> > > rhashtable is the only part of BPF code that takes a lock.
> > >
> > > Maybe the tracepoint needs to disable lockdep while the BPF handler i=
s
> > > running, or something like that.
> > >
> > > But I would need a much stronger argument before I could be happy wit=
h
> > > this patch.
> >
> > Thanks for the review.
> >
> > I agree that attaching BPF to lock_release() is a sharp edge: the
> > tracepoint runs before __lock_release(), so the lock is still on the
> > lockdep held stack, and any lock taken by the BPF program becomes a
> > dependency edge.  Whether that instrumentation path should be isolated
> > from lockdep is a broader question, and I don't claim this patch solves
> > it.
> >
> > But the syzbot warning at hand is not BPF-specific.  It is a false
> > positive from modeling every rhashtable bucket lock with one global
> > lock_class_key.  Different rhashtable instances have different physical
> > bitlocks; nesting them is not recursive locking of the same lock.
>
> This is common practice in the kernel.
> All dentries for all filesystems have a d_lock with the same lock_class.
> All block devices have a bd_holder_lock mutex with the same lock_class.
> All kobjects have a list_lock with the same lock_class.
>
> >
> > I can reproduce the same "possible recursive locking detected" without
> > any BPF / lock tracepoint:
> >
> >   1. init two tables at distinct rhashtable_init() call sites (ht_a, ht=
_b)
> >   2. prefill so the insert path walks a non-empty bucket chain
> >   3. in ht_a's obj_cmpfn (called under ht_a's bucket bitlock), call
> >      rhashtable_lookup_insert_key() on ht_b
>
> Yes you *can* do that, but why *would* you do that?
> The obj_cmpfn is meant to be an idempotent compare function.
> We make no particular promises about when it will be called.
> So making a change to anything in that function is ill-advised at best.
> I don't think we have any interest in making change which would allow
> an obj_cmpfn() to make changes to a different rhashtable.
>
> >
> > That is enough to hit the warning on an unpatched kernel.  So disabling
> > lockdep around the BPF handler would only silence one trigger for this
> > class-modeling bug; it would not fix the underlying incorrect lock clas=
s
> > sharing, and it would also hide real lock-order problems on that path
> > (including the callback-under-bucket-lock cases that 149212f07856 wante=
d
> > lockdep to see).
>
> I think the main reason we added the lockdep tracking was to justify
> that switching from spinlocks to bitlock didn't lose anything important.
> It wouldn't be completely inappropriate to take a lock in an obj_cmpfn,
> but I wouldn't normally expect it.
>
> >
> > The per-init-site bucket key follows the same approach as 060d4e94b8d4
> > did for ht->mutex: keep one class per init site (and across resize of
> > that table via SINGLE_DEPTH_NESTING), rather than one class for the
> > entire kernel.
>
> Hmmm.. I think that patch might have been a poor choice.
>
> Commit 09ae540e1d5c ("rhashtable: drop ht->mutex in rhashtable_free_and_d=
estroy()")
>
> landed about the same time and removed the problem instead of hiding it.
>
> NeilBrown
>
>
> >
> > Happy to share the small local reproducer if that helps.
> >
> > On Sat, Aug 1, 2026 at 7:12=E2=80=AFPM NeilBrown <neilb@ownmail.net> wr=
ote:
> > >
> > > On Sat, 01 Aug 2026, quanyemostima@gmail.com wrote:
> > > > From: quanyeyang <quanyemostima@gmail.com>
> > > >
> > > > All bucket tables currently share a single lockdep class. This make=
s
> > > > lockdep conflate bucket locks from unrelated rhashtable instances.
> > > >
> > > > A BPF program attached to lock_release can expose this when pidfs
> > > > inserts a pid. The tracepoint runs before lockdep removes the pidfs
> > > > bucket lock from the task's held-lock stack. Deleting an element fr=
om
> > > > a BPF RHASH map then acquires a bucket lock belonging to a differen=
t
> > > > rhashtable. Since both tables use the same class, lockdep reports
> > > > possible recursive locking.
> > >
> > > This seems like a band-aid rather than a proper fix.
> > >
> > > Surely attaching a BPF program to lock_release() has potential for
> > > causing all sorts of lockdep related problems.  Any lock that the BPF
> > > program takes can trigger something, and I find it unlikely that
> > > rhashtable is the only part of BPF code that takes a lock.
> > >
> > > Maybe the tracepoint needs to disable lockdep while the BPF handler i=
s
> > > running, or something like that.
> > >
> > > But I would need a much stronger argument before I could be happy wit=
h
> > > this patch.
> > >
> > > NeilBrown
> > >
> > >
> > > >
> > > > Declare a separate bucket lock class key at each rhashtable_init() =
and
> > > > rhltable_init() call site, alongside the mutex class key. Store the
> > > > bucket key in struct rhashtable so tables created during resize kee=
p
> > > > using the same class.
> > > >
> > > > A targeted reproducer triggers the warning reliably before this cha=
nge.
> > > > After the change, the nested BPF RHASH deletion still executes, but
> > > > lockdep no longer reports recursive locking.
> > > >
> > > > Fixes: 149212f07856 ("rhashtable: add lockdep tracking to bucket bi=
t-spin-locks.")
> > > > Reported-by: syzbot+ef8d17bae14efb960935@syzkaller.appspotmail.com
> > > > Closes: https://syzkaller.appspot.com/bug?extid=3Def8d17bae14efb960=
935
> > > > Assisted-by: Cursor:GPT-5.6 Sol
> > > > Signed-off-by: quanyeyang <quanyemostima@gmail.com>
> > > > ---
> > > >  include/linux/rhashtable-types.h | 20 ++++++++++++++------
> > > >  lib/rhashtable.c                 | 19 +++++++++++++------
> > > >  2 files changed, 27 insertions(+), 12 deletions(-)
> > > >
> > > > diff --git a/include/linux/rhashtable-types.h b/include/linux/rhash=
table-types.h
> > > > index 57c11ec9dc64..4dea91a49ec8 100644
> > > > --- a/include/linux/rhashtable-types.h
> > > > +++ b/include/linux/rhashtable-types.h
> > > > @@ -82,6 +82,7 @@ struct rhashtable_params {
> > > >   * @mutex: Mutex to protect current/future table swapping
> > > >   * @lock: Spin lock to protect walker list
> > > >   * @nelems: Number of elements in table
> > > > + * @bucket_lock_key: Per-init-site lockdep class for bucket bit-lo=
cks
> > > >   */
> > > >  struct rhashtable {
> > > >       struct bucket_table __rcu       *tbl;
> > > > @@ -94,6 +95,7 @@ struct rhashtable {
> > > >       struct mutex                    mutex;
> > > >       spinlock_t                      lock;
> > > >       atomic_t                        nelems;
> > > > +     struct lock_class_key           *bucket_lock_key;
> > > >  #ifdef CONFIG_MEM_ALLOC_PROFILING
> > > >       struct alloc_tag                *alloc_tag;
> > > >  #endif
> > > > @@ -138,23 +140,29 @@ struct rhashtable_iter {
> > > >
> > > >  int __rhashtable_init_noprof(struct rhashtable *ht,
> > > >                   const struct rhashtable_params *params,
> > > > -                 struct lock_class_key *key);
> > > > +                 struct lock_class_key *mutex_key,
> > > > +                 struct lock_class_key *bucket_key);
> > > >  #define rhashtable_init_noprof(ht, params)                        =
   \
> > > >  ({                                                                =
   \
> > > > -     static struct lock_class_key __key;                          =
   \
> > > > +     static struct lock_class_key __mutex_key;                    =
   \
> > > > +     static struct lock_class_key __bucket_key;                   =
   \
> > > >                                                                    =
   \
> > > > -     __rhashtable_init_noprof(ht, params, &__key);                =
   \
> > > > +     __rhashtable_init_noprof(ht, params, &__mutex_key,           =
   \
> > > > +                              &__bucket_key);                     =
   \
> > > >  })
> > > >  #define rhashtable_init(...) alloc_hooks(rhashtable_init_noprof(__=
VA_ARGS__))
> > > >
> > > >  int __rhltable_init_noprof(struct rhltable *hlt,
> > > >                 const struct rhashtable_params *params,
> > > > -               struct lock_class_key *key);
> > > > +               struct lock_class_key *mutex_key,
> > > > +               struct lock_class_key *bucket_key);
> > > >  #define rhltable_init_noprof(hlt, params)                         =
   \
> > > >  ({                                                                =
   \
> > > > -     static struct lock_class_key __key;                          =
   \
> > > > +     static struct lock_class_key __mutex_key;                    =
   \
> > > > +     static struct lock_class_key __bucket_key;                   =
   \
> > > >                                                                    =
   \
> > > > -     __rhltable_init_noprof(hlt, params, &__key);                 =
   \
> > > > +     __rhltable_init_noprof(hlt, params, &__mutex_key,            =
   \
> > > > +                            &__bucket_key);                       =
   \
> > > >  })
> > > >  #define rhltable_init(...)   alloc_hooks(rhltable_init_noprof(__VA=
_ARGS__))
> > > >
> > > > diff --git a/lib/rhashtable.c b/lib/rhashtable.c
> > > > index d459bef245f4..e047ad912f0e 100644
> > > > --- a/lib/rhashtable.c
> > > > +++ b/lib/rhashtable.c
> > > > @@ -189,7 +189,6 @@ static struct bucket_table *bucket_table_alloc(=
struct rhashtable *ht,
> > > >       struct bucket_table *tbl =3D NULL;
> > > >       size_t size;
> > > >       int i;
> > > > -     static struct lock_class_key __key;
> > > >
> > > >       tbl =3D alloc_hooks_tag(ht->alloc_tag,
> > > >                       kvmalloc_node_align_noprof(struct_size(tbl, b=
uckets, nbuckets),
> > > > @@ -205,7 +204,12 @@ static struct bucket_table *bucket_table_alloc=
(struct rhashtable *ht,
> > > >       if (tbl =3D=3D NULL)
> > > >               return NULL;
> > > >
> > > > -     lockdep_init_map(&tbl->dep_map, "rhashtable_bucket", &__key, =
0);
> > > > +     /*
> > > > +      * Keep all bucket tables belonging to the same rhashtable in=
 the
> > > > +      * per-init-site lock class, including tables created during =
resize.
> > > > +      */
> > > > +     lockdep_init_map(&tbl->dep_map, "rhashtable_bucket",
> > > > +                      ht->bucket_lock_key, 0);
> > > >
> > > >       tbl->size =3D size;
> > > >
> > > > @@ -1162,7 +1166,8 @@ static u32 rhashtable_jhash2(const void *key,=
 u32 length, u32 seed)
> > > >   */
> > > >  int __rhashtable_init_noprof(struct rhashtable *ht,
> > > >                   const struct rhashtable_params *params,
> > > > -                 struct lock_class_key *key)
> > > > +                 struct lock_class_key *mutex_key,
> > > > +                 struct lock_class_key *bucket_key)
> > > >  {
> > > >       struct bucket_table *tbl;
> > > >       size_t size;
> > > > @@ -1172,7 +1177,8 @@ int __rhashtable_init_noprof(struct rhashtabl=
e *ht,
> > > >               return -EINVAL;
> > > >
> > > >       memset(ht, 0, sizeof(*ht));
> > > > -     mutex_init_with_key(&ht->mutex, key);
> > > > +     mutex_init_with_key(&ht->mutex, mutex_key);
> > > > +     ht->bucket_lock_key =3D bucket_key;
> > > >       spin_lock_init(&ht->lock);
> > > >       memcpy(&ht->p, params, sizeof(*params));
> > > >
> > > > @@ -1237,11 +1243,12 @@ EXPORT_SYMBOL_GPL(__rhashtable_init_noprof)=
;
> > > >   */
> > > >  int __rhltable_init_noprof(struct rhltable *hlt,
> > > >                          const struct rhashtable_params *params,
> > > > -                        struct lock_class_key *key)
> > > > +                        struct lock_class_key *mutex_key,
> > > > +                        struct lock_class_key *bucket_key)
> > > >  {
> > > >       int err;
> > > >
> > > > -     err =3D __rhashtable_init_noprof(&hlt->ht, params, key);
> > > > +     err =3D __rhashtable_init_noprof(&hlt->ht, params, mutex_key,=
 bucket_key);
> > > >       hlt->ht.rhlist =3D true;
> > > >       return err;
> > > >  }
> > > >
> > > > ---
> > > > base-commit: 0131b508c0e2489eac6e121135988f6eeb716f19
> > > > change-id: 20260801-fix-rhashtable-bucket-lockdep-95e25abebeea
> > > >
> > > > Best regards,
> > > > --
> > > > quanyeyang <quanyemostima@gmail.com>
> > > >
> > > >
> > > >
> > > >
> > >
> >
>
