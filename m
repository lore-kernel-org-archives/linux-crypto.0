Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C384D1A6822;
	Thu,  4 Jun 2026 02:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780538508; cv=none; b=qfqPxoGuokTjdUWzfUQLCVoCNQqxRDBCTxyvhOofn/+laVYEo9M+cke9ep8L6iUr6DwtlFaEWgK1O2a/JvjoHLcF9aEqgCPwrlYuOWZHWH+vloBlvwMiJCM9UGEVumhQipS+g3UhhVSZ0yl0DWPdn82a6lTAkO4PrJtJ1xy/WQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780538508; c=relaxed/simple;
	bh=e5mkK9PoC3Bvz4+z3gJ98WPOxTQQkV5l42WCSMAbTdI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CqUw7B5Ew8HZEqBL10wiMNg8oRGb85tnpLUl20mxbQQqYeQjj7fgClY/zQ4P0q0pdM4dks4DZ8heoj6VoQ8X1HggpoYNLQ6vihOZ9zWH5uo7IHFpf5TJaByZ+WWVOESJyTjCNicOAvK6D6mk1eLMHonhn/pIrUgsL/ZwIGvndPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=XjyLTSSX; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="XjyLTSSX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=MI3brEEaTAwdgrtrzuIzMmSJFaeGXyuOqsGFkQ7a85k=; 
	b=XjyLTSSXKXoBn1vcFIGtTBTIR5kY/WCwFl8Gdoh6gSb8yZweIMnv2M7BOYuVegOT/syGObSdV+S
	0IVKzh5Cgyh0C4gZfeU5hBdTNht08GUVoNs7mJ+9Z7MKQ44ZowzAHot2VogJFq9jkfSvnMmAkyxYO
	BTvbJxgNMlKP37yX314w/3O9qSmSxYAqj4eh1FP6AjcDmOMUpaOYDWqsh+rRnKMPglnbGciy0Sb2A
	M72OTXnOmDsnK0w4URoMlRlh5koreiCpJzhk5otfqc1m2pqagstYLI8M+ZQC0ZMS4yDvWNFtD8W6+
	2F+eTTrTYh8Y4RuG/Fsu4MqeQ+IvU13q7x9A==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wUxOt-002DLW-0U;
	Thu, 04 Jun 2026 10:01:40 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 04 Jun 2026 10:01:39 +0800
Date: Thu, 4 Jun 2026 10:01:39 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Wentao Liang <vulab@iscas.ac.cn>
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3] crypto/algapi: fix refcount leak in
 crypto_register_alg()
Message-ID: <aiDcg4CL92mdFqfA@gondor.apana.org.au>
References: <20260603082140.3719314-1-vulab@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260603082140.3719314-1-vulab@iscas.ac.cn>

On Wed, Jun 03, 2026 at 08:21:40AM +0000, Wentao Liang wrote:
> When crypto_register_alg() calls crypto_check_alg() successfully,
> the algorithm's refcount is set to one.  If the subsequent handling

The algorithm wasn't registered anywhere and the refcount isn't used.

I fail to see the point of your patch.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
