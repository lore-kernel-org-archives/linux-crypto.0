Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3B4D3D34B1;
	Thu, 30 Jul 2026 08:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785400858; cv=none; b=AKf/Q5O+kVdZscdi9nCNpUK97IUwFRdFHZlw7kU0pyYI9XpXlSg7b22Oah8uWtQ17jASL2VtDyfMQ17zmyjyaLt9uL5uUhLd9vuiDc1GVU3nkiDyVJJd4Al/XeDnsnkM3NaZD9+KiVedhoQY+knNJabhJWM5OdUMdoOmPASzc3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785400858; c=relaxed/simple;
	bh=XGTlOfzF7DyhR/Rv4Q3DHwH6S+2hOm7D81mRHW045Sc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=svnUjTcOGJGl2/oAcCg9ytV03baHeO6F+4yGgYaWuKEGfASAAoz5VztboCqPG6rYpR7wgiOk9+KsGdaE2WoVur5oD9qOETVuWN6ix1FGMN2l36YERlQshK3eqyrALRoeO5RQRt/9+ltWoq1nuFXv97+Y7tZrJDEyBYhAuw20xRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.40.54.123])
	by gateway (Coremail) with SMTP id _____8Axx+oWDmtqFs0IAA--.30081S3;
	Thu, 30 Jul 2026 16:40:54 +0800 (CST)
Received: from localhost.localdomain (unknown [10.40.54.123])
	by front1 (Coremail) with SMTP id qMiowJAxTsUNDmtqc50dAA--.27500S3;
	Thu, 30 Jul 2026 16:40:54 +0800 (CST)
From: Qunqin Zhao <zhaoqunqin@loongson.cn>
To: lee@kernel.org
Cc: chenhuacai@kernel.org,
	linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-crypto@vger.kernel.org,
	Qunqin Zhao <zhaoqunqin@loongson.cn>
Subject: [PATCH v5 1/2] mfd: loongson-se: Add multi-node support
Date: Thu, 30 Jul 2026 16:26:07 +0800
Message-ID: <20260730082608.1929-2-zhaoqunqin@loongson.cn>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20260730082608.1929-1-zhaoqunqin@loongson.cn>
References: <20260730082608.1929-1-zhaoqunqin@loongson.cn>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJAxTsUNDmtqc50dAA--.27500S3
X-CM-SenderInfo: 52kd01pxqtx0o6or00hjvr0hdfq/
X-Coremail-Antispam: 1Uk129KBj93XoW7urW8tFW7Zw48Jr4fAry7Arc_yoW8ZF1Dpa
	15GayYvr4Uua1Fkw1DZa4DCF15AFWft3y3CwsrJa17Aas8Jwn3GrW3JFy2qFs5CFW8Xay8
	XrZ5GF4ruFW8WFcCm3ZEXasCq-sJn29KB7ZKAUJUUUU5529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUkFb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r106r15M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6r4UJVWxJr1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2xF0cIa020Ex4CE44I27w
	Aqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_JF0_Jw1lYx0Ex4A2jsIE
	14v26r4j6F4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwCF04k20xvY0x
	0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E
	7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcV
	C0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF
	04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r4j6F4UMIIF0xvEx4A2jsIEc7
	CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07jY38nUUUUU=

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
index 3902ba377d..7f552a8ee6 100644
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
2.47.3

