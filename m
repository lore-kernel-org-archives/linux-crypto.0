Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6878915A4A2;
	Fri,  7 Jun 2024 11:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717761332; cv=none; b=lSqOCWE34PIFfdZkeKxOtk1CtFkimH+HHhL9rOE0vUA8mi9HINqWVahnKYD/Xbr2NO1EDS9fp+xWSpLNl9QCDyge9WUbpbmJ/2LlS4yIgIv4XnfGPlu6K48WdiH9PA0Ca3smMnDxaVqLwPhVTeWy/nZVCnvGZPanM5nAtQBaIKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717761332; c=relaxed/simple;
	bh=wetSO9VDWUT8n731lexWlY9oqskmjMj41pxRcj/o/rY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cu9U7TDLtQ3LrKqHo9PXMTXDfm3PbzMHo+9QdgXfpftwqA4L8qv763F2lxuyjt46euv3I9mLdHjmmpx1iEvA3BiHDviE2jFm/Fo8jmCTPN1P+2Og+3kyW8fh2Y3as2my8SD1l7TVstDPL31MfBE5GX+TzYAbQph0eUYicRhp2ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sFYBk-006pDz-2u;
	Fri, 07 Jun 2024 19:55:21 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 07 Jun 2024 19:55:23 +0800
Date: Fri, 7 Jun 2024 19:55:23 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Stefan Berger <stefanb@linux.ibm.com>
Cc: keyrings@vger.kernel.org, linux-crypto@vger.kernel.org,
	davem@davemloft.net, linux-kernel@vger.kernel.org, lukas@wunner.de,
	jarkko@kernel.org
Subject: Re: [PATCH 0/2] ecdsa: Use ecc_digits_from_bytes to simplify code
Message-ID: <ZmL1K0xhM45Cd7z1@gondor.apana.org.au>
References: <20240529230827.379111-1-stefanb@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240529230827.379111-1-stefanb@linux.ibm.com>

On Wed, May 29, 2024 at 07:08:25PM -0400, Stefan Berger wrote:
> Simplify two functions that were using temporary byte arrays for
> converting too-short input byte arrays to digits. Use ecc_digits_from_bytes
> since this function can now handle an input byte array that provides
> less bytes than what a coordinate of a curve requires - the function
> provides zeros for the missing (leading) bytes.
> 
> See: c6ab5c915da4 ("crypto: ecc - Prevent ecc_digits_from_bytes from reading too many bytes")
> 
> Regards,
>    Stefan
> 
> Stefan Berger (2):
>   crypto: ecdsa - Use ecc_digits_from_bytes to create hash digits array
>   crypto: ecdsa - Use ecc_digits_from_bytes to convert signature
> 
>  crypto/ecdsa.c | 29 ++++++-----------------------
>  1 file changed, 6 insertions(+), 23 deletions(-)
> 
> -- 
> 2.43.0

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
