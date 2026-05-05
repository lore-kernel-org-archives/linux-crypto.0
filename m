Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 018662F1FC3;
	Tue,  5 May 2026 08:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777970457; cv=none; b=dLYJUDZdefhlPaIGI+mLbz9X086O36RNFXGIaGhhO2JK+vtkUyJBX23FFxcV4+ipJq4bfWSJTP5mXAvRTYhKVgXQkSWeLFbm+yakRlBx8tszAvMpz0YN4ahjLsoTas5ld907RiUhrq8oxbMK8A5WuUjE1JdCm7Hr7ofO6pzRPjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777970457; c=relaxed/simple;
	bh=hGMHkQg5RP7bd1xiaM6gfqSNFR52xRdBBeTJqqkRF14=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LAjnmmR+X7RDZjQ5YxlG0UXH1JyV9/zhzjIyLi/4oEhEHUtxkCvIQ+Er0mQpLR1CW2RCfWwlgwFVDOaoE2nFg5caEsLwswmYgvd3ySQgLnNelBZGNLFlbDrlYWEZUr2FJDtvUqNafVyLjp4OR+YL4V9wjtZo0pdkAZ0WvTAAuDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=qROJBK+R; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="qROJBK+R"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=7dBduEfzo7n8Dq5nnIZFj7zg6ZOrTk8TkDgVPQs6Vsw=; 
	b=qROJBK+RLxEmuhr/uY8RxgfLuI9KkvWPM+cXYWrb7Z8fDLdcmdT96BwU0c7CcKY4XL+JZ6D07Mz
	Re6J9I5atM16B2Q+LFWAUTP/FiYtE+ePIMs+um20ISmYN345I98HvQoNDKA+ksTmwdVC7GCJhCD6O
	GP92amzcbj23XA8fgWP8hiRUv4HVko3hHv3e7IR6gSmQwyr1MavwY02ef/0uM5eiTZvDPKKk5Is/W
	cRLj2Nxqw6TB+hxj6Rz2fd0NE9xfZcpvok46vp32m1LNx6HmPQ5xSGONKeV14n0OLZbpzHRUTA0VJ
	R13LslFG5ZE7gX0LtQRTiNWJoBQOFWe7Qx9A==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wKBKg-00BMwv-2E;
	Tue, 05 May 2026 16:40:47 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 05 May 2026 16:40:46 +0800
Date: Tue, 5 May 2026 16:40:46 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Tycho Andersen <tycho@kernel.org>
Cc: Tom Lendacky <thomas.lendacky@amd.com>, John Allen <john.allen@amd.com>,
	"David S. Miller" <davem@davemloft.net>,
	Ashish Kalra <ashish.kalra@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Brijesh Singh <brijesh.singh@amd.com>,
	Michael Roth <michael.roth@amd.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v1 0/4] Fix some bugs in the CCP driver
Message-ID: <afmtDhOXWq87HtUc@gondor.apana.org.au>
References: <20260408143259.602767-1-tycho@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260408143259.602767-1-tycho@kernel.org>

On Wed, Apr 08, 2026 at 08:32:55AM -0600, Tycho Andersen wrote:
> From: "Tycho Andersen (AMD)" <tycho@kernel.org>
> 
> This set of fixes came out of using various AI tools on the SNP shutdown
> series:
> https://lore.kernel.org/all/20260326161110.1764303-1-tycho@kernel.org/
> 
> I'm not quite sure how to cite these tools yet, checkpatch complained a
> bit about my citations here. Happy to respin if there's a better way. It
> looks like e.g. Assisted-by in the process of being added:
> https://lore.kernel.org/all/20260302143659.41882-1-thomas.hellstrom@linux.intel.com/
> 
> Thanks,
> 
> Tycho
> 
> Tycho Andersen (AMD) (4):
>   crypto/ccp: Reverse the cleanup order in psp_dev_destroy()
>   crypto/ccp: Fix snp_filter_reserved_mem_regions() off-by-one
>   crypto/ccp: Check for page allocation failure correctly in TIO
>   crypto/ccp: Initialize data during __sev_snp_init_locked()
> 
>  drivers/crypto/ccp/psp-dev.c |  8 ++++----
>  drivers/crypto/ccp/sev-dev.c | 23 +++++++++++++----------
>  2 files changed, 17 insertions(+), 14 deletions(-)
> 
> 
> base-commit: 6c927e5ca9d238f8ae40b453a8382eb9cf4ee855
> -- 
> 2.53.0

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
