Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FE622571B0;
	Sat, 30 Aug 2025 08:52:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756543975; cv=none; b=YLR6BcBe4Knv6buf8mSNf8fAMTuFo17uY4P3g9ezccHZkEr4wbLVKRUhAeN++eeE1z6xYkaBCtOpZ7b/nrHtzbHJxJkMAxXRW61JKdWorc4jMwcOS5gsIBL2EqQbB6riQv272AUd4xya4GMqyQSlPfBKvhDCLeSDfPeWz3Nc0OE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756543975; c=relaxed/simple;
	bh=jcJQ3rA63umAgZbu3rvv53kKljjXR6etnXzqDxvpDQw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dimBpbghpaY9x3sXpJStWGwDhZn/bb+MTEeRTaiU7niIsYHQyrUgkHpUhV7gpqKKoA8SAwlMokljVEd2XV+bBNG0FtbNSOhm8v2SX40Fb2oNUYr8kUqKM8ljn/OK2CD5Z0j/aJav8U4Nh/mhYLNPeQ8q22TyoE72EDp4HTzOREI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=m2srH5zx; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="m2srH5zx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=MyltwLt1vho4BqBHbOkVpoeXKq95+fL91F+SvEBawGM=; b=m2srH5zxWIdp67bZ5dMbsw9Mrm
	qK6uAiDiQnP8UBQxSGFKKudOM7fptJMTJjkbP+u3Tny0msRuYJ8HCJ2h7ANowZiqhjPTyUEoHgBTI
	JCaE+6WcfvbJWN0bBn0G5Ev2B23oK6MnAwEkXrGPzq9skuj4eYZBWPZEYt3zQkkuEq2R7UQcIPhAK
	zZRTcsejK/PtbCOh6C4fFm4soFuj9x5HUiGMAkSnOHp/fas4fNDRobq1hA/BiuFmypAUEw7t9YAvH
	cJ/PrjaXEgPULzvEG7vrvPnEMewzsU7p4fAvOCrw2PKCvvnOjRxAiF9OZD8iU5rD5YSNIfx82rAyF
	hCzv7g9Q==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1usH4o-0017DC-2Y;
	Sat, 30 Aug 2025 16:52:44 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 30 Aug 2025 16:52:43 +0800
Date: Sat, 30 Aug 2025 16:52:43 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Liao Yuanhong <liaoyuanhong@vivo.com>
Cc: Olivia Mackall <olivia@selenic.com>,
	"open list:HARDWARE RANDOM NUMBER GENERATOR CORE" <linux-crypto@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] hwrng: cn10k - Remove the use of dev_err_probe()
Message-ID: <aLK7238JlcDNBOuq@gondor.apana.org.au>
References: <20250820123926.473600-1-liaoyuanhong@vivo.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250820123926.473600-1-liaoyuanhong@vivo.com>

On Wed, Aug 20, 2025 at 08:39:23PM +0800, Liao Yuanhong wrote:
> Logging messages that show some type of "out of memory" error are generally
> unnecessary as there is a generic message and a stack dump done by the
> memory subsystem. These messages generally increase kernel size without
> much added value[1].
> 
> The dev_err_probe() doesn't do anything when error is '-ENOMEM'. Therefore,
> remove the useless call to dev_err_probe(), and just return the value
> instead.
> 
> [1]: https://lore.kernel.org/lkml/1402419340.30479.18.camel@joe-AO725/
> 
> Signed-off-by: Liao Yuanhong <liaoyuanhong@vivo.com>
> ---
>  drivers/char/hw_random/cn10k-rng.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
