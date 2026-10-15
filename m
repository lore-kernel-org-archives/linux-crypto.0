Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA8F13750CB
	for <linux-crypto@vger.kernel.org>; Thu, 15 Oct 2026 21:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792100945; cv=pass; b=gUP+7ZGe9v0GhYwPyyRVCU1txUBGxt9tvKCNwyuupoWkssl+kvNBd5tABO78lG8C5qonHBm+ayUyCU3xyNizglfJWVDcgZ76NKrEwfoIYkfJOdKdBpDbfpEq/eUvQTVg/Nlc042qY6Q8SdIWRGZMIBIy2Tk5xWgRKFFlBIR4lH0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792100945; c=relaxed/simple;
	bh=x3Z7gjnUSjhUxdXxOj+8VMf1kpKkUIZM8oPBYAHKrD8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UDzIhcCUuHEbYQuOS7UxvGy2ugykzsrcEAINC/h5HP2M9/yk/F8SZ8+WTSLmkKLWmNvkTChb4d8qmcPwfUMTke+1KpEDdPbyIRy8Fx6DjP8DqMNeOUT/2moQDtfA71703vxCM3gHshb67w8wHDLC6XGCTVDzuTadPdKEyRcuJPg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=crgG9fJ1; arc=pass smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="crgG9fJ1"
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-5bce4e278baso529230e87.0
        for <linux-crypto@vger.kernel.org>; Thu, 15 Oct 2026 14:49:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792100942; cv=none;
        d=google.com; s=arc-20260327;
        b=YaFZjUCTFJDH7IyMaJqavi+IV8AGMhFz13no/apQ2TfOE9FnJBJHbxYIoY3fPuskz+
         Z0RKRJzWkVHU/eb+vn8ngPWnb0DBuIOgaFR94MUlZfyzL1yV/PreC1c39R4+7tCVFAja
         FkjBHhS6m0nGQdllv423BefJteePK29jMyG3A6rBmuGnqXAsDryM9WTZRFe/BRmcB77a
         7Pwr7CBhL009pF5dAwiWnNSSMGfIIcFV+wWd5+dN2i3pzj2b6yZsZtoFB0oIXLBe/D2h
         hF61P2wHBDTj/xeaZLpDVKSSRqHWjIJlIdz6qBSTO3WPoYWHW7vDwd5pCKoQmm3U21+N
         0R8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=HVp7UPgTWIGd6YIMzy9YpX0cl7irx8Lhee7jk1JUl1I=;
        fh=XZyl+IeF1Y1cUrJzl0kRnykMlT3uEPVgJb2qaFRSjLA=;
        b=GN1jXEE+vTPP87rqMzcF79Wy1kSGgkLey4TuktHmkgGGlADCZ431dacpXPxJ+7JpvQ
         IG6AegnhYSI0lE0E7eNGMTrbhUXx3ZwgKyI3haNNAwCOlQDGWBLcJgicMXPxqYh66Xwo
         TZQqCYKrjYbNXFzW8W0aJEmGifLuWfDYhDPC1ZNiOfUVX4Tw9uFGr82mbPRnLnIc+toI
         CgJQZ7qME8kHpvc9koYK88unKqzLQr6yuLHLcRkmSdu5NeB4YnsWIHi2SVBdvPLpuBWJ
         a6McRyP57aGt6aMfa1aRqB+eh9RhPpY2wj6aa5+qOTE5qE+MWiz1SeaSHy29C5/15PQt
         q9Rg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792100942; x=1792705742; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=HVp7UPgTWIGd6YIMzy9YpX0cl7irx8Lhee7jk1JUl1I=;
        b=crgG9fJ1u+tkPMxeYmGsNJPmVcbrEk4+cM+QbN5iyitPiD2EqQcMJ1r5iF4aLXoGWz
         10k+3Fc+0gfCelgckba3eaaqu7AW/phwpyz4WYYh/poYC+VsAdOMqnbHPlpk4DE6jDCQ
         QF2IUdwgRG7FGhuZvhJ9tbylD9UjwWv8muJiL0CVqDYuox6VFQgVBbJ6aYH783GcMqdA
         p2ALU/INn50zHCxC8kZMjgAEYbeb2AS8hXxWhTHYRLsrSfJp7LPbOAEUb59+6o/dhsiI
         u06rgYUiLaFnRRdHta5sBPRfcdJ1b42ayUirapLRvRW7LKWo8G9oGG1gt+he8SBBRvSd
         K6mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792100942; x=1792705742;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HVp7UPgTWIGd6YIMzy9YpX0cl7irx8Lhee7jk1JUl1I=;
        b=UOSk7amwsgCNH9XPfDLRZXjUnbbRaaSMKcRiS0SzHHHzLWdJOQN7KSpY5XdqnKpTGc
         oTKwb5O7kSqckG6rQXZ45JjCJIOsfYfkwKMhB+xvOjcPM9UaKLIFcOrtUwsFzKyMDb6a
         iUo+D8fSj273YfsOGgORug6LDUG2xZl+xVciYwtpN3zF06WXi9FPQtR+rEtKVtTzLXd9
         ebW5QMYS/OVF2kgL/WiMxB8bZE1kcQHc4tZ32/E1wtOlJb0feB2HmHZ4FvvLTQzRxpyG
         nz3mP4g1YIo1Qxp5DwmsiPLc+EWDQ/thM/qfw038IUmsj+jhaQHsMfhvrLHDQcYdnyFD
         NUmQ==
