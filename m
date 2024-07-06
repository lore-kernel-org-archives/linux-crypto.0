Received: from norbury.hmeau.com (helcar.hmeau.com [216.24.177.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32B6F17FE;
	Sat,  6 Jul 2024 00:11:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.24.177.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720224668; cv=none; b=u0zBsCLrAsEel+hwgfjmnz8P0OIyrM8uTgewOUQNO+zjehw4Jt9V1MPb+ysPPiLOfKEXedWa9RJn/F6yVkmHa1yZGTZhxGKmruh1gwi3a8svEf7w/C6w5aZLjVbSqHiCjT1124sGlGiIxXG0hJ/5nwEnzD28IJIxgGYR6XLyeuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720224668; c=relaxed/simple;
	bh=LguLmIQSB/dZ75aSBBP49WT4ZtDGzUukxhPYqFXnGx8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FvQJhvwgtK0J2sKMz0no+AbHvoUFsCQbuxwlGZu7lKz+yBc751+SJ61jKYSfgnC1KFVbHMjTYLRRe0D212F4ssCZJuFoAWC7nNnhh6UMHH4uGGcoc9PSy/nakI38Z8S4jxqQ1udzVauBX3E7xwCIQjiIVnb7bVSlTb4QPu3XjXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=216.24.177.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
	by norbury.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sPt0Z-006gdt-04;
	Sat, 06 Jul 2024 10:10:45 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Sat, 06 Jul 2024 10:10:31 +1000
Date: Sat, 6 Jul 2024 10:10:31 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Francesco Dolcini <francesco@dolcini.it>,
	Bharat Bhushan <bbhushan2@marvell.com>
Cc: Olivia Mackall <olivia@selenic.com>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] hwrng: Kconfig - Do not enable by default CN10K driver
Message-ID: <ZoiLd/Cezq2CS4Zp@gondor.apana.org.au>
References: <20240625195746.48905-1-francesco@dolcini.it>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240625195746.48905-1-francesco@dolcini.it>

On Tue, Jun 25, 2024 at 09:57:46PM +0200, Francesco Dolcini wrote:
> From: Francesco Dolcini <francesco.dolcini@toradex.com>
> 
> Do not enable by default the CN10K HW random generator driver.
> 
> CN10K Random Number Generator is available only on some specific
> Marvell SoCs, however the driver is in practice enabled by default on
> all arm64 configs.
> 
> Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
> ---
> as an alternative I could propose
> 
> default HW_RANDOM if ARCH_THUNDER=y

Adding marvell Cc.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
