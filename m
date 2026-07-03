Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9650F380FF7;
	Fri,  3 Jul 2026 06:19:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783059569; cv=none; b=LBDmdTsfBoV0dGBVXvnualqDSD2fz77bqYz4Rf+GMUBGsWN5XRq4jKY+RWb+Z7Erjj0z+RdTw+0INx0NU6Y2gc2CVQpMaJytojot6t6n2ArhWBduRtoMVcQ7JngSXM86AuRmfxKfgRj1Vn8z7PG3Q4q71TJHbwoTl8UKs/NGKnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783059569; c=relaxed/simple;
	bh=6KylznHOqiWd22SnFBQraUpSbQmxUJRMz+dU7yx/cUY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Fe7rSbN++35ExlBlk4BLFDDo++2SVmNKo1eWx3+WLtC0KKid8uKq1DQ9nYg2vkHkgsk8JFaG9j21rMLSVMZs8YEz4XEra5rigszOd3UEyvNpbavy+Ic14alIpuqPwuZ/OCG+okIrTqrFLwD1kLIcOwfljQYPfIZikPA6nCUpZnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=dIzzF/nf; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="dIzzF/nf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=DXEQ90sJPpbTVqwRJFktHc90n2QX5ZI2D1JPxidYX3I=; 
	b=dIzzF/nfDsKxfew7reyEO7o32o0SsY7FOPtycwv9Lep7ZC9LAXWfjATwXD+ny2sudVmjP5ca0pw
	W08CeNki5VyXkTC/weZbRveC4g7x6dE38svlNqFLGlY27BcDXYA0JgFXXS11uEseTKWCplA0ybUL+
	bWxN/tjPQSJCRLwCPWGYNGsuzybHuYkfDZa5gunevLUbK1xdD/DVnvHzJQW/xbulpUbZZvbjGhei5
	TFCIGh3UUAd4LdfWJOEJ3Yy9Ca7tkpKL3qaF8B2fvnftC4aTMhYDMjlFtHybSGLUc13db5g2dSeEx
	cXOwTYOvYF5QkIryQpwVrBYOqYflPmAkXYRA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wfXF5-0000000AGiE-3BxF;
	Fri, 03 Jul 2026 14:19:16 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 03 Jul 2026 14:19:15 +0800
Date: Fri, 3 Jul 2026 14:19:15 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Atish Patra <atish.patra@linux.dev>
Cc: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Peter Gonda <pgonda@google.com>,
	Brijesh Singh <brijesh.singh@amd.com>,
	Youngjae Lee <youngjaelee@meta.com>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Michael Roth <michael.roth@amd.com>,
	John Allen <john.allen@amd.com>, clm@meta.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	stable@vger.kernel.org, Atish Patra <atishp@meta.com>,
	Sashiko <sashiko-bot@kernel.org>
Subject: Re: [PATCH v3 4/4] crypto: ccp: Fix memory leak in SEV INIT_EX path
Message-ID: <akdUY_qEi2DaQKcR@gondor.apana.org.au>
References: <20260602-sev_snp_fixes-v3-0-24bfd3ae047c@meta.com>
 <20260602-sev_snp_fixes-v3-4-24bfd3ae047c@meta.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260602-sev_snp_fixes-v3-4-24bfd3ae047c@meta.com>

On Tue, Jun 02, 2026 at 03:36:35PM -0700, Atish Patra wrote:
> From: Atish Patra <atishp@meta.com>
> 
> allocated pages in _init_ext_path are never freed and sev_init_ex_buffer
> is left pointing at the leaked memory in case of any failures during the
> function..
> 
> Fix by adding an error path that frees the pages and clears
> sev_init_ex_buffer. Make sure we only free the memory if the failure
> happens before the conversion. Otherwise, we may end up trying to free
> up converted pages in case of reclaim failure. rmp_mark_pages_firmware
> failures should be rare enough to avoid more code complexity to track
> down which pages were reclaimed/leaked vs which are not.
> 
> Fixes: 7364a6fbca45 ("crypto: ccp: Handle non-volatile INIT_EX data when SNP is enabled")
> 
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
> Signed-off-by: Atish Patra <atishp@meta.com>
> ---
>  drivers/crypto/ccp/sev-dev.c | 17 ++++++++++++++---
>  1 file changed, 14 insertions(+), 3 deletions(-)

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
