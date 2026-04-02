Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 906142FDC5E;
	Thu,  2 Apr 2026 13:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775135214; cv=none; b=fvogFZ338FNhKHqf7JbdFZDVn956mwbfFTBpE051OWLlurVKCd8jbwlzGuoic++XUt6l0OSHVQsVUYttrWZi6cHwyrlxE/KEtH/pwnaZau0vPo8l5DMpZoc9nQUtw6T13HrK9CzgxnQ89O9RrP+6A6HerjQRuXAfitEmcYFvHZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775135214; c=relaxed/simple;
	bh=3mEkNNBAXT/4sit0JHlFgeh1aJsvdLOLsQ/a+hbFXz8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=L4xPCNM8E9DnuHFlL3PpH8Hj8YjPJHSfQzVq9n5mJW7JjYbReBD3RrMK4ainSpVljYhA7AcH9QwiSvonfd5okfZMEYB//RdlGhEdWQSWwwaAb9aFvbvtBJwhTt7KG6R4QTMUBqGtjGv8Hr2NwP9sVPMEgxqcRFL10FqZR9BO144=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=spFekU9l; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="spFekU9l"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775135205;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=XboYRvZ1sjYhyAoBa5TPLfYewPrhv3xPgmAMGkkGk/o=;
	b=spFekU9lXZZRDPDs2lxIlWAnB+B+iSR4L3So790w2OTxVKsH+yrp144YMXVpedX4zeO1bA
	89thoQj4D2yqq2vsaI8McjojulCu0jRfiipVcN68CtqTLv5c9+lj/9FvAZMea/eqDrOi5y
	3fg99F5szxQTfpMUNSLwIYEMB6osyP4=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Tudor Ambarus <tudor.ambarus@linaro.org>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	stable@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: atmel-ecc - fix potential use-after-free in remove path
Date: Thu,  2 Apr 2026 15:05:38 +0200
Message-ID: <20260402130536.892838-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1664; i=thorsten.blum@linux.dev; h=from:subject; bh=3mEkNNBAXT/4sit0JHlFgeh1aJsvdLOLsQ/a+hbFXz8=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDJnnMheENJrmbZmbEWt7Pzc8OXyBgl/xjrhvRVdT21gzO XgTZzN2lLIwiHExyIopsjyY9WOGb2lN5SaTiJ0wc1iZQIYwcHEKwEQKvjAyPDBom7f2zeo3Tje3 /1T8qfnD3nj73bR0Dq643vd+z+uW8DMyPP1YKsFRc8LvW3TMiZO3zqwr6+CuYf3KOiVKzm5zdKM cCwA=
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Flush the Atmel I2C workqueue before teardown to prevent a potential
use-after-free if a queued callback runs while the device is being
removed.

Drop the early return to ensure the driver always unregisters the KPP
algorithm and removes the client from the global list instead of
aborting teardown when the device is busy.

Fixes: 11105693fa05 ("crypto: atmel-ecc - introduce Microchip / Atmel ECC driver")
Cc: stable@vger.kernel.org
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/crypto/atmel-ecc.c | 15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

diff --git a/drivers/crypto/atmel-ecc.c b/drivers/crypto/atmel-ecc.c
index b6a77c8d439c..6dbd0f70dd84 100644
--- a/drivers/crypto/atmel-ecc.c
+++ b/drivers/crypto/atmel-ecc.c
@@ -346,21 +346,8 @@ static void atmel_ecc_remove(struct i2c_client *client)
 {
 	struct atmel_i2c_client_priv *i2c_priv = i2c_get_clientdata(client);
 
-	/* Return EBUSY if i2c client already allocated. */
-	if (atomic_read(&i2c_priv->tfm_count)) {
-		/*
-		 * After we return here, the memory backing the device is freed.
-		 * That happens no matter what the return value of this function
-		 * is because in the Linux device model there is no error
-		 * handling for unbinding a driver.
-		 * If there is still some action pending, it probably involves
-		 * accessing the freed memory.
-		 */
-		dev_emerg(&client->dev, "Device is busy, expect memory corruption.\n");
-		return;
-	}
-
 	crypto_unregister_kpp(&atmel_ecdh_nist_p256);
+	atmel_i2c_flush_queue();
 
 	spin_lock(&driver_data.i2c_list_lock);
 	list_del(&i2c_priv->i2c_client_list_node);
