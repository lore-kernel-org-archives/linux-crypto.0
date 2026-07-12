Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EC9815E5DC
	for <linux-crypto@vger.kernel.org>; Sun, 12 Jul 2026 20:02:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783886534; cv=none; b=ZJUf6/UVQOs8ai+R4n+Ey4Ke8Nsg2EpLOP65r1IqDlaohANX6ftmJNlSxwqLuSvhsG+W5XNRATRGRAMiF8K+A59DhI8fzDqEZh2h99WFifz5iKFdXWkJrMKLs3+Ae/LZ3qBGULtPsaL3geYbCKE/075RUOmwGZcTSUZW3Cd/tW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783886534; c=relaxed/simple;
	bh=qL8FM6AVnZAnuA9XulnK6ooND0raI6K+9KU3zSmwtUI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=g3vHgvPctzNY33dDUMQOKTGCh29uV52w7uxI8DW74KFoCUYJ84xpgeVpxllDs2DT4fCfhgkuwBRU3AhFltaUlVm0wLrJyd2B3WExd7T88JoQFstc1Fs8fi88svFOeLrGfy9HzxXknP0N9xLlNMxWhCSlA1WE5QpgaO72Vh5NYyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FokmABC/; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FokmABC/"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-493c2c7770bso1982255e9.1
        for <linux-crypto@vger.kernel.org>; Sun, 12 Jul 2026 13:02:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783886531; x=1784491331; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=my9baOCRIbPqjbDoPiN9p6z8vQOZ+uD4vuxAZjcqRYg=;
        b=FokmABC/r5RPNb8RB+9qsS+YZC0zGvhYwIkPCFyY3GU0kk400nRTq3nQAD4CbtsrtN
         XZodQIok6Naeudgd2cZrsR7jZKR2rUVnptGi9WqJ3SHkObL6CT6lucOVQl/OP2Ru1Ce/
         7Bggoat08uSpGvjOCkZRmJatgv+AXPPuXw8P33etQvlaxl0Lm9PckdIlYQ83xL6SVWSA
         fqM8ONepIePQf3WtCKhZBYngpIthyd8M2nA0T+Ng3KHqpj9Ko35EFelofJe/ciJRnn9p
         Qv6KG9Iu6eKeVYGk9ANMc5zbNqjHp6q21/ZkggpjP0kmKOcl+C/lIXa8HbaAMXANko+J
         SlUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783886531; x=1784491331;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=my9baOCRIbPqjbDoPiN9p6z8vQOZ+uD4vuxAZjcqRYg=;
        b=ZLY4lG076AR/xUX4ZB5ElLTyFdRzPfX/4o8HkKv8TDDTQp0UQJGh6DzEW2QYqu8RBV
         nFQk0I3tzb2p0fHG7tZFfR8AQF6j7TIWuZ264Vy0txyhaeZBEj/XWyP88Arfq+pZPTk+
         k6dlssnEIpc92YW9JPSLN0FsZrpZE+HSYNaSAeBPp/Fwqr96gX6KbUWzzPJ0/oUledPE
         iIeSAMxgnn5h6qXzCPHIXt3O9OERH6AH8CYQ8RWvuNNxqGUncIFaRo7YTYJtK/hGXoQR
         5Kwi5G33eT4ox1PtYzcd4cHKsyFhCafvNcNU5rJJQECuXGrZeNIJrdtXzWe3Zr1seTBZ
         jSMw==
X-Gm-Message-State: AOJu0Yx4ZuYX9835CX24OUYyfSGGabR57Zb1yiqWYKPZDSzyNJk2lD00
	mPSjUEIs7J86rEqWF5vuH0pQd2k9wMbgmjriwSJ/jxvHl6rZK2rnDXvP
X-Gm-Gg: AfdE7clkkh03tGvkOkHf/k0cmK2lErRhPb9zc/H74pgEUzptraVDvL8pC0aYIan6x42
	wMfOURFUYZ1S51QN7VdIaCcv4obeeDmIbqZuT6zKPll8o+FfDFpxym3at0IDjasaWdyJUMsaNDT
	74c1eet5D20EHedPx1jJsVtdwMQH31urbv7Rg+LUeT948rG+MGCkmxWvi2E/fbbAWH1HESaTPTv
	uKR/giBl4/EcQ6PBlfaCZPutla70ON+0RZHDRnhDmQz8s6I3EKdgyf6hCxa5OVUw3ycCJ1oCygO
	9skMW+ekyFOCfq8aSo8Sd7W80zPExwvBeEQFujTVTnPeimnkE2ndwN2uagJpWl3PlN8Tis3p8H/
	NdYgnFS9wGhNHILov1ihH1JzWz92Cfso0P3wh9aOfPzgvOe3pJNLvEODZPDNNDj71m+wuLupnM8
	NdGvWGmWOa9wu72Obyf+9gbCW+7niPGYATgwdn6ZR5HIoIrO7R7n8rwlzLVt/pzPc=
