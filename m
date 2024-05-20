Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3324AD299;
	Mon, 20 May 2024 03:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716175615; cv=none; b=BdSA5aDPMvd6BiiFSF8n1noR3VJWntM2c5dWAgmG2aLVkC2CpZblUALZyW2+DJO4Dqt8b9isPlliTAxorJl2wzpd9TqrNejzJR45+4BnkagGwBz0ZTO5d754lunh/yzB+Z2Pwv4m2wK2y+TPpZ7+9VYVBoYmiS6or6HR7Zr+DRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716175615; c=relaxed/simple;
	bh=V5wn606jK4rLb8q9tpFx0F72ZJTGSftm4ClrGhQwzJU=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tmXQgXysgooITxfqysC2sVPaNmvCAX9GW0aJYD3zJ+ug4L/CUp9/bET3iWxal1MKmxDZ1WixWUGN/5z0U822dDwAXrjst2XJtkAcODR3WLSRi1xcf/lyrc9TtsGD/Z8XmeCDMUzenapljlST3LTmSecrT52oSDT0BEn6ENj7psQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1s8tfd-00HW6r-1n;
	Mon, 20 May 2024 11:26:42 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 20 May 2024 11:26:42 +0800
Date: Mon, 20 May 2024 11:26:42 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [GIT PULL] Crypto Fixes for 6.10
Message-ID: <ZkrC8u1NmwpldTOH@gondor.apana.org.au>
References: <Yzv0wXi4Uu2WND37@gondor.apana.org.au>
 <Y5mGGrBJaDL6mnQJ@gondor.apana.org.au>
 <Y/MDmL02XYfSz8XX@gondor.apana.org.au>
 <ZEYLC6QsKnqlEQzW@gondor.apana.org.au>
 <ZJ0RSuWLwzikFr9r@gondor.apana.org.au>
 <ZOxnTFhchkTvKpZV@gondor.apana.org.au>
 <ZUNIBcBJ0VeZRmT9@gondor.apana.org.au>
 <ZZ3F/Pp1pxkdqfiD@gondor.apana.org.au>
 <ZbstBewmaIfrFocE@gondor.apana.org.au>
 <ZgFIP3x1w294DIxQ@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZgFIP3x1w294DIxQ@gondor.apana.org.au>

Hi Linus:

The following changes since commit 13909a0c88972c5ef5d13f44d1a8bf065a31bdf4:

  crypto: atmel-sha204a - provide the otp content (2024-05-10 17:15:25 +0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git v6.10-p2 

for you to fetch changes up to c6ab5c915da460c0397960af3c308386c3f3247b:

  crypto: ecc - Prevent ecc_digits_from_bytes from reading too many bytes (2024-05-17 18:55:07 +0800)

----------------------------------------------------------------
This push fixes a bug in the new ecc P521 code as well as a buggy
fix in qat.
----------------------------------------------------------------

Herbert Xu (1):
      crypto: qat - Fix ADF_DEV_RESET_SYNC memory leak

Stefan Berger (1):
      crypto: ecc - Prevent ecc_digits_from_bytes from reading too many bytes

 crypto/ecc.c                                  | 22 ++++++++++++++++++++++
 drivers/crypto/intel/qat/qat_common/adf_aer.c | 19 +++++--------------
 include/crypto/internal/ecc.h                 | 15 ++-------------
 3 files changed, 29 insertions(+), 27 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
