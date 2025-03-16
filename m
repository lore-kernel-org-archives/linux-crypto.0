Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E19C4437A
	for <linux-crypto@vger.kernel.org>; Sun, 16 Mar 2025 01:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742088070; cv=none; b=DouIMuFsAmfumL9OgnThj1hjfw/bqSRzOA9HZ+8KhFbbLPaG5PRbfMjCBEorfLxACwfSXTymkwDcBozwvRrQj7E4AARauQT0fTavgpDkDpK0O+fYVmLawHCjCAsUvIcwspJts8/dA2NW0w/KicDpAPcgixwztqdWUdzJ4A/1mLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742088070; c=relaxed/simple;
	bh=WxZf8ojQOZ9ZS02yz6lGhHqnjWyu4ax3DvueLEBidrA=;
	h=Date:Message-Id:From:Subject:To:Cc; b=olsK/ueCXgUVmuh1ZVm5/MvJjaJb3j/KRB8+LQDNtgo/ZNfoYb2lJ2/Ul06SUBBcVD5egVcJSXkJuv8piT30/mDCU9yDf7DTT10B7JxRMCdm/iP6JiMoJygHp2DOB4E6zGxvvH6aiJnG1p3CXdwyna3oIHArHPUuaO7nVtJU5Gg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=oIpUFchJ; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="oIpUFchJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Cc:To:Subject:From:Message-Id:Date:Sender:Reply-To:MIME-Version
	:Content-Type:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Rx7SpjylYHSsSoEr4qRdTA44QgWABjvDksr+gRaWde8=; b=oIpUFchJrzbTYc8ivN4WF2gKQ5
	hD3E+kKTzg6eaYlutcAz0ApW0lmWe8IXLF2sezk9bl96zx4KLU4XsO/nfdH4SXWOdTY9Bp64BUfT7
	ugZe8liFrzan1VsjWuX2vgQp2v+bw/VetXT+g7MQ32IrIQTW+X81jKLt0kAld3SsEUjO7QcxhKsQQ
	+GcjByNM/DM/ksnM9g1qJJiubLi0HFJl4ofQuH1qgItSnOo0P4Kpv4hn21e1IhwzULpLzFMDMos12
	cK6VsWkPdfH9rl80tKghpRBvX9ucb+1pthwV5uBg3fqEh45d0yIETfl//VnPV5egZuOVazn/SAUh6
	25b7eZrg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1ttcgX-006xY1-2J;
	Sun, 16 Mar 2025 09:21:02 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 16 Mar 2025 09:21:01 +0800
Date: Sun, 16 Mar 2025 09:21:01 +0800
Message-Id: <cover.1742087941.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 00/11] crypto: comp - Remove comp interface
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

This is a resurrection of a patch series that Ard posted back in
2023:

https://patchwork.kernel.org/project/linux-crypto/cover/20230718125847.3869700-1-ardb@kernel.org/

It removes the legacy crypto compression interface.

Ard Biesheuvel (11):
  crypto: nx - Migrate to scomp API
  crypto: 842 - drop obsolete 'comp' implementation
  crypto: deflate - drop obsolete 'comp' implementation
  crypto: lz4 - drop obsolete 'comp' implementation
  crypto: lz4hc - drop obsolete 'comp' implementation
  crypto: lzo-rle - drop obsolete 'comp' implementation
  crypto: lzo - drop obsolete 'comp' implementation
  crypto: zstd - drop obsolete 'comp' implementation
  crypto: cavium/zip - drop obsolete 'comp' implementation
  crypto: compress_null - drop obsolete 'comp' implementation
  crypto: remove obsolete 'comp' compression API

 Documentation/crypto/architecture.rst  |   2 -
 crypto/842.c                           |  66 +----------
 crypto/Makefile                        |   2 +-
 crypto/api.c                           |   4 -
 crypto/compress.c                      |  32 ------
 crypto/crypto_null.c                   |  31 +----
 crypto/crypto_user.c                   |  16 ---
 crypto/deflate.c                       |  58 +---------
 crypto/lz4.c                           |  61 +---------
 crypto/lz4hc.c                         |  66 +----------
 crypto/lzo-rle.c                       |  70 +----------
 crypto/lzo.c                           |  70 +----------
 crypto/proc.c                          |   3 -
 crypto/testmgr.c                       | 153 ++-----------------------
 crypto/zstd.c                          |  56 +--------
 drivers/crypto/cavium/zip/zip_crypto.c |  40 -------
 drivers/crypto/cavium/zip/zip_crypto.h |  11 --
 drivers/crypto/cavium/zip/zip_main.c   |  50 +-------
 drivers/crypto/nx/nx-842.c             |  33 +++---
 drivers/crypto/nx/nx-842.h             |  15 +--
 drivers/crypto/nx/nx-common-powernv.c  |  31 +++--
 drivers/crypto/nx/nx-common-pseries.c  |  33 +++---
 include/linux/crypto.h                 |  76 +-----------
 23 files changed, 95 insertions(+), 884 deletions(-)
 delete mode 100644 crypto/compress.c

-- 
2.39.5

