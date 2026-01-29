Received: from mail-m49197.qiye.163.com (mail-m49197.qiye.163.com [45.254.49.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D02531BBBFC;
	Thu, 29 Jan 2026 15:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.254.49.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769699427; cv=none; b=rBsCpE+62BHNLz+KU+e7/oi5a+mHkN+Ak7V1Op33Xt3MEr8kHSf1TyZ9z1fHZjOFmjLKqmgetN8cKd1hsZx2QwhxQDZJrjB4+xTWb/seKcHRKacgsACs2qZ+v3+A2Ex35q7c/2Yt35vgEyafwumxdhRw+UVTuUJYXbTW26b4tN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769699427; c=relaxed/simple;
	bh=XtXkRDHKKsTeLbFxtIGZK4ZRMM1Oxlr7XSMAIvHfcpM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=IZua9K1Y5xh8RJd/LG5FoRd/0temzfNOmECDdHS3iJKSo1J07ikGsrnr57teRY4jWkVwxHc6DP7FXomLuq0CUx9zMlPZ1jTcQTt/2dNWIzCN3OPLCQ4+H28h2cvGKhELSyYHr6JV7kNcvCyO7ng8Mocq76bidsIg0pWpS6YPwo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn; spf=pass smtp.mailfrom=seu.edu.cn; dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b=EyY1k/JG; arc=none smtp.client-ip=45.254.49.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b="EyY1k/JG"
Received: from LAPTOP-N070L597.localdomain (unknown [221.228.238.82])
	by smtp.qiye.163.com (Hmail) with ESMTP id 3271fc4f2;
	Thu, 29 Jan 2026 23:10:18 +0800 (GMT+08:00)
From: Zilin Guan <zilin@seu.edu.cn>
To: jiajie.ho@starfivetech.com
Cc: william.qiu@starfivetech.com,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Zilin Guan <zilin@seu.edu.cn>
Subject: [PATCH] crypto: starfive - Fix memory leak in starfive_aes_aead_do_one_req()
Date: Thu, 29 Jan 2026 15:10:16 +0000
Message-Id: <20260129151016.1131652-1-zilin@seu.edu.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9c0a4e1f3003a1kunmabac713311ccb5
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWS1ZQUlXWQ8JGhUIEh9ZQVlCSU4fVk1OHhkfSk5DGB4aTFYeHw5VEwETFhoSFy
	QUDg9ZV1kYEgtZQVlJSUpVSUlDVUlIQ1VDSVlXWRYaDxIVHRRZQVlPS0hVSktJSE5DQ1VKS0tVS1
	kG
DKIM-Signature: a=rsa-sha256;
	b=EyY1k/JGfTkmtfHE5Ae5AMNsVExoteLglK6owtneDnH+X4rfWX8pPxHvZY1omxldhR7UjVS5iznWcog+LADdmo+OdQNUOSIMAAirO+KNUCRTCZKF9GM1iGiux1dT5KVg3y8jVJT2VoUSdxNWH8y7LGD4FpglfVi3AA2aWHyusrM=; s=default; c=relaxed/relaxed; d=seu.edu.cn; v=1;
	bh=ekVmTo2Lncyaa4qMnxFSFUH+yw6zK90Gs3zIwYdWG9c=;
	h=date:mime-version:subject:message-id:from;

The starfive_aes_aead_do_one_req() function allocates rctx->adata with
kzalloc() but fails to free it if sg_copy_to_buffer() or
starfive_aes_hw_init() fails, which lead to memory leaks.

Since rctx->adata is unconditionally freed after the write_adata
operations, ensure consistent cleanup by freeing the allocation in these
earlier error paths as well.

Compile tested only. Issue found using a prototype static analysis tool
and code review.

Fixes: 7467147ef9bf ("crypto: starfive - Use dma for aes requests")
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
---
 drivers/crypto/starfive/jh7110-aes.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/starfive/jh7110-aes.c b/drivers/crypto/starfive/jh7110-aes.c
index 426b24889af8..01195664cc7c 100644
--- a/drivers/crypto/starfive/jh7110-aes.c
+++ b/drivers/crypto/starfive/jh7110-aes.c
@@ -669,8 +669,10 @@ static int starfive_aes_aead_do_one_req(struct crypto_engine *engine, void *areq
 			return -ENOMEM;
 
 		if (sg_copy_to_buffer(req->src, sg_nents_for_len(req->src, cryp->assoclen),
-				      rctx->adata, cryp->assoclen) != cryp->assoclen)
+				      rctx->adata, cryp->assoclen) != cryp->assoclen) {
+			kfree(rctx->adata);
 			return -EINVAL;
+		}
 	}
 
 	if (cryp->total_in)
@@ -681,8 +683,11 @@ static int starfive_aes_aead_do_one_req(struct crypto_engine *engine, void *areq
 	ctx->rctx = rctx;
 
 	ret = starfive_aes_hw_init(ctx);
-	if (ret)
+	if (ret) {
+		if (cryp->assoclen)
+			kfree(rctx->adata);
 		return ret;
+	}
 
 	if (!cryp->assoclen)
 		goto write_text;
-- 
2.34.1

