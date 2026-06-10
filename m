Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AAAB38A29A;
	Wed, 10 Jun 2026 07:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781075941; cv=none; b=qRls+61hz445bEL+AUX19IBRv4Z32hLg5xVI3Vf8U6x1gQhT2MeY/Py+818U/wvimTDoOBkm3hYL/xU05aUNCihJ2T6FUPTuOA3vZ/Wa8xsJwA+3r2JykyOy54qJrEqhuZ9LwY4UplWi5Z7bJc3r6MNTWfuTvM3Q+g5i/1ZdilA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781075941; c=relaxed/simple;
	bh=KabWLugESkcH2GuNNe6giO1ysnlLsWK4c6X3vJq4dUM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=i2+bds9nMKnfIa2qYurb457NcbqzgO0A+voEA8TogXu7mzWsdpGhuJ3gDXXuxMtlRv2eOfeqwHr+1cNYLZUo80JlPMkn6ZphO9h6azpomMgbf30fbPQMQBz5N38HVVNH/8Dl3nJAThqkRFXTpiUfi2/dXBcDmPuR3P5nB2iPTow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.40.54.15])
	by gateway (Coremail) with SMTP id _____8CxHurZDylqkpQSAA--.48571S3;
	Wed, 10 Jun 2026 15:18:49 +0800 (CST)
Received: from localhost.localdomain (unknown [10.40.54.15])
	by front1 (Coremail) with SMTP id qMiowJDxaeDWDylqL62hAA--.45694S2;
	Wed, 10 Jun 2026 15:18:47 +0800 (CST)
From: Qunqin Zhao <zhaoqunqin@loongson.cn>
To: lee@kernel.org
Cc: chenhuacai@kernel.org,
	xry111@xry111.site,
	linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-crypto@vger.kernel.org,
	Qunqin Zhao <zhaoqunqin@loongson.cn>
Subject: [PATCH v3] mfd: loongson-se: Add multi-node support
Date: Wed, 10 Jun 2026 23:13:54 +0800
Message-Id: <20260610151354.32617-1-zhaoqunqin@loongson.cn>
X-Mailer: git-send-email 2.20.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJDxaeDWDylqL62hAA--.45694S2
X-CM-SenderInfo: 52kd01pxqtx0o6or00hjvr0hdfq/
X-Coremail-Antispam: 1Uk129KBj93XoW7urW8tFW7Zw48Jr4fGF1fKrX_yoW8Ar1DpF
	4UWa4qkr4UG3W0kw1DZa1DuF1YyayYq3y3GanFqw47Aas8tw1kZFy3tFW7WF43AFW8XayU
	ZrZYgF48uFW8uFcCm3ZEXasCq-sJn29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUvSb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M280x2IEY4vEnII2IxkI6r1a6r45M28lY4IE
	w2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84
	ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1l84ACjcxK6I8E87Iv67AKxVWxJVW8Jr1l
	84ACjcxK6I8E87Iv6xkF7I0E14v26r4UJVWxJr1le2I262IYc4CY6c8Ij28IcVAaY2xG8w
	AqjxCEc2xF0cIa020Ex4CE44I27wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8I
	cVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjc
	xG0xvY0x0EwIxGrwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s02
	6c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF
	0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvE
	c7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14
	v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7I
	U0Jku3UUUUU==

On the Loongson platform, each node is equipped with a security engine
device. However, due to a hardware flaw, only the device on node 0 can
trigger interrupts. Therefore, interrupts from other nodes are forwarded
by node 0. We need to check in the interrupt handler of node 0 whether
this interrupt is intended for other nodes, this can be accomplished via
shared interrupt handling.

Signed-off-by: Qunqin Zhao <zhaoqunqin@loongson.cn>
---
V3: 
Using shared interrupts (IRQF_SHARED) instead of manually
iterating through all devices to check for interrupts.

Link to v2:
https://lore.kernel.org/all/20260427165133.23350-1-zhaoqunqin@loongson.cn/

 drivers/mfd/loongson-se.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/loongson-se.c b/drivers/mfd/loongson-se.c
index 3902ba377d6..e63ea40d5db 100644
--- a/drivers/mfd/loongson-se.c
+++ b/drivers/mfd/loongson-se.c
@@ -219,7 +219,7 @@ static int loongson_se_probe(struct platform_device *pdev)
 
 	for (i = 0; i < nr_irq; i++) {
 		irq = platform_get_irq(pdev, i);
-		err = devm_request_irq(dev, irq, se_irq_handler, 0, "loongson-se", se);
+		err = devm_request_irq(dev, irq, se_irq_handler, IRQF_SHARED, "loongson-se", se);
 		if (err)
 			dev_err(dev, "failed to request IRQ: %d\n", irq);
 	}
@@ -228,7 +228,7 @@ static int loongson_se_probe(struct platform_device *pdev)
 	if (err)
 		return err;
 
-	return devm_mfd_add_devices(dev, PLATFORM_DEVID_NONE, engines,
+	return devm_mfd_add_devices(dev, PLATFORM_DEVID_AUTO, engines,
 				    ARRAY_SIZE(engines), NULL, 0, NULL);
 }
 

base-commit: 254f49634ee16a731174d2ae34bc50bd5f45e731
-- 
2.47.2

