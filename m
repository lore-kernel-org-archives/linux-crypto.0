Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BACB34C12B;
	Fri, 16 Jan 2026 06:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768543505; cv=none; b=ALdI5b0sP++Ej5NiPCmdZu6IDTtZC8f62e2dUNNgVaYQ9c2i9x5C1B/EiqISMhSu66JV8fKj2b1cwx/phzLB7EbGMbI+LkIkEX8WwLJqlgUbC+yCG4AUpbCdBauvF2EB5TH6X/mP/cK4pUKvxaPh/CsMXdoEn/El8w8qmp227xE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768543505; c=relaxed/simple;
	bh=FN+aCEE1iL9vdrvoKuxmZpihrD+8k45ikhQ9R6hm4Sw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qrnnon14D/r9ZDYfeP+ksIwqFHIiVWG3PkRufALTZrKyAij+hSJgpCPA/FTo52XkeDlv28rwH6UyaZRbmwvy+atAhEZ46bdX8fxES3h6fY9M+KnfKiDT3Tr7IMC9Qu0fJ0O7/aYFdATRaI+7EZBzV/cZI0LfoV+kSLMjKa9nLIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=k5YMD7Yc; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="k5YMD7Yc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=FpAwuq56UqWz07ahsm2U5uuWNsHxpefhN/wuvpIhlCY=; 
	b=k5YMD7YcY21vXPmiZlH7WYkSzCjFleD0zlIRR9tnG7ILWjVpuE7ATrCdzc+JrrNrodEs+2Xd/7s
	oKaSkhCS2EdUDb4HIyh+sNN2VWzN83XMQammDxn3Xqt+tcsW5gEAk/3RJ7WnHgQbe8PxNPRDMzJI7
	iUf3ZZB5Qq5s0Qbr3DL5AU7oFgHNIohlYbN72PPS827kQaQW6w9YCYp8rElfJVXHaEgz9bCQOi0y9
	N8u70p5KfbFPTnPNT2HVX2uqWdfpUX7bmaxT/MLeMxQns6M6YjNVazWieJyb9x3yuQTu9OL0LSIIl
	cNKX1ruVTndJbTof8Y2ohqbeRlaKCmcGvMnw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vgcx6-00HDMw-0t;
	Fri, 16 Jan 2026 14:04:57 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 16 Jan 2026 14:04:56 +0800
Date: Fri, 16 Jan 2026 14:04:56 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thomas Fourier <fourier.thomas@gmail.com>
Cc: Srujana Challa <schalla@marvell.com>,
	Bharat Bhushan <bbhushan2@marvell.com>,
	"David S. Miller" <davem@davemloft.net>,
	Lukasz Bartosik <lbartosik@marvell.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: marvell: fix dma_free_coherent() size
Message-ID: <aWnVCF78G3ZMlHER@gondor.apana.org.au>
References: <20251218101259.47931-2-fourier.thomas@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251218101259.47931-2-fourier.thomas@gmail.com>

On Thu, Dec 18, 2025 at 11:12:57AM +0100, Thomas Fourier wrote:
> The size of the buffer in alloc_command_queues() is
> curr->size + OTX_CPT_NEXT_CHUNK_PTR_SIZE, so used that length for
> dma_free_coherent().
> 
> Fixes: 10b4f09491bf ("crypto: marvell - add the Virtual Function driver for CPT")
> Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
> ---
>  drivers/crypto/marvell/octeontx/otx_cptvf_main.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
