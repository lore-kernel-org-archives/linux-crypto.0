Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A851A1F91C8
	for <linux-crypto@vger.kernel.org>; Mon,  5 May 2025 12:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746447918; cv=none; b=Qlu6KBQzXN6Te2y3ahBIWkHlVBmzw2bCeokDTBptjoLqYLrn108lIyKzDnjJtLy7BU7B5eN/9elwxszNE1Ob1PqJri+KvH0LP7XG9bkkJt1veQRHn1gO7kUgk0qlI5M1fmpqK1Mn/QhgoL4nbdNPjlEYAXtm0JImqNleWBGce0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746447918; c=relaxed/simple;
	bh=zda+kHXe+TVAVd1aUYC09XowZOFc6jws/n6/xUlK82Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ej8vIEVit5D90noZfBxDun2i7PPTot85gqkPzRMLUV2tOspc8ckI2nnKeoh/dpBrO5O8Nee5Vtgto5Q8Th5acOZ70BaTtbuxWJs5bgx73Bu//9JUsbMP9uLxcXMKdmU/l8SvN7nSPVPWdTg6WrqQhpxxoq5i2gJo3E9UYP4GuaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=qjSb7Ctp; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="qjSb7Ctp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=dCXVnplh7d3VE+sraH655yNsRum4Q8AJMuWZVIstilw=; b=qjSb7CtpyWHkXdKsCzKF27ndor
	vJTK1W37Vztv6oH2hvWT+bEWbNlzo3Maf/UZYGCCiudYzq0QmsEhDtgAQD876Tz7Vo799PwejOfyU
	2gNx4S9V1169PkR5zDvpLQHoC/+AvqtvglkrB2T48YdCvGoXgE117b9WsAvb/Wjmg9TnAuBeS6zda
	HH5Zgc19jNT8E9H/0lvEEnx0ZFTY8OaK4Xh8G+jExhSLZ1TIi8ewSQa77V4Ai+wIRISjfDobXbXtz
	E2xU7XESGRd5fI2SAJ5u3cIAj0WEJFx77KQ550VFCbX1txE8KivjLqsizZYWC8I6Z7VlhPNdxkz8L
	LAEU1aOQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uBush-003YFX-0M;
	Mon, 05 May 2025 20:25:12 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 05 May 2025 20:25:11 +0800
Date: Mon, 5 May 2025 20:25:11 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: Re: [PATCH] crypto: qat - include qat_common in top Makefile
Message-ID: <aBiuJzTI384rN1Bp@gondor.apana.org.au>
References: <20250428172426.861977-1-suman.kumar.chakraborty@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250428172426.861977-1-suman.kumar.chakraborty@intel.com>

On Mon, Apr 28, 2025 at 06:24:26PM +0100, Suman Kumar Chakraborty wrote:
> To ensure proper functionality, each specific driver needs to access
> functions located in the qat_common folder.
> 
> Move the include path for qat_common to the top-level Makefile.
> This eliminates the need for redundant include directives in the
> Makefiles of individual drivers.
> 
> Suggested-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Signed-off-by: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
> Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> ---
>  drivers/crypto/intel/qat/Makefile                | 1 +
>  drivers/crypto/intel/qat/qat_420xx/Makefile      | 1 -
>  drivers/crypto/intel/qat/qat_4xxx/Makefile       | 1 -
>  drivers/crypto/intel/qat/qat_c3xxx/Makefile      | 1 -
>  drivers/crypto/intel/qat/qat_c3xxxvf/Makefile    | 1 -
>  drivers/crypto/intel/qat/qat_c62x/Makefile       | 1 -
>  drivers/crypto/intel/qat/qat_c62xvf/Makefile     | 1 -
>  drivers/crypto/intel/qat/qat_dh895xcc/Makefile   | 1 -
>  drivers/crypto/intel/qat/qat_dh895xccvf/Makefile | 1 -
>  9 files changed, 1 insertion(+), 8 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
