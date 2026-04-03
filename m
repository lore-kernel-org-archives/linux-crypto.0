Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7736F1FC7C5;
	Fri,  3 Apr 2026 00:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775175864; cv=none; b=I93SCdAgQcTtf7tvpeh9MgKa8qrl1Tj7Pvh0JFIIENDaQ8MgC872iLZRujag9j6zSsmkR70doBYPAXC1MdZcrUzfealXJHJjc0NxQYUbEssFUjdfKsAMI4wV0METfaBvlh05UoJNro/EDz63TIVd4w+Za3CFg947BH1AB3Edpxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775175864; c=relaxed/simple;
	bh=PSG2pD1bxaF3huDleq3gxn76NJIKWKsUixYHeu6X70U=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=qCkoIG4L8P3hG3l2Qs0EpP+uEnV5FQtEzYqKKYE664kfAO++VfamBKV7TgUPx5TXc7CTo6xe36pdVd8U0JrRaEdOFzW+c1ndzlGWcygoPYCNSxJ6NWL38kVU7o7PugE6s2LHvBy+sbJvSCtr9tSb//upKsAl3xVgHZUVcB9M4kM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=AyuIMpP4; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="AyuIMpP4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=Content-Type:MIME-Version:Message-ID:Subject:
	To:From:Date:cc:to:subject:message-id:date:from:content-type:in-reply-to:
	references:reply-to; bh=NYv/MV28FqzZDMKaGximea77+EENWj/EDOqqkqglnlU=; b=AyuIM
	pP45f4Ze06CcZTvpBjE4ppxJ4hvqRN7SkAUb9hR0c0BBG7LXNG5AhnGoDAkUt+iDVIFJaUgEWNZv+
	/fXjQ6PnKPwi0uKYtqQIcxQexn8be6iO9Naj36gN7sGWPbzo9P/1+VO33TnKTClbRstqcAZEAPFC8
	R2Q52zIwzVJAmtBf/3Db7Sd0s9ga1bnZ2zE/cv0RlPsGRfNH2vQCsAd5ax2lXo8TOQYrcP2DQ2pwR
	xmncCi8G0KuBHvhY10AhR/yuFMYmJLSy07rcR/TzVfNKWeHijL1yOOfeXQEEZXwLcxUm2F2o2t187
	A9UxCaoK5OZMv/rluTi01enQSAJbQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1w8Rv1-003QOo-0R;
	Fri, 03 Apr 2026 08:24:07 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 03 Apr 2026 08:24:05 +0800
Date: Fri, 3 Apr 2026 08:24:05 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [GIT PULL] Crypto Fixes for 7.0
Message-ID: <ac8IpdQbWxiGuq0E@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hi Linus:

The following changes since commit 5c52607c43c397b79a9852ce33fc61de58c3645c:

  crypto: ccp - Fix leaking the same page twice (2026-03-14 14:01:37 +0900)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6 tags/v7.0-p4

for you to fetch changes up to e02494114ebf7c8b42777c6cd6982f113bfdbec7:

  crypto: authencesn - Do not place hiseq at end of dst for out-of-place decryption (2026-03-31 17:11:48 +0900)

----------------------------------------------------------------
This push contains the following changes:

- Add missing async markers to tegra.
- Fix long hmac key DMA handling in caam.
- Fix spurious ENOSPC errors in deflate.
- Fix SG chaining in af_alg.
- Do not use in-place process in algif_aead.
- Fix out-of-place destination overflow in authencesn.
----------------------------------------------------------------

Eric Biggers (1):
      crypto: tegra - Add missing CRYPTO_ALG_ASYNC

Herbert Xu (2):
      crypto: algif_aead - Revert to operating out-of-place
      crypto: authencesn - Do not place hiseq at end of dst for out-of-place decryption

Horia Geantă (2):
      crypto: caam - fix DMA corruption on long hmac keys
      crypto: caam - fix overflow on long hmac keys

Mikulas Patocka (1):
      crypto: deflate - fix spurious -ENOSPC

Norbert Szetei (1):
      crypto: af-alg - fix NULL pointer dereference in scatterwalk

 crypto/af_alg.c                      |  53 +++++--------------
 crypto/algif_aead.c                  | 100 +++++++----------------------------
 crypto/algif_skcipher.c              |   6 +--
 crypto/authencesn.c                  |  50 +++++++++++-------
 crypto/deflate.c                     |  11 ++--
 drivers/crypto/caam/caamalg_qi2.c    |   3 +-
 drivers/crypto/caam/caamhash.c       |   3 +-
 drivers/crypto/tegra/tegra-se-aes.c  |  11 ++--
 drivers/crypto/tegra/tegra-se-hash.c |  30 ++++++-----
 include/crypto/if_alg.h              |   5 +-
 10 files changed, 102 insertions(+), 170 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
