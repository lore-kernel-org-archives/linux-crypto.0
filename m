Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A078F2114;
	Mon, 23 Sep 2024 03:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727060916; cv=none; b=AhfAllCZNYfCofMUoGUCvEPBhzQ8v6xMZlUog099ikgedT4luqps8wWM7ZSF1ICMEHa5u5BE7CbzwE/397baovsTowdpBzsnD7/b1VEwqDI77ojcC0j7gHR8YuWD6LbuBkY2net6kcrLD7f+rt9KisqKl6kC9+/nQJQRElxqCNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727060916; c=relaxed/simple;
	bh=DmZ2VYDEZ7Wmj44Kj6ZHEJtmPfeSavajhNt5V2lt9N8=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UuGxHL9TAcACzX8SzYMAEdsF2ufOHxjcwadf/lEctGAjDTx7NR79qGFlmXJuUXgfBhphw+VRFFgkPZhhN62RZU+msItzj6686jAKq2MJNPLhemwI1clS/fw4Hbmr/d6WhxjFdUj3cJR6UId541t7RvP5RTRi4SU7SOk9SCeoO30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=dqxu2MG7; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="dqxu2MG7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=szss05oDsCk/7n/oo+wZQN9aHEW4ocRDwZg8vG2fR6U=; b=dqxu2MG7pIx8hDnxy+LJcTJK/J
	aHgyRv7Q42lucitrDMeMLo56F66Ut0EMgvKLdyKJHdAx3NjFfZYaVC73PGc5tajqCh5qpLnI7rOQy
	6UBJkswpk8eC6dJ3Y0yg4RqAoTBa7zx9rR7lwU3cVekMLoTYp8V06yEC0hsB3stT0YEllPF4lTDGg
	+PRedVOxK7dy3Yj8ty9MRUNytgiPKIrB5ZE2068Bt0uQ3PwR3k/Z2k6X/0SL+8r1+4NcG1caMyINW
	RqDKyH/p+Y7+ILoE68p2iPoBhJaVt1tjjS/8dko0QQQb3vcP7D/drde5jwPbRxFmlpVnTeDINkTpo
	IqXkYKrg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1ssZH0-0040yi-15;
	Mon, 23 Sep 2024 11:08:17 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 23 Sep 2024 11:08:15 +0800
Date: Mon, 23 Sep 2024 11:08:15 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [GIT PULL] Crypto Fixes for 6.12
Message-ID: <ZvDbn6lSNdWG9P6f@gondor.apana.org.au>
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

The following changes since commit ce212d2afca47acd366a2e74c76fe82c31f785ab:

  crypto: n2 - Set err to EINVAL if snprintf fails for hmac (2024-09-13 18:26:53 +0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git v6.12-p2 

for you to fetch changes up to 44ac4625ea002deecd0c227336c95b724206c698:

  crypto: powerpc/p10-aes-gcm - Disable CRYPTO_AES_GCM_P10 (2024-09-21 17:14:59 +0800)

----------------------------------------------------------------
This push fixes the following issues:

- Disable buggy p10 aes-gcm code on powerpc.
- Fix module aliases in paes_s390.
- Fix buffer overread in caam.
----------------------------------------------------------------

Danny Tsen (1):
      crypto: powerpc/p10-aes-gcm - Disable CRYPTO_AES_GCM_P10

Herbert Xu (2):
      crypto: caam - Pad SG length when allocating hash edesc
      crypto: s390/paes - Fix module aliases

 arch/powerpc/crypto/Kconfig    | 1 +
 arch/s390/crypto/paes_s390.c   | 5 ++++-
 drivers/crypto/caam/caamhash.c | 1 +
 3 files changed, 6 insertions(+), 1 deletion(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
