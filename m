Received: from phobos.denx.de (phobos.denx.de [85.214.62.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78F9A1C728E
	for <linux-crypto@vger.kernel.org>; Thu, 24 Oct 2024 16:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.62.61
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729787510; cv=none; b=jOk7V8ncM5mW26e7lc9L65f95YXpo3x6kgSeOziECVv1eEVXgaTig2u3OmBp8sdc8D1AJkGm94UvHqVZ2ZWQTVrzcYk3VPM3pFGuYCP5wvdDFGWCMA6FODko0s74bDTwvihPebX0YCgLP8dwGOZOd4W011duhiOdHx7Gcj5dqdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729787510; c=relaxed/simple;
	bh=ZO9k30mb+ULzxzsxBTttL7WgHHyAz6SAieYZ59l0uqo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BACcgBgwx8y7dkX/HlmxcmLRrx/mn19l1th9IoYjwBctj8HmgDsprG8jiMi9TBFJSDhHIl8v6wPdd84Gbue/ufmcadbxujFjzHWkmxbN1GMmjfnGzj+kO7pAXfJ2KJo2a8zXx/PjGQHtcVV+TqzSY5QbKaka3XbFbX41nig01qY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=ztEQ7hdG; arc=none smtp.client-ip=85.214.62.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="ztEQ7hdG"
Received: from tr.lan (ip-86-49-120-218.bb.vodafone.cz [86.49.120.218])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: marex@denx.de)
	by phobos.denx.de (Postfix) with ESMTPSA id AF60488F55;
	Thu, 24 Oct 2024 18:31:38 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
	s=phobos-20191101; t=1729787500;
	bh=uT3dmEunMhyO4RLAkq3R/O0Yfgr5p6PgNIFHGQuE2KI=;
	h=From:To:Cc:Subject:Date:From;
	b=ztEQ7hdGOSnRJLQ/axPyhXKTmHaCguHEM1lw4QON/dLqtuRKNoGgvS6k+Z2DEna6V
	 GA+FY48xWim3TUtbmP8d4QOATWDyQvxHoVikNM0IuApxqpluNTBhYK2NptotxYX1oj
	 s8Zk+ZUNCt+FITHzLCKXAvidP7/MKXUcInj7+kMslY776OuakiLxndSJvgDrc0B8nR
	 TrJqq6qgIlEfd5cfuW8cnrbXle2DL8P5NqMyUU3HZUYZtYVct9WoIcQYkn5RxwTmm3
	 jNWqnVP6ea9H/QBNiiMNxbW1uFM1GagaHlgQYK9P9a96PMINIBhuq3vk0YWK+5Fpks
	 PAFZboWFTp1Vg==
From: Marek Vasut <marex@denx.de>
To: linux-crypto@vger.kernel.org
Cc: Marek Vasut <marex@denx.de>,
	Dominik Brodowski <linux@dominikbrodowski.net>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Li Zhijian <lizhijian@fujitsu.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Olivia Mackall <olivia@selenic.com>
Subject: [PATCH 1/2] [RFC] hwrng: fix khwrng lifecycle
Date: Thu, 24 Oct 2024 18:30:15 +0200
Message-ID: <20241024163121.246420-1-marex@denx.de>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.103.8 at phobos.denx.de
X-Virus-Status: Clean

The khwrng can terminate also if the rng is removed, and in this case it
doesn't synchronize with kthread_should_stop(), but it directly sets
hwrng_fill to NULL. If this happens after the NULL check but before
kthread_stop() is called, we'll have a NULL pointer dereference.

Keep the hwrng_fill thread around and only park it when unused, i.e.
when there is no RNG available. Unpark it when RNG becomes available.
This way, we are sure to never trigger the NULL pointer dereference.

Signed-off-by: Marek Vasut <marex@denx.de>
---
This is a follow-up on first part of V2 of work by Luca Dariz:
https://lore.kernel.org/all/AM6PR06MB5400DAFE0551F1D468B728FBAB889@AM6PR06MB5400.eurprd06.prod.outlook.com/
---
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: Harald Freudenberger <freude@linux.ibm.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Li Zhijian <lizhijian@fujitsu.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Olivia Mackall <olivia@selenic.com>
Cc: linux-crypto@vger.kernel.org
---
 drivers/char/hw_random/core.c | 71 ++++++++++++++++++++++-------------
 1 file changed, 45 insertions(+), 26 deletions(-)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index 018316f546215..5be26f4e9d975 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -87,15 +87,6 @@ static int set_current_rng(struct hwrng *rng)
 	drop_current_rng();
 	current_rng = rng;
 
-	/* if necessary, start hwrng thread */
-	if (!hwrng_fill) {
-		hwrng_fill = kthread_run(hwrng_fillfn, NULL, "hwrng");
-		if (IS_ERR(hwrng_fill)) {
-			pr_err("hwrng_fill thread creation failed\n");
-			hwrng_fill = NULL;
-		}
-	}
-
 	return 0;
 }
 
