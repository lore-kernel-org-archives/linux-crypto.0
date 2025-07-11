Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7C0F2ED842;
	Fri, 11 Jul 2025 18:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752258634; cv=none; b=uHyvJ5p/CArBARqJBwCH4PALPLxXh6udnvpvBjM8hiqOH0JHAqXsBXRIg5L9OVOnjcSe5fcFrPwuFB3KsSioc6eSVAC0gwrInUeJ5iTySuRZS2v8+l6j+AV3pUhTqkJZh5RDkQeyAvGCTfE/DZjPVFT7S7BpIEqEbptvZguCsRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752258634; c=relaxed/simple;
	bh=sJW/1fGSw11zYgLi/9LWnszpW7KHJj2dr0zHLZ1lreM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=oDoaHLC1L1JZyrTCuUkJlg7KToNgScwSiDMgkHx7eyigjDA52Y9th8AqNdGCaV4Pz9VM7fsoWs347gGqDLSoBAM4B2IiWULzuGlNCKC3/Kwrmg5MYS2uNUWtOTg4DpWKKCR3cYyTZ5ZOOsLzVjryeTXesty6BTW/wAqjvHWr46I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Vuup7Qoh; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Vuup7Qoh"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-ae3b37207easo476663966b.2;
        Fri, 11 Jul 2025 11:30:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752258631; x=1752863431; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=TOP6MH4LWDkkQWWYHqizxUdoYZyd4qiL1+SiqsnJqbg=;
        b=Vuup7QoheIhuJaez74kbhN7UMiCYqCRmNOBinsEzXg6VRdHOeM6JT/JdBPbZj6JvgC
         2/A4ONf59mrRnoP1mGx8CutVA+6Hru+rI6Ph7xrYmb6VMjozkBMAetOTFl+g+ZrVOmBx
         cRx6nttPdMGF29yJHU3ltRpTU+HQ/rx+OK9TM6Px1VCFmkHLMSH6TR84FZ95R5Q7If3/
         FG5RATZ0RgNWPEuno+u0gP8aIaQsyB/03L8LiL/PB1xsCKkIRAnzTA35py55zP3Gw1iv
         h9t4cTucci2Qa7V4xlQ+quxrxSGQYRPEpFLGjVFAaZdSz5wMxTAZuBAtsApk+OKBtwMT
         j46Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752258631; x=1752863431;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TOP6MH4LWDkkQWWYHqizxUdoYZyd4qiL1+SiqsnJqbg=;
        b=fl+TMAmxwBnSS0l7Ffk6u4Xq85X49Ny2bYxXQkpfxNo5ulxbjDeAi0MFbjLcK/2Lkf
         N7k0BTVbGQ42woEVeI6njxJmMF4g36FukeZBGNVVp9kEenXiWoWVpHNcijCc0N7qAfuI
         eRnciEjGZS/h/hko2QtAebBSRo1EwmQpX6c9QiKBWThvIaASK2i7I8mEM8atd9LpUu5Z
         f+jNdOa/ebom7oMab0NJ6n0JeyWl+nn2Toz1yjHddbOkVfgO5oI5MdHnYFDY/nmBQwnh
         5LS9+3UwOlGXbhiX2X7IfiDHUA6sq+XXrA5T4nbC6WrEOcldDAiyTwgzj8HOOZqbKGbB
         MMMQ==
X-Forwarded-Encrypted: i=1; AJvYcCVW4rCs4AWuBtKDiTsv6AHP4c5eNob6NMG8Uh/AM0IOVL6i20oOMriKOIuITAHndVgrsIo4nokpze/XjBaZ@vger.kernel.org, AJvYcCXKnuowE5kXjrKqJG8nRP6u+91ZP2rGKY55P1BQgVqOx50xYpCeroAeECd6Io2CwpuXW/Jf/DC+WbNV5w==@vger.kernel.org, AJvYcCXozlrkXwVAugYR+8TfIVONLqN2N2SRBnjfhFop3izqPstPkIHCJyFQUHsE2PxD70Sc57133tCP8zQTRdo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw6PD/cnzjGpfovBMqAAoukJP3984yhbFv/4JE+cuW8lAgUeiFM
	jjsOPMafuzwLbWHonazdja5zhZJKhzxgura23TYthe7uWHm49RrfXfKtlY5uyA==
