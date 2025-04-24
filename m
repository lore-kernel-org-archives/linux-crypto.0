Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1696C1DED49;
	Thu, 24 Apr 2025 09:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745485635; cv=none; b=SZjUZd1JdANDwsPzOKoMWbd7iqKfCg9/fgGJtHwemOepFWN+E6kps3Si05dRxJBqMisMQGK9qacR5Z3gpYItONnKuwvWP0/YWXC8w75eja5edN4zega/NMoeqe4FP+OWITMkjAGxrdOhi26iUdZngHNs5DeuaExDvhKipeVGZpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745485635; c=relaxed/simple;
	bh=jy5nIM0xDOaEX66JTTYxCCobpJsKJNujNJcgUZv6rNA=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mp3ahpF/vuCKIoBcAIRcmU37EJ8Jkp/IQIRplAbFBWUzJQQEcDkIVonQIJO9Ob29S7KDlzqDV4b/x7z4KBebDiV0fXdCdTWQ7q9+UeeKNBsQDHsZrzMTkolw1MunVx19Iwi+ObbKMOBEXGQygU0soktWqfAxGf9eTy1m/tZifQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=fSWX5IUp; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="fSWX5IUp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
	:References:Message-ID:Subject:To:From:Date:Sender:Reply-To:Cc:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=nF7FqQ9YbgPgZLoKxSaHIjMaq3vAjDNUtoKXyw0MY2k=; b=fSWX5IUpWvN6LgO3R5dGBmFcXJ
	DK3oKRmFAKXqHq5AgRfWCjgNBGnXGfug+Pd4wEG0aBeV316a+EAhWfJ1GdEt2YicCidqpnQHL5mp8
	dhJwH1WXrzAuvlFM6087Kdi8DHlCGA8bi63+YEXGFd+w0tudeK4zHSM4a6kXZJ5qK++3zurnn4iyO
	902G+gxxoREXi5/HT2BffwGGlrdd7JXO+kR4z+tcpIpxI5jl+H0isHHoHqIJx/Hw50icytOy+pvEm
	6v6QPgxJnenPhlSNeIUVkNe/Q8NDn9I8N0O1Nneunf17c5T21/foyQMAOrlq7A4TDacmSORbcO7Zi
	ADTRMc6g==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u7sXt-000djE-0p;
	Thu, 24 Apr 2025 17:07:02 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 24 Apr 2025 17:07:01 +0800
Date: Thu, 24 Apr 2025 17:07:01 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [GIT PULL] Crypto Fixes for 6.15
Message-ID: <aAn_NWZjdX-wYHxR@gondor.apana.org.au>
References: <ZUNIBcBJ0VeZRmT9@gondor.apana.org.au>
 <ZZ3F/Pp1pxkdqfiD@gondor.apana.org.au>
 <ZbstBewmaIfrFocE@gondor.apana.org.au>
 <ZgFIP3x1w294DIxQ@gondor.apana.org.au>
 <ZkrC8u1NmwpldTOH@gondor.apana.org.au>
 <ZvDbn6lSNdWG9P6f@gondor.apana.org.au>
 <Z11ODNgZwlA9vhfx@gondor.apana.org.au>
 <Z-ofAGzvFfuGucld@gondor.apana.org.au>
 <Z_CUFE0pA3l6IwfC@gondor.apana.org.au>
 <Z_89K7tSzQVKRqr6@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Z_89K7tSzQVKRqr6@gondor.apana.org.au>

Hi Linus:

The following changes since commit b2e689baf220408aff8ee5dfb4edb0817e1632bb:

  crypto: ahash - Disable request chaining (2025-04-12 09:33:09 +0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git tags/v6.15-p5

for you to fetch changes up to 8006aff15516a170640239c5a8e6696c0ba18d8e:

  crypto: atmel-sha204a - Set hwrng quality to lowest possible (2025-04-23 09:32:57 +0800)

----------------------------------------------------------------
This push fixes the following issues:

- Revert acomp multibuffer tests which were buggy.
- Fix off-by-one regression in new scomp code.
- Lower quality setting on atmel-sha204a as it may not be random.
----------------------------------------------------------------

Herbert Xu (2):
      Revert "crypto: testmgr - Add multibuffer acomp testing"
      crypto: scomp - Fix off-by-one bug when calculating last page

Marek Behún (1):
      crypto: atmel-sha204a - Set hwrng quality to lowest possible

 crypto/scompress.c             |  10 +--
 crypto/testmgr.c               | 145 ++++++++++++++++++-----------------------
 drivers/crypto/atmel-sha204a.c |   6 ++
 3 files changed, 74 insertions(+), 87 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
