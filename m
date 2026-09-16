Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C594438911B;
	Wed, 16 Sep 2026 12:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789563215; cv=none; b=D7AB8ri3t6PkP3YI2GT6v3lTLoEkB4abcHD9zfIv6RuNWCs+VIoj//EJJpuFtPNr/kuljFLMI/2D7j8eIrovbYeRr5iMcaDEMPUlP323UnACID1w+/RxUVXKVhOIYoVRVWY6A82GXPip7qu5MnTO/zD/LcWh07l/PXJjMUOnV3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789563215; c=relaxed/simple;
	bh=TbLRaXkDrq80hEWcR1PWe6s0di669QdnDK40nHuJWF8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sERO8IVmcFd8DeKvoFR5UmaUyrD6Aw48AvrnH1HosB8le8pOJp3m7AHjncWcss6zrhdFdGy02sKEifUoMgu660Q1kQu8iWkdZVCCuFWoLnmpJq7OMHW764sDO+zMOBmG2rroVe01M9wbFuPm7wTiLKP7Z6+UTOOOAwLrzHTk0CY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=tM1doCnj; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="tM1doCnj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=d86Tf0LllrXXpe+yggb0gJXtQSGuOtZBdvyxrLeFofM=; 
	b=tM1doCnjaU5WeMhOXF7rJ8vHCR2pK2UIp4JEwU2GFPbWi89ekVLHxquWQB/ij1vIKgUvbybiwEM
	S9FF1kV0uGkYcI29bx4aVhL5Tju4moOY09AhcKV30CXPLx2X1AE/cFjSix1BzWOk9Pw8jWRKH9Ghf
	I06a0I/U+yCeLQiN9qWjIM9iCpKS3xrxMZ1sUZmnBLB14noURu8MP0mTDenDZ/3THFEdCixfC4dV5
	SZnPbf3LvPAF0Fnm8OolNkxf8rsxsSnozCNB3ewEVUwfAOIudWwiH92bkm2Kirp0VLYk5pDiIdfbC
	eqnvkdvatQn5K9pEnDQLgAGNH6ZvCIcBSYhA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x6p8d-0000000EcXk-3WFx;
	Wed, 16 Sep 2026 20:53:24 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 16 Sep 2026 22:53:23 +1000
Date: Wed, 16 Sep 2026 22:53:23 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <blum@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: atmel-tdes - simplify DMA buffer initialization
Message-ID: <aqqRQ-vn3l2-bjWs@gondor.apana.org.au>
References: <20260903210845.162790-2-blum@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260903210845.162790-2-blum@kernel.org>

On Thu, Sep 03, 2026 at 11:08:46PM +0200, Thorsten Blum wrote:
> Calculate the buffer length in a single statement and simplify the error
> handling. Inline the dma_mapping_error() checks and return -ENOMEM from
> the common error path. If mapping the output buffer fails, unmap the
> previously mapped input buffer first.
> 
> Also use dev_err() to log errors and %zu to format size_t, and clarify
> the error messages.
> 
> Signed-off-by: Thorsten Blum <blum@kernel.org>
> ---
>  drivers/crypto/atmel-tdes.c | 36 ++++++++++++------------------------
>  1 file changed, 12 insertions(+), 24 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
