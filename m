Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3F53280018
	for <linux-crypto@vger.kernel.org>; Sat,  7 Mar 2026 05:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772861637; cv=none; b=npGaiuMlYXGozKw52j6PFwqNueygZxl2RDUYDaByaOYdKfqwcOQZsGdgUS2eqPXTQGNIQrUhd87IrBF54zjOJjyYrJHTUw3xNV4BNEMl/lKLhvPXd2g3bHaTQqmj3jdfKbfNNRf1AEPxstJK+t/JDUuyrRRAQlRm2B4HYYU0NeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772861637; c=relaxed/simple;
	bh=W5qY/C6xNresVnqUwHXVV1gHkj0of1Juu9zSaeNZigI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V6jdPyCh22Jiryt/ggPf2uQ3qfLwCf2nqsCDFeGMHg+ElECIKKZ2+RntHXqBwDuvBBw+Cv0hCIHbQc0vwXyOwYu3tfm2DlXAdVZnpfrjHHqsstDCmBXueqZMJYOpQKw253m+pbBfDDae16AZ7NTX7qzbN0Nj7y+0DFxD255mlmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=MLn3cPf4; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="MLn3cPf4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=d/1gv7DbquhnLFmd1t9DEhHgcaGnuD+ggt1eLc09gfQ=; 
	b=MLn3cPf453UwyXYtlXq9M+kGSCMpcYyV5avzVgNeuiW+oBjTGaDgOwB/WJmAzLKjjcrToeTBkQS
	6FE2xmqEuWCbbP/8jaCI5HHb7eKJyXPsGDd03qAwQRu5MU+bGINwpyJtCX0TobAqVlyhzqjpxi7gz
	+rFgvi83liKfeZxZ5FxQdh0cN1Yr8oWgUC9vbDSKXqb3nMBH94qvApmArn5a8L7PMtF3Q6k2TFG6+
	te5dXoLnUViRzXXjGeYYMumQLQcr3ZUReEM7AITIB/F/IXheutuwXNzQdYQjrqIavkAJD8XaMrPbp
	k7AH3EIYPsYVzBC5AMgC3BnU0w8yBSkxvxUg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vykIS-00CJae-1Q;
	Sat, 07 Mar 2026 13:33:53 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 07 Mar 2026 14:33:52 +0900
Date: Sat, 7 Mar 2026 14:33:52 +0900
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-crypto@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] crypto: des - fix all kernel-doc warnings
Message-ID: <aau4wCD_MBS-sbuo@gondor.apana.org.au>
References: <20260225014518.43720-1-rdunlap@infradead.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260225014518.43720-1-rdunlap@infradead.org>

On Tue, Feb 24, 2026 at 05:45:18PM -0800, Randy Dunlap wrote:
> Use correct function parameter names and add Returns: sections to
> eliminate all kernel-doc warnings in des.h:
> 
> Warning: include/crypto/des.h:41 function parameter 'keylen' not
>  described in 'des_expand_key'
> Warning: include/crypto/des.h:41 No description found for return value
>  of 'des_expand_key'
> Warning: include/crypto/des.h:54 function parameter 'keylen' not
>  described in 'des3_ede_expand_key'
> Warning: include/crypto/des.h:54 No description found for return value
>  of 'des3_ede_expand_key'
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> ---
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: "David S. Miller" <davem@davemloft.net>
> 
>  include/crypto/des.h |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
