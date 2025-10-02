Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4478E30505A;
	Thu,  2 Oct 2025 09:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759398593; cv=none; b=BFOouZYeOwmnrkR/JFE1bmvfXhBgKDz9hnGX+6PtVUZz3bTJEaBMbB7h1lmUnvLFAK8jNd335YEVSajeHXokogcGvrImz9e9qtVeMB80cX0m/DGc+B0NxwmutfF3q7lvTmxdO5Ezhmxv+CUf2QUGWaLM9+iUHWHKEQeAbV1bKY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759398593; c=relaxed/simple;
	bh=To+yaYHmSu4iZS7XnhTFFY3y09t7YDgDX6wBnMBqsPg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YTGr3Xlgq8vGXcCUkkB0obLElHpAtZ6eqJXKhNjDauFikMypwMRj1fs2CEqRT4qkAWzZDkudMF7NTp7i4+zszZ9/LuToNyk20DsRElejBOhBxHncY9jaREcBPquR0PFmfQayPSdxo3CVat2ezAB480MIEKXGArElihH/yUWBeeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=BvflF1Xy; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="BvflF1Xy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:MIME-Version:References:
	Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:from:
	reply-to; bh=3W0P4bDWNFT8Gbxvk4ZY9whuakawwnE85T7bVAcIOJA=; b=BvflF1XyYU+xeQIC
	8a6CJyBc0k6UY6olP2p5HSF/Zq4dplOUEfYFzx6h7XSX68qpjxik+4SEXKleVQzn1C2TxCBio1t1r
	vYO1OUfZUeDz/RQi+RD8bgacyl6mpTWBqd30fZHt5G2jCsHoy3N2vY5PFZ8yM8ROeTzqwrUvkY0TJ
	76n1jyqeP+bl/0jnhZHbPp0Drfvn0Jk54wAnEI+yB4hqIUMk/mGmaYO0FkFNd9unKNiieV30FGV1v
	pbNAIaDF+BIS18rbmClSAVhwodBAuag2aDiDtoWDSWA91JzdeUMYNmRYUQErYRci+5jv8NV8hxV/K
	wJHJXAiDX7ph8NDAkw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1v4FwV-009zLy-22;
	Thu, 02 Oct 2025 17:49:44 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 02 Oct 2025 17:49:43 +0800
Date: Thu, 2 Oct 2025 17:49:43 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: T Pratham <t-pratham@ti.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Kamlesh Gurudasani <kamlesh@ti.com>,
	Manorit Chawdhry <m-chawdhry@ti.com>,
	Shiva Tripathi <s-tripathi1@ti.com>,
	Kavitha Malarvizhi <k-malarvizhi@ti.com>,
	Vishal Mahaveer <vishalm@ti.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: ti - Add CRYPTO_ALG_ASYNC flag to DTHEv2 AES
 algos
Message-ID: <aN5Kt3iKmjqYgmPg@gondor.apana.org.au>
References: <20250930102423.2895282-1-t-pratham@ti.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250930102423.2895282-1-t-pratham@ti.com>

On Tue, Sep 30, 2025 at 03:40:26PM +0530, T Pratham wrote:
> Add CRYPTO_ALG_ASYNC flag to DTHEv2 AES-ECB and AES-CBC algorithms so as
> to properly indicate driver capabilities.
> 
> Suggested-by: Herbert Xu <herbert@gondor.apana.org.au>
> Signed-off-by: T Pratham <t-pratham@ti.com>
> ---
>  drivers/crypto/ti/dthev2-aes.c | 2 ++
>  1 file changed, 2 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
