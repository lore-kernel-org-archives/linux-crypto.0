Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B535E37CD4A
	for <linux-crypto@vger.kernel.org>; Fri, 22 May 2026 23:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779490905; cv=none; b=BNfT0DhtbGvyz3A0AoAauHh0FJndULG8GOH+/6l1lEFFayCqJsg9XeH48HEngKOYc7B1hKBS+961SZbWY/ZGqndzc9FBxohkMAEtjyiDbE6TPNEiCfvyli6bN0B2gIPtQMO1ux7Pb5p1/El3JOdmn8+upI3Y4iCJtBWKTWNmH9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779490905; c=relaxed/simple;
	bh=nsNvnSO+5T+Nj0B0DFFIY3h9EpY8d8S0QFcXa60qh7g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=cx3n8dj8W+CxoGnZCLnhlkBVS8ydy/UdZ0R5Kt2fgb7we2UZTkSKYi7H4bsI1+KMdaDl4tHwodxeDfv3Ke5WfUsmZ9Uh4ZJGK5xC8LUcGOAOgUhcEUuEHiKVS5O9XbM734CjOFsYzJWJZPVd9aujrnmfkjCDPKgncawYZB3C5jE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Irz/Ey2S; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Irz/Ey2S"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-45e6c2d9c5cso724167f8f.1
        for <linux-crypto@vger.kernel.org>; Fri, 22 May 2026 16:01:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779490902; x=1780095702; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r1V+f8VZ/BVcHT7ioxjC934CpqH8W/zfFq5YGMNwGR4=;
        b=Irz/Ey2SLQ8vE/94bKmOy9hXb4VobCz4iPKfEsn+8Cr53S1WXpBfOC7rf0y6PahkvU
         V52/LvIuzYHkSwYqyhODNChBy6VuJhSRnFod8tPyyTfjJHmtNMGMeeQdLIGYP9GHZssm
         /Ren52AalmsjvYhWNEMcF23k/OcJifpIQGkPqxifmtuB+aPlpbuIX+LTulIdByt9MRqz
         g9Weffuk5yguZ/7Q9wUd+z+ffAFLx3xvSohPe+OqFP0EZK7D53RpiCARnJg52UA+Wv6I
         dpw7wkkQUszmsrOQ8Qz4Xl/rOMsM54FmI+ep41OPzunB6ZJEsAFyx2Fqrhja2aINH5nm
         HCpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779490902; x=1780095702;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=r1V+f8VZ/BVcHT7ioxjC934CpqH8W/zfFq5YGMNwGR4=;
        b=jGDjK5Fxp/ZQS6W2VCZE9UvpnB+99F/dnNApNwvGUDEnOe7WrTE4ND2u4hqezX0ey9
         t3InSvLw/xnXFGSl8rm2PFWU2Cx+PH4Wu4MXimD4czL6OAhM4od4skHLZUqFyVMcEciv
         kBFmoFZru2UwiZKWZnr+OEciQlm7RhFuoqBVvSIpSZcya5aLXGRWoBVqC0BTTdfPO3Zf
         mnCw/EwfcuG7IrRu7t1FBAgx/cdckYY8c0NyuGDdNZNue53aw1oga0Gsv9fHDgEHFy8+
         FPQziCaVEUpqVa07+U2JAlpYHOkFzitFtCEVHzlkdZ2msPCtmYBpMoQptjYqqD5vLQzZ
         439A==
X-Gm-Message-State: AOJu0YxltmwoZ++BsAHoO9iiwVwNYgyKJNgG9DZsd28uLa1lGrE36Ef2
	YS9304g75NBKNQE/8FvaxFt4BG1z/GqMcTMeBAQ9P9d30KuwCD49d4GR
