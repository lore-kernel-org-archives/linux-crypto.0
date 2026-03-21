Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19F5825B31D;
	Sat, 21 Mar 2026 08:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774082684; cv=none; b=DI0Kbgzm3Nr6LbWAOVpGcUVqsIJE0qlq8d+kE6etMUVlsShwZ778kVyKn2Z4rsbSUL8jSDe7O34cjBwL2HYfIapKrfo7n5oj5XEFb+Ko9sFE31tcXE4/+cTKQeQdZ2nKSZ5MXjt077FB5Un0oH7XFFmo7TSW1bhlQ9rV+WUaXDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774082684; c=relaxed/simple;
	bh=6GQ2XtbLURGaXYe0gsuQd42n54KeN6M/EV6YiQaST9c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ed9yd6de11BE8rJW8KVphR25VfleDICQY8/w5iyUT54wvVo6D6VlcqgPUbwaC7iSxcr6WFn5BtSUOtOPdmYLTjvbz/wZmKNU4E0KQT+TiAVdqSE6ogZG4KSXA7qmbu8qQ6RzXs+eRFe5hCoLLFmJCR9IiKraKS/+72lEfrs5Q+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=f5ZEAYC5; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="f5ZEAYC5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=ddwFSz+a9hI0WzDfvYqBvAWUH/yvE+gKAbgPWQBzNBw=; 
	b=f5ZEAYC5CJvN2qE9y1TCBpugVldTnkw8jR1wqm2f71d9kjY0S4eePBErIrBGWu4iCD2jTAmGWkz
	U6Fych2tSwsJdP79NkbSkNLTuudLH8I5ucO0191mPbEk/ivTPe1bgiaoulJw2WeY022lmw1cVbaqH
	j/ASdT1LefwLeq2NxEPOhu824Z68mZ5oaPGlQyO65OkLst+BCP2IlaNeLvfgTES2zmsW23CBHJ8si
	nwyJHz3beas6bPxrPkvJktuXsPsZP0602dGUilJWrVGkLb9OkykbH7uo8DMkXIIXscwi9XZs2a04H
	GdtxbiR1EQmPazUjogixOlnx7IW54uuKb4lw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1w3rw8-00GJ6I-0L;
	Sat, 21 Mar 2026 16:44:01 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 21 Mar 2026 17:44:00 +0900
Date: Sat, 21 Mar 2026 17:44:00 +0900
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Tycho Andersen <tycho@kernel.org>
Cc: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>,
	"David S. Miller" <davem@davemloft.net>,
	Ard Biesheuvel <ardb@kernel.org>,
	Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>,
	Kishon Vijay Abraham I <kvijayab@amd.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	Nikunj A Dadhania <nikunj@amd.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Kim Phillips <kim.phillips@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH v3 6/7] crypto: ccp - implement SNP x86 shutdown
Message-ID: <ab5aUI77Wik5GvXV@gondor.apana.org.au>
References: <20260317162157.150842-1-tycho@kernel.org>
 <20260317162157.150842-7-tycho@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260317162157.150842-7-tycho@kernel.org>

On Tue, Mar 17, 2026 at 10:21:56AM -0600, Tycho Andersen wrote:
> From: "Tycho Andersen (AMD)" <tycho@kernel.org>
> 
> The SEV firmware has support to disable SNP during an SNP_SHUTDOWN_EX
> command. Verify that this support is available and set the flag so that SNP
> is disabled when it is not being used. In cases where SNP is disabled, skip
> the call to amd_iommu_snp_disable(), as all of the IOMMU pages have already
> been made shared. Also skip the panic case, since snp_x86_shutdown() does
> IPIs.
> 
> Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
> Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
> ---
>  drivers/crypto/ccp/sev-dev.c | 41 +++++++++++++++++++++---------------
>  include/linux/psp-sev.h      |  4 +++-
>  2 files changed, 27 insertions(+), 18 deletions(-)

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
