Received: from mail-m49197.qiye.163.com (mail-m49197.qiye.163.com [45.254.49.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E615292911;
	Fri, 23 May 2025 13:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.254.49.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748007069; cv=none; b=CT0iM8PNz1nvXWfz7LB32r/tzYEqKYIACNb9qs5trvak1C2vKdRP61Wy7nqVjKJjM4cMNyVtxTp8EyVqG6EgJEVdDC0U4MIm7gC/Vgd8vM133tPPx41cE5VRo/GOW7wQMVvZdRnOB4YswwEZkdQiAS0xg3isqARgQ78lu3ubrT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748007069; c=relaxed/simple;
	bh=nnZRK8lPl9SyiDMJbFJSArxBQ5vkLzLDfP3ZLzu1lVA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=sRmjUcUz11X3JvjPlC81VWQBOA+cdqMgdA5YL7kDPVA9hjBrpAkjt6Cu3CdoFrF448jNe80kHBEO9xrFx2+5kFIrP/XNP3kvfFDaMQs56ue9apWpTVd449hfu8SedwIL+ImAQ97OyX3y4aenxvIX0SK+3guBc0ZAdF4dzt60Q7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn; spf=pass smtp.mailfrom=seu.edu.cn; dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b=ON1CM0cs; arc=none smtp.client-ip=45.254.49.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b="ON1CM0cs"
Received: from localhost.localdomain (unknown [202.119.23.198])
	by smtp.qiye.163.com (Hmail) with ESMTP id 163121437;
	Fri, 23 May 2025 21:31:00 +0800 (GMT+08:00)
From: Zilin Guan <zilin@seu.edu.cn>
To: qianweili@huawei.com
Cc: wangzhou1@hisilicon.com,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	jianhao.xu@seu.edu.cn,
	Zilin Guan <zilin@seu.edu.cn>
Subject: [PATCH] crypto: hisilicon: use kfree_sensitive() for pool cleanup
Date: Fri, 23 May 2025 13:30:57 +0000
Message-Id: <20250523133057.4025075-1-zilin@seu.edu.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWS1ZQUlXWQ8JGhUIEh9ZQVlDQ00YVk4ZTk9KT00aTU4fGFYeHw5VEwETFhoSFy
	QUDg9ZV1kYEgtZQVlJS0lVSkpCVUlIVUpCQ1lXWRYaDxIVHRRZQVlPS0hVSktISk9ITFVKS0tVSk
	JLS1kG
X-HM-Tid: 0a96fd57027f03a1kunmd10b84c92accc8
X-HM-MType: 10
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MTo6Lio6HzEzDBRLFksCAxdW
	TBQKFD5VSlVKTE9DS0tMS01KSU9MVTMWGhIXVQESFxIVOwgeDlUeHw5VGBVFWVdZEgtZQVlJS0lV
	SkpCVUlIVUpCQ1lXWQgBWUFKTU5ONwY+
DKIM-Signature:a=rsa-sha256;
	b=ON1CM0csT+ZFX3d7Kk/uaRI+fOv7MXWaytkLpuV5P8aebPyPD7jwwfd4ubE7b66Xe0zEBFHQauhTwOtJYUJkIA/k0/0AkbtBsz1xRT9x0OWKNIRT3exZoXvz6Eq+LZn7WczLoD3+g28B77e0ZVpX5gwZVRUPtmuXZIIzhamwvMY=; s=default; c=relaxed/relaxed; d=seu.edu.cn; v=1;
	bh=jRFn8bu4n2o4gj3EMfZ9WV2kRTdw4d7yf31Z8DlFERQ=;
	h=date:mime-version:subject:message-id:from;

The error path of hisi_acc_create_sgl_pool() already calls
kfree_sensitive() to wipe sensitive data before freeing the pool.
However, hisi_acc_free_sgl_pool() currently uses plain kfree(), which
may leave secrets behind in memory and undo the protection applied
during creation.

This patch replaces kfree() with kfree_sensitive() in
hisi_acc_free_sgl_pool(), ensuring that all SGL pool deallocations
securely clear their contents.

Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
---
 drivers/crypto/hisilicon/sgl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/hisilicon/sgl.c b/drivers/crypto/hisilicon/sgl.c
index c974f95cd126..6a88a2056708 100644
--- a/drivers/crypto/hisilicon/sgl.c
+++ b/drivers/crypto/hisilicon/sgl.c
@@ -151,7 +151,7 @@ void hisi_acc_free_sgl_pool(struct device *dev, struct hisi_acc_sgl_pool *pool)
 		dma_free_coherent(dev, block[i].size, block[i].sgl,
 				  block[i].sgl_dma);
 
-	kfree(pool);
+	kfree_sensitive(pool);
 }
 EXPORT_SYMBOL_GPL(hisi_acc_free_sgl_pool);
 
-- 
2.34.1

