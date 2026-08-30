Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFDA63B27D4;
	Sun, 30 Aug 2026 13:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788095885; cv=none; b=NYiyDMdScYCX5WpPhUvdVoErHQ6uPf3a7Zk/UTEbUsHDVWtqt/gsxDY2ES5TE4yCPvGf6Hi2ONJDIO58kHk/lgqyhS5G9Hj5FNblApABAGyTSvkTFTpWFBroC5x9qFEVD23DtiHgcub3aD41E5B4Erdt6OB5oYzbuB5UXASGsEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788095885; c=relaxed/simple;
	bh=gwhSxE546cFMDGfclvXpPfQ5Tsqc1uOqKK2HkMA1LqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bYXO6A5NrpuJg8kJQEhqaZblQDndpUB3KkO7XMpH6/PgWSs+e4k9TaFldWC8yc8MfYScgj1i0DQemWmAzUNQNWhCIboezFjUP0tT3aF9h+l773aCFM1t4sUrjJMmpdPrz8NQP92W/mbgi3IfM+oKEbKDQMMsty5ufnKY6Iu0JWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from localhost.localdomain (unknown [111.196.241.250])
	by APP-03 (Coremail) with SMTP id rQCowADHyjiDLZRqBPeaBg--.17324S2;
	Sun, 30 Aug 2026 21:17:56 +0800 (CST)
From: Pengpeng Hou <pengpeng@iscas.ac.cn>
To: Jia Jie Ho <jiajie.ho@starfivetech.com>
Cc: Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] hwrng: starfive: propagate clock and reset errors
Date: Sun, 30 Aug 2026 21:17:53 +0800
Message-ID: <20260830131753.3744-1-pengpeng@iscas.ac.cn>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:rQCowADHyjiDLZRqBPeaBg--.17324S2
X-Coremail-Antispam: 1UD129KBjvJXoWxCw48CF1ftw4UWw1DAw4UXFb_yoW5XFWkpF
	WUXrWYyr4IgrWS9Fs3JF4DAFyF9r4xtFWIq3yfKas7Xw4rArykXa18tF1jqFn0yr95Kw45
	Jr4aqFy8CF4UZFUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvj14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
	6r4UJwA2z4x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Cr
	1j6rxdM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj
	6xIIjxv20xvE14v26r126r1DMcIj6I8E87Iv67AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr
	0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkF7I0En4kS14v2
	6r126r1DMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrV
	AFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCI
	c40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1I6r4UMIIF0xvE2Ix0cI8IcVCY1x0267
	AKxVWxJVW8Jr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r4j
	6F4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr1j6F4UJbIYCTnIWIevJa73UjIFyTuYvjfUeT
	mhDUUUU
X-CM-SenderInfo: pshqw1xhqjqxpvfd2hldfou0/

The StarFive TRNG probe and resume paths ignore failures from their clock
and reset operations. That lets the driver register or resume while its
hardware access prerequisites were not established.

Check each transition, unwind only the previously enabled clock on failure,
and propagate the error to the probe or PM core.

Fixes: c388f458bc34 ("hwrng: starfive - Add TRNG driver for StarFive SoC")
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
---
 drivers/char/hw_random/jh7110-trng.c | 39 +++++++++++++++++++++++++++---------
 1 file changed, 29 insertions(+), 10 deletions(-)

diff --git a/drivers/char/hw_random/jh7110-trng.c b/drivers/char/hw_random/jh7110-trng.c
index aee12caab5780..61eb4db7ac014 100644
--- a/drivers/char/hw_random/jh7110-trng.c
+++ b/drivers/char/hw_random/jh7110-trng.c
@@ -320,9 +320,17 @@ static int starfive_trng_probe(struct platform_device *pdev)
 		return dev_err_probe(&pdev->dev, PTR_ERR(trng->rst),
 				     "Error getting hardware reset line\n");
 
-	clk_prepare_enable(trng->hclk);
-	clk_prepare_enable(trng->ahb);
-	reset_control_deassert(trng->rst);
+	ret = clk_prepare_enable(trng->hclk);
+	if (ret)
+		return ret;
+
+	ret = clk_prepare_enable(trng->ahb);
+	if (ret)
+		goto disable_hclk;
+
+	ret = reset_control_deassert(trng->rst);
+	if (ret)
+		goto disable_ahb;
 
 	trng->rng.name = dev_driver_string(&pdev->dev);
 	trng->rng.init = starfive_trng_init;
@@ -342,13 +350,18 @@ static int starfive_trng_probe(struct platform_device *pdev)
 		pm_runtime_disable(&pdev->dev);
 
 		reset_control_assert(trng->rst);
-		clk_disable_unprepare(trng->ahb);
-		clk_disable_unprepare(trng->hclk);
-
-		return dev_err_probe(&pdev->dev, ret, "Failed to register hwrng\n");
+		ret = dev_err_probe(&pdev->dev, ret, "Failed to register hwrng\n");
+		goto disable_ahb;
 	}
 
 	return 0;
+
+disable_ahb:
+	clk_disable_unprepare(trng->ahb);
+disable_hclk:
+	clk_disable_unprepare(trng->hclk);
+
+	return ret;
 }
 
 static int __maybe_unused starfive_trng_suspend(struct device *dev)
@@ -364,11 +377,17 @@ static int __maybe_unused starfive_trng_suspend(struct device *dev)
 static int __maybe_unused starfive_trng_resume(struct device *dev)
 {
 	struct starfive_trng *trng = dev_get_drvdata(dev);
+	int ret;
+
+	ret = clk_prepare_enable(trng->hclk);
+	if (ret)
+		return ret;
 
-	clk_prepare_enable(trng->hclk);
-	clk_prepare_enable(trng->ahb);
+	ret = clk_prepare_enable(trng->ahb);
+	if (ret)
+		clk_disable_unprepare(trng->hclk);
 
-	return 0;
+	return ret;
 }
 
 static const struct dev_pm_ops starfive_trng_pm_ops = {

base-commit: 08dbfad3f5040f5bdb6c529da20d6d4e81fefd72
-- 
2.50.1

