Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23CFE4418E2;
	Fri, 15 May 2026 10:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778839999; cv=none; b=aDjbaomtuT6Tla4whLgLyNkRYn2k8nrJ8Om2G0HXqx/wRjAe/DDRdvIZF7/eMBjQ7Wgy+b3yYz3dQ0UgrXy9t9W9FK/rXWZ2JUydU/s0lg+FrFhBjE+UWW7TEUIEPmH4AFkyZFu7mufQmvJbwL9o9XZJbN9zHqRyVtKgUWWx7fY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778839999; c=relaxed/simple;
	bh=aE7+PjpbDa9Z+D/ebCVRlbOH95ur7VMY2/r+UIj0dWw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RnNzR1dMI7ehtLAlxIKMNVkekrqPt59gRy9z72WCXVnZZQfFmnW8MUvpTYXPsBPWhfiMBqkmLGMtXw03K7Z58o67ehdrFqkp3c+foBJVI0T7/tZG7BTOTjwRovcER/FTA3Jat2EDABumwyAf0ELdh+VAfa4OM9dlGTTNiOMVWmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=Ms60Hl/I; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="Ms60Hl/I"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=2NDgPP/DBS/CnGum+V/vfsB3HFc4mN55Ug/9MpL8ZYY=; 
	b=Ms60Hl/I6M82+3kDkXE7vN9Lm1P+k0s/OdYy5WJHcOlvNQN+CbmqOVYPR6Ehf6ObVq5cpz6F/dk
	++ASF54Lr9ql3ThpvT67RVCprMSIbAPGPnoHjuW2mJ93s8ksPxOyxjDDMVPMdwJkXGSwOp8lVYOKT
	hOgdT7B9VcNVynnWjrklvEggD88gn8/82ushy4DDko5XkdHQtB9756E3L8AMSagvEfx6QMjCWASG2
	IjtW7qtS3nUDmzYH5MzZWPgilboKu0krvgJ3A8eRAtMp00qy6oGhBC24gEFsZdG32Z9J+VvlXGa4Q
	pJQonhRvqWu5eViwpN+DTBXmCZ+dtaE0+gVg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wNpXS-00EOFw-2E;
	Fri, 15 May 2026 18:13:03 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 15 May 2026 18:13:02 +0800
Date: Fri, 15 May 2026 18:13:02 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Stephan Mueller <smueller@chronox.de>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] crypto: jitterentropy - drop redundant delta check
 in jent_entropy_init
Message-ID: <agbxrumSJgnSJ2gW@gondor.apana.org.au>
References: <20260504082848.7194-4-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260504082848.7194-4-thorsten.blum@linux.dev>

On Mon, May 04, 2026 at 10:28:50AM +0200, Thorsten Blum wrote:
> Since start_time = end_time - delta, start_time can only equal end_time
> when delta is 0, making the explicit end_time == start_time check
> redundant. Remove it.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  crypto/jitterentropy.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
