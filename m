Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A12283C9EDD;
	Tue,  4 Aug 2026 07:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785828893; cv=none; b=XLn0etJYkkfIB+WHJ5C7AxPMpjfLI4kk8BLJGmL8FAPOxv8WYII0ALbx/5XUJvKWuQNYXtgX5N4Kd7k4WDR1WFPM7Jag6tFLeCrdMo5TUbq/urPssZQ26absZrWGCLsODQJoA5tw/snxb28pZ/WFNZCkhbHQTbmhch2GUFBRy9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785828893; c=relaxed/simple;
	bh=lS6llJtx2WNSvkKvNtHJDT58jhvVkatxpbQbuG2LJXk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=rVbtFyIsVyQ1mBnnh/Z8x1pQnTzAGtgIgfARoSPhjMmHgmC6EhcTq9ktM3W1QDKPOK9UCO6qPRBPfK7fV0poi0HqH5U7IsZYOPIgjk/yhcSPhXLus7fNI9Dhw2m6HCNETX/01smUQrRiOo1oHB6ohtf+p8s87Zu8yU6CUy+xbCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: f66f958c8fd611f1aa26b74ffac11d73-20260804
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:efd29c2f-41c8-4d5b-8a28-b55c08630832,IP:0,U
	RL:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:25
X-CID-META: VersionHash:e7bac3a,CLOUDID:1713f53fb8613302519a73dfc8f4b0fc,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:102|850|865|898,TC:nil,Content:0|15|50,E
	DM:5,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:
	0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: f66f958c8fd611f1aa26b74ffac11d73-20260804
X-User: xiaopei01@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <xiaopei01@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1042760798; Tue, 04 Aug 2026 15:34:44 +0800
From: Pei Xiao <xiaopei01@kylinos.cn>
To: hadar.gat@arm.com,
	olivia@selenic.com,
	herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Pei Xiao <xiaopei01@kylinos.cn>
Subject: [PATCH] hwrng: cctrng: Fix use-after-free in cctrng_remove due to race condition
Date: Tue,  4 Aug 2026 15:34:41 +0800
Message-Id: <c77fad0623ba0f152490dc14d4029debd789915e.1785828765.git.xiaopei01@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In cctrng_probe, &drvdata->compwork is bound with
cc_trng_compwork_handler, and &drvdata->startwork is bound with
cc_trng_startwork_handler. cc_isr can schedule compwork on system_wq
when an RNG interrupt is received, and cctrng_read can schedule
startwork on system_wq when the data buffer needs refilling.

If we remove the device, cctrng_remove makes cleanup and the memory
allocated for drvdata with devm_kzalloc() is released by the devm
cleanup after the remove callback returns, while the works mentioned
above may still be pending or running. The sequence of operations that
may lead to a UAF bug is as follows:

CPU0                                      CPU1

                                          | cc_isr
                                          | schedule_work(&drvdata->compwork)
cctrng_remove                             |
cc_trng_pm_fini(drvdata)                  |
// remove returns                         |
// devm cleanup: free_irq,                |
// kfree(drvdata)                         |
                                          | cc_trng_compwork_handler
                                          | // use drvdata (use-after-free)

Fix it by masking the RNG interrupts, so the IRQ handler cannot
schedule new work, and canceling the works before the remaining
cleanup in cctrng_remove and the devm release of drvdata.

Fixes: a583ed310bb6 ("hwrng: cctrng - introduce Arm CryptoCell driver")
Assisted-by: Codex:deepseek-v4-flash
Signed-off-by: Pei Xiao <xiaopei01@kylinos.cn>
---
 drivers/char/hw_random/cctrng.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/char/hw_random/cctrng.c b/drivers/char/hw_random/cctrng.c
index a6925211c3b5..dd41f2d1fee5 100644
--- a/drivers/char/hw_random/cctrng.c
+++ b/drivers/char/hw_random/cctrng.c
@@ -568,6 +568,12 @@ static void cctrng_remove(struct platform_device *pdev)
 
 	cc_trng_pm_fini(drvdata);
 
+	/* Mask RNG interrupts so cc_isr cannot schedule new work */
+	cc_iowrite(drvdata, CC_RNG_IMR_REG_OFFSET, 0xFFFFFFFF);
+
+	cancel_work_sync(&drvdata->compwork);
+	cancel_work_sync(&drvdata->startwork);
+
 	dev_info(dev, "ARM cctrng device terminated\n");
 }
 
-- 
2.25.1

