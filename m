Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=101.204.27.37
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795592794;
	b=YmSG/36i4zZJFdXBOGEqv/UC51yTgbQRVhdAhbQFowZ/DzzU4Nb9Bi6JAg/DLPMepQSp
	 SOlXaGN5AFn0bLkr1NT7JFLZ9E61MOZtXgqOV974U2DUwY8sPyWN4sKE3rLNpyoWj35rg
	 D5osp/H3rmO0kCCSpfluEs0Pb6AcbAHHaiZtUSHIEbyDWssd3LLR6me4hZSfrCdpZminJ
	 NZSdbpUQwNsfnQiooGvQKTmYy/fdhQ4ZBXda4A+jpCsp107MDbALm6q/KdQ2y7w+x6bx4
	 GfMuowH6ckOpfriBXzf5CHdeyVtPhRQ33/IKTxGAThQuzIgys5CC0tU0w0TGACAguUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795592794;
	h=DMARC-Filter:Received:Received:Received:Received:From:To:CC:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-ClientProxiedBy;
	bh=76O/tVzdUg4Z726gYEpRRnJU+7SxQzbjaHJxix1TuzA=;
	b=BV0fYccv9Bj8hZqYg7a1Tw0PUvFPND5ZRgdfOk3DSVekVmVey4iXvzp3dSPlBhDanbCJ
	 R/lxVnMgHO2yYHqO2gSU0/yf0iWHAl+eGODx4DXNQPu0teOJPv42FJ9NosKJeFU+Dy67l
	 2VFA06jnGZ9yi/hMYSkZSscBWwNSyQMixoLwBchVXw7DWkESDhPW+WTE80o96KT4GDSjE
	 AIvsK7TnIW0riFRbWvpjpElKz2/VssZST86AzvB6zLX5FewgPST7pIJn6pMqzbydBBR23
	 p2B8rooYEajBipmID8Cq93dmG0RixdB7M8Pe6KG+FR+cFnv5nhWsDSYgl2IBlUuvarw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=hygon.cn;
	spf=pass smtp.mailfrom=hygon.cn;
	arc=none smtp.remote-ip=101.204.27.37
Received: from spam01.hygon.cn (unknown [101.204.27.37])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28D14606A323;
	Wed, 25 Nov 2026 07:46:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 28D14606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hygon.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hygon.cn
Received: from maildlp2.hygon.cn (unknown [127.0.0.1])
	by spam01.hygon.cn (Postfix) with ESMTP id 4jZBZc6F2DzVcB8;
	Wed, 25 Nov 2026 15:46:32 +0800 (CST)
Received: from maildlp2.hygon.cn (unknown [172.23.18.61])
	by spam01.hygon.cn (Postfix) with ESMTP id 4jZBZY6fQPzVcB6;
	Wed, 25 Nov 2026 15:46:29 +0800 (CST)
Received: from cncheex04.Hygon.cn (unknown [172.23.18.114])
	by maildlp2.hygon.cn (Postfix) with ESMTPS id 5AD24300B6F1;
	Wed, 25 Nov 2026 15:45:17 +0800 (CST)
Received: from hygon.hygon.cn (172.25.24.133) by cncheex04.Hygon.cn
 (172.23.18.114) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Wed, 25 Nov
 2026 15:46:29 +0800
From: Depei Yang <yangdepei@hygon.cn>
To: <linux-crypto@vger.kernel.org>
CC: Tom Lendacky <thomas.lendacky@amd.com>, Herbert Xu
	<herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, Gary
 R Hook <gary.hook@amd.com>, <linux-kernel@vger.kernel.org>, Depei Yang
	<yangdepei@hygon.cn>, Shan Chen <chenshan@hygon.cn>, Yongwei Xu
	<xuyongwei@hygon.cn>, Xiaochen Shen <shenxiaochen@hygon.cn>,
	<stable@vger.kernel.org>
