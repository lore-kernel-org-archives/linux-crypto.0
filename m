Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E02BD418A52
	for <linux-crypto@vger.kernel.org>; Tue, 28 Jul 2026 08:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785228255; cv=none; b=t3xLk1JcgvTgUoi6MTOiuMOfCDPo3EZ7wdGmIxEmNldwBhR8zzTDCnlcZE2O7IWM6/v7SvZl0JQZv65+bbhVmPjjExnWN20nvNmPHsOsmI/079esI8T6leszyRLr9LkRhY8AGvZrXvuArKUKt0urSGktFTEPJF0J4Fwm05msBEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785228255; c=relaxed/simple;
	bh=csuLR5iCWrapqyAuDccx1TKHF6TmNIqS5D3QsXWHFdk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nQbsumLPWM9GgWmZJizhFClFJI/SkvQVtZqFhzBhOQ8eFVMvCAsOH3b/oH0RpphbWyGgQgbp+2X6eGCCoiJGPSo/ubQaVxTbkSIaRIH0TMTP8/Aifd/nxYluHpgHmTMuVdyiZ0KkbBQqU9z/qGTZH6x+cegs/+c4uICjVsm7mkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ebgkHrrj; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ebgkHrrj"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2cedda2ce6fso30267225ad.1
        for <linux-crypto@vger.kernel.org>; Tue, 28 Jul 2026 01:44:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785228252; x=1785833052; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NFn0MZ4bxGVk/BVF8CImWHCT1sjhVyqO8BLSrIvbU9M=;
        b=ebgkHrrjpArMTkBFJ77fvDgHfQWwrJNOghfQLdfEJd5qPS0xYT0WuNLohKo2cLn8xD
         AnCizaKLpsw2rMhx48m2La0CFyKHGAwFzyuvdiPv3VLFstG+VU+asBc44IT8HVbR27RG
         0YgL9EJbNNmhGHWtFg375mJqU5mJMom12kdB4QW1/0AvjMRqYmX3ev7cx7ZBB22xImAK
         xKp43CObhZbIECCu9X7HtwodBKiavz4SSKpJIkxvfdJxZs9JryBGzeKs2hHYZTNfCZTZ
         yN60CJiV+oggBN+WzpHdJG0o1CSYmhrJ6dQd0dtft8MyyWBetsgm6GPF/bmtUa2PZfIx
         39Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785228252; x=1785833052;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=NFn0MZ4bxGVk/BVF8CImWHCT1sjhVyqO8BLSrIvbU9M=;
        b=qNdWSyU/rQEO0ukJ5n5wS7EhtOJ05Ug8lbNMAROxiVJRsaZ5U9a+ej8qpKhP09pwej
         UMqtQHPEEGD1iWO2c52J7qLBzM2avKS9fICONZnxZPipJ5Bnr4haxop3zFtozmSY+sWy
         Y1EZ7XetDHUsQEKpapMUyJpwjqaqGCf02lvbiRXwpFEbkcHwIYGeTgFHMOKdnm51gQEy
         tdIqLl74rq+xWsE579gGSZqrRjZzk/B1Nl/3FdTVM11ir0Jg5jz0q3dUbPL0xCOvW3iL
         7fOGviqmIVjDwxpVYLdnR/9qGVIwRCqpgiwBZC6/Z4W12uwKlnOQ8GHaE3Qn+jaY7fse
         +13w==
X-Forwarded-Encrypted: i=1; AHgh+RpVycvHO0YD7sI29XkdE0I/bUq/emtGH9bQrurK6mXGBKYJtcm1nFJeNAod3TH/JL1F+y/Ui9f7yuFOhww=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx0ChWu0f1jsmz8ZOYr1YM1yOsotXFo5/0UTQoHVMGlZGTuGeo8
	yg5jtOX4Vo4powPFnbuR8Td3u1P2y0jj8eC0MqiBleOBdcIo/jVOShzR
