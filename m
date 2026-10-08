Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F29DD3B637E;
	Thu,  8 Oct 2026 07:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791445135; cv=none; b=qykmW3H4KgZt0cZOdsoT0gcFy04smlUAUInTILG9f/RJXMiu/fzsT1fy+At9A46oGN6Fd4BF4hiQ2gQuxOb2Ag4dsNN2ZZPsO2wb+o/ZcKxEGmt9nvRu7um8xcYL8ps+Q3wtaWM6jRfykCfKrsJ+B9bGt7oboZlz7KErvNiUWBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791445135; c=relaxed/simple;
	bh=quaw3TN7wQxTpA1zt6t5doKqXY5cTJy1ynwI4LidPXI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=duXYR6z6ithpI3q7+U7SkBxYy54YE5ljcbjPMqCsqaApkVIeHGGm/J1vutYOmOmGQB1VarSc5TPAkG4ag4EEaQDwFoNaTtx+uEqqRd0dsyXBx5JaK9GoT61xyQB6Hw827AdseYkAi/70tfRPnZA1H8xz4uyMT6bSmhy+u/D+uGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=Epbaj1Ep; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="Epbaj1Ep"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=99qcoWn/C6vTAxcHMgBHAoVGDaiU3YWNHI3EDWo+C+s=; 
	b=Epbaj1Ep7KGgZGjAB5R3uR9egKkfmXFUVQp/6AxQkVfZL2hzrq82iS8QIi0tmIFTFEsga89qTgL
	b+gKgj0ae55NCINujYepd+ZEI1X7gr3WUnh3ZJ6ZfQay6ioZJBuYLQR1/GrL2bjDy9vrnJnAufU2z
	V7xX0lJ176CZIpMJymdvZLIP4btxrZEaQ7qVGsmQT76GpS4R2mtH7GzRd+ztDHO/eNLMRvfW0Jc7W
	i3w+mJc9rH1RHXuCxphakT0xJzePgl8YL4vhciaw77ho6+HjY7T4U7day9n+hPmdvCCVuLeJXEz1o
	/GZmrhGqK5zriq2fWNrJlBWr1BRIu6Kbny2w==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xEii7-00000001n42-0Z0Y;
	Thu, 08 Oct 2026 15:38:40 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 08 Oct 2026 18:38:39 +1100
Date: Thu, 8 Oct 2026 18:38:39 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Changwei Zou <changwei.zou@canonical.com>
Cc: sahil.malhotra@nxp.com, davem@davemloft.net, horia.geanta@nxp.com,
	pankaj.gupta@nxp.com, gaurav.jain@nxp.com, iuliana.prodan@nxp.com,
	martin.kepplinger-novakovic@ginzinger.com, lukas@wunner.de,
	sahil.malhotra@oss.nxp.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/2] crypto: caam - Fix RSA destination buffer handling
Message-ID: <asdIf-bbjjSHRNh7@gondor.apana.org.au>
References: <20261004210200.290119-1-changwei.zou@canonical.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261004210200.290119-1-changwei.zou@canonical.com>

On Mon, Oct 05, 2026 at 08:01:58AM +1100, Changwei Zou wrote:
> This series fixes two issues in the rsa-caam driver.
> 
> Patch 1 fixes wrong unmap operations where rsa_pub_unmap() was called
> regardless of the key type.
> 
> Patch 2 adds a bounce buffer to handle unaligned RSA destination
> buffers on DMA-incoherent hardware such as i.MX8, fixing intermittent
> -EKEYREJECTED errors when loading signed kernel modules.
> 
> Changes since v1:
> - Patch 1: Add Fixes: tag; pick up Reviewed-by from Sahil Malhotra.
> - Patch 2: Move the !bounce_buf check out of do_rsa_bounce_buf() into
>   the caller rsa_bounce_buf_done() so the helper is only entered when a
>   bounce buffer actually exists; add Reported-by/Closes and Tested-by
>   from Martin Kepplinger-Novakovic.
> 
> Link to v1:
> https://lore.kernel.org/linux-crypto/20260821045555.806471-1-changwei.zou@canonical.com/
> 
> Changwei Zou (2):
>   crypto: caam - Fix wrong unmap operations
>   crypto: caam - Use bounce buffer for unaligned RSA destination buffers
> 
>  drivers/crypto/caam/caampkc.c | 123 ++++++++++++++++++++++++++++++----
>  drivers/crypto/caam/caampkc.h |   6 ++
>  2 files changed, 116 insertions(+), 13 deletions(-)
> 
> -- 
> 2.43.0

Plesae check

https://sashiko.dev/#/patchset/20261004210200.290119-1-changwei.zou%40canonical.com

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
