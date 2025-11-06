Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEC81279DA2
	for <linux-crypto@vger.kernel.org>; Thu,  6 Nov 2025 07:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762412640; cv=none; b=fTqGTffoNqBd9bCMdhUxYO39nNErHWC8xSoIZkJIjCaqr1YId1HKV9XmpQteTSTJP8HE/gUI6o2d4q/fgVId57p9T0MnvPZhucg+qoQWucuh/qAAMW+5nU1IOUUl8j/QpyktxzVB3rZWwRXchvE4YCerpniVeVA/tqYJ6gA85cE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762412640; c=relaxed/simple;
	bh=xLLx5CikeKrn9ICvzdhMUtURNXu3hla7AbVwdqfLV+4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aHafzAxsZzPdKEFJlI5fh2RhfegEJZQPYeAHDUgznGzufmZbxgMIJcn+N65MU3jBUwYyWV6OLO73OYxt74pIb3HkcwJ56h4K6Rp9o2cjYGIYHYvMOZ0I1WtxlPxImFuj6JMaK5fsKoJ9vMqdRUGrpQgZdxfMgcCHTm7M0tENRy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=TSh45tci; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="TSh45tci"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=mtEHSoxFkZ/Lv6bOJriaZsc80akfuOEdkJHY6YxYJQw=; 
	b=TSh45tciGUleDJo7Orhg3JsL3XD73WhnL9lgwieukcihBRZMk7TNkm3dqrEDZENSKs29FZyIpyy
	wyw7xrWhtEk8ahCLuwDvZbLh82iLgaolb+Bpfp4a4p/RpSkKF7fKam/MeUSndLPHmUbPpHrfcmWHQ
	naQTFqhdvXfibtj8HLkeV2WDV5A0TkNKFuFZnDwgLW8eu5M/n14k0ZYfHGWu1msUlQsVvhTsKFA84
	jr9ivxwy210jrh8DWiWmf6GwsQd1dBReX5thM+zSVghVy0blFWiQ9lc4FsQxfpfpZtQcBaE4sAhfP
	EjvQmZDdlc0nJ5yowY8YDFJwk8R2bUzkRNBQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vGu2D-000rXG-1c;
	Thu, 06 Nov 2025 15:03:54 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 06 Nov 2025 15:03:53 +0800
Date: Thu, 6 Nov 2025 15:03:53 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Harsh Jain <h.jain@amd.com>
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	mounika.botcha@amd.com, sarat.chand.savitala@amd.com,
	michal.simek@amd.com, kernel test robot <lkp@intel.com>,
	Julia Lawall <julia.lawall@inria.fr>
Subject: Re: [PATCH] crypto: xilinx - Use %pe to print PTR_ERR
Message-ID: <aQxIWYSFxpawDZYx@gondor.apana.org.au>
References: <20251029070838.3133358-1-h.jain@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251029070838.3133358-1-h.jain@amd.com>

On Wed, Oct 29, 2025 at 12:38:38PM +0530, Harsh Jain wrote:
> Fix cocci warnings to use %pe to print PTR_ERR().
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Julia Lawall <julia.lawall@inria.fr>
> Closes: https://lore.kernel.org/r/202510231229.Z6TduqZy-lkp@intel.com/
> Signed-off-by: Harsh Jain <h.jain@amd.com>
> ---
>  drivers/crypto/xilinx/xilinx-trng.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