X-Forwarded-Encrypted: i=1; AKwUvBxjPAMjlJpuQ2g8nmJZ6ghy9SiX2uuP/mNv/7La+MbapDMpsTv5cM4QqFpLaxliw1KOFdDqTcjNZPSP/xU=@vger.kernel.org
X-Gm-Message-State: AFq9FYJ7u7e238HiJMuyjmq1uAwMyuz2THvqCba99hpy8YyOikcZ5A+X
	Qe9r0wepFG78ctCWpqFG2W+pl2IVAddsjWCDnzng63mtubb5cC5PHc8G4Cbg9uTOQl6OEjMk+VN
	DU3TNzs9EK3wfY3/qujVTSie755DrLaDugAKS
X-Gm-Gg: AYBFou2ZKNTwgyoQdfoa+MAimVgu6585XLjJ8AQ8F8LXjSTa/vi8f0/KYpLCPbo6xuo
	/gRiUZxYrmz4q8TMaUhMvAmvMKOlHjnilS0o3AzqpnZm5DdWnCzbEk10kJqoyKGdeEmmR/r58jT
	1WTZnT3XIBqDrDwx6C9CtcBkRXAkXZ0AtQCuaxT6a73ZtANtPDJ2T5E8Gj7Fy1ouPjE3Q9npbpl
	pxRehc6nr5rlWyAmTDKKO9/Fj/E1RVJFjpNZHRYCW8D8m1HHSIQUuQfHwmui6yNloQ3pGJXWeIc
	shTrYwqhDYwr4C7ubyP7aRscEfWqiEt1XlWdSsMLyPBuy8gnTMoEYZU=
X-Received: by 2002:a05:6512:6c3:b0:5b6:10bc:dc44 with SMTP id
 2adb3069b0e04-5be47919a66mr371981e87.27.1792100941493; Thu, 15 Oct 2026
 14:49:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261008182814.27450-1-kanchanapsridhar2026@gmail.com>
 <20261008182814.27450-8-kanchanapsridhar2026@gmail.com> <as-izeIj5bP01bna@google.com>
In-Reply-To: <as-izeIj5bP01bna@google.com>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Thu, 15 Oct 2026 14:48:49 -0700
X-Gm-Features: AclHuK9kJdMeQIt5SjytQ3uY2AY9vgRZt5bGu_tW5kkaC9v8cX-axyE2p_KzZ08
Message-ID: <CACpmpof++tM9MUYgqgenwEBfaaJ60VsDwptK7Ne_-b+-DKMRZg@mail.gmail.com>
Subject: Re: [PATCH v1 7/8] mm: zswap: Optimally place members of struct
 zswap_pool, struct zswap_entry.
To: Yosry Ahmed <yosry@kernel.org>
Cc: hannes@cmpxchg.org, nphamcs@gmail.com, chengming.zhou@linux.dev, 
	akpm@linux-foundation.org, linux-mm@kvack.org, herbert@gondor.apana.org.au, 
	davem@davemloft.net, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, rientjes@google.com, willy@infradead.org, 
	senozhatsky@chromium.org, 
	"Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 14, 2026 at 8:43=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> wrot=
