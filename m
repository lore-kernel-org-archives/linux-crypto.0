Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792696564;
	b=JcfL8X82PW1VC4rlRENdzWPpZh84Qrpo73lNHS+iHXFc4Eisvnkhd6CVDjnpzo5DEXGz
	 VG08afT816cLx0kCoZXLIFqiy5tZxDCwm3JcUyfQ35YWLDN9REZO6aZXuihTE4WYh+vQw
	 CPFMYCxyQH0J6QALfaLtZ+STEPCb67a1rEX/GRc9XeagBwyRlj+OJj992WWrFLKEA/gUH
	 R1J0bouaa6EXR/XFRCHykE1ve5a5KGr81Th7d7pbWHWrtZFx4qp6oE3n6Sjr6xK4MT1eZ
	 2141kVjXMeAq35hC7ss55XOxjO7GdY8kbZhN/5lWi/RhuJqPcfqyMl/aZgIzM5KA4MA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792696564;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=aXEotVyVHJYDPptgK6vNC0rI1V41OJrJxrbuxV/+QY4=;
	b=3A5FHac7CgkXG3TA67IRt0qiADueF/e/mxjTvs++0d3bpePulPUIUFK7iWDQkLqYEoTa
	 ATd+A/c4Pgr2qSw/UsyqSSmwqM215TM9GulzK8xq2tfU7mdO4fpeqzqMmzHA4vJ6fMxVQ
	 /W6tZbg+Dozggn/HHOC+bQroqRFgkxcNS8a3FhXlIMydDguWwOXEWRCdbbRQuodW5V5jT
	 8U/Pk5WCaSCCT3d8lGASL+BFGLg0LOA3zKqCovJvD60axFk95Ny1l4PXpUOQiLfcZNWAL
	 6MbeU5OnFMgRqs2ON7JEvcTh7S5WoouF2oV6kmzt8sRg6rfXF8+Y4AskJPPsk31zq5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ggZEktIu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFA66606A331
	for <linux-crypto@vger.kernel.org>; Thu, 22 Oct 2026 19:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ggZEktIu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7460E1F031ED
	for <linux-crypto@vger.kernel.org>; Thu, 22 Oct 2026 19:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792696563;
	bh=aXEotVyVHJYDPptgK6vNC0rI1V41OJrJxrbuxV/+QY4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=ggZEktIu+eC0ocrsZZXiVHxUntX/tF/RiCECaz1exsAYChneQQq5R9Zw1zHCAZ+Ny
	 46dYopslFW4D4BIJ86ovTrPhIEApOeoKUDyI44l7UbPdKSYK6V6zQyS4VaIlbL3W5m
	 KufrO3ZTfHynnu+DYQqKa6UE3P4tfmww1BG43u+EJ8Uwnx3ox8YxyuKhJErLEXA5gl
	 8RoevceTnFtiiTYiPn3gEVGVrjIvdWVXpERr23iLocMiOU0P0+UqSTRrW08U+Immcg
	 ygmko5cwJXvek8zOVUHeeZTPLXrzeKV7yr4gLgyiqmszdV5OX4yWp1A4A5k+SjSn1n
	 ZHxmsFIw0hxLw==
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-6b1a86c0316so122285a12.0
        for <linux-crypto@vger.kernel.org>; Thu, 22 Oct 2026 12:16:03 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzzORPWUTHRCws6djuaXH+I0H3F7ye3J05D3Ni8JRlLwiZOxFPSkjWEWOUvKFsLIp+BFLowDgFF/XNxmtc=@vger.kernel.org
X-Gm-Message-State: AFq9FYLqHkP5v4HDKbGldcMF/6A2TKb71x4waCCiTmtsIAkzfehOIkTf
	NXgoR6MAFvMpWwbzqrmbJwzb5yp/IboxN0t092UJxlrAh8OTIjSVXe3GepAlUU8ZOz0dMdxU4od
	g0wtp7ud9FSiGzuf/tnm3uqOG6FnOrDU=
X-Received: by 2002:a17:907:9c06:b0:c3e:34fa:611d with SMTP id
 a640c23a62f3a-c46a93f0638mr14493466b.35.1792696562242; Thu, 22 Oct 2026
 12:16:02 -0700 (PDT)
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261021205626.3286270-1-suseendranb@google.com>
 <20261021205626.3286270-3-suseendranb@google.com> <CAO9r8zNtuN=_BTV53oHqaTqE0Bo2qiDSrgTBzEZo5oyOnWyeYA@mail.gmail.com>
 <20261022155144.4177200-1-suseendranb@google.com> <CAO9r8zP+GUE-hcGWSGzhLNLcchFoZ38EMVCAtX5yZ78tZ0bbgA@mail.gmail.com>
 <20261022183319.163484-1-suseendranb@google.com>
In-Reply-To: <20261022183319.163484-1-suseendranb@google.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Thu, 22 Oct 2026 12:15:51 -0700
X-Gmail-Original-Message-ID: <CAO9r8zN6hN4h5m9pg4xQpirJj3o2nhGx5dxAuSddZ8+UenYnMg@mail.gmail.com>
X-Gm-Features: AclHuK_hJDFj0vZeNwHlzwbNEbCyCqR7zIQWw8UnwCHO6c8KrbK1Hg29ZhvDHe4
Message-ID: <CAO9r8zN6hN4h5m9pg4xQpirJj3o2nhGx5dxAuSddZ8+UenYnMg@mail.gmail.com>
Subject: Re: [PATCH 2/2] mm/zswap: classify compression dst overflow as poor compression
To: Suseendran Bhaskaran <suseendranb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S . Miller" <davem@davemloft.net>, Johannes Weiner <hannes@cmpxchg.org>, Nhat Pham <nphamcs@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Nick Terrell <terrelln@fb.com>, 
	David Sterba <dsterba@suse.com>, SJ Park <sj@kernel.org>, Chris Li <chrisl@kernel.org>, 
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>, 
	Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>, linux-crypto@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 22, 2026 at 11:33=E2=80=AFAM Suseendran Bhaskaran
