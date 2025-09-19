Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2407621FF28;
	Fri, 19 Sep 2025 04:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758255024; cv=none; b=okPrdaDORwVjTBePk98rlIaovrHKhCcSCPsaDe8r2Vu26657QJScxHUqdsIgVp8h+tTDRqEYCs6JuZCuvkWULKrvhE3pyaljejoaoOno6cwYWZRB72Ik2RbgkCSWnYzknBFnlNz9QFsMCZqTPceGue7EykTmG84MLYPxynVzJVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758255024; c=relaxed/simple;
	bh=kWzIDiGE6mm34WBl9MUTAlmb9j+541K2BGfcZiTNNW4=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=hIIPqOACX7f7HME4vRd1RYtcMSPHGjBetlQsNDKUznW+2NfIPVj0fGp3ujEkuTq+6c+owFX74ie+4htftETpJlwsziosnRqymTRWCNYhWG7VSINBmXDT1M18niXaFfn820w6YBQioc1GrPGfqnUkQXwSWrHIsNeq9oOATWCWgB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=CqqiTLXn; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="CqqiTLXn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Content-Type:MIME-Version:Message-ID:Subject:To:From:Date:
	Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=sskuHSBZ8w8pFCK2JnMFoGM719oiNoHTzFHvnVcys00=; b=CqqiTLXnp/5klwvtlo/frgszar
	kLZV3Xrmws8o0dXlHm9dDTrRx9eHRLyYn3PLwW0TmF8Bl5fz/cKoIddm5CyiIEyz8cmJ6nRRZ3DBh
	2MEXeYmbKSzGqbYS5F4J50NKgp1CXwqzEJELjp3o73+GeVGhM5AZ8xlDmzexJrI9VeFxWSwlJkkVT
	o2DywFyJSK9D43bmfEehEG78gh8eQihgjDBKoMxocoNcgkCL4U28KLVkXIHlgTMoL5PlPjN7ujP2k
	4f0G5N1nrtUkJi9IvDZ99zICPhbKyJHzHa+N3jWwYot8hiqihOqIRD+e8RDtdM4AhS4B6a+3v9dwO
	pHnUM5YQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uzSCF-006ede-0f;
	Fri, 19 Sep 2025 12:10:04 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 19 Sep 2025 12:10:03 +0800
Date: Fri, 19 Sep 2025 12:10:03 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [GIT PULL] Crypto Fixes for 6.17
Message-ID: <aMzXm4zy8LARVMbk@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus:

The following changes since commit 8f5ae30d69d7543eee0d70083daf4de8fe15d585:

  Linux 6.17-rc1 (2025-08-10 19:41:16 +0300)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git tags/v6.17-p3

for you to fetch changes up to 1b34cbbf4f011a121ef7b2d7d6e6920a036d5285:

  crypto: af_alg - Disallow concurrent writes in af_alg_sendmsg (2025-09-18 17:24:59 +0800)

----------------------------------------------------------------
This push fixes a NULL pointer dereference in ccp and a couple of
bugs in the af_alg interface.
----------------------------------------------------------------

Borislav Petkov (AMD) (1):
      crypto: ccp - Always pass in an error pointer to __sev_platform_shutdown_locked()

Herbert Xu (2):
      crypto: af_alg - Set merge to zero early in af_alg_sendmsg
      crypto: af_alg - Disallow concurrent writes in af_alg_sendmsg

 crypto/af_alg.c              | 10 +++++++++-
 drivers/crypto/ccp/sev-dev.c |  2 +-
 include/crypto/if_alg.h      | 10 ++++++----
 3 files changed, 16 insertions(+), 6 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
