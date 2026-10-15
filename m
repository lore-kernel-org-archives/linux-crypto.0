Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8C1250B426;
	Thu, 15 Oct 2026 09:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792058141; cv=none; b=DzpqxX9DI8v3NdSgMIoXdqSQHT3GaiK/3dBAE7Aqh6r3+zyvfUYZ4uPo4jqFihu4caydPvPyrMbtxTxQbwLyrgUQtzNkCfa61mZaU5J0bHE5EkD2yenEw6/jvlyt84EQ9EjHI6G3uWfX5w1bv8aXVV3DgGDIPTyskMQhhFtap1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792058141; c=relaxed/simple;
	bh=cfvuOQvAVy+qPRIz3MNFmW4KWCQZ65BwDeUzqg5jFkY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iIHFIvSz95ZB0uQ3gskSQwxpPg/3B6cp4VJFiAzYS6BXDj7KiyVxOex2MY12uHGNKF906evOGNF8Hfbze6cdv1gout2uNKYNEExNJoQWQyqg02KhOo28+qDy4QccDStDTfz8QjfMVTHII4MVx7p9DNIR3OFDcJqiJiymy9LjaXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=PDXduSzY; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="PDXduSzY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=I4zu+imZ9yhfkQ/DfMFfiw1YnJijbZZRdd3fTfHrNo4=; 
	b=PDXduSzYXOqGpws6c3BcdWgjy8uXUFhiuK6v76V7c5SpeImKebKfoMp5ES/bcoqgNQ+q+IFqMu8
	N0s6GufggOWIN1i0CfwrNvYZuAchCi581rT3gzkEHTiMJPWrTj0QypB/RM7CnaTrV/cfTgQ1G+mOv
	P3ZjoQh8wT2CjoHhuoxOKaapJjTNdy5tqXP3EX2R/JW1dTM3FkEy98JjkFGi8Iupjd+1N2XGdZs3j
	8e0JlFGA8I4CzjfhPnnnviXTrOA/A97Ko2FGnf6VyYjZj/f4jJBPqZN+pewyzosfvLhOF6eoQTbVM
	d6IbBonwfyTGx7+fHFOHUM2YA6ZwupK2Recw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xHIBO-000000047tk-0Him;
	Thu, 15 Oct 2026 17:55:31 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 15 Oct 2026 20:55:30 +1100
Date: Thu, 15 Oct 2026 20:55:30 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <blum@kernel.org>
Cc: Hadar Gat <hadar.gat@arm.com>, Olivia Mackall <olivia@selenic.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwrng: cctrng - simplify cctrng_probe()
Message-ID: <atCjEuSC7dG-_byJ@gondor.apana.org.au>
References: <20261006202734.104415-2-blum@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261006202734.104415-2-blum@kernel.org>

On Tue, Oct 06, 2026 at 10:27:34PM +0200, Thorsten Blum wrote:
> Handle the error directly and drop the goto statement.
> 
> Signed-off-by: Thorsten Blum <blum@kernel.org>
> ---
>  drivers/char/hw_random/cctrng.c | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
