Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 767F0210F45
	for <linux-crypto@vger.kernel.org>; Wed, 30 Apr 2025 08:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746001562; cv=none; b=FwKho1NEG+pdnKFVyE7RucJY/qMzSwR/jBcO4FBBF2WDvaC4iCw9O2jIPRCYC/AJNHjkWkCZF0QPvUiPPE/Bkc61ohwKBEZSzdtwm0xlkIDhbJgiF9AYAURwYyLL0JKmAu+aqvTxF88siPgWkenjHEVjxkenuEM0xPCdR5r7lew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746001562; c=relaxed/simple;
	bh=+AuIuIUyhweQGTDyMRQfCE77a6DyEX/P8ogaUVNAyAA=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=hSPKw3D99twxVEV3M1g6I1rP5ovVasr8x5wbjcvJkP3YMImowij83v+RYWhN5Fle1eHq6j4cUF4T8OSI6LpKMhRTXK7F+e2m3DHF6Liq2E4VHnMaxZTpbI2KCbgN0O3B6Uyg+76A8Ky1OR8L8TlOhZqsRNUlMAFo/2RfH0YMcEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=pZKzpB3G; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="pZKzpB3G"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Content-Type:MIME-Version:Message-ID:Subject:To:From:Date:
	Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=B2vDGo7QRSKQj15Wy/+XQ5p+zBqiSWdx2R/Xmla2OGE=; b=pZKzpB3GXdAPnv7r4i3bLf+wFa
	GwVOk77wxAAhfVcW/tqTCHTG9/TnDrm0QDs7p+Ev2KRFAhukfzRQWJDwAEKawXgXtmqw5D79Q5qTN
	hlSLRFJtw7U/o7UDaYymDJ2uv1pXRCiiINUset8sNmkhDyoOwgxYQUsV440ldEPtRbWqVfhOfHvyn
	SsysvnAQy1/xAW16wyXzAT1zCySahTQ/DTu0GXCs91Y9uxFrGqu5aOl8AmgO2WkMTbOEhm5ysKMed
	aD9HRFxFHs4qtgDb6jQfFgImsIOQOh8STxBg+7yo8g4BFHu2nWvdQOYgrIQaYf0XO1DYQtB5Ltkq5
	q7yO6Ibg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uA2lP-002D38-1W;
	Wed, 30 Apr 2025 16:25:56 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 30 Apr 2025 16:25:55 +0800
Date: Wed, 30 Apr 2025 16:25:55 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [PATCH] crypto: x86/blake2s - Include linux/init.h
Message-ID: <aBHek23p0_0Xd6Wy@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Explicitly include linux/init.h rather than pulling it through
potluck.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 arch/x86/lib/crypto/blake2s-glue.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/arch/x86/lib/crypto/blake2s-glue.c b/arch/x86/lib/crypto/blake2s-glue.c
index 00f84f29cc8c..adc296cd17c9 100644
--- a/arch/x86/lib/crypto/blake2s-glue.c
+++ b/arch/x86/lib/crypto/blake2s-glue.c
@@ -3,17 +3,15 @@
  * Copyright (C) 2015-2019 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
  */
 
-#include <crypto/internal/blake2s.h>
-
-#include <linux/types.h>
-#include <linux/jump_label.h>
-#include <linux/kernel.h>
-#include <linux/sizes.h>
-
 #include <asm/cpufeature.h>
 #include <asm/fpu/api.h>
 #include <asm/processor.h>
 #include <asm/simd.h>
+#include <crypto/internal/blake2s.h>
+#include <linux/init.h>
+#include <linux/jump_label.h>
+#include <linux/kernel.h>
+#include <linux/sizes.h>
 
 asmlinkage void blake2s_compress_ssse3(struct blake2s_state *state,
 				       const u8 *block, const size_t nblocks,
-- 
2.39.5

-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
