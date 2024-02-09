Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A73D556B6F
	for <linux-crypto@vger.kernel.org>; Fri,  9 Feb 2024 05:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707454911; cv=none; b=s52owjKLVL3qfmA6Nigt8ozX6comfFl65UR/v9jWDDXdlU5PtjTjdQkQin4wodTpFmJvOE8uODzAkONUZfr6gYC6C39jo0DfIcXeiOeNjsqNuUEVS1qjoL7UDMyQay5ashWUseFhC5u9t6EtVjoQv0ATg6Bu5CpKvrMaDZSw2dU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707454911; c=relaxed/simple;
	bh=/UFRH8E2S+D+VdjTFEyphLyWdW9mP15mUOTl4JMd/tE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cCcAGFC33Tm/ApCHsF18yATPNU0A1p4sYMHywemx4VGqHlXfeWtW5hCS4EAq+LdarNixeA9tgtUkQz4ooxWGW5qat/tYNIkVTj0E8bfGmMlrhVgLUBBWIAkWSjTAjyMpS4D/cblrIMpoHsFPyH6nPnoPYbhgYuYmE/1H5dkgIXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1rYJ1F-00Bhjr-0v; Fri, 09 Feb 2024 13:01:46 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 09 Feb 2024 13:01:58 +0800
Date: Fri, 9 Feb 2024 13:01:58 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Joachim Vandersmissen <git@jvdsn.com>
Cc: linux-crypto@vger.kernel.org
Subject: Re: [PATCH v2] crypto: rsa - restrict plaintext/ciphertext values
 more
Message-ID: <ZcWxxnF7gb3aXi9U@gondor.apana.org.au>
References: <20240203071959.239363-1-git@jvdsn.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240203071959.239363-1-git@jvdsn.com>

On Sat, Feb 03, 2024 at 01:19:59AM -0600, Joachim Vandersmissen wrote:
> Hi Herbert,
> 
> As requested, I replaced the existing check with the new SP 800-56Br2
> check. I verified that the restriction is now applied in both FIPS and
> non-FIPS mode. I tried to make it clear in the comments why the code is
> now deviating from RFC3447.
> 
> ---8<---
> 
> SP 800-56Br2, Section 7.1.1 [1] specifies that:
> 1. If m does not satisfy 1 < m < (n – 1), output an indication that m is
> out of range, and exit without further processing.
> 
> Similarly, Section 7.1.2 of the same standard specifies that:
> 1. If the ciphertext c does not satisfy 1 < c < (n – 1), output an
> indication that the ciphertext is out of range, and exit without further
> processing.
> 
> This range is slightly more conservative than RFC3447, as it also
> excludes RSA fixed points 0, 1, and n - 1.
> 
> [1] https://doi.org/10.6028/NIST.SP.800-56Br2
> 
> Signed-off-by: Joachim Vandersmissen <git@jvdsn.com>
> ---
>  crypto/rsa.c | 36 ++++++++++++++++++++++++++++++++----
>  1 file changed, 32 insertions(+), 4 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
