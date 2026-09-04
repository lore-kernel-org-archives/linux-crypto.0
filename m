Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D7333FA5FC;
	Fri,  4 Sep 2026 09:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788512690; cv=none; b=mJ2QKDv4llHhJeveQVY7KETL+e4OfF0abqF7BwSFLvP1ZLhnxRmhtzIoeZm170P30Z3H7PijfHpWHRSR224Mr31RW7UkX6IcYoc9kuQmt2ziQwLZCiTuDZx4jMuU4aZ1G0ihCJUK/MwEcoX7L32hJSID7yIp3CKKRiXheMj/u2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788512690; c=relaxed/simple;
	bh=iZfz4MuBM0iI2ih4fzWtulPSD0XbBQGpSAqgeIoXYbM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BXVopedOLZtRHVnv7J+roNwpDqki/ra/H3aNyfqNGnuNXbRxWHBfnP1DNLJlSLTs9v7K4p3i8w9yT6iUEPh+UGIL0mR/FMwi5lZFBVlQabf7BVZ7ITBcbM9qd6y7m0VZeb148lwQ2MI+77sbvJ/jd25v3ZGXpTRZaub3f+lsgWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=Wt/WHBRJ; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="Wt/WHBRJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=Qj1KKHdEibEEXlpVaBhRvkk3alqmH93S2WW3QBBCQac=; 
	b=Wt/WHBRJMCILq1B+KkvBTww2AGpfqXJ134ScK1uSF7xTKBJu6jCeX9F9oh0F44qJetwWAaG7yML
	y6Jw2HSRsy9WWBKNCTeQ7w4bPBR0PSoN+ChA3e+xLsibSm4HuMAXQAFRHK2t2UG8JBBEfQA2AAzEx
	TukU/zEIYmxfhpSWPv7faijWKQGhCWDnwCS0+XYyh7dQbEyf6K7D9uxjj+lOPWukISHlUrOZqD4SO
	N4NFgN/yBf1R1N7gDVWCXTv59PRBfEWDFl7U3YZACXk+01ot3G/18tZH7vtimGmMiu0ivYm9hBP4p
	sxNW1Y1P30FaCqxO4h9kfFmOdKMaeZ2NL/1w==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x2Pqk-0000000Am3o-2XET;
	Fri, 04 Sep 2026 17:04:43 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 04 Sep 2026 19:04:42 +1000
Date: Fri, 4 Sep 2026 19:04:42 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Rosen Penev <rosenp@gmail.com>
Cc: linux-crypto@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: talitos: pass talitos_private to irq handlers
Message-ID: <apqJqh91urkVIbDJ@gondor.apana.org.au>
References: <20260811043953.150589-1-rosenp@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260811043953.150589-1-rosenp@gmail.com>

On Mon, Aug 10, 2026 at 09:39:53PM -0700, Rosen Penev wrote:
> The irq handlers only need priv, which they can get from the
> dev_get_drvdata() they currently perform on the struct device passed
> as data. Pass priv directly as the irq handler data and drop the
> dev_get_drvdata() call, while deriving dev from priv->dev where
> still needed.
> 
> Assisted-by: opencode:deepseek-v4-flash-free
> Signed-off-by: Rosen Penev <rosenp@gmail.com>
> ---
>  drivers/crypto/talitos.c | 18 ++++++++----------
>  1 file changed, 8 insertions(+), 10 deletions(-)

Please review the Sashiko comments:

https://sashiko.dev/#/patchset/20260811043953.150589-1-rosenp%40gmail.com

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
