Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 847323F12F5;
	Wed,  8 Jul 2026 15:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783523079; cv=none; b=YxhflrfB9a9BwWSMDKYC536TaYVXcsEZmc0roObpOxdpyux17ZCxs7RAjkSQoKIXGyEyf0dVULjnBPJ4yi5NtIjBiOOvoeqJ6kAiUwWkPvIOX1Gc9R1vIjvYtLYNVsZ3j7pTnnfgI348Y/aLAQ5Jwn3dzBkdGq+7vhBoAQx9C/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783523079; c=relaxed/simple;
	bh=q6WzhvHEK1zBLo09d+1w9A+q4i17hzUyPxyhhhNLWOw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KJwq9bTVxJd7Z3uIZXyyiVpo6100q//dzC2aIzBQ/7ObT7ksDti3Zlhgq3x+KHtDW6iKSom9TG35DKxbL3gzXeJJw8qJ6JKAlU9RK50MKIuk2Z0gLfWbTkkfjUlpKPxEiVkeq4niJW77UeTK9/zsrunW6Tdi0KCg8yC6ZEp9F5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=hUqtXPlC; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="hUqtXPlC"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783523073;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=N0tnrtHNCdPPaeil/2FJ7xhWeZJlpBvAHaqYCxTjbds=;
	b=hUqtXPlCKELHA6EiN9LfGfbVZe4c7bDuZoHBgOwhbzi72GRUinJRiobYqhbd/jB69TgpCU
	8ruYxUGJpT6Umayo14BjAa/WAKGrtjcJUBr2/RxhA/o6dtB6FTwQ6h2kkEurFMzvOVlz71
	GbUIvRFoXa2Ntr6oXNd2vuc4M8jkNDo=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>
Cc: linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: atmel-sha204a - clear RNG data from memory
Date: Wed,  8 Jul 2026 17:04:00 +0200
Message-ID: <20260708150359.545852-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2157; i=thorsten.blum@linux.dev; h=from:subject; bh=q6WzhvHEK1zBLo09d+1w9A+q4i17hzUyPxyhhhNLWOw=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFl+afc5ply5Gz+/81i136fpd7unxxkaGBaG3z2zJu7Vu i/3A9YKdZSyMIhxMciKKbI8mPVjhm9pTeUmk4idMHNYmUCGMHBxCsBEJjowMjT3b2z7njlNdvpB rmj3EpuOgM7jv+81Oq4tnj5B2MjIwJmR4U+j5oRbjI4ch1JWbbdb95dp4Z/tQmtMuj92HNvazJ7 Lyg8A
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

In atmel_sha204a_rng_read(), use memzero_explicit() to clear the local
stack variable cmd before it goes out of scope, since cmd.data may still
hold the last 32 random bytes.

Since atmel_sha204a_rng_done() caches work_data in hwrng::priv, and its
response data is later used as RNG entropy, use kfree_sensitive() to
clear the cached data on transaction failure and device removal.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/crypto/atmel-sha204a.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/atmel-sha204a.c b/drivers/crypto/atmel-sha204a.c
index 5eb76245347d..21a84c29c9b7 100644
--- a/drivers/crypto/atmel-sha204a.c
+++ b/drivers/crypto/atmel-sha204a.c
@@ -15,6 +15,7 @@
 #include <linux/module.h>
 #include <linux/scatterlist.h>
 #include <linux/slab.h>
+#include <linux/string.h>
 #include <linux/sysfs.h>
 #include <linux/workqueue.h>
 #include "atmel-i2c.h"
@@ -35,7 +36,7 @@ static void atmel_sha204a_rng_done(struct atmel_i2c_work_data *work_data,
 		dev_warn_ratelimited(&i2c_priv->client->dev,
 				     "i2c transaction failed (%d)\n",
 				     status);
-		kfree(work_data);
+		kfree_sensitive(work_data);
 		atomic_dec(&i2c_priv->tfm_count);
 		return;
 	}
@@ -95,12 +96,15 @@ static int atmel_sha204a_rng_read(struct hwrng *rng, void *data, size_t max,
 
 	ret = atmel_i2c_send_receive(i2c_priv->client, &cmd);
 	if (ret)
-		return ret;
+		goto out;
 
 	max = min(RANDOM_RSP_SIZE - CMD_OVERHEAD_SIZE, max);
 	memcpy(data, &cmd.data[RSP_DATA_IDX], max);
+	ret = max;
 
-	return max;
+out:
+	memzero_explicit(&cmd, sizeof(cmd));
+	return ret;
 }
 
 static int atmel_sha204a_otp_read(struct i2c_client *client, u16 addr, u8 *otp)
@@ -209,7 +213,7 @@ static void atmel_sha204a_remove(struct i2c_client *client)
 	devm_hwrng_unregister(&client->dev, &i2c_priv->hwrng);
 	atmel_i2c_flush_queue();
 
-	kfree((void *)i2c_priv->hwrng.priv);
+	kfree_sensitive((void *)i2c_priv->hwrng.priv);
 }
 
 static const struct of_device_id atmel_sha204a_dt_ids[] = {

base-commit: e264401ce4776a288524e5b87593d4d864147115
