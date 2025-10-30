Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFF812E1EE7
	for <linux-crypto@vger.kernel.org>; Thu, 30 Oct 2025 16:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761842004; cv=none; b=rY5Mu+i4Du8ko2mAA7/GJclhtX+LAa9Fv0hjGM9E7PBh3YwQq6FIkd7MnL0Db60aWojxvXuqwcqU3N+H4yOLIgZhlgEOmAvIxBTrCMr7fpxPv3eaKTbIakFanWuFnIK1Cg98WW9lVvDjdTInDhx6nnF1KzvhtZa9GSySHPDFpAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761842004; c=relaxed/simple;
	bh=vLBR6Kx4k+b1x4sLzlaXYmvVJTw9xYzTAsSR1fmgiec=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=G7pWYfgSaQUD6yU/yJ95gKZK6qntBnG54saxJtzCmH94eleji41aXEIxhtTlUmyeentwJCxKvppbg8oabPgFjb86c+8xkPSeMdY7jtiZyB+J8jsQsPiS72a5nP6+v9kGiTnl3M3Q/r++ihpPFoMWjike1lve/RH9LPwSGv2tiBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=X7JBABGp; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="X7JBABGp"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761841991;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=AYElKPO+b0NDxX27xQpPlTgEKkzpFH6cCIUwLw9wU84=;
	b=X7JBABGpae2pBGOE0yb6zwHFiJ2mOygYBHF0qo+jHyuipwvnv0e9wwby81j4bjKEAg67hx
	MQHYBu+GnjsKhoenJvSIhXtA67gmY1qaEsFoGXLMdo2AQ9uRhEG3E8p7qAj0vqRqU+sOj2
	EdDk80vVy2LfOyamC8CejvmaIoIv4TM=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: deflate - Use struct_size to improve deflate_alloc_stream
Date: Thu, 30 Oct 2025 17:32:17 +0100
Message-ID: <20251030163218.497730-1-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Use struct_size(), which provides additional compile-time checks for
structures with flexible array members (e.g., __must_be_array()), to
calculate the allocation size for a new 'deflate_stream'.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 crypto/deflate.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/crypto/deflate.c b/crypto/deflate.c
index 21404515dc77..a3e1fff55661 100644
--- a/crypto/deflate.c
+++ b/crypto/deflate.c
@@ -15,6 +15,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
+#include <linux/overflow.h>
 #include <linux/percpu.h>
 #include <linux/scatterlist.h>
 #include <linux/slab.h>
@@ -39,7 +40,7 @@ static void *deflate_alloc_stream(void)
 						     DEFLATE_DEF_MEMLEVEL));
 	struct deflate_stream *ctx;
 
-	ctx = kvmalloc(sizeof(*ctx) + size, GFP_KERNEL);
+	ctx = kvmalloc(struct_size(ctx, workspace, size), GFP_KERNEL);
 	if (!ctx)
 		return ERR_PTR(-ENOMEM);
 
-- 
2.51.0

