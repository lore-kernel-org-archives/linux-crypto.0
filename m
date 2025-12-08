Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D123227BB5;
	Mon,  8 Dec 2025 08:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765181353; cv=none; b=UF7pdTFXCl0SWzfsAQ+99ExavnGlABYAPe1/3/bFQeJSud+eC2iAOoAtUQ86XKtb5aN/JA9lTlIwDr+6Pgjjofs9+vHabGRPbR+6YvyfyFAt+ChnmMSwuve9azluSkgSuwJUfOWahkKABKEwOHy61TgbPRAqa4U3W3DcD0pqNRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765181353; c=relaxed/simple;
	bh=8Izt8j2LDVeu5yFVj0DcleOjQ1CUWt5s26Gj52BMqcQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TInBPQQoO9eZvyHAAndlEwkagSZnbsWFGFFHEuV1pOdFeuCypiOTDzh2D9rpvfcpa1GGamb8UybqESN/A5Jiz/FkWdwJ4+OqvXO4wS42Y0ZryU9qWF82TiF+hSPneQ0ytMoNh8Thfy8yIOTOLoXf/ZC/IE5oG05g5ZO0vUxMSxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from DESKTOP-L0HPE2S (unknown [124.16.141.245])
	by APP-01 (Coremail) with SMTP id qwCowABX7cyZhzZpxEp1Aw--.7249S2;
	Mon, 08 Dec 2025 16:08:59 +0800 (CST)
From: Haotian Zhang <vulab@iscas.ac.cn>
To: ansuelsmth@gmail.com,
	olivia@selenic.com,
	herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Haotian Zhang <vulab@iscas.ac.cn>
Subject: [PATCH] hwrng: airoha: Fix wait_for_completion_timeout return value check
Date: Mon,  8 Dec 2025 16:08:36 +0800
Message-ID: <20251208080836.1010-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.50.1.windows.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qwCowABX7cyZhzZpxEp1Aw--.7249S2
X-Coremail-Antispam: 1UD129KBjvJXoW7tF1UCr45WFWDWw47trWkJFb_yoW8Gw4kpr
	4Uu34DAF4fX3yrCFWFkan8Zw4Yqay3XaykKrya934kZwnYkF18Gay5tFyqqF1UCrZaqF13
	tr45tr1DZwn8AaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkl14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
	0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xII
	jxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr0_Gr
	1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkF7I0En4kS14v26r12
	6r1DMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI
	0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y
	0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxV
	WUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1l
	IxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUjO6pDUUUU
	U==
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiDAUKA2k2dlRKYwAAsU

wait_for_completion_timeout() returns an unsigned long
representing remaining jiffies, not an int. It returns
0 on timeout and a positive value on completion, never
a negative error code.

Change the type of ret to unsigned long, and update the
check to == 0 to correctly detect timeouts.

Fixes: e53ca8efcc5e ("hwrng: airoha - add support for Airoha EN7581 TRNG")
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
---
 drivers/char/hw_random/airoha-trng.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/hw_random/airoha-trng.c b/drivers/char/hw_random/airoha-trng.c
index 1dbfa9505c21..3e94233e1389 100644
--- a/drivers/char/hw_random/airoha-trng.c
+++ b/drivers/char/hw_random/airoha-trng.c
@@ -76,7 +76,7 @@ static int airoha_trng_irq_unmask(struct airoha_trng *trng)
 static int airoha_trng_init(struct hwrng *rng)
 {
 	struct airoha_trng *trng = container_of(rng, struct airoha_trng, rng);
-	int ret;
+	unsigned long ret;
 	u32 val;
 
 	val = readl(trng->base + TRNG_NS_SEK_AND_DAT_EN);
@@ -88,7 +88,7 @@ static int airoha_trng_init(struct hwrng *rng)
 	writel(0, trng->base + TRNG_HEALTH_TEST_SW_RST);
 
 	ret = wait_for_completion_timeout(&trng->rng_op_done, BUSY_LOOP_TIMEOUT);
-	if (ret <= 0) {
+	if (ret == 0) {
 		dev_err(trng->dev, "Timeout waiting for Health Check\n");
 		airoha_trng_irq_mask(trng);
 		return -ENODEV;
-- 
2.50.1.windows.1

