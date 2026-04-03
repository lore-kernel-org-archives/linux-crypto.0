Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE22227281E;
	Fri,  3 Apr 2026 01:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775178244; cv=none; b=fo8P+xe8BMUH1bw8wR0YGgueaNUQLypk41ywTA+vgtMt565cI1lMVaX2Dm9Kd28eC7HPhTxk3ApnBCEyMywTZWuC7DgnUfVtXmumdONx3C3Rs9MMFW/mcxs98DgiHWaIGUx0JBcVE+sKOtAp02B9JBKLE/8NVWW7oFwqpGPZ5VE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775178244; c=relaxed/simple;
	bh=28gWX1qbzonK2iM9+i58Tp9r2QU/wtJNMFr4R5LuAZE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fvk4BT2XLLv933vlHkzUxXOb+n5GvfO/5VRHkN5mi+a50GB6bm6wSZRn19EaFd44//vAhAU7qfu5Flpk4GYkss4QGtbV1TxKPYznhmJ+3MIxusmYRVV4HasA+3qWZoBF8Zj0vpHyfTEGH1/y0JDcvRx241hA079W+oWKob/bnU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=D055EPFQ; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="D055EPFQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=tbaviXLjg0PXUVsUx5hA4y/b5e3bQMUImYlqsY+pT7A=; 
	b=D055EPFQQkhWp7k6WFgpKQETFl/AXbjDVTpyr1BDzOFKyGDXbX4fr38kfFb2XzH9gKzj5vWPKFS
	ViTYUzsJgJsRzjFLnUvBJiTeTep/x/m90kRpZLOMaiGLupVqC29Cb7uzU7x0bYYBnUB554TZBH/8U
	R0EOCX/tM3CvFTfTfEcRa99UeKG76R/vj2e+W8brS2JDc3UsmVkjrqzV+acZN09wA6UfVknwOlaaq
	YC9XirJ12psWLTadLFWNmCBNKeOqySiiTEYKjwlFBI/fL6xX2VjUQ8wuzPwjRh0IdF2uj7g3q/uHw
	bSI9TIL2ZcOl51Kxb80ztjXXwEIWgoDrMe4g==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1w8SXV-003Qxb-21;
	Fri, 03 Apr 2026 09:03:53 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 03 Apr 2026 09:03:52 +0800
Date: Fri, 3 Apr 2026 09:03:52 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Tom Lendacky <thomas.lendacky@amd.com>, John Allen <john.allen@amd.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: ccp - Replace snprintf("%s") with strscpy
Message-ID: <ac8R-G95NgMnlzwa@gondor.apana.org.au>
References: <20260324113006.95171-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260324113006.95171-3-thorsten.blum@linux.dev>

On Tue, Mar 24, 2026 at 12:30:07PM +0100, Thorsten Blum wrote:
> Replace snprintf("%s") with the faster and more direct strscpy().
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  drivers/crypto/ccp/ccp-crypto-aes-galois.c | 6 +++---
>  drivers/crypto/ccp/ccp-crypto-aes-xts.c    | 6 +++---
>  drivers/crypto/ccp/ccp-crypto-aes.c        | 5 ++---
>  drivers/crypto/ccp/ccp-crypto-des3.c       | 5 ++---
>  drivers/crypto/ccp/ccp-crypto-rsa.c        | 6 +++---
>  drivers/crypto/ccp/ccp-crypto-sha.c        | 5 ++---
>  6 files changed, 15 insertions(+), 18 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