X-Gm-Gg: ASbGncvukN56CygkMFq+r3UlnNAa0Tx0c9YMz6COQdLYMHo8oGGtLQa10MbJyuJenPI
	zhOIigr2ub7xbfYxasdCky+z4O909yxw9z3rcLByOUhaUh3TQeLrZDe8cZ1KyHhvLuLJRfo6zBS
	6iNlQD1Fw07cQep9WpIR5s0hHIkfIyW3xHvXZUOmPPToEpLf2OuLrlHzjvQe7fLoa3VRS2Lx5et
	eZywV5E78Z9scIQEe0qojVnJSP/OmjBH2x6Tz8qH+garsy/8bN58//GBsQykgGrrVmx/IFh3mns
	QPk3jepEKllCcRg2d+aTzDpP2teoNaipIk13HC6kCkwyyhjDogKrQSYlUAt2ZU0CS/C80BFLw4s
	gjb8Ty/wa0u7UHfEUCKly67uGcUwLXrpfUxs=
X-Google-Smtp-Source: AGHT+IFZ+CT7VU8SXE2R9rYpWGqwI+x5YqfZKcBNQpoWiXBRCuYmYkFXigYic9U/s5bCPICsGUlhJA==
X-Received: by 2002:a17:907:805:b0:ae6:d3dc:4f47 with SMTP id a640c23a62f3a-ae6fbf98a08mr496827266b.43.1752258630915;
        Fri, 11 Jul 2025 11:30:30 -0700 (PDT)
Received: from ws-linux01 ([2a02:2f07:6009:b200:8bc2:7901:5231:7913])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae6e7ee569asm334750066b.44.2025.07.11.11.30.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jul 2025 11:30:29 -0700 (PDT)
From: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
To: herbert@gondor.apana.org.au,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Ovidiu Panait <ovidiu.panait.oss@gmail.com>,
	freude@linux.ibm.com,
	dengler@linux.ibm.com,
	linux-s390@vger.kernel.org,
	horia.geanta@nxp.com,
	pankaj.gupta@nxp.com,
	gaurav.jain@nxp.com,
	arei.gonglei@huawei.com,
	virtualization@lists.linux.dev
Subject: [PATCH 1/2] crypto: engine: remove request batching support
Date: Fri, 11 Jul 2025 21:29:31 +0300
Message-ID: <20250711182932.918257-1-ovidiu.panait.oss@gmail.com>
X-Mailer: git-send-email 2.50.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove request batching support from crypto_engine, as there are no
drivers using this feature and it doesn't really work that well.

Instead of doing batching based on backlog, a more optimal approach
would be for the user to handle the batching (similar to how IPsec
can hook into GSO to get 64K of data each time or how block encryption
can use unit sizes much greater than 4K).

Suggested-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
---
Cc: freude@linux.ibm.com
Cc: dengler@linux.ibm.com
Cc: linux-s390@vger.kernel.org
Cc: horia.geanta@nxp.com
Cc: pankaj.gupta@nxp.com
Cc: gaurav.jain@nxp.com
Cc: arei.gonglei@huawei.com
Cc: virtualization@lists.linux.dev

 arch/s390/crypto/paes_s390.c               |  2 +-
 arch/s390/crypto/phmac_s390.c              |  2 +-
 crypto/crypto_engine.c                     | 25 +---------------------
 drivers/crypto/caam/jr.c                   |  3 +--
 drivers/crypto/virtio/virtio_crypto_core.c |  2 +-
 include/crypto/engine.h                    |  1 -
 include/crypto/internal/engine.h           |  4 ----
 7 files changed, 5 insertions(+), 34 deletions(-)

