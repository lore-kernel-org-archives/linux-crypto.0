Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8A8D3CC9E8;
	Fri, 15 May 2026 10:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778840333; cv=none; b=ZEj2eR6vLdlmuk9fCxlGwpNRmsS16hxJQc4QtnPVgKgshgY914qfL5LC1KArAx9vYsrOFdeGdyrete526Q7y7jyNFffXXNgvHRJzrGS5qgO9rOnz77FD+ZNIs6+3ZtXO7ACI8myF43J13uhV9B7hAPgL+pBJimuyVsjXM3Mgl7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778840333; c=relaxed/simple;
	bh=estsdPkGQF63VQ0ywPg2VlGT3TZ0lvY/MAGYh538h8g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Py6GYFmcpAPS/Jk7zBrWYyow4Yj51+XfHgyxcgzlFU64nyf6BESJVnVhZFmShSEbLrHKJTIfczfPx7PkkFRoDFoiL/3WYzU+Hdxu8skS44gwJp+wNfz926cEmgZo+YaxQBSlvnyB4T5mcJmw2PypsxUP9o4Kk07spmE4e6PqpOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=R9kdrxId; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="R9kdrxId"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=10pZOv/auosoZB1ndrwAch7s/xEh5cPcq4qG2XwrhLo=; 
	b=R9kdrxIdz6V1lvpwsHHb2WFPvaOVJErbaeIxGL8pXRtZAAQ0WoV9fNp8iC6OCW1dKnDWzvrSsu2
	SOKucodg0YWNlSARbHDNmA9aXSfwzwha17DqulQTuD+izq42/0AjhjiZGr3Q3eZTCm/Kg00Z72ARj
	v++OwjYU2o67BaDfoWMIUykFkiNLZM+RJcPCRfMCf7zQCa1TKHW2NzheZxV5RGMkHy6isx/YOJfLA
	VNANPzkquu2uavPZLCIc3ndPuVVtotXNhbF47VB/NUrWPRnjBexPJKzFcUriA0gIXOC/rIly0HK0a
	z5OuiLoY5n2gzsey6vaORNzGEmL+CquntrqA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wNpcv-00EOPo-17;
	Fri, 15 May 2026 18:18:42 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 15 May 2026 18:18:41 +0800
Date: Fri, 15 May 2026 18:18:41 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Aleksander Jan Bajkowski <olek2@wp.pl>
Cc: atenart@kernel.org, davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: safexcel - Remove repeated plus
Message-ID: <agbzAU8ikJlM-6zG@gondor.apana.org.au>
References: <20260504173250.751589-1-olek2@wp.pl>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260504173250.751589-1-olek2@wp.pl>

On Mon, May 04, 2026 at 07:32:47PM +0200, Aleksander Jan Bajkowski wrote:
> Remove repeated "+".
> 
> Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
> ---
>  drivers/crypto/inside-secure/safexcel.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
