Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E646427FB0;
	Tue, 15 Sep 2026 03:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789444524; cv=none; b=SsK4aQohmqUY87A4Te8Y5oiFptf1UHPdlorV3CsFy4kzYk9dqTbdOy0HWrm5kUPg5bIh57qsppToFSwmhsPAgWxC8Yis0QA+TKQRpWhGHh9pQ2LEYd+5bymm24XIMA1QUrOu9VmMaX9bcVZEDF2KxdZw4hTEg5VOYVEJg2lmY2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789444524; c=relaxed/simple;
	bh=aX810VIgDUenKlA/jmx7LeoAcvdkWpseNbN7UJNsoek=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Z4iI7xygTybOq7TpU0klxjCtgkDh89P+a6A22pFprXoWLDM6iE3EFoFN3KbBTgdClfaojTHHvWxR3wpw5wbr73/FZY7HqNkV4pSK92ETV57csfXmJ7zwInpumUINRU1QNDVTsge+UclqWdN8ClllcZR1EHPOnlMqV2rFY8si7aQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from dfae2b116770.home.arpa (unknown [36.110.52.2])
	by APP-01 (Coremail) with SMTP id qwCowAAX7O+lwahq7NkHCA--.60773S2;
	Tue, 15 Sep 2026 11:55:17 +0800 (CST)
From: Wentao Liang <vulab@iscas.ac.cn>
To: herbert@gondor.apana.org.au
Cc: jenny.zhang@starfivetech.com,
	jiajie.ho@starfivetech.com,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	olivia@selenic.com,
	lkml@vger.kernel.org,
	Wentao Liang <vulab@iscas.ac.cn>,
	stable@vger.kernel.org
Subject: [PATCH 3/4] hwrng: starfive - Fix runtime PM leak in starfive_trng_read()
Date: Tue, 15 Sep 2026 03:54:48 +0000
Message-Id: <20260915035448.1724327-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qwCowAAX7O+lwahq7NkHCA--.60773S2
X-Coremail-Antispam: 1UD129KBjvJXoW7ZrW7Zw4fZr13Aw4kWryUWrg_yoW8ZFy7pr
	W5XayjyFWrJrW2yrs3AF4DZFyru3yftay8CFWIgas7Zws5G3Wvqa1UWFyYqF10yrZ3Aw45
	tw4aq3y3AF45tFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkK14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
	6r4UJwA2z4x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_JF0_Jw1lYx0Ex4A2jsIE14v26F4j6r4UJwAm72CE4IkC6x0Yz7v_Jr
	0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkF7I0En4kS14v2
	6r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrV
	AFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCI
	c40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267
	AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_
	Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VU1go2U
	UUUUU==
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiBwELA2qoi338RgAAsA

starfive_trng_read() takes a runtime PM reference with
pm_runtime_get_sync(trng->dev), which leaves the device's usage
count incremented even when it fails, and balances it with
pm_runtime_put_sync_autosuspend() on the success path only.  If
starfive_trng_wait_idle() times out or starfive_trng_cmd() fails,
the function returns early without dropping the reference, leaking
it on every failed read.

Convert the pm_runtime_get_sync() call to
pm_runtime_resume_and_get(), which drops the reference again on
failure, and release the reference with
pm_runtime_put_sync_autosuspend() before the two early returns.

Fixes: c388f458bc34 ("hwrng: starfive - Add TRNG driver for StarFive SoC")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
---
 drivers/char/hw_random/jh7110-trng.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/char/hw_random/jh7110-trng.c b/drivers/char/hw_random/jh7110-trng.c
index 9776f4daa044..01024145afb5 100644
--- a/drivers/char/hw_random/jh7110-trng.c
+++ b/drivers/char/hw_random/jh7110-trng.c
@@ -247,7 +247,9 @@ static int starfive_trng_read(struct hwrng *rng, void *buf, size_t max, bool wai
 	struct starfive_trng *trng = to_trng(rng);
 	int ret;
 
-	pm_runtime_get_sync(trng->dev);
+	ret = pm_runtime_resume_and_get(trng->dev);
+	if (ret)
+		return ret;
 
 	if (trng->mode == PRNG_256BIT)
 		max = min_t(size_t, max, (STARFIVE_RAND_LEN * 8));
@@ -256,13 +258,17 @@ static int starfive_trng_read(struct hwrng *rng, void *buf, size_t max, bool wai
 
 	if (wait) {
 		ret = starfive_trng_wait_idle(trng);
-		if (ret)
+		if (ret) {
+			pm_runtime_put_sync_autosuspend(trng->dev);
 			return -ETIMEDOUT;
+		}
 	}
 
 	ret = starfive_trng_cmd(trng, STARFIVE_CTRL_GENE_RANDNUM, wait);
-	if (ret)
+	if (ret) {
+		pm_runtime_put_sync_autosuspend(trng->dev);
 		return ret;
+	}
 
 	memcpy_fromio(buf, trng->base + STARFIVE_RAND0, max);
 
-- 
2.34.1