<suseendranb@google.com> wrote:
>
> On Thu, Oct 22, 2026 at 09:01:02AM -0700, Yosry Ahmed wrote:
> > On Thu, Oct 22, 2026 at 8:51 AM Suseendran Bhaskaran
> > <suseendranb@google.com> wrote:
> [...]
> > > With that unchanged, existing zswap_compress() already accounts -ENOS=
PC
> > > vs other error codes when writeback is disabled, except for the
> > > !comp_ret && dlen >=3D PAGE_SIZE case mentioned above:
> >
> > Is this actually possible? When we changed the buffer size to
> > PAGE_SIZE, I thought we made sure all compressors wouldn't write
> > beyond the buffer size. dlen > PAGE_SIZE means buffer overflow, which
> > is a bigger problem than debugfs stats. Or maybe compressors can set
> > dlen > PAGE_SIZE but won't actually write to the buffer? I didn't
> > check.
>
> dlen > PAGE_SIZE isn't possible, since all compressors bound their
> output by the input req->dlen (PAGE_SIZE) as you mentioned, and only
> set req->dlen <=3D PAGE_SIZE. The 'dlen >=3D PAGE_SIZE' check in commit
> dca4437a5861 ("mm/zswap: store <PAGE_SIZE compression failed page
> as-is") was written when the buffer was still 2 * PAGE_SIZE prior to
> commit 0b1bf60c324a ("mm/zswap: reduce the size of the compression
> buffer to a single page").
>
> > As for the (!comp_ret && dlen =3D=3D PAGE_SIZE) case specifically, yeah=
 we
> > should probably use -ENOSPC to count it as poor compression.
>
> Ack.
>
> > The compt_ret and dlen checks are not super intuitive tbh, I wonder
> > how they should relate. What is the expected value of dlen if comp_ret
> > is an error? Is it always 0, or can the compressor set it as a
> > non-zero value if compression fails?
>
> On error (comp_ret !=3D 0), dlen is not guaranteed to be 0. The value
> left in dlen depends on the compressor used. For example:
> - zstd, 842, and qat set dlen =3D 0 on error.
> - lz4, lz4hc, lzo, lzo-rle (via scomp_acomp_comp_decomp()), deflate,
>   and iaa return the error code without modifying dlen, so dlen
>   remains at its input value (PAGE_SIZE).
> - hisi_zip sets dlen to the hardware-reported produced bytes even
>   on error.
>
> So dlen is only meaningful when !comp_ret. The !dlen check was
> added in commit dca4437a5861 ("mm/zswap: store <PAGE_SIZE
> compression failed page as-is") as a defensive check for the case when
> comp_ret is 0 with 0 dlen which shouldn't happen unless the compressor
> is faulty.
>
> > >
> > > -                       comp_ret =3D comp_ret ? comp_ret : -EINVAL;
> > > +                       comp_ret =3D comp_ret ? comp_ret :
> > > +                                  (dlen >=3D PAGE_SIZE ? -ENOSPC : -=
EINVAL);
> > >
> > > Would you prefer that I narrow Patch 2 to just that change in v2, or =
drop
> > > Patch 2 and only send Patch 1?
> >
> > Let's figure out what needs to be done for patch 2 first, if anything.
>
> Since dlen is only valid when !comp_ret, we could normalize comp_ret
> first when !comp_ret and then just check 'if (comp_ret)':
>
> diff --git a/mm/zswap.c b/mm/zswap.c
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -874,19 +874,24 @@ static bool zswap_compress(struct page *page, struc=
t zswap_entry *entry,
>          */
>         comp_ret =3D crypto_wait_req(crypto_acomp_compress(acomp_ctx->req=
), &acomp_ctx->wait);
>         dlen =3D acomp_ctx->req->dlen;
> +       if (!comp_ret) {
> +               if (dlen =3D=3D PAGE_SIZE)
> +                       comp_ret =3D -ENOSPC;
> +               else if (WARN_ON_ONCE(!dlen || dlen > PAGE_SIZE))
> +                       comp_ret =3D -EINVAL;
> +       }
>
>         /*
>          * If a page cannot be compressed into a size smaller than PAGE_S=
IZE,
>          * save the content as is without a compression, to keep the LRU =
order
>          * of writebacks.  If writeback is disabled, reject the page sinc=
e it
>          * only adds metadata overhead.  swap_writeout() will put the pag=
e back
>          * to the active LRU list in the case.
>          */
> -       if (comp_ret || !dlen || dlen >=3D PAGE_SIZE) {
> +       if (comp_ret) {
>                 rcu_read_lock();
>                 if (!mem_cgroup_zswap_writeback_enabled(
>                                         folio_memcg(page_folio(page)))) {
>                         rcu_read_unlock();
> -                       comp_ret =3D comp_ret ? comp_ret : -EINVAL;
>                         goto unlock;
>                 }
>
> Does this look good to you?

Yes. I assume this is completely independent from patch 1, so we can
tell Herbert to pick up patch 1 and send this separately?
