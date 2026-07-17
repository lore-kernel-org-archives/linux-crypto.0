Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D9763DCD80;
	Fri, 17 Jul 2026 08:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784275975; cv=none; b=LOPGThRUuLNO6/2gqIqRXQ7F3wpadauwQQF8D4wIfHGweRH54myZbdxABCJihHElNzvsn1zJxY56J6N36LPUmzb4DEOhvNuYsXO+aleujui5gysMPMKIQmN8eB3hMgSus8Cs9R3y8eVzfFTBCZEXm5+a7OaT3N4333Gk+Ggyk1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784275975; c=relaxed/simple;
	bh=S/pUPjjFEluO8UlpIkXELPP5I9K6Xq89F12zWkSvEzg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tZrmlFHg4sTLshL0hXX2/B2c0CX1G66VTJ99Wq4/sjcLpjaXgKftCMUPyLMYqxs0ozQgcicBLQGhI+NxXl5Yx2893J0aRZDkoA9f/tsjx4LteaNdSvv0DeJJYPJ+h9kVxaqxs7hAzuTeeN/JBNDv9csflq4QxhQbXcZloV3Y66w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=Pr1zF9mw; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="Pr1zF9mw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=K62uW8vQtw/8uDEh7X0bvTQ8tmP4Jr+IwUjh+D1hffs=; 
	b=Pr1zF9mw3mPzfKzZ4ZWntzyEJ305ITPFp4O7KLCvqqcsttSe2DzgaHBdSNb8JrLucRGKNHrLHy4
	uPBwYaLjexEaqrxr+TNplbOcGN+JPJXwswKcNlQJ6JGYcWUetIfTPDRN4BHNufYtv5RAgH01DemwP
	4LoHcutNioFzSnfxYny/pIEwLdfZ43O99qOZa0SrnzT3ZNhjH1ieW6KedKIjLs6gmwcAtDRPznW/n
	55mMXgLo5ulR3bzga3PZnUTYTo87bTYJQC/Zm3gJpZNc4U9bmQ1fcwkOjOe7gaRqFPxwERngVkIzb
	INPl8mvt3OhhRBpOFiwN3MhDhAFm4YgZcBSw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wkdgc-0000000EO4B-2ZQr;
	Fri, 17 Jul 2026 16:12:47 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 17 Jul 2026 18:12:46 +1000
Date: Fri, 17 Jul 2026 18:12:46 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>,
	qat-linux@intel.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: qat - use strscpy_pad to simplify
 adf_service_string_to_mask
Message-ID: <alnj_iYq7ANdeHPv@gondor.apana.org.au>
References: <20260705133842.241401-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260705133842.241401-3-thorsten.blum@linux.dev>

On Sun, Jul 05, 2026 at 03:38:39PM +0200, Thorsten Blum wrote:
> Use strscpy_pad() to copy buf and zero-pad any trailing bytes instead of
> zero-initializing the local services buffer and then using strscpy() to
> copy into it. Also use the strscpy_pad() return value to detect string
> truncation instead of checking the caller-provided length.
> 
> Remove the now-unused length parameters from
> adf_service_string_to_mask() and adf_parse_service_string(). Also remove
> the redundant strnlen() call in adf_get_service_mask(), which only
> computed the removed length argument.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  .../intel/qat/qat_common/adf_cfg_services.c       | 15 ++++++---------
>  .../intel/qat/qat_common/adf_cfg_services.h       |  2 +-
>  drivers/crypto/intel/qat/qat_common/adf_sysfs.c   |  2 +-
>  3 files changed, 8 insertions(+), 11 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
