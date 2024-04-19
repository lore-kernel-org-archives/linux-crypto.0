Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8ED57F7C3;
	Fri, 19 Apr 2024 10:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713524253; cv=none; b=erTBYRn5HaONNM8RsRqIcz0z/p7PPoLdBSlIfEQXh4rIwFPipCN6oX17va2OHLcvSsytziMc4TPZSwpjAQXuURiUjwGwpYq4SHW5U+bPcZSh7Ap3hSNvT+kvYMAekl39Su/J+tz+1qJG4RKy8ZOCDUax2KGJQOvPhwESxiM2l60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713524253; c=relaxed/simple;
	bh=Y3bZAMS4ybnNbjmn7/PqJk5ZJemVjRctPVPsq2cjzik=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=akesL0e3o6yoEpFejlwhTJbCCvspt9IhBbEv1MeU39i+MYx4eZPtsNUfYqwbR8zlA2f7+yKk2H1anR0y0O/78spvypnwFNncTpb5L5uRJrCy6XIHlG1+VwjbV10RD4jwNrbYRURcLpUaCfQKcM9tGnlgc5UGUgWCKs/sHwj38Is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1rxlvb-003sPA-Cq; Fri, 19 Apr 2024 18:57:12 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 19 Apr 2024 18:57:29 +0800
Date: Fri, 19 Apr 2024 18:57:29 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Chen Ni <nichen@iscas.ac.cn>
Cc: bbrezillon@kernel.org, arno@natisbad.org, schalla@marvell.com,
	davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: octeontx2 - add missing check for dma_map_single
Message-ID: <ZiJOGZrdIAVyMAIV@gondor.apana.org.au>
References: <20240408015914.101442-1-nichen@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240408015914.101442-1-nichen@iscas.ac.cn>

On Mon, Apr 08, 2024 at 01:59:14AM +0000, Chen Ni wrote:
> Add check for dma_map_single() and return error if it fails in order
> to avoid invalid dma address.
> 
> Fixes: e92971117c2c ("crypto: octeontx2 - add ctx_val workaround")
> Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
> ---
>  drivers/crypto/marvell/octeontx2/cn10k_cpt.c | 4 ++++
>  1 file changed, 4 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
