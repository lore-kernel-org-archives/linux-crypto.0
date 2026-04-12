Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE7CF258CD0;
	Sun, 12 Apr 2026 08:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775983837; cv=none; b=VlSMAxlaf+UGDtSQWtgXuqMwJERGc2cSbX5K5OHasImdyZfvrvQ29GJypf983aVS6dDv3/DgPDtoVsgEHF7g6pIPwcBhE2x5tCXZC0OKRh88zAHKqa50KQzI5P2IhjZHFI2MerVqT+ji+d9VyjP7/D1YckZuohBlxB55zLqj8TM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775983837; c=relaxed/simple;
	bh=/fmU5zOVQBJ+rZCjKqynNobyDEsvFblCE8VDVfA4of0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RsugyJ09gk+pCVCUvFvGjpRr/RepFLhTZf8hy6JrAoXrWqzlWjvyUoMbR1IKfWrWF5ZEVpT3paJNquJ0Gd1J0sa0mSqQ0P1674ILqhnH+UocCcI7Rkl7jFSJ2qF8bvee5U0fyQXfTh9oCFbJ7FSuKZFpmvTPLJ6MrUqPAqHAQDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=cVmDrF4z; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="cVmDrF4z"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=E4RgOiL/638KlhyxgpKe98aPbuCcn9RCJVgDup0avGk=; 
	b=cVmDrF4z6V9JQHnIbmfzyqLTnRelPy475ZDNSL7PoviLV7hS312t9hBO8jniDmNNkSKu1bGA1jH
	GP5XKmhiAmcJ9GXmBok00A4kxNryzLYp39FoigJOpPWkm02Hi9nioh/tRrRuRKs11kbkl3uRG4a4w
	9iddgy4wKlE3O2v++J0AE6na+YkahIfrofXgAilc1aBmPHbgAB8X49PYHuNByaskud8CT3b8CdwgE
	wKJdiw1WFG/xh8U8swDlhXcIUl/XBMgVRMYQ1P5SIUKhs4c32HzZZRhK+f6sjqjkkecGfbTfQD1up
	59y3edkDVuzB6KjdiBYAE+cN894myKWKZFMQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wBq6x-005UEe-26;
	Sun, 12 Apr 2026 16:50:27 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 12 Apr 2026 16:50:26 +0800
Date: Sun, 12 Apr 2026 16:50:26 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
Cc: gilad@benyossef.com, davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] crypto: ccree: fix a memory leak in cc_mac_digest()
Message-ID: <adtc0v9KCWbphJUn@gondor.apana.org.au>
References: <20260330033402.2758074-1-lihaoxiang@isrc.iscas.ac.cn>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260330033402.2758074-1-lihaoxiang@isrc.iscas.ac.cn>

On Mon, Mar 30, 2026 at 11:34:02AM +0800, Haoxiang Li wrote:
> Add cc_unmap_result() if cc_map_hash_request_final()
> fails to prevent potential memory leak.
> 
> Fixes: 63893811b0fc ("crypto: ccree - add ahash support")
> Cc: stable@vger.kernel.org
> Signed-off-by: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
> ---
>  drivers/crypto/ccree/cc_hash.c | 1 +
>  1 file changed, 1 insertion(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
