Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB5DA442389;
	Thu, 24 Sep 2026 09:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790240765; cv=none; b=o1k8Njf5LNpWiZwhe/IeZPxdC33mYBD6MH1nwV4RiGU+YIUuM/EPj8/+DQ0PXc2tLxy+cNNnPzfBVXZLWYKlVgGYQbGSJ+s7yw/TicvWXwjT3+/n6Dnm0RIhLUca5Y3BppXjo71GEAMvEHUJBMOf/BbZr4Fpr7m1fodTNuHejvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790240765; c=relaxed/simple;
	bh=eFECeLyDkbWzBkQVvwJoMcgBPRYqOL8szfGa49qfmBs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=WP/n94Z+I85OjIdGxB5XCGUoihoIv/vihqschh0RSdm3ls0LaxZTjRxouSdk0aZYhRtFHNJ+e7q4vu8YYereYCZuF6vqfeQ76VAN0bWTzxNtHP2b723ZHyRGt2WdLzJ1jKO8bFvMPDzKtUNvG+Uj85brMgjCycEH+e1DzuCN+xI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=T7szqF68; arc=none smtp.client-ip=117.135.210.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="T7szqF68"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=f3
	eIWvq8JseXKyO0v9+KOkbgd8+L+uJ1/rUfXrwV9h0=; b=T7szqF68yJZuZUg61X
	S1h5dAaPJL3WID0K3JY2N7iSyEZuSLeE8lzJ3wSRcNcn/y1fjF4RPClZEZe2ZrXl
	u18vqCZaP2JPE2QVp6yFf5vefnx9IyywUT1fk/uMjsd7LffrDsPCXhPEYRCOYkqY
	ZY/0iS74Ys9N4D8eih+4zYFxA=
Received: from pc.localdomain (unknown [])
	by gzga-smtp-mtada-g1-0 (Coremail) with SMTP id _____wD3H6Xj57RqnK4OAg--.46651S2;
	Thu, 24 Sep 2026 17:05:40 +0800 (CST)
From: Jiale Yao <yaojiale02@163.com>
To: Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Gary R Hook <gary.hook@amd.com>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Jiale Yao <yaojiale02@163.com>,
	stable@vger.kernel.org
Subject: [PATCH] crypto: ccp: drain v5 IRQ tasklet during teardown
Date: Thu, 24 Sep 2026 17:05:37 +0800
Message-Id: <20260924090537.173532-1-yaojiale02@163.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3H6Xj57RqnK4OAg--.46651S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Ww4kuw13JF1xtF43uF45ZFb_yoW8Aw4fpa
	9rGay5KryrJr429a97Zw1UW34rZFsak345Kr40qw1Svwn8uFWFgry7Cw47t3WjyFn5ZFy2
	qayj9FWrCr4kA3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pREeHhUUUUU=
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbCzQT6NWq05+TBRQAA3f

On PCI devices using MSI-X, ccp5_irq_handler() disables the queue
interrupts and schedules ccp->irq_tasklet. The tasklet calls
ccp5_irq_bh(), which accesses registers and wait queues through
ccp->cmd_q.

Both the ccp5_init() error path and ccp5_destroy() free the CCP IRQ
before the command queues and the device-managed ccp allocation are
released. sp_free_ccp_irq() prevents another hard IRQ and waits for an
in-flight handler, but it does not drain a tasklet that the handler
already scheduled. The tasklet can therefore access ccp->cmd_q after
its backing allocation has been released.

Kill the tasklet after sp_free_ccp_irq(), when no handler can schedule
it again, and before the command queues or ccp can be released. Check
ccp->use_tasklet because the tasklet is initialized only for MSI-X.

Fixes: 6263b51eb319 ("crypto: ccp - Change ISR handler method for a v5 CCP")
Cc: stable@vger.kernel.org
Signed-off-by: Jiale Yao <yaojiale02@163.com>
---
 drivers/crypto/ccp/ccp-dev-v5.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/crypto/ccp/ccp-dev-v5.c b/drivers/crypto/ccp/ccp-dev-v5.c
index dcd6aab51e47..dacde9614e8a 100644
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

