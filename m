Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F5B2433E7A;
	Sun,  5 Jul 2026 08:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783240283; cv=none; b=UDTaAZ2Q34J472nQkCUgdSEx7tQRnH3pFmNEUUGf37qpeb45IMD2rzktbIGD433j7m2GNpTwHRLGkf6ZLEiLREPVLWFq7UVg4OwCnzecTYVe2YF9/fDNF2baAxLaz6PuELEOqtuRT3sfzmPwtmS3dMSZlaZVBBtOeeXdH54svW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783240283; c=relaxed/simple;
	bh=SZbbJ8EO083td5pS9EEjBmJm8dGqmqPEVdLuCn4fQds=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jEYphhy7hufuBHjuJvlxXcyKQCRlrtm3gnwevcP1ridzu83QtZnrvX8V86NdRc/Z/msdz7mB1JKRGUNdxxul1LpFQPV8uk3YsyjTa/aBGXkkuTp13gyxYH0qdglGwR9LIhI4uuiHx0rLbp63aXBpyb1nLPLVh3ZG6OVOU9Sj3eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=EISUI8Id; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="EISUI8Id"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=2xN3+gAOrfXpLJmizIv3UK+61coP9zg3wxQZiNEZEoo=; 
	b=EISUI8Id3g51j1MFVxLSImb8m2nO+cfrpFp5l27/IiXmLjwKDGr4YiVapt3pyLQmLe08WgMjviP
	aZ0MqzP0T78BX3ckbCpheJ5hau7b4h3KtbnTdflIXAtVBcwoVgEm2JZRm8ltjb1Amovptf15F46dj
	81IHdzQrXhew48uh0sv6xk1S8bAMtgxbtFnpur8ow1K8KAqKOoVxrmtw68s/8Jatu+av0Z3lP+t2S
	QBvmG6bdoSW/gbD+6183Q5tgNul4Z9Cyb3AI5eIs2Il/vDBW9SGtV5vZjLh0e/AyYaKBMlL5i4xHH
	AXEqomU5CCb1CXlUj3QVzb1uxJ3NRMBOpE0w==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wgIFz-0000000AkyY-0rEO;
	Sun, 05 Jul 2026 16:31:20 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 05 Jul 2026 16:31:19 +0800
Date: Sun, 5 Jul 2026 16:31:19 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Bartosz Golaszewski <brgl@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: qce - drop unused scatterlist traversal in
 qce_ahash_update
Message-ID: <akoWV03fY7bcL0xh@gondor.apana.org.au>
References: <20260614152605.701754-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260614152605.701754-3-thorsten.blum@linux.dev>

On Sun, Jun 14, 2026 at 05:26:07PM +0200, Thorsten Blum wrote:
> Commit df12ef60c87b ("crypto: qce/sha - Do not modify scatterlist passed
> along with request") removed the only use of sg_last, rendering the
> scatterlist traversal useless. Remove it and its local variables.
> 
> Also remove the redundant hash_later check, inline the source offset,
> and assign the number of complete blocks directly to req->nbytes.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  drivers/crypto/qce/sha.c | 31 +++++--------------------------
>  1 file changed, 5 insertions(+), 26 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
