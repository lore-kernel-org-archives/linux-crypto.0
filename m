Received: from mail-m155101.qiye.163.com (mail-m155101.qiye.163.com [101.71.155.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86E723AB5DC;
	Fri,  9 Oct 2026 03:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.71.155.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791516729; cv=none; b=UUO2dqM9KTehsNdI1RWFUyhn9AQ5+i8l7WNP5Lneuhx3r4uvJ5ZgXzB4y75AtQxt5a6WUYdnpQJVU9xLgV/oRZlt0pvK+gd/piPmLOCenmKnPIkTjxTGEpbRELg0sfv7pm7yoO6QRxgFnGbydUygS2ZpSKV4xFoUn/rmNq8c0xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791516729; c=relaxed/simple;
	bh=DJdBDREzG7h7vTup7WhoYyl/QMwzRMYkrocwbln5h/Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ahdC4KvYm0s9XrO5eMPsfZpD84Bp0G1wInrcSooMw1aE4sqeGc9gvp/HS59p5ecK+8s2/GjG5zH8dJyhSVsFI+LQFBMLgCQX8cTdudPiR7gPVu8k31g3e1UHCTcZ68OduedoZqT3gct9toLfLOy8ptNkDKWuGRIkdsXBsyouZJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn; spf=pass smtp.mailfrom=seu.edu.cn; dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b=dLPMMMJw; arc=none smtp.client-ip=101.71.155.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b="dLPMMMJw"
Received: from PC-202605011814.localdomain (unknown [223.112.146.162])
	by smtp.qiye.163.com (Hmail) with ESMTP id 50622dd9c;
	Fri, 9 Oct 2026 11:31:55 +0800 (GMT+08:00)
From: Runyu Xiao <runyu.xiao@seu.edu.cn>
To: Christian Marangi <ansuelsmth@gmail.com>
Cc: Antoine Tenart <atenart@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Jianhao Xu <jianhao.xu@seu.edu.cn>
Subject: [PATCH v2] crypto: inside-secure: initialize EIP93 state before requesting IRQ
Date: Fri,  9 Oct 2026 11:31:49 +0800
Message-Id: <20261009033149.1127441-1-runyu.xiao@seu.edu.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <asXl69ABi0_1ZKIJ@gondor.apana.org.au>
References: <asXl69ABi0_1ZKIJ@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa11eb7aa1e03a1kunmf0a94a55431ab9
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkZSU5IVh0eShhJTR0dSU8dGlYeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlJSUhVSkpJVUpPTVVKTUlZV1kWGg8SFR0UWUFZT0tIVUJCSU
	5LVUpLS1VKQktCWQY+
DKIM-Signature: a=rsa-sha256;
	b=dLPMMMJwVRjlnu86nmy5mGbxVwus/Ry5hal25mIpLf69CCgtpEYBHOQRDele3PgMtxnsMiRfpe0Rfc5DkltwT8652i881XhXE3dRTu22kKQ1Unab4sAYClROZh3j/apEI+lVeqa3WbdG4dgMd8hNQgnU6VRK1dBUEiFm4rAifzI=; c=relaxed/relaxed; s=default; d=seu.edu.cn; v=1;
	bh=56dcQkmnI7815PCgex3ip24CJMUdwzNIUdqUHZX90Dk=;
	h=date:mime-version:subject:message-id:from;

devm_request_threaded_irq() can invoke the handler as soon as registration
starts. Initialize EIP93 state before requesting it and leave device
interrupts disabled until registration succeeds.

If IRQ registration fails after the hardware and rings are initialized,
call eip93_cleanup() before returning. This shuts down the engine and
clears the ring registers before devres releases the DMA rings.

Fixes: 9739f5f93b78 ("crypto: eip93 - Add Inside Secure SafeXcel EIP-93 crypto engine support")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
---
Changes in v2:
- Call eip93_cleanup() if IRQ registration fails after device initialization.

 drivers/crypto/inside-secure/eip93/eip93-main.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/inside-secure/eip93/eip93-main.c b/drivers/crypto/inside-secure/eip93/eip93-main.c
index e62785952b..52b5fb1ffc 100644
--- a/drivers/crypto/inside-secure/eip93/eip93-main.c
+++ b/drivers/crypto/inside-secure/eip93/eip93-main.c
@@ -430,12 +430,6 @@ static int eip93_crypto_probe(struct platform_device *pdev)
 	if (eip93->irq < 0)
 		return eip93->irq;
 
-	ret = devm_request_threaded_irq(eip93->dev, eip93->irq, eip93_irq_handler,
-					NULL, IRQF_ONESHOT,
-					dev_name(eip93->dev), eip93);
-	if (ret)
-		return ret;
-
 	ret = eip93_desc_init(eip93);
 	if (ret)
 		return ret;
@@ -452,6 +446,14 @@ static int eip93_crypto_probe(struct platform_device *pdev)
 
 	eip93_initialize(eip93, algo_flags);
 
+	ret = devm_request_threaded_irq(eip93->dev, eip93->irq, eip93_irq_handler,
+					NULL, IRQF_ONESHOT,
+					dev_name(eip93->dev), eip93);
+	if (ret) {
+		eip93_cleanup(eip93);
+		return ret;
+	}
+
 	/* Init finished, enable RDR interrupt */
 	eip93_irq_enable(eip93, EIP93_INT_RDR_THRESH);
 
