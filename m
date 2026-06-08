Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3E583815F8;
	Mon,  8 Jun 2026 05:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780897422; cv=none; b=p21Zko6Jb78zoCJDg6oNwsiC+CJl5m3cSJdDT/h0F73K+LLtcRGyhCos8l51rtLvZPcPFhYnVtJaWUUUYanAT39GhsiDgjzmzt0QTIx+FBQ+pSnBz2d/pPLvrYJFp5/RIYgGnUycnx93IDMuYDHjzaWDBlSEsa/2Ar8UhiJ0fKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780897422; c=relaxed/simple;
	bh=GcsvY5VuYeV5qGsvYTXPYDb6jcwkJ12FYxJ7q/aN4u8=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=hbQiQEK6GmviGft6x7BGr5Qy/XfdPdvLZIUqqS4FP4IzfMJv+DMptj9n7L/YhG+4OXUHM4SakZvyRLfz5xKIOrm5FCqXfRxUDZzendvo0/PN2RD9ABwLrfmQ/hq0Ic55TDXkKhJGOxCLtZz0YVh4TxnlweCzpvF0TrpMsBauJ3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=QQXpO+2l; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="QQXpO+2l"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=Content-Type:MIME-Version:Message-ID:Subject:
	To:From:Date:cc:to:subject:message-id:date:from:content-type:in-reply-to:
	references:reply-to; bh=vV94r8uwFGNlVI9+ZhnizPKLwJzZ2D4pr3BODRiB6TU=; b=QQXpO
	+2lswXXBowmq2zWzT+ODE9qiEYKXrqOb2mCF1bqIs+kqrLOIyyASBTeXdqCjvkjp6tc5MJ93zJebQ
	SN8HqhtTgZvtDQ0zPFsgzk1wgn612edJDlmTMGHLNu88Gjg2F0xZsEcHQS0oJCzSxP8t46EFs7PIV
	8ZJ7lEZW4+5X8k24jWJrao8+j3Myizf6CIni+lRrV3mVHCdU6vgK+ijy/hAjKlIOFO/hS2SRBjDf4
	aYY2WbhPbMpZ2XgksLaKw4oMcKQeXpJ/rb3+djws2XJEAyZaqrM8sIX4GAIFl3HVz4nQl4Y0Ekzzo
	u3cog/WHoT1kMmdn9GtfENTkk1n/Q==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wWSlg-003ObC-15;
	Mon, 08 Jun 2026 13:43:25 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 08 Jun 2026 13:43:24 +0800
Date: Mon, 8 Jun 2026 13:43:24 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [GIT PULL] Crypto Fixes for 7.1
Message-ID: <aiZWfDt54UazaMJ0@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit d1fa83ecac31093a550534a79a33bc7f4ba8fc10:

  rhashtable: Add bucket_table_free_atomic() helper (2026-05-05 16:12:07 +0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6 tags/v7.1-p5

for you to fetch changes up to ecf3edd349dfabee9bc8a46c5ff91c9ebd858d48:

  crypto: s390 - add select CRYPTO_AEAD for aes (2026-05-29 14:04:03 +0800)

----------------------------------------------------------------
This push contains the following changes:

- Fix random config build failure on s390.

----------------------------------------------------------------
Arnd Bergmann (1):
      crypto: s390 - add select CRYPTO_AEAD for aes

 arch/s390/crypto/Kconfig | 1 +
 1 file changed, 1 insertion(+)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
