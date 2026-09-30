Received: from mail-m155101.qiye.163.com (mail-m155101.qiye.163.com [101.71.155.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93905351C11;
	Wed, 30 Sep 2026 09:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.71.155.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790760370; cv=none; b=WJuMT+uUI7xvSQlNwpv/HjWiH5SCU0t7AyqSkP/rSX+2AacPyiWjFp0kfmkLQTvuS6EM0wMWAb6wgGdlqQVMrxiYfqRaqFLoWSKoFUq+UkazyNcgTc9H02nv+JIcvogRV/uyNehjVRjmprzPV3IyoeZgr5kcJQlPXMmGSvzR89w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790760370; c=relaxed/simple;
	bh=gHFxeGC83I52w7Kqn26hl48MzLaWSSiV1Vh+AYsdIzo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=jtk1H7RdocqiPmoC38FFLSlyw9h9UUOj0XMde0uz8LJfWv6Ws026VGafR6HXQ5LUMiCeGyxjAnOKN77cVdZKJ7elkZ/kMEwRLQI75hE0mvpl7xGULXY5MZspU3nSCNmFQTB3Dmv0z7u0T79aUCgDtnAaox03crt59GTX2FuuCxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn; spf=pass smtp.mailfrom=seu.edu.cn; dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b=hAeUr06d; arc=none smtp.client-ip=101.71.155.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b="hAeUr06d"
Received: from PC-202605011814.localdomain (unknown [222.191.246.242])
	by smtp.qiye.163.com (Hmail) with ESMTP id 4fa0978f4;
	Wed, 30 Sep 2026 17:25:56 +0800 (GMT+08:00)
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
Subject: [PATCH] crypto: inside-secure: initialize EIP93 state before requesting IRQ
Date: Wed, 30 Sep 2026 17:25:51 +0800
Message-Id: <20260930092551.2976763-1-runyu.xiao@seu.edu.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa0f1a28a8703a1kunm3b8c0ff6276571
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlCQkMfVh1PH0pPSU5LSEpPTFYeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlJSUlVSkJKVUlPTVVJT0lZV1kWGg8SFR0UWUFZT0tIVUpLSE
	pPSExVSktLVUpCS0tZBg++
DKIM-Signature: a=rsa-sha256;
	b=hAeUr06diREDicqV35nZW5+nOOa0hLEOS8o3DcO896+adlwBeQPRom+1lm7O5CT4z34kOILd+3ze5zEUanQVzlSiVYxoGxkbJErKFdHGIUg9EGF1Bq1UdOXk1qr8PAZwciy5gYFkqJBeV29LGotdW3VLM5FVn3KfO/L4+b8eFfA=; c=relaxed/relaxed; s=default; d=seu.edu.cn; v=1;
	bh=88+OFijJh0zX95cxLz82bXir1Qum2T2Rzvhc27AGbLw=;
	h=date:mime-version:subject:message-id:from;

devm_request_threaded_irq() can invoke the handler as soon as
registration starts.  The EIP93 probe currently requests the IRQ
before allocating the descriptor rings and initializing the tasklet,
locks, and IDR used by the handler.

Initialize the software and hardware state, and disable the device
interrupts, before requesting the IRQ.  The existing interrupt enable
remains after successful IRQ registration.

Fixes: 9739f5f93b78 ("crypto: eip93 - Add Inside Secure SafeXcel EIP-93 crypto engine support")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
---
 drivers/crypto/inside-secure/eip93/eip93-main.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/inside-secure/eip93/eip93-main.c b/drivers/crypto/inside-secure/eip93/eip93-main.c
index e62785952..06c8d771a 100644
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
@@ -452,6 +446,12 @@ static int eip93_crypto_probe(struct platform_device *pdev)
 
 	eip93_initialize(eip93, algo_flags);
 
+	ret = devm_request_threaded_irq(eip93->dev, eip93->irq, eip93_irq_handler,
+					NULL, IRQF_ONESHOT,
+					dev_name(eip93->dev), eip93);
+	if (ret)
+		return ret;
+
 	/* Init finished, enable RDR interrupt */
 	eip93_irq_enable(eip93, EIP93_INT_RDR_THRESH);
 
-- 
2.34.1