X-Gm-Gg: Acq92OHRtXoYNzfrAsJwHKAwjaEYqlp7cMSX8uaHpALuGHfyiI3IfrQQIq+0zFWpCTy
	NcqkNP4kIpy6MBo0H+4OiqEmC6f4i2bVb3cTxTBIqzDM+ytNKXgV2ALQ1ZVIVwAIKB5lAjmADYW
	UnELkc6NA/AJUZMEA+pTxmzRB5HP/j3Cep2f4LrX71E9bn/ydC944LjCmEefIhezBNBfofxh+T+
	Dih+e+uF2a00V9BK2LSpxQvXCtuxZOmKjq7E2XLqQR2egAMMPpQ8GIGLEvubDJOjslbI5LwE0n7
	oBsZibrLyH9ZyXrw/EopCZlM1DmEoOxJuU2Kv6HB4AOL/MYrgueksgCbVF99zzNpi24ZnMAp+qA
	AZNdYRnzgcChdbERwEbeKdGXVLJB/D4eIE7DMxCKxWDziOYTCBBnefbhBZY4XhLemW8TZAbAxxo
	ozgv4muC+/YdwjsvJhmmgX4pzYZ9RmDqCZnIK++rccKtI5KK9JWwHmCKn81xRyx75DGiOZ6lkE/
	w==
X-Received: by 2002:a05:600c:4fc7:b0:488:abe9:86 with SMTP id 5b1f17b1804b1-49042aec1demr39859485e9.7.1779490902091;
        Fri, 22 May 2026 16:01:42 -0700 (PDT)
Received: from menon.v.cablecom.net (84-74-0-139.dclient.hispeed.ch. [84.74.0.139])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490456274ebsm67100265e9.15.2026.05.22.16.01.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 May 2026 16:01:41 -0700 (PDT)
From: Lothar Rubusch <l.rubusch@gmail.com>
To: thorsten.blum@linux.dev,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	nicolas.ferre@microchip.com,
	alexandre.belloni@bootlin.com,
	claudiu.beznea@tuxon.dev,
	tudor.ambarus@linaro.org,
	ardb@kernel.org,
	linusw@kernel.org,
	krzk+dt@kernel.org
Cc: linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	l.rubusch@gmail.com
Subject: [PATCH v4 02/12] crypto: atmel-ecc - fix multi-device kpp registration
Date: Fri, 22 May 2026 23:01:24 +0000
Message-Id: <20260522230134.32414-3-l.rubusch@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260522230134.32414-1-l.rubusch@gmail.com>
References: <20260522230134.32414-1-l.rubusch@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When multiple atmel-ecc hardware accelerator chips are attached to the
same host, registering the same static kpp_alg structure multiple times
corrupts internal fields used by the crypto core's algorithm list. This
leads to immediate list corruption or kernel panics.

Additionally, removing an individual device via sysfs while active crypto
transformations (TFMs) are running triggers a use-after-free (UAF) bug.
Because the device driver core lacks unbind error-handling paths, the
underlying memory allocated via devm for the i2c_priv structure is freed
unconditionally, leaving active transformation context pointers dangling.

Fix these problems by implementing a centralized subsystem tracking matrix:

1. Introduce a global subsystem mutex and reference counter to ensure
   that the static 'atmel_ecdh_nist_p256' structure is only registered by
   the first probing device, and unregistered exclusively when the last
   supporting device unbinds.

2. Maintain per-device allocation tracking with 'tfm_count'. On remove,
   mark the device unready to halt load-balancing assignments, and block
   via a completion barrier until all pending transformation contexts bound
   to that specific physical hardware are freed.

3. Fix a critical re-registration race where a high-velocity unbind and
   subsequent re-probe cycles occur while crypto core asynchronous users
   are still purging. Establish a global 'atmel_ecc_unreg_active' state
   fence to force concurrent probing threads to execute a 2-second timeout
   bounded wait_for_completion_timeout() rather than unsafely mutating
   static lists.

Fixes: 11105693fa05 ("crypto: atmel-ecc - introduce Microchip / Atmel ECC driver")
Signed-off-by: Lothar Rubusch <l.rubusch@gmail.com>
---
 drivers/crypto/atmel-ecc.c | 107 ++++++++++++++++++++++++++++---------
 drivers/crypto/atmel-i2c.h |   1 +
 2 files changed, 82 insertions(+), 26 deletions(-)

