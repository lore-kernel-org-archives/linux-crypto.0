Received: from norbury.hmeau.com (helcar.hmeau.com [216.24.177.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4F6811CA9
	for <linux-crypto@vger.kernel.org>; Fri, 28 Jun 2024 01:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.24.177.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719539585; cv=none; b=Vw/pH47q7kQjNcypWKpGU8mjpGHs6s3Xmr9UwtMiNzO7otVR4LjgsYpCNC7WWnn3e0PJ+HSTnyamkyrrujI2Xg1gClN3X8a4JSGTzXVwQlXEyWMNnChxjqaC6boQ2eT+eAoi9JQrG69loj3JfvvMtHaS6bDrfXVqwIwBEHIF6k4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719539585; c=relaxed/simple;
	bh=20HcdlCqKaQF5MnUQB1WC0YJIUrETNsQwDltKyj4Hzo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LMyo3SMnWPI0nuJh2+YeBSlt5ur8OITm79VeOXipI9HLVvI9MxdwY0FVRLhcFOh0MQ1RCeJ6OHo5cpClxOtiNcF/z7TkxTPTBe5R774rIpNMr0DnK4iADxeB/ozqq/EpnMHvUX9N3XwN4va71vVwMUNWy0sMYyubF5vI9RbTgjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=216.24.177.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
	by norbury.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sN0n7-004GGT-1w;
	Fri, 28 Jun 2024 11:52:46 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 28 Jun 2024 11:52:46 +1000
Date: Fri, 28 Jun 2024 11:52:46 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Harald Freudenberger <freude@linux.ibm.com>
Cc: linux-crypto@vger.kernel.org, dengler@linux.ibm.com, Jason@zx2c4.com
Subject: Re: [PATCH v2] hwrng: core - Fix wrong quality calculation at hw rng
 registration
Message-ID: <Zn4XboIRp5V5RRuz@gondor.apana.org.au>
References: <20240621150224.53886-1-freude@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240621150224.53886-1-freude@linux.ibm.com>

On Fri, Jun 21, 2024 at 05:02:24PM +0200, Harald Freudenberger wrote:
> When there are rng sources registering at the hwrng core via
> hwrng_register() a struct hwrng is delivered. There is a quality
> field in there which is used to decide which of the registered
> hw rng sources will be used by the hwrng core.
> 
> With commit 16bdbae39428 ("hwrng: core - treat default_quality as
> a maximum and default to 1024") there came in a new default of
> 1024 in case this field is empty and all the known hw rng sources
> at that time had been reworked to not fill this field and thus
> use the default of 1024.
> 
> The code choosing the 'better' hw rng source during registration
> of a new hw rng source has never been adapted to this and thus
> used 0 if the hw rng implementation does not fill the quality field.
> So when two rng sources register, one with 0 (meaning 1024) and
> the other one with 999, the 999 hw rng will be chosen.
> 
> As the later invoked function hwrng_init() anyway adjusts the
> quality field of the hw rng source, this adjustment is now done
> during registration of this new hw rng source.
> 
> Tested on s390 with two hardware rng sources: crypto cards and
> trng true random generator device driver.
> 
> Fixes: 16bdbae39428 ("hwrng: core - treat default_quality as a maximum and default to 1024")
> Reported-by: Christian Rund <Christian.Rund@de.ibm.com>
> Suggested-by: Herbert Xu <herbert@gondor.apana.org.au>
> Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
> ---
>  drivers/char/hw_random/core.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
