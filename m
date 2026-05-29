Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A2343C3BF3
	for <linux-crypto@vger.kernel.org>; Fri, 29 May 2026 09:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780046837; cv=none; b=WhY2o5wDu+mz2rk0TgQGYVsAVySxBj2nHS/KBD6vkkuQ+H35591lwYHfsvFk1/BvDvveSE+8MLsZHQztVypgjYh1RFZZiNesySeidWXCdxLDX6bKgcUY+DWrrF3poeOE7OcVNhqFfNG6Pwuq257je219DfgWW+jdTG55p8fWSg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780046837; c=relaxed/simple;
	bh=OAabwV0ZdqXW3P/4QfoliKDakvaM+Bs8nZPDbFv6+NU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=qeCtv5b/AzxQwKPFf2QMtYKwd/MOvMilpiW0sccMFhm2yMpKuqUqMyzp4FjSBI9B+JqFEOPtl0p9I9GAwd6TdH3AMIb6KyTGMNscRnEZMG+lXPP39+QV2A12vIy6LmJn6N9u9/PFBT/eVpYvyAbQV38MQMH6a+f3Aj6rKGh9QZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ImyI1deI; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ImyI1deI"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-48fde653997so11362025e9.2
        for <linux-crypto@vger.kernel.org>; Fri, 29 May 2026 02:27:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780046830; x=1780651630; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=kNd8JRRutou7cnYAoh85T3g5wIr46IBSZCq17y/WOqA=;
        b=ImyI1deIjjKBRS6rgSBT9ohMps1irJL2UJDEmp4/eroEWVCBdro9Rd1ZwcjcCwjexU
         8voQJO+2w+hrzfcuvoWQjqrabLOseCHvdZT4bB9Yx+G6m+J75Az3IKAKRI1B++apEoCH
         0UzLP5wLM+B24pSqT10Ph2jVe1p1rRMmtNfrdTL0TJD+DhlHjCanngisY3cA4D28RXGM
         0qAhuhx/103+foTb9ReXbSrmZXenfJDwRcK9Y2OVcXgFz8ERAlhY/rfbCvcGEDaG2x2v
         MjrX1loMPpuXWwkRxP9JNDLQSAO4FLSOdN8czsNBcNqOuY1n63XNKttL6QdUcDVAfag3
         WFeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780046830; x=1780651630;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kNd8JRRutou7cnYAoh85T3g5wIr46IBSZCq17y/WOqA=;
        b=JVhNh/5e8WBV4RUm6vhZtl7AjympTYJkYel6zcznF7xysZcTr2VKwxmqYAZQURgaKe
         E8XXmPb05g1m2gt7KhoA/zgWGxYkCX/u/sS7pmXSLLdrvL3rB8Yj5K5SoG6R5MfpP21x
         KXWMw5ccPjTBH5aCSMX4SFeK8S8QAg8bl8nGfG9hhL1fTJw+2N8Zo5CqMUKHXsMSQgjn
         1oODMo9TQzNRD56IYdEJVUFDXSflKg6AUpS2qlGsesYJxWCj33eT/LhGavM0Q8A0K6+T
         TtZldllgGWHGQ6HrFAGd4IwS5sii0xtjg/I4JtKcHx77mkq2iT5LqOSMZAR1QWwU4xna
         xpjQ==
X-Gm-Message-State: AOJu0YzbW5f4hdrl8nDpjjpM1kjx6/aUFBlySHN5n4R+zFTsLqyCCPvD
	JrWZLAyO9Me4LKzhmdlskrqrm/8MuOSen9jGKtSKDeBaq/6zNzPVWcSP
X-Gm-Gg: Acq92OH+2UY70E12VZavThX8W0aKpsukT9ddcX4m9hGLRWBBZPbiUMK7SAMj6biQsYC
	WSR/sI1OrO5jo3SfBHhlQ65lva+ELBX0kPDKGp9/BfknfDbAEdeK+WlYjp4F/rrg4RWYcUFwfid
	sb11YvF3TwAupicyrRbcs1j1tuZ04IWJTva02TOYffuxvNaZpLZ6Q5n0qevg5bwUeXPoLTEObmU
	YAL0V3ZQIVmZa4pWktlPtfT58h9luFb2rq44IvJ0HeWjpWTcMN3wLXlVxaOSdc68BA5g8tvuAi2
	zqAK/GmtT7L7f2lvIt3ujam6BI5EwUdINQi2c4NB2yqqn4i4ml9QcoAsWwr+YSeZnkGDCxO53ZN
	oQ1VE1zsIypu3mL05+qC3lE1VALnlTVNaJuAEhj2Db0Ja/JXASbGumaFgXJcWwXDPBPUaDJYyH2
	hZjVMSyuLgTGZ1UDWepd5y3zPsD3UNZnM/US6wYWyQ0KBO7stpBX4hgKkQMULV/SNIbylCAs+1O
	w==
X-Received: by 2002:a05:600c:6d08:b0:490:3cb8:b853 with SMTP id 5b1f17b1804b1-4909c0e0d29mr9716185e9.7.1780046829525;
        Fri, 29 May 2026 02:27:09 -0700 (PDT)
