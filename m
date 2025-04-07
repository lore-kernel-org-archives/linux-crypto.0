Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ED7523098D
	for <linux-crypto@vger.kernel.org>; Mon,  7 Apr 2025 10:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744020697; cv=none; b=f9IxgonoAWK2FkcyvKjrKhhiot3mqcKHEeySZeez54irkehbGRGS5OhXjroqx/UMPMDzZlR4CAVe3Uoi2RpL5pPgyCN0dgTT5xQmtZsV1lnG7NwSGjpbe93JVwAA73AYvEjKLaDHKBz+MeE5FcuLjspYpjT+H3N4xoKGGg3YDkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744020697; c=relaxed/simple;
	bh=Rx43x/gmNAVqvUidLKT9WQpcj57N5z5fmYfWym47W3w=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=eCKwWF5jyMxShwsetZY769DamrYbf+pGdHx3+LK3gP1yAaOKXVweXLG6ctT1Xj6Mv2Hb0k7bN5gn+R9cUtzw6tcpwzyoaFuURAZmV06qtxDBXxIHuVb2h09BPwXJ9/iha2cdehloTcKsOxv5SFoSZSI9XirEDDWHjwSA84UWdDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=tEoOu6i6; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="tEoOu6i6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=SVtSz/Fhnl1tff8QqTJNTl3sUqI5bps0fDeYDjgrp9A=; b=tEoOu6i6+TVppvjLVp7LAg4S65
	LPql10VuxMMz6GSLx9BiqOhBaC7VAi5UeRwfBDyA98uPxleIByQHpG1x5Qbb9RHEQRsSQZcf3bMYs
	afwhw5vJK18IiMDyIkJ+6Mf/9tPesF/ahRa5t4jI/BXCi0Ty2bb36SI/8uGYtXDhj6t/qo9SxUz+E
	OoDUkEF1HLM0qGi8f+pJ8nRUv/HT6/c0E8BK/uC6ZUixWVoY8NCujOpoWZn37936Q3RY9TeWuWV7u
	3I0d0sZK3aDIjk1S7M17IfMwbEIao4elqArFLLQdoUz1K+yya8Udr8hLDI8ExkTRZAAciP6CdSwF9
	dErGe4fg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u1jRz-00DTPg-0A;
	Mon, 07 Apr 2025 18:11:32 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 07 Apr 2025 18:11:31 +0800
Date: Mon, 07 Apr 2025 18:11:31 +0800
Message-Id: <2890fa98bd1086655ab11503e0b719348df53e97.1744020575.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1744020575.git.herbert@gondor.apana.org.au>
References: <cover.1744020575.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 3/4] crypto: s5p-sss - Add missing header inclusions
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The gutting of crypto/ctr.h uncovered missing header inclusions.
Add them.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 drivers/crypto/s5p-sss.c | 24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
index b4c3c14dafd5..b829c84f60f2 100644
--- a/drivers/crypto/s5p-sss.c
+++ b/drivers/crypto/s5p-sss.c
@@ -9,11 +9,17 @@
 //
 // Hash part based on omap-sham.c driver.
 
+#include <crypto/aes.h>
+#include <crypto/ctr.h>
+#include <crypto/internal/hash.h>
+#include <crypto/internal/skcipher.h>
+#include <crypto/md5.h>
+#include <crypto/scatterwalk.h>
+#include <crypto/sha1.h>
+#include <crypto/sha2.h>
 #include <linux/clk.h>
-#include <linux/crypto.h>
 #include <linux/dma-mapping.h>
 #include <linux/err.h>
-#include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
@@ -22,17 +28,9 @@
 #include <linux/of.h>
 #include <linux/platform_device.h>
 #include <linux/scatterlist.h>
-
-#include <crypto/ctr.h>
-#include <crypto/aes.h>
-#include <crypto/algapi.h>
-#include <crypto/scatterwalk.h>
-
-#include <crypto/hash.h>
-#include <crypto/md5.h>
-#include <crypto/sha1.h>
-#include <crypto/sha2.h>
-#include <crypto/internal/hash.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+#include <linux/string.h>
 
 #define _SBF(s, v)			((v) << (s))
 
-- 
2.39.5

