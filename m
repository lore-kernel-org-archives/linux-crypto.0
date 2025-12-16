Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BD96296BD1
	for <linux-crypto@vger.kernel.org>; Tue, 16 Dec 2025 01:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765849824; cv=none; b=svVkUSVxQHeC92BOjVEFgzqdtMVXQS2kM1DezyuOzQrsISl9xt7FswSJ/W8FOgOuLMDL5lqHGMLsY+gtTaPVQwU5L7Q7buco1gjkXMso/Uw98NDlp8bsjgyc77nXL7p9R3q+kuTtbrRmip9rdTtEKXm/O4/iRuyfqh8PlZS2EEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765849824; c=relaxed/simple;
	bh=G2oP2k3t0qbCvIX40HKhg8K5XNp3hsKDqhT/0cfEGPQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HZKjSGn1iJxIAecqvVxdU/2/5v+H6Oi/xloNzWL0jQ82opZXHyBC/Acc7/Qo/snwD+1ZYVTywi6aKOLRF/5pgnibxKZbKO8Ta1MpzmcKAcBPNOSRS2zf55qDLcWItuc15oY7rF8pRiU9V8JBfzfLwMsvjdZxFUKR+qMOWTGgyVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=mr4S1fHG; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="mr4S1fHG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=Ku8VInA82mqWkREp9b2PQtNKD3dV8X3h6+nxzGwgLyA=; 
	b=mr4S1fHGddmKHs08do1iDyPnBape7NJ7t0Or1x4Xg5SK5/We3E8tMfLIt2FoDoM4+wfEt/ZVGRN
	W7YMcbnyAjb+3/pBOlIP2XY9WuRGZQv2GmSHQuAls9P2801cs/4MUAgB9WVnXzS2YfyiViUOc/XRt
	qcFf3QysCHBSWy8AHJ2oJPfuUsfaky8gW8XQ/C8xfzhoIpZa/oY/pA3alW6ZqgcTrPwqkmwfRdkna
	GsAvH2ZuoCdkARyAuxLvsn+bGdj5tQUq7BrxrZ9IoZfNDpe8NC2mTYhbtz5wqb5VU9Kix6eWrTON3
	XOv0Sk3VLqgtSNgwA2cbReXvRf9q433//f9w==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vVKCB-00APHg-07;
	Tue, 16 Dec 2025 09:49:48 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 16 Dec 2025 09:49:47 +0800
Date: Tue, 16 Dec 2025 09:49:47 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ron Li <xiangrongl@nvidia.com>, David Howells <dhowells@redhat.com>,
	Lukas Wunner <lukas@wunner.de>,
	Ignat Korchagin <ignat@cloudflare.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	David Thompson <davthompson@nvidia.com>,
	Khalil Blaiech <kblaiech@nvidia.com>,
	John Hubbard <jhubbard@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	"alok.a.tiwari@oracle.com" <alok.a.tiwari@oracle.com>,
	Vadim Pasternak <vadimp@nvidia.com>,
	"ilpo.jarvinen@linux.intel.com" <ilpo.jarvinen@linux.intel.com>,
	Hans de Goede <hansg@kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Re: Nvidia PKA driver upstream needs permission from linux-crypto
 team
Message-ID: <aUC6u-9r7w1uZH3G@gondor.apana.org.au>
References: <20250919195132.1088515-1-xiangrongl@nvidia.com>
 <20250919195132.1088515-3-xiangrongl@nvidia.com>
 <fab52b36-496b-41c3-9adc-cb4e26e91e53@kernel.org>
 <BYAPR12MB3015BB37C50E4B9647C268ADA9ADA@BYAPR12MB3015.namprd12.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BYAPR12MB3015BB37C50E4B9647C268ADA9ADA@BYAPR12MB3015.namprd12.prod.outlook.com>

On Mon, Dec 15, 2025 at 08:22:56PM +0000, Ron Li wrote:
> Hello Herbert and David,
> This is Ron Li at Nvidia. Our team submitted an upstream review this year for the BlueField PKA in-tree driver:
> 
> https://lore.kernel.org/all/20250919195132.1088515-1-xiangrongl@nvidia.com/
> https://lore.kernel.org/all/20250919195132.1088515-2-xiangrongl@nvidia.com/
> https://lore.kernel.org/all/20250919195132.1088515-3-xiangrongl@nvidia.com/
> https://lore.kernel.org/all/20250919195132.1088515-4-xiangrongl@nvidia.com/
> 
> The maintainers asked why we don't use the kernel crypto API, and we provided the justifications:
> https://lore.kernel.org/all/BYAPR12MB30157EDAC502D14D7E0E5546A9CCA@BYAPR12MB3015.namprd12.prod.outlook.com/
> 
> However, it's still recommended to have the explicit permission from the linux-crypto maintainers.
> 
> Would you check the patch and our justifications, and suggest the next steps?

Adding the maintainers for asymmetric keys as they should be able
to provide you with the best advice.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
