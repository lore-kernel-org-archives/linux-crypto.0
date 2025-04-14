Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 683E07E9;
	Mon, 14 Apr 2025 05:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744607836; cv=none; b=ETkmVGKhbdIQPSbcRw/HqEt9xrrs+6W26uU7Dyr98uGACncPAUW7dMIwWBzhyFavWGzP0klOW2eX56gRcCqM7X9RsfPm3OW0tf8QZ75EwqSuP6ZxHnz/2rflQK3zrRwvAaHF7hoFadPhVKE3lV6NL3DmS/l/Z0RvNNudoX0OZcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744607836; c=relaxed/simple;
	bh=SDy3egfL5IDgvPeL0mrXHP4S0r+q/UvjOcD3uIkTv30=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N3jSNY1yyFJs+VTfCopgzIr+wQQvYpZd7wmUDRZDCG2m9sThzvWtF/XG1LKIKazm6krNE08aE+yWb5hzCxDJfDfLM+OPDJ2kzsLLOQEnFAjY+N62dNnMNZB7jO4k6tYD15X89s25DpsqKMlWX9hzfax8O1kjafB5AuVbFJJ7nqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=BPMQdUls; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="BPMQdUls"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=cRKULB2qPIZFDaNugiFcdTYMoir+vA8thM83kE8yoC8=; b=BPMQdUlsIKZ4pRp71LKbxPb8Dc
	Zb4RI4bJDQX7WjnQUihot8bSBbneaX3VdKdh84pkCsFaGLCdRgYp0GYlWCFk1x37thlLZmXssKP5m
	sRavvE1r2y6Ue4jWWAwJTkXYQHOxEsFnUDuV3AkXIVuDM4QjK9lgi7odWaXzI8tid6Pso4UaelqcU
	+4iq6hwolE7g1AQr0yRGYJBxDVx07IJkYMnNEp1idislPcfTtfzHioZ4fGgARNJEIe24h9a1Nx7Br
	gqyeWhmj+agyzS1mPR8s6c0AiWSULvLqZXGxXplkw/r2E0jr++EF2azA7V7M0vJXrI5FTVHsceMnQ
	Rbj01uIw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u4CBa-00FOkk-1b;
	Mon, 14 Apr 2025 13:16:47 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 14 Apr 2025 13:16:46 +0800
Date: Mon, 14 Apr 2025 13:16:46 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Sean Anderson <sean.anderson@linux.dev>,
	Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	Gaurav Jain <gaurav.jain@nxp.com>, linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org,
	Valentin Ciocoi Radulescu <valentin.ciocoi@nxp.com>
Subject: Re: [PATCH] crypto: api - Add support for duplicating algorithms
 before registration
Message-ID: <Z_yaPhwelNpuKrb_@gondor.apana.org.au>
References: <17f9af67-de10-4b96-99ef-3c5cd78124c0@linux.dev>
 <Z_SxYFdyBJTYe_7G@gondor.apana.org.au>
 <e3dd2f83-8451-47b0-a774-a697b861ceb3@linux.dev>
 <Z_XiPLmSVs8PGTZD@gondor.apana.org.au>
 <Z_XpfyPaoZ6Y8u6z@gondor.apana.org.au>
 <cf7e20a2-dc30-4940-9abe-bbf5ea1ac413@linux.dev>
 <Z_hyG816TRNGoSaP@gondor.apana.org.au>
 <Z_n3O_IZhbgQE02q@gondor.apana.org.au>
 <20250413160304.GA16145@quark.localdomain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250413160304.GA16145@quark.localdomain>

On Sun, Apr 13, 2025 at 09:03:04AM -0700, Eric Biggers wrote:
>
> Why does this make any sense?  The lifetime of the algorithm struct memory
> should be the same as that of the owning module, and drivers should ensure that.
> In which case hacks like this are not needed.

Hardware can be unplugged at any time.  Once all hardware backing
a driver has been removed, you need to unregister that algorithm.

Please read my explanation for the prior patch:

https://patchwork.kernel.org/project/linux-crypto/patch/Z_XpfyPaoZ6Y8u6z@gondor.apana.org.au/

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
