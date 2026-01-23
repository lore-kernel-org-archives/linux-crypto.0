Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9797834BA3B;
	Fri, 23 Jan 2026 05:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769148000; cv=none; b=OuVkoq5YqojO1o/2rDah0mvuKJDT8v0XKk9t1SguG5O+YJg173cOvQTVCboe/CX4kuhmB5+4Ug1a1RSiEnkMV2LRBwaN41MJxD2G0mjbj6Oik25w0da5BcCqXGCqPjCkAiQL1vRjN1pYzafU7SBN+0CLSeMiQtidOAiqoH1Ho5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769148000; c=relaxed/simple;
	bh=PQsya/tQi2WoCuD6sv6tkhG6f2z9Ju+fPgjCNT6yFKk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GoVNNeI3ltwt0p/GSdccr4GQMsQtFAoGHFFkA3sR8FxKA93yoH240RHNgVhIPG0CChRfireIGH+qBjPQvGecB9uz5p3qAAETEmqLT7ic+cMNZ50AinYQLN9wv8jdEBVhFBw8WpRERKoErdHrajAefby7NUQfEQg6oN0adBCwKQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=jvZ/Ou6c; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="jvZ/Ou6c"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=oLUWXUHo5Q/GmBrApC+e/MrzWDT+tmgwBy88fymy8h4=; 
	b=jvZ/Ou6cZ8VQ2jLiwnAcGfCVe8LX2Vv50ho5wWfvf49+xLbAwhB1I8DtCrWH38mmKwPjOPp//ey
	isfPgJlA1HF0+l4K4931Y9XRnQolxGBVtUVbne3/yTU+xVKWlFXo9Vx4OZHsdkveFjWA0RbRK6/U9
	RG80592jE7FL1lPAIC698eJf9ZvXvMkCEHHYbuSUf1qodiNCl/k3TUdiNi80rR9ykpujDRhNgo8/0
	nXF8ZIyN4sblCrhOApGDZbcz7MRzshdg5vf7/X1AWHMZypIB2ACWybr5ZJBJSbDsVXrhhqp7W55ut
	9o4ItGEmizPC04MVdoyvGtlCwtgbT4BlzTXA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vjACn-001VPJ-00;
	Fri, 23 Jan 2026 13:59:38 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 23 Jan 2026 13:59:36 +0800
Date: Fri, 23 Jan 2026 13:59:36 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Aleksander Jan Bajkowski <olek2@wp.pl>
Cc: davem@davemloft.net, mcoquelin.stm32@gmail.com,
	alexandre.torgue@foss.st.com, linux-crypto@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: testmgr - allow authenc(sha224,rfc3686) variant
 in fips mode
Message-ID: <aXMOSCt5Yzfk8vTI@gondor.apana.org.au>
References: <20260101152522.1147262-1-olek2@wp.pl>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260101152522.1147262-1-olek2@wp.pl>

On Thu, Jan 01, 2026 at 04:25:18PM +0100, Aleksander Jan Bajkowski wrote:
> The remaining combinations of AES-CTR-RFC3686 and SHA* have already been
> marked as allowed in 8888690ef5f7. This commit does the same for SHA224.
> 
> rfc3686(ctr(aes)) is already marked fips compliant,
> so these should be fine.
> 
> Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
> ---
>  crypto/testmgr.c | 4 ++++
>  1 file changed, 4 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
