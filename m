Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 434E449A3A5
	for <linux-crypto@vger.kernel.org>; Thu, 15 Oct 2026 22:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792101984; cv=none; b=kY3HRifJHW1Yn8C09kU8BY9dsOWsHV9lybjtIZma2Q+4NkehuuiikiuL47xJjcnXJmiOquFjeBYNt25FtXvMn4kYqS8MWrhyG64lA3AFI6lLU670pcCMr8lcZvz+lMgSsT1vRIYGYbE5/1wZ1vCAGysYoUwVB8Gq7yD50/DozM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792101984; c=relaxed/simple;
	bh=nrAOSkpfvvC53d8wyV+4GEFbopuHgXUDky8Zx5ZxtII=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AoDlHZigcjzz9KGWkBeypzKluWDwVxuvzlGRVbVhuO2M8N7zmp5ULmVJBJDw3R/m8/zQaAu8HbosZV2uToHlaYNryvsOzq0zSr0NYUg1gjysynDBLdjrU8n3uAeP4UqhC0xmLD06+itOqZxEHYY8xk5bqVz1eV2VjjHWrqO3UvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=itmch/aA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="itmch/aA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCCE51F000C7
	for <linux-crypto@vger.kernel.org>; Thu, 15 Oct 2026 22:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792101982;
	bh=mJbsb6dU/XznSRrcG1GSuxTRuvW4/61fnYkUcg+ByiM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=itmch/aArHNeBR/ur+BnCI+m882cF1KxHAM9x0OT8uMYRvdLvVM1x0/qIeS151x5L
	 Fyoo6cz7VRpbhDZKe915EUj0SEQmP9ybIJeRc0PFePcvDsOkr9Vp4CPO3d1xGYscXF
	 dbfazzin059JqRPz3VadX8oAMj3XjSxudqglgs1/2e6P8WvVvJUi1DsKmNkiwdEjty
	 NEouf7vKm/ktaNHDjyjQ3SOVQcRcHQ8iW/KPBaddWhbyemcvbzDeVFV419KEhJ1KeS
	 M8ntuHWI6hkqyNPOCcAOVXFVhrJO4TJWxjMZt75aEm0U7ve0+2/aJE4ClWgWI3zSip
	 MKTC1HRN8MPYQ==
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c2e8c710847so728151766b.0
        for <linux-crypto@vger.kernel.org>; Thu, 15 Oct 2026 15:06:22 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxZakXrk3FLfMoMumm+/M/bqhgz1H8AvqKwRmEewqeI2LB6ZrhSGXJZNAt3PLRDZ9VHXgnZFXhq4vtS5h0=@vger.kernel.org
X-Gm-Message-State: AFq9FYJkiU4NX8aUvvPbNEfiDE/ix37kvBjRz1CHC+oBu1sYvL1kuAFL
	Vwg2uxIvVBIMMOvGKk7cE7TuBfH+iztSd9V2YnmfWPiexiEpU53lvQ1qeIixbMi+XLQ6sOo8zfQ
	HGQHm17eaVOpitNsZ0cy1UGljVHmyyYE=
X-Received: by 2002:a17:907:8692:b0:c2e:2720:8f68 with SMTP id
 a640c23a62f3a-c31aa01b41fmr1817223366b.46.1792101981739; Thu, 15 Oct 2026
 15:06:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261008182814.27450-1-kanchanapsridhar2026@gmail.com>
 <20261008182814.27450-8-kanchanapsridhar2026@gmail.com> <as-izeIj5bP01bna@google.com>
 <CACpmpof++tM9MUYgqgenwEBfaaJ60VsDwptK7Ne_-b+-DKMRZg@mail.gmail.com>
In-Reply-To: <CACpmpof++tM9MUYgqgenwEBfaaJ60VsDwptK7Ne_-b+-DKMRZg@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Thu, 15 Oct 2026 15:06:09 -0700
X-Gmail-Original-Message-ID: <CAO9r8zPpmLyMHF+yDb2ZHRmSdAHFTNvsu8PZsQ2Z-EVvF-dc3g@mail.gmail.com>
X-Gm-Features: AclHuK-S4zsk6EqmhjsVui6ifjRKos1ouVvuuztrm3peIKBuRi4LD8-5u9AW2Mg
Message-ID: <CAO9r8zPpmLyMHF+yDb2ZHRmSdAHFTNvsu8PZsQ2Z-EVvF-dc3g@mail.gmail.com>
Subject: Re: [PATCH v1 7/8] mm: zswap: Optimally place members of struct
 zswap_pool, struct zswap_entry.
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Cc: hannes@cmpxchg.org, nphamcs@gmail.com, chengming.zhou@linux.dev, 
	akpm@linux-foundation.org, linux-mm@kvack.org, herbert@gondor.apana.org.au, 
	davem@davemloft.net, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, rientjes@google.com, willy@infradead.org, 
	senozhatsky@chromium.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 15, 2026 at 2:49=E2=80=AFPM Kanchana P. Sridhar
<kanchanapsridhar2026@gmail.com> wrote:
>
> On Wed, Oct 14, 2026 at 8:43=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> wr=
ote:
> >
> > On Thu, Oct 08, 2026 at 11:28:13AM -0700, Kanchana P. Sridhar wrote:
> > > Place and align the members of struct zswap_pool and struct zswap_ent=
ry
> > > such that members used together in compress/decompress hot paths are
> > > able to share the same cacheline. Minimize holes within these structs
> > > while doing so.
> > >
> > > Signed-off-by: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>
> > > ---
> > >  mm/zswap.c | 10 +++++-----
> > >  1 file changed, 5 insertions(+), 5 deletions(-)
> > >
> > > diff --git a/mm/zswap.c b/mm/zswap.c
> > > index 8ae67fd10522..ade84ac4076e 100644
> > > --- a/mm/zswap.c
> > > +++ b/mm/zswap.c
> > > @@ -160,11 +160,11 @@ struct crypto_acomp_ctx {
> > >  struct zswap_pool {
> > >       struct zs_pool *zs_pool;
> > >       struct crypto_acomp_ctx __percpu *acomp_ctx;
> > > -     u8 compr_batch_size;
> > >       struct percpu_ref ref;
> > > -     struct rcu_work release_rwork;
> > > -     struct hlist_node node;
> > >       u8 idx;
> > > +     u8 compr_batch_size;
> > > +     struct hlist_node node;
> > > +     struct rcu_work release_rwork;
> >
> > compr_batch_size is added by this series, why not just add it before id=
x
> > to begin with?
>
> In patch 0006, where compr_batch_size is introduced, I was attempting
> to place it in the same cacheline as the acomp_ctx. This increased the
> size of struct zswap_pool to 248 bytes. I later optimized this in
> patch 0007, bringing back the size to 240 with the addition of
> compr_batch_size.

This doesn't make much sense, and the size of zswap_pool is not that
important (usually only one globally). I would drop the patch and add
compr_batch_size directly where it needs to end up.