X-Gm-Gg: AR+sD12gj85DM6HSoeEpHxpGg6jQxM+o08p+uaeiQ8o5BV2KPPJHRQbrsYOIH3aKfcT
	F6hghHZOlTIhcg+yszg1JJjlglVpZI2suiAwvmBrSDlPla47Am57zW7gdsc3VmFkY7HiiGtNcY2
	9mLC7xUb/Jsl8s4uQw1QSNaKg0eEe54vdMHq6J9MHLA4CFmOf4DH43FGAj1sePSag9afUN8pkvp
	wD53+PN4RuDlXNOkzRUK6LUlFjqh09icLPJ79njbcJNCIGCjAS7B0CW5yNeLGbY4YNy3h72zh/i
	nNGZM5LjPLNvKmDINGQEGyOie5p7br6+Ew4t39DjUvCBx/sX70vGMXhIV+HBcfk8vHDWctc/Hya
	3vRthqNjydlTA308E76ANeLDVdQLJB3m9mVR1FY4DI7fcCEZHo87+mbRPRxnUZjHbP48jTpqXJZ
	0N
X-Received: by 2002:a17:902:f545:b0:2cc:eec6:558 with SMTP id d9443c01a7336-2d015c925bcmr17202865ad.39.1785228252090;
        Tue, 28 Jul 2026 01:44:12 -0700 (PDT)
