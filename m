Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F66B35E92F;
	Mon,  7 Sep 2026 02:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788748739; cv=none; b=gCz29+XQGiyH8dqYqFxxd2uMjEguoQQvO+re49LvcR9pnVD4WbxrzqNUnq7W94nXwB/l4ko+OvUGv+z3/+9QuE8By/G7l8mLT2cSTqgBfjBkqTFugp2ZL+WUenH+RAqwinBOCxMpzUSVJd6NuXdOTXPdh7irMmsM7bk6YbwEBOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788748739; c=relaxed/simple;
	bh=JUQeAXAC/pf1NwAEgV2vOt7veD4II3XQYnqXn35JEMM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dKxOswKtOemDpYVRpnivSX4wbqXtFxg7fb+7tDDfANjDvCYf/k0DVRSDZbWirXksef5si0BmQdYNq5JNGdkJRnvQSpJj4MGcujbWsxX/+ynSsLAkJ1Smdv/zLbwvIIMItwUe5oV8rjJA5DaDb5wEOWLzevF7FOeJRrJyztasX8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=QRQu4JgB; arc=none smtp.client-ip=220.197.31.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="QRQu4JgB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=Xz
	KQqR9KbJqy9j/mmb6X8TPwQ2Kyu4YH9tYGiOuD1dY=; b=QRQu4JgBn1ykFPjbrn
	NGJCYGEnNFYTvPYeusdRHzD8F/GUCP1Ow3jXjehh2zvrQ7hZf29ISW2fbkVXlo4j
	vNQYTi78dgyDfm/S9OQJ+PCnlF3PXGZRUIgYr4mb5yntt7aEmsiHjEeSHdDV+wW/
	Von/62DKWIIzec7Zj6qSJ3fro=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-0 (Coremail) with SMTP id _____wD399KkI55qynlmBA--.44662S3;
	Mon, 07 Sep 2026 10:38:30 +0800 (CST)
From: Qunqin Zhao <zhaoqunqin@163.com>
To: lee@kernel.org
Cc: chenhuacai@kernel.org,
	linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-crypto@vger.kernel.org,
	mfd@lists.linux.dev,
	Qunqin Zhao <zhaoqunqin@loongson.cn>
Subject: [PATCH v6 1/2] mfd: loongson-se: Add multi-node support
Date: Mon,  7 Sep 2026 10:38:26 +0800
Message-Id: <20260907023827.14905-2-zhaoqunqin@163.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260907023827.14905-1-zhaoqunqin@163.com>
References: <20260907023827.14905-1-zhaoqunqin@163.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD399KkI55qynlmBA--.44662S3
X-Coremail-Antispam: 1Uf129KBjvJXoW7Kr45Jr4DZFWUJFW5AF1xAFb_yoW8ZFW3pF
	45GayYvr4j9a1Fkw1DZa4DCr15AFWSq39xCanrJF47Aas8Jwn3GrWfJFy2qFs3CFW8Xay8
	XrZ5GFWrCFW8WF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jATmhUUUUU=
X-CM-SenderInfo: 52kd01pxqtx0i6rwjhhfrp/xtbC7gY0c2qeI6Z2OAAA3Q

From: Qunqin Zhao <zhaoqunqin@loongson.cn>

On the Loongson platform, each node is equipped with a security engine
device. However, due to a hardware flaw, only the device on node 0 can
trigger interrupts. Therefore, interrupts from other nodes are forwarded
by node 0. We need to check in the interrupt handler of node 0 whether
this interrupt is intended for other nodes, this can be accomplished via
shared interrupt handling.

Signed-off-by: Qunqin Zhao <zhaoqunqin@loongson.cn>
---
 drivers/mfd/loongson-se.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/loongson-se.c b/drivers/mfd/loongson-se.c
index 3902ba377..7f552a8ee 100644
--- a/drivers/mfd/loongson-se.c
+++ b/drivers/mfd/loongson-se.c
@@ -140,6 +140,11 @@ static irqreturn_t se_irq_handler(int irq, void *dev_id)
 
 	int_status = readl(se->base + SE_S2LINT_STAT);
 
+	if (int_status == 0) {
+		spin_unlock(&se->dev_lock);
+		return IRQ_NONE;
+	}
+
 	/* For controller */
 	if (int_status & SE_INT_CONTROLLER) {
 		complete(&se->cmd_completion);
@@ -211,24 +216,26 @@ static int loongson_se_probe(struct platform_device *pdev)
 	if (IS_ERR(se->base))
 		return PTR_ERR(se->base);
 
-	writel(SE_INT_ALL, se->base + SE_S2LINT_EN);
-
 	nr_irq = platform_irq_count(pdev);
 	if (nr_irq <= 0)
 		return -ENODEV;
 
+	writel(SE_INT_ALL, se->base + SE_S2LINT_CL);
+
 	for (i = 0; i < nr_irq; i++) {
 		irq = platform_get_irq(pdev, i);
-		err = devm_request_irq(dev, irq, se_irq_handler, 0, "loongson-se", se);
+		err = devm_request_irq(dev, irq, se_irq_handler, IRQF_SHARED, "loongson-se", se);
 		if (err)
 			dev_err(dev, "failed to request IRQ: %d\n", irq);
 	}
 
+	writel(SE_INT_ALL, se->base + SE_S2LINT_EN);
+
 	err = loongson_se_init(se, paddr, se->dmam_size);
 	if (err)
 		return err;
 
-	return devm_mfd_add_devices(dev, PLATFORM_DEVID_NONE, engines,
+	return devm_mfd_add_devices(dev, PLATFORM_DEVID_AUTO, engines,
 				    ARRAY_SIZE(engines), NULL, 0, NULL);
 }
 
-- 
2.47.2

