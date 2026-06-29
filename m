Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F4973CCA02;
	Mon, 29 Jun 2026 07:24:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782717890; cv=none; b=q7VYpFYGLuIRU35ERsNdaD5mtjKvr/QD5NzLc6V3pda1ZJy1JFTNlW4tO0wHNInwDLMvC1Tesm7fQKfIGhB6sGiKI+pmEtEEDa5k0DMcTobsgvbIkKAbRb7geKII8HaGvKQnojq4QEHuno8LpI3o3JmOdhpimAKGhgeHvtxHAN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782717890; c=relaxed/simple;
	bh=de8LDif55Fqz7zOA1XBNJhXlpAtdvJS1158BAzuFqPw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mmqdnxK32jN8yuflAgeEeNtCSA4hGom+MCg42K+H5efhk5UQN/IpHRgsYd7ppQTzru/fY1j86sBdCc/WeLVAcfV/xPNXTVu8VthsDHQzWMrTYriFlDAfKmWrWHMzwLC4n9Ka0Dd49Fc7Zbmho/TrkSlm/UmnBAxj+7vdFZRtvU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.40.54.123])
	by gateway (Coremail) with SMTP id _____8Cx9Oi9HUJqnRMZAA--.57941S3;
	Mon, 29 Jun 2026 15:24:45 +0800 (CST)
Received: from localhost.localdomain (unknown [10.40.54.123])
	by front1 (Coremail) with SMTP id qMiowJDxhcCxHUJqJl63AA--.61324S4;
	Mon, 29 Jun 2026 15:24:45 +0800 (CST)
From: Qunqin Zhao <zhaoqunqin@loongson.cn>
To: lee@kernel.org
Cc: chenhuacai@kernel.org,
	xry111@xry111.site,
	linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-crypto@vger.kernel.org,
	Qunqin Zhao <zhaoqunqin@loongson.cn>
Subject: [PATCH v4 2/2] mfd: loongson-se: Add multi-node support
Date: Mon, 29 Jun 2026 15:11:09 +0800
Message-ID: <20260629071109.7341-3-zhaoqunqin@loongson.cn>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20260629071109.7341-1-zhaoqunqin@loongson.cn>
References: <20260629071109.7341-1-zhaoqunqin@loongson.cn>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJDxhcCxHUJqJl63AA--.61324S4
X-CM-SenderInfo: 52kd01pxqtx0o6or00hjvr0hdfq/
X-Coremail-Antispam: 1Uk129KBj93XoW7urW8tFW7Zw48Jr4fAry7Arc_yoW8AF18pF
	WDuayY9F4UuF10kwn8Za1DWF1YyFWft39xGanrXw47Aas8JwnxXFy3tFy2gr4fCFy8Xayj
	qrWrKFWruFW8uFcCm3ZEXasCq-sJn29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUk2b4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r126r13M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
	xVW8Jr0_Cr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2x26I8E6xACxx
	1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1q6rW5McIj6I8E87Iv
	67AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41l42xK82IYc2
	Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s02
	6x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0x
	vE2Ix0cI8IcVAFwI0_JFI_Gr1lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE
	42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6x
	kF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUco7KUUUUU

On the Loongson platform, each node is equipped with a security engine
device. However, due to a hardware flaw, only the device on node 0 can
trigger interrupts. Therefore, interrupts from other nodes are forwarded
by node 0. We need to check in the interrupt handler of node 0 whether
this interrupt is intended for other nodes, this can be accomplished via
shared interrupt handling.

Signed-off-by: Qunqin Zhao <zhaoqunqin@loongson.cn>
---
 drivers/mfd/loongson-se.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/loongson-se.c b/drivers/mfd/loongson-se.c
index aa34e663c4..2f296faa97 100644
--- a/drivers/mfd/loongson-se.c
+++ b/drivers/mfd/loongson-se.c
@@ -142,6 +142,11 @@ static irqreturn_t se_irq_handler(int irq, void *dev_id)
 
 	int_status = readl(se->base + SE_S2LINT_STAT);
 
+	if (int_status == 0) {
+		spin_unlock(&se->dev_lock);
+		return IRQ_NONE;
+	}
+
 	/* For controller */
 	if (int_status & SE_INT_CONTROLLER) {
 		complete(&se->cmd_completion);
@@ -222,7 +227,7 @@ static int loongson_se_probe(struct platform_device *pdev)
 
 	for (i = 0; i < nr_irq; i++) {
 		irq = platform_get_irq(pdev, i);
-		err = devm_request_irq(dev, irq, se_irq_handler, 0, "loongson-se", se);
+		err = devm_request_irq(dev, irq, se_irq_handler, IRQF_SHARED, "loongson-se", se);
 		if (err) {
 			dev_err(dev, "failed to request IRQ: %d\n", irq);
 			return err;
@@ -233,7 +238,7 @@ static int loongson_se_probe(struct platform_device *pdev)
 	if (err)
 		return err;
 
-	return devm_mfd_add_devices(dev, PLATFORM_DEVID_NONE, engines,
+	return devm_mfd_add_devices(dev, PLATFORM_DEVID_AUTO, engines,
 				    ARRAY_SIZE(engines), NULL, 0, NULL);
 }
 
-- 
2.47.2

