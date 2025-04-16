Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8883184E1C;
	Wed, 16 Apr 2025 05:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744780599; cv=none; b=MsH/IrdlQOXwaG2GrzeBj2UPdXY9bHE7xaQwSY1Uylof2iz1a/1Tsj76K6X46CzVinQ8K8kkJei/ymlW8IXs9XvWjXUj0lyAr8jJNGqzPbyNeNspLf6KCJ9i0Miiq6o+GN1zdcVvCM/XZhuWjw6dvP4LDsq13B2lnFaeJynBfaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744780599; c=relaxed/simple;
	bh=ei7rLsZrrryCoI6cB9rvLfiPFmPOEV6hkOqs5UKtwp4=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t2BMR8V7K9OjXfJ9xQpUN8emqXpN7KWb0J0OD0cUuGCoxfZQOCGqKF4nq85++H9vf7wWRiigcQ3LOAt+kZT+38Y8hGIaO4UR/HgGtcHYzpgz6S1AlkTbYs7hHYTCNJyZ290zpPh5uays10oXErYkc+WffKO9B31o9tqi+GIwx9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=MuUZWUD2; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="MuUZWUD2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=CqfvsXbBiDDcFgpcq1IA10fHYCHWEZRKwfjjAwjhDy4=; b=MuUZWUD2eLWvH0Ktn8+FSuMZNv
	DNCLnJt823oGDxR7hmZ7A5fErX3ULsvc5z/IhfbndVOrxY/TFNW3I4sA10g9xhAUyVW0pNAGaL3W1
	XZkwgx1vo0J5OP+BvE8bQItr7/SWJ6PjO8AlAEl0S7tCXLdVpjRfEhVEoC8oPG1jrgZ9o6ZJFhXqa
	jx3sbGY7tzObf2MegV5zyRpI49wc1ed03n5IGOqihuuPYEc8UaXsdDRdzTrH3I8+M1vdCHSV1AcFg
	DnHwA87P/PaTJp/HUzgjOwsYwGc7j+fi2llUYN95CY22ofHoa7/RXkHPSHaXNDENW2NpYHR40Ssxx
	gNfVcWJg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u4v8N-00G5V5-0Y;
	Wed, 16 Apr 2025 13:16:28 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 16 Apr 2025 13:16:27 +0800
Date: Wed, 16 Apr 2025 13:16:27 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [GIT PULL] Crypto Fixes for 6.15
Message-ID: <Z_89K7tSzQVKRqr6@gondor.apana.org.au>
References: <ZOxnTFhchkTvKpZV@gondor.apana.org.au>
 <ZUNIBcBJ0VeZRmT9@gondor.apana.org.au>
 <ZZ3F/Pp1pxkdqfiD@gondor.apana.org.au>
 <ZbstBewmaIfrFocE@gondor.apana.org.au>
 <ZgFIP3x1w294DIxQ@gondor.apana.org.au>
 <ZkrC8u1NmwpldTOH@gondor.apana.org.au>
 <ZvDbn6lSNdWG9P6f@gondor.apana.org.au>
 <Z11ODNgZwlA9vhfx@gondor.apana.org.au>
 <Z-ofAGzvFfuGucld@gondor.apana.org.au>
 <Z_CUFE0pA3l6IwfC@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z_CUFE0pA3l6IwfC@gondor.apana.org.au>

Hi Linus:

The following changes since commit 0af2f6be1b4281385b618cb86ad946eded089ac8:

  Linux 6.15-rc1 (2025-04-06 13:11:33 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git tags/v6.15-p4

for you to fetch changes up to b2e689baf220408aff8ee5dfb4edb0817e1632bb:

  crypto: ahash - Disable request chaining (2025-04-12 09:33:09 +0800)

----------------------------------------------------------------
This push fixes the following issues:

- Disable ahash request chaining as it causes problems with the sa2ul driver.
- Fix a couple of bugs in the new scomp stream freeing code.
- Fix an old caam refcount underflow that is possibly showing up now
  because of the new parallel self-tests.
- Fix regression in the tegra driver.
----------------------------------------------------------------

Akhil R (1):
      crypto: tegra - Fix IV usage for AES ECB

Herbert Xu (4):
      crypto: scomp - Fix null-pointer deref when freeing streams
      crypto: caam/qi - Fix drv_ctx refcount bug
      crypto: scomp - Fix wild memory accesses in scomp_free_streams
      crypto: ahash - Disable request chaining

 crypto/ahash.c                      | 76 +------------------------------------
 crypto/scompress.c                  | 10 +++--
 drivers/crypto/caam/qi.c            |  6 +--
 drivers/crypto/tegra/tegra-se-aes.c |  5 +--
 include/crypto/hash.h               |  6 ++-
 include/crypto/internal/hash.h      |  2 +-
 6 files changed, 18 insertions(+), 87 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
