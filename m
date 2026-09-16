Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43ACE3803CC;
	Wed, 16 Sep 2026 12:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789563172; cv=none; b=RIx/UCnv7u5afZ0J/djZun5Sxvm47GvXvdkZze7+b+Y39rK85DgrCoBum+Fa0USNw9z6QH4lI9zB6gU32VM4LR0Y/uEG5ScBSnV2ummKLDl/ZZVMyGjC8Ie1QfDzE4UHYZ4+3Ikf8Yl/yE9uCRalfN1MFi4+3JAGcyAZS6SyhLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789563172; c=relaxed/simple;
	bh=OpXUFrvWY5AcSjxr2LePO763pTvLIjLpA1Dpa0pMRD4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f8cthehPfoi+pT0lnfdYeXeVnAWEG5NAhnv7P911rC4adgyz6gt8FtiTaLYud22bAvgR2ayHwsA6AqSJuOWLk/1LAk2nwtz6XyokalBmgSoySctxQ5TRm/k1qTiQMLEf2t7xpR5rgVuAAXCZhbAzMwACVY+kSjGK5eelejUeRK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=XABKVAcb; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="XABKVAcb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=5sLtuH87xZswkz1I2OTACybW2ceK91Y8QH5ha9ovOPE=; 
	b=XABKVAcbWkT4CDfcJWoPN8tctUEOcZsZajuH7ys8f4OfgYkjTj3xbb8D5rAq53uF4blCj4qT4Tk
	Y120Aay7Ooog2v+FdbEScWAL8UJ3QkV8RHbxeVK7LrtG/gFwi/3p52IqKSNDNvJ6g69qqw5pcBq4C
	YxO5t5Fihqc1byxvJasgrXyJg3PqbIyuUzMcDxba+bQ3JjYT7zP2CSCodg6klfbWgXyHNAHRV4Ref
	0D2NiP+c6TPlMP47xTP31qQHkEhvyOs0xwQ2DfdBuI04IjVT+SBdgobyiE1JJ9I/z/F82WScQOCSv
	uN53C8pRlXJ6cLMbfL1wvD/NLClOGBiEzEpQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x6p7w-0000000EcX0-24ty;
	Wed, 16 Sep 2026 20:52:41 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 16 Sep 2026 22:52:40 +1000
Date: Wed, 16 Sep 2026 22:52:40 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Aleksander Jan Bajkowski <olek2@wp.pl>
Cc: ansuelsmth@gmail.com, atenart@kernel.org, davem@davemloft.net,
	vschagen@icloud.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: eip93 - fix ssl mac bit field definition
Message-ID: <aqqRGKw3Z7WAJrXm@gondor.apana.org.au>
References: <20260902205509.84019-1-olek2@wp.pl>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260902205509.84019-1-olek2@wp.pl>

On Wed, Sep 02, 2026 at 10:54:28PM +0200, Aleksander Jan Bajkowski wrote:
> Checked the register definitions with the documentation[1]. Turns out
> that the EIP93_SA_CMD_SSL_MAC bit field has a bad value. It's used in
> SSL offload mode. This driver doesn't support SSL offload yet, so this
> causes no problems.
> 
> 1. MT7621 ProgrammingGuide DMA
> Fixes: 9739f5f93b78 ("crypto: eip93 - Add Inside Secure SafeXcel EIP-93 crypto engine support")
> Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
> ---
>  drivers/crypto/inside-secure/eip93/eip93-regs.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
