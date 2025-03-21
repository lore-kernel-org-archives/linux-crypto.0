Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D78F214A7A
	for <linux-crypto@vger.kernel.org>; Fri, 21 Mar 2025 11:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742555061; cv=none; b=gPZov1akHI6yXv1hmir3+NfM0p5Bv9hONq+SsFfy0GAgDrk8cO4itx55ZA8vUlLZbmwah/4ud/P60Kv3B6tZKItBkpZSdETFDXagNpoyJStMqaRaFv3wOkOTO810VHd1HqB5SVlTNouKKES6zS0WtIi7isgSIoVuymAXT+wI7Jo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742555061; c=relaxed/simple;
	bh=79AtSo2eux+y9fbeXMyCV13gPb2BfHYqM7TrFziG948=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bPCfDrtosqyXOBxlT9GUD4ww0hrRtXXqR7jgKBiJ1lmzoXGyfXerZDUVvK0VeUTinhi7p2YikJEqVnLzc/D0bCkSE/VZdTY7C7getD1CjT3cCJTkTvhoc2BiF9k9wYKfbtrCJtL1lRfX8cLHi9jftZ7gVoSyP+9IFNFkL3kS458=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=frGGp1rA; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="frGGp1rA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=FpvjS9rHVe7oud2S42b4yFYQTjMyxm/2dGyezYoS8Gw=; b=frGGp1rAJVZyEJhShe/DCuGqHg
	wmJrvaQKUYK3LGopv/yiW11i5goVkD1Yfv98Lhh5jv6r772m8Uy6PB2YkW0btiB+DjzZh/cb0ALbO
	1mIlBd+xPD7Slee8MS7EjNizGxEEhvg5katTqxQrc0ciuUwLTqq3dS9vMYAUWtA170kWSd3C8ADod
	MzS1lsgoooShC4b2MeB+ILHzXW783kAIwJT7wvfLlTlrpSCYXnZ7n+hrwsR2ci6CuyF7AuuxQhbWT
	0hWv+bNl9e+ulJLwZPXEg8F7pz2+xtGIOCFvhclWmCpigQa08/1DcxjjSZFSE04CL8QcwrtqkYh4S
	LjxP9uGg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tvaAe-00909p-1m;
	Fri, 21 Mar 2025 19:04:13 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 21 Mar 2025 19:04:12 +0800
Date: Fri, 21 Mar 2025 19:04:12 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: [PATCH] crypto: qat - add macro to write 64-bit values to
 registers
Message-ID: <Z91HrG-GM_Px8bNk@gondor.apana.org.au>
References: <20250310161540.510166-1-suman.kumar.chakraborty@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250310161540.510166-1-suman.kumar.chakraborty@intel.com>

On Mon, Mar 10, 2025 at 04:15:40PM +0000, Suman Kumar Chakraborty wrote:
> Introduce the ADF_CSR_WR_LO_HI macro to simplify writing a 64-bit values
> to hardware registers.
> 
> This macro works by splitting the 64-bit value into two 32-bit segments,
> which are then written separately to the specified lower and upper
> register offsets.
> 
> Update the adf_gen4_set_ssm_wdtimer() function to utilize this newly
> introduced macro.
> 
> Signed-off-by: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
> Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  .../intel/qat/qat_common/adf_accel_devices.h  | 10 +++++++
>  .../intel/qat/qat_common/adf_gen4_hw_data.c   | 30 ++++---------------
>  2 files changed, 16 insertions(+), 24 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
