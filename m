Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FCB7313E2B
	for <linux-crypto@vger.kernel.org>; Sat,  6 Jun 2026 20:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780776694; cv=none; b=X+qrj+xYjznouZBFXcASAThDz08oTFL6WwBOMU2k2GanJPIDfy2c1gotD41jS0pW7aKl+gJEryWpmiK8RQKNOlC+MjJb4RaiYd/ztfA7KBr7F+L7ghnUYWyOxBswsxaRcW7C1fOG/BjolAhc4EHbbcd+ZjMTIIXt1OVVf+T+LdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780776694; c=relaxed/simple;
	bh=w3sIkzZ8sJKLLi/G4Ikcs7T8/ELzxdVP4zO12xpcCko=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=AcmDmN+AGzENrkqWF+bO82yU6JF0nYQZKe+lveyKdiXHqgaIva/MrCXavewsZoYqFqcS95Ziwp2mWegfydkTa3cwq4bwckmmaAY90ZRb5AUtsD1qmdn42JdkuGgTBxZiWQ66/8ozB2le50ZtNTAlrLjLINL2D9O5Bfq5mNOFbQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=syZ93O2s; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="syZ93O2s"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-490b8adf7efso1808305e9.1
        for <linux-crypto@vger.kernel.org>; Sat, 06 Jun 2026 13:11:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780776691; x=1781381491; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=dOOnGKhqXgyE5tvsSDo31ys2lneC3zZUQbZqWGyQ4jY=;
        b=syZ93O2sDZWotHiU4+1PXT0wZXBMuLwYE46YbkOfJmccZvhpCAXncx7UsGIdygWnkB
         pic+1pS/i6X2hU174jlgLWIAVSradYynZaayLBqCejwb7OtAnUgQogsZavRAKNlnbCTQ
         3lWkUHFRQ8lCPubXoQd+yfQVdJ0AJr04Bkk6PhXbnxPMSsNbwks0jRBGBh8E6a1ZQ2tD
         nz/dLezEWHyWyGV7fIUiKr3bC+dY8nb9qo/xaTyhrT+Tw5BChSkHJnzYYLgDlML8zyQd
         s/TlqM4X1GpWVmE8wEpayTTuwl0m6jwFoYCqC232JUfsN2Np1sr2oV1qQbT87Kb/1wa4
         GCzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780776691; x=1781381491;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dOOnGKhqXgyE5tvsSDo31ys2lneC3zZUQbZqWGyQ4jY=;
        b=qFBXQVIql/rg1cJvc5y3Qh8jdoRNvLYVWvupD6OuSzPnYErbsFP2dRpLjAtqWyCsEr
         JJzLkp+i+8HimLr99U5urW2Vr0oq96+LQZRFvpy3PQTauo41AIEZybnvinCSrRJbCwE9
         5tMCMegqzgEsTlP1eMszl+h8gTnTXhf8rTCfIBurSugbtP4/rVaYz0yhC5yVj7iU4bZs
         G0y0EKaOTJUzCdT6Ka+Wk8MPDPoKCxbT84rurMLxY0DurWc47F5JWdrIQJTacRPfhqfC
         Qr3w+WkXWhixXwbhaXvk2gaC5HZPZZJuIQCR0wQlrVNliVRSIeSrNjRs8Ycxwc8YjKuO
         rICQ==
X-Gm-Message-State: AOJu0YwDsO8ay/iKUPpGBZ4nOfanuwrxun2EQfHwW0hnjtUkLiE6GcHk
	mdP6dmzeVLeBbhlTNlQGVvITEuyl7VBhQWEkV+Hz51f96hJU9qie/sot
X-Gm-Gg: Acq92OF/0csfduocQC0vbAX68S4AN1hA0wKP98Jgb3+AvdKSODvBxDnWOHaMAdgOgdZ
	N3sdOucZwajhTMBRLROwLX1zNpz3CPm4/eNoH0zAhb9oz9XV8sIo4kvFOPGLLBQu59ussjvCjOx
	5ZC6ujtOgLlS7ES4Xx7oWQUYckHGLXGF/+QTF1EXIOpXljLe9nMvmmsNi4bVo0oulkJnf6bZHh7
	j0PYCDmJB5p6dektp29htxnqMrYFgev0L895K91b2Rvr124qYK8vaWZsOvEcJjgeEu7wMAz+rCm
	FL66UuNpHszqfRikdG/S1eDbFoTTsxeFp7pFvZBcDXgOyY7iUP3Mwry6Wd7eb10ES6C8YXY5nn4
	s+YGwsC8Y3MBNO1rNF4MFUc7ft2aU/qhV7K3UfWBoi/+Q+DkC4PoOrDECJyiJnNCGwhtVIn6cGK
	nx4No62Uo+zTbq/U8BXuz1LmuhVMT9zof6IDMgJGtbk3Uc7TZRpzJNz68y0kbN76Yll5ZRfvzrL
	g==
X-Received: by 2002:a05:600c:a011:b0:488:7e7b:dbc2 with SMTP id 5b1f17b1804b1-490c25dcc9bmr64016335e9.3.1780776691198;
        Sat, 06 Jun 2026 13:11:31 -0700 (PDT)
