Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44A93248893
	for <linux-crypto@vger.kernel.org>; Tue, 23 Sep 2025 01:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758591231; cv=none; b=rilKTvxrIAeKRyNqep84Wbs8BhdAtE0HNs5xkQOPL0vbBlK4jRokdKWEromjTCrcWQZ/ge2+A9jSvsNmTHr665yBvXAmAfenYyxvp/ahRuqTdlHeaBWKjiY4U28JUd3g3EsEeVG7FQmUCyaFyXypwMCoGOmpDXCdJsGawF1jMx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758591231; c=relaxed/simple;
	bh=ZVRcL8DCQQSrllt9UgXRyUIl8kbTz2epswuzZNWOFY8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rOP96gWQ+LUw8VETfW7dhlHktpbggEHQbBLM7KUo1XzaV0aAI/M8DbICVu7uJb8hd+uc8hhvuWo2WtX9yqx+sFbgsPwqpHtbfnhXW/DfvBNH5jfutkGnDeayoSRoP1GZBvufoaMwm9oB7PEcl/CNbR0BEn4mEdkLO9z3O7YAr/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=h/3BC0ZK; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="h/3BC0ZK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:MIME-Version:References:Message-ID:Subject:Cc:To:
	From:Date:cc:to:subject:message-id:date:from:reply-to;
	bh=zoWiebIbVtDuhsoMjJSYIdo5hVIaPwkm9+7phQjDVo0=; b=h/3BC0ZKdx7mIeDA8lxypkqzNd
	ij5FUzrav5Eswnh1sK5cydPH5V5TagRFz7ZGw0Z7tnPbq6UQQovBRrW5K15/WCevDJ1xvC0zIZ7GY
	fuBwSS8upRecnc/BcVUn7MeOm0q6BSZEQPztchUr331gxRwdHloaXbcHghjxv9p91QWneChMz+ihC
	SH2f0za/VBZm8Us0vzOAhKx8RgcBM1o6JUMAwzk5gpDjAM26ajummaj0/NcV0ETSg0wVg5u+F4Nrv
	8U9Xbw0FbD0PEBj3d2P3Jmt7vzWYP5BsdmU+WoP0MX0EUcewxnSFE/9c9VJFA2CeJrkLmgbWh83qF
	7ADbmhBw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1v0ruW-007YC6-1S;
	Tue, 23 Sep 2025 09:33:41 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 23 Sep 2025 09:33:40 +0800
Date: Tue, 23 Sep 2025 09:33:40 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Sergey Shtylyov <s.shtylyov@omp.ru>
Cc: "David S. Miller\"" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	Karina Yankevich <k.yankevich@omp.ru>
Subject: Re: [PATCH] crypto: drbg - drop useless check in
 drbg_get_random_bytes()
Message-ID: <aNH49MZHzZNOGSID@gondor.apana.org.au>
References: <35bd2eaa-3cb2-481a-a02b-79fa1bc98016@omp.ru>
 <aNCo7yjktKTFg9HH@gondor.apana.org.au>
 <12e0fdc7-8978-44f4-9763-7cb4d8376be6@omp.ru>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12e0fdc7-8978-44f4-9763-7cb4d8376be6@omp.ru>

On Mon, Sep 22, 2025 at 10:43:59PM +0300, Sergey Shtylyov wrote:
>
> > then please change the drbg_fips_continuous_test function signature
> > so that it can no longer return an error.
> 
>    I didn't understand what change you meant here...

Make it return a boolean instead of an int.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
