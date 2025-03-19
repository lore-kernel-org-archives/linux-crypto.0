Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD4E3253B60
	for <linux-crypto@vger.kernel.org>; Wed, 19 Mar 2025 12:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742387509; cv=none; b=mq6nj3T9Z/fRmvOyXFYf9BEhDndJbDCfkkntQjEcTnU86ceikrJTp/UqH6V610DJblD9S1l3HSfSuX8Dppp5LrTyG/Ia9blcgDglOQdU3DPhBJobtWI4abLsAnVC7fc707gXQhtb3zl+tW4alP6w/w39EykANC+AXvz80sWrpTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742387509; c=relaxed/simple;
	bh=PyfzWpslcjwcwkoeCgS9AVUuhS3nY3EXKC7FgGF/7EY=;
	h=Date:Message-Id:From:Subject:To:Cc; b=JJsmOLf/j78XcaViMOanLk39DfUlG5FCjHFgtqOisC45KvH3hDxfgF9ntvUvT/S3OJfvxkXJb7w9AVpjQHZg7sPLUVUzacGjFSEhzPtDv9daVt/lc/SoAbfSfmru7CRmGJGZ3KRE2yiR2ACIdPx5+Rj4W83O36hxsPNuaLPTSRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=M7NGC2P/; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="M7NGC2P/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Cc:To:Subject:From:Message-Id:Date:Sender:Reply-To:MIME-Version
	:Content-Type:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=62/iGZmt873zN/+GskqbsltIiaAnE7ZaiYnfQQc374Y=; b=M7NGC2P/wDeejEZ2po7FvVGJCp
	a11OOPZL+3+Z8/HeCWvPzMZA4DE9vffxA0neVoow8TC95DH2rrbhvJZ+Wf5IV1+igRIhUs5eWv7Nz
	CRsZO0Cl1OaXsCRnYkqPM2vtagPSu8L6xASqWNOIVoeLhnkQg9w6FYhcklC9kksaqc9q22L5DzClN
	61ws+nvy/yUhkkMOQrkKTHFo+GtbSHMPdiLLOx7WcXBw+gXZAidtAu1XxWsaG7OeyQ93jTDIzHj6U
	5oZ9tTQRCSoztKulUe8hvsdbbSDf2lBPYLZo3GIXw+1FWGcxG7gQG87CBkHWNletLDj16dGjKQjR9
	nbuv7fbA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tusaE-008Q0W-1K;
	Wed, 19 Mar 2025 20:31:43 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 19 Mar 2025 20:31:42 +0800
Date: Wed, 19 Mar 2025 20:31:42 +0800
Message-Id: <cover.1742387288.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 0/3] crypto: Remove cavium zip and drop scomp dst buffer
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

This series removes the cavium zip driver and the dst scratch buffer
from scomp.  The latter could use up to 64K of memory per CPU.

Herbert Xu (3):
  crypto: cavium - Move cpt and nitrox rules into cavium Makefile
  crypto: cavium/zip - Remove driver
  crypto: scomp - Drop the dst scratch buffer

 crypto/scompress.c                      |   98 +-
 drivers/crypto/Kconfig                  |    7 -
 drivers/crypto/Makefile                 |    4 +-
 drivers/crypto/cavium/Makefile          |    3 +-
 drivers/crypto/cavium/zip/Makefile      |   12 -
 drivers/crypto/cavium/zip/common.h      |  222 ----
 drivers/crypto/cavium/zip/zip_crypto.c  |  261 -----
 drivers/crypto/cavium/zip/zip_crypto.h  |   68 --
 drivers/crypto/cavium/zip/zip_deflate.c |  200 ----
 drivers/crypto/cavium/zip/zip_deflate.h |   62 --
 drivers/crypto/cavium/zip/zip_device.c  |  202 ----
 drivers/crypto/cavium/zip/zip_device.h  |  108 --
 drivers/crypto/cavium/zip/zip_inflate.c |  223 ----
 drivers/crypto/cavium/zip/zip_inflate.h |   62 --
 drivers/crypto/cavium/zip/zip_main.c    |  603 ----------
 drivers/crypto/cavium/zip/zip_main.h    |  120 --
 drivers/crypto/cavium/zip/zip_mem.c     |  114 --
 drivers/crypto/cavium/zip/zip_mem.h     |   78 --
 drivers/crypto/cavium/zip/zip_regs.h    | 1347 -----------------------
 19 files changed, 47 insertions(+), 3747 deletions(-)
 delete mode 100644 drivers/crypto/cavium/zip/Makefile
 delete mode 100644 drivers/crypto/cavium/zip/common.h
 delete mode 100644 drivers/crypto/cavium/zip/zip_crypto.c
 delete mode 100644 drivers/crypto/cavium/zip/zip_crypto.h
 delete mode 100644 drivers/crypto/cavium/zip/zip_deflate.c
 delete mode 100644 drivers/crypto/cavium/zip/zip_deflate.h
 delete mode 100644 drivers/crypto/cavium/zip/zip_device.c
 delete mode 100644 drivers/crypto/cavium/zip/zip_device.h
 delete mode 100644 drivers/crypto/cavium/zip/zip_inflate.c
 delete mode 100644 drivers/crypto/cavium/zip/zip_inflate.h
 delete mode 100644 drivers/crypto/cavium/zip/zip_main.c
 delete mode 100644 drivers/crypto/cavium/zip/zip_main.h
 delete mode 100644 drivers/crypto/cavium/zip/zip_mem.c
 delete mode 100644 drivers/crypto/cavium/zip/zip_mem.h
 delete mode 100644 drivers/crypto/cavium/zip/zip_regs.h

-- 
2.39.5

