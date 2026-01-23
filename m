Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67761399001;
	Fri, 23 Jan 2026 05:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769147969; cv=none; b=SZb0m2CeMlByW9Pno92vo5MdZuQdMmKUeuDp/y9PfgGYwzJsyk5eFE1CyYSs5dADb7ukl7fuMB4JmwvxlrCH041GntX6Z3kf8MUem23GepwUTrZ7jkrX9rlEMA5zkYUkl+s2jgw5funBsvsGYtCyHFV7V85hRfCHoHuLmum5FC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769147969; c=relaxed/simple;
	bh=xBPD4Kq5eV7X5Q7AIuiZrfzV80/9Fju+wnrGO/aoCWQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tsibpLHGPLWcZH9QFUjmHNIeGgBSjbH7NTzrVQ5kR1Y6k4N5PZ0gy/XzuHFiaWupf8ftg0FhwiI6wkCn+HPom5BR+bbVZLxntafRwtmG2Azpuv1k8nniA3hSBCXqlgc1pNRdpDqOW0tqXfstAQcbFYS9foyI8L7huUO3iXHncto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=o5Nr1584; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="o5Nr1584"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=eoislff6NdgQr70mDGRhROvUf1Rezjfhuy+yFSDXiYA=; 
	b=o5Nr1584Fv55I/Y5aWbBREYl7aAw9/UlkULnMXM8d4wmWhehZZy5eRnbt1ZeYOHEAhr9fe0Xe88
	84y1arO4qv8+mTgBgqMvswjs7LbSV+uSLP/7tbwTeBOC6PtSJyoVqmkz/6FL5pdq2rHXXshB23OGE
	VL/+NX7Uc97K9Un1x/XpPqVK5tR0nEyfLlo5YLEUENIoAwE4H2uWTGUCs8cXFUWpuppK8AHesQJ/x
	dadVWWNnC4v9tConOV79GQRfNPhR+FF2+886vm/yKfnC9WrPKKm35HRWdWUbbAXxOLvO7s9mV/FNS
	rpCiMNujm7hDzxnXUPEDSvPaasQUwBfbMCiQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vjACH-001VOl-0r;
	Fri, 23 Jan 2026 13:59:06 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 23 Jan 2026 13:59:05 +0800
Date: Fri, 23 Jan 2026 13:59:05 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Aleksander Jan Bajkowski <olek2@wp.pl>
Cc: ansuelsmth@gmail.com, atenart@kernel.org, davem@davemloft.net,
	vschagen@icloud.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: inside-secure/eip93 - fix kernel panic in driver
 detach
Message-ID: <aXMOKTBrxUgB0rQq@gondor.apana.org.au>
References: <20251230211721.1110174-1-olek2@wp.pl>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251230211721.1110174-1-olek2@wp.pl>

On Tue, Dec 30, 2025 at 10:17:17PM +0100, Aleksander Jan Bajkowski wrote:
> During driver detach, the same hash algorithm is unregistered multiple
> times due to a wrong iterator.
> 
> Fixes: 9739f5f93b78 ("crypto: eip93 - Add Inside Secure SafeXcel EIP-93 crypto engine support")
> Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
> ---
>  drivers/crypto/inside-secure/eip93/eip93-main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