Received: from menon.v.cablecom.net (84-74-0-139.dclient.hispeed.ch. [84.74.0.139])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490bc3fd663sm289512465e9.10.2026.06.06.13.11.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Jun 2026 13:11:30 -0700 (PDT)
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
Subject: [PATCH v2 1/1] crypto: atmel-ecc - fix multi-device use-after-free and registration races
Date: Sat,  6 Jun 2026 20:11:20 +0000
Message-Id: <20260606201120.35536-1-l.rubusch@gmail.com>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

During parallel driver initialization or driver teardown sequences
in setups with multiple atmel-ecc instances, a race condition exists
between atmel_ecc_i2c_client_alloc() and the probe/remove paths.

A concurrent transformation request can fetch an i2c_client instance
from the global i2c_client_list before the kpp is fully registered, or
while it is actively being unbound, resulting in a use-after-free (UAF)
risk.

1. The initialization problem in probe(): Adding first an i2c client to the
i2c_client_list, and then registering the kpp algorim may result in a race,
when this happens for a second (or further) probed device. In this case the
algorithm is already registered, so a TFM may arrive, while the latest
probing device is added to the list, but not kpp registered. In case this
fails and this last device is going to be removed again from the list, this
leaves a window where the TFM might obtain a pointer to the - now deleted -
i2c client, which opens a UAF risk. Furthermore, there will happen atempts
to multiple registering the same driver to the same type of algorithm.
Note, a simple reverting of the order: first register kpp, second add the
i2c client to the i2c_client_list - is not possible here, since the kpp
registration immediately triggers the self tests, which then will allocate
and require an i2c client.

2. The removal problem, also related to the re-initialization in particular
scenarios where this might happen to quick, might result in overwriting not
fully freed memory resources. The remove might still take time, a
re-probing then overwrite the (still existing) static resource without
having it before cleaned up before. Here were additional issues with the
order of when to remove the i2c client from the i2c_client_list but already
having removed the resources.

Address this by implementing an independent subsystem reference counter
kpp refcnt protected by a dedicated mutex to ensure the static global kpp
algorithm structure is registered exactly once by the first probing device
instance. In multi-device scenarios, or when extending the resource
management support of the i2c_client_list to all atmel-i2c based device
drivers, such scenarios can become realistic. The particular algorithm is
registered only once. Each i2c client (i.e. each probing device driver) is
added as client to the i2c_client_list. This guarantee that only the first
probe will register the algorithm. The list is populated for further calls
to probe, and subsequent calls to the client alloc function.

Concurrently, decouple list mutations from registration by moving the
global list eviction to the absolute top of the remove lifecycle. This
keeps the quick execution of the list allocation loop intact, ensures that
unbinding hardware is instantly blind to the rest of the system, and
completely bypasses the recursive deadlock condition previously triggered
by synchronous crypto API self-tests.

Fixes: 11105693fa05 ("crypto: atmel-ecc - introduce Microchip / Atmel ECC driver")
Signed-off-by: Lothar Rubusch <l.rubusch@gmail.com>
---
v1 -> v2:
- remove the initial approach with "ready" state bool, replace it by
  this be a more comprehensive approach

 drivers/crypto/atmel-ecc.c | 96 +++++++++++++++++++++++++++-----------
 drivers/crypto/atmel-i2c.h |  1 +
 2 files changed, 70 insertions(+), 27 deletions(-)

diff --git a/drivers/crypto/atmel-ecc.c b/drivers/crypto/atmel-ecc.c
index 0ca02995a1de..0f1567bf23b7 100644
--- a/drivers/crypto/atmel-ecc.c
+++ b/drivers/crypto/atmel-ecc.c
@@ -23,6 +23,11 @@
 #include <crypto/kpp.h>
 #include "atmel-i2c.h"
 
