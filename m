Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9046F2C029D
	for <linux-crypto@vger.kernel.org>; Sun,  7 Jun 2026 20:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780862529; cv=none; b=N5MO0XErT6u/cxQL0rGuF8VlPTtdAjIm3Eo0iGWJKvyqRomRSY9r/RZ4OLs2TP0Gg5FXYkBCs+V8btih1wcJV882vPt2TlpaDnEK6O6Q4b0cZzSpOecsoIVODKGJa4goy1vT9/Y2F526BntvbJUmMpHC2uhlEW3dh4UE23Jfxe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780862529; c=relaxed/simple;
	bh=Fr4JL6GbjKguwCehUmftZ0cXfJ+8xRNtKaxtyFIYf7Q=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=t2nQ0WLZU39EJ9cXySVJFT/PgF7YaUynHAi+UOTaUVOsyq8VSRMyNt16XtL8RbZsxZ3UEIIUMX9xeBsVL+RK2aJuVVoc+o7T0NVpIqmE1SWTe+vP5Nt1UOrR0/tlGvp1tDhJdf157+4Wid4duMoa6C8BbsdEOmzaLSSLYld4sds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=pG5G0gVm; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pG5G0gVm"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-490c28f84fdso5030985e9.0
        for <linux-crypto@vger.kernel.org>; Sun, 07 Jun 2026 13:02:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780862526; x=1781467326; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=RpOFBj23taOxwcprfVeftqLa7EfFOLIHW3Oby+mxG4c=;
        b=pG5G0gVmp+/052G58yIIH9HpWtBNnqsawWqdA0FcFTXvmzWrNsqmmfFhPYsY2aGIcM
         xWDGqlpx7AgG5hlmZKoIyMe/yStnZZS+lMjM0zEWIk7hoEbEWLCgM1g76S26AJErFE42
         d1BqUkgeaW6L3qEPrsmnHZ0uwyPj31BvLt0YAd1fVAE7zFYFzfiCA1GL/m2RbyCV8tZ1
         t0yqUOQQOV6By5wnILPiVRELuI5OvkW1xdM2h9wIcn11SNhW9cmq1vWW5SEkK91ypYAX
         GUh47gq5F9vaCMJg09+2t/2gjsBEo7f9RBB4V3EH+r+v/5ZTZdVXSeU5WBqjBFJ1Rstg
         MgNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780862526; x=1781467326;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RpOFBj23taOxwcprfVeftqLa7EfFOLIHW3Oby+mxG4c=;
        b=VNlN4jNt0GHahjwfcVm9ldW5bY6GH2+tkgJTch/JNHTK0U8RAR7rP9RU1tATxVSV1L
         K4WELxV7Ow/dV+qtDqlF/x4jOgcAy73WAog8RoF7vNZq9+cITLR3ob2i0cV56aHFkBOe
         8f//ZkLit7Hv/x0z9Jm7LTxuPLeDZzXf57uCm0A3qsRURpgMq23Wenl48cw3aYi3kgwa
         sduitsamQQFDbNU7PQ8EpkHtGb2hGneNKrE5YzBi5DhIPbe+d+JBNx0bNADMFVrHWACV
         ZtRZ7H+4vHNYizZx26KoPqupCp/tCMLfD0F25P0vZQJG/TOevcNlc4Ys25TnO5XAa+QD
         +ylQ==
X-Gm-Message-State: AOJu0YzThD8qGzPy0nWAaLCMOjcCzwV+47SEnLDJTSs/nuoa6Z1v0BEq
	9p58VtpDU3rS+pcxIFowJw1FJrYPBWuZpG1eCjDiIyc1ZYx2opkZ2ztG
X-Gm-Gg: Acq92OG7yr61iXuFfX3os2TJUnmDvAz+8qNkGdODaKr7SSatIgoaz7zKtatSBO8LFFK
	7jmmUtORq5T9BKpqwxAtV5BESE3l7KX4PoWMmh4g4YLmBIHzBpCY0LQZzt28oW31p/O2DSauNTD
	iLkwe4oBnTsH1kUubm1EAxyhnENrkQp8V0aBtoZlr8iwfpVNrnQHo/4kdJbntuGPYeaQxD2YeEn
	OADMRzFK+yjAHIzhufq4YJqJLrUGGuNkuAti42VNBq0pEF7m8BneFqDCoESGH07x5gh4zohADTT
	Sv4n/4HOJTIR6NtWvjgQcHxEsh0ADWwq3SzGzEjMR4eVDI/HRJCTV6V+WsoBUv3HkO0h9scK17Z
	gbxudwWXZKvPj3QctKxB+FhCPja77gr4qYh96hro3yBAEFKWoae3ijdovJTtLrzzB3O7CxxT9cN
	a9vY9wjRUi28lJlr4h8y/8zzDoLFqPLOTeZ4luGx+ADsqb5tRLoQ9bQGTAcnySSoq9vUzPc2AFF
	g==
