Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98F9A3CF695
	for <linux-crypto@vger.kernel.org>; Fri, 10 Jul 2026 07:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783669381; cv=none; b=CUUitt5NyP+X4ptdwftUHFP1nHzI+3FE2M+jv7me4BaJdeB0KS+pmC/8tzccoC9u+AsBkqe1GBK9nCoYgJzAYHWKJoTq0d282ZZDgGtDCLVGeB8xDA9MUgM6qNmG/AP5SFQD42tF+Tk/9ORAudoJ7j+A8t2R4dE2khVC9M+qm/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783669381; c=relaxed/simple;
	bh=Qih+LP3/egjYrLR7EBVMJajAdXN04WaqHWQ9otOcoB8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=htjmevG6zXCaleOvN6cZcYC6q8YJKkQdMGF/81vYnwWJp8SThwwhCu9ZyAbC87BZhV3JFbQDJG97uBDdSOVpwevB6GNwiV6c5NAwFkyz59qRwmei5E6PUJ9Vpyn/ikFSJELGBmBfsdTU3QmcRD8j+k89Dxejy2NM6Q1DFJ89ov0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Gr7NmQjx; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Gr7NmQjx"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783669367;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=c3e6oZbc6F773Qir26Sc0QNFGUCJZN+wEbH26HH5gZw=;
	b=Gr7NmQjxqvseruVX3aV9qclTAMbBP4n2z/NSk2XHQZGBb5Ud20Qfj7hXtsYTDys9kspgUM
	AXJzAUVXQ8d0e2XfOpf4aCCS4Z2rR5+LWBYpXGNn2Yhg09B3R4z29UCeooKrLPo+n68NN3
	YziHs9gwWqJ4ejxXKbh8QctRVVNSGCY=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Corentin Labbe <clabbe@baylibre.com>,
	Hans Ulli Kroll <ulli.kroll@googlemail.com>,
	Linus Walleij <linusw@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-arm-kernel@lists.infradead.org,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: sl3516 - drop invalid sg_dma_len checks before DMA mapping
Date: Fri, 10 Jul 2026 09:42:17 +0200
Message-ID: <20260710074216.734849-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1485; i=thorsten.blum@linux.dev; h=from:subject; bh=Qih+LP3/egjYrLR7EBVMJajAdXN04WaqHWQ9otOcoB8=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFkBiyJkW1f1nI9hfXkntCj45V7BbTE/ct01506vOe05+ /lWa8/LHaUsDGJcDLJiiiwPZv2Y4VtaU7nJJGInzBxWJpAhDFycAjCRFcmMDMu2+/sYnuP9PtXk I/eUsoZ5Ulf69llNOFbQ8WHOi1m7PwkwMrR1snAkGslWvxGeVsP88dahm3+X3llfF7ouR9ph+ps /0xkB
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

sg_dma_len() is only valid after mapping the scatterlist with
dma_map_sg(). However, sl3516_ce_need_fallback() checks it before the
source and destination scatterlists are mapped. Thus, a stale DMA length
that is not a multiple of 16 could incorrectly force a software fallback
when CONFIG_NEED_SG_DMA_LENGTH=y.

Remove the invalid checks; the existing scatterlist length checks are
sufficient.

Fixes: 46c5338db7bd ("crypto: sl3516 - Add sl3516 crypto engine")
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/crypto/gemini/sl3516-ce-cipher.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/crypto/gemini/sl3516-ce-cipher.c b/drivers/crypto/gemini/sl3516-ce-cipher.c
index 583010b2d007..02ec4282333b 100644
--- a/drivers/crypto/gemini/sl3516-ce-cipher.c
+++ b/drivers/crypto/gemini/sl3516-ce-cipher.c
@@ -56,10 +56,6 @@ static bool sl3516_ce_need_fallback(struct skcipher_request *areq)
 			ce->fallback_mod16++;
 			return true;
 		}
-		if ((sg_dma_len(sg) % 16) != 0) {
-			ce->fallback_mod16++;
-			return true;
-		}
 		if (!IS_ALIGNED(sg->offset, 16)) {
 			ce->fallback_align16++;
 			return true;
@@ -72,10 +68,6 @@ static bool sl3516_ce_need_fallback(struct skcipher_request *areq)
 			ce->fallback_mod16++;
 			return true;
 		}
-		if ((sg_dma_len(sg) % 16) != 0) {
-			ce->fallback_mod16++;
-			return true;
-		}
 		if (!IS_ALIGNED(sg->offset, 16)) {
 			ce->fallback_align16++;
 			return true;
