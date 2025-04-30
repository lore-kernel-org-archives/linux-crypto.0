Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 719231E5202
	for <linux-crypto@vger.kernel.org>; Wed, 30 Apr 2025 06:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745993199; cv=none; b=QRkAZ0SO9PpYksEjHdoZ7gZkpAfmBSllKYDfjFvreFYehQs6gZJoLUHMMhubjUrMabTzIDhNSCwt0o/Pdy2fKO5HTWCeXEtbJdN7Jr/NyUnCQ3ujC842rTtvSWvlmptF84XpvOCIfLbdGUuZrYOvTyEFM7pmx+xIZFIe7fPb2jg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745993199; c=relaxed/simple;
	bh=qF6y5fESRZoTDJV0vuPrxoFM96bjYfFYXQL/wyQMInY=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=hZwqCvAIFk38VIGHgJuxYA1V3mfCcRBMaD3cv6n9NCabf/a+bKCA5Vtrc46l3koJExl/w1J63AsYnHYCZx0HBwSYZrBEJV1iCImTAqSCXRSjLik+0w0HJJ8cYrK7BCVKnJOWudXEP20DOsHox66KYVEu7iguJmZoSYkkGumuIdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=oogBN3Ho; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="oogBN3Ho"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ew7RwAjpad2G+egHDYlmuB1mTdwNCSZmfETgS1XfJzI=; b=oogBN3HoSfCX3/fwpYjonjceHn
	Yqo812d8VY91Kiom3daCYlNDuM1V00NV1Ttu5lqHD13omEwejR+nAAnlIPDRg2uTCBijPCtfOifZ1
	BDuSSynks1Q4lhMpmFf9mI1mvrtzAvlsjCyg9xLhauQi6y4jjwwUT2Bynptin6FWT4fnTCjoGyMuk
	CnXVE9OZM8JGzfb2cFN/a5NX8WOy4NThnEivJu3g4vwnO9u9ho2sbN/c0B1I94FEC8qNKzhpfJ8Id
	TYqEClV/eodjqZm2WEIH265BV7WtXMJW+mtscAb9FBMeTrkY4WJUGSEP/v0L5nqWKnBRpt9zTSqV5
	lHBQO8sg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uA0aX-002Ab4-24;
	Wed, 30 Apr 2025 14:06:34 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 30 Apr 2025 14:06:33 +0800
Date: Wed, 30 Apr 2025 14:06:33 +0800
Message-Id: <ee4c035563382b803cac8aed6deb61e9b96fdaff.1745992998.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1745992998.git.herbert@gondor.apana.org.au>
References: <cover.1745992998.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 08/12] crypto: s390/sha256 - Export block functions as GPL
 only
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Export the block functions as GPL only, there is no reason
to let arbitrary modules use these internal functions.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 arch/s390/lib/crypto/sha256.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/s390/lib/crypto/sha256.c b/arch/s390/lib/crypto/sha256.c
index 50c592ce7a5d..fcfa2706a7f9 100644
--- a/arch/s390/lib/crypto/sha256.c
+++ b/arch/s390/lib/crypto/sha256.c
@@ -21,13 +21,13 @@ void sha256_blocks_arch(u32 state[SHA256_STATE_WORDS],
 	else
 		sha256_blocks_generic(state, data, nblocks);
 }
-EXPORT_SYMBOL(sha256_blocks_arch);
+EXPORT_SYMBOL_GPL(sha256_blocks_arch);
 
 bool sha256_is_arch_optimized(void)
 {
 	return static_key_enabled(&have_cpacf_sha256);
 }
-EXPORT_SYMBOL(sha256_is_arch_optimized);
+EXPORT_SYMBOL_GPL(sha256_is_arch_optimized);
 
 static int __init sha256_s390_mod_init(void)
 {
-- 
2.39.5

