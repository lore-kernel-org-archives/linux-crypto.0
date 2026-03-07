Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7AF82472AE
	for <linux-crypto@vger.kernel.org>; Sat,  7 Mar 2026 05:33:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772861630; cv=none; b=oxMlpaELMWcb7qPOAdjOuGfvyno0SVcCFu21TstZJQYaE9mD57dQt8Lng8qvikXVvZQ1Wp5gokvp/7BgQuNo+jREK/IC0rfm7qLq0nLM7HpRSNZ1/G/fdOka5R3UahZvdmnfFI/XcrrWyHydzFa58glHAMNWX6ERMYmp/0TOwAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772861630; c=relaxed/simple;
	bh=oSqDGTQ2dnYUrdvEaffzeyIezE3Nt8AYydxlgam94KA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NRtGE1RobeOQhFPdAnaIlDDACUNxmPHhzug+4odwbN+mggA6WDYGe/qjYoBkWpIRpP7ibdft7kGyurnhGz1wFzUrdeaGayxLPXdd9Tx3khBmnKqBSEmbKDqOEAqU9StOUSHWiRi19eC8foVmZotJq3bPNxtIbW3vguNkGOGQGks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=Rpm1Ha9o; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="Rpm1Ha9o"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=401+q06X5BnS4f3yYQaxm1yoCl7Y+W716aL/pzddHKY=; 
	b=Rpm1Ha9o/vTsnfKrJgk15Q9fMWeZCMeyLer3DBRi53Uq9ITeuGLgKk5a5gwWKbtsUerys5+RdJs
	TftPp8VDAniCqB3TxPz8+iz0iOsnvCF4b7awUjbWV7pqiptciwSI9DaEQ4ftU8j/7hGcQeWM0stg7
	ocRTpRY2A4lQqJGHm8pDX1HUy5HbG8+yZk/IIgvHLErxR3SqWQdyrALkYzMU9TYDPfZh85LVAxIrj
	ODw1S5NInpnI/bLawvV3uc9n9OEmpL3F3EVxlYBFPvLhtwtOr4uUHPUGJfU0tKm19gbsP1nVGW961
	XOiFSE+oknLadp1ZB0zG6VJP4E0sLG1oAdHw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vykIL-00CJaY-15;
	Sat, 07 Mar 2026 13:33:46 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 07 Mar 2026 14:33:45 +0900
Date: Sat, 7 Mar 2026 14:33:45 +0900
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-crypto@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] crypto: acomp: acompress.h: repair kernel-doc warnings
Message-ID: <aau4ueOfHCBkT8X0@gondor.apana.org.au>
References: <20260225014500.41938-1-rdunlap@infradead.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260225014500.41938-1-rdunlap@infradead.org>

On Tue, Feb 24, 2026 at 05:45:00PM -0800, Randy Dunlap wrote:
> Correct kernel-doc:
> - add the @extra function parameter
> - add "_extra" to the mismatched function name
> - spell the "cmpl" parameter correctly
> 
> to avoid these warnings:
> 
> Warning: include/crypto/acompress.h:251 function parameter 'extra' not
>  described in 'acomp_request_alloc_extra'
> Warning: include/crypto/acompress.h:251 expecting prototype for
>  acomp_request_alloc(). Prototype was for acomp_request_alloc_extra()
>  instead
> Warning: include/crypto/acompress.h:327 function parameter 'cmpl' not
>  described in 'acomp_request_set_callback'
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> ---
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: "David S. Miller" <davem@davemloft.net>
> 
>  include/crypto/acompress.h |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
