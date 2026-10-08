Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85A22429CD6;
	Thu,  8 Oct 2026 07:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791444764; cv=none; b=iJb/g+KOhI+195lbjLizcW+wKpcgiDH2RbXqgIgu+eU/5qOd9qd/7710eVUvTjlK+aNrc417PrzPh0481wtoa27hP0IcB8G4U7Xft/4mBl3crlGtE2JeVcCZnVLgwnUym804ZlON2oBNWDW3jQXjI3oJDRrhy7lmHhAUAg3Hf1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791444764; c=relaxed/simple;
	bh=/zdqDkp+MR4muNmPlebN8/G/pEFyOL6VDyJAsQ+89jk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=sIW1PODPH9WG58FA3/zbd8lW4eQVZ6Qr4lmLNyIUvrkPEEewT/kc0+rlAJUFA0+eKvGJ/r4VJlCzkcijyIVwz9d64YOxYCTVEK48Gw5PQRmyn26zLIPe/LIYhrGcDM8f9+fjQXKGvDDkqNpSeuCUj2bn280uRwDXYEpB6ECXEGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=RIPiK8mW; arc=none smtp.client-ip=117.135.210.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="RIPiK8mW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=2W
	mrGmbVz8iXt7vLLO/9uShFkQKub27VoiEbcOyNMm4=; b=RIPiK8mW5gZWNcYdrG
	NEYWtCcXD/q5a1ZQpKz48xcYzpIV5hnQwgkuzzZFiyLA1zh3NFh2N9r4s3G9UFhe
	HXnL5U/iJzYRWJ5NT666jusWC1m31/E3oTv8jVc7nDG0N7TG8AB2nKzbPU/ngTdJ
	kz4v9PJQjwtqxlKZp2F1ugZ9U=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-1 (Coremail) with SMTP id _____wD3v07tRsdqtq9hDA--.12178S3;
	Thu, 08 Oct 2026 15:32:02 +0800 (CST)
From: Qunqin Zhao <zhaoqunqin@163.com>
To: lee@kernel.org,
	zhaoqunqin@loongson.cn
Cc: chenhuacai@kernel.org,
	linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-crypto@vger.kernel.org,
	mfd@lists.linux.dev,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH v9 1/2] mfd: loongson-se: Add multi-node support
Date: Thu,  8 Oct 2026 15:31:50 +0800
Message-Id: <20261008073151.15808-2-zhaoqunqin@163.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20261008073151.15808-1-zhaoqunqin@163.com>
References: <20261008073151.15808-1-zhaoqunqin@163.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3v07tRsdqtq9hDA--.12178S3
X-Coremail-Antispam: 1Uf129KBjvJXoW7Kr45Jr4DZFWUJFW5AF1xAFb_yoW8ur4xpF
	45CayYvr4UWw48uw1DZa4DCr15AFWFq39xCanrJw47Aas8Jwn3WrWfJFy2qFs8CFW8Xay8
	ZrZ5CFW8CFy8uF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jnID7UUUUU=
X-CM-SenderInfo: 52kd01pxqtx0i6rwjhhfrp/xtbC7hJamWrHRvKhqwAA3s

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
 drivers/mfd/loongson-se.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/loongson-se.c b/drivers/mfd/loongson-se.c
index 3902ba377..969378518 100644
--- a/drivers/mfd/loongson-se.c
+++ b/drivers/mfd/loongson-se.c
@@ -139,6 +139,10 @@ static irqreturn_t se_irq_handler(int irq, void *dev_id)
 	spin_lock(&se->dev_lock);
 
 	int_status = readl(se->base + SE_S2LINT_STAT);
+	if (int_status == 0) {
+		spin_unlock(&se->dev_lock);
+		return IRQ_NONE;
+	}
 
 	/* For controller */
 	if (int_status & SE_INT_CONTROLLER) {
@@ -211,24 +215,26 @@ static int loongson_se_probe(struct platform_device *pdev)
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

