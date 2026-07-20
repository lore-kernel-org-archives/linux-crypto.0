Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 421814C6D;
	Mon, 20 Jul 2026 00:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784506423; cv=none; b=s+iwPbXb7IcgItikYLKCAb56xcEnqaKpjXkjPPwzNav9T6B9mxqEe0Kvb3+eUlSyUk2gvwfP0XAkjYDz7qnYgbrcq4tLHfddPWFsOQ9f1M1jc4UyRC5Dwqhtzl5OzlwrK9claXVJXPU8Ok+HlEH5ph3QyiCCPjPqvqXksqtyNXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784506423; c=relaxed/simple;
	bh=4qx3lYBKFcLAF9CEfySUJcSBxFmNc9isR8xYQcUDmro=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h7Hcnq+DI0vI8tFZou046Y+A1E4Z7NZKGEJUCyFsO7qjVKFBzO2bKtNJ5jR/FGYdSCjz86T+iTKM0Sgtxi/xbD0xurLqrtSQ3BxZcaRv2QhV6CumwJJV9/9XXESDpYNw6zdQPyiKhlErRMLUlYw210RYIhOVrVwS5PHveG2nDZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=Dro15UIN; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="Dro15UIN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=2+V9OXdDe9F3+SH3nYBx3sTM5SgQT9TJIxeZqXBiwuY=; 
	b=Dro15UINYpN8WJqevyQBz75uBsczOR4DFnDu6f4HjiLNosuQDCN4tsdYngmMsxX7MtkWMLJ6ozk
	IgeUH8h0d2KRPbbK4FfitJDV5KGb4br89sErRV8hVUk7tT+XN9Pf/UC9yta4tUpzYXgSBSaIwjdpJ
	4yoSnJ7QRmpZ5X9zrNsZkNJ/FjP92RYe82KOHlDI4EutXS1AeTxtbwOhIGFu4q3bR7Iao39Qp+yNZ
	nZbTfeKTznBlMVYEJbYNiiGZjarecx6DSlIZ2UVC2GvUxq/xmL9RkWX2HUpJ0JeRI49Jf/09cnzI0
	hKBoeiQU6IsFxhyZCxHKG3JnmXhsi8PQcP5w==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wlbdO-0000000ExgZ-42mp;
	Mon, 20 Jul 2026 08:13:28 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 20 Jul 2026 10:13:26 +1000
Date: Mon, 20 Jul 2026 10:13:26 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: unassigned <unassigned.56@gmail.com>
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] crypto: Update cleanup path to use kfree_sensitive()
Message-ID: <al1oJlPR6kaWSKjq@gondor.apana.org.au>
References: <20260719100750.13867-1-unassigned.56@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260719100750.13867-1-unassigned.56@gmail.com>

On Sun, Jul 19, 2026 at 11:07:50AM +0100, unassigned wrote:
> ---
>  drivers/crypto/xilinx/zynqmp-aes-gcm.c | 12 ++++--------
>  1 file changed, 4 insertions(+), 8 deletions(-)

Please read Documentation/process/submitting-patches.rst and
follow the instructions.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
