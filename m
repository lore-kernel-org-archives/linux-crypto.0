Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A6D32D77F5;
	Mon, 13 Jul 2026 02:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783908555; cv=none; b=U/2h1h1+6gV3AeanRMVK0WvVyLTGefudxwessCkqO4B7OB1RLbtK2NKtcCgmxNupnmV1rXEJho0qDqTILbTj0YQrq7QvFtNU/xVv723z/6v4P1D9g41BX9hz44yTUDN6PRxAbirmkF8PwLxMPB99ngQbM4rLTzUV26dcgXgYOak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783908555; c=relaxed/simple;
	bh=iTY+1Uatitk5rJHb6sb1FsxZ8/tdaF0YJ40QmlGdN9s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eQnX70S/6eoW9EaOKsuFiMsPUA4pHKtsD32OCb1h3u0ta6/jLt2NXtkoh7/Fsb8u0FnMSzLcBavMAEvrXppOe/DzzGk2kpN1Nc/Nuey9NAESbXTqdU9l7q+5zlTMpnij69BfIdYONrlSOVqDY73diK9H9F0ZW36PkR2nI170LkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=GYXfRv8Q; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="GYXfRv8Q"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=AbiLZWl/3TiK6gijGtX2JiTC/GloFVRdhq3Htt3t6jo=; 
	b=GYXfRv8QfzZGxTxtwvkmABU9bpzgn1qwfCpIbYos5GLxSViHnLxB+lX+Dv6vcWxCNwztwX1KeJZ
	kUCfvObRV7JWYrfPySm4o9+dqB6K5wEQCFjMnx214x4O9SYWhC4+6LoMQimctl8iT28+2+H4M9HdR
	vEw18zho/OfxOhZsRnUIZkL5BQZJd568rK0ipO39rMmiC1oE4NHx7ItNikT3uuYU4NTGIjERq5Tkn
	Qq2V0vS465XgFt9Mz+qHY57O9TvCiZnLuXLsIJjWdY9g68h9Xnk7jI64zdMrrJGc+ea00Bu9Fmwye
	2fGaCbw+gue5YyBFPin2ygJHyckNRJ8n3/7A==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wj66V-0000000CxAu-44X0;
	Mon, 13 Jul 2026 10:09:09 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 13 Jul 2026 12:09:07 +1000
Date: Mon, 13 Jul 2026 12:09:07 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Rosen Penev <rosenp@gmail.com>
Cc: linux-crypto@vger.kernel.org, Srujana Challa <schalla@marvell.com>,
	Bharat Bhushan <bbhushan2@marvell.com>,
	"David S. Miller" <davem@davemloft.net>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: cesa: add missing free_irq() calls
Message-ID: <alRIw6NnLkD_HU99@gondor.apana.org.au>
References: <20260628232000.1287439-1-rosenp@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260628232000.1287439-1-rosenp@gmail.com>

On Sun, Jun 28, 2026 at 04:20:00PM -0700, Rosen Penev wrote:
> Add the missing free_irq() calls, along with irq_set_affinity_hint(NULL)
> to clear the affinity hint set during probe.
> 
> Fixes: 5bbf25419f8e ("crypto: marvell/cesa - use request_threaded_irq instead of devm variant")

This commit does not exist.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
