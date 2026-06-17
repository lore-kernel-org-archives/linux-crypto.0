Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2F1F23D283;
	Wed, 17 Jun 2026 01:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781660222; cv=none; b=dxL5j+dcL2jGhOWu1zpGhqnZ+P1loeSID3S8I9tUcKlXXW4326jQIshn+kn0SElRfhWxm7uq8IKxY9lEabdeexUOGg2u8Wq6811abAO2ESXtsE711gx4545BOmbj8ROCNxDum1AaBLApnK+usbscEBdI8/cgX9TkSTMbC5qKdJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781660222; c=relaxed/simple;
	bh=mw/OtSnbMMwexT2Ic93EBcQd638ZeumIWXoRN2HvoZA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=qQzK/SlgSH8au7+tr2ZAlCAQoRjXC0EjV+AQ13iCKEAXM4KLbTvl9d9pm/EsI2zWY17Z1EuXJmR/Ei3JEl9d1p4pSi5rAIzvn/md8d7Q7uLv+c8ab7Txa08khN/IoY49LrYf4CFthr4Kt5tpVDVcEoXvY76pdnOXQPj6k0kBatY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 0521d58c69ed11f1aa26b74ffac11d73-20260617
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:72959fdd-7258-4545-b045-0856459128eb,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:e7bac3a,CLOUDID:e1a0612af1ac5ce65c5af018cbfae19f,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:102|850|865|898,TC:nil,Content:0|15|50,E
	DM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA
	:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 0521d58c69ed11f1aa26b74ffac11d73-20260617
X-User: zenghongling@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <zenghongling@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1545579859; Wed, 17 Jun 2026 09:36:53 +0800
From: Hongling Zeng <zenghongling@kylinos.cn>
To: t-pratham@ti.com,
	herbert@gondor.apana.org.au,
	davem@davemloft.net
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhongling0719@126.com,
	Hongling Zeng <zenghongling@kylinos.cn>
Subject: [PATCH v2] =?UTF-8?q?crypto:=20ti-dthev2=EF=BC=9AFix=20potential?= =?UTF-8?q?=20invalid=20access=20when=20device=20list=20is=20empty?=
Date: Wed, 17 Jun 2026 09:36:48 +0800
Message-Id: <20260617013648.514148-1-zenghongling@kylinos.cn>
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
 drivers/crypto/ti/dthev2-common.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/ti/dthev2-common.c b/drivers/crypto/ti/dthev2-common.c
index a2ad79bec105..9480b32b8111 100644
--- a/drivers/crypto/ti/dthev2-common.c
+++ b/drivers/crypto/ti/dthev2-common.c
@@ -40,7 +40,7 @@ struct dthe_data *dthe_get_dev(struct dthe_tfm_ctx *ctx)
 		return ctx->dev_data;
 
 	spin_lock_bh(&dthe_dev_list.lock);
-	dev_data = list_first_entry(&dthe_dev_list.dev_list, struct dthe_data, list);
+	dev_data = list_first_entry_or_null(&dthe_dev_list.dev_list, struct dthe_data, list);
 	if (dev_data)
 		list_move_tail(&dev_data->list, &dthe_dev_list.dev_list);
 	spin_unlock_bh(&dthe_dev_list.lock);
@@ -201,12 +201,12 @@ static void dthe_remove(struct platform_device *pdev)
 {
 	struct dthe_data *dev_data = platform_get_drvdata(pdev);
 
-	spin_lock(&dthe_dev_list.lock);
-	list_del(&dev_data->list);
-	spin_unlock(&dthe_dev_list.lock);
-
 	dthe_unregister_algs();
 
+        spin_lock(&dthe_dev_list.lock);
+        list_del(&dev_data->list);
+        spin_unlock(&dthe_dev_list.lock);
+
 	crypto_engine_exit(dev_data->engine);
 
 	dma_release_channel(dev_data->dma_aes_rx);
-- 
2.25.1