Received: from menon.v.cablecom.net (84-74-0-139.dclient.hispeed.ch. [84.74.0.139])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4909cab0e79sm59295725e9.13.2026.05.29.02.27.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2026 02:27:09 -0700 (PDT)
From: Lothar Rubusch <l.rubusch@gmail.com>
To: thorsten.blum@linux.dev,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	nicolas.ferre@microchip.com,
	alexandre.belloni@bootlin.com,
	claudiu.beznea@tuxon.dev,
	tudor.ambarus@linaro.org,
	krzk+dt@kernel.org
Cc: linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	l.rubusch@gmail.com
Subject: [PATCH 1/1] crypto: atmel-ecc - fix use after free situation
Date: Fri, 29 May 2026 09:27:03 +0000
Message-Id: <20260529092703.33086-1-l.rubusch@gmail.com>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fixes a possible race condition, when having multiple of such devices
attached (identified by sashiko feedback).

The Scenario:
    Thread A (Device 1 Probe): Successfully adds i2c_priv to the global
             list (Line 324). The lock is released.
    Thread B (An active crypto request): Concurrently calls
              atmel_ecc_i2c_client_alloc(). It scans the global list, sees
              Device 1, and assigns a crypto job to it.
    Thread A: Moves to line 332. crypto_register_kpp() fails (e.g., out of
              memory or name clash).
    Thread A: Enters the error path. It removes Device 1 from the list and
              frees the i2c_priv memory.
    Thread B: Is still actively trying to talk to the I2C hardware using
              the i2c_priv pointer it grabbed in Step 2. The memory is now
              gone. Result: Kernel crash (Use-After-Free).

Fixes: 11105693fa05 ("crypto: atmel-ecc - introduce Microchip / Atmel ECC driver")
Signed-off-by: Lothar Rubusch <l.rubusch@gmail.com>
---
 drivers/crypto/atmel-ecc.c | 10 ++++++++++
 drivers/crypto/atmel-i2c.h |  2 ++
 2 files changed, 12 insertions(+)

diff --git a/drivers/crypto/atmel-ecc.c b/drivers/crypto/atmel-ecc.c
index 0ca02995a1de..d391fe1462f6 100644
--- a/drivers/crypto/atmel-ecc.c
+++ b/drivers/crypto/atmel-ecc.c
@@ -218,6 +218,8 @@ static struct i2c_client *atmel_ecc_i2c_client_alloc(void)
 
 	list_for_each_entry(i2c_priv, &driver_data.i2c_client_list,
 			    i2c_client_list_node) {
+		if (!i2c_priv->ready)
+			continue;
 		tfm_cnt = atomic_read(&i2c_priv->tfm_count);
 		if (tfm_cnt < min_tfm_cnt) {
 			min_tfm_cnt = tfm_cnt;
@@ -322,20 +324,24 @@ static int atmel_ecc_probe(struct i2c_client *client)
 		return ret;
 
 	i2c_priv = i2c_get_clientdata(client);
+	i2c_priv->ready = false;
 
 	spin_lock(&driver_data.i2c_list_lock);
 	list_add_tail(&i2c_priv->i2c_client_list_node,
 		      &driver_data.i2c_client_list);
+	i2c_priv->ready = true;
 	spin_unlock(&driver_data.i2c_list_lock);
 
 	ret = crypto_register_kpp(&atmel_ecdh_nist_p256);
 	if (ret) {
 		spin_lock(&driver_data.i2c_list_lock);
+		i2c_priv->ready = false;
 		list_del(&i2c_priv->i2c_client_list_node);
 		spin_unlock(&driver_data.i2c_list_lock);
 
 		dev_err(&client->dev, "%s alg registration failed\n",
 			atmel_ecdh_nist_p256.base.cra_driver_name);
+		return ret;
 	} else {
 		dev_info(&client->dev, "atmel ecc algorithms registered in /proc/crypto\n");
 	}
@@ -347,6 +353,10 @@ static void atmel_ecc_remove(struct i2c_client *client)
 {
 	struct atmel_i2c_client_priv *i2c_priv = i2c_get_clientdata(client);
 
+	spin_lock(&driver_data.i2c_list_lock);
+	i2c_priv->ready = false;
+	spin_unlock(&driver_data.i2c_list_lock);
+
 	/* Return EBUSY if i2c client already allocated. */
 	if (atomic_read(&i2c_priv->tfm_count)) {
 		/*
diff --git a/drivers/crypto/atmel-i2c.h b/drivers/crypto/atmel-i2c.h
index 72f04c15682f..e3b12030f9c4 100644
--- a/drivers/crypto/atmel-i2c.h
+++ b/drivers/crypto/atmel-i2c.h
@@ -129,6 +129,7 @@ struct atmel_ecc_driver_data {
  * @wake_token_sz       : size in bytes of the wake_token
  * @tfm_count           : number of active crypto transformations on i2c client
  * @hwrng               : hold the hardware generated rng
+ * @ready               : hw client is ready to use
  *
  * Reads and writes from/to the i2c client are sequential. The first byte
  * transmitted to the device is treated as the byte size. Any attempt to send
@@ -145,6 +146,7 @@ struct atmel_i2c_client_priv {
 	size_t wake_token_sz;
 	atomic_t tfm_count ____cacheline_aligned;
 	struct hwrng hwrng;
+	bool ready;
 };
 
 /**

base-commit: 5624ea54f3ba5c83d2e5503411a31a8be0278c1e
-- 
2.53.0

