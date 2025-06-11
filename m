Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF2507485;
	Wed, 11 Jun 2025 09:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749633395; cv=none; b=pTefVwDBmokeTllsb39XGIV0aN1+amROXBT+YyPMcd8swZa/gCikFlHj41qUO8UntqH4dYcLvL601LeKVRwuIjcQS8hQFkFMMzcYKQF2qkWGkMFAveaPObTYpgB+C2IqXb4kCmklg9diHNvnyleOinEfVXCAt+9kldColLWnEaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749633395; c=relaxed/simple;
	bh=dIXFmqO9ilA7Z9VdHlSlZ8eqsNpDXMnR3e+yAlKuu4o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iXZeeHM5knuOfE5hFwb2dN/L/jLDYuiuL1DiPN5QmREZEJvOEGifzkFAxo2PunzUs9mHbGPnUyGoGzcW+S16VJAMAQjzVXIhdMblLrglixXYzBItDyQOHWZZb77N0FELRlJkXtnBye10mQlhjEz7s2cdRrJRREO8OYQnj29UgyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=L8pv/Doj; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="L8pv/Doj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=5DHbHB5XwQ7sCy4c1zryRBuGpd3CYxNRK0kkNo56kZw=; b=L8pv/DojJfGs/tZAi4WrOE615S
	SqtCk3FZilhO45Vx73Pxysp5+oFuG6cFnT/xCNjJNe6kczTAuC7FrUz5SrgBUOlRGZ4a4QzqEd+D7
	A1bZbP7F5apWJYyiRiOWFIcDrhhxfhYA1dP5nveMIKNllt/rJ9WiTitolf3Xwcyem2Uh7zfeEZp+8
	qNomWsgMUZHPwx+IITgq6bRPmdSrhOWnx/m08W4ai9V2Dk96vwJ3vTSi4vsU64uExIWElS/wxtJ8K
	mLLi2jVX8coY6n6DLNis6nXhO0LlTTRAYLsWEDpRPmPQ+Qq0Rl+M30e6ziGwQh11onnSKqKs6DZ/H
	CLHdWZIw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uPHZE-00CJB6-0N;
	Wed, 11 Jun 2025 17:16:21 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 11 Jun 2025 17:16:20 +0800
Date: Wed, 11 Jun 2025 17:16:20 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Wentao Liang <vulab@iscas.ac.cn>
Cc: akhilrajeev@nvidia.com, davem@davemloft.net, thierry.reding@gmail.com,
	jonathanh@nvidia.com, linux-crypto@vger.kernel.org,
	linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: tegra: Add crypto config in tegra_cmac_do_final()
Message-ID: <aElJZAxSVEM4bwBI@gondor.apana.org.au>
References: <20250526020403.230-1-vulab@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250526020403.230-1-vulab@iscas.ac.cn>

On Mon, May 26, 2025 at 10:04:02AM +0800, Wentao Liang wrote:
> The function tegra_cmac_do_final() calls the function tegra234_aes_cfg(),
> but does not call tegra234_aes_crypto_cfg() to have a crypto
> configuration. A proper implementation can be found in
> tegra_ccm_do_ctr().
> 
> Add the tegra234_aes_crypto_cfg() for configuration.
> 
> Fixes: 0880bb3b00c8 ("crypto: tegra - Add Tegra Security Engine driver")
> Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
> ---
>  drivers/crypto/tegra/tegra-se-aes.c | 2 ++
>  1 file changed, 2 insertions(+)

So did this fail during the self-test? Please provide the before
and after self-test results.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
