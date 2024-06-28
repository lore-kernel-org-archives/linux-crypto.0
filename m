Received: from norbury.hmeau.com (helcar.hmeau.com [216.24.177.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C06FE37B;
	Fri, 28 Jun 2024 00:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.24.177.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719535251; cv=none; b=hw117pTIgY/M5HEGGOUdLPbW87cbtL+/OLaRW60BtnL22Q0S3s8CUO6r7JAeHnmV8RZTeeANul9m8fT6xx4Wd3RwYi5fA9X+4TErj1CVCuYhI2ltcoIZbdi8eDeA7Fb1vgAtMzk7HbNTcok95xio0FljCi8LLOxR9+3Y9CyWZiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719535251; c=relaxed/simple;
	bh=YeFs6HonKDeum86XnWqSuzNRL3761wsSnXRis9kNfT0=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H/+uAF0PBRjYxFC/OHhYN5uoMbU5jmP/ctBvZPxzu4H6yzM8zdOHq5RBolAsX2Zq6Af69mGqsObBbQ33wbcbPNGBdPeO2aa3Fw5XRLnPs7GpedVhQYj1LR3Nlw2iWD4JH6PAPBoXML+aVGsIu9wWs+czStg8jkF0jKPM9e+nuTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=216.24.177.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
	by norbury.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sMzf1-004FT1-18;
	Fri, 28 Jun 2024 10:40:20 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 28 Jun 2024 10:40:19 +1000
Date: Fri, 28 Jun 2024 10:40:19 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [GIT PULL] Crypto Fixes for 6.10
Message-ID: <Zn4Gc+jxtfLZ+cD1@gondor.apana.org.au>
References: <Y/MDmL02XYfSz8XX@gondor.apana.org.au>
 <ZEYLC6QsKnqlEQzW@gondor.apana.org.au>
 <ZJ0RSuWLwzikFr9r@gondor.apana.org.au>
 <ZOxnTFhchkTvKpZV@gondor.apana.org.au>
 <ZUNIBcBJ0VeZRmT9@gondor.apana.org.au>
 <ZZ3F/Pp1pxkdqfiD@gondor.apana.org.au>
 <ZbstBewmaIfrFocE@gondor.apana.org.au>
 <ZgFIP3x1w294DIxQ@gondor.apana.org.au>
 <ZkrC8u1NmwpldTOH@gondor.apana.org.au>
 <ZlascqIex2rE2nO_@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZlascqIex2rE2nO_@gondor.apana.org.au>

Hi Linus:

The following changes since commit 67ec8cdf29971677b2fb4b6d92871eb5d5e95597:

  hwrng: core - Remove add_early_randomness (2024-05-26 18:32:16 +0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git v6.10-p4 

for you to fetch changes up to a5d8922ab2aec39336ebc78d7cefe3b84647b058:

  crypto: qat - fix linking errors when PCI_IOV is disabled (2024-06-21 21:51:51 +1000)

----------------------------------------------------------------
This push fixes a build failure in qat.
----------------------------------------------------------------

Xin Zeng (1):
      crypto: qat - fix linking errors when PCI_IOV is disabled

 drivers/crypto/intel/qat/qat_common/Makefile | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
