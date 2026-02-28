Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB3F53E95B6
	for <linux-crypto@vger.kernel.org>; Sat, 28 Feb 2026 08:41:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772268096; cv=none; b=B0PvMNOJlFneWYV94HqinHTwt+VMbUPyIlukH9/CFfa7seX/KO9uQGnHaZ2EBvzaZAxBzR4kSg6GRXBQdbHJcFuwy7O+2PyKjSq8zyfsY7bV0z6Xm5mz/9RE1V4XQvEwsZEpTn+5ZGvzEBkDLAla2/BgfWtahKpIwvmwzIMgfgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772268096; c=relaxed/simple;
	bh=h5SQyBiJsUFRC0WzBjBqA3fNqD30TkaBtvI8FZB9Z3g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GzuMZ8gg+Hu9awkhsDO0ym0S1Zhq9yFFNNeDz10Zt9qaMIxWx3ECBxdvvIJvEYjALxAStF+YaOUWFHUk5MAAxhaqCbZlPBaD7GWYQUIRFZ6yi1jDEfEBNjZ4q6f2kePdyJJRgKUwpIadP82T4r9NCgyb0cBdYFoKVhjByqgB7PQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=SI9pmrmu; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="SI9pmrmu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=lkYifvfXKRVdgYb8NPXREQxR5YK/1Q9ocsKi9yC5ZeM=; 
	b=SI9pmrmuPEpwloTMotyH/k4bW5MNBmgMvSB0j8UCfo170e8E0qCyZ3R3glt64+1HBj5QSjZM8Zu
	KIPEOzh0DAUnOarhTMXjI7+Oum0PfRxQhxWrXG4ruKIA8ulaTxoH9QnAkg8ClvzdnsLHDBpvfX2ob
	F7fMuV5o72jdkuFzLxpmX/MTZ+ftVCKiWM28lTx+bHQqwrzsBnqXPTZzX0g/0SORJKDvh7EWML/+O
	J1iudjWs+0YzBMvSZ16MTv/2SOBwxR8hhi2HrHkB7faBuB4MZO4PZszMHmCJ2l5Y5qodBP/XmjUwM
	N1IPzM42fjq/3bS3ohktBqssWEgaIPjavakA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vwFt0-00ADl9-1y;
	Sat, 28 Feb 2026 16:41:19 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 28 Feb 2026 17:41:18 +0900
Date: Sat, 28 Feb 2026 17:41:18 +0900
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Aleksander Jan Bajkowski <olek2@wp.pl>
Cc: davem@davemloft.net, mcoquelin.stm32@gmail.com,
	alexandre.torgue@foss.st.com, linux-crypto@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] crypto: tesmgr - allow
 authenc(hmac(sha224/sha384),cbc(aes)) in fips mode
Message-ID: <aaKqLk9U1wcqxbea@gondor.apana.org.au>
References: <linux-kernel@vger.kernel.org>
 <20260206192732.478178-1-olek2@wp.pl>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260206192732.478178-1-olek2@wp.pl>

On Fri, Feb 06, 2026 at 08:26:59PM +0100, Aleksander Jan Bajkowski wrote:
> The remaining combinations of AES-CBC and SHA* have already been marked
> as allowed. This commit does the same for SHA224 and SHA384.
> 
> Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
> ---
>  crypto/testmgr.c | 2 ++
>  1 file changed, 2 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
