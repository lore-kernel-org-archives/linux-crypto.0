Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D46C2372EC2;
	Fri,  3 Jul 2026 06:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783059564; cv=none; b=BCeq2B4U8ns55hHQsSFoh9js6uUoEXjyoKlcCPU4asbVnhWo+Ba+Wg2gJzutK2abbvI0L+ZgX1WDDj0h1iHqk6c05QCr+PaK1WglUIgek68UL4dtk5efB6a5TM0ntGyr+Tpc/XdDZUvWW/JTLRMHraEb2mp4GhgluNLVfiO9DgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783059564; c=relaxed/simple;
	bh=inKJGBUJkTuIRHR3mmK/NENLteLDVMvABcyPAGkKOyc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KeSGKUEBZcTKPjcK3yflfaKlZ+0rWXDWq9ALVplSWQVSy88Mzw1VS6ocBoljiQDRVeuWl86rCApUL0a/mwNRKFH/ss75Ctx2HETOGQkfR1PsRUS8KmWntJb0hSVY6JDb/Ew2J2sCHH26Z/kIzRcGnqWq7rZM1ssw1/BSz1qvkWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=iZ92HP03; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="iZ92HP03"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=vE92qeJByI2YA1KVwspOtgLh+8NHTenJzNWCzPyxjsY=; 
	b=iZ92HP03MrvT5DpXr4lUViVyiIKf9mZ5Y5gcFb1KB6yiG1cpBO34A5E1kSFNwE1HsOPmTeC7Ug2
	dEeN/y6TmlG9fTsqUpaPRhWJAj2ENul5AUaoQx368ROwbl/fUdvYAEp7qLtuafd0UsytLrk0oohRZ
	gut3Ef7IxZFRPtTzf2osmNW7fVfMmXh8wnF2NfTVnF4qp3y5WblpU6NjnMSbghfxX9pdojm5ZwOqJ
	TcpIHYfOrDzRPb6w0ZB+nEIle3ehd5Ys7otxP0joMNl2BEWJKJzoQnoHHPOZzMZQS0AOESXDBowNm
	T0PgMMLgF+m9PHg7RJekcdkbFkd2/EMWXkeg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wfXEo-0000000AGhd-3xgT;
	Fri, 03 Jul 2026 14:19:00 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 03 Jul 2026 14:18:58 +0800
Date: Fri, 3 Jul 2026 14:18:58 +0800
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
	stable@vger.kernel.org, Atish Patra <atishp@meta.com>
Subject: Re: [PATCH v3 3/4] crypto: ccp: Fix possible deadlock in SEV init
 failure path
Message-ID: <akdUUggmSSS1a0IW@gondor.apana.org.au>
References: <20260602-sev_snp_fixes-v3-0-24bfd3ae047c@meta.com>
 <20260602-sev_snp_fixes-v3-3-24bfd3ae047c@meta.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260602-sev_snp_fixes-v3-3-24bfd3ae047c@meta.com>

On Tue, Jun 02, 2026 at 03:36:34PM -0700, Atish Patra wrote:
> From: Atish Patra <atishp@meta.com>
> 
> __sev_platform_init_handle_init_ex_path() calls
> rmp_mark_pages_firmware() with locked=false while the parent
> function of init_ex_path already acquired the sev_cmd_mutex.
> In the case of an RMPUPDATE failure for any page after the first, the cleanup
> path would invoke reclaim pages which would result in a deadlock in
> sev_do_cmd.
> 
> Pass locked=true to honor the lock status of the parent function.
> 
> Fixes: 7364a6fbca45 ("crypto: ccp: Handle non-volatile INIT_EX data when SNP is enabled")
> 
> Reported-by: Chris Mason <clm@meta.com>
> Assisted-by: Claude:claude-opus-4-6
> Fixes: 7364a6fbca45 ("crypto: ccp: Handle non-volatile INIT_EX data when SNP is enabled")
> Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
> Signed-off-by: Atish Patra <atishp@meta.com>
> ---
>  drivers/crypto/ccp/sev-dev.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
