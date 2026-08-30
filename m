Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12BFE1A9FBC;
	Sun, 30 Aug 2026 13:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788097037; cv=none; b=j3xzQWCQ4TZMxQQbtJ9QJx7f2PfxJILgjZjXlgOOzIY89MaCsrYN+l6gmJbw/SF9V5X8fJold05Gv5L4DVs/sjbH96CbkGtzjpe6udbcJ7xZ2ECBUJ+iYDq6A9XahEttk1ISmd/d/BFYBdRGWwI0v7wsdILQrS6Mtjk4dKaGgo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788097037; c=relaxed/simple;
	bh=H8fpou32kSYOzfXiyBVBL9oqV3pCi2hwWUYAK6P/Wj8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fFa2VHD5tBRfZkYYB1TSkY0rK0iFi5F0IwdagqptnePf6m71/gwyH8xTCa8SB73I3qoROf/mQpmtklCu0xfGZ3QkaVG29X8ux5GDkb5Dxatq3haL5QqLE84cA6NogcfhmB59iJllszpTR7SggqaeIvuHNvbDk0+19kGZ6/JyusQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from localhost.localdomain (unknown [111.196.241.250])
	by APP-03 (Coremail) with SMTP id rQCowADH0T_3MZRqVzGbBg--.48150S2;
	Sun, 30 Aug 2026 21:36:55 +0800 (CST)
From: Pengpeng Hou <pengpeng@iscas.ac.cn>
To: Daniel Golle <daniel@makrotopia.org>
Cc: Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Nicolas Frattaroli <nicolas.frattaroli@collabora.com>,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Heiko Stuebner <heiko@sntech.de>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-rockchip@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] hwrng: rockchip: propagate reset errors
Date: Sun, 30 Aug 2026 21:36:52 +0800
Message-ID: <20260830133652.7618-1-pengpeng@iscas.ac.cn>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:rQCowADH0T_3MZRqVzGbBg--.48150S2
X-Coremail-Antispam: 1UD129KBjvJXoWrKry5KFWxKFyxtryDXF45GFg_yoW8Jr1xpF
	WkCFyavrWUC3yFva9rAay5Z3ZYg3WayFWUK3yIk3s7ZwnxJw18Gw1YvFZIqasxXF48try5
	tr47Aa48uF42vr7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
	4UMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_
	JF4lIxAIcVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYx
	BIdaVFxhVjvjDU0xZFpf9x0JUgXocUUUUU=
X-CM-SenderInfo: pshqw1xhqjqxpvfd2hldfou0/

rk_rng_probe() pulses the optional or required reset array before
registering
the hardware RNG, but discards errors from both reset operations.

Return reset failures before publishing the RNG device.

Fixes: 8eff8eb83fc0 ("hwrng: rockchip - add support for rk3588's standalone TRNG")
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
---
 drivers/char/hw_random/rockchip-rng.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/char/hw_random/rockchip-rng.c b/drivers/char/hw_random/rockchip-rng.c
index 6e3ed4b856051..ff98fcdc68911 100644
--- a/drivers/char/hw_random/rockchip-rng.c
+++ b/drivers/char/hw_random/rockchip-rng.c
@@ -412,9 +412,14 @@ static int rk_rng_probe(struct platform_device *pdev)
 		if (IS_ERR(rst))
 			return dev_err_probe(dev, PTR_ERR(rst), "Failed to get reset property\n");
 
-		reset_control_assert(rst);
+		ret = reset_control_assert(rst);
+		if (ret)
+			return ret;
+
 		udelay(2);
-		reset_control_deassert(rst);
+		ret = reset_control_deassert(rst);
+		if (ret)
+			return ret;
 	}
 
 	platform_set_drvdata(pdev, rk_rng);

base-commit: 08dbfad3f5040f5bdb6c529da20d6d4e81fefd72
-- 
2.50.1

