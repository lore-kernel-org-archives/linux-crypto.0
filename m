Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795168479;
	b=MHyp8/DV3Dth4BpD2gm18zRUtOkqNwW1KEwsV7T3dJU62rUaBgugeyhrh9ww1g2Ec1uW
	 LlWF4zWoh0YvZ0HhXgqEOOFVNuTTRPBM3ArAdKisGPIZINM0C+kTIPGkOFaLlO9ouTQOS
	 cmzZj6S1z+/pLqmzGMQO3HorF3B+oXeb8fwml6b/lqsIKzDbpGScKs6VEkDn/PjjStLjk
	 nJQTn0YwPCPwHTWYnPl6y3dZubyOy2o20MlxaKkI31HEx4FtvWcoDwiB8MrKC+Ol2EBpJ
	 +5Qs0dKtiqxKRX6m/XJQw0onB0BRgHDYDo63TfhhK2hmQLHprQWPybr9hibC3ZKBC0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795168479;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=rARoXv7ufFOzEMpSx2Pol3AL0xwvVnviWOlVEFct/Y4=;
	b=nZ+FzeAZAnub0kRdBvGyWMSBN39rSaJfE12PVg9fOjHDyokOt1MpXMgT6bW/hu2MnYXQ
	 /0Mhs6mEYVl2aXbucz/s0hnW27ISXJebcmzezxvPj7pBN3giwRcZvcOTmtwBUaICfZJEd
	 VyP27v2Dos2MLt2vaBmcNNQnSF2FAW/GGvzrkp8R2ER8hJ3MRq8IMwz4gXzUHFRePleIQ
	 pcTPV3pv2F2+4+EFTg3GiuETQHHT877M7Wjjne6GoBooHgVhNIYU16ycyZy2P4b+xzh5O
	 YJkLhJbpho7XLbfG/9dC3qIzl7qHYGIQxUBZWM9bAuxj53bCKH5WVyGQfSc2PQRS3PA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=LyAAKOr0;
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9D62606A32A;
	Fri, 20 Nov 2026 09:54:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E9D62606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=LyAAKOr0
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=rARoXv7ufFOzEMpSx2Pol3AL0xwvVnviWOlVEFct/Y4=; 
	b=LyAAKOr0Bp07knZ0MGPiLcrUZCB6NBdGuK5jTlkAs7bZTqXaRaMZ2bJuaHA+rbYiEtpzv1aJcls
	qgzITrwhf4OyWtZYNq86nPDAkSIJI77bLKr9Eopc170lZRmuiZ2A2lrXR73631PZ3AzCr86Zact+h
	Ji8we+pYC8aevoe4fU2bN3xyzkfWGGyTBUU2SdiC2KBrpNULGug1n4vo7BwX/vBCCTv223YDQiss3
	U14JxDV/vET0+4TyzoiXCPJJmYvaQWJ3lXw2jEhRQWSUY+pxm/ee28yX4KugcnORDtOwGoF8NbfAB
	+eYkjSthh/U80uh8S8ZReMZkdlwgt+uCzMCQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xULKE-0000000HYi9-3yWT;
	Fri, 20 Nov 2026 17:54:36 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 20 Nov 2026 17:54:34 +0800
Date: Fri, 20 Nov 2026 17:54:34 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: T Pratham <t-pratham@ti.com>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, Sebin Francis <sebin.francis@ti.com>,
	Manorit Chawdhry <m-chawdhry@ti.com>,
	Praneeth Bajjuri <praneeth@ti.com>,
	Vishal Mahaveer <vishalm@ti.com>
Subject: Re: [PATCH v13 00/15] Fix several issues in DTHEv2 driver
Message-ID: <awAY2r7Rum8H6Vig@gondor.apana.org.au>
References: <20261112081204.1146395-1-t-pratham@ti.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261112081204.1146395-1-t-pratham@ti.com>

