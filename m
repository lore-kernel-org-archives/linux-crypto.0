Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDB375258
	for <linux-crypto@vger.kernel.org>; Tue, 13 May 2025 06:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747116239; cv=none; b=WpYKaxsRQcKzXRawVzqjok2OSwmybaB2PaLwlpuiZQsUeXu32u64EJIOKun6+KRdy9UAzGOCO3Is3hBR/jz7bV6rYsPKYNP0giv+4tHQOyhoUEYTgR5xI0LNF/l9AACJAXQ0x28Ey8ZmNhbsLeoylNWF5vXWyPp5wZbGJIpJ/O8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747116239; c=relaxed/simple;
	bh=Uy1Y63ipc0TmvW/ZAg5WsJLOKtY23vcvYs3FzkfL4ng=;
	h=Date:Message-Id:From:Subject:To:Cc; b=EJbmDkhATJJPFb6ZGPuGbIqpjSMKIefo2PFHxcGzneMz1XTZrCGKNo/Ifxk9f/8EwfxayLWGnlCvCQvnduz//IJHJ8LF+3SllrAFGvyDTjHDSLIsH1evrTQL8irUn5+qjAR2rjb6Zax12kgtdD7BOXswbGBYiRahRwp6c22+xsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=ZsYoYNhH; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="ZsYoYNhH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Cc:To:Subject:From:Message-Id:Date:Sender:Reply-To:MIME-Version
	:Content-Type:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=gnhH4MKBTnxG4N3owibGYMEInxvdW62epN6YeSvvHb0=; b=ZsYoYNhHT5C2TvhqdTySZwpFrG
	PvBrA/tLe2BXPJikfcVZjL6pQQyjh1R+d9HWw4wGsg9V/5kbPi/KwKdsOFeo7Smtuc0q9yxOR3Ahi
	RFk08Ndo94H53jxUr6xQ+R4vaDGinsCkun58GjzCe7YEFU7geuCyZcTnbOKKEtgUZeQEj34JNevkg
	T2qUSEmp9Dt7RLQuesGUKcC496KLfBTQ1lou47KtT/utyt+bemHRFfsyDjlC6FNRWrsRaRzSZ6/bB
	50eSmkGyj770u4uAbj6smX+JF4v1qxAvQLB3VQo2+pRRuy2IppnqnX/qPRe0gHom6lZ4CAW21UpPs
	islexMOg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uEijx-005g48-2K;
	Tue, 13 May 2025 14:03:46 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 13 May 2025 14:03:45 +0800
Date: Tue, 13 May 2025 14:03:45 +0800
Message-Id: <cover.1747116129.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 00/11] crypto: aspeed/hash - Convert to partial block API
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: Neal Liu <neal_liu@aspeedtech.com>, linux-aspeed@lists.ozlabs.org
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

This series converts aspeed to the partial block API while removing
hash length limits and making it more robust if dma mapping fails.

Herbert Xu (11):
  crypto: aspeed/hash - Remove purely software hmac implementation
  crypto: aspeed/hash - Reorganise struct aspeed_sham_reqctx
  crypto: aspeed/hash - Use init_tfm instead of cra_init
  crypto: aspeed/hash - Provide rctx->buffer as argument to fill padding
  crypto: aspeed/hash - Move sham_final call into sham_update
  crypto: aspeed/hash - Move final padding into dma_prepare
  crypto: aspeed/hash - Remove sha_iv
  crypto: aspeed/hash - Use API partial block handling
  crypto: aspeed/hash - Add fallback
  crypto: aspeed/hash - Iterate on large hashes in dma_prepare
  crypto: aspeed/hash - Fix potential overflow in dma_prepare_sg

 drivers/crypto/aspeed/aspeed-hace-hash.c | 802 ++++++-----------------
 drivers/crypto/aspeed/aspeed-hace.h      |  28 +-
 2 files changed, 207 insertions(+), 623 deletions(-)

-- 
2.39.5

