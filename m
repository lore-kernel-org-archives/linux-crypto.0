Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6742A2673A5;
	Fri, 17 Oct 2025 08:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760689030; cv=none; b=Nvahx5ztTaaHZxVwX8xSwYS1oZORcWkiv1zNuZOTmS+oGHPpXYWG7A9Ad0nWhoXkoqIoXz4jo1ArSrJxkrC4tAGYiyRJZ/lpy42RUaFxKU/ZM+GVOEryF8STWP/T8ykKu6ue5VZQp7hh62Nd3MGA/nHkheHOPvJ5yVOElbxC910=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760689030; c=relaxed/simple;
	bh=QlK9v+zRWCjK8hHmDTmdzJ1doslKeAbMeoQlL0ZrFHQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hK+KuHvqb/iSODyp0F516mmQ006M6lu6zCaMWD8txohBWyJceWpwDTDQy5ADrboH5vhpRmmBVQi22/Li4XtRHtcGUm/riaUqrRvnYoHDPcpVCCRSrNLi/Z0kGzgcLU8vMYHYjnRNXydxueNBiXFE6DOLFBT8XoANNw4hOt+r9vg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=p8mTP+7A; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="p8mTP+7A"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=NQZ5r2qdTthoxEb8XXxMNCh9ry/B35dP7QLFFJU3jro=; 
	b=p8mTP+7AQjmIhhtK25bEvHXjAwffBpQ50rC/MsKOGBvDV8niDN03q4d1XchSurQx0SO7jTCypWw
	Kz+yXvufN/nZ7q7zUmZMEzfrmOsk/Jq1/xHGzL8OLc4lin17Z8kcWfwnmkJBOhgxM8GlJJjculgyA
	MSIENflWplhwR/8Qgm+d0jfzIwhuBbE2h5g11eJ2KJygBWLpFL7n0V3PrBVp1a1N1P6Lv6VoqSsT/
	rPsiSq54j+22DJ4NGKzN7UUFxAMlMmrLIxU1QcQNTK9YSJ1Z0qLzOllRHvGOfFIcK1X0XyeQvVbhf
	2sE8ge798zhWuqbA8A/gw5cVHN8wvZRjFNWg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1v9fe0-00DMyt-2d;
	Fri, 17 Oct 2025 16:17:01 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 17 Oct 2025 16:17:00 +0800
Date: Fri, 17 Oct 2025 16:17:00 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: hifn_795x - replace simple_strtoul with
 kstrtouint
Message-ID: <aPH7fC4gj3_t4-Fk@gondor.apana.org.au>
References: <20250923010304.1796713-1-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250923010304.1796713-1-thorsten.blum@linux.dev>

On Tue, Sep 23, 2025 at 03:03:04AM +0200, Thorsten Blum wrote:
> Replace simple_strtoul() with the recommended kstrtouint() for parsing
> the 'hifn_pll_ref=' module parameter. Unlike simple_strtoul(), which
> returns an unsigned long, kstrtouint() converts the string directly to
> an unsigned integer and avoids implicit casting.
> 
> Check the return value of kstrtouint() and fall back to 66 MHz if
> parsing fails. This adds error handling while preserving existing
> behavior for valid values, and removes use of the deprecated
> simple_strtoul() helper.
> 
> Add a space in the log message to correctly format "66 MHz" while we're
> at it.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  drivers/crypto/hifn_795x.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
