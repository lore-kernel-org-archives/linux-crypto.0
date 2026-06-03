Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFE2E44A701;
	Wed,  3 Jun 2026 11:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780484624; cv=none; b=jAlXTeLkeaCIE8Y36uhQhGWi9vHNdqZXwDvRqr7+TXJPQZkErZBvBAn9xEihVZkgSTRfT8LBrhtfh2qmDvGb/tMUGV2xjIYbb6IY+DU2AtAo8HnvuOzA9Ejoej3a+DBktIE+WuaZkXD6UUKPTFhOhbGKsAOFj53j6IzD1tmr4BM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780484624; c=relaxed/simple;
	bh=Y6oH8BWy8BbiPwWdHl9UzZYZ4XmHlPZhtUvW4P5ves4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=byZLFWS8wY1oINX97P+YFqm9SAh5utIJNPZfma7hf5uKI2Boll74nw1nQ/ZBWeGVph94a6s0d5LuC2CcTiZFf4GhBPY8P7cBzC0DGgsKkVRlz6yzuxgnEzItyu2x2HblnztT0W4zLR+ilGVuiZamPo/HVF5lwXtdtIuujvYByJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from dfae2b116770.home.arpa (unknown [36.110.52.2])
	by APP-03 (Coremail) with SMTP id rQCowABnfNMKCiBqGk9_Ew--.20012S2;
	Wed, 03 Jun 2026 19:03:38 +0800 (CST)
From: Wentao Liang <vulab@iscas.ac.cn>
To: jiajie.ho@starfivetech.com,
	olivia@selenic.com,
	herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Wentao Liang <vulab@iscas.ac.cn>,
	stable@vger.kernel.org
Subject: [PATCH] hwrng: jh7110: fix refcount leak in starfive_trng_read()
Date: Wed,  3 Jun 2026 11:03:27 +0000
Message-Id: <20260603110327.3750514-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:rQCowABnfNMKCiBqGk9_Ew--.20012S2
X-Coremail-Antispam: 1UD129KBjvJXoW7uF1UGryrXw4fZFy8XFWrZrb_yoW8WFy5pr
	WjqayYkr4rJr47ArZxJFs8ZFyrurWft3y8W397K3y8Zw4rJ3WkXa10kF1YqF1UKFWxJw45
	trsIqw45CFWjyFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkC14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
	0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xII
	jxv20xvE14v26r126r1DMcIj6I8E87Iv67AKxVW8Jr0_Cr1UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7CjxVAaw2AFwI0_
	JF0_Jw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67
	AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIY
	rxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14
	v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8
	JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUOMKuUU
	UUU
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiBg0HA2of-Y4cXQACsK

The starfive_trng_read() function acquires a runtime PM reference
via pm_runtime_get_sync() but fails to release it on two error
paths.  If starfive_trng_wait_idle() or starfive_trng_cmd() returns
an error, the function exits without calling
pm_runtime_put_sync_autosuspend(), leaving the runtime PM usage
counter permanently elevated and preventing the device from entering
runtime suspend.

Refactor the function to use a unified error path that calls
pm_runtime_put_sync_autosuspend() before returning.

Cc: stable@vger.kernel.org
Fixes: c388f458bc34 ("hwrng: starfive - Add TRNG driver for StarFive SoC")
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
---
 drivers/char/hw_random/jh7110-trng.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/char/hw_random/jh7110-trng.c b/drivers/char/hw_random/jh7110-trng.c
index 9776f4daa044..4712c3c530e4 100644
--- a/drivers/char/hw_random/jh7110-trng.c
+++ b/drivers/char/hw_random/jh7110-trng.c
@@ -256,19 +256,22 @@ static int starfive_trng_read(struct hwrng *rng, void *buf, size_t max, bool wai
 
 	if (wait) {
 		ret = starfive_trng_wait_idle(trng);
-		if (ret)
-			return -ETIMEDOUT;
+		if (ret) {
+			ret = -ETIMEDOUT;
+			goto out_put;
+		}
 	}
 
 	ret = starfive_trng_cmd(trng, STARFIVE_CTRL_GENE_RANDNUM, wait);
 	if (ret)
-		return ret;
+		goto out_put;
 
 	memcpy_fromio(buf, trng->base + STARFIVE_RAND0, max);
+	ret = max;
 
+out_put:
 	pm_runtime_put_sync_autosuspend(trng->dev);
-
-	return max;
+	return ret;
 }
 
 static int starfive_trng_probe(struct platform_device *pdev)
-- 
2.34.1

