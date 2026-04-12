Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56D4627470;
	Sun, 12 Apr 2026 09:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775985429; cv=none; b=UCtdxUd3d/uqm1KATHiHm4XuYJu31PwBEWkYbDF7W6QaS+8OfAelyjd1ZP2zIDilOttZJ/e3L3GBOWa/n9UULSD0OsWqUZvAAtm5N6cGMZWJHByXHVEtn6PRbvUMnARdZjR1tv7+Ns5i/JbLbdAEuL+HAh2okKXeKMM7Y0JiwgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775985429; c=relaxed/simple;
	bh=lYfrKxXfmsYkXIZN7tqXMGx6Wd0BabL2Hd7HrE+n9ZM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gIsxw2jmBbySBu/zvfufPSq0aOlA9t3L/eZSe6ihe6xLwlMesUM7xqZWyBigdbIZjj1Odp9C3s5kHHLrCQglaJTyANvCcajSoA+q52ytqyqisBhRtDeFBAJ3pWzgVk4c217crBO/ru4e0hmp+NfuB4kwT9C/k41sXusj7N6UspY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=MpcrMPe3; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="MpcrMPe3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=zslX7DMvczK4LWISNjCiANQf0LDXZmIYpqHfHcLe1IE=; 
	b=MpcrMPe3ScwvQJXly2skEDH6NUAN8jxYWedOjsP501VjRg8qbkocwQveysW4rQ5b0SfYiEV4pdn
	fvsryRymCh7HY1VsfSuhpr67fll+LBL08oPR+LVKc/mdxhKT3km1QeWz8rDs0qXezAFLL0V0D/tyn
	hbFrAfQoaMalNMY8al0B7HUAtYP0iCTGL7ZNgSmLwm3KrZOT5rbRDX/lM8Vg6XV2fHyLQpFQr+la+
	KLqqUpnH4DMQPAUy8+QxU7mhDdObFpj5g1OkPiIopWOwLkp7snGlqTz9awlD8uhZKlSvgEsAQmwLP
	Dhy0W5h8IBFTrLIy3jmfKJ2xOR4VbKZHcJag==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wBqWh-005UVS-1H;
	Sun, 12 Apr 2026 17:17:03 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 12 Apr 2026 17:17:02 +0800
Date: Sun, 12 Apr 2026 17:17:02 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: omap - convert reqctx buffer to fixed-size array
Message-ID: <adtjDuprvk8KwcSV@gondor.apana.org.au>
References: <20260404101017.936076-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260404101017.936076-2-thorsten.blum@linux.dev>

On Sat, Apr 04, 2026 at 12:10:17PM +0200, Thorsten Blum wrote:
> The flexible array member 'buffer' in 'omap_sham_reqctx' is always
> allocated with BUFLEN bytes. Replace the flexible array with a
> fixed-size array and remove the now-redundant 'buflen' field.
> 
> Since 'struct omap_sham_reqctx' now includes the buffer, simplify
> 'reqsize' and 'statesize' and use an offsetof-based memcpy() in
> omap_sham_export() and omap_sham_import().
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  drivers/crypto/omap-sham.c | 21 ++++++++++-----------
>  1 file changed, 10 insertions(+), 11 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
