Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C401A3246FE;
	Tue,  5 May 2026 09:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777973346; cv=none; b=JrOB3UMHwHPVmfzOGp6icSt5OHhcmQG478UtRXAh5xjVwO8mgB+irj+1UkJNgLEyMKnnjKWh7E3eHnTbkJ2CzovcP7wP9lculYqRnzPTvsS+cHblaLIsjDH70hMUPou1+40U3Uj40qaGasHetv3+7u/nu6E/uJA+YwNiJjF0xtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777973346; c=relaxed/simple;
	bh=KKRid32cyUA3OHXzKwft0YJO9BLjQwyJR7HUMJSey7E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=taQ/iJa8Ab6vDmUgMqLXnsHakfsdtXqO3P0iJ6UdzrXy4Mr1IkROIgTWD1MkHU6zHoBcraXDUXjafEGdYmDmsihAMfTC64NDwOb6gS0saOsJT4yBzt0O76HuEt/WSz5IjwTkn48cn8FKADn7NBDXoxO8U+aoYBn1+yqBYlAZ36c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=P+2psbiF; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="P+2psbiF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=LhwT1MF4l60lU1sel58L8VahblH5TSOgO3iDXh6wzbE=; 
	b=P+2psbiFJkrVF13Tvb1M9IfpeHzE7DP6N1+FiBJig90i5n+MYljsA7+k4gtv1GlNvZg9dKFj/C/
	ITjIhsxanrCQvBxbTPTlNVwspll6nZbDb9BAyzS6fB9rpJ3AknWWoa76n5lRzipjxTcScZTkGzYCp
	q2ee6QCcPG/YXEthc6g67ZaCN6HHyksB7Rz0zC03r2HM/RRFe68P7VLF9K/BCFvUWF1Y11OpxSCG9
	No/gBx7tUuW3L5jgWBYh8aXYhSnzgfQYvlmgCIATLM6jF8is+VSaQSEEdJLRKPVif6wcGdpAJq0UO
	cX1o8MWEm+Qp+7bo6QhCAQAfnzjblRQwtxyA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wKC5K-00BNwM-39;
	Tue, 05 May 2026 17:28:59 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 05 May 2026 17:28:58 +0800
Date: Tue, 5 May 2026 17:28:58 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] crypto: omap - add omap_aes_unregister_algs helper
Message-ID: <afm4WhMqYLAfaaNh@gondor.apana.org.au>
References: <20260427172018.416707-4-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260427172018.416707-4-thorsten.blum@linux.dev>

On Mon, Apr 27, 2026 at 07:20:18PM +0200, Thorsten Blum wrote:
> Add a new helper omap_aes_unregister_algs() and replace two for loops in
> omap_aes_probe() and omap_aes_remove(), which also ensure ->registered
> is reset to 0.
> 
> Replace two additional for loops with crypto_engine_unregister_aeads()
> while at it and reset ->registered to 0 explicitly.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  drivers/crypto/omap-aes.c | 43 ++++++++++++++++++++-------------------
>  1 file changed, 22 insertions(+), 21 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
