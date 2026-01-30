Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE98D33F8A6;
	Fri, 30 Jan 2026 05:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769749860; cv=none; b=Im4Jg50nha00Gh8vohZ5sScinRaqmOR3GXShDJAV7wJnRMkQDpH7fiJWmV/G/jL2jH7N1rTeU5d792547d1yoxqvGaBNe09ijesTcLlPsRONxkCIG6U+sVvjrJLc+N0i6zPpq8LSUyYmgEvpKV5NFQR2TRC7U6s6PKXU803IEE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769749860; c=relaxed/simple;
	bh=SR9s5oRQ5MdP67G3f7qcWYmtiiNHB8IPJlrsxhRBAus=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Gsv1En3nn/PxfMWYBn71ehQLQs0SRMmrnB4e2v56L0DcK2Y7m/EWHwGxnr//aJlhWNT5s8TBX01C6WscxAm/uyL7oBt7noZYCJJMazcwPDYPdRvg4jL3jF3tkHJddcMcPy+FUHgILjGUPJS0Nffh5LwEB2muvlUnJQPQZonjK78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=KbCMgdHg; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="KbCMgdHg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=aTE635nylV+CsuYnB1QJnswo4PraDvGjNuU6gzG7dWA=; 
	b=KbCMgdHgySXA2ZX3NPkCRe8v2caI9lk3v1POcWrwq2L2gi0EJwxlcFopoUPpSqW9VrAxpvYBX4L
	Qz+bYvXCi6qcFqTvNz0Ki0gafv0dEWbUK7f2mqVrr1UUU/1Hi2UPA6UA86ftBZtSL9F1ZiKviBcGW
	jr5YeIuSxCw0SqCUUc9cjUoDPu15btJoL6JrOSOQvV1vgsDR2mo8m4echVzb1xvG5MZWc9ny6NnZK
	oqifuhdR6H/y3fxsomtkIg1dMeACCBflZDBmcTpslf9Zy5ca+bOdsCl8rFSaOfoFIm7YGjyMjinN6
	tmkSrE+bugwGvD4QNgXKaFwJ92jtutyO5frQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vlgmQ-003DaK-2c;
	Fri, 30 Jan 2026 13:10:51 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 30 Jan 2026 13:10:50 +0800
Date: Fri, 30 Jan 2026 13:10:50 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: jeffbarnes@linux.microsoft.com
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jeff Barnes <jeffbarnes@microsoft.com>
Subject: Re: [PATCH] crypto: aead: add service indicator flag for RFC4106
 AES-GCM
Message-ID: <aXw9Wj19ZX6dpNHW@gondor.apana.org.au>
References: <20260129-fips-gcm-clean-v1-v1-1-43e17dc20a1a@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260129-fips-gcm-clean-v1-v1-1-43e17dc20a1a@microsoft.com>

On Thu, Jan 29, 2026 at 04:04:36PM -0500, jeffbarnes@linux.microsoft.com wrote:
> From: Jeff Barnes <jeffbarnes@microsoft.com>
> 
> FIPS 140 validations require a “service indicator” to positively
> identify when an approved cryptographic service is provided. For
> RFC4106 AES‑GCM (used by IPsec), this commit exposes a per‑request
> indicator bit when the IV/nonce construction meets the FIPS uniqueness
> requirement.
> 
> Specifically, the indicator is set when the caller uses the RFC4106
> construction with seqiv (per RFC 4106 §3), where the 32‑bit salt and
> 64‑bit seqiv together guarantee a unique 96‑bit IV per key. This
> meets the SP 800‑38D §8.2 uniqueness requirement for GCM.
> 
> No ABI or uAPI changes. The flag is internal to the crypto API request
> path and may be consumed by in‑tree callers that need to record service
> use in a FIPS context.
> 
> Tests:
> - Verified that gcm(aes) requests never set the service‑indicator bit.
> - Verified that rfc4106(gcm(aes)) requests consistently set the bit.
> - Existing crypto self‑tests continue to pass.
> - checkpatch.pl: no issues.
> 
> Signed-off-by: Jeff Barnes <jeffbarnes@microsoft.com>

Rather than exporting this indicator, I would prefer that we just
forbid non-compliant combinations when FIPS mode is enabled.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
