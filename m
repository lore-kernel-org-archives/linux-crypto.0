Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F03F31F37CE
	for <linux-crypto@vger.kernel.org>; Tue,  4 Mar 2025 09:25:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741080310; cv=none; b=Iu70K/OgYI3yy/u2AhRgDPXAv30aS8Adarqyzc7GmnqknQeLY9YB9cWmpbV1sqx7a/g91zS7jruOQvh6TF9IPupN73YVilx5aDwCMhHRLxz8mBpKIBhClaGnfVapEcRFeGZma7ORooUKYvKVKrU4hpsGceGPTvPl9idCDthUq5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741080310; c=relaxed/simple;
	bh=V5WgKTuPylQ7ld1Wocn1u3xZQVR8yKw69FRZ0nsQ7i0=;
	h=Date:Message-Id:From:Subject:To:Cc; b=adifdltFn9tOB402cE/rBHl3x/EKQtyKVAE4IRsAdRUiTkGrleRVE+Zxc0FumouSyJ5HePFKemNlJ+I6BL0l1Yp7cH9gamW8J3/3q2KO4CKMFqvMH/AhZfDvkOfeQPqEKvET6acqHpzEOIfseBtxW7bPY6LYs9xSvyf62sTFaZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=jqovEuM+; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="jqovEuM+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Cc:To:Subject:From:Message-Id:Date:Sender:Reply-To:MIME-Version
	:Content-Type:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=oOWyZsWtOhaGOVjcVSi4lGgbwKvpdJ6y1wpvql7a50s=; b=jqovEuM+VoQGfea29LrxoT+JAc
	nodb+6A5hb5kSEjKrQjpe3cnNcY84ezGkUC8okZd1A7ORgaIzewRFgzV7ZXPfilL++4nJ0tDS7KZB
	Jm6pez3WuQW02oqxaohimeONzdXKX8I+4h8YUqJ5zLLv0txEo8hvKtmQjkGz3fW9+9g+r49vKkY73
	HvW2qbSUt1XNxMlRE0sNpjeXu9ukzLh0BsxdLn7AziTGGUASgRp3ki2viueIICpSBuHOzuxApK3zR
	wTETzClwxSxHD4d59LD5KzbeCpGIWhRw8Vz2aZdy2Jhu0ngVQhHuPjxNc8phpjE+8ihGrSLYKdpyS
	q6I5grBw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tpOWL-003a2B-1f;
	Tue, 04 Mar 2025 17:25:02 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 04 Mar 2025 17:25:01 +0800
Date: Tue, 04 Mar 2025 17:25:01 +0800
Message-Id: <cover.1741080140.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v2 PATCH 0/7] crypto: acomp - Add request chaining and virtual address support
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: linux-mm@kvack.org, Yosry Ahmed <yosry.ahmed@linux.dev>, Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

This patch series adds reqeust chaining and virtual address support
to the crypto_acomp interface.

Herbert Xu (7):
  crypto: api - Add cra_type->destroy hook
  crypto: scomp - Remove tfm argument from alloc/free_ctx
  crypto: acomp - Add request chaining and virtual addresses
  crypto: testmgr - Remove NULL dst acomp tests
  crypto: scomp - Remove support for most non-trivial destination SG
    lists
  crypto: scomp - Add chaining and virtual address support
  crypto: acomp - Move stream management into scomp layer

 crypto/842.c                           |   8 +-
 crypto/acompress.c                     | 208 ++++++++++++++++++++---
 crypto/algapi.c                        |   9 +
 crypto/compress.h                      |   2 -
 crypto/deflate.c                       |   4 +-
 crypto/internal.h                      |   6 +-
 crypto/lz4.c                           |   8 +-
 crypto/lz4hc.c                         |   8 +-
 crypto/lzo-rle.c                       |   8 +-
 crypto/lzo.c                           |   8 +-
 crypto/scompress.c                     | 226 +++++++++++++++----------
 crypto/testmgr.c                       |  29 ----
 crypto/zstd.c                          |   4 +-
 drivers/crypto/cavium/zip/zip_crypto.c |   6 +-
 drivers/crypto/cavium/zip/zip_crypto.h |   6 +-
 include/crypto/acompress.h             | 118 ++++++++++---
 include/crypto/internal/acompress.h    |  39 +++--
 include/crypto/internal/scompress.h    |  18 +-
 18 files changed, 488 insertions(+), 227 deletions(-)

-- 
2.39.5