X-Received: by 2002:a05:600c:190b:b0:485:c456:5e4f with SMTP id 5b1f17b1804b1-490c24f5f07mr94700135e9.0.1780862525816;
        Sun, 07 Jun 2026 13:02:05 -0700 (PDT)
Received: from menon.v.cablecom.net (84-74-0-139.dclient.hispeed.ch. [84.74.0.139])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490bc3b59f0sm388946455e9.2.2026.06.07.13.02.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Jun 2026 13:02:05 -0700 (PDT)
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
Subject: [PATCH v4 1/1] crypto: atmel-ecc - fix multi-device use-after-free and registration races
Date: Sun,  7 Jun 2026 20:02:02 +0000
Message-Id: <20260607200202.39550-1-l.rubusch@gmail.com>
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

2. The critical race condition problem: It exists when an Atmel device
instance is rapidly removed and immediately re-probed, before the global
resources are fully cleaned up. In this scenario, the asynchronous
unregistration sequence in the remove() lags behind the incoming probe()
function. Because of the global algorithm structure being not yet
completely cleaned up, the newly re-probed device incorrectly intercepts
the static, partially-dismantled global context. It then overwrites active
pointers and re-acquires the global instance prematurely. In this way, when
the deregistration sequence finally completes its execution, under the
newly initialized device, it may lose the tracking references, leaking the
older driver memory blocks, and introducing an immediate UAF risk.

3. The removal race problem, when a call to remove() starts removing the
device, but another thread executing a TFM, a severe Time-of-Check to
Time-of-Use (TOCTOU) race condition exists in the teardown path between the
asynchronous remove() sequence and completing TFMs. When the device is
unbound, the remove() function evaluates the active tfm_count and decides
whether to wait or proceed with resource deallocation. However, if the
final active TFM finishes its crypto operation and invokes the client free
function immediately after remove() performs its reference check but before
it can sleep, the completion signal is fired into a clearing state. The
unbind thread then misinterprets the zeroed counter, skips the
synchronization barrier entirely, and instantly deallocates the per-device
private structures. This leaves the final TFM worker thread executing code
inside a completely freed memory area, triggering an immediate UAF kernel
panic. Note, simply calling the kpp unregister here won't clean up the
situation in the context of having a setup with external hardware on a slow
bus.

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
 drivers/crypto/atmel-ecc.c | 130 +++++++++++++++++++++++++++++--------
 drivers/crypto/atmel-i2c.h |   3 +
 2 files changed, 106 insertions(+), 27 deletions(-)

diff --git a/drivers/crypto/atmel-ecc.c b/drivers/crypto/atmel-ecc.c
index 0ca02995a1de..7336c3661e52 100644
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
@@ -241,7 +246,10 @@ static void atmel_ecc_i2c_client_free(struct i2c_client *client)
 {
 	struct atmel_i2c_client_priv *i2c_priv = i2c_get_clientdata(client);
 
-	atomic_dec(&i2c_priv->tfm_count);
+	spin_lock(&driver_data.i2c_list_lock);
+	if (atomic_dec_and_test(&i2c_priv->tfm_count) && i2c_priv->unbinding)
+		complete(&i2c_priv->remove_done);
+	spin_unlock(&driver_data.i2c_list_lock);
 }
 
 static int atmel_ecdh_init_tfm(struct crypto_kpp *tfm)
@@ -276,7 +284,8 @@ static void atmel_ecdh_exit_tfm(struct crypto_kpp *tfm)
 	struct atmel_ecdh_ctx *ctx = kpp_tfm_ctx(tfm);
 
 	kfree(ctx->public_key);
-	crypto_free_kpp(ctx->fallback);
+	if (ctx->fallback)
+		crypto_free_kpp(ctx->fallback);
 	atmel_ecc_i2c_client_free(ctx->client);
 }
 
@@ -295,6 +304,28 @@ static unsigned int atmel_ecdh_max_size(struct crypto_kpp *tfm)
 	return ATMEL_ECC_PUBKEY_SIZE;
 }
 
