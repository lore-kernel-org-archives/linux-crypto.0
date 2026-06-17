Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 156F638F64C;
	Wed, 17 Jun 2026 06:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781678043; cv=none; b=f6y+0ve3iMk2hGURcM7iG75xWG15BMHtlVawXdb/NvXF9/27E97l94zYbzksjlyZ50q74GcCKuvPXvQfB93thYVomZMOz0U0/IOxJbhiY2SQF3uvI9qjp7xrdm0gHokNDaAVlx4HePOfVNaUoXk2i215BbPDIT/44kXwvvx9Elc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781678043; c=relaxed/simple;
	bh=YqQWb0F4Xet77kSVUyHaOkHTLT2fuvf1fFmz7MllaTY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=uP4ixZYVU2jU4r9TtgWUCTgcg5bYmNVfp9mngA+c8B8zUKCXsrYAx3GUc50dPvK49xhkgzLvuFBtwaBe0RjDtnhA8dyA22DHaXsi42GDikqcVB0EaEn2WlQc0ezHVPS0GRyFNCak78oRUVQZrbAVWvBqyR9LonwE3Pf2E+7g7SE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 82530f0c6a1611f1aa26b74ffac11d73-20260617
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:7209977a-848f-4aad-b6bc-6097fcc0b48d,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:e7bac3a,CLOUDID:b7e09ff7e95d555e30f8e9d4af9377ae,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:102|850|865|898,TC:nil,Content:0|15|50,E
	DM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA
	:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 82530f0c6a1611f1aa26b74ffac11d73-20260617
X-User: zenghongling@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <zenghongling@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1714997179; Wed, 17 Jun 2026 14:33:53 +0800
From: Hongling Zeng <zenghongling@kylinos.cn>
To: t-pratham@ti.com,
	herbert@gondor.apana.org.au,
	davem@davemloft.net
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhongling0719@126.com,
	Hongling Zeng <zenghongling@kylinos.cn>
Subject: [PATCH v3] =?UTF-8?q?crypto:=20ti-dthev2=EF=BC=9AFix=20potential?= =?UTF-8?q?=20invalid=20access=20when=20device=20list=20is=20empty?=
Date: Wed, 17 Jun 2026 14:33:47 +0800
Message-Id: <20260617063347.674064-1-zenghongling@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

list_first_entry() never returns NULL - if the list is empty, it still
returns a pointer to an invalid object, leading to potential invalid
memory access when dereferenced.

Fix this by using list_first_entry_or_null instead of list_first_entry.

Fixes: 52f641bc63a4 ("crypto: ti - Add driver for DTHE V2 AES Engine (ECB, CBC)")
Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>

---
Change in v2
 -Reorder dthe_remove(): unregister algorithms before removing from list
  This prevents new allocations during removal.
---
Change in v3
 -Fix spinlock inconsistency:dthe_get_dev() uses spin_lock_bh() while
  dthe_probe() and dthe_remove() use spin_lock(). This can cause deadlock
  if softirq interrupts process context holding the lock.
---
 drivers/crypto/ti/dthev2-common.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/ti/dthev2-common.c b/drivers/crypto/ti/dthev2-common.c
index a2ad79bec105..b315c850f05d 100644
--- a/drivers/crypto/ti/dthev2-common.c
+++ b/drivers/crypto/ti/dthev2-common.c
@@ -39,11 +39,11 @@ struct dthe_data *dthe_get_dev(struct dthe_tfm_ctx *ctx)
 	if (ctx->dev_data)
 		return ctx->dev_data;
 
-	spin_lock_bh(&dthe_dev_list.lock);
-	dev_data = list_first_entry(&dthe_dev_list.dev_list, struct dthe_data, list);
+	spin_lock(&dthe_dev_list.lock);
+	dev_data = list_first_entry_or_null(&dthe_dev_list.dev_list, struct dthe_data, list);
 	if (dev_data)
 		list_move_tail(&dev_data->list, &dthe_dev_list.dev_list);
-	spin_unlock_bh(&dthe_dev_list.lock);
+	spin_unlock(&dthe_dev_list.lock);
 
 	return dev_data;
 }
@@ -201,12 +201,12 @@ static void dthe_remove(struct platform_device *pdev)
 {
 	struct dthe_data *dev_data = platform_get_drvdata(pdev);
 
+	dthe_unregister_algs();
+
 	spin_lock(&dthe_dev_list.lock);
 	list_del(&dev_data->list);
 	spin_unlock(&dthe_dev_list.lock);
 
-	dthe_unregister_algs();
-
 	crypto_engine_exit(dev_data->engine);
 
 	dma_release_channel(dev_data->dma_aes_rx);
-- 
2.25.1