diff --git a/drivers/crypto/atmel-ecc.c b/drivers/crypto/atmel-ecc.c
index 94360d29f9f9..005a9a3d919c 100644
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
@@ -243,7 +248,8 @@ static void atmel_ecc_i2c_client_free(struct i2c_client *client)
 {
 	struct atmel_i2c_client_priv *i2c_priv = i2c_get_clientdata(client);
 
-	atomic_dec(&i2c_priv->tfm_count);
+	if (atomic_dec_and_test(&i2c_priv->tfm_count))
+		complete(&i2c_priv->remove_done);
 }
 
 static int atmel_ecdh_init_tfm(struct crypto_kpp *tfm)
@@ -278,7 +284,8 @@ static void atmel_ecdh_exit_tfm(struct crypto_kpp *tfm)
 	struct atmel_ecdh_ctx *ctx = kpp_tfm_ctx(tfm);
 
 	kfree(ctx->public_key);
-	crypto_free_kpp(ctx->fallback);
+	if (ctx->fallback)
+		crypto_free_kpp(ctx->fallback);
 	atmel_ecc_i2c_client_free(ctx->client);
 }
 
@@ -317,6 +324,7 @@ static struct kpp_alg atmel_ecdh_nist_p256 = {
 static int atmel_ecc_probe(struct i2c_client *client)
 {
 	struct atmel_i2c_client_priv *i2c_priv;
+	unsigned long timeout;
 	int ret;
 
 	ret = atmel_i2c_probe(client);
@@ -332,50 +340,97 @@ static int atmel_ecc_probe(struct i2c_client *client)
 	i2c_priv->ready = true;
 	spin_unlock(&driver_data.i2c_list_lock);
 
-	ret = crypto_register_kpp(&atmel_ecdh_nist_p256);
-	if (ret) {
-		spin_lock(&driver_data.i2c_list_lock);
-		i2c_priv->ready = false;
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
+			i2c_priv->ready = false;
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
-		return ret;
-	} else {
-		dev_info(&client->dev, "atmel ecc algorithms registered in /proc/crypto\n");
+	if (atmel_ecc_kpp_refcnt == 0) {
+		ret = crypto_register_kpp(&atmel_ecdh_nist_p256);
+		if (ret) {
+			spin_lock(&driver_data.i2c_list_lock);
+			i2c_priv->ready = false;
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
+	bool trigger_unreg = false;
 
 	spin_lock(&driver_data.i2c_list_lock);
 	i2c_priv->ready = false;
 	spin_unlock(&driver_data.i2c_list_lock);
 
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
+	 * The Linux crypto core automatically blocks until all active
+	 * transformations utilizing that specific algorithm structure
+	 * are fully freed and closed.
+	 */
+	mutex_lock(&atmel_ecc_kpp_lock);
+	atmel_ecc_kpp_refcnt--;
+
+	if (atmel_ecc_kpp_refcnt == 0) {
+		trigger_unreg = true;
+		atmel_ecc_unreg_active = true;
+		reinit_completion(&atmel_ecc_unreg_done);
 	}
+	mutex_unlock(&atmel_ecc_kpp_lock);
 
-	crypto_unregister_kpp(&atmel_ecdh_nist_p256);
+	if (atomic_read(&i2c_priv->tfm_count))
+		wait_for_completion(&i2c_priv->remove_done);
 
 	spin_lock(&driver_data.i2c_list_lock);
 	list_del(&i2c_priv->i2c_client_list_node);
 	spin_unlock(&driver_data.i2c_list_lock);
+
+	/*
+	 * The driver registers once an algorithm, but maintains a list of
+	 * supporting i2c devices. Unregister the algorithm only, when the last
+	 * supporting device deregisters. Use completions to assure no inflight
+	 * TFMs and/or re-registering driver probe will then loose memory
+	 * by over initializing the global statics.
+	 */
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
index e3b12030f9c4..b320559e50eb 100644
--- a/drivers/crypto/atmel-i2c.h
+++ b/drivers/crypto/atmel-i2c.h
@@ -146,6 +146,7 @@ struct atmel_i2c_client_priv {
 	size_t wake_token_sz;
 	atomic_t tfm_count ____cacheline_aligned;
 	struct hwrng hwrng;
+	struct completion remove_done;
 	bool ready;
 };
 
-- 
2.39.5

