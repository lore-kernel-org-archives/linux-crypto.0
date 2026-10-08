Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62C523EC687;
	Thu,  8 Oct 2026 08:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791448560; cv=none; b=ib02PVpw9NLX75JjbMgB71c9QcJ/xdbP0/luqj68cS2ZOImVMgn/H/hpyise1LFn1uQF5zhyGTW84Ir9un2XI6P8i1n/JrjQQHZ24dtJs7eXCCFFaFTeUDoCG0peHOV5Ehll1nnLLvh6ZHH+aFfnT21QM4382JpAy48Ia0gKOjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791448560; c=relaxed/simple;
	bh=0zO+HFQPlcF1i4bAxLCS8zbkt/uI9s/dRcZOxEHqLWo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XIKR1nlt61DHa8JVeb1iwVzQ572FrCH3fkUx7YLKLrwzMDvd6+NZ+kW63/4F2O0RmeoLEEcBu2bQzGjY26wOYhyLdOf2eGOjA7x/03+zVpkyFBltORjAt2Bc+bte9NzCuiAHsDXoxGzk8/iun7y1ZRQf7x0XVsL5uS81LcBcP1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=V6Azj8CQ; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="V6Azj8CQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=swbz33a1MOM+cAZCMt6I7ez5nLnDR7nUjheJbpYnlxc=; 
	b=V6Azj8CQUf6iYU3uaCLGd0/kMzaJZtx5430ROR29/IgUXJ1SQsId0BN6Xzi75DnGkmzkYRIBjlF
	ZJ9zxfuuEnERmc/YMytSYsKC99MlHdrLAMOaLGKT/vYc9myg4r17ixHE+EBgi+XsCxjfiUicCYuK8
	r8twUnYWkvmProIY6/Ro5ZMX5E2gYHfylLt7jsc/qtDQbLIakQJvyqamkSGkn2Jl8XO+6k0x7rA6z
	kywqU9LUp3dKb3Wa5lSqV6d2C810l8S9l8EJY4N4E+53t2zUq5sRu3ze5dGOlejFp3e8CNJrv7GFO
	W3+P3xeiUHdgmwaWzffMF6oDtGPLUZZWtZfw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xEjbW-00000001o8E-1Lvq;
	Thu, 08 Oct 2026 16:35:55 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 08 Oct 2026 19:35:54 +1100
Date: Thu, 8 Oct 2026 19:35:54 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Justin M. Forbes" <jforbes@fedoraproject.org>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Allow hmac(sha512) for unpriviledged users
Message-ID: <asdV6jia9xxujt7W@gondor.apana.org.au>
References: <20261003160302.3000325-1-jforbes@fedoraproject.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261003160302.3000325-1-jforbes@fedoraproject.org>

On Sat, Oct 03, 2026 at 10:03:02AM -0600, Justin M. Forbes wrote:
> By default users cannot run sha512hmac with the current set up. This
> is problematic because our kernel builds call this for FIPS compliance.
> Rather than have anyone turn off af_alg_restrict all together, let's
> allow a common use case.
> 
> Signed-off-by: Justin M. Forbes <jforbes@fedoraproject.org>
> ---
>  crypto/algif_hash.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
