Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792702654;
	b=OtqhWKh981nHB7k/pvbmlJ3c1SPHEUQgQKm+gGDLl1ljOoQFw0YlKkuJSQT2t1gmwEvo
	 cqVNOO2RANYaqmFCtVZ02lIhmelm0ZZtWRe/wsMDJLn3tNyzfz/P8POZecKG/VA/6mq67
	 5IFdPdsmHoekrDOXc38fGNVD0PEHHBxuPwxRs1bKDoFGY9J7GffzLPHkrUMzWwt4Ib4tX
	 j24N5m4eX8/I1mxmnndeC/FyHWC0Dev9SVASPQP1qtAGxB7QXlh2dl+pB9sLzcrOiH+u+
	 DwyTYLrwBFr1pjRliF+kIHmpxKFk30oKvIuserMEBIrDIejyBzF68DU3D6DzfIWcYDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792702654;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=LIhfmmcjoIFyE9XcthoG6P+kIqoTwbVtmyT4W+Ofg3k=;
	b=IuKIRWI+l04u70LUdfVPIAGCP/jh/pnczLmtzASjCfDzZMSKBek53jv62aLlOAh0DLXg
	 5XNdAGtA7KuSCkEDqn/CCIeWGyJKfh8R5NW1v9l11AyZBzH4CzEPoE/rX51LVyc3TTxRc
	 WI7yj6+sdkXhYKLp8yB+59SUw4puGpxBoYVeY2Tjs8wU8RIsaSJyMycq3PCe33hfyGfAV
	 WAk2pyGXfA5g5F15l39XygiXaZWW4/hkLVxJv4DuV5oUl1sMXoPg25C+h87ccUqzoxn2O
	 smHYNOMN4VjzechSX3BobbcPIkQs5+PNSpRGWi5oY7HFTYjb733nXEeqAbP15R2ugyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kcTsICfZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7BC3606A31B
	for <linux-crypto@vger.kernel.org>; Thu, 22 Oct 2026 20:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kcTsICfZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 510B31F01828;
	Thu, 22 Oct 2026 20:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792702653;
	bh=LIhfmmcjoIFyE9XcthoG6P+kIqoTwbVtmyT4W+Ofg3k=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kcTsICfZDioQU+wZci6SIJUDQUMw648cJ9rpOrODjZHKhZYtSqEgmoEOidSUoWaJw
	 oOGYTtFqdfj1un1kqeVHKaKO7Z1Y+6z2DPxi56uHJId1fXJ2yyj9qlC29HsPPjMCMg
	 xQq5jHPob1ZDZuCCYeC2FHA6NjlLGhQRZRd2dnRDzFiKE6CzlXUUOF1cyV77gPS/s2
	 tdjK3+BPYjO2tGsnP1Q6PIVqcwZUyt0wv4kI68w/adndXAH89cwK9RG7KCahnlLocU
	 BHGYwPKbQ8KkUz2Yvh1MHEPHsfXXYiHKvZnrSDo0zFdp4CqVQth0qZ6xdwp93fzmcb
	 5V/JbvnuYLTBA==
Message-ID: <sashiko-outbox-182032@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/2] mm/zswap: classify compression dst overflow as poor
 compression
Reply-To: sashiko-reviews@lists.linux.dev
To: "Suseendran Bhaskaran" <suseendranb@google.com>, "Andrew Morton" <akpm@linux-foundation.org>, "Herbert
 Xu" <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, "Johannes
 Weiner" <hannes@cmpxchg.org>, "Yosry Ahmed" <yosry@kernel.org>, "Nhat Pham" <nphamcs@gmail.com>
Cc: "Chengming Zhou" <chengming.zhou@linux.dev>, "Nick Terrell" <terrelln@fb.com>, "David
 Sterba" <dsterba@suse.com>, "SJ Park" <sj@kernel.org>, "Chris Li" <chrisl@kernel.org>, "Giovanni
 Cabiddu" <giovanni.cabiddu@intel.com>, "Suman Kumar Chakraborty" <suman.kumar.chakraborty@intel.com>, linux-crypto@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20261021205626.3286270-3-suseendranb@google.com>
References: <20261021205626.3286270-1-suseendranb@google.com>
 <20261021205626.3286270-3-suseendranb@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 20:57:31 +0000
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] mm/zswap: zswap_compress() mishandles -E2BIG overflow from hw co=
mpressors
--

