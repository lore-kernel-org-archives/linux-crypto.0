Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D5D235C69B;
	Mon, 10 Aug 2026 08:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786350796; cv=none; b=nzFAeaMP5GS1Pfw3W+cw16wJtlResaG+wD6RQmeqUi6XBH4Aiwd5VLTzKvESZ56+H15F5lUXRCaZUgIEJ0dffyTYldX3KUR+HUYPWSFEnzTsdiv7kzOd5KIFt6X8ehpMnSJcYKvDZolRSfgX0I5fxvV9u3ieR6vq/E6o3xoR4WI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786350796; c=relaxed/simple;
	bh=9AFoPuL0LyiB2dj2FoJgBZQJlAB5ggTGizdlnqz4vms=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jTs7bOHe5D6k/fU+o1WNSWakQsUTrVa1BKlzpvNlmPWzwkM+YybQdFIKDC0zMIJA69o8I/f4Yl9hudnfYbRnJv2LdL7mHRW3EKwfIbdGtmKyQnbb2E7BpITGTHaI6jXLMEcom7Dgc79nnFybqT+pzKEMFVtejFQjl/QU6Sa+Es4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=oAN82gFO; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="oAN82gFO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=rlW8OBHYZbYI4aR3jM6dDZXVtGCtDgRCahYcCoB8fUk=; 
	b=oAN82gFOOLcbagQ23ipn4dvUgQm882TlnCI/qI6jFC64oY0mdJsIAT35cJqbiQhrEx+ar0aU59A
	+9cSkgIaFCtfJKw+MSbKW0uVpDlJm5Tdsai5GpzKkVw3aUkfkPR4UOmyq3LmNbYuAe0zN58Z0M7//
	KE8LoiclGp/fC32oqI2jJlIlEDgDf4FqzeHGjAHaP/5lycmIoA668xJa+v6/f26Xsj2Wc6X0jmKqR
	SvHWa2Vkk3IOEeRzUrMfjt1ZQPodc82joE0Euq/sD6fQKkC0pO6Tn2DU23F66TQIG4WhVBH/OWeqD
	P+O9MYbOaVbxBM4hxTB4Kn8QB85Ik0B40cEQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wtLRW-00000003Wlt-2mhy;
	Mon, 10 Aug 2026 16:33:11 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 10 Aug 2026 18:33:10 +1000
Date: Mon, 10 Aug 2026 18:33:10 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Rosen Penev <rosenp@gmail.com>
Cc: linux-crypto@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: amcc: get irq and ioremap resource first
Message-ID: <anmMxvAcJBJ9JDaT@gondor.apana.org.au>
References: <20260730204915.1102403-1-rosenp@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260730204915.1102403-1-rosenp@gmail.com>

On Thu, Jul 30, 2026 at 01:49:15PM -0700, Rosen Penev wrote:
> These functions can return -EPROBE_DEFER and require no special setup
> other than the platform_device which is already provided.
> 
> Avoids doing extra work when not needed.
> 
> Signed-off-by: Rosen Penev <rosenp@gmail.com>
> ---
>  drivers/crypto/amcc/crypto4xx_core.c | 16 ++++++++++++----
>  1 file changed, 12 insertions(+), 4 deletions(-)

Please check the Sashiko comments on this patch:

https://sashiko.dev/#/patchset/20260730204915.1102403-1-rosenp%40gmail.com

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
