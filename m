Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2D5E27FB1E;
	Fri, 17 Oct 2025 08:25:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760689546; cv=none; b=jFtCiYCJ2/L5fR7ifT5psPbsWU2ZvUi54wDQPIRXGuCWifvg1TiWvrruQHpIYDDFAH5lMH4VlkgItcaXb3iDGJweYWvzj/lDqT8UFzbFiocipYR0h34S9Wh1eHt48M3d3wNLUcWeDgP/aULfR8VYStEiJuDlyWSu2XuS5qLhqIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760689546; c=relaxed/simple;
	bh=crGhxP2XPChdCRTll3MItpLW+qrXhpcZraQXV5TGIHA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j88iSHgNIvxiSwNthNYP5AZRfcZI95NCa13Ztu2pNzEc6Vd2K46TtqbTvMb8bKC3ZORs8S8K87Gu1uz2ZjFXM9kqYj76qOIRwUjlih3+gsmHW8dNfMiZq342RQhOLrGUPvMS9f3CbrCUHSy2F4sXX4xB6XlccQEtTP/XtRkENr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=dInuwgmE; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="dInuwgmE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=e76ofERkLSKsm6KZLfoUt2NM6P3sOScL+Jzu9OwlTUw=; 
	b=dInuwgmE3uFw3UZkirPm6rITApJOW8+8kIryPbPqcNk5YY1yKWv7vkc39Avjo0EBM310JmbLT+b
	5NKHN0+cEWEyqnlz/VI0qxnkMJ4tFNDQjPghhW3e4tzYEtJU/MPDCyHVqeC92tXw1uC/ETp6yrYKp
	5K0nVYqojG5PCE/z+8IEL46MibhAxo/ijuNTOVhK/CDCZnK8Uz0FfwDTZK+CXpmaFmLx5nfomtAve
	Kt747ofaTtISOLh0qGjYiT9QUNz8XjzWT3gkr8/c1OG75NNMwCFYZ4AgkKweoiRq7x7PHM2qZ3pwN
	cQHKAgaVeIhUysliCMYWDBgWFZe+tVPJYiLQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1v9fmL-00DN80-1g;
	Fri, 17 Oct 2025 16:25:38 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 17 Oct 2025 16:25:37 +0800
Date: Fri, 17 Oct 2025 16:25:37 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: T Pratham <t-pratham@ti.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Manorit Chawdhry <m-chawdhry@ti.com>,
	Kamlesh Gurudasani <kamlesh@ti.com>,
	Shiva Tripathi <s-tripathi1@ti.com>,
	Kavitha Malarvizhi <k-malarvizhi@ti.com>,
	Vishal Mahaveer <vishalm@ti.com>,
	Praneeth Bajjuri <praneeth@ti.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: aead - Fix reqsize handling
Message-ID: <aPH9gTi-EuL5Gd3s@gondor.apana.org.au>
References: <20251008100117.808195-1-t-pratham@ti.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251008100117.808195-1-t-pratham@ti.com>

On Wed, Oct 08, 2025 at 03:03:14PM +0530, T Pratham wrote:
> Commit afddce13ce81d ("crypto: api - Add reqsize to crypto_alg")
> introduced cra_reqsize field in crypto_alg struct to replace type
> specific reqsize fields. It looks like this was introduced specifically
> for ahash and acomp from the commit description as subsequent commits
> add necessary changes in these alg frameworks.
> 
> However, this is being recommended for use in all crypto algs
> instead of setting reqsize using crypto_*_set_reqsize(). Using
> cra_reqsize in aead algorithms, hence, causes memory corruptions and
> crashes as the underlying functions in the algorithm framework have not
> been updated to set the reqsize properly from cra_reqsize. [1]
> 
> Add proper set_reqsize calls in the aead init function to properly
> initialize reqsize for these algorithms in the framework.
> 
> [1]: https://gist.github.com/Pratham-T/24247446f1faf4b7843e4014d5089f6b
> 
> Fixes: afddce13ce81d ("crypto: api - Add reqsize to crypto_alg")
> Signed-off-by: T Pratham <t-pratham@ti.com>
> ---
>  crypto/aead.c | 1 +
>  1 file changed, 1 insertion(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
