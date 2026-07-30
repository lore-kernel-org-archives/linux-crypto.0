Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19A0E3BBA0F;
	Thu, 30 Jul 2026 07:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785396360; cv=none; b=ZaWJmGNN7EDWdTKm/ELsUNg4BPKW6E7GbN/RvDga+ca9saFf1+Kn50bYdeQ/AGL1xPnP/3VNPalzb4+gWzofPytgiDPMqCkBSS3ZiFX2zlmIF5EyJelE0Biqer2AUq7Tz/Yk7SuQM3R/yzMdTuv0vzAHsBO0FL+KO+SAbFkpnHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785396360; c=relaxed/simple;
	bh=bmu3sw/Q+HXDc/oI0x39vIQW7xljMRBKOwkorRw/5H0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CSIXTaMqbvK9GCPgXrQ36TN8iLzKA+DoljLBVHV5ggp7Vsne7tCnl4lLTJ50v+COPXjgkevx/AIr3aJbcRZIljGtnOm1Bi98zhMn8oXAK7ZJqyfsRXfUNWvwQLemhscs1LSPIYsPwTrDUo7JGgJIWIy8U3/XQtSdMHSlYnlHIjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=KYrUkIRC; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="KYrUkIRC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=mWLqk9Kvx+2PugcZm4FbwSBcflKhsmKAhT+xyTVSPr4=; 
	b=KYrUkIRCx4MlRbc8xvh9lLTUYsW5Jo9kWnoHn1nc7UZAvtUWFZFXbDp7gukAQHAvnCq8AkeNl5i
	KbhftJgVEaibWiZpqfccRYQ4u1hzWTArnyfT9Yaorq2W2C203JMYo/ODTQa8qQU7icNwQA2+F86F1
	lRTvORoU9vgNOUqmu9p6cNNosN+u1c6U48UKEcfOimiH/cTEK7zgJmNUpp0RMiD2t63rb7BAlxEea
	YhC79IPllqNxVGQ4LAvvGMbwCK1iIJAx38dJtPanEyBc+/y+/tD3OHl5U8U3TjtP/PoLBiTzEM4aR
	C1V1872InHFPVZ2UN0KmrLRYhMJF5cmWzvcQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wpL9K-00000000Rj9-0p0w;
	Thu, 30 Jul 2026 15:25:51 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 30 Jul 2026 17:25:50 +1000
Date: Thu, 30 Jul 2026 17:25:50 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Richard Weinberger <richard@nod.at>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	davem@davemloft.net, gaurav.jain@nxp.com, pankaj.gupta@nxp.com,
	horia.geanta@nxp.com, ebiggers@kernel.org,
	upstream+linux@sigma-star.at
Subject: Re: [PATCH 1/3] crypto: caam: Fix DMA mapping leak in the cbc(paes)
 job path
Message-ID: <amr8fnn5tkynYpxa@gondor.apana.org.au>
References: <20260726081504.2182951-1-richard@nod.at>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260726081504.2182951-1-richard@nod.at>

On Sun, Jul 26, 2026 at 10:15:02AM +0200, Richard Weinberger wrote:
> For a protected key, init_skcipher_job() maps the second job descriptor
> so that the blob decapsulation descriptor can jump to it, but keeps the
> address in a local variable. Nothing can ever unmap it, and the buffer
> it covers lives in edesc, which skcipher_crypt_done() frees while the
> mapping is still live. The mapping error is not checked either.
> 
> cbc(paes) is reachable through AF_ALG, so an unprivileged process leaks
> one mapping per request, exhausting IOVA space or swiotlb buffers.
> 
> Store the mapping in the extended descriptor, release it in
> skcipher_unmap() and propagate mapping failures to the caller.
> 
> Assisted-by: Claude-Code:claude-fable-5
> Reported-by: Eric Biggers <ebiggers@kernel.org>
> Signed-off-by: Richard Weinberger <richard@nod.at>
> ---
>  drivers/crypto/caam/caamalg.c | 31 +++++++++++++++++++++++++++----
>  1 file changed, 27 insertions(+), 4 deletions(-)

Please check the Sashiko comments:

https://sashiko.dev/#/patchset/20260726081504.2182951-1-richard%40nod.at

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
