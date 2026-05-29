Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A780360751;
	Fri, 29 May 2026 06:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780034910; cv=none; b=b3gDPTCD4bSRR21YVk1d9TcJSOuMtbn0DKFou8GUAJvDEyF+8BByMgu1e2Pwq2VXaHBOf3ZsAlgz6U2oGNf8kp2So8I0OiepUj9I60CURkmNPqAMX/EtLPpQXndw75qbOnwMFsE5W9hfpyCpHgU4haoiVld0x9LfNqrRe1WHrI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780034910; c=relaxed/simple;
	bh=RBz//esfofXvbehmuF8QGKMMslpRvLKFHYYxjIwoPcM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HAt/nHR68jEl7Cd0ec8JiaexEoEEmi7ilxn16MeiwLsqJXb6PBFeCeyVqc/ileAuDm32Dk7H1Yfjh7sGNmeOV9Swt0IRi264KGbofbdteJSUJiHdGk666nklw+6BSdHm8Qo1BHW2MlrAlwG69W1TNn3isVzqjqiINt1sFTl/dko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=bgYUFCco; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="bgYUFCco"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=bUi6qNPCJHs1zjImKGBpaa0dufszLYZyWbxdSNWETVo=; 
	b=bgYUFCcoZ/+pBgZ4BgEIM/6U8LBKUang6Ju5OrggXpuoRp0Gl2Nbiyn4wG5RsnyqhC8AFiA2M+z
	sB8N/V4dAM+cjb6WaAOgMr7dq0Ga6rQjuYv4ZY70/IqBeGkBIbnThJ8AZVneKlygelhQHm+29jPDL
	BBVLjEXNQEmCJZ+qk7drDf2wpdQjGSMfwQqhqdNQgubnAlquycGI8swLCol7vCqiaflDRpMQQRdft
	wxutGbwemtSLW+6sUHYC9Z4FpZDr3y/mhpSVpd/7/ni8alW/gTZ54KiBFNNEUe5yQgzrJ9EUotnMm
	O7VFLG1N5xH8+q7oH35RkZ6wAhN3UgNGxwuQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wSqOP-000dJI-2C;
	Fri, 29 May 2026 14:08:26 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 29 May 2026 14:08:25 +0800
Date: Fri, 29 May 2026 14:08:25 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev, Huacai Chen <chenhuacai@kernel.org>,
	Qunqin Zhao <zhaoqunqin@loongson.cn>,
	Yinggang Gu <guyinggang@loongson.cn>, Lee Jones <lee@kernel.org>,
	kernel test robot <lkp@intel.com>, stable@vger.kernel.org
Subject: Re: [PATCH] crypto: loongson - Select CRYPTO_RNG
Message-ID: <ahktWQCfZYel_0hZ@gondor.apana.org.au>
References: <20260522022525.12976-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260522022525.12976-1-ebiggers@kernel.org>

On Thu, May 21, 2026 at 09:25:25PM -0500, Eric Biggers wrote:
> This driver registers a rng_alg, so it requires CRYPTO_RNG.
> 
> Fixes: 766b2d724c8d ("crypto: loongson - add Loongson RNG driver support")
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202605201622.qWOiiZTV-lkp@intel.com/
> Cc: stable@vger.kernel.org
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>  drivers/crypto/loongson/Kconfig | 1 +
>  1 file changed, 1 insertion(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
