Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2C4434EF11;
	Sat, 14 Mar 2026 05:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773465104; cv=none; b=ZLhWfQcMlJCE4HnTgy4h2Cr4x6KTGGmybAMw1jmmi3AO9EP3LlaX1BEzIvXyN1AKPSmFBxL0AphjErsiXV+3FJu7QfU98hiqIUuee1nlsJvu3aCXYtorocIr+zgx/59+G6Fvh3TgsOghZgyU7HzKNSjZEx6kLKKM2vI2Mk+VAfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773465104; c=relaxed/simple;
	bh=M0MK020pIz5hYMo5oe4xDkyJ+XxgOHsakzDCPYjOZDI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d1rGFW3kZUM9h1RLWErY1sGoor+KPiPjqPrJoW2VFUv35e+ovp0czt1+/OJyJ/E9Mn/KpcyLjgP2lTqVr8GYCYu2onN1Fg+uZNUlz2NqAmDiKlv/xbO0BROy47ZQ9NpQo18QP+dKDSKnuujKzNEiA7ce8xZN/bu1UAHVuIqQqiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=FdKUAsdt; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="FdKUAsdt"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=Pv1Sue+tDSp6HzrN4XeKwtqr/fyjbCxgs0THp9ehQnw=; 
	b=FdKUAsdtLS5zNfzgoaBnNaHNkHIFu+4LwlRew7JascmslFH8vlqoWfBKnILw4AIM+sLWy9SZSGe
	zihaN1u/tNEuZYR1fHQ2OO7XUH5zEqU+GdGWJDtgBwnmnOiTkJJ3Djbkko6lWuewgiwsvBNQQyro+
	ltRYKGT+zWQ+MhXve1rvtCXxsntRFftRFWyuXOmLZ8JRvcs4w4C0A6hUb6ZrDGWxOmpa/ZtjgLqx2
	ryL9k8bKNKSRkF00ISE7GMFyirN4vf+1j6NpyJ/hYeiqpyEQpwwQrRSsYQOVQRAzNSOJe6eKRVKjU
	fDZ5LqWgNa+iLV6508N8nZMWwwth7hHaIdpg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1w1HHi-00EL7Z-25;
	Sat, 14 Mar 2026 13:11:35 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 14 Mar 2026 14:11:34 +0900
Date: Sat, 14 Mar 2026 14:11:34 +0900
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
Cc: davem@davemloft.net, ebiggers@kernel.org, ardb@kernel.org,
	kees@kernel.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: tcrypt: stop ahash speed tests when setkey fails
Message-ID: <abTuBiFU5ekM2YBy@gondor.apana.org.au>
References: <20260303000641.770327-1-saeed.mirzamohammadi@oracle.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260303000641.770327-1-saeed.mirzamohammadi@oracle.com>

On Mon, Mar 02, 2026 at 04:06:40PM -0800, Saeed Mirzamohammadi wrote:
> The async hash speed path ignores the return code from
> crypto_ahash_setkey().  If the caller picks an unsupported key length,
> the transform keeps whatever key state it already has and the speed test
> still runs, producing misleading numbers, hence bail out of the loop when
> setkey fails.
> 
> Signed-off-by: Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
> ---
>  crypto/tcrypt.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
