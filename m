Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D99C4348C7A;
	Fri, 29 May 2026 06:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780034427; cv=none; b=OFpWzPFVJ8E1O56RmQPyDAjTnTkJbL1C0qLkJXJIJ5cMKoghh4Z/zs4nXo4H4AcbwtUwR/TQfB04QMfvgjmcrXH3u/EFoc8KHQHHVZ1YX9gyIHkenuvyjV+/EKwv2eTsh/PSSrWr3FQ6ZZ38VUjmYIi9vmvZBXvHsUOWTtrnTt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780034427; c=relaxed/simple;
	bh=2oAn0L5+HD2AtTlV2uME3f3hPS6uvq0i6nSaEreytVA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Dzu4TJJuXDCD6UgrQB4lTWk4Ho5wk5rFl2HRgSEwrcQmIVqabYv0axhIMFh1v4/adkTzlpeyWb4LiudurWtSHfG2h/i6lMtMfbSy+I1zZZRnX3WrBBuW9D3YSW4zZKVKqL+QKY/xGXE0SPEdToJ9zi1zZ8mUreUoQ59XbN031vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=ITw3jwo0; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="ITw3jwo0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=fVgFMc5OWbl1c4wXUC0otOrFLG1QbIAFkmFb4gQM/XY=; 
	b=ITw3jwo06NQc8/pVtNjEcrh+1HsSMS1CRkI/EzSfGYBhbg1xU6xV+Tx+JLcoXWWUGmO0MBgNX+A
	HoQKge8cswuYjL6niBXkk41oUt6U1xGeRPkvQMc+QzBvkt3spHGhwxAhLH4RioZa0OIg0RcLdyM4O
	tSRq8w3KPBNM5NcMiqNzIh4b5Oqt0R2CNWAwPoLdpsA0fbIlnXzgVW579QykowKAE2ubMVba4pAlm
	eG0YbHykJeZmprwrYsv0unlzVeDijHi4YnzndjkI9e2V88Sqcs9m8u5c9K5iGUqEO/uNtz33xTrfw
	Zl0HxVmMWkh+WlwNFD+W6hmAPVU9FIW/JIPQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wSqGW-000d8r-2G;
	Fri, 29 May 2026 14:00:17 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 29 May 2026 14:00:16 +0800
Date: Fri, 29 May 2026 14:00:16 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Aleksander Jan Bajkowski <olek2@wp.pl>
Cc: ansuelsmth@gmail.com, atenart@kernel.org, davem@davemloft.net,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: inside-secure/eip93 - Add check for
 devm_request_threaded_irq
Message-ID: <ahkrcFDYQbEHelqF@gondor.apana.org.au>
References: <20260518212506.292170-1-olek2@wp.pl>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260518212506.292170-1-olek2@wp.pl>

On Mon, May 18, 2026 at 11:24:59PM +0200, Aleksander Jan Bajkowski wrote:
> As the potential failure of the devm_request_threaded_irq(),
> it should be better to check the return value and return
> error if fails.
> 
> Fixes: 9739f5f93b78 ("crypto: eip93 - Add Inside Secure SafeXcel EIP-93 crypto engine support")
> Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
> ---
>  drivers/crypto/inside-secure/eip93/eip93-main.c | 2 ++
>  1 file changed, 2 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
