Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05C572D1F6B;
	Tue, 18 Nov 2025 03:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763436224; cv=none; b=shFCvXlm1ivjZTxERD26/p8LtZmgbm4+0RkycWGgerh16o7mxoKunigDSB3WGJfoe2C1rKTuLqJz2GX96FJo4nYsdgBMIoGv2Nj59++yJT8LSdgV34zeZ9ozupFjOCzSdUd2jt3Dya/Qw3z8K8CPVGuVr6Nv7uMS2ttrXtUouIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763436224; c=relaxed/simple;
	bh=EYBmIR3V37R2AdJbStrc8c+A8fnJHMSbIYWrcxBVsM0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DsudDgHQjXxGmskdikivIoR3P9Q+zrZsuzy7eJGU9Jfj+rAy4xRMOPOcr9Iw7irRfYv9Od6YmjiJvwRYiwFtFj5p39kpORshfQHxRIEJf8zVaR4vtmIRmjXT0WRWqhs7krHx5NOKePVDmg+ZQ29PqfMYJRY1Bj+JW1ojagRbHRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=NlXZEcS9; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="NlXZEcS9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=wjbxku3jEYUzophf5j9dnZVtgiAgPPqnEntMw/OYwP8=; 
	b=NlXZEcS9MEYr93yrm/mgP1EEB2NfB+Jo6TQf65dPW0waijFMjk+S+hmjEte+OKap94LdOeoH+D3
	daMQA53S3RaOs8l8hvNtXIYU21ETfOz/fNarskBJkrDCcqWb2DBkVvq+IPA2KIJ1SGR05FUBCQGZF
	rkhbJcfcf83wxxF396ofTAFd2BxFGlcnH925y1TiwkXZ9SB/FBOBKOwj9WJXN3YRAKQE1kOqgxB3y
	/T60VHNYfiF6Euw8yBnZsJDUFE/SnAdXSAXQxei6YpCVmPnx+EG4yaow85WDKIhI3DxwBpar0CISB
	jGZNFR96QNzsKdA/mm4GNtMKGyf1xkxMCUGw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vLCJS-003uLI-1Q;
	Tue, 18 Nov 2025 11:23:27 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 18 Nov 2025 11:23:26 +0800
Date: Tue, 18 Nov 2025 11:23:26 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, Colin Ian King <coking@nvidia.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/2] crypto: Fix memcpy_sglist()
Message-ID: <aRvmrtvwVju-mMI9@gondor.apana.org.au>
References: <20251115230817.26070-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251115230817.26070-1-ebiggers@kernel.org>

On Sat, Nov 15, 2025 at 03:08:15PM -0800, Eric Biggers wrote:
> This series rewrites memcpy_sglist() to fix the bug where it called
> functions that could fail and ignored errors.
> 
> This series is targeting crypto/master.

While this is a worthwhile improvement, I don't think it's a bug
fix.  The only error that can actually happen is if you call
memcpy_tosglist from hard IRQ context.

Since there isn't any such usage in the current kernel, this is
purely an enhancement.

So I will be putting this into cryptodev and not crypto.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
