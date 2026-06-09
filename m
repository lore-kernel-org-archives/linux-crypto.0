Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7054B381AE2
	for <linux-crypto@vger.kernel.org>; Tue,  9 Jun 2026 09:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780997377; cv=none; b=eSeGdMe6Bql+zAhbeaGykhUacqnxQKT1lRLqqczAAe0EZIaCiZETAJurnrMDeuWAh+fAqcE1fDbY/ox4dXX7yM0B9M4gMJNFlIpkP2oaxC2Gi21zaB09WMfvotg18w1KKQvhKP1NutvLRezCq+lMSqDbzGHHKQHACKI1iJ2YmRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780997377; c=relaxed/simple;
	bh=SWv11wCYu61f+IcG7zVETeOpr2/lPSaNxSQaOKvgyFI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=jo2ehRTIm9CZvphDDB4DOK4BL53ExYhu6AXhrJHtzKuncG0ev/lNSWVBx7bWqnPJCrz0Y5L3tfGr8l3GRoUf4EOqJs9ZG/GT1yfw19+hmyxAjMr+5B76T2k+kn6l1O+TGRtuMRfQmH9VExS4ZbfwA5mTxLLZqef4sKhc+KN9Qmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fA2m2xGE; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fA2m2xGE"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-45ef57256d8so462961f8f.3
        for <linux-crypto@vger.kernel.org>; Tue, 09 Jun 2026 02:29:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780997374; x=1781602174; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=pRzTXFA5FdxPZzzcvlQRBiMd6g7fdENgr5qKURqqC88=;
        b=fA2m2xGEBE7d5I2DYIxEW6q1kNTJevAZhOy+Am/Vhn/vJS0b+KqlmzopiBPHdO3TS/
         s7BH3DUZI2J0z8lcPefGXPoDOCQBfVp1nrPKQ58kFSG5nUGDce9LjnjY6zkoIGx3fkxG
         JgcLZepCdRfUL6Wcg4B/4egg27LxXaRKnpSwUh5lLDhVLy/klE03hQey3/q2VDsyg0Fx
         lCxs0TrvpB5o2fWiSjj3iXIJxaQhaj/8z8tIQHerrqGHZaqF9xMcdROZtPyY4ksi3iga
         EXuspry+H+aD3icuB3hH421L1gQlMbntFcvc1w/rStbhpa7b6V+K1ein8FJ1AEsXYVhM
         fM2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780997374; x=1781602174;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pRzTXFA5FdxPZzzcvlQRBiMd6g7fdENgr5qKURqqC88=;
        b=iFGXFGOc1QpzgTAUuMZMI18GP0Srg//ywDeQt2Yc6RWycr19Dr5s9W4UbyEcVKjpXY
         24W6FzcBozrdiXIJa6RcfulDGTunLHMfJ7UYJhEAMDNbzNN02jLI/+sFmAWkhbju2i3e
         8kr52Fm+5MVvcxonCjOLEGCR7L5O/o8qDFYEtbuBHTSUj2xWX15LB+LlRB4BHl7prW+j
         aJVi8bI6ZQ4I7IJc9wHW4jmjABw9UdtYr9sMYHYHwL1aO45kVB8wkx4iU6fBSHdeB7pK
         lbJTyUE0owA/Us8NDfEk7mV9mjVj1vqtJaoep3wUyjYRirC4TqgdEV6rnUhTlOWzCjmF
         8UOw==
X-Gm-Message-State: AOJu0YzwFLeRR0YEhB3hZN5+/PuHS7SfQFqxYbduLG5Mh/o4hQEIVK8t
	FXOWLSzR0w3XIBAY0SPGVOxu/EeSE/fwFfFmzKdPUvpmjnv+x6E50I/Y
X-Gm-Gg: Acq92OG9AxOqUV1YJijwJrHeg2F7hVPMwroN+ai+DE96O7fXW5ajwYACu91QdgQiTUm
	s117outj9VwuNLYC7M3f69nN0GICzMCTM8rHDDW/QPfLd4+FWjn0trZsyB6vPEyWYAiJq5VTRuh
	2x5xb8lYCkxbO0VWmGhMpn5zkGSlGexAvLLKy7dm6j2/iYYDOhIG6cf2VZqKcnrME8mUYEsaU8p
	KXAQCphsVX0AzeQZtq/atRG39EBZz7NFk59ekFPrx385WUAL6FU1jQ3FHOT5EZKJEklnc6IIh+K
	MFbCJVC3OU5NpelyHR6T5ASvq4X09qZIG8TgunC7gcQeT/WfljsUY2UnEhT/m9M3FaDYbbzz3WU
	I9IV5JzcVv1z+NxrvxwIhDP+NNX8jY1dzXTHjE/a1AH/VZw0mzqnoUqp1rM7/tKxIDChQUmUnTk
	eUW6gCh9Qk5xX2iIyNCDk3KSm4BsuSd7qtGRkzqarKPNt7t2nEArnNl3LV8QHJr7dzRTWBaSHCa
	C59iIZARl0U
