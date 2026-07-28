Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EB543B992C
	for <linux-crypto@vger.kernel.org>; Tue, 28 Jul 2026 22:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785276931; cv=none; b=RqZkIvc2jAV5v6H/yPWsuoBxT1UaqrUdcyGnB5wiamoJfx0EHPOwzkYXr3mj8hbNeRcA0RfskKPkKLvoJczK0uxUyv+iqAJXTtHq+WwNqrXJ+41BpNjFQzSJJwbULIzCFQhoQXcoR+doqc2MciyAgvN5Anr4hdfwCt4c8PoDyIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785276931; c=relaxed/simple;
	bh=uw4bZwIrdj1YjP68vDijy/T0UHOqNdWcEQwgihwnrig=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nOJV1/3ezIHu1aH8P6/O5A49v1LUKYrmi9roD2EmKVVXBTzUsRKJAU8C9fSlTIrIwW0tMq124rmwvyjo9mSKUbfPiLZnWrbRyVH8IuoXQA2YlqZnqTIHwcWCJppdra9FwpCZK+5J6/vKiQfW8gBXSCV5e5dbwzviCaHw6jCEzMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FHdDLyUn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FHdDLyUn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E67C91F00AC4
	for <linux-crypto@vger.kernel.org>; Tue, 28 Jul 2026 22:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785276929;
	bh=N0eBsWs0q2P0UZ8e/AAn7CCfkvDk0gaFdW1LovMU5z8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=FHdDLyUnpBx9xVs0uH8TISrHwXE28GtpuQpbF+m429jPUHSHC24nwLMjfMhny4nOi
	 3VPUKUuEND8Q1HsXLrrhrsK1ygFHcYMlvx2UDhdj2gu98WWMGOc2VKEFbBc2TmXzSR
	 TL6yiCwcrIBo1NGs9aSbUQw8BMkpVNcoQCFwPiYjqWFQOabtCt2Q71KAokADm0/cOM
	 9zj37Ve6ZtYQTHUzPWg67oR5Togg05xCzqAXgc5q2XOGaQooqZQyvWenloWFDHlk++
	 H+k6bhOv8lv56BzTPbx8+0XWZWVxXZOMmFD7J+tzLAmY5AIm2kml4RNXWHuUkIKC1u
	 jW0/N/X1uXrGg==
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c15cd3fd760so37471766b.2
        for <linux-crypto@vger.kernel.org>; Tue, 28 Jul 2026 15:15:29 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RrxRAYDEjM8PDMTkCLGCjK1qbZ312JpIyiYF/Pz3H/qxkS+ViyMoAuIaf7wpLZ1ZY1YxmFwPDJhaFf8yxw=@vger.kernel.org
X-Gm-Message-State: AOJu0YzgLTBgfg2A9Etn6mo5LymNiY22FRIZ1BGapz79jdSX4fYRczOk
	R9daPxcG9Ef74+vIg+s6/7taVOAnIvcVPtFz8aIzRWwhUN5KBH6ejhd6iYOPShro5ywJPWGPGOG
	ep8T6sjmdMlMBoV3pCT6r5EWohpnkmGQ=
X-Received: by 2002:a17:907:7a8e:b0:c12:6632:e7f0 with SMTP id
 a640c23a62f3a-c1f7215c7e3mr220028066b.24.1785276928806; Tue, 28 Jul 2026
 15:15:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260125033537.334628-27-kanchana.p.sridhar@intel.com> <tencent_381E310D1F05DE327C2607824BFCDCFA1806@qq.com>
In-Reply-To: <tencent_381E310D1F05DE327C2607824BFCDCFA1806@qq.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Tue, 28 Jul 2026 15:15:16 -0700
X-Gmail-Original-Message-ID: <CAO9r8zNbf9as6ecW=ktGu21PZbixpUwADpYTQ9Z4sCp8cufX8Q@mail.gmail.com>
X-Gm-Features: AUfX_mxmAAF2OnOz1425OOiRR8ewIViwu-1NOZWKO3MtBqR-1IxZUGx5IgblJqE
Message-ID: <CAO9r8zNbf9as6ecW=ktGu21PZbixpUwADpYTQ9Z4sCp8cufX8Q@mail.gmail.com>
Subject: Re: [PATCH v14 26/26] mm: zswap: Batched zswap_compress() for
 compress batching of large folios.
To: He Jixin <1270243756@qq.com>
Cc: kanchana.p.sridhar@intel.com, 21cnbao@gmail.com, akpm@linux-foundation.org, 
	ardb@kernel.org, chengming.zhou@linux.dev, clabbe@baylibre.com, 
	davem@davemloft.net, ebiggers@google.com, giovanni.cabiddu@intel.com, 
	hannes@cmpxchg.org, herbert@gondor.apana.org.au, kasong@tencent.com, 
	kristen.c.accardi@intel.com, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, nphamcs@gmail.com, 
	ryan.roberts@arm.com, senozhatsky@chromium.org, sj@kernel.org, 
	surenb@google.com, usamaarif642@gmail.com, vinicius.gomes@intel.com, 
	wajdi.k.feghali@intel.com, ying.huang@linux.alibaba.com, 
	yosry.ahmed@linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 27, 2026 at 8:05=E2=80=AFPM He Jixin <1270243756@qq.com> wrote:
>
> On Sat, 24 Jan 2026 19:35:37 -0800, Kanchana P Sridhar wrote:
> > +                        if (dlen < 0) {
> > +                                dlen =3D PAGE_SIZE;
> > +                                dst =3D kmap_local_page(folio_page(fol=
io,
> > +                                                      folio_start + ba=
tch_iter));
> > +                        }
> > +
> > +                        handle =3D zs_malloc(zs_pool, dlen, gfp, nid);
> > +
> > +                        if (unlikely(IS_ERR_VALUE(handle))) {
> > +                                if (PTR_ERR((void *)handle) =3D=3D -EN=
OSPC)
> > +                                        zswap_reject_compress_poor++;
> > +                                else
> > +                                        zswap_reject_alloc_fail++;
> > +
> > +                                goto err_unlock;
> > +                        }
> > ...
> > +err_unlock:
> >          mutex_unlock(&acomp_ctx->mutex);
> > -        return comp_ret =3D=3D 0 && alloc_ret =3D=3D 0;
> > +        return false;
>
> I think there might be a resource leak when both conditions below happen:
>
> 1. `dlen < 0` enters the first if block and does `kmap_local_page()` into=
 `dst`
> 2. Then `zs_malloc()` fails, hitting the `IS_ERR_VALUE(handle)` path and =
jumping to `err_unlock`
>
> In this path, `dst` points to a kmapped page that does not appear to get =
`kunmap_local()` before `err_unlock`.
> The old code had a `mapped` flag and a common unlock path, so kunmap_loca=
l() was called on all exits after kmap_local_page().
> After the batching rewrite, the successful path still unmaps `dst`, but t=
he zs_malloc() failure path appears to bypass that cleanup.
>
> If my understanding is correct, the fix could be either:
>
> - Option A: Add `kunmap_local(dst)` right before `goto err_unlock` when `=
dlen < 0` was taken.
> - Option B: Restructure so that `kmap_local_page()` happens after `zs_mal=
loc()` succeeds, only for the compression-failed entries.
>
> I'm new to the mm subsystem, so please let me know if I missed something =
that makes this safe.

I think we are indeed missing kunmap_local() in that cleanup path.
Unfortunately, there hasn't been much progress on this patch series
recently, I don't think we'll see a new version soon :/
