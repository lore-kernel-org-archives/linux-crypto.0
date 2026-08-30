Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF6E114F70;
	Sun, 30 Aug 2026 13:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788097726; cv=none; b=LKh5cieWVI5AR3Jh+Mtv3sHjdqfhaqqoU/BoMwFNvzm/ccqHdX3agBz9Z9UNrYSVnLz7gmFieUnpEKcbY5zfeQyk506w5sBT6uD4QUeO4ium8UpI5rAphaEYPTX1etlK7cwtO8ZHMR8VDTesFHGKjMxopH4sTplzT2LjA/OS0fQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788097726; c=relaxed/simple;
	bh=699dEzGSd/m5V3n5zr/soYQ3Ap0jLrCZ24n4FGR/GjY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BCW0QQvulAm6oKWyXUqmRZjVOvWB6UWKTGzb1SLK/xzX4cpM/vnX+9bJdnUuTaJKHFSjS0A45g3KqmmglvFxRhEBllkrllJKdwUv0wb4EWo68DPc21QnNqQu+LypW7vAncGBcAOPFoDH6zNto3bPtVmB0Jl3VYb4a9F/xkZP1HE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from localhost.localdomain (unknown [111.196.241.250])
	by APP-03 (Coremail) with SMTP id rQCowAAXIkC1NJRqNVObBg--.20257S2;
	Sun, 30 Aug 2026 21:48:37 +0800 (CST)
From: Pengpeng Hou <pengpeng@iscas.ac.cn>
To: Jia Jie Ho <jiajie.ho@starfivetech.com>
Cc: Pengpeng Hou <pengpeng@iscas.ac.cn>,
	William Qiu <william.qiu@starfivetech.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: starfive: propagate clock and reset errors
Date: Sun, 30 Aug 2026 21:48:35 +0800
Message-ID: <20260830134835.10572-1-pengpeng@iscas.ac.cn>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:rQCowAAXIkC1NJRqNVObBg--.20257S2
X-Coremail-Antispam: 1UD129KBjvJXoW7tr4rWr4kAr4rXw4fGr43GFg_yoW8CF4fpF
	nxtrWSyr4UXrWSgan8Jrs5Zr1rZ3yFqF9agr4fG3Wxuw43AFWxJ3WSkF9YvFn0yFy8Jw15
	tFsrtr18CF47ZFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvj14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
	6r4UJwA2z4x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Cr
	1j6rxdM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj
	6xIIjxv20xvE14v26r126r1DMcIj6I8E87Iv67AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr
	0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkF7I0En4kS14v2
	6r126r1DMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrV
	AFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCI
	c40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1I6r4UMIIF0xvE2Ix0cI8IcVCY1x0267
	AKxVWxJVW8Jr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r4j
	6F4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr1j6F4UJbIYCTnIWIevJa73UjIFyTuYvjfUeT
	mhDUUUU
X-CM-SenderInfo: pshqw1xhqjqxpvfd2hldfou0/

starfive_cryp_probe() publishes the crypto device after enabling its clocks
and deasserting its reset without checking whether those operations
succeeded.

Check each hardware activation step and unwind only the resources that were
actually enabled before returning the error.

Fixes: 42ef0e944b01 ("crypto: starfive - Add crypto engine support")
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
---
 drivers/crypto/starfive/jh7110-cryp.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/starfive/jh7110-cryp.c b/drivers/crypto/starfive/jh7110-cryp.c
index 842f76b0f1148..856290347b95b 100644
--- a/drivers/crypto/starfive/jh7110-cryp.c
+++ b/drivers/crypto/starfive/jh7110-cryp.c
@@ -120,9 +120,17 @@ static int starfive_cryp_probe(struct platform_device *pdev)
 		return dev_err_probe(&pdev->dev, PTR_ERR(cryp->rst),
 				     "Error getting hardware reset line\n");
 
-	clk_prepare_enable(cryp->hclk);
-	clk_prepare_enable(cryp->ahb);
-	reset_control_deassert(cryp->rst);
+	ret = clk_prepare_enable(cryp->hclk);
+	if (ret)
+		return ret;
+
+	ret = clk_prepare_enable(cryp->ahb);
+	if (ret)
+		goto disable_hclk;
+
+	ret = reset_control_deassert(cryp->rst);
+	if (ret)
+		goto disable_ahb;
 
 	spin_lock(&dev_list.lock);
 	list_add(&cryp->list, &dev_list.dev_list);
@@ -170,9 +178,11 @@ static int starfive_cryp_probe(struct platform_device *pdev)
 	list_del(&cryp->list);
 	spin_unlock(&dev_list.lock);
 
-	clk_disable_unprepare(cryp->hclk);
-	clk_disable_unprepare(cryp->ahb);
 	reset_control_assert(cryp->rst);
+disable_ahb:
+	clk_disable_unprepare(cryp->ahb);
+disable_hclk:
+	clk_disable_unprepare(cryp->hclk);
 
 	return ret;
 }

base-commit: 08dbfad3f5040f5bdb6c529da20d6d4e81fefd72
-- 
2.50.1

