Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A60913612FE
	for <linux-crypto@vger.kernel.org>; Fri,  6 Feb 2026 10:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770375536; cv=none; b=LudtQlChrQqqFx3rVfsCk8OoiFm78pm7QYxEbmmpnd4FE79T18UKN4912dofe4aR3TMbU2Ia5aqMnRaT/YBoc8yPMssDmYTghGrfzSGBEvHlt/GkumZ+QvAoDJnS2pserDR+Lh+w5wNsTlqcKRkYvnDHpbda84KeYlPlTMgcZyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770375536; c=relaxed/simple;
	bh=SVxrvug3dHxkYz1wSVuAt1ZNkGIaefrBE1cEITAOAUE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rtD0dEi92FZCLHMSLMgzjEfhWb2VdGZ7b/kzxmvnutGOCka7s7686M+WCpk5w5x+JrjO7I5WvMCh2TCTRI+/+JlsGE9V22G1qWinJenijuk3pkpOHJhJ276T3k31bVLUgqWCWxZoax4W4XyiISZnAaYQ25R7Gwpu+vwK4gFTHho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=s6sH4vsW; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="s6sH4vsW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=uf3Mn4yUKMvW/6DBZicxxhoSqJXvniVryUZ0kXqs+XI=; 
	b=s6sH4vsW4qgkyo2SxElIASHPgrDhkK8fivT1GLXnfltpJm3HNla4qi8Sf6y4+0G+OQD4MoFaGtE
	AEoyGaQ180Sxsog9mtf+uPMyU3G5YoweBP4HSyohz76HGwM4w77eCC7Lya2msir7wQvIOHKXQQGPD
	zrOV4clt0ZIs5Ugb2WmyUYdvGfsVFV6ciFGJF1GKz8V3hjBkuPBQkbO8U/305AeF3n9RpdKDxPCI9
	loxGkgcf4CA30e8GVF5/9MvEYkQbNP2Ff/uNXV1KOzaaVQNCtw/j1ZOtwAr7xWGR1lLlZEXSdCfQQ
	0xFuV6Kie1rznFIDIwadiina9yJPt796jYVQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1voJY0-004zVG-1g;
	Fri, 06 Feb 2026 18:58:49 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 06 Feb 2026 18:58:48 +0800
Date: Fri, 6 Feb 2026 18:58:48 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Harsh Jain <h.jain@amd.com>
Cc: michal.simek@amd.com, davem@davemloft.net, linux-crypto@vger.kernel.org,
	kernel test robot <lkp@intel.com>
Subject: Re: [LINUX PATCH] crypto: xilinx: Fix inconsistant indentation
Message-ID: <aYXJaKCXVkQo81u8@gondor.apana.org.au>
References: <20260127070155.199790-1-h.jain@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260127070155.199790-1-h.jain@amd.com>

On Tue, Jan 27, 2026 at 12:31:55PM +0530, Harsh Jain wrote:
> Fix smatch inconsistant code warning.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202601251908.baMDVVgW-lkp@intel.com/
> Signed-off-by: Harsh Jain <h.jain@amd.com>
> ---
>  drivers/crypto/xilinx/zynqmp-aes-gcm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
