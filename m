Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC38229408;
	Sun, 12 Apr 2026 05:42:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775972551; cv=none; b=cUhE2zmkWyNCWIMR5CD8PJ42w5TAXPbNyQvwNZkCJqtJ66U5ECIoCF6r8f3051aSXKScs8tMnaGn3s8oXGHZdmhXB1eVGLjx+vREe/c+9zYeJisKiA36FkBdQR1kzQmoGudo483ymo5IcVQRfR3SlapuHDoISxhPOpC/Y9GVvZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775972551; c=relaxed/simple;
	bh=XsN4Ody2/TPyM8PZZmC7+RttzyLqkElEdbZFo4LCV48=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=MEZRzp1PHfzkUnSuU/MiFO9cd8F0UNpyWK846Kd7NQhZ4om83pAWr/LVOYhBw5SDU4vc2/8aBj5Vr9A+6KfIuUcRYlDkpI7ooVnQxSDXnayC5frHUfSThK6muKnAQ4agbQRRj96AdNtmWsgvYwUUi6WlA2+ZaB9Va2TO6w/L6TM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=fHtLgM8w; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="fHtLgM8w"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=Content-Type:MIME-Version:Message-ID:Subject:
	To:From:Date:cc:to:subject:message-id:date:from:content-type:in-reply-to:
	references:reply-to; bh=eJgHAf89J7tM9f00mPaA/Ii/xLmWPtAe0lI3nlkbcFc=; b=fHtLg
	M8wvFfezZ6OdL643CSR6b8cpn2gNHQcBMQ1lpE5bBugICWBbtlPfZ0OXbqG1lPi6l61HQzxt6JH17
	29yzoS9owARjjF+7E9aL9Sy+ux8FdRF692abpHkGsgKxyDIK7E2n6sGSHDVJu4fGYMpgQf30DPT71
	nwqQ4kaB4RZVofKSfm9zEaid2uOH53gX9jBicaY39cXZ6+7XQfRsaQ+3D8M/yaAqaz1lM8uAM1lrw
	ibf90JEis+Mh1lYObxe0dSHN2fbK+ScjoHVDX4JyP778SMzE3LoPpGyaiTUSLqcykcsBcrtavOmix
	2td9EYxcRX7CUWyn5/+nLkVo+bXAQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wBnAx-005T3u-0v;
	Sun, 12 Apr 2026 13:42:23 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 12 Apr 2026 13:42:22 +0800
Date: Sun, 12 Apr 2026 13:42:22 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [GIT PULL] Crypto Fixes for 7.0
Message-ID: <adswvtLQx42MYSX8@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus:

The following changes since commit e02494114ebf7c8b42777c6cd6982f113bfdbec7:

  crypto: authencesn - Do not place hiseq at end of dst for out-of-place decryption (2026-03-31 17:11:48 +0900)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6 tags/v7.0-p5

for you to fetch changes up to 3d14bd48e3a77091cbce637a12c2ae31b4a1687c:

  crypto: algif_aead - Fix minimum RX size check for decryption (2026-04-12 13:38:19 +0800)

----------------------------------------------------------------
This push contains the following changes:

- Enforce rx socket buffer limit in af_alg.
- Fix array overflow in af_alg_pull_tsgl.
- Fix out-of-bounds access when parsing extensions in X.509.
- Fix minimum rx size check in algif_aead.
----------------------------------------------------------------

Douya Le (1):
      crypto: af_alg - limit RX SG extraction by receive buffer budget

Herbert Xu (2):
      crypto: af_alg - Fix page reassignment overflow in af_alg_pull_tsgl
      crypto: algif_aead - Fix minimum RX size check for decryption

Lukas Wunner (1):
      X.509: Fix out-of-bounds access when parsing extensions

 crypto/af_alg.c                           | 6 ++++--
 crypto/algif_aead.c                       | 2 +-
 crypto/algif_skcipher.c                   | 5 +++++
 crypto/asymmetric_keys/x509_cert_parser.c | 8 ++++----
 4 files changed, 14 insertions(+), 7 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
