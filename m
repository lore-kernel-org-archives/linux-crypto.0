Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9E202C15A5;
	Fri, 29 May 2026 06:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780034805; cv=none; b=kyqXTi5tu9hgzwK8PoVJ4gMTZyAHKngbomzVNfP8EfQ264dhAwmJ531/CJltb45ZUgfd0HJ2j2IL+SU0jRyJ2VxbxTYXVV7BVW9uxwG8w3wyU9RpPLTAo9zwE3UwJwq0CHIH74hQOL4elTgahTzPSfodgAyBRwsPFDKsbTME8Rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780034805; c=relaxed/simple;
	bh=UdUMru5QOSPbyz+WGm6fSUxYJLj4j9R57BGsFplh2y0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T0QWegOQr1EwGyCyZg8V55F+522Ne6GysYNLbmBpqDrOSO4TZnThJi+kiBrEQC9ye1XkymxWksVY6G4kGfbNcdCaOQ51sqEfU1JOKzSXJpTZA2TIHt6/ss4ZcUYoA1GyHs7CC4NVLgLlfwR1uREYlwUB0AVmCsLpxP+FAt+lO2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=Xse0m6yq; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="Xse0m6yq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=Q2qQaqVw4GB5ncUk6mIz3Ji2oXgiD3xBx7pikbpXG1w=; 
	b=Xse0m6yqe/yONxApuGoZUVU02oey0rs/n5krI2wbIvc8aWWa4Inf2nn7Hi2dqIoSZobSvCL1cRJ
	r+v3KCGANuqOC1mpCck+xzBquQhmlhbA7PwvYDfaF7g3oh56bmhc4giY9swPmhB8XMz68hSqRePub
	cb+XCOV+vEGNg5qrAKrS7KSwLvCMWirZezbpKpjTK9QKSXVuncjpl3HDZceSdp/6fkrPU5taDtq1U
	4DAeAP2kbQ9jAZ8T1xoNDGeSoCgAGIXlM6B2f161xcp2J72omnPE7NV3uibwTWPXvMm3327AHPrbx
	ovR00nRblkRohLWj33klwqBwoGlztd1oSV7A==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wSqMi-000dEz-08;
	Fri, 29 May 2026 14:06:41 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 29 May 2026 14:06:40 +0800
Date: Fri, 29 May 2026 14:06:40 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ahsan Atta <ahsan.atta@intel.com>
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
	stable@vger.kernel.org,
	Maksim Lukoshkov <maksim.lukoshkov@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: Re: [PATCH] crypto: qat - fix restarting state leak on allocation
 failure
Message-ID: <ahks8KzNx-sXgnhL@gondor.apana.org.au>
References: <20260520123300.210290-1-ahsan.atta@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260520123300.210290-1-ahsan.atta@intel.com>

On Wed, May 20, 2026 at 01:33:00PM +0100, Ahsan Atta wrote:
> In adf_dev_aer_schedule_reset(), ADF_STATUS_RESTARTING is set before
> allocating reset_data. If the allocation fails, the function returns
> -ENOMEM without queuing reset work, so nothing ever clears the bit.
> This leaves the device permanently stuck in the restarting state,
> causing all subsequent reset attempts to be silently skipped.
> 
> Fix this by using test_and_set_bit() to atomically claim the
> RESTARTING state, preventing duplicate reset scheduling races under
> concurrent fatal error reporting. If the subsequent allocation fails,
> clear the bit to restore clean state so future reset attempts can
> proceed.
> 
> Cc: stable@vger.kernel.org
> Fixes: d8cba25d2c68 ("crypto: qat - Intel(R) QAT driver framework")
> Signed-off-by: Ahsan Atta <ahsan.atta@intel.com>
> Co-developed-by: Maksim Lukoshkov <maksim.lukoshkov@intel.com>
> Signed-off-by: Maksim Lukoshkov <maksim.lukoshkov@intel.com>
> Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> ---
>  drivers/crypto/intel/qat/qat_common/adf_aer.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
