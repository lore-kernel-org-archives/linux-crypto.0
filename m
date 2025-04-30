Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDA642111;
	Wed, 30 Apr 2025 02:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745981268; cv=none; b=A9P+YX3TjDkueJNLw2J5ez/KlDVmROWWEI3Ac3rDUihzdwoUBlo2ys9wMmwvkI33/fpE3+YvhhxKMK3DmTmL2ozFmONTkSZXJ9WoY/WyNINMtFKyOblUnAWHBg2eXQ2ujQyQPYAfoiiR3eohmnvDyHx60xZMqbbx18N/P8ZoAis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745981268; c=relaxed/simple;
	bh=+Ob5i8Dn7eF+x4miDHXxuDe3afBUibimhKURbRd+Lic=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TKcCOO9+8BW3h2syFISz5AYROlq25Mju9GvgSiI9UktvVodkSSEVCOltoSDE8pFviu3lUORG+imUE6jHuh8GjUgRbWjA+C6HC4GTmCSgkQ/RFwjWwhZRNo9Q7OqAOeE673Pq6b0BkwfYPRemH9+5DKi32N6vF00SeofpBzuNJhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=qvKIYmzq; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="qvKIYmzq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=dinu/IcYpDONett6L65YxigVMJYuWf4ibUzIRHPzHAw=; b=qvKIYmzqbInh9gBZMfH+8X0whE
	qUkpzTfCxw9xC2P5jineD6QJ2m8LzDtnc9B3uf8fDjVnhqn58HRkMZtJEvqbTi/9tervXuMTAGw6x
	suBN/jUCd+4VzFUPfGkAc8+WOfeOx6ta4vzEyqKGTthNyPljl9UVYDl9E7gxfhiVAUXUDlQp+fdXr
	LABAdWp0aciRzG6Q0h/Hsul6Sj/kX67DYnouk/HA8+Rceb8MZuKHAJbG/Ih45T5fTdxj4gWUNAgoY
	yBJZ6PfYoKLnKCxTFqdk5exfpAPsLOGfCfxINxEXeyfEJHB+1g4OI78MSh4RG9uJV4Jz9vBYklhuc
	2aG57nbg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u9xU2-00290q-2o;
	Wed, 30 Apr 2025 10:47:40 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 30 Apr 2025 10:47:38 +0800
Date: Wed, 30 Apr 2025 10:47:38 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [GIT PULL] Crypto Fixes for 6.15
Message-ID: <aBGPSpJcLRrwiutd@gondor.apana.org.au>
References: <ZZ3F/Pp1pxkdqfiD@gondor.apana.org.au>
 <ZbstBewmaIfrFocE@gondor.apana.org.au>
 <ZgFIP3x1w294DIxQ@gondor.apana.org.au>
 <ZkrC8u1NmwpldTOH@gondor.apana.org.au>
 <ZvDbn6lSNdWG9P6f@gondor.apana.org.au>
 <Z11ODNgZwlA9vhfx@gondor.apana.org.au>
 <Z-ofAGzvFfuGucld@gondor.apana.org.au>
 <Z_CUFE0pA3l6IwfC@gondor.apana.org.au>
 <Z_89K7tSzQVKRqr6@gondor.apana.org.au>
 <aAn_NWZjdX-wYHxR@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aAn_NWZjdX-wYHxR@gondor.apana.org.au>

Hi Linus:

The following changes since commit 8006aff15516a170640239c5a8e6696c0ba18d8e:

  crypto: atmel-sha204a - Set hwrng quality to lowest possible (2025-04-23 09:32:57 +0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git tags/v6.15-p6

for you to fetch changes up to a32f1923c6d6e9e727d00558a15ec0af6639de19:

  crypto: scompress - increment scomp_scratch_users when already allocated (2025-04-25 10:33:30 +0800)

----------------------------------------------------------------
This push fixes a regression in scompress.
----------------------------------------------------------------

Sabrina Dubroca (1):
      crypto: scompress - increment scomp_scratch_users when already allocated

 crypto/scompress.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
