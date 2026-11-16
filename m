Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=117.135.210.4
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794822830;
	b=br2A9P+l7K0Q9JBoYfTQDqKRKfFRezzVjIx9oXRZpOz/DBm2d5MYYM1Er8iBsgh5zgvU
	 toZj0p9s3IJ5L/IREsgWlMs9nZtiqXukv8P66RuVZdOuoq7TLOgA0WNyCnDhG+OEMk/ib
	 Hzw3NwnLa7IGBA2/88aLrTjOmWe+56LqirE9xovMEZv7JvRkYeO1okgZ8acfIsIEUOQkA
	 3aXrcscbnSOz47vhC+Ucb9Wteo75aHURgW9wkk4lQhohRno3vHfnSgq2j0xEpFDSvAVUA
	 chJAlcTARquyEq3JOnNGBkUaQHuMky7vWYc+YcwctGF+5//Fb5v1YXsMz4Mklq7VTYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794822830;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-CM-TRANSID:X-Coremail-Antispam:X-CM-SenderInfo;
	bh=thQ5tIrrwD7SqIdDlbUJwnmSGJ/4IF6F6XNTPstz/Ko=;
	b=o+bYPz+6cbrTKwrpp8fQoQxu6yIhgoL/QKtI+Vhm8TpSgagmVovbAbafXZxIxbHpE/ti
	 7FiIxb1kZuWeVcfh6RwZMKB3SQeAbe+1y7QgVWSVHEg3StKCZi/Ypk7+fdHEZz79ynwW9
	 DzwrH0VXnQhR3rlCjfbBtoye8j8wD4BXO3MWjo5Ls9XLxyJuOCnYf6/SLgftSUP2DViOi
	 CC2mVEYCqwpcLU9jUi+lTl4ZEK/97TQERGDmHTCSvh3Y8uVIEyPG3/GMosCv8m5J8bOO/
	 8zWzSklpqsF52jJFCNwRYJaUxykSQHsJMBletDcC7kDTP4Tn3VOjg9mcJfcY6AO0RPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=163.com;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=RFqcgEaR;
	arc=none smtp.remote-ip=117.135.210.4
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D0CD606A31C;
	Mon, 16 Nov 2026 09:53:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3D0CD606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=RFqcgEaR
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=th
	Q5tIrrwD7SqIdDlbUJwnmSGJ/4IF6F6XNTPstz/Ko=; b=RFqcgEaRkSibPW+DBu
	JvUhIPEM5y4bCxqOiIkyZ/eE8LPdLcK8VFIQ9OtZ4VboFLYHJZFiNVO5+nl/S6hr
	brJkpZilItrYMQRcbUtlRO3LL6qThIIB5PY+27qpBl0gV9ZmvDSHJZdFW7TuSRxu
	DqVE/DQ4osfO4mrRXCY8xcwbk=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-2 (Coremail) with SMTP id _____wBXMyCS0vpqu8TwHw--.57709S2;
	Mon, 16 Nov 2026 17:53:23 +0800 (CST)
From: Qunqin Zhao <zhaoqunqin@163.com>
To: lee@kernel.org
Cc: chenhuacai@kernel.org,
	linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-crypto@vger.kernel.org,
	mfd@lists.linux.dev,
	Qunqin Zhao <zhaoqunqin@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH v10] mfd: loongson-se: Add multi-node support
Date: Mon, 16 Nov 2026 17:53:07 +0800
Message-Id: <20261116095307.21990-1-zhaoqunqin@163.com>
X-Mailer: git-send-email 2.20.1
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wBXMyCS0vpqu8TwHw--.57709S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Kr45Jr4DZFWUJFW5Jw45GFg_yoW8tw1kpa
	98Wa90yr4jkr1F9wn8ZayvkFy3Z3yft3y3C39rJw47A3s8twn5ury3JFyjgr1fCFWrJa1U
	XrWFkF48uFW8uF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UpOJrUUUUU=
X-CM-SenderInfo: 52kd01pxqtx0i6rwjhhfrp/xtbC7RMycWr60pN89gAA3m

From: Qunqin Zhao <zhaoqunqin@loongson.cn>

On the Loongson platform, each node is equipped with a security engine
device. However, due to a hardware flaw, only the device on node 0 can
trigger interrupts. Therefore, interrupts from other nodes are forwarded
by node 0. We need to check in the interrupt handler of node 0 whether
this interrupt is intended for other nodes, this can be accomplished via
shared interrupt handling.

Signed-off-by: Qunqin Zhao <zhaoqunqin@loongson.cn>
Reviewed-by: Huacai Chen <chenhuacai@loongson.cn>
---
v10: Rebase onto latest for-mfd-next
v9: Keep checks immediately after allocation calls
v6-v8: no changes
v5: Clear pending interrupts with S2LINT_CL before requesting IRQs,
    and move S2LINT_EN to after all interrupt handlers are registered.
v4: Safely handling shared interrupt handler returns.
v3: Using shared interrupts (IRQF_SHARED) instead of manually
    iterating through all devices to check for interrupts.

 drivers/mfd/loongson-se.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/loongson-se.c b/drivers/mfd/loongson-se.c
index 23af05d38..0c6274aa0 100644
--- a/drivers/mfd/loongson-se.c
+++ b/drivers/mfd/loongson-se.c
@@ -152,6 +152,10 @@ static irqreturn_t se_irq_handler(int irq, void *dev_id)
 	spin_lock(&se->dev_lock);
 
 	int_status = readl(se->base + SE_S2LINT_STAT);
+	if (int_status == 0) {
+		spin_unlock(&se->dev_lock);
+		return IRQ_NONE;
+	}
 
 	/* For controller */
 	if (int_status & SE_INT_CONTROLLER) {
@@ -278,7 +282,7 @@ static int loongson_se_probe(struct platform_device *pdev)
 		if (irq < 0)
 			return irq;
 
-		err = devm_request_irq(dev, irq, se_irq_handler, 0, "loongson-se", se);
+		err = devm_request_irq(dev, irq, se_irq_handler, IRQF_SHARED, "loongson-se", se);
 		if (err)
 			return dev_err_probe(dev, err, "Failed to request IRQ: %d\n", irq);
 	}
@@ -293,7 +297,7 @@ static int loongson_se_probe(struct platform_device *pdev)
 	if (err)
 		return err;
 
-	return devm_mfd_add_devices(dev, PLATFORM_DEVID_NONE, engines,
+	return devm_mfd_add_devices(dev, PLATFORM_DEVID_AUTO, engines,
 				    ARRAY_SIZE(engines), NULL, 0, NULL);
 }
 

base-commit: c92739a23a80f5f0a7c6f3c10aa792102d252ac4
-- 
2.47.2

