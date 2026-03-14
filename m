Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C04CB1A9FAB;
	Sat, 14 Mar 2026 05:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773465332; cv=none; b=Cd0zbHK9LnMloHNq67JqdiwsRuZmvB8gVIt0su9TPjwF4EOijzzO9WzY434xTlI13qjSsXHhfPQAeyPzsNrz7OM0/4pOqWbzdHlM1e+KJSzF8yXsoDwAokrcBL92Jgzx+lIXm8dIRsaUhZnyxZR+Qi+sOHhWD6OZbrZ62Qv0iOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773465332; c=relaxed/simple;
	bh=e+Y21tF4OIiiT5Iy82jCbjwEcnWMkIhsBSYFwD1SCmY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eG3e761M6yitKW1QB+OhQ6CjF4tRcK8v2fKmiGWRyqY42pfZXk9zADADFc/lZmDeU+l5h3D7pmcW9f030yYkjoVQQnJNh2gI8FYBXVXZtEKLIT+9FkUb+qkJPRLqulVzHzWrzbLtpiaS6cGaz3yoMkwUQ+JTSyppDAgZY5Pwvz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=syf/7lFL; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="syf/7lFL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=fMBFDSt8SNA5Bj4132vhLk7iNDRMu/frJuoe4oSzxaQ=; 
	b=syf/7lFLSEGaYF4UqtHC/GRe7YCpWZdChV+tA8HfR/lkG0IaS0dovC3rzyBLfbHSXEGokowBBsT
	/IQNv0+wW6zMrHba4q00EDdSeBQaZqpVqY6bYBjYc3hiQI44qFHoFLBH0ZQZfbHoKPg5IlDzFpuqv
	RBKS/KbIU1DZtJAdREaowMute6TNNjWEbht0tPl50uJ+ep05Zo55LcDYDZ36OxKvMkbsNq7xUscn9
	M1L9zUFTrJ1TYNj9KOyh6bIhlF2qedEBG4Ruq5PybSfvPyTTvDYzaj7HNl1/uw/vll2d2AQR4TUFT
	DqEDiKejZ8MzeWNK9+PxC8zFkqtfJsGmeN0g==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1w1HLS-00ELAf-2w;
	Sat, 14 Mar 2026 13:15:28 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 14 Mar 2026 14:15:26 +0900
Date: Sat, 14 Mar 2026 14:15:26 +0900
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Ashish Kalra <ashish.kalra@amd.com>, John Allen <john.allen@amd.com>,
	"David S . Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Tycho Andersen <tycho@kernel.org>,
	Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH] crypto: ccp - Fix leaking the same page twice
Message-ID: <abTu7tacXIMi3lNc@gondor.apana.org.au>
References: <20260304203934.3217058-1-linux@roeck-us.net>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260304203934.3217058-1-linux@roeck-us.net>

On Wed, Mar 04, 2026 at 12:39:34PM -0800, Guenter Roeck wrote:
> Commit 551120148b67 ("crypto: ccp - Fix a case where SNP_SHUTDOWN is
> missed") fixed a case where SNP is left in INIT state if page reclaim
> fails. It removes the transition to the INIT state for this command and
> adjusts the page state management.
> 
> While doing this, it added a call to snp_leak_pages() after a call to
> snp_reclaim_pages() failed. Since snp_reclaim_pages() already calls
> snp_leak_pages() internally on the pages it fails to reclaim, calling
> it again leaks the exact same page twice.
> 
> Fix by removing the extra call to snp_leak_pages().
> 
> The problem was found by an experimental code review agent based on
> gemini-3.1-pro while reviewing backports into v6.18.y.
> 
> Assisted-by: Gemini:gemini-3.1-pro
> Fixes: 551120148b67 ("crypto: ccp - Fix a case where SNP_SHUTDOWN is missed")
> Cc: Tycho Andersen (AMD) <tycho@kernel.org>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
>  drivers/crypto/ccp/sev-dev.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