e:
>
> On Thu, Oct 08, 2026 at 11:28:13AM -0700, Kanchana P. Sridhar wrote:
> > Place and align the members of struct zswap_pool and struct zswap_entry
> > such that members used together in compress/decompress hot paths are
> > able to share the same cacheline. Minimize holes within these structs
> > while doing so.
> >
> > Signed-off-by: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>
> > ---
> >  mm/zswap.c | 10 +++++-----
> >  1 file changed, 5 insertions(+), 5 deletions(-)
> >
> > diff --git a/mm/zswap.c b/mm/zswap.c
> > index 8ae67fd10522..ade84ac4076e 100644
> > --- a/mm/zswap.c
> > +++ b/mm/zswap.c
> > @@ -160,11 +160,11 @@ struct crypto_acomp_ctx {
> >  struct zswap_pool {
> >       struct zs_pool *zs_pool;
> >       struct crypto_acomp_ctx __percpu *acomp_ctx;
> > -     u8 compr_batch_size;
> >       struct percpu_ref ref;
> > -     struct rcu_work release_rwork;
> > -     struct hlist_node node;
> >       u8 idx;
> > +     u8 compr_batch_size;
> > +     struct hlist_node node;
> > +     struct rcu_work release_rwork;
>
> compr_batch_size is added by this series, why not just add it before idx
> to begin with?

In patch 0006, where compr_batch_size is introduced, I was attempting
to place it in the same cacheline as the acomp_ctx. This increased the
size of struct zswap_pool to 248 bytes. I later optimized this in
patch 0007, bringing back the size to 240 with the addition of
compr_batch_size.

As things stand:

Baseline mm-unstable:

struct zswap_pool {
        struct zs_pool *           zs_pool;              /*     0     8 */
        struct crypto_acomp_ctx *  acomp_ctx;            /*     8     8 */
        struct percpu_ref          ref;                  /*    16    16 */
        struct rcu_work            release_rwork
__attribute__((__aligned__(8))); /*    32    56 */
        /* --- cacheline 1 boundary (64 bytes) was 24 bytes ago --- */
        struct hlist_node          node;                 /*    88    16 */
        u8                         idx;                  /*   104     1 */
        char                       tfm_name[128];        /*   105   128 */

        /* size: 240, cachelines: 4, members: 7 */
        /* padding: 7 */
        /* forced alignments: 1 */
        /* last cacheline: 48 bytes */
} __attribute__((__aligned__(8)));

My latest version makes changes to struct zswap_pool in 2 separate
patches: the first introduces compr_batch_size without changing the
size, the second optimizes for hot-path members' co-location on the
same cacheline:

struct zswap_pool {
  struct zs_pool *zs_pool;
  struct crypto_acomp_ctx __percpu *acomp_ctx;
  struct percpu_ref ref;
  u8 idx;
  u8 compr_batch_size;
  struct hlist_node node;
  struct rcu_work release_rwork;
  char tfm_name[CRYPTO_MAX_ALG_NAME];
};

struct zswap_pool {
        struct zs_pool *           zs_pool;              /*     0     8 */
        struct crypto_acomp_ctx *  acomp_ctx;            /*     8     8 */
        struct percpu_ref          ref;                  /*    16    16 */
        u8                         idx;                  /*    32     1 */
        u8                         compr_batch_size;     /*    33     1 */

        /* XXX 6 bytes hole, try to pack */

        struct hlist_node          node;                 /*    40    16 */
        struct rcu_work            release_rwork
__attribute__((__aligned__(8))); /*    56    56 */
        /* --- cacheline 1 boundary (64 bytes) was 48 bytes ago --- */
        char                       tfm_name[128];        /*   112   128 */

        /* size: 240, cachelines: 4, members: 8 */
        /* sum members: 234, holes: 1, sum holes: 6 */
        /* forced alignments: 1 */
        /* last cacheline: 48 bytes */
} __attribute__((__aligned__(8)));

>
> >       char tfm_name[CRYPTO_MAX_ALG_NAME];
> >  };
> >
> > @@ -202,10 +202,10 @@ static struct shrinker *zswap_shrinker;
> >   *              logic if referenced is unset. See comments in the shri=
nker
> >   *              section for context.
> >   * nid - NUMA node id of the page for which this is the zswap entry.
> > - * pool_idx - id of the zswap_pool that the entry's data is in.
> >   * handle - zsmalloc allocation handle that stores the compressed page=
 data
> >   * objcg - the obj_cgroup that the compressed memory is charged to
> >   * lru - handle to the pool's lru used to evict pages.
> > + * pool_idx - id of the zswap_pool that the entry's data is in.
> >   */
> >  struct zswap_entry {
> >       swp_entry_t swpentry;
> > @@ -214,10 +214,10 @@ struct zswap_entry {
> >               bool referenced:1;
> >       };
> >       int nid;
> > -     u8 pool_idx;
> >       unsigned long handle;
> >       struct obj_cgroup *objcg;
> >       struct list_head lru;
> > +     u8 pool_idx;
>
> As mentioned previously, this needs to be packed with the length.

Done.

>
> >  };
> >
> >  /*
> > --
> > 2.39.5
> >
