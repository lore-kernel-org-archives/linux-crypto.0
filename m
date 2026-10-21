Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792619279;
	b=VoQHT9te7NfK4kacL8dpduUAklKfOjxZoxfdWzylDkG3qHNfEKZxhi/TPPB9Xy+PEYBZ
	 J5aLUQMTjzVizDFte2V5rfbnDC0DhW3XpstAv0AGrmA4Vi5/AG3LXdahGwihhJf1QW6oX
	 6984QyHoiMHO347DMq93oE3TcLlIRxdQGS/Fh7hjeGyZRsdKB1uEFNFBHjtzQwoALTM/Z
	 NnIUmLsdEzXnM1432v4XxnIcZrWbAgYNXLmkHOHPc/lPZRtFX3rgotFz3tA1i6BXbqd/z
	 mXCB0CLedYaEzajt4LqLS4focc0heBlibgEjwEaJeh6SMQ130UiXHS81Vkq+ht96tbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792619279;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=lNlfmBmtfiESOniOkWbpwP2+Kbv356q2HSZrSlUKiAI=;
	b=nNqACd18wfRGBQalOLXkaR4qnzbRppigMMmIwKHTdN3KXGHln5E5Ao51xoPCZDw1kM5u
	 mrLLxQB3Q+pJ8XbkywnUpM8D6FP2KQy3/QuqSQJlZ7ws/NdY62PJdsi7TMugQGlOQLJ8C
	 nRAycQdnz3tcTGFkqeBsaomn1w8o/SKdC6mOWuHs3IUHHcvw0XMQVIGhkovvEeGUd0qCW
	 n72H94WidG30rht4wFsDbZmLCS/rcbJ8BHWDWZebDdoQBuwGrxnvuaR3qUit6seOBffY6
	 xe+35OCj+ZquoMPFPo2g6AIUltoZdgY/ptE90jtZZ8X6LOdfybPqJ2WDILtRnTRO8Sw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EReoPclS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B496606A31D
	for <linux-crypto@vger.kernel.org>; Wed, 21 Oct 2026 21:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EReoPclS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E3A81F000C9
	for <linux-crypto@vger.kernel.org>; Wed, 21 Oct 2026 21:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792619279;
	bh=lNlfmBmtfiESOniOkWbpwP2+Kbv356q2HSZrSlUKiAI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=EReoPclS6CGlBuqPgcg18O5SMm3/5LhGzjWMr6HSGDtx4kfjBAAnYXMpGDcL/OreR
	 O/CXbo9BVRGQTpBiJtTktJhZ64QXVsP2XWUjq1xN7okV7FdWm4gJUc5P+CMlZldkdO
	 OkxVk+07qGBPF6Tbwe8dJ+ID1E9kb8eToCOvAES40Tu9+yumt5dcz5h+3s2KNngjlq
	 tHL1rLFAbWABCd2KvIpvlu2veqGIdoQ1q9Hg/MvQWPV38nT1iSkN7IvHb7QZuEWh7y
	 GFYIwPbiqAvuAl0oahBTBS6gv4qEE6UqbxArSiwa44c2/eUTlXkalQHQKTh3Jv+ZWS
	 20X3q5oYDj7jw==
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c40f29667e6so191938766b.0
        for <linux-crypto@vger.kernel.org>; Wed, 21 Oct 2026 14:47:59 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzAPABOrjeiVJd7zyXLlGnQ/MT65ckRNvXEPIY8s95sEQhjTG+pOuWpSVT7KdowsfEfkjnDllxaInywpu4=@vger.kernel.org
X-Gm-Message-State: AFq9FYK5pTArpAxTHT8SfiZ432UCm2S5ScWWbjTjEMXyo7o2U3Cn6Ezs
	ZtR/XGRsVngOk67oYj3gZxxiVSdNlWe6Khv7gqHHiwlc6WAmpP5i1+MMu/KGVd1y6MXJ0ggaJuE
	d4H6+GFTw3g5O1pl3vOFEO+RuFaiijTw=
X-Received: by 2002:a17:907:9608:b0:c28:599b:7782 with SMTP id
 a640c23a62f3a-c467959800cmr282913866b.21.1792619278019; Wed, 21 Oct 2026
 14:47:58 -0700 (PDT)
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261021205626.3286270-1-suseendranb@google.com> <20261021205626.3286270-3-suseendranb@google.com>
In-Reply-To: <20261021205626.3286270-3-suseendranb@google.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Wed, 21 Oct 2026 14:47:46 -0700
X-Gmail-Original-Message-ID: <CAO9r8zNtuN=_BTV53oHqaTqE0Bo2qiDSrgTBzEZo5oyOnWyeYA@mail.gmail.com>
X-Gm-Features: AclHuK-8jo-f_F6DT-y6k_PMr4phWvWZnvu-2n_VUIdKUsZEm6R5LdMzF9aUhcU
Message-ID: <CAO9r8zNtuN=_BTV53oHqaTqE0Bo2qiDSrgTBzEZo5oyOnWyeYA@mail.gmail.com>
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