+static int atmel_ecc_wait_for_tfms(struct atmel_i2c_client_priv *i2c_priv)
+{
+	unsigned long timeout;
+
+	spin_lock(&driver_data.i2c_list_lock);
+	list_del(&i2c_priv->i2c_client_list_node);
+	i2c_priv->unbinding = true;
+	reinit_completion(&i2c_priv->remove_done);
+	if (!atomic_read(&i2c_priv->tfm_count)) {
+		spin_unlock(&driver_data.i2c_list_lock);
+		return 0;
+	}
+	spin_unlock(&driver_data.i2c_list_lock);
+
+	timeout = wait_for_completion_timeout(&i2c_priv->remove_done,
+					      msecs_to_jiffies(2000));
+	if (!timeout)
+		return -ETIMEDOUT;
+
+	return 0;
+}
+
 static struct kpp_alg atmel_ecdh_nist_p256 = {
 	.set_secret = atmel_ecdh_set_secret,
 	.generate_public_key = atmel_ecdh_generate_public_key,
@@ -315,6 +346,7 @@ static struct kpp_alg atmel_ecdh_nist_p256 = {
 static int atmel_ecc_probe(struct i2c_client *client)
 {
 	struct atmel_i2c_client_priv *i2c_priv;
+	unsigned long timeout;
 	int ret;
 
 	ret = atmel_i2c_probe(client);
@@ -323,49 +355,93 @@ static int atmel_ecc_probe(struct i2c_client *client)
 
 	i2c_priv = i2c_get_clientdata(client);
 
+	init_completion(&i2c_priv->remove_done);
+	i2c_priv->unbinding = false;
+
 	spin_lock(&driver_data.i2c_list_lock);
 	list_add_tail(&i2c_priv->i2c_client_list_node,
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
+		if (timeout == 0) {
+			mutex_unlock(&atmel_ecc_kpp_lock);
+
+			ret = atmel_ecc_wait_for_tfms(i2c_priv);
+			if (ret)
+				dev_err(&client->dev,
+					"probe timed out, former instance active\n");
+			return -ETIMEDOUT;
+		}
+	}
+	if (atmel_ecc_kpp_refcnt == 0) {
+		ret = crypto_register_kpp(&atmel_ecdh_nist_p256);
+		if (ret) {
+			mutex_unlock(&atmel_ecc_kpp_lock);
 
-		dev_err(&client->dev, "%s alg registration failed\n",
-			atmel_ecdh_nist_p256.base.cra_driver_name);
-	} else {
-		dev_info(&client->dev, "atmel ecc algorithms registered in /proc/crypto\n");
+			atmel_ecc_wait_for_tfms(i2c_priv);
+			dev_err(&client->dev,
+				"%s alg registration failed\n",
+				atmel_ecdh_nist_p256.base.cra_driver_name);
+
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
+	bool wait_needed = false;
+	unsigned long timeout;
 
 	spin_lock(&driver_data.i2c_list_lock);
 	list_del(&i2c_priv->i2c_client_list_node);
+	i2c_priv->unbinding = true;
+	reinit_completion(&i2c_priv->remove_done);
+	if (atomic_read(&i2c_priv->tfm_count) > 0)
+		wait_needed = true;
 	spin_unlock(&driver_data.i2c_list_lock);
+	if (wait_needed) {
+		timeout = wait_for_completion_timeout(&i2c_priv->remove_done,
+						      msecs_to_jiffies(5000));
+		if (timeout == 0)
+			dev_emerg(&client->dev, "Teardown timed out! Active TFMs leaked, memory corruption imminent.\n");
+	}
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
index 72f04c15682f..8e6617422191 100644
--- a/drivers/crypto/atmel-i2c.h
+++ b/drivers/crypto/atmel-i2c.h
@@ -129,6 +129,7 @@ struct atmel_ecc_driver_data {
  * @wake_token_sz       : size in bytes of the wake_token
  * @tfm_count           : number of active crypto transformations on i2c client
  * @hwrng               : hold the hardware generated rng
+ * @unbinding           : unbinding handshake
  *
  * Reads and writes from/to the i2c client are sequential. The first byte
  * transmitted to the device is treated as the byte size. Any attempt to send
@@ -145,6 +146,8 @@ struct atmel_i2c_client_priv {
 	size_t wake_token_sz;
 	atomic_t tfm_count ____cacheline_aligned;
 	struct hwrng hwrng;
+	struct completion remove_done;
+	bool unbinding;
 };
 
 /**

base-commit: 79bbe453e5bfa6e1c6aa2e8329bfc8f152b81c9b
-- 
2.53.0