On Thu, Nov 12, 2026 at 01:41:48PM +0530, T Pratham wrote:
> This series fixes a handful of independent and mostly benign till now
> issues in the DTHEv2 driver which were flagged by bots and AI agents.
> Except for the fifth patch in this series which was found in an internal
> testing.
> 
> The Sashiko review on DTHEv2 hashing driver patch series v5 pointed out
> some pre-existing issues which needed to be fixed [1].
> 
> One of the issues had already been flagged by kernel test bot and a fix
> sent on the list by Mert [2].
> 
> I included this patch in this series with minor edits. Then the Sashiko
> review page for [2] had more comments [3]
> 
> Overall this resulted in a bunch of fixes patches which would have
> deviated the DTHEv2 hashing driver series had they been included with
> it. So I clubbed them together in a new patch series which is this.
> 
> Signed-off-by: T Pratham <t-pratham@ti.com>
> ---
> Links:
> [1]: https://sashiko.dev/#/patchset/20260807110501.975130-1-t-pratham%40ti.com
> [2]: https://lore.kernel.org/all/20260613085858.32580-1-mertsftl@gmail.com/
> [3]: https://sashiko.dev/#/patchset/20260613085858.32580-1-mertsftl%40gmail.com
> 
> Changelog:
> v13:
>  - Put kref in probe error path (regression reported by Sashiko).
> v12:
>  - Rebased and resolved merge conflicts. No functional changes.
> v11:
>  - Changed order of operations in probe.
>  - Added comments in AEAD Tag helper functions.
> v10:
>  - Corrected typo (dev --> ctx->dev)
> v9:
>  - Changed extensive completion re-init based wait to using kref in
>    patch 04/15
> v8:
>  - Minor fix based on Sashiko comment (corrected spinlock)
> v7:
>  - Fixes based on Sashiko comments (added locking around
>    dthe_put_drvdata)
> v6:
>  - Fixes based on Sashiko comments (waitqueue -> completion; DMA
>    alignment for cache coherency)
> v5:
>  - Fix spinlock inconsistency patch
> v4:
>  - Fixes based on Sashiko comments
> v3:
>  - Fixes based on Sashiko comments
>  - Some reordering of patches
> v2:
>  - Fixes based on Sashiko comments
> 
> Link to previous versions:
> v12: https://lore.kernel.org/all/20261107160631.2592763-1-t-pratham@ti.com/
> v11: https://lore.kernel.org/all/20261107145618.2349562-1-t-pratham@ti.com/
> v10: https://lore.kernel.org/all/20261016124456.1802080-1-t-pratham@ti.com/
> v9: https://lore.kernel.org/all/20261016114806.1749515-1-t-pratham@ti.com/
> v8: https://lore.kernel.org/all/20261001085245.2922974-1-t-pratham@ti.com/
> v7: https://lore.kernel.org/all/20260930125859.1749849-1-t-pratham@ti.com/
> v6: https://lore.kernel.org/all/20260930112533.1593952-1-t-pratham@ti.com/
> v5: https://lore.kernel.org/all/20260918102245.2784000-1-t-pratham@ti.com/
> v4: https://lore.kernel.org/all/20260910175619.2122149-1-t-pratham@ti.com/
> v3: https://lore.kernel.org/all/20260910104202.1537226-1-t-pratham@ti.com/
> v2: https://lore.kernel.org/all/20260827132318.613876-1-t-pratham@ti.com/
> v1: https://lore.kernel.org/all/20260827105711.527182-1-t-pratham@ti.com/
> ---
> 
> Mert Seftali (1):
>   crypto: ti - Use list_first_entry_or_null() in dthe_get_dev()
> 
> T Pratham (14):
>   crypto: ti - Fix spinlock inconsistency in DTHEv2
>   crypto: ti - Fix potential memory corruption on highmem pages
>   crypto: ti - Fix use-after-free of dev_data on DTHEv2 driver removal
>   crypto: ti - Trim scatterlists to correct length in AES
>   crypto: ti - Align buffers to cacheline for DMA
>   crypto: ti - Separate padding buffer for src and dst
>   crypto: ti - Validate sg_nents_for_len() return value in DTHEv2 AES
>   crypto: ti - Validate sg_nents_for_len() return value in DTHEv2 AEAD
>   crypto: ti - Terminate DMA on all error paths in AES to clear
>     descriptors
>   crypto: ti - Terminate DMA on all error paths in AEAD to clear
>     descriptors
>   crypto: ti - Do AEAD software fallback on only ENOMEM
>   crypto: ti - Correct AEAD tag operations against dma cache
>     invalidation
>   crypto: ti - Change lengths in AES to u64 to avoid potential overflows
>   crypto: ti - Change lengths in AEAD to u64 to avoid potential
>     overflows
> 
>  drivers/crypto/ti/dthev2-aes.c    | 378 +++++++++++++++++++-----------
>  drivers/crypto/ti/dthev2-common.c |  84 +++++--
>  drivers/crypto/ti/dthev2-common.h |  66 +++++-
>  3 files changed, 365 insertions(+), 163 deletions(-)
> 
> 
> base-commit: 99f506c86bf8b6909564fff64eeaa64dec5996b9
> -- 
> 2.34.1

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