@@ -484,10 +475,17 @@ static int hwrng_fillfn(void *unused)
 	while (!kthread_should_stop()) {
 		unsigned short quality;
 		struct hwrng *rng;
+		if (kthread_should_park()) {
+			kthread_parkme();
+			continue;
+		}
 
 		rng = get_current_rng();
-		if (IS_ERR(rng) || !rng)
-			break;
+		if (IS_ERR(rng) || !rng) {
+			schedule();
+			continue;
+		}
+
 		mutex_lock(&reading_mutex);
 		rc = rng_get_data(rng, rng_fillbuf,
 				  rng_buffer_size(), 1);
@@ -515,12 +513,12 @@ static int hwrng_fillfn(void *unused)
 		add_hwgenerator_randomness((void *)rng_fillbuf, rc,
 					   entropy >> 10, true);
 	}
-	hwrng_fill = NULL;
 	return 0;
 }
 
 int hwrng_register(struct hwrng *rng)
 {
+	struct hwrng *old_rng;
 	int err = -EINVAL;
 	struct hwrng *tmp;
 
@@ -544,6 +542,7 @@ int hwrng_register(struct hwrng *rng)
 	/* Adjust quality field to always have a proper value */
 	rng->quality = min_t(u16, min_t(u16, default_quality, 1024), rng->quality ?: 1024);
 
+	old_rng = current_rng;
 	if (!current_rng ||
 	    (!cur_rng_set_by_user && rng->quality > current_rng->quality)) {
 		/*
@@ -556,6 +555,10 @@ int hwrng_register(struct hwrng *rng)
 			goto out_unlock;
 	}
 	mutex_unlock(&rng_mutex);
+
+	if (!old_rng && current_rng)
+		kthread_unpark(hwrng_fill);
+
 	return 0;
 out_unlock:
 	mutex_unlock(&rng_mutex);
@@ -582,15 +585,12 @@ void hwrng_unregister(struct hwrng *rng)
 	}
 
 	new_rng = get_current_rng_nolock();
-	if (list_empty(&rng_list)) {
-		mutex_unlock(&rng_mutex);
-		if (hwrng_fill)
-			kthread_stop(hwrng_fill);
-	} else
-		mutex_unlock(&rng_mutex);
+	mutex_unlock(&rng_mutex);
 
 	if (new_rng)
 		put_rng(new_rng);
+	else
+		kthread_park(hwrng_fill);
 
 	wait_for_completion(&rng->cleanup_done);
 }
@@ -654,7 +654,7 @@ EXPORT_SYMBOL_GPL(hwrng_yield);
 
 static int __init hwrng_modinit(void)
 {
-	int ret;
+	int ret = -ENOMEM;
 
 	/* kmalloc makes this safe for virt_to_page() in virtio_rng.c */
 	rng_buffer = kmalloc(rng_buffer_size(), GFP_KERNEL);
@@ -662,22 +662,41 @@ static int __init hwrng_modinit(void)
 		return -ENOMEM;
 
 	rng_fillbuf = kmalloc(rng_buffer_size(), GFP_KERNEL);
-	if (!rng_fillbuf) {
-		kfree(rng_buffer);
-		return -ENOMEM;
-	}
+	if (!rng_fillbuf)
+		goto err_fillbuf;
 
 	ret = misc_register(&rng_miscdev);
-	if (ret) {
-		kfree(rng_fillbuf);
-		kfree(rng_buffer);
+	if (ret)
+		goto err_miscdev;
+
+	hwrng_fill = kthread_create(hwrng_fillfn, NULL, "hwrng");
+	if (IS_ERR(hwrng_fill)) {
+		ret = PTR_ERR(hwrng_fill);
+		pr_err("hwrng_fill thread creation failed (%d)\n", ret);
+		goto err_kthread;
 	}
 
+	ret = kthread_park(hwrng_fill);
+	if (ret)
+		goto err_park;
+
+	return ret;
+
+err_park:
+	kthread_stop(hwrng_fill);
+err_kthread:
+	misc_deregister(&rng_miscdev);
+err_miscdev:
+	kfree(rng_buffer);
+err_fillbuf:
+	kfree(rng_buffer);
 	return ret;
 }
 
 static void __exit hwrng_modexit(void)
 {
+	kthread_stop(hwrng_fill);
+
 	mutex_lock(&rng_mutex);
 	BUG_ON(current_rng);
 	kfree(rng_buffer);
-- 
2.45.2

