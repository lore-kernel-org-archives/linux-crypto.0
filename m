Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD6C717BA5
	for <linux-crypto@vger.kernel.org>; Sun,  9 Mar 2025 02:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741488200; cv=none; b=ssThHCSOI7tWQZ8oVBrCxoezVikUoRQSdslthZBAZ8nS2vdNdxeqnUb+XmUYAe7cpt1bi5+QiF0Rtl1tV8SoEJnGcSmHTjAVbgtT+T1zzWXGTjOpiFQvWYpYhmePSgfOm5knWqCcQPPt4Tfwrglh/mD6Li0VkXmru9vx8yMlQ9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741488200; c=relaxed/simple;
	bh=tmLysB9Khp1iYmMoyw5NJISthFKCFcw4TBvLLR6uQk4=;
	h=Date:Message-Id:From:Subject:To:Cc; b=HfxEzh4NOSk4o29LsujTqCVg8VUYQw7PMGMTN3ql4pmhSJ4qeaninY3qGzGhgthXvSO+bEWtIG7czxpw5Ov2yfiCQcpctBjVmh//YMB7f5YQuBWJa0gmPQblGgMGHhzqFpqwblVYNXHBOBVRYPr6Lcs85yO9un0dEbn7LzZn0lo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=OIILnKm8; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="OIILnKm8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Cc:To:Subject:From:Message-Id:Date:Sender:Reply-To:MIME-Version
	:Content-Type:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=wmmkOpiVwPDJW+36ScQPJAsuKUZhZI4DO4YY8RoHQ7s=; b=OIILnKm8dFDzsi/XIkoyJio2tu
	LeU0SYlIXMm/SueRQ1tFIhC5qRb+Ow/OYfkQDgw7OpHF2k+Fe7CHwggj3CEbc8Ul4ZplH76Uld8qj
	yvXVl+4G2RpO7PahXPdwm1rqknhAkagIXrcDeyhSQmARsav1zg0fV4mDo4tQB9YGbONgsedVcxcd2
	bT7/EehWScpry75qHRXauHzhCTo7a9TLkhWpmHRJ4xFF+v/AHa5UM0AQr8OphLUggTsp9po7Kl6Bi
	R36b1BeuX8TNyMCmOIUABFyyPshiqOxow1a04ZRSdv86s2q/aFDSJcaUjHcdYAqIFzw2ipwH+dDC9
	Pc80Dy3A==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tr6dC-004zHG-0M;
	Sun, 09 Mar 2025 10:43:11 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 09 Mar 2025 10:43:10 +0800
Date: Sun, 09 Mar 2025 10:43:10 +0800
Message-Id: <cover.1741488107.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v3 PATCH 0/8] crypto: acomp - Add request chaining and virtual address support
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>, Kanchana P Sridhar <kanchana.p.sridhar@intel.com>, Sergey Senozhatsky <senozhatsky@chromium.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

v3 adds mixing SG with virtual, e.g., SG src with virtual dst.

This patch series adds reqeust chaining and virtual address support
to the crypto_acomp interface.

Herbert Xu (8):
  crypto: api - Add cra_type->destroy hook
  crypto: scomp - Remove tfm argument from alloc/free_ctx
  crypto: acomp - Move stream management into scomp layer
  crypto: scomp - Disable BH when taking per-cpu spin lock
  crypto: acomp - Add request chaining and virtual addresses
  crypto: testmgr - Remove NULL dst acomp tests
  crypto: scomp - Remove support for most non-trivial destination SG
    lists
  crypto: scomp - Add chaining and virtual address support

 crypto/842.c                           |   8 +-
 crypto/acompress.c                     | 204 +++++++++++++++++++---
 crypto/api.c                           |  10 ++
 crypto/compress.h                      |   2 -
 crypto/deflate.c                       |   4 +-
 crypto/internal.h                      |   6 +-
 crypto/lz4.c                           |   8 +-
 crypto/lz4hc.c                         |   8 +-
 crypto/lzo-rle.c                       |   8 +-
 crypto/lzo.c                           |   8 +-
 crypto/scompress.c                     | 225 +++++++++++++++----------
 crypto/testmgr.c                       |  29 ----
 crypto/zstd.c                          |   4 +-
 drivers/crypto/cavium/zip/zip_crypto.c |   6 +-
 drivers/crypto/cavium/zip/zip_crypto.h |   6 +-
 include/crypto/acompress.h             | 225 ++++++++++++++++++++++---
 include/crypto/internal/acompress.h    |  59 +++++--
 include/crypto/internal/scompress.h    |  18 +-
 18 files changed, 611 insertions(+), 227 deletions(-)

-- 
2.39.5

