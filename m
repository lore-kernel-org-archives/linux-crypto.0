Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A379A55;
	Wed, 29 May 2024 04:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716957269; cv=none; b=mFQIYaao+Wsqb5UcTCZqURtgjGZzjuQz65RkXvfN0y/Y5L45qZysTQ4CHQKJfiVPO92zLkaJd/VZ4rIqdEbiohvY0yEhmztz59kLzHyCz5spsMX+R0kaTJ/DIsQXaoeKjWwiZHYn9yAM2q3RArjmCUO6HTwzfLc2ujMEMSfgUcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716957269; c=relaxed/simple;
	bh=uULQ3FTkF4PJbu/IpU5tIpNPZ6qr38dEXqA/v1696pc=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S24/m24JoiZay6/SikADenPW1ssWD5zN5duCpXXnNXRC3sS36kMKLKx6l+ZyWidevlJBiOoDytjQmRF1jBln6CPFK29PKU05ajyjage6mEOh2xPrw9+ZyWuKCLdyd0bLU3OPdkytjd4lhtyoQkj7njL5Q4LcJCrJk+DekUVS6UI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sCAl6-003FLH-1p;
	Wed, 29 May 2024 12:17:53 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 29 May 2024 12:17:54 +0800
Date: Wed, 29 May 2024 12:17:54 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [GIT PULL] Crypto Fixes for 6.10
Message-ID: <ZlascqIex2rE2nO_@gondor.apana.org.au>
References: <Y5mGGrBJaDL6mnQJ@gondor.apana.org.au>
 <Y/MDmL02XYfSz8XX@gondor.apana.org.au>
 <ZEYLC6QsKnqlEQzW@gondor.apana.org.au>
 <ZJ0RSuWLwzikFr9r@gondor.apana.org.au>
 <ZOxnTFhchkTvKpZV@gondor.apana.org.au>
 <ZUNIBcBJ0VeZRmT9@gondor.apana.org.au>
 <ZZ3F/Pp1pxkdqfiD@gondor.apana.org.au>
 <ZbstBewmaIfrFocE@gondor.apana.org.au>
 <ZgFIP3x1w294DIxQ@gondor.apana.org.au>
 <ZkrC8u1NmwpldTOH@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZkrC8u1NmwpldTOH@gondor.apana.org.au>

Hi Linus:

The following changes since commit c6ab5c915da460c0397960af3c308386c3f3247b:

  crypto: ecc - Prevent ecc_digits_from_bytes from reading too many bytes (2024-05-17 18:55:07 +0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git v6.10-p3 

for you to fetch changes up to 67ec8cdf29971677b2fb4b6d92871eb5d5e95597:

  hwrng: core - Remove add_early_randomness (2024-05-26 18:32:16 +0800)

----------------------------------------------------------------
This push fixes a new run-time warning triggered by tpm.
----------------------------------------------------------------

Herbert Xu (1):
      hwrng: core - Remove add_early_randomness

 drivers/char/hw_random/core.c | 47 ++++---------------------------------------
 1 file changed, 4 insertions(+), 43 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