X-Received: by 2002:a05:600c:3f12:b0:493:e536:7bcf with SMTP id 5b1f17b1804b1-493f8865dfdmr40375275e9.7.1783886530426;
        Sun, 12 Jul 2026 13:02:10 -0700 (PDT)
Received: from menon.v.cablecom.net (84-74-0-139.dclient.hispeed.ch. [84.74.0.139])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493eb73b161sm277347275e9.9.2026.07.12.13.02.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jul 2026 13:02:09 -0700 (PDT)
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
Subject: [RFC RESEND PATCH v6 1/1] crypto: atmel-ecc - fix multi-device use-after-free and registration races
Date: Sun, 12 Jul 2026 20:02:03 +0000
Message-Id: <20260712200203.47764-1-l.rubusch@gmail.com>
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
Assisted-by: Gemini:1.5-Pro [google]
---
 drivers/crypto/atmel-ecc.c | 136 +++++++++++++++++++++++++++++--------
 drivers/crypto/atmel-i2c.h |   3 +
 2 files changed, 109 insertions(+), 30 deletions(-)

diff --git a/drivers/crypto/atmel-ecc.c b/drivers/crypto/atmel-ecc.c
index 8e13aeccf011..a9146f892823 100644
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
@@ -232,7 +237,10 @@ static void atmel_ecc_i2c_client_free(struct i2c_client *client)
 {
 	struct atmel_i2c_client_priv *i2c_priv = i2c_get_clientdata(client);
 
-	atomic_dec(&i2c_priv->tfm_count);
+	spin_lock(&driver_data.i2c_list_lock);
+	if (atomic_dec_and_test(&i2c_priv->tfm_count) && i2c_priv->unbinding)
+		complete(&i2c_priv->remove_done);
+	spin_unlock(&driver_data.i2c_list_lock);
 }
 
 static int atmel_ecdh_init_tfm(struct crypto_kpp *tfm)
@@ -266,7 +274,8 @@ static void atmel_ecdh_exit_tfm(struct crypto_kpp *tfm)
 	struct atmel_ecdh_ctx *ctx = kpp_tfm_ctx(tfm);
 
 	kfree(ctx->public_key);
-	crypto_free_kpp(ctx->fallback);
+	if (ctx->fallback)
+		crypto_free_kpp(ctx->fallback);
 	atmel_ecc_i2c_client_free(ctx->client);
 }
 
@@ -277,6 +286,26 @@ static unsigned int atmel_ecdh_max_size(struct crypto_kpp *tfm)
 	return crypto_kpp_maxsize(ctx->fallback);
 }
 
+static int atmel_ecc_wait_for_tfms(struct atmel_i2c_client_priv *i2c_priv,
+				   unsigned long timeout)
+{
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
+	if (!wait_for_completion_timeout(&i2c_priv->remove_done,
+					 msecs_to_jiffies(timeout)))
+		return -ETIMEDOUT;
+
+	return 0;
+}
+
 static struct kpp_alg atmel_ecdh_nist_p256 = {
 	.set_secret = atmel_ecdh_set_secret,
 	.generate_public_key = atmel_ecdh_generate_public_key,
@@ -297,6 +326,7 @@ static struct kpp_alg atmel_ecdh_nist_p256 = {
 static int atmel_ecc_probe(struct i2c_client *client)
 {
 	struct atmel_i2c_client_priv *i2c_priv;
+	unsigned long timeout;
 	int ret;
 
 	ret = atmel_i2c_probe(client);
@@ -305,49 +335,95 @@ static int atmel_ecc_probe(struct i2c_client *client)
 
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
+			/*
+			 * FIXME / RFC: If we time out here, returning -ETIMEDOUT
+			 * triggers devres cleanup, causing a UAF for any lagging TFMs.
+			 * Should this be changed to an unbounded wait_for_completion()
+			 * to prioritize memory safety over thread liveness?
+			 */
+			if (atmel_ecc_wait_for_tfms(i2c_priv, 2000))
+				dev_emerg(&client->dev,
+					  "Probe abort timed out! Active TFMs leaked, memory corruption imminent.\n");
+			else
+				dev_err(&client->dev,
+					"Probe timed out waiting for former instance unregistration\n");
+
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
+			atmel_ecc_wait_for_tfms(i2c_priv, 2000);
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
+	bool trigger_unreg = false;
+
+	/*
+	 * FIXME / RFC: The timeout prevents a permanent hang,
+	 * but since remove() returns void, devres will instantly
+	 * free i2c_priv anyway. Memory corruption is imminent
+	 * when the active TFM eventually closes.
+	 */
+	if (atmel_ecc_wait_for_tfms(i2c_priv, 5000))
+		dev_emerg(&client->dev,
+			  "Teardown timed out! Active TFMs leak, memory corruption imminent.\n");
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
 	}
-
-	crypto_unregister_kpp(&atmel_ecdh_nist_p256);
-
-	spin_lock(&driver_data.i2c_list_lock);
-	list_del(&i2c_priv->i2c_client_list_node);
-	spin_unlock(&driver_data.i2c_list_lock);
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

base-commit: e264401ce4776a288524e5b87593d4d864147115
-- 
2.53.0

