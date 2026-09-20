Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B53D23F3294;
	Sun, 20 Sep 2026 17:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789925713; cv=none; b=eiipn8Rk4MonPYHyc05qdO/yUeqWFlnJoLb8PL/uuaL3MCSerVAJQp6zK2POaxKSRmGVDC7yBps7NraQWPRS3dUhGSUvPGFa/fU/w9NEt9GE52XaRETk17iEnJKuQt5FZ+r8UPy1SA1i9WeP9CDZBy7KcPynYhWbrASiOKGwCYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789925713; c=relaxed/simple;
	bh=wt+p7+WQEsrvlkB/TpcfB2WkiZ92vYltSUJNr8v53PI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=HN9BCPdXKt42JJSjX2z2NTptlKUzpGPXXygKOQhWtH6XCuMwNzykMCl/1ixvt6ZLAlOqdjHjez5ZWOUpyRXbuMMl6YaqB/rpXNLQS2kwIJPjfMEXi9xBMfAH55gEMDQbYy3rvi8fGSEHoet4OoHAmhOC0z2Izy9xiI9zLhB2Myw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=BAjf7WeU; arc=none smtp.client-ip=220.197.31.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="BAjf7WeU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=VY
	vFOMxp088J7Z5nKkTATrjH/03iFcG1KN3su6kNDBI=; b=BAjf7WeUzlvVRaHdMF
	UujxKKSjV3bnciFpTDw7yMIJvu3qy0B059K90ffYm3keBFeGamYRcIdYn6eMc0Rc
	XR/2hQ3/Mz9GHP+XUVaTGSDZgJKhzq3p4bVfESD+v2UMwY2afvaXVSjGcAhrcEbs
	0jh7yUtqdhpKNrdccP4wX8Lck=
Received: from pc.localdomain (unknown [])
	by gzga-smtp-mtada-g0-3 (Coremail) with SMTP id _____wD3n1saGbBqhwquBw--.7793S2;
	Mon, 21 Sep 2026 01:34:19 +0800 (CST)
From: Jiale Yao <yaojiale02@163.com>
To: Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Gary R Hook <gary.hook@amd.com>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Jiale Yao <yaojiale02@163.com>
Subject: [PATCH] crypto: ccp: kill v5 IRQ tasklet during teardown
Date: Mon, 21 Sep 2026 01:34:17 +0800
Message-Id: <20260920173417.2126346-1-yaojiale02@163.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3n1saGbBqhwquBw--.7793S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7tF13Xw1ktFWxXF1rAFWkJFb_yoW8JFWUpa
	9rJayUur95Jr4DGay8Z3WUWryrXFnak345KrWjqw1Svwn8ZFWFgry7Cr42k3WUtFykZFy2
	qFWj9F4rCw1kJ3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pRkpnkUUUUU=
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbCzhsTTWqwGRv1YAAA3G

On PCI devices using MSI-X, ccp5_irq_handler() schedules irq_tasklet.
The teardown paths release the IRQ but do not drain a tasklet that was
already queued, so it can access ccp after the device-managed allocation
has been released.

Kill the tasklet after releasing the IRQ in both the initialization
error path and ccp5_destroy().

Fixes: 6263b51eb319 ("crypto: ccp - Change ISR handler method for a v5 CCP")

Signed-off-by: Jiale Yao <yaojiale02@163.com>
---
 drivers/crypto/ccp/ccp-dev-v5.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/crypto/ccp/ccp-dev-v5.c b/drivers/crypto/ccp/ccp-dev-v5.c
index 7b73332d6aa1..4235be5df546 100644
--- a/drivers/crypto/ccp/ccp-dev-v5.c
+++ b/drivers/crypto/ccp/ccp-dev-v5.c
@@ -995,6 +995,8 @@ static int ccp5_init(struct ccp_device *ccp)
 
 e_irq:
 	sp_free_ccp_irq(ccp->sp, ccp);
+	if (ccp->use_tasklet)
+		tasklet_kill(&ccp->irq_tasklet);
 
 e_pool:
 	for (i = 0; i < ccp->cmd_q_count; i++)
@@ -1046,6 +1048,8 @@ static void ccp5_destroy(struct ccp_device *ccp)
 			kthread_stop(ccp->cmd_q[i].kthread);
 
 	sp_free_ccp_irq(ccp->sp, ccp);
+	if (ccp->use_tasklet)
+		tasklet_kill(&ccp->irq_tasklet);
 
 	/* Flush the cmd and backlog queue */
 	while (!list_empty(&ccp->cmd)) {
-- 
2.34.1

