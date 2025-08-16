Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A51D21B9FD;
	Sat, 16 Aug 2025 09:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755335371; cv=none; b=YxrOOckyYCRy7vZsbwOtw80YWHNUz8yOU7Kgrekbx8JEc4rbqKVramYzElWcFgOk9g5DhCPVTt5LcWGAijcCKco8P+gzxM7CpTfcexN6IicPKNtzmR+S+bhuUhcolYftazKuWc8ZJt7wtFQPW5rh5Em5N4kvLOuea+s+Q3mheS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755335371; c=relaxed/simple;
	bh=sZeCxT7RWN2dvDA/asN0c7waJmCLwx4WyPAavexkuAE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p7EPoXzvX4/roc1wH4Ucs7i4aEmCmqNSGDR6gkjG08XIbSYPfZJ+sd403q8w/oeiW+fBnEFhya5DoJ5J9UzjpVYVeyucXaFzqSGRV6/zPrVGXbF8ZfXh/UTmmkn1+RcdkEEkqD64utN2OzfZ3vxfEfe0TOQDhzOHQFR/UC8vaVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=ZiQi59f9; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="ZiQi59f9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=PsG18bRLbzBDlWWJBWH8shg+HfW363Y8h4z4QtNnMgU=; b=ZiQi59f9VWa4kBg1fzLxkP2ppo
	jrHvLfuXVbTM9njC9u0q55rZzV9M6hIzYUZZt3Hnf4BLqMnUeLURy/BDr07PtNgiXKwt9f8wdp4iB
	D7dpftrau1AEU0atNdINFlPZIaH8Zl3r5U7cBQ8oPFOtDZ0sKLu6fBdlznmQg9hZtbNpY1PZrikZs
	BZ5e0SIba6tYlAyjrhmI2eF9og6XMoaepr6sQ5+q6FgaL3FovP58B0TIMGvtwLdM7gu6ksZXg1WIX
	x29TXp40jIb0D//FJauHhJ+VwUkXVfp6sLaoTtzytc2ZacKiIKS/QTGpqt3QSQI5o/BC7+vKlJOYm
	sqyHPrRg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1unCf7-00Em8c-2p;
	Sat, 16 Aug 2025 17:09:15 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 16 Aug 2025 17:09:14 +0800
Date: Sat, 16 Aug 2025 17:09:14 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
Cc: clabbe.montjoie@gmail.com, davem@davemloft.net,
	linux-crypto@vger.kernel.org, wens@csie.org,
	jernej.skrabec@gmail.com, samuel@sholland.org,
	linux-arm-kernel@lists.infradead.org, linux-sunxi@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/9] crypto: sun8i-ce - save hash buffers and dma info to
 request context
Message-ID: <aKBKul0unf06oBiV@gondor.apana.org.au>
References: <20250728060701.1787607-1-ovidiu.panait.oss@gmail.com>
 <20250728060701.1787607-9-ovidiu.panait.oss@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250728060701.1787607-9-ovidiu.panait.oss@gmail.com>

On Mon, Jul 28, 2025 at 09:07:00AM +0300, Ovidiu Panait wrote:
>
> +	u8 result[CE_MAX_HASH_DIGEST_SIZE] ____cacheline_aligned;

To get proper alignment for the reqctx, the driver should use
the ahash_request_ctx_dma helper.  Of course, the reqsize should
also be increased by CRYPTO_DMA_PADDING.

For the struct member, instead of __cacheline_aligned use
__aligned(CRYPTO_DMA_ALIGN).

> +	u8 pad[2 * CE_MAX_HASH_BLOCK_SIZE] ____cacheline_aligned;

This is to-devce only, right? If so it doesn't need to be aligned.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
