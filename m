Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D2E32D9797;
	Fri, 31 Oct 2025 09:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761903416; cv=none; b=W5E1p2cWrZy2eYKBdQoBXWHNSF1y9FdHwcahT/p5wdBM5KlNB5Mwv3tusmtqoc6CcimfH8SrNbg1u02AZpHaVjuXPNutGPSDMsDF/M6foXeUXTqJ92RDQvnEtgGBj0ttF83NLQSswQPzb1ph9fze+LjgnEi4cQ+Cxfv5UM40Vqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761903416; c=relaxed/simple;
	bh=ns3Df3/IDjgiLjT2xWQPnkTNmJNCSUdEVm0TyzBHwhY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QpkRM+xXj/PhFBIgDx+P/uvxS9e5CFb5zNuTzjx7+oBsDdwCUWX9jat5lijTkvxtfqAiAQo+7qax6H+lmZJoHv7wZ+uYjvLl3zvmznUHJTA5O9RMeGnm+ZW44BRnULWPA5zSQi6yJrwoiShZTrZf3balzS8ba2eWPY0O6JpV3No=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=ZB8rS59V; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="ZB8rS59V"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=cqeky3OkmbvUdQlSzLhyQGgk21GypekfDm8TxtKkmIA=; 
	b=ZB8rS59V42dcerMAQy55TktpfJLJWmU3JN+nxl4PBRX0r+LXNkwl+VYrTnczl+E1kEW56Yh8XMv
	oZCvBaZLxx/mckA8gsoZwrgCEviUipFkDFv/XqFNshEPuXaxvk2hezJxcl3fLcwoLJbXASlGheyaH
	a9z9PC9goYiay1SLqasO7ucjfEAsNJ6MHSNl9VgQ2xtmM+wXoILWgRAOEtiQGXA8KCA0/+VunXHNL
	o34XdzQBVBeEWVh9PsjgnmVcgIbovLLrx0wVKhvXmTFUv9Os1ebU8aSp9qIAMfo7Dy6q+VNu9m1zS
	AGv0mGvrXaBPtOsosPPUZA/+vjKd/a0CA/LQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vElYs-00H1YE-0T;
	Fri, 31 Oct 2025 17:36:47 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 31 Oct 2025 17:36:46 +0800
Date: Fri, 31 Oct 2025 17:36:46 +0800
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
Subject: Re: [PATCH v5 2/4] crypto: ti - Add support for AES-CTR in DTHEv2
 driver
Message-ID: <aQSDLpD2LXlqILku@gondor.apana.org.au>
References: <20251022180302.729728-1-t-pratham@ti.com>
 <20251022180302.729728-3-t-pratham@ti.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251022180302.729728-3-t-pratham@ti.com>

On Wed, Oct 22, 2025 at 11:15:40PM +0530, T Pratham wrote:
>
> +	if (ctx->aes_mode == DTHE_AES_CTR) {
> +		/*
> +		 * CTR mode can operate on any input length, but the hardware
> +		 * requires input length to be a multiple of the block size.
> +		 * We need to handle the padding in the driver.
> +		 */
> +		if (req->cryptlen % AES_BLOCK_SIZE) {
> +			/* Need to create a new SG list with padding */
> +			pad_len = ALIGN(req->cryptlen, AES_BLOCK_SIZE) - req->cryptlen;
> +			struct scatterlist *sg;
> +
> +			src = kmalloc_array((src_nents + 1), sizeof(*src), GFP_KERNEL);

You can't allocate memory on the data path.  The request might have
been issued by the storage layer and doing a GFP_KERNEL allocation
here risks dead-lock.

Failing the allocation is also not good.

Ideally you should make the hardware deal with the multiple of block
size data, and then handle the trailer in your driver.

But if it's too hard just send the whole thing to the fallback.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
