Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 794444483A6;
	Fri,  2 Oct 2026 08:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790929362; cv=none; b=b/BumhrCYPa+bfsY/qPCXUImvEEYIiQ12D8q2Et8LHKPS1gosfnzVX+mW9wYd6Ms8YyJWMHCSTfRH6pevPp8oJ4A/oUklDirM7lfTEyyA9I/aZTuX4Yp+JPRI03zabbBdwHE/7GG8VyqWy829n+9Seoss5ENJ3SN/LaFj4hLKZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790929362; c=relaxed/simple;
	bh=s2AFnJ09+x0vtG3p6oY+OS4DK1tcRifOMi74kVoHsBI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Lt5FvVk0bQg8fb9M4DfyAE+SAAVyxe2KHD8Dvf1nPpnYnpggOERRN2YcyyUvgnSAk8I6HgN4rPDUNs7SSjUM3U1m92qmmykf9Wi93/aTo9rRUM7MN1mibE1LCmoGrBtju0n1nQDtIjgtZJCotBkH/TGSVPz/AtdvLpdfszvm6FU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=d/UKGUuT; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="d/UKGUuT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=BEn7pn6jbI52CjCYtQw7B6hgdNS08h2Y039Lu6UW1yk=; 
	b=d/UKGUuT9uATWOskiV0n+XtSYq9/C5+Ewqjv+y5k0ZlkEzMlg1kVUhMXrh2jMbKWI+BUfsTK8rP
	+9z0c7HFGhiK20c8hd353wzlDUASAXZD+rgvRVzKPskh7/89zNVOgnPykkkDqwJqxTEJ3U4xnApJr
	CMYjg8AaQx6/PlitgTX+tAnF1dd13+BUfx2BX9cUB1Wd10rIrHFX5x3uf3uQWzHxkEm7c6HBRfEHY
	pRKUeGoLmzNiYdEzcZgA5dtddATNLrGdZDpYC8HflC8TFF0/Wx89jfvyYB6slFwMalzEZcJhE5D7q
	ZEeEbBrkCckBj2T66IKaQ08Ht512W5wbtIDw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xCYXH-00000002mcI-3ThK;
	Fri, 02 Oct 2026 16:22:32 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 02 Oct 2026 18:22:31 +1000
Date: Fri, 2 Oct 2026 18:22:31 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: phucduc.bui@gmail.com
Cc: Olivia Mackall <olivia@selenic.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwrng: omap3-rom: Use pm_runtime_resume_and_get()
Message-ID: <ar9px8j0agfRz8yM@gondor.apana.org.au>
References: <20260922032054.320969-1-phucduc.bui@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260922032054.320969-1-phucduc.bui@gmail.com>

On Tue, Sep 22, 2026 at 10:20:54AM +0700, phucduc.bui@gmail.com wrote:
> From: bui duc phuc <phucduc.bui@gmail.com>
> 
> Replace the open-coded pm_runtime_get_sync() + pm_runtime_put_noidle()
> error handling pattern with pm_runtime_resume_and_get(), which already
> does this internally.
> 
> No functional change.
> 
> Found by manual code inspection.
> 
> Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
> ---
>  drivers/char/hw_random/omap3-rom-rng.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
