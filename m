Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 979823B4E81;
	Sun, 30 Aug 2026 13:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788095286; cv=none; b=akNp4jpbdbmzHbysuLeC59uAkFDAKj/Le/ZDTd+2qRyIWVFEVAlRK83ILnDPILRuQjJkkaKZNn0H6I++Ljf5dgO5o+j/5+J2raxaaUvFF+wQ3EZI5C0WpI+YH5PlqUDmxDsA/MHr+4t1gvQw+EduhqwhTLZaF7OcppamBaNCEC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788095286; c=relaxed/simple;
	bh=g4dOvEXL4ZYUUCgoiTokQCfy9OFRqEFluD322yinIQE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LonozmLMA0DZc50u8FTQcWH3sIv0QXmF+fZIdWVvBBdVY+9cnqFtPmMezU9jGv25GtW0my+MYYehtrwLrttCkgRecmvoZXrB6DXotDGLkwo4AG9m1744RTNP4bhRj9amo+FchNmHKYS5Wq5SayTE2Nxkt+pw+sS+D5U7B24CZns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from localhost.localdomain (unknown [111.196.241.250])
	by APP-03 (Coremail) with SMTP id rQCowABncD4mK5Rqp9aaBg--.48169S2;
	Sun, 30 Aug 2026 21:07:50 +0800 (CST)
From: Pengpeng Hou <pengpeng@iscas.ac.cn>
To: Corentin Labbe <clabbe@baylibre.com>
Cc: Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	Heiko Stuebner <heiko@sntech.de>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-rockchip@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: rockchip: propagate activation errors
Date: Sun, 30 Aug 2026 21:07:48 +0800
Message-ID: <20260830130748.944-1-pengpeng@iscas.ac.cn>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:rQCowABncD4mK5Rqp9aaBg--.48169S2
X-Coremail-Antispam: 1UD129KBjvJXoW7Aw1rGw1xuw1UGFy8XF47Arb_yoW8ZFW3pr
	13GrZrArWkCr4xGa95tr1rZF4rX3ySyry3Jr47K3WfAw1aqw1IgrWayFy0vFnxAFy8J3y5
	AFs7Aa48CF1xZFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9214x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
	6r4UJwA2z4x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Cr
	1j6rxdM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj
	6xIIjxv20xvE14v26r126r1DMcIj6I8E87Iv67AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr
	0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E
	8cxan2IY04v7MxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFV
	Cjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWl
	x4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1I6r
	4UMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWxJVW8Jr1lIxAIcVCF04k26cxKx2IYs7xG6r1j
	6r1xMIIF0xvEx4A2jsIE14v26r4j6F4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYx
	BIdaVFxhVjvjDU0xZFpf9x0JUgXocUUUUU=
X-CM-SenderInfo: pshqw1xhqjqxpvfd2hldfou0/

The Rockchip crypto driver ignores reset and crypto-engine start failures
in
probe, and ignores a reset deassertion failure during runtime resume. It
can therefore publish or resume the crypto device without a usable engine.

Return reset and engine-start failures, and disable the clocks if a runtime
resume reset deassertion fails.

Fixes: 433cd2c617bf ("crypto: rockchip - add crypto driver for rk3288")
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
---
 drivers/crypto/rockchip/rk3288_crypto.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/rockchip/rk3288_crypto.c b/drivers/crypto/rockchip/rk3288_crypto.c
index 7cb1316b6f189..18ecbec1f101b 100644
--- a/drivers/crypto/rockchip/rk3288_crypto.c
+++ b/drivers/crypto/rockchip/rk3288_crypto.c
@@ -133,7 +133,12 @@ static int rk_crypto_pm_resume(struct device *dev)
 	if (ret)
 		return ret;
 
-	reset_control_deassert(rkdev->rst);
+	ret = reset_control_deassert(rkdev->rst);
+	if (ret) {
+		rk_crypto_disable_clk(rkdev);
+		return ret;
+	}
+
 	return 0;
 
 }
@@ -341,9 +346,14 @@ static int rk_crypto_probe(struct platform_device *pdev)
 		goto err_crypto;
 	}
 
-	reset_control_assert(crypto_info->rst);
+	err = reset_control_assert(crypto_info->rst);
+	if (err)
+		goto err_crypto;
+
 	usleep_range(10, 20);
-	reset_control_deassert(crypto_info->rst);
+	err = reset_control_deassert(crypto_info->rst);
+	if (err)
+		goto err_crypto;
 
 	crypto_info->reg = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(crypto_info->reg)) {
@@ -374,7 +384,10 @@ static int rk_crypto_probe(struct platform_device *pdev)
 		goto err_crypto;
 	}
 
-	crypto_engine_start(crypto_info->engine);
+	err = crypto_engine_start(crypto_info->engine);
+	if (err)
+		goto err_pm;
+
 	init_completion(&crypto_info->complete);
 
 	err = rk_crypto_pm_init(crypto_info);

base-commit: 08dbfad3f5040f5bdb6c529da20d6d4e81fefd72
-- 
2.50.1

