Received: from mail-pj2-f3.google.com (mail-pj2-f3.google.com [74.125.227.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4928833B6D6
	for <linux-crypto@vger.kernel.org>; Sun,  2 Aug 2026 10:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.227.131
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785666837; cv=pass; b=lcxrN3XbIGYQEz1nSytyusZTamaGDbjtO3wLhJk8xJnry7301V7xkl9TixiTkvxyFm6ESLK90qo9cvw0At9evrh9KnjYe21WZM7rmtuYfZFQZHQG66Dpi+uCdFMiZ9OBxapWnz3z9N18yMA0enZ62E5DX25G/EYIE0tJ45Dtp6E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785666837; c=relaxed/simple;
	bh=n8xkAo9gAAwTl5C2x4Iqi3A6yP1GLcxTavBPQWdJ7aY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SGtY5SpQ73XDgxlBPLOjpV4Udy9nWN5jtm/v1LMUChGvNipQ0jJCfXbbbzptznKSOlVZS0zpIGK3FWWgQIH91reRs1qAKYFV49fruScQAI4KAzcG9W6X31GjfRXlTR8YvRrOMfqJ6B8zSYWBO0VX13ZEywhchwNmiqfc1YTvpyE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=siATVMGf; arc=pass smtp.client-ip=74.125.227.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="siATVMGf"
Received: by mail-pj2-f3.google.com with SMTP id d9443c01a7336-2ccb0e85312so14662265ad.0
        for <linux-crypto@vger.kernel.org>; Sun, 02 Aug 2026 03:33:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785666835; cv=none;
        d=google.com; s=arc-20260327;
        b=ntajC7fkkUobmEIAi9MVf+LRYHjLxV1RT9fQwiKItaEPrXC1uvtwQb0YQaZEmf+DvO
         y9jonnw5PyRoFEWupDdAr7TCPgIiCk20yAiTIhNQQ1SSUv9gvJpbt30M9Oq15L18Lv7D
         RLfFiRkF1OfsCpBMJGnR8XF8zDEWCDVHgd1T1jWCgOE4UuLD+Cb2BZkGJgP3FD43s+D5
         SzMv1uN6AlmaCzgdhlwKcov9Ai67gA4uAMZVqte6z7jQYR29ez5NeE0GoPYeMHD+vd10
         uV9by4NtYlx2SkECy4TuLt7o9sr/UcSn0aPDBpjg00x1uelH3pD+QcNwE4/FpxKxe9C/
         ReIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=etHLP0egrf5kFKUELVc+A40QZjO5VBQKdu4BMmdYXPk=;
        fh=d5Awy7RYGkCFHJVFwFSfZk64LECY6Fcmil7XvSerp4Y=;
        b=XWuNUPKa9Lc0T/8NneCi0lVvXIHQwf53Th70uPUqTIEQ6ZW481Wre/HjuxL+JFptTu
         yYjnOc3i1YxC06yK2HGmErbq4sfsjgfkPKY3Sz+l5DmEFNXVxGDnYjw1Sp1r/U7ll6rC
         k4nXyiNAo8mXS5r/9TI+j3M+2y3Lv9xRB0ZCon2tR1f0tsaizRPK7pXdWuOj2+NiNn2W
         Ub7rRnR5xbcnZGpBnzPGNQee9rF4MZIwdg02STXQ3XyieXXVGRBOHSapnsZc82ZMWT1d
         reAYnCDe1+cfCv0OTN86l/MJArfg9esijgPChAqSTztlZO8fSpRm0JaridILj9+vMWwa
         M+Mg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785666835; x=1786271635; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=etHLP0egrf5kFKUELVc+A40QZjO5VBQKdu4BMmdYXPk=;
        b=siATVMGfwpoU1y3jdmjf+J+8U2ODi9UPtdzsQlPJDdUz5Ap54BSGLaR6nRsaI2TYiT
         j9E4uId9ttWZUX0VYNaNtKIj+fyUHZMJA5RkbCsCcKjhWNJVlgA7zP1M3Bl3Cb4295od
         IvRypb40/Df1fQ8LD1Hql6tWaKAkxC4KQNj37853NcXoeoO4LHKvPVtPD05zx28PV2Pl
         1I2sikHpCbZOStdUqGuLLFXH3ZcmUYCKpXj9okbcjNwfxNr3ojtWmEi5O6q40KwD/gA1
         fizxA0cG1veB/BkHkRnTXZajpJhvpVYij+/g99+G4xigBkan4wJeZVle6PXw9tiU8+J0
         JM2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785666835; x=1786271635;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=etHLP0egrf5kFKUELVc+A40QZjO5VBQKdu4BMmdYXPk=;
        b=rtx/RDihvN+qOV0/8lKUzh7wxdPB8/9g8IFnOlFkXQHOAxr1kRg3PGiqbfidWn/SkI
         Dg5g4H4FhzRR2yKxm3uT0rvPCG7X7ze0oTB6eYvw4y/VODfoAlC9Mc7zoRrK3UelKM6h
         daZVh3/GPgK1GuuO7ugJaUCAEiTZLF73XL7U3ifEuB3XG9xBhiUfrCs5jS27W74JwgJU
         +XzBM7SxTTBpCYLKbUgf7wIJ3wxroYlZZwY32JfcXO0yZr3+fLGOFFHbSs+XTA/vzKjb
         CDk38qnSWhyOk5ZGnZxuqKJmOMFTB5ZLtqBfHW6hZZfE7z/ZeIsSeD33MyDdkLMbYYM7
         ljwA==
X-Forwarded-Encrypted: i=1; AHgh+RrOqarcRjNnuzZvCOPGifBC9GKXhP2KYsBZ51HE+5MbPN1CZtaj1rD/Ftl3Cgo9FRvuab+6NKm6kIiKXcQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwFT8Qw85yLxlmQhxkZ78hUDn2yOFNvuUoxvQeQ5FbxFMQt3x2u
	lqt0Hyv8ew19nAJ1Y9jmN3/Hly4hDgEFNCuTSb7qXHSdYEXwQ/qAnZUpHhA46wNqpAFBK1N3hz1
	qNMrVdSlZqmxrt34+Y262oH/l+o5MqsM=
X-Gm-Gg: AR+sD119LsOrcvKLnZckqOiTlFkeBG8dXTlrNyi8vkXwa0s+KbzXuGVNprK4QqQO9RJ
	NyPZ/kVGnFp2m7HlM2afs4lZshgnssWB0sM3rMVzXBr03CXVz06q46XqiTaqgOu3Hq/HQMuSS7f
	tp6dyqhKc5Jo3k5n6Okg/bNMxLVLrt3Bwa/GpxHClj6JfCDdn5i8A3gGqpTNiopd7yoKUsIZYFw
	pzQvHbgvVgWMy4bu85tLI3t+26vsWiIMRtlwzzJvlr7vjxKJAZ9di0FtpvrcUfxYm4SOXv9FC+U
	GxxYhT6+4ET9zM3qnJ05L5r6j349k7uo3J8ojvOWBUeUmg==
X-Received: by 2002:a05:6a20:ae24:b0:3c0:9c19:65c2 with SMTP id
 adf61e73a8af0-3c92a993e49mr6048608637.74.1785666835428; Sun, 02 Aug 2026
 03:33:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260801-fix-rhashtable-bucket-lockdep-v1-1-15a0f8ae094c@gmail.com>
 <178558275123.3252194.11769833511956588358@noble.neil.brown.name>
In-Reply-To: <178558275123.3252194.11769833511956588358@noble.neil.brown.name>
From: Quanye Yang <quanyemostima@gmail.com>
Date: Sun, 2 Aug 2026 18:33:43 +0800
X-Gm-Features: AUfX_mzScXCub8PQVSZEdB0RKfRdK0g9n-j9xNzjP5UPQjT0pt7SQX2S5bKrM3Y
Message-ID: <CABcBDJuSd=tjfcQoDxVgRrYw0UKu0HPcWDC4H10uOmR8--fE2Q@mail.gmail.com>
Subject: Re: [PATCH] rhashtable: use per-init-site lockdep classes for bucket locks
To: NeilBrown <neil@brown.name>
Cc: Thomas Graf <tgraf@suug.ch>, Herbert Xu <herbert@gondor.apana.org.au>, 
	Andrew Morton <akpm@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot+ef8d17bae14efb960935@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Aug 01, 2026 at 07:12:00PM +0000, NeilBrown wrote:
> This seems like a band-aid rather than a proper fix.
>
> Surely attaching a BPF program to lock_release() has potential for
> causing all sorts of lockdep related problems.  Any lock that the BPF
> program takes can trigger something, and I find it unlikely that
> rhashtable is the only part of BPF code that takes a lock.
>
> Maybe the tracepoint needs to disable lockdep while the BPF handler is
> running, or something like that.
>
> But I would need a much stronger argument before I could be happy with
> this patch.

Thanks for the review.

I agree that attaching BPF to lock_release() is a sharp edge: the
tracepoint runs before __lock_release(), so the lock is still on the
lockdep held stack, and any lock taken by the BPF program becomes a
dependency edge.  Whether that instrumentation path should be isolated
from lockdep is a broader question, and I don't claim this patch solves
it.

But the syzbot warning at hand is not BPF-specific.  It is a false
positive from modeling every rhashtable bucket lock with one global
lock_class_key.  Different rhashtable instances have different physical
bitlocks; nesting them is not recursive locking of the same lock.

I can reproduce the same "possible recursive locking detected" without
any BPF / lock tracepoint:

  1. init two tables at distinct rhashtable_init() call sites (ht_a, ht_b)
  2. prefill so the insert path walks a non-empty bucket chain
  3. in ht_a's obj_cmpfn (called under ht_a's bucket bitlock), call
     rhashtable_lookup_insert_key() on ht_b

That is enough to hit the warning on an unpatched kernel.  So disabling
lockdep around the BPF handler would only silence one trigger for this
class-modeling bug; it would not fix the underlying incorrect lock class
sharing, and it would also hide real lock-order problems on that path
(including the callback-under-bucket-lock cases that 149212f07856 wanted
lockdep to see).

The per-init-site bucket key follows the same approach as 060d4e94b8d4
did for ht->mutex: keep one class per init site (and across resize of
that table via SINGLE_DEPTH_NESTING), rather than one class for the
entire kernel.

Happy to share the small local reproducer if that helps.

On Sat, Aug 1, 2026 at 7:12=E2=80=AFPM NeilBrown <neilb@ownmail.net> wrote:
>
> On Sat, 01 Aug 2026, quanyemostima@gmail.com wrote:
> > From: quanyeyang <quanyemostima@gmail.com>
> >
> > All bucket tables currently share a single lockdep class. This makes
> > lockdep conflate bucket locks from unrelated rhashtable instances.
> >
> > A BPF program attached to lock_release can expose this when pidfs
> > inserts a pid. The tracepoint runs before lockdep removes the pidfs
> > bucket lock from the task's held-lock stack. Deleting an element from
> > a BPF RHASH map then acquires a bucket lock belonging to a different
> > rhashtable. Since both tables use the same class, lockdep reports
> > possible recursive locking.
>
> This seems like a band-aid rather than a proper fix.
>
> Surely attaching a BPF program to lock_release() has potential for
> causing all sorts of lockdep related problems.  Any lock that the BPF
> program takes can trigger something, and I find it unlikely that
> rhashtable is the only part of BPF code that takes a lock.
>
> Maybe the tracepoint needs to disable lockdep while the BPF handler is
> running, or something like that.
>
> But I would need a much stronger argument before I could be happy with
> this patch.
>
> NeilBrown
>
>
> >
> > Declare a separate bucket lock class key at each rhashtable_init() and
> > rhltable_init() call site, alongside the mutex class key. Store the
> > bucket key in struct rhashtable so tables created during resize keep
> > using the same class.
> >
> > A targeted reproducer triggers the warning reliably before this change.
> > After the change, the nested BPF RHASH deletion still executes, but
> > lockdep no longer reports recursive locking.
> >
> > Fixes: 149212f07856 ("rhashtable: add lockdep tracking to bucket bit-sp=
in-locks.")
> > Reported-by: syzbot+ef8d17bae14efb960935@syzkaller.appspotmail.com
> > Closes: https://syzkaller.appspot.com/bug?extid=3Def8d17bae14efb960935
> > Assisted-by: Cursor:GPT-5.6 Sol
> > Signed-off-by: quanyeyang <quanyemostima@gmail.com>
> > ---
> >  include/linux/rhashtable-types.h | 20 ++++++++++++++------
> >  lib/rhashtable.c                 | 19 +++++++++++++------
> >  2 files changed, 27 insertions(+), 12 deletions(-)
> >
> > diff --git a/include/linux/rhashtable-types.h b/include/linux/rhashtabl=
e-types.h
> > index 57c11ec9dc64..4dea91a49ec8 100644
> > --- a/include/linux/rhashtable-types.h
> > +++ b/include/linux/rhashtable-types.h
> > @@ -82,6 +82,7 @@ struct rhashtable_params {
> >   * @mutex: Mutex to protect current/future table swapping
> >   * @lock: Spin lock to protect walker list
> >   * @nelems: Number of elements in table
> > + * @bucket_lock_key: Per-init-site lockdep class for bucket bit-locks
> >   */
> >  struct rhashtable {
> >       struct bucket_table __rcu       *tbl;
> > @@ -94,6 +95,7 @@ struct rhashtable {
> >       struct mutex                    mutex;
> >       spinlock_t                      lock;
> >       atomic_t                        nelems;
> > +     struct lock_class_key           *bucket_lock_key;
> >  #ifdef CONFIG_MEM_ALLOC_PROFILING
> >       struct alloc_tag                *alloc_tag;
> >  #endif
> > @@ -138,23 +140,29 @@ struct rhashtable_iter {
> >
> >  int __rhashtable_init_noprof(struct rhashtable *ht,
> >                   const struct rhashtable_params *params,
> > -                 struct lock_class_key *key);
> > +                 struct lock_class_key *mutex_key,
> > +                 struct lock_class_key *bucket_key);
> >  #define rhashtable_init_noprof(ht, params)                           \
> >  ({                                                                   \
> > -     static struct lock_class_key __key;                             \
> > +     static struct lock_class_key __mutex_key;                       \
> > +     static struct lock_class_key __bucket_key;                      \
> >                                                                       \
> > -     __rhashtable_init_noprof(ht, params, &__key);                   \
> > +     __rhashtable_init_noprof(ht, params, &__mutex_key,              \
> > +                              &__bucket_key);                        \
> >  })
> >  #define rhashtable_init(...) alloc_hooks(rhashtable_init_noprof(__VA_A=
RGS__))
> >
> >  int __rhltable_init_noprof(struct rhltable *hlt,
> >                 const struct rhashtable_params *params,
> > -               struct lock_class_key *key);
> > +               struct lock_class_key *mutex_key,
> > +               struct lock_class_key *bucket_key);
> >  #define rhltable_init_noprof(hlt, params)                            \
> >  ({                                                                   \
> > -     static struct lock_class_key __key;                             \
> > +     static struct lock_class_key __mutex_key;                       \
> > +     static struct lock_class_key __bucket_key;                      \
> >                                                                       \
> > -     __rhltable_init_noprof(hlt, params, &__key);                    \
> > +     __rhltable_init_noprof(hlt, params, &__mutex_key,               \
> > +                            &__bucket_key);                          \
> >  })
> >  #define rhltable_init(...)   alloc_hooks(rhltable_init_noprof(__VA_ARG=
S__))
> >
> > diff --git a/lib/rhashtable.c b/lib/rhashtable.c
> > index d459bef245f4..e047ad912f0e 100644
> > --- a/lib/rhashtable.c
> > +++ b/lib/rhashtable.c
> > @@ -189,7 +189,6 @@ static struct bucket_table *bucket_table_alloc(stru=
ct rhashtable *ht,
> >       struct bucket_table *tbl =3D NULL;
> >       size_t size;
> >       int i;
> > -     static struct lock_class_key __key;
> >
> >       tbl =3D alloc_hooks_tag(ht->alloc_tag,
> >                       kvmalloc_node_align_noprof(struct_size(tbl, bucke=
ts, nbuckets),
> > @@ -205,7 +204,12 @@ static struct bucket_table *bucket_table_alloc(str=
uct rhashtable *ht,
> >       if (tbl =3D=3D NULL)
> >               return NULL;
> >
> > -     lockdep_init_map(&tbl->dep_map, "rhashtable_bucket", &__key, 0);
> > +     /*
> > +      * Keep all bucket tables belonging to the same rhashtable in the
> > +      * per-init-site lock class, including tables created during resi=
ze.
> > +      */
> > +     lockdep_init_map(&tbl->dep_map, "rhashtable_bucket",
> > +                      ht->bucket_lock_key, 0);
> >
> >       tbl->size =3D size;
> >
> > @@ -1162,7 +1166,8 @@ static u32 rhashtable_jhash2(const void *key, u32=
 length, u32 seed)
> >   */
> >  int __rhashtable_init_noprof(struct rhashtable *ht,
> >                   const struct rhashtable_params *params,
> > -                 struct lock_class_key *key)
> > +                 struct lock_class_key *mutex_key,
> > +                 struct lock_class_key *bucket_key)
> >  {
> >       struct bucket_table *tbl;
> >       size_t size;
> > @@ -1172,7 +1177,8 @@ int __rhashtable_init_noprof(struct rhashtable *h=
t,
> >               return -EINVAL;
> >
> >       memset(ht, 0, sizeof(*ht));
> > -     mutex_init_with_key(&ht->mutex, key);
> > +     mutex_init_with_key(&ht->mutex, mutex_key);
> > +     ht->bucket_lock_key =3D bucket_key;
> >       spin_lock_init(&ht->lock);
> >       memcpy(&ht->p, params, sizeof(*params));
> >
> > @@ -1237,11 +1243,12 @@ EXPORT_SYMBOL_GPL(__rhashtable_init_noprof);
> >   */
> >  int __rhltable_init_noprof(struct rhltable *hlt,
> >                          const struct rhashtable_params *params,
> > -                        struct lock_class_key *key)
> > +                        struct lock_class_key *mutex_key,
> > +                        struct lock_class_key *bucket_key)
> >  {
> >       int err;
> >
> > -     err =3D __rhashtable_init_noprof(&hlt->ht, params, key);
> > +     err =3D __rhashtable_init_noprof(&hlt->ht, params, mutex_key, buc=
ket_key);
> >       hlt->ht.rhlist =3D true;
> >       return err;
> >  }
> >
> > ---
> > base-commit: 0131b508c0e2489eac6e121135988f6eeb716f19
> > change-id: 20260801-fix-rhashtable-bucket-lockdep-95e25abebeea
> >
> > Best regards,
> > --
> > quanyeyang <quanyemostima@gmail.com>
> >
> >
> >
> >
>
