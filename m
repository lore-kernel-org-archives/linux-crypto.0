Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2C38404BF9;
	Wed, 23 Sep 2026 08:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790153325; cv=none; b=VMUyzPBmjI4XsJ4ophWCZRq7CXpKixUV1O9gooWhRHcz0tU+rxL+nynWO22VOPNB9AbPyleOvitNh1EEJkY80Umi8RfCANZ4CzllQYD+6wH7t5WoQ912EjpwTSzlPCkh2kv4a4P0UeUDqr+xMlgj2JlGVnEBOqVC/DphbCUsBr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790153325; c=relaxed/simple;
	bh=JUQeAXAC/pf1NwAEgV2vOt7veD4II3XQYnqXn35JEMM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DLe7iwMxCJNtcZKpgCg4zylHTl5hJZhJC+2v5YIrixGGse0ZZLfEFHWVNq3QAHIeUNU/N5gyr4aY30t58AzEeMUt0dGm1lBKYgJLcibo7GCE2IKaOLKaKxZpnUT6gMOalk0SUWCbs6uZ/PGDySF6+faTcAsB9U0gnKAI1ejbVek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=ia0grihV; arc=none smtp.client-ip=220.197.31.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="ia0grihV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=Xz
	KQqR9KbJqy9j/mmb6X8TPwQ2Kyu4YH9tYGiOuD1dY=; b=ia0grihVWNJ+4KbUEb
	KehGsqLfGmT3KO01fTvuhWc/jNn8LOnxmPRwcUWS7pDf4qsQNhxOBEUfLR1ouqI2
	WOE+l37RDT+EZIIR0KyLc+jjgiFVdiQpb0hNEaeZ5z0rPsIsRUCMXA7UCAEnK23E
	2deVHcSoNT1pBn0fkDJOEZyFA=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-1 (Coremail) with SMTP id _____wDXHyRIkrNqfwQ4AQ--.22208S3;
	Wed, 23 Sep 2026 16:48:12 +0800 (CST)
From: Qunqin Zhao <zhaoqunqin@163.com>
To: lee@kernel.org,
	zhaoqunqin@loongson.cn
Cc: chenhuacai@kernel.org,
	linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-crypto@vger.kernel.org,
	mfd@lists.linux.dev
Subject: [PATCH v8 1/2] mfd: loongson-se: Add multi-node support
Date: Wed, 23 Sep 2026 16:48:01 +0800
Message-Id: <20260923084802.29508-2-zhaoqunqin@163.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260923084802.29508-1-zhaoqunqin@163.com>
References: <20260923084802.29508-1-zhaoqunqin@163.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDXHyRIkrNqfwQ4AQ--.22208S3
X-Coremail-Antispam: 1Uf129KBjvJXoW7Kr45Jr4DZFWUJFW5AF1xAFb_yoW8ZFW3pF
	45GayYvr4j9a1Fkw1DZa4DCr15AFWSq39xCanrJF47Aas8Jwn3GrWfJFy2qFs3CFW8Xay8
	XrZ5GFWrCFW8WF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jLjjgUUUUU=
X-CM-SenderInfo: 52kd01pxqtx0i6rwjhhfrp/xtbCxQ0-fmqzkk38UAAA3j

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