commit 6e958455f7e6f806b4bd7b7afc39fe7c9fb8cd1f
Author: Suseendran Bhaskaran <suseendranb@google.com>

mm/zswap: classify compression dst overflow as poor compression

This commit updates zswap_compress() to treat only -ENOSPC or an output
length of at least PAGE_SIZE as an incompressible page, while routing other
non-zero return values from crypto_acomp_compress() to the compressor failu=
re
path.

> diff --git a/mm/zswap.c b/mm/zswap.c
> index 37f34e406c8e3..5f2a941fcaf1e 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -881,12 +881,12 @@ static bool zswap_compress(struct page *page, struc=
t zswap_entry *entry,
>  	 * only adds metadata overhead.  swap_writeout() will put the page back
>  	 * to the active LRU list in the case.
>  	 */
> -	if (comp_ret || !dlen || dlen >=3D PAGE_SIZE) {
> +	if (comp_ret =3D=3D -ENOSPC || (!comp_ret && dlen >=3D PAGE_SIZE)) {
>  		rcu_read_lock();
>  		if (!mem_cgroup_zswap_writeback_enabled(
>  					folio_memcg(page_folio(page)))) {
>  			rcu_read_unlock();
> -			comp_ret =3D comp_ret ? comp_ret : -EINVAL;
> +			comp_ret =3D -ENOSPC;
>  			goto unlock;
>  		}
>  		rcu_read_unlock();
> @@ -894,6 +894,9 @@ static bool zswap_compress(struct page *page, struct =
zswap_entry *entry,
>  		dlen =3D PAGE_SIZE;
>  		dst =3D kmap_local_page(page);
>  		mapped =3D true;
> +	} else if (comp_ret || !dlen) {
> +		comp_ret =3D comp_ret ? comp_ret : -EINVAL;
> +		goto unlock;
>  	}
> =20
>  	gfp =3D GFP_NOWAIT | __GFP_NORETRY | __GFP_HIGHMEM | __GFP_MOVABLE;

[Severity: Medium]
Does restricting the incompressible page check to comp_ret =3D=3D -ENOSPC c=
ause a
regression when using hardware acomp drivers that return -E2BIG or -EOVERFL=
OW
on destination buffer overflow?

When zswap_store() -> zswap_store_page() -> zswap_compress() compresses an
incompressible page into a PAGE_SIZE destination buffer, hardware acomp
drivers in drivers/crypto/ do not return -ENOSPC when the compressed output
exceeds the destination buffer:

drivers/crypto/intel/iaa/iaa_crypto_main.c:check_completion() {
	if (comp->status =3D=3D IAA_ANALYTICS_ERROR &&
	    comp->error_code =3D=3D IAA_ERROR_COMP_BUF_OVERFLOW && compress) {
		ret =3D -E2BIG;
		dev_dbg(dev, "compressed > uncompressed size,"
			" not compressing, size=3D0x%x\n",
			comp->output_size);
		update_completion_comp_buf_overflow_errs();
		goto out;
	}
}

Similarly, the QAT acomp driver (which registers deflate and zstd with
priority 4001) completes destination buffer overflows with -E2BIG in
qat_comp_generic_callback() (and -E2BIG or -EOVERFLOW in
qat_comp_lz4s_zstd_callback()):

drivers/crypto/intel/qat/qat_common/qat_comp_algs.c:qat_comp_generic_callba=
ck() {
	if (unlikely(produced > qat_req->actual_dlen)) {
		memset(inst->dc_data->ovf_buff, 0,
		       inst->dc_data->ovf_buff_sz);
		dev_dbg(&GET_DEV(accel_dev),
			"Actual buffer overflow: produced=3D%d, dlen=3D%d\n",
			produced, qat_req->actual_dlen);

		res =3D -E2BIG;
		areq->dlen =3D 0;
		goto end;
	}
}

With this change, -E2BIG and -EOVERFLOW fall into the else if (comp_ret ||
!dlen) branch and jump to unlock. When zswap writeback is enabled,
incompressible pages will be rejected instead of being stored uncompressed =
in
zsmalloc, and zswap_reject_compress_fail will be incremented instead of
zswap_reject_compress_poor.

Should those hardware acomp drivers be updated to return -ENOSPC on
destination overflow, or should zswap_compress() also handle -E2BIG and
-EOVERFLOW as poor compression?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261021205626.3286=
270-1-suseendranb@google.com?part=3D2
