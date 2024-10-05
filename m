Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 644C138F83
	for <linux-crypto@vger.kernel.org>; Sat,  5 Oct 2024 05:33:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728106434; cv=none; b=XvnWvrew8j9PbDkCMv2eDzZmO11JWRc5IbD5Uj/ob6DpGy+5zFKqYYasSFuKk75kOj8QXZJL/3lyOzz8549PrUqAvNB6bika5QFNSGsFuL3xOjLz9i3D2jWWIf8NPO14uq3coXq+Q9/305zvakhc+c2qSfEuyApAPWmHPu9AMvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728106434; c=relaxed/simple;
	bh=CbmRoo9YI8mq/BiZhCzaehKEa4HLDNWNCbIfARWbtxQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LBdXdxd4b/1W7HHRS1TCyPXJ3r0kYmBjnTahs8u6OMYJZf+VzuXk0fEuOizr/LnXbQ/g5sgMhZdnYxwm4p4+p2eKhSgqLq1wfWwqRKqzMUf5n0884t5lC+4jfN16rhmm57vvJRelCZA2Fxdeok96EzFtQRYaYG45inFSNC6BVHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=n085CNTT; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="n085CNTT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=HK1PO1CGNzUbXyAQLXFke0cUNwUDuewhUofzHcNzCXU=; b=n085CNTT87KZC5kwtcw4bL+A02
	MqZG36hel6pKA3mNlinb4WzIf8W1MFk6jpp83jmk8cWjbntv4nkPYaEsb/x0h/jcvbfMMM/pQWYTj
	wtUY+71kHrxbYD868SBy/CBr/1g5xaUA1A4j6tQFCrBU9e9OCoJFzj1Or2S0Sx1oGcO+XfyIbGWy0
	CFylN1WotRj9G3aNmgK4+sC890KdtJhTd8Q873bwrvjKJyc3IjZcTGkPDLxkh75oxbg5qmrP2jc9x
	jpv9rSqvzhjnAu+/bhPkgh+YoXyR9LEqrO1APi0qr8PxiEALyFrIdz37XDhXTgwMTbWRsOp5W2rAS
	uSYAiRGg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1swxGJ-0071XP-0g;
	Sat, 05 Oct 2024 13:33:41 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 05 Oct 2024 13:33:40 +0800
Date: Sat, 5 Oct 2024 13:33:40 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Olivia Mackall <olivia@selenic.com>,
	William Zhang <william.zhang@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH] hwrng: iproc-r200: enable on BCMBCA
Message-ID: <ZwDPtH-lqHO7lyhd@gondor.apana.org.au>
References: <20240917-bcmbca-hwrng-iproc-r200-v1-1-58cf8a83ad97@linaro.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240917-bcmbca-hwrng-iproc-r200-v1-1-58cf8a83ad97@linaro.org>

On Tue, Sep 17, 2024 at 02:39:03PM +0200, Linus Walleij wrote:
> The Broadcom Broadband Access (BCA) SoC:s include the
> iproc r200 hwrng so enable it to be selected for these
> platforms.
> 
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>  drivers/char/hw_random/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