+static DEFINE_MUTEX(atmel_ecc_kpp_lock);
+static int atmel_ecc_kpp_refcnt;
+DECLARE_COMPLETION(atmel_ecc_unreg_done);
+static bool atmel_ecc_unreg_active;
+
 static struct atmel_ecc_driver_data driver_data;
 
 /**
@@ -241,7 +246,8 @@ static void atmel_ecc_i2c_client_free(struct i2c_client *client)
 {
 	struct atmel_i2c_client_priv *i2c_priv = i2c_get_clientdata(client);
 
-	atomic_dec(&i2c_priv->tfm_count);
+	if (atomic_dec_and_test(&i2c_priv->tfm_count))
+		complete(&i2c_priv->remove_done);
 }
 
 static int atmel_ecdh_init_tfm(struct crypto_kpp *tfm)
@@ -276,7 +282,8 @@ static void atmel_ecdh_exit_tfm(struct crypto_kpp *tfm)
 	struct atmel_ecdh_ctx *ctx = kpp_tfm_ctx(tfm);
 
 	kfree(ctx->public_key);
-	crypto_free_kpp(ctx->fallback);
+	if (ctx->fallback)
+		crypto_free_kpp(ctx->fallback);
 	atmel_ecc_i2c_client_free(ctx->client);
 }
 
@@ -315,6 +322,7 @@ static struct kpp_alg atmel_ecdh_nist_p256 = {
 static int atmel_ecc_probe(struct i2c_client *client)
 {
 	struct atmel_i2c_client_priv *i2c_priv;
+	unsigned long timeout;
 	int ret;
 
 	ret = atmel_i2c_probe(client);
@@ -328,44 +336,78 @@ static int atmel_ecc_probe(struct i2c_client *client)
 		      &driver_data.i2c_client_list);
 	spin_unlock(&driver_data.i2c_list_lock);
 
-	ret = crypto_register_kpp(&atmel_ecdh_nist_p256);
-	if (ret) {
-		spin_lock(&driver_data.i2c_list_lock);
-		list_del(&i2c_priv->i2c_client_list_node);
-		spin_unlock(&driver_data.i2c_list_lock);
+	mutex_lock(&atmel_ecc_kpp_lock);
+	/*
+	 * For cases where the same/last such device is still in unregistering,
+	 * and now re-registering (refcnt is 0, but completion still exists).
+	 * Safely capture the pointer, drop the lock and sleep until it
+	 * terminates upon completion or retry limit reached.
+	 */
+	while (atmel_ecc_unreg_active) {
+		mutex_unlock(&atmel_ecc_kpp_lock);
+		timeout = wait_for_completion_timeout(&atmel_ecc_unreg_done,
+						      msecs_to_jiffies(2000));
+		mutex_lock(&atmel_ecc_kpp_lock);
+
+		if (timeout == 0) {
+			spin_lock(&driver_data.i2c_list_lock);
+			list_del(&i2c_priv->i2c_client_list_node);
+			spin_unlock(&driver_data.i2c_list_lock);
+			mutex_unlock(&atmel_ecc_kpp_lock);
+
+			dev_err(&client->dev, "probe timed out, former driver instance not fully deregistered\n");
+			return -ETIMEDOUT;
+		}
+	}
 
-		dev_err(&client->dev, "%s alg registration failed\n",
-			atmel_ecdh_nist_p256.base.cra_driver_name);
-	} else {
-		dev_info(&client->dev, "atmel ecc algorithms registered in /proc/crypto\n");
+	if (atmel_ecc_kpp_refcnt == 0) {
+		ret = crypto_register_kpp(&atmel_ecdh_nist_p256);
+		if (ret) {
+			spin_lock(&driver_data.i2c_list_lock);
+			list_del(&i2c_priv->i2c_client_list_node);
+			spin_unlock(&driver_data.i2c_list_lock);
+			mutex_unlock(&atmel_ecc_kpp_lock);
+
+			dev_err(&client->dev, "%s alg registration failed\n",
+				atmel_ecdh_nist_p256.base.cra_driver_name);
+			return ret;
+		}
 	}
+	atmel_ecc_kpp_refcnt++;
+	mutex_unlock(&atmel_ecc_kpp_lock);
 
+	dev_info(&client->dev, "atmel ecc algorithms registered in /proc/crypto\n");
 	return ret;
 }
 
 static void atmel_ecc_remove(struct i2c_client *client)
 {
 	struct atmel_i2c_client_priv *i2c_priv = i2c_get_clientdata(client);
-
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
-	crypto_unregister_kpp(&atmel_ecdh_nist_p256);
+	bool trigger_unreg = false;
 
 	spin_lock(&driver_data.i2c_list_lock);
 	list_del(&i2c_priv->i2c_client_list_node);
 	spin_unlock(&driver_data.i2c_list_lock);
+
+	mutex_lock(&atmel_ecc_kpp_lock);
+	atmel_ecc_kpp_refcnt--;
+	if (atmel_ecc_kpp_refcnt == 0) {
+		trigger_unreg = true;
+		atmel_ecc_unreg_active = true;
+		reinit_completion(&atmel_ecc_unreg_done);
+	}
+	mutex_unlock(&atmel_ecc_kpp_lock);
+
+	if (atomic_read(&i2c_priv->tfm_count))
+		wait_for_completion(&i2c_priv->remove_done);
+
+	if (trigger_unreg) {
+		crypto_unregister_kpp(&atmel_ecdh_nist_p256);
+		mutex_lock(&atmel_ecc_kpp_lock);
+		atmel_ecc_unreg_active = false;
+		complete_all(&atmel_ecc_unreg_done);
+		mutex_unlock(&atmel_ecc_kpp_lock);
+	}
 }
 
 static const struct of_device_id atmel_ecc_dt_ids[] = {
diff --git a/drivers/crypto/atmel-i2c.h b/drivers/crypto/atmel-i2c.h
index 72f04c15682f..d957c2ff60d8 100644
--- a/drivers/crypto/atmel-i2c.h
+++ b/drivers/crypto/atmel-i2c.h
@@ -145,6 +145,7 @@ struct atmel_i2c_client_priv {
 	size_t wake_token_sz;
 	atomic_t tfm_count ____cacheline_aligned;
 	struct hwrng hwrng;
+	struct completion remove_done;
 };
 
 /**

base-commit: 5624ea54f3ba5c83d2e5503411a31a8be0278c1e
-- 
2.53.0