diff --git a/arch/s390/crypto/paes_s390.c b/arch/s390/crypto/paes_s390.c
index 8a340c16acb4..a624a43a2b54 100644
--- a/arch/s390/crypto/paes_s390.c
+++ b/arch/s390/crypto/paes_s390.c
@@ -1633,7 +1633,7 @@ static int __init paes_s390_init(void)
 	/* with this pseudo devie alloc and start a crypto engine */
 	paes_crypto_engine =
 		crypto_engine_alloc_init_and_set(paes_dev.this_device,
-						 true, NULL, false, MAX_QLEN);
+						 true, false, MAX_QLEN);
 	if (!paes_crypto_engine) {
 		rc = -ENOMEM;
 		goto out_err;
diff --git a/arch/s390/crypto/phmac_s390.c b/arch/s390/crypto/phmac_s390.c
index 90602f72108f..7ecfdc4fba2d 100644
--- a/arch/s390/crypto/phmac_s390.c
+++ b/arch/s390/crypto/phmac_s390.c
@@ -1006,7 +1006,7 @@ static int __init s390_phmac_init(void)
 	/* with this pseudo device alloc and start a crypto engine */
 	phmac_crypto_engine =
 		crypto_engine_alloc_init_and_set(phmac_dev.this_device,
-						 true, NULL, false, MAX_QLEN);
+						 true, false, MAX_QLEN);
 	if (!phmac_crypto_engine) {
 		rc = -ENOMEM;
 		goto out_err;
diff --git a/crypto/crypto_engine.c b/crypto/crypto_engine.c
index 445d3c113ee1..8a2400f240d4 100644
--- a/crypto/crypto_engine.c
+++ b/crypto/crypto_engine.c
@@ -195,17 +195,6 @@ static void crypto_pump_requests(struct crypto_engine *engine,
 out:
 	spin_unlock_irqrestore(&engine->queue_lock, flags);
 
-	/*
-	 * Batch requests is possible only if
-	 * hardware can enqueue multiple requests
-	 */
-	if (engine->do_batch_requests) {
-		ret = engine->do_batch_requests(engine);
-		if (ret)
-			dev_err(engine->dev, "failed to do batch requests: %d\n",
-				ret);
-	}
-
 	return;
 }
 
@@ -462,12 +451,6 @@ EXPORT_SYMBOL_GPL(crypto_engine_stop);
  * crypto-engine queue.
  * @dev: the device attached with one hardware engine
  * @retry_support: whether hardware has support for retry mechanism
- * @cbk_do_batch: pointer to a callback function to be invoked when executing
- *                a batch of requests.
- *                This has the form:
- *                callback(struct crypto_engine *engine)
- *                where:
- *                engine: the crypto engine structure.
  * @rt: whether this queue is set to run as a realtime task
  * @qlen: maximum size of the crypto-engine queue
  *
@@ -476,7 +459,6 @@ EXPORT_SYMBOL_GPL(crypto_engine_stop);
  */
 struct crypto_engine *crypto_engine_alloc_init_and_set(struct device *dev,
 						       bool retry_support,
-						       int (*cbk_do_batch)(struct crypto_engine *engine),
 						       bool rt, int qlen)
 {
 	struct crypto_engine *engine;
@@ -495,11 +477,6 @@ struct crypto_engine *crypto_engine_alloc_init_and_set(struct device *dev,
 	engine->idling = false;
 	engine->retry_support = retry_support;
 	engine->priv_data = dev;
-	/*
-	 * Batch requests is possible only if
-	 * hardware has support for retry mechanism.
-	 */
-	engine->do_batch_requests = retry_support ? cbk_do_batch : NULL;
 
 	snprintf(engine->name, sizeof(engine->name),
 		 "%s-engine", dev_name(dev));
@@ -534,7 +511,7 @@ EXPORT_SYMBOL_GPL(crypto_engine_alloc_init_and_set);
  */
 struct crypto_engine *crypto_engine_alloc_init(struct device *dev, bool rt)
 {
-	return crypto_engine_alloc_init_and_set(dev, false, NULL, rt,
+	return crypto_engine_alloc_init_and_set(dev, false, rt,
 						CRYPTO_ENGINE_MAX_QLEN);
 }
 EXPORT_SYMBOL_GPL(crypto_engine_alloc_init);
diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c
index 9fcdb64084ac..0ef00df9730e 100644
--- a/drivers/crypto/caam/jr.c
+++ b/drivers/crypto/caam/jr.c
@@ -629,8 +629,7 @@ static int caam_jr_probe(struct platform_device *pdev)
 	}
 
 	/* Initialize crypto engine */
-	jrpriv->engine = crypto_engine_alloc_init_and_set(jrdev, true, NULL,
-							  false,
+	jrpriv->engine = crypto_engine_alloc_init_and_set(jrdev, true, false,
 							  CRYPTO_ENGINE_MAX_QLEN);
 	if (!jrpriv->engine) {
 		dev_err(jrdev, "Could not init crypto-engine\n");
diff --git a/drivers/crypto/virtio/virtio_crypto_core.c b/drivers/crypto/virtio/virtio_crypto_core.c
index 0d522049f595..3d241446099c 100644
--- a/drivers/crypto/virtio/virtio_crypto_core.c
+++ b/drivers/crypto/virtio/virtio_crypto_core.c
@@ -139,7 +139,7 @@ static int virtcrypto_find_vqs(struct virtio_crypto *vi)
 		spin_lock_init(&vi->data_vq[i].lock);
 		vi->data_vq[i].vq = vqs[i];
 		/* Initialize crypto engine */
-		vi->data_vq[i].engine = crypto_engine_alloc_init_and_set(dev, true, NULL, true,
+		vi->data_vq[i].engine = crypto_engine_alloc_init_and_set(dev, true, true,
 						virtqueue_get_vring_size(vqs[i]));
 		if (!vi->data_vq[i].engine) {
 			ret = -ENOMEM;
diff --git a/include/crypto/engine.h b/include/crypto/engine.h
index 545dbefe3e13..2e60344437da 100644
--- a/include/crypto/engine.h
+++ b/include/crypto/engine.h
@@ -76,7 +76,6 @@ int crypto_engine_stop(struct crypto_engine *engine);
 struct crypto_engine *crypto_engine_alloc_init(struct device *dev, bool rt);
 struct crypto_engine *crypto_engine_alloc_init_and_set(struct device *dev,
 						       bool retry_support,
-						       int (*cbk_do_batch)(struct crypto_engine *engine),
 						       bool rt, int qlen);
 void crypto_engine_exit(struct crypto_engine *engine);
 
diff --git a/include/crypto/internal/engine.h b/include/crypto/internal/engine.h
index b6a4ea2240fc..8da1a13619c9 100644
--- a/include/crypto/internal/engine.h
+++ b/include/crypto/internal/engine.h
@@ -37,8 +37,6 @@ struct device;
  * @unprepare_crypt_hardware: there are currently no more requests on the
  * queue so the subsystem notifies the driver that it may relax the
  * hardware by issuing this call
- * @do_batch_requests: execute a batch of requests. Depends on multiple
- * requests support.
  * @kworker: kthread worker struct for request pump
  * @pump_requests: work struct for scheduling work to the request pump
  * @priv_data: the engine private data
@@ -60,8 +58,6 @@ struct crypto_engine {
 
 	int (*prepare_crypt_hardware)(struct crypto_engine *engine);
 	int (*unprepare_crypt_hardware)(struct crypto_engine *engine);
-	int (*do_batch_requests)(struct crypto_engine *engine);
-
 
 	struct kthread_worker           *kworker;
 	struct kthread_work             pump_requests;
-- 
2.50.0

