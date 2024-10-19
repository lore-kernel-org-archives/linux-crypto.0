Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23B2F17DE36;
	Sat, 19 Oct 2024 11:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729339060; cv=none; b=D2dSjY0JzxCQQetkbwnPqjC0SMqsVc5qjD74qcWo4JHJ9En68d6MISgbCtfbBmPlGG0tyqtGSzZacaXuDwpHx0FdDghireg/SLVsxEVmY0xyDv6yJTsbMbEdIKZbHzvCgnH1k/BVvDGNkEZQDKdmMAWtAdOGUvuTIbz7nnpJKlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729339060; c=relaxed/simple;
	bh=8/wmceTo6G2lpk6TYCNpIrivHXKb0CY3wokeFJRg+9o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WSh8hTm8z7zOVU2vQPl2hw6M6Ie9+qottECYNaa9NJkwai44ulnuzlLLRepRD9El9q31JduSxantaZbQdi5CMgr9Mnuj+TwJlepHt0pPiVhdxaiGobBwnstoNb7jsQ3pCLr4u2MCTpEfJLcliyzp2fk1D/qJjaDeMXSV7WTwT2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=YQM8s/IB; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="YQM8s/IB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=BRvT0dMiFdoI7FUuP4LFCDbjeUzNW9+o1+iJAw9zO/Y=; b=YQM8s/IBvgYi2t+uBMrt4f7oBd
	VmAsA4HBaVXmxlCEN/+DTy4Co6dza7RnvwhSPLvNInP1y1eX0M4pwlNF37dU1d3gpYaeRNgImaln9
	ErRks/WwSVL+fkvmhiBpV+X+8lQOojhNzV/EkrXzZnk1Rgyy5xuF3iZ9DbVIpAHdieYg7rmBJjOYm
	DOMIbrBeh0/RxGAN58iN0k2LK/nw2HX4lm79N791jZdK/vKBBQ+jC04rsX0gsQU0MAeTCQUmMqwtz
	kO+B/3XigmLAPCOTAYK/AMwkLUvLM7QR5iljRgMlnw7SEQRAQrxXVvnQd9ZYRaeMtL37yWxNerzit
	q6daP9pw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1t285F-00AaOg-2d;
	Sat, 19 Oct 2024 19:57:26 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 19 Oct 2024 19:57:25 +0800
Date: Sat, 19 Oct 2024 19:57:25 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Zhu Jun <zhujun2@cmss.chinamobile.com>
Cc: olivia@selenic.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] hwrng: histb-rng: Fix the wrong format specifier
Message-ID: <ZxOepXJHs4m40unK@gondor.apana.org.au>
References: <20241009064244.6420-1-zhujun2@cmss.chinamobile.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241009064244.6420-1-zhujun2@cmss.chinamobile.com>

On Tue, Oct 08, 2024 at 11:42:44PM -0700, Zhu Jun wrote:
> The format specifier of "unsigned int" in sprintf() should be "%u", not
> "%d".
> 
> Signed-off-by: Zhu Jun <zhujun2@cmss.chinamobile.com>
> ---
> Changes:
> v1:fix the subject line, it has to be in the subsystem style
> 
>  drivers/char/hw_random/histb-rng.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
