Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A6CD376E9
	for <linux-crypto@vger.kernel.org>; Sat, 24 Aug 2024 13:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724507514; cv=none; b=iPOAC9Sq7Ji5/uGOPTmQHW7CxQnyGFyQYLmct/d3l7Riw4sviQCq5EhopwgEWxfVbI40h70zpZTBGYpSv35xhQIzcDi0urHKW3qaPmANM0JazoAL/9dHt+K/0xzJYdxQ9g/DoQSFHYz25P7ybpJw8V/aNOpV0kXHJCyldfYJSJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724507514; c=relaxed/simple;
	bh=xMSGHEhDMLz62YEvLlrA4p+XNCqMPQ/89FepRx2SzX8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FKkLXkdX+63gXi8LazymHQByimKfku8i9GGXTYnK8whORnB6Tg47bprOosaEdhF2zkXlYT0hSwNA+HuBGvvuewqX42aaa4ZJYcIgDv2PPjjALAH4YaXpYHizy1GR0Vdnv6jCx7uBnl/7FBZoza7sR3R1/j9MqmtBdlTKoec9W4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1shr2l-00724M-3C;
	Sat, 24 Aug 2024 21:51:50 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 24 Aug 2024 21:51:49 +0800
Date: Sat, 24 Aug 2024 21:51:49 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
	Svyatoslav Pankratov <svyatoslav.pankratov@intel.com>,
	Xin Zeng <xin.zeng@intel.com>
Subject: Re: [PATCH] crypto: qat - fix "Full Going True" macro definition
Message-ID: <ZsnldZbalnV3a33T@gondor.apana.org.au>
References: <20240815154736.58269-1-giovanni.cabiddu@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240815154736.58269-1-giovanni.cabiddu@intel.com>

On Thu, Aug 15, 2024 at 04:47:23PM +0100, Giovanni Cabiddu wrote:
> From: Svyatoslav Pankratov <svyatoslav.pankratov@intel.com>
> 
> The macro `ADF_RP_INT_SRC_SEL_F_RISE_MASK` is currently set to the value
> `0100b` which means "Empty Going False". This might cause an incorrect
> restore of the bank state during live migration.
> 
> Fix the definition of the macro to properly represent the "Full Going
> True" state which is encoded as `0011b`.
> 
> Fixes: bbfdde7d195f ("crypto: qat - add bank save and restore flows")
> Signed-off-by: Svyatoslav Pankratov <svyatoslav.pankratov@intel.com>
> Reviewed-by: Xin Zeng <xin.zeng@intel.com>
> Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> ---
>  drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
