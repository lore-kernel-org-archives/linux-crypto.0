Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01C5F318146;
	Sun,  5 Jul 2026 08:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783240257; cv=none; b=ajMuKlhVvkOfuf2EFEp/0McaH4mBvYUzO/7kp37jchgsN12OP4xXPZz93iJi6ASNRPbLUjcRAHnnKIQOuFYfZJ/DkSOM7BUxiDV0yM/uUqZ3zRHwv5lN9BwOQBLoFr848/qzYDoP2zcLnHuzmbZfVIscYSv+oJTY1zxWHgPRK1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783240257; c=relaxed/simple;
	bh=7t26CzUzUNpqjsEhHyQNaaYsRM3IBeJyHDPdgXYOkx4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=guWl24mIEV69/IW9CBodXzUmX6WyckendR3t6GFsn7gcf00CNHkbhiEBcsTrvUk1iQTKP58eQR4BE9q3k1v2cJ5Vw5nuKezsjif7oLiBF8c1kcWntHVlYxQn2R6qmfX8HzqJWXEb4k06UO/XmK6t5HjdiL7YUs2HzxNv8NNEBEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=XBklIydb; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="XBklIydb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=6WimpGsQQziwQoL4PNsLtzHbTBjAePAu6SlXXFb67OE=; 
	b=XBklIydbiMcXUFcecEVhazHvUBuFiDyhO88zEhkx/WVi0agAehH16T1QWWxvh8Th8T60eMsgnRF
	Lt7dFoc6pbU3EBMTYD54SZiVWggjUKyaCFgG/KSU7RBt04OMvzQhDG5yQTDNEWLIQvJx5G79Mr7zO
	XnGpHqBIaqdbnHSz9Mh0cA8sGkB1XZeLbVvum6GilAB3FeLfUmvk05v/Whkibc1A5v1Q8KE3DkfCq
	mfkG6QOJ+48vNnIICxHzHVqnVgWvUOsTx3lFT7+mLt9C2E+GPr7jFR9cIfljsBm6brF6f/2fLi18H
	SJ+rROObVpkcYKtRnb/TTswGy0iNmjKSUXEg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wgIFY-0000000Aky5-1xjz;
	Sun, 05 Jul 2026 16:30:53 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 05 Jul 2026 16:30:52 +0800
Date: Sun, 5 Jul 2026 16:30:52 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Rosen Penev <rosenp@gmail.com>
Cc: linux-crypto@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: amcc: move ioremapping up
Message-ID: <akoWPJSbrZNoFJb7@gondor.apana.org.au>
References: <20260614012917.70772-1-rosenp@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260614012917.70772-1-rosenp@gmail.com>

On Sat, Jun 13, 2026 at 06:29:17PM -0700, Rosen Penev wrote:
> There's no need for devm_platform_ioremap_resource() to be so far down.
> In fact, putting it up allows direct return instead of having to goto
> some branch. Also, remove the error message as the function complains
> loudly itself. No need to duplicate.
> 
> Signed-off-by: Rosen Penev <rosenp@gmail.com>
> ---
>  drivers/crypto/amcc/crypto4xx_core.c | 11 ++++-------
>  1 file changed, 4 insertions(+), 7 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