X-Received: by 2002:a05:600c:45d1:b0:490:9f89:7eba with SMTP id 5b1f17b1804b1-490c2609e2fmr128490115e9.5.1780997373485;
        Tue, 09 Jun 2026 02:29:33 -0700 (PDT)
Received: from menon.v.cablecom.net (84-74-0-139.dclient.hispeed.ch. [84.74.0.139])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490c2d52e5esm226021065e9.2.2026.06.09.02.29.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2026 02:29:32 -0700 (PDT)
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
Subject: [RFC PATCH v6 1/1] crypto: atmel-ecc - fix multi-device use-after-free and registration races
Date: Tue,  9 Jun 2026 09:29:27 +0000
Message-Id: <20260609092927.47222-1-l.rubusch@gmail.com>
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
RFC: feedback and probably architectural decision needed

The current atmel-ecc driver contains instabilities which should be fixed.
At least the situation with the i2c_client_list and the kpp registration.
Ideally we should have one algorithm registration, but one or multiple
device instances on the i2c list and ensure this to happen as originally
also designed by providing this i2c_client_list approach, which I highly
appreciate. The problematic remove() situation is another known topic here.
Probably more theoretically, but it was commented already before. As also
teardown synchronization might affect probe(), this is a round-trip to open
issues at the i2c list and kpp registration.

While my patch adresses and attempts to fix the above mentioned problems.
The following dilemma is popping up, getting flagged in both cases by
sashiko.

A) Applying unbound wait
Using wait_for_completion() assures waiting for all active TFMs to clear.
Nevertheless, it carries the risk of waiting infinitely.

B) Timed wait
Using wait_for_completion_timeout() avoids infinite waits. Nevertheless, it
introduces the risk of a UAF. In case of an aborting probe() or remove(),
any TFM in progress being cut off devres memory.

Questions:
1. First, please review the current state of the fixes elaborated with
sashiko feedbacks. Do you agree to the approach taken? Do you disagree and
why? Please, let me know what you think.

2. Initially I tried to separately only present a (kind of) fix to problem
1 (v1). Since everything seems to be somehow intertwined, I've put them
together, which increases complexity leading to a huge commit message.
Shall I split or shall I leave it together?

3. Do you see an alternative? If you agree, then which direction you would
like me to take here, A or B? The alternative, I can see here is, we also
could move away from `devm_` memory resources to active
allocation/deallocation in probe here to avoid the UAF.

v5 -> v6:
- RFC
- going back to using timeouts as in v4
- removing redundant code
v4 -> v5:
- sashiko warning: revert wait_for_completion_timeout() by
  wait_for_completion() when former instance still active at probe()
- change return type of atmel_ecc_wait_for_tfms() to void
v3 -> v4:
- sashiko warning: replace wait_for_completion() by
  wait_for_completion_timeout() in remove; decision is a kind of dilemma
- move redundant code of this fix out into a separate function
- make also use of the wait_for_completion_timeout() function at probe for
  convenience
v2 -> v3:
- sashiko warning: fix missing init_completion() for remove_done
- add comment naming all three related main problem situations
v1 -> v2:
- remove the initial approach with "ready" state bool, replace it by
  this be a more comprehensive approach

 drivers/crypto/atmel-ecc.c | 134 +++++++++++++++++++++++++++++--------
 drivers/crypto/atmel-i2c.h |   3 +
 2 files changed, 108 insertions(+), 29 deletions(-)

diff --git a/drivers/crypto/atmel-ecc.c b/drivers/crypto/atmel-ecc.c
index 0ca02995a1de..702d988a6547 100644
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
 
@@ -295,6 +304,26 @@ static unsigned int atmel_ecdh_max_size(struct crypto_kpp *tfm)
 	return ATMEL_ECC_PUBKEY_SIZE;
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
@@ -315,6 +344,7 @@ static struct kpp_alg atmel_ecdh_nist_p256 = {
 static int atmel_ecc_probe(struct i2c_client *client)
 {
 	struct atmel_i2c_client_priv *i2c_priv;
+	unsigned long timeout;
 	int ret;
 
 	ret = atmel_i2c_probe(client);
@@ -323,49 +353,95 @@ static int atmel_ecc_probe(struct i2c_client *client)
 
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
+
+			atmel_ecc_wait_for_tfms(i2c_priv, 2000);
+			dev_err(&client->dev,
+				"%s alg registration failed\n",
+				atmel_ecdh_nist_p256.base.cra_driver_name);
 
-		dev_err(&client->dev, "%s alg registration failed\n",
-			atmel_ecdh_nist_p256.base.cra_driver_name);
-	} else {
-		dev_info(&client->dev, "atmel ecc algorithms registered in /proc/crypto\n");
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
+	bool trigger_unreg = false;
 
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

base-commit: 79bbe453e5bfa6e1c6aa2e8329bfc8f152b81c9b
-- 
2.53.0