Received: from mincom1 ([175.235.236.1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cfde7bc585sm48168505ad.51.2026.07.28.01.44.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2026 01:44:11 -0700 (PDT)
From: Jihong Min <hurryman2212@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Christian Marangi <ansuelsmth@gmail.com>,
	linux-crypto@vger.kernel.org
Cc: Jihong Min <hurryman2212@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Antoine Tenart <atenart@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] crypto: eliminate fallback proxy overhead while disabled
Date: Tue, 28 Jul 2026 17:43:32 +0900
Message-ID: <8a2de6d91385ac56820f5dc3996ecd667aea36ab.1785226804.git.hurryman2212@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1785226804.git.hurryman2212@gmail.com>
References: <cover.1785226804.git.hurryman2212@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Register fallback proxy providers only when the per-device control is
enabled. Unregister them again on disable so newly allocated transforms
select the hardware provider directly.

Allocate proxy algorithms per enable cycle and retain retired
generations until existing transforms release them. This keeps repeated
runtime enable and disable transitions safe while forcing retired
proxies to use hardware after disable.

The Crypto API cannot migrate an already allocated transform between
providers. A transform created while disabled remains bound to its
native hardware provider after enable. A transform created while
enabled keeps its proxy after disable until it is released, with its
threshold forced to hardware. Newly allocated transforms follow the
current enabled state.

Assisted-by: Codex:gpt-5.6
Signed-off-by: Jihong Min <hurryman2212@gmail.com>
---
 crypto/fallback.c | 284 ++++++++++++++++++++++++++++++++++------------
 1 file changed, 214 insertions(+), 70 deletions(-)

diff --git a/crypto/fallback.c b/crypto/fallback.c
index af8830f1077c..40755d409e7a 100644
--- a/crypto/fallback.c
+++ b/crypto/fallback.c
@@ -9,13 +9,16 @@
 #include <linux/device.h>
 #include <linux/err.h>
 #include <linux/kernel.h>
+#include <linux/kref.h>
 #include <linux/limits.h>
+#include <linux/list.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/random.h>
 #include <linux/rtnetlink.h>
 #include <linux/scatterlist.h>
 #include <linux/slab.h>
+#include <linux/spinlock.h>
 #include <linux/string.h>
 #include <linux/sysfs.h>
 
@@ -48,10 +51,12 @@ struct crypto_fallback {
 	struct attribute_group sysfs_group;
 	struct attribute **sysfs_attrs;
 	struct device_attribute enabled_attr;
+	struct kref refcount;
 	struct mutex lock; /* Serializes tuning and sysfs writes. */
-	struct fallback_alg *algs;
+	spinlock_t alg_lock; /* Protects algs and fallback_alg state. */
+	struct list_head algs;
+	struct module *owner;
 	unsigned int num_groups;
-	unsigned int num_algs;
 	bool enabled;
 };
 
@@ -422,6 +427,9 @@ static int crypto_fallback_tune_group(const struct crypto_fallback_group *group,
 	return 0;
 }
 
+static int fallback_register_algs(struct crypto_fallback *fallback);
+static void fallback_unregister_algs(struct crypto_fallback *fallback);
+
 static ssize_t fallback_enabled_show(struct device *dev,
 				     struct device_attribute *attr, char *buf)
 {
@@ -451,9 +459,6 @@ static ssize_t fallback_enabled_store(struct device *dev,
 		goto out_unlock;
 
 	if (enabled) {
-		for (i = 0; i < fallback->num_groups; i++)
-			WRITE_ONCE(fallback->groups[i].threshold.value, 0);
-
 		for (i = 0; i < fallback->num_groups; i++) {
 			struct crypto_fallback_group_state *state;
 			int threshold;
@@ -463,9 +468,10 @@ static ssize_t fallback_enabled_store(struct device *dev,
 							 &threshold);
 			if (err) {
 				dev_warn(fallback->dev,
-					"%s benchmark failed: %d; using hardware\n",
-					state->group.name, err);
+					 "%s benchmark failed: %d; using hardware\n",
+					 state->group.name, err);
 				threshold = 0;
+				err = 0;
 			}
 			WRITE_ONCE(state->value, threshold);
 			dev_info(fallback->dev,
@@ -476,28 +482,39 @@ static ssize_t fallback_enabled_store(struct device *dev,
 		for (i = 0; i < fallback->num_groups; i++)
 			WRITE_ONCE(fallback->groups[i].threshold.value,
 				   fallback->groups[i].value);
+
+		if (!fallback->enabled) {
+			err = fallback_register_algs(fallback);
+			if (err) {
+				for (i = 0; i < fallback->num_groups; i++)
+					WRITE_ONCE(fallback->groups[i].threshold.value,
+						   0);
+				goto out_unlock;
+			}
+		}
 	} else {
+		WRITE_ONCE(fallback->enabled, false);
 		for (i = 0; i < fallback->num_groups; i++)
 			WRITE_ONCE(fallback->groups[i].threshold.value, 0);
+		fallback_unregister_algs(fallback);
 	}
 	WRITE_ONCE(fallback->enabled, enabled);
 
 out_unlock:
 	mutex_unlock(&fallback->lock);
 
-	return count;
+	return err ?: count;
 }
 
-static void crypto_fallback_free(struct crypto_fallback *fallback)
+static void crypto_fallback_free(struct kref *ref)
 {
+	struct crypto_fallback *fallback;
 	unsigned int i;
 
-	if (!fallback)
-		return;
+	fallback = container_of(ref, struct crypto_fallback, refcount);
 
 	for (i = 0; i < fallback->num_groups; i++)
 		kfree_const(fallback->groups[i].group.name);
-	kfree(fallback->algs);
 	kfree(fallback->sysfs_attrs);
 	kfree(fallback->groups);
 	mutex_destroy(&fallback->lock);
@@ -506,7 +523,8 @@ static void crypto_fallback_free(struct crypto_fallback *fallback)
 }
 
 static struct crypto_fallback *
-fallback_alloc(struct device *dev, const struct crypto_fallback_group *groups,
+fallback_alloc(struct module *owner, struct device *dev,
+	       const struct crypto_fallback_group *groups,
 	       unsigned int num_groups)
 {
 	struct crypto_fallback *fallback;
@@ -520,8 +538,12 @@ fallback_alloc(struct device *dev, const struct crypto_fallback_group *groups,
 	if (!fallback)
 		return ERR_PTR(-ENOMEM);
 
+	kref_init(&fallback->refcount);
 	mutex_init(&fallback->lock);
+	spin_lock_init(&fallback->alg_lock);
+	INIT_LIST_HEAD(&fallback->algs);
 	fallback->dev = get_device(dev);
+	fallback->owner = owner;
 	fallback->num_groups = num_groups;
 	fallback->groups =
 		kcalloc(num_groups, sizeof(*fallback->groups), GFP_KERNEL);
@@ -583,20 +605,11 @@ fallback_alloc(struct device *dev, const struct crypto_fallback_group *groups,
 	return fallback;
 
 err_free:
-	crypto_fallback_free(fallback);
+	kref_put(&fallback->refcount, crypto_fallback_free);
 
 	return ERR_PTR(err);
 }
 
-static void fallback_release(struct crypto_fallback *fallback)
-{
-	if (!fallback || IS_ERR(fallback))
-		return;
-
-	sysfs_remove_group(&fallback->dev->kobj, &fallback->sysfs_group);
-	crypto_fallback_free(fallback);
-}
-
 static bool fallback_use_software(const struct fallback_threshold *threshold,
 				  unsigned int input_size)
 {
@@ -630,10 +643,20 @@ struct fallback_ahash_state {
 	u8 state[] CRYPTO_MINALIGN_ATTR;
 };
 
+/*
+ * Allocate proxy algorithms per enable cycle because their destruction can be
+ * deferred until transforms allocated before disable release them.
+ */
 struct fallback_alg {
+	struct list_head list;
+	struct crypto_fallback *fallback;
+	struct kref refcount;
 	const struct fallback_threshold *threshold;
 	char driver_name[CRYPTO_MAX_ALG_NAME];
 	enum crypto_fallback_alg_type type;
+	bool registration_complete;
+	bool registered;
+	bool dead;
 	union {
 		struct skcipher_alg skcipher;
 		struct aead_alg aead;
@@ -641,6 +664,87 @@ struct fallback_alg {
 	} alg;
 };
 
+static void fallback_alg_release(struct kref *ref)
+{
+	struct fallback_alg *alg;
+	struct crypto_fallback *fallback;
+
+	alg = container_of(ref, struct fallback_alg, refcount);
+	fallback = alg->fallback;
+	kfree(alg);
+	kref_put(&fallback->refcount, crypto_fallback_free);
+}
+
+static void fallback_alg_destroy(struct fallback_alg *alg)
+{
+	struct crypto_fallback *fallback = alg->fallback;
+	unsigned long flags;
+	bool release = false;
+
+	spin_lock_irqsave(&fallback->alg_lock, flags);
+	alg->dead = true;
+	alg->registered = false;
+	if (alg->registration_complete) {
+		list_del_init(&alg->list);
+		release = true;
+	}
+	spin_unlock_irqrestore(&fallback->alg_lock, flags);
+
+	if (release)
+		kref_put(&alg->refcount, fallback_alg_release);
+}
+
+static void fallback_skcipher_destroy(struct crypto_alg *base)
+{
+	struct skcipher_alg *alg;
+
+	alg = container_of(base, struct skcipher_alg, base);
+	fallback_alg_destroy(container_of(alg, struct fallback_alg,
+					  alg.skcipher));
+}
+
+static void fallback_aead_destroy(struct crypto_alg *base)
+{
+	struct aead_alg *alg;
+
+	alg = container_of(base, struct aead_alg, base);
+	fallback_alg_destroy(container_of(alg, struct fallback_alg, alg.aead));
+}
+
+static void fallback_ahash_destroy(struct crypto_alg *base)
+{
+	struct hash_alg_common *halg;
+	struct ahash_alg *alg;
+
+	halg = container_of(base, struct hash_alg_common, base);
+	alg = container_of(halg, struct ahash_alg, halg);
+	fallback_alg_destroy(container_of(alg, struct fallback_alg, alg.ahash));
+}
+
+static int fallback_alg_complete_registration(struct fallback_alg *alg, int err)
+{
+	struct crypto_fallback *fallback = alg->fallback;
+	unsigned long flags;
+	bool release = false;
+
+	spin_lock_irqsave(&fallback->alg_lock, flags);
+	alg->registration_complete = true;
+	if (err || alg->dead) {
+		list_del_init(&alg->list);
+		release = true;
+		if (!err)
+			err = -ENODEV;
+	} else {
+		alg->registered = true;
+	}
+	spin_unlock_irqrestore(&fallback->alg_lock, flags);
+
+	if (release)
+		kref_put(&alg->refcount, fallback_alg_release);
+
+	return err;
+}
+
 static struct fallback_alg *fallback_skcipher_alg(struct crypto_skcipher *tfm)
 {
 	return container_of(crypto_skcipher_alg(tfm), struct fallback_alg,
@@ -1068,6 +1172,7 @@ static int fallback_register_skcipher(struct fallback_alg *entry,
 	if (err)
 		goto out_free_software;
 	fallback_init_base(&alg->base, &hcommon->base, &scommon->base, owner);
+	alg->base.cra_destroy = fallback_skcipher_destroy;
 	alg->min_keysize = max(hcommon->min_keysize, scommon->min_keysize);
 	alg->max_keysize = min(hcommon->max_keysize, scommon->max_keysize);
 	if (alg->min_keysize > alg->max_keysize) {
@@ -1129,6 +1234,7 @@ static int fallback_register_aead(struct fallback_alg *entry,
 	if (err)
 		goto out_free_software;
 	fallback_init_base(&alg->base, &halg->base, &salg->base, owner);
+	alg->base.cra_destroy = fallback_aead_destroy;
 	alg->ivsize = halg->ivsize;
 	alg->maxauthsize = min(halg->maxauthsize, salg->maxauthsize);
 	alg->chunksize = max(halg->chunksize, salg->chunksize);
@@ -1187,6 +1293,7 @@ static int fallback_register_ahash(struct fallback_alg *entry,
 		goto out_free_software;
 	fallback_init_base(&alg->halg.base, &hcommon->base, &scommon->base,
 			   owner);
+	alg->halg.base.cra_destroy = fallback_ahash_destroy;
 	alg->halg.base.cra_flags |= CRYPTO_ALG_REQ_VIRT;
 	alg->halg.base.cra_flags |= hcommon->base.cra_flags &
 				    CRYPTO_ALG_OPTIONAL_KEY;
@@ -1246,87 +1353,124 @@ static void fallback_unregister_alg(struct fallback_alg *alg)
 	}
 }
 
-struct crypto_fallback *
-crypto_fallback_register(struct module *owner, struct device *dev,
-			 const struct crypto_fallback_group *groups,
-			 unsigned int num_groups)
+static void fallback_unregister_algs(struct crypto_fallback *fallback)
 {
-	struct crypto_fallback *fallback;
-	unsigned int num_algs = 0;
-	unsigned int i, j;
-	int err;
+	struct fallback_alg *alg;
+	struct fallback_alg *candidate;
+	unsigned long flags;
+
+	for (;;) {
+		alg = NULL;
+		spin_lock_irqsave(&fallback->alg_lock, flags);
+		list_for_each_entry(candidate, &fallback->algs, list) {
+			if (!candidate->registered)
+				continue;
 
-	if (!dev || !groups || !num_groups)
-		return ERR_PTR(-EINVAL);
+			alg = candidate;
+			alg->registered = false;
+			kref_get(&alg->refcount);
+			break;
+		}
+		spin_unlock_irqrestore(&fallback->alg_lock, flags);
 
-	for (i = 0; i < num_groups; i++) {
-		if (!groups[i].algs || !groups[i].num_algs)
-			return ERR_PTR(-EINVAL);
-		if (groups[i].num_algs > UINT_MAX - num_algs)
-			return ERR_PTR(-EOVERFLOW);
-		num_algs += groups[i].num_algs;
+		if (!alg)
+			break;
+
+		fallback_unregister_alg(alg);
+		kref_put(&alg->refcount, fallback_alg_release);
 	}
+}
 
-	fallback = fallback_alloc(dev, groups, num_groups);
-	if (IS_ERR(fallback))
-		return fallback;
+static int fallback_register_algs(struct crypto_fallback *fallback)
+{
+	unsigned int i, j;
+	int err;
 
-	fallback->algs = kcalloc(num_algs, sizeof(*fallback->algs), GFP_KERNEL);
-	if (!fallback->algs) {
-		err = -ENOMEM;
-		goto err_release;
-	}
-	for (i = 0; i < num_groups; i++) {
-		const struct fallback_threshold *threshold;
+	for (i = 0; i < fallback->num_groups; i++) {
+		const struct crypto_fallback_group *group;
 
-		threshold = &fallback->groups[i].threshold;
-		for (j = 0; j < groups[i].num_algs; j++) {
-			const char *driver_name = groups[i].algs[j];
-			struct fallback_alg *alg =
-				&fallback->algs[fallback->num_algs];
+		group = &fallback->groups[i].group;
+		for (j = 0; j < group->num_algs; j++) {
+			struct fallback_alg *alg;
+			unsigned long flags;
 
-			if (!driver_name) {
-				err = -EINVAL;
+			alg = kzalloc_obj(*alg, GFP_KERNEL);
+			if (!alg) {
+				err = -ENOMEM;
 				goto err_unregister_algs;
 			}
 
-			alg->type = groups[i].benchmark.type;
-			alg->threshold = threshold;
-			if (strscpy(alg->driver_name, driver_name,
+			INIT_LIST_HEAD(&alg->list);
+			kref_init(&alg->refcount);
+			alg->fallback = fallback;
+			alg->threshold = &fallback->groups[i].threshold;
+			alg->type = group->benchmark.type;
+			if (strscpy(alg->driver_name, group->algs[j],
 				    sizeof(alg->driver_name)) < 0) {
+				kfree(alg);
 				err = -ENAMETOOLONG;
 				goto err_unregister_algs;
 			}
 
-			err = fallback_register_alg(alg, owner);
+			kref_get(&fallback->refcount);
+			spin_lock_irqsave(&fallback->alg_lock, flags);
+			list_add_tail(&alg->list, &fallback->algs);
+			spin_unlock_irqrestore(&fallback->alg_lock, flags);
+
+			err = fallback_register_alg(alg, fallback->owner);
+			err = fallback_alg_complete_registration(alg, err);
 			if (err == -ENOENT)
 				continue;
 			if (err)
 				goto err_unregister_algs;
-			fallback->num_algs++;
 		}
 	}
 
-	return fallback;
+	return 0;
 
 err_unregister_algs:
-	while (fallback->num_algs)
-		fallback_unregister_alg(&fallback->algs[--fallback->num_algs]);
-err_release:
-	fallback_release(fallback);
+	fallback_unregister_algs(fallback);
 
-	return ERR_PTR(err);
+	return err;
+}
+
+struct crypto_fallback *
+crypto_fallback_register(struct module *owner, struct device *dev,
+			 const struct crypto_fallback_group *groups,
+			 unsigned int num_groups)
+{
+	unsigned int i, j;
+
+	if (!owner || !dev || !groups || !num_groups)
+		return ERR_PTR(-EINVAL);
+
+	for (i = 0; i < num_groups; i++) {
+		if (!groups[i].algs || !groups[i].num_algs)
+			return ERR_PTR(-EINVAL);
+		for (j = 0; j < groups[i].num_algs; j++)
+			if (!groups[i].algs[j])
+				return ERR_PTR(-EINVAL);
+	}
+
+	return fallback_alloc(owner, dev, groups, num_groups);
 }
 EXPORT_SYMBOL_GPL(crypto_fallback_register);
 
 void crypto_fallback_unregister(struct crypto_fallback *fallback)
 {
+	unsigned int i;
+
 	if (!fallback || IS_ERR(fallback))
 		return;
 
-	while (fallback->num_algs)
-		fallback_unregister_alg(&fallback->algs[--fallback->num_algs]);
-	fallback_release(fallback);
+	sysfs_remove_group(&fallback->dev->kobj, &fallback->sysfs_group);
+	mutex_lock(&fallback->lock);
+	WRITE_ONCE(fallback->enabled, false);
+	for (i = 0; i < fallback->num_groups; i++)
+		WRITE_ONCE(fallback->groups[i].threshold.value, 0);
+	fallback_unregister_algs(fallback);
+	mutex_unlock(&fallback->lock);
+	kref_put(&fallback->refcount, crypto_fallback_free);
 }
 EXPORT_SYMBOL_GPL(crypto_fallback_unregister);
 
-- 
2.53.0
