Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10E6E267AF2;
	Mon, 28 Apr 2025 11:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745840390; cv=none; b=d4mnd0Rx8q3V6ptA+KOCZpGJZTIRwfjMHY+h2978Z/owtPhGM6yILYWzasyjmeJ4htPCUa8nu6DIJnfQXdrVcOpNAsPQEd2xoqpl9G67WniqZRW1LxtalsBdzUuv0XMxTVJlcRl5KbV2AK5mN6qY2FXv0nHkvSCiZyKVmEFzf90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745840390; c=relaxed/simple;
	bh=wXnw6NaXGexdF7bjS7VYaVlXZidbEfsdHdhzCPLP8zk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Eueg/e7JpudriIghmFeEBzH8ZQWwdaiiF+nIR2kp+xHAI/gp+cjFwHkd0VQ7uzjydHbRNJdErmbFwDo2ahM8waSrL+Up1ijFq3hoZTJW6l8tl36AVI8m3HNxqr5M7qeNPmGc25uQaWHa7XZcR4r1KenCWiL8LCxnZqt+QK48WM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=CEUOlbvK; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="CEUOlbvK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=mnUpu6aIGkBvFTLRk8XsqS6jkn7cP+pYPk1SMU1zWj0=; b=CEUOlbvK/GAsNuym/k6N+Y0xv6
	+at5oP3gUeO0RGzXczUnbrtxYLEudQYFL7yudwFGrpNpHHx/csGAw0zrp4U9mQyeOjjrQbSC4UO15
	PSB3hVYzDIx2/F3M8kNwI7KpDGRggW//O9sOC6HsrnfDksd/bCtMHBP/0u0g986TiBIV411y/xAxC
	wmJ2XhPGw609eY5XDVujevyh0GMfteMHsUXhODm6ym9WiiSOv/a0BpnCvMiUuwxdPMpeX4wWkuuHV
	1wiMOZVAYovWVYVJI5yoN6Vm/X4liHHkOiz4+m4CcCWgPaZ6B3xOKNKlVxD7pnZ8Jf7v59sQ9cSIl
	92kAOvOQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u9Mpj-001bAH-1g;
	Mon, 28 Apr 2025 19:39:36 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 28 Apr 2025 19:39:35 +0800
Date: Mon, 28 Apr 2025 19:39:35 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
Cc: clabbe.montjoie@gmail.com, davem@davemloft.net,
	linux-crypto@vger.kernel.org, wens@csie.org,
	jernej.skrabec@gmail.com, samuel@sholland.org,
	linux-arm-kernel@lists.infradead.org, linux-sunxi@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] crypto: sun8i-ce-cipher - use
 crypto_skcipher_driver_name()
Message-ID: <aA9o9w1odAIgmK0e@gondor.apana.org.au>
References: <20250425124517.2225963-1-ovidiu.panait.oss@gmail.com>
 <20250425124517.2225963-2-ovidiu.panait.oss@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250425124517.2225963-2-ovidiu.panait.oss@gmail.com>

On Fri, Apr 25, 2025 at 03:45:15PM +0300, Ovidiu Panait wrote:
> Use crypto_skcipher_driver_name() helper from <crypto/skcipher.h>, instead
> of accessing struct crypto_alg directly.
> 
> Signed-off-by: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
> ---
>  drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
> index 05f67661553c..f03a8fa7bfa2 100644
> --- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
> +++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
> @@ -17,6 +17,7 @@
>  #include <linux/io.h>
>  #include <linux/pm_runtime.h>
>  #include <crypto/scatterwalk.h>
> +#include <crypto/skcipher.h>
>  #include <crypto/internal/des.h>
>  #include <crypto/internal/skcipher.h>

If you include internal/skcipher.h, there is no need to include
skcipher.h.

There is no need to resend this as I'll just remove this hunk when
applying the patch.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
