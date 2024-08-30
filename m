Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 086E417B501
	for <linux-crypto@vger.kernel.org>; Fri, 30 Aug 2024 10:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725012790; cv=none; b=j1qFbr2HgrT3u2huSWrFSrtMuaxbiWQLKXsTmKQIq7ClHn1euNs9PY3bxFl+yTnW6F8GQ5kueTeygyRe7DVyyoL0uqishh4skYCFvZU73Z/is1f3fD+sPWqAy4D7R4RLpn9WSxX2HX8hobTPvCVd7RWvWFP28Zz/VAYzcZMToaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725012790; c=relaxed/simple;
	bh=vhoCR+tpJmpO6136ArDQleKkr4KjVFNmdnMhgfRPzT4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uoQQK2ErHbc0GzwWIy7RGg00wXkn/393IzBfLe/oOEJTmR/0EsJgtmgFf0GIzEWuKRKJq8ZwSGn8wpr5U2nMIYYnIKDlhNl5I/WiEEYaMw+dvLzXxFuGJUbygf0iWtzjk5Y95M54nJJuvsluHHhK5lDU+HMH6ctwOgEuux5hw50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sjyUG-008UBa-2l;
	Fri, 30 Aug 2024 18:12:58 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 30 Aug 2024 18:12:57 +0800
Date: Fri, 30 Aug 2024 18:12:57 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Hongbo Li <lihongbo22@huawei.com>
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org
Subject: Re: [PATCH -next] crypto: Remove unused parameter from macro ROLDQ
Message-ID: <ZtGbKYhHXQWBQbbM@gondor.apana.org.au>
References: <20240823065707.3327267-1-lihongbo22@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240823065707.3327267-1-lihongbo22@huawei.com>

On Fri, Aug 23, 2024 at 02:57:07PM +0800, Hongbo Li wrote:
> The parameter w1 is not used in macro ROLDQ, so we can
> remove it to simplify the code.
> 
> Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
> ---
>  crypto/camellia_generic.c | 42 +++++++++++++++++++--------------------
>  1 file changed, 21 insertions(+), 21 deletions(-)

I don't think the churn caused by this change is worth it.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