On Wed, Oct 21, 2026 at 1:57=E2=80=AFPM Suseendran Bhaskaran
<suseendranb@google.com> wrote:
>
> Commit dca4437a5861 ("mm/zswap: store <PAGE_SIZE compression failed page
> as-is") and commit 0b1bf60c324a ("mm/zswap: reduce the size of the
> compression buffer to a single page") updated zswap_compress() to pass a
> PAGE_SIZE destination buffer to crypto_acomp_compress() (so
> incompressible pages typically overflow the PAGE_SIZE buffer due to
> compressor metadata overhead) and check:
>
>     if (comp_ret || !dlen || dlen >=3D PAGE_SIZE)
>
> Because crypto_acomp_compress() previously returned -EINVAL on
> destination buffer overflow, this check conflated destination buffer
> overflow (incompressible page) with unexpected compressor failures and
> did not set comp_ret =3D -ENOSPC when rejecting incompressible pages,
> resulting in two user-facing issues:
>
> 1. When zswap writeback is disabled (e.g. memory.zswap.writeback =3D 0),
>    zswap_compress() sets 'comp_ret =3D comp_ret ? comp_ret : -EINVAL' and
>    jumps to unlock. Whether the compressor fails on destination overflow
>    with -EINVAL or succeeds with dlen =3D=3D PAGE_SIZE, comp_ret becomes
>    -EINVAL. Consequently, incompressible pages are misaccounted in
>    debugfs under reject_compress_fail instead of reject_compress_poor
>    (leaving reject_compress_poor stuck at 0 and triggering false
>    compressor failure alerts on normal incompressible workloads).

Hmm IIUC this is completely fixed by patch 1, so it doesn't belong here, ri=
ght?

>
> 2. When zswap writeback is enabled, any non-zero comp_ret (such as
>    -EINVAL from an invalid compressor context, -ENOMEM, or a hardware
>    accelerator error) is treated identically to an incompressible page:
>    comp_ret is cleared to 0 and the raw page is stored uncompressed in
>    zsmalloc. This silently masks genuine compressor failures
>    (reject_compress_fail is never incremented) and miscounts pages that
>    encountered a compressor error under stored_incompressible_pages.

Storing pages in zswap when compression fails to avoid LRU inversion
was intentional in commit dca4437a5861 ("mm/zswap: store <PAGE_SIZE
compression failed page as-is"). Unless we think this needs to be
changed, I think all we really need to do is make sure we account
debugfs correctly for -ENOSPC vs other error codes? Or am I missing
something?

>
> Update zswap_compress() to treat only comp_ret =3D=3D -ENOSPC or
> (!comp_ret && dlen >=3D PAGE_SIZE) as an incompressible page (storing it
> uncompressed in zswap when writeback is enabled to preserve LRU order,
> or rejecting it with comp_ret =3D -ENOSPC when writeback is disabled so
> zswap_reject_compress_poor is incremented), while jumping to unlock on
> unexpected compressor errors (comp_ret || !dlen) so
> zswap_reject_compress_fail is properly incremented.
>
> Fixes: dca4437a5861 ("mm/zswap: store <PAGE_SIZE compression failed page =
as-is")
> Signed-off-by: Suseendran Bhaskaran <suseendranb@google.com>
> ---
>  mm/zswap.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 37f34e406c8e..5f2a941fcaf1 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -881,12 +881,12 @@ static bool zswap_compress(struct page *page, struc=
t zswap_entry *entry,
>          * only adds metadata overhead.  swap_writeout() will put the pag=
e back
>          * to the active LRU list in the case.
>          */
> -       if (comp_ret || !dlen || dlen >=3D PAGE_SIZE) {
> +       if (comp_ret =3D=3D -ENOSPC || (!comp_ret && dlen >=3D PAGE_SIZE)=
) {
>                 rcu_read_lock();
>                 if (!mem_cgroup_zswap_writeback_enabled(
>                                         folio_memcg(page_folio(page)))) {
>                         rcu_read_unlock();
> -                       comp_ret =3D comp_ret ? comp_ret : -EINVAL;
> +                       comp_ret =3D -ENOSPC;
>                         goto unlock;
>                 }
>                 rcu_read_unlock();
> @@ -894,6 +894,9 @@ static bool zswap_compress(struct page *page, struct =
zswap_entry *entry,
>                 dlen =3D PAGE_SIZE;
>                 dst =3D kmap_local_page(page);
>                 mapped =3D true;
> +       } else if (comp_ret || !dlen) {
> +               comp_ret =3D comp_ret ? comp_ret : -EINVAL;
> +               goto unlock;
>         }
>
>         gfp =3D GFP_NOWAIT | __GFP_NORETRY | __GFP_HIGHMEM | __GFP_MOVABL=
E;
> --
> 2.56.0.218.g1ec904b173-goog
>
