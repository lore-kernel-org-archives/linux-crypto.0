Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C579E233134
	for <linux-crypto@vger.kernel.org>; Fri,  3 Apr 2026 00:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775177722; cv=none; b=IdWuXgOWLT2tF2GRFgJpRIbhHb0jBvyoUpBAktErFJEkAzh8uVicRiZe45E3DunzR5PAS+dNjbdQXmusPYqPAGsbO8526un5D/w4BLA1qXVlf5uNDmZX/rCqRhdNmWnN1BNNN3v+v5r9SQfv4OA1PAEo/MT2Ullo5ZPxcW5arxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775177722; c=relaxed/simple;
	bh=8XSfAfxNuW+TXaeqBkfQU0yzF6Wb/cu7osXOGgDzMtE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Lbgk4rMhPkz3rnMdBc2pL57tb6+SFcL4HyYG2hxzB8i9uRvCe+qwSAIDjYupbbM7JKh9sb8eoV5ZRHtfwytUHSZZ8yZNHdKZSpYdHot4Hq4MX6zh3eYw3/jzLS3sV6FSLLOzOGVRkBeOOFjT03R7A4ger6t0ho8z5JeTuJJB0BQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=Dn3Vi/Us; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="Dn3Vi/Us"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=pvnUOnltIT5QkRUcioKpnyjBxk8ZJhpYwrWtkhgyC4Q=; 
	b=Dn3Vi/UscYigbqXSeG5+Ia+aFeEFzxd8kBNpZsOOzShrCyRXHIvqWyU3rAgkWXplG9DBOtIMQic
	jAX9M3ppAeH2X7FNiiJGBs4Xt478HETNU4t0sJqo3Z+g8pGXFsfeIFg/S05Zv7g6mIL9vrk3sPxvS
	ns5r/DIEcqlZ3cqdiXAgkOmR6N1L7aGL2bnflfZIHDKLX39jOh36sOMLvwp24yV7oWkkmmPRm5bYi
	ENPaUKwyN67wAE5reJo/NpespT7kLpmtgGQ9dG1j++q+AMAgpLtAfZUWS83V4hGuseEy2OwdFbsQs
	Zahp7JBYaHQ2F9Cy2YBe4TG7scOTiOfl8K/g==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1w8SP9-003Qs1-2z;
	Fri, 03 Apr 2026 08:55:15 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 03 Apr 2026 08:55:14 +0800
Date: Fri, 3 Apr 2026 08:55:14 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ren Wei <n05ec@lzu.edu.cn>
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net, smueller@chronox.de,
	yifanwucs@gmail.com, tomapufckgml@gmail.com, yuantan098@gmail.com,
	bird@lzu.edu.cn, ldy3087146292@gmail.com
Subject: Re: [PATCH v2] crypto: af_alg: limit RX SG extraction by receive
 buffer budget
Message-ID: <ac8P8tcqzxATISXt@gondor.apana.org.au>
References: <20260322141516.283737-1-n05ec@lzu.edu.cn>
 <7094f2ac73594db6f240466220a0fb8fb85b898b.1775051536.git.ldy3087146292@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7094f2ac73594db6f240466220a0fb8fb85b898b.1775051536.git.ldy3087146292@gmail.com>

On Thu, Apr 02, 2026 at 11:34:55PM +0800, Ren Wei wrote:
> From: Douya Le <ldy3087146292@gmail.com>
> 
> Make af_alg_get_rsgl() limit each RX scatterlist extraction to the
> remaining receive buffer budget.
> 
> af_alg_get_rsgl() currently uses af_alg_readable() only as a gate
> before extracting data into the RX scatterlist. Limit each extraction
> to the remaining af_alg_rcvbuf(sk) budget so that receive-side
> accounting matches the amount of data attached to the request.
> 
> If skcipher cannot obtain enough RX space for at least one chunk while
> more data remains to be processed, reject the recvmsg call instead of
> rounding the request length down to zero.
> 
> Fixes: e870456d8e7c8d57c059ea479b5aadbb55ff4c3a ("crypto: algif_skcipher - overhaul memory management")
> Reported-by: Yifan Wu <yifanwucs@gmail.com>
> Reported-by: Juefei Pu <tomapufckgml@gmail.com>
> Co-developed-by: Yuan Tan <yuantan098@gmail.com>
> Signed-off-by: Yuan Tan <yuantan098@gmail.com>
> Suggested-by: Xin Liu <bird@lzu.edu.cn>
> Signed-off-by: Douya Le <ldy3087146292@gmail.com>
> Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
> 
> ---
> Changes in v2:
> - keep the af_alg_get_rsgl() change minimal and only cap seglen by the
>   remaining af_alg_rcvbuf() budget
> - fix the Fixes tag to point to e870456d8e7c
> - reject skcipher recvmsg calls that cannot obtain one full chunk of RX
>   space, instead of rounding the request length down to zero
> 
>  crypto/af_alg.c         | 2 ++
>  crypto/algif_skcipher.c | 5 +++++
>  2 files changed, 7 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