Subject: [PATCH 02/11] crypto: ccp - acknowledge queue interrupt before waking waiter
Date: Wed, 25 Nov 2026 15:46:00 +0800
Message-ID: <f8c36f6a347c032835910d3c8b448d770d720965.1795588986.git.yangdepei@hygon.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1795588986.git.yangdepei@hygon.cn>
References: <cover.1795588986.git.yangdepei@hygon.cn>
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
Content-Type: text/plain
X-ClientProxiedBy: cncheex05.Hygon.cn (172.23.18.115) To cncheex04.Hygon.cn
 (172.23.18.114)

ccp5_irq_bh() and ccp_irq_bh() set int_rcvd before writing the interrupt
status back to the device.  A waiting queue thread can then start the
next command before the previous completion has been acknowledged; the
stale write-back clears the new completion bit as well, and the thread
waits for an interrupt that will never be raised again.  The wait has no
timeout, so the queue stays stuck.

Acknowledge the interrupt before making int_rcvd visible.  The v5 handler
was observed to wedge a queue thread under concurrent crypto load; the
v3 handler uses the same ordering and gets the same treatment.

Fixes: 4b394a232df7 ("crypto: ccp - Let a v5 CCP provide the same function as v3")
Fixes: 63b945091a07 ("crypto: ccp - CCP device driver and interface support")
Cc: stable@vger.kernel.org
Reviewed-by: Shan Chen <chenshan@hygon.cn>
Tested-by: Yongwei Xu <xuyongwei@hygon.cn>
Signed-off-by: Depei Yang <yangdepei@hygon.cn>
---
 drivers/crypto/ccp/ccp-dev-v3.c | 9 ++++++---
 drivers/crypto/ccp/ccp-dev-v5.c | 9 ++++++---
 2 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-dev-v3.c b/drivers/crypto/ccp/ccp-dev-v3.c
index d92de4ad31ac..02f7575e8f9b 100644
--- a/drivers/crypto/ccp/ccp-dev-v3.c
+++ b/drivers/crypto/ccp/ccp-dev-v3.c
@@ -343,10 +343,13 @@ static void ccp_irq_bh(unsigned long data)
 			if ((q_int & cmd_q->int_err) && !cmd_q->cmd_error)
 				cmd_q->cmd_error = CMD_Q_ERROR(cmd_q->q_status);
 
-			cmd_q->int_rcvd = 1;
-
-			/* Acknowledge the interrupt and wake the kthread */
+			/*
+			 * Acknowledge the interrupt before waking the kthread,
+			 * otherwise a fast waiter can start a new command while
+			 * the old interrupt is still pending.
+			 */
 			iowrite32(q_int, ccp->io_regs + IRQ_STATUS_REG);
+			cmd_q->int_rcvd = 1;
 			wake_up_interruptible(&cmd_q->int_queue);
 		}
 	}
diff --git a/drivers/crypto/ccp/ccp-dev-v5.c b/drivers/crypto/ccp/ccp-dev-v5.c
index 4a546224af79..bf76743845e3 100644
--- a/drivers/crypto/ccp/ccp-dev-v5.c
+++ b/drivers/crypto/ccp/ccp-dev-v5.c
@@ -754,10 +754,13 @@ static void ccp5_irq_bh(unsigned long data)
 			if ((status & INT_ERROR) && !cmd_q->cmd_error)
 				cmd_q->cmd_error = CMD_Q_ERROR(cmd_q->q_status);
 
-			cmd_q->int_rcvd = 1;
-
-			/* Acknowledge the interrupt and wake the kthread */
+			/*
+			 * Acknowledge the interrupt before waking the kthread,
+			 * otherwise a fast waiter can start a new command while
+			 * the old interrupt is still pending.
+			 */
 			iowrite32(status, cmd_q->reg_interrupt_status);
+			cmd_q->int_rcvd = 1;
 			wake_up_interruptible(&cmd_q->int_queue);
 		}
 	}
-- 
2.34.1


