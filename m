Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6C4D32B99F;
	Sun, 20 Sep 2026 17:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789925712; cv=none; b=NQK5KCCZiBz0AliIWlPL1jrvZo+jOwIdakjZGBdaLHCGMr55cdM2uuAWWxni/GGireUKaWew96pXyZRTFYzYcRxJmuCmMr2muKp/0vn4MnMVEu5bpeNOVVvQsCwAXVPMC5gkUFQOGjo+79hSy9fFmYgeKP70qFzygkqRIf8LELo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789925712; c=relaxed/simple;
	bh=IwyhlzKM7E1TdkYYSkn+MUUWrQCv4aFpAQ11SCCarXA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Ae0J2iCxaqY8iBkQEdz2y/woXcH3XYk+woyqemGMoX/19Avc8dRJTdD0DfV3kxb3E5oHjSJ6Mk/I9IU6VFutXZhp6THlgSS6YupJoV4e1wNVLVckdZlQe2qUazECbdsyc0Hkqg15ooaJWMcGoDArbyxgd+o0oG80ufErGFI0NyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=KHJtR8IK; arc=none smtp.client-ip=117.135.210.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="KHJtR8IK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=Zw
	aAKrIS0ew4+gSlj3A8kCDnKECw35Tg8rz0r8uQPSo=; b=KHJtR8IKuegskfGw5Q
	5cBhKBrVb5HeEiMYC9qjGFK47Djb8cDBbsXmXcBsDPNs+3ezH6yG4PJO9rOBFyhV
	xThsb5KK1WZDJI0dpvxQBZR8zyVUoiXCIkBEV46LZ8xeoRWyD1eG60mOMTjAyfYZ
	hDPcI6IQMl/BAjLIG1NmM4LbE=
Received: from pc.localdomain (unknown [])
	by gzga-smtp-mtada-g1-4 (Coremail) with SMTP id _____wAnYJMRGbBqrWMRCA--.15098S2;
	Mon, 21 Sep 2026 01:34:09 +0800 (CST)
From: Jiale Yao <yaojiale02@163.com>
To: Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Gary R Hook <gary.hook@amd.com>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Jiale Yao <yaojiale02@163.com>
Subject: [PATCH] crypto: ccp: kill v3 IRQ tasklet during teardown
Date: Mon, 21 Sep 2026 01:34:07 +0800
Message-Id: <20260920173407.2126086-1-yaojiale02@163.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wAnYJMRGbBqrWMRCA--.15098S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7tF13Xw1ktFWxXr4Dur1rWFg_yoW8Gr13pa
	9rA3yjkry8JFsrGaykA3WUG34FqFna934rKrWjgw1Svwn8ZFWFgrW7Cr42ka1UtF4kZFy2
	qFW29r1rC3WkJw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pRy5d_UUUUU=
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbCzhIRS2qwGRL00QAA3y

On PCI devices using MSI-X, ccp_irq_handler() schedules irq_tasklet. The
teardown paths release the IRQ but do not drain a tasklet that was
already queued, so it can access ccp after the device-managed allocation
has been released.

Kill the tasklet after releasing the IRQ in both the initialization
error path and ccp_destroy().

Fixes: 7b537b24e76a ("crypto: ccp - Change ISR handler method for a v3 CCP")

Signed-off-by: Jiale Yao <yaojiale02@163.com>
---
 drivers/crypto/ccp/ccp-dev-v3.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/crypto/ccp/ccp-dev-v3.c b/drivers/crypto/ccp/ccp-dev-v3.c
index fe69053b2394..e85b4ded417a 100644
--- a/drivers/crypto/ccp/ccp-dev-v3.c
+++ b/drivers/crypto/ccp/ccp-dev-v3.c
@@ -506,6 +506,8 @@ static int ccp_init(struct ccp_device *ccp)
 			kthread_stop(ccp->cmd_q[i].kthread);
 
 	sp_free_ccp_irq(ccp->sp, ccp);
+	if (ccp->use_tasklet)
+		tasklet_kill(&ccp->irq_tasklet);
 
 e_pool:
 	for (i = 0; i < ccp->cmd_q_count; i++)
@@ -545,6 +547,8 @@ static void ccp_destroy(struct ccp_device *ccp)
 			kthread_stop(ccp->cmd_q[i].kthread);
 
 	sp_free_ccp_irq(ccp->sp, ccp);
+	if (ccp->use_tasklet)
+		tasklet_kill(&ccp->irq_tasklet);
 
 	for (i = 0; i < ccp->cmd_q_count; i++)
 		dma_pool_destroy(ccp->cmd_q[i].dma_pool);
-- 
2.34.1

