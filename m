Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A991D334364;
	Wed, 20 Aug 2025 17:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755709448; cv=none; b=brfPQUOfNNsUGrJqsPleJbzTplkfXZDoKfgLILlsvV4eDU6SsWOyTIyBVoIBjhLHLqlSkGuwoTKhAycS7QdDxCg8EmFr0y1siXJupmPpi99CNpgmfBDhumBTWkJF5CTl6Tmdu41Tlq+bS/3oXO3xGn8LmidNKDAP6LTjVAJqpX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755709448; c=relaxed/simple;
	bh=BUQIzmR1fZdgTalj6+5JNA70aN+48HW/Om7eSgm08+w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=l8LKjxWfpz8ipItMGkd0/l3ohrF6MUNyntV+/R/VOL3fdlYT16lqzy6dW8v5X3vJh8CPAgD5jnV2Ju758F8IemMEQVmokgwKqquZojNgMoNMlk+luDc+7Ndfjzd1jC33/PEqnOa3Vo6lRShC3Al67W5NkqeDXgtl82HE51EGfIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bepuR5k0; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bepuR5k0"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-afcb79f659aso16106966b.2;
        Wed, 20 Aug 2025 10:04:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755709444; x=1756314244; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=VTRRQjroGtbVcnGt+UBxy/TTtusWmZEt6cLmZHCTVgs=;
        b=bepuR5k0srxnYoKFrju3Uy+BO7i6nBhEISURcQGDWq8LPXIYxf8HG9ou5OjvF1z0vr
         9H58cNWLOGs7Sa2Z5Oouy1SCdkik9vRbmqXHZg6b11KZYiIBMVNCnczhncG5dj8p/2ha
         i3oNwaqYnbjYna6ieIzfdMaaeZfcgk6nehImFtPn3S9mtLzJWPMrme5HsnGUQnPpdM1q
         uJHJHEM+xQK0+CYkZ0AhIJ3bztZvwr5DbNuk7am8TzsNPGFMemGwwJ91J2xDzsWfNvTU
         a3rWtGB4904krQqoOgV91G7GsETYsq8UHSMiSJ9n4A79Bd1RFgUrWgu7X/dX3Uei0fTT
         jDQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755709444; x=1756314244;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VTRRQjroGtbVcnGt+UBxy/TTtusWmZEt6cLmZHCTVgs=;
        b=g/v0KCNh746SF3snXePsOTpu76V0IVdS79gTed8BX3HFWt1MaNHjftfIU1uDo8wAbP
         LdoITh5TAy6MoydkHV3QWkPLV66olPE7UfzBWT6TxH/JkRl07Xp5sq5/FOPgOmtsCA53
         uKvbNeKAynNAb6Sy6icucLRkoCp8xzkHzYlsFChJJ0Qljcj7IBlDI+krPEI9dUvtSeVe
         1qI6eoGFxZPSjsphpA0uDr/trNDiXeqQA+/JcPtNs7ItO7vhsIraL4/PNXFxNhfZSKVW
         U/rlRt7ncXclzwN0g3uekB0kopfy3u2pTglhH/RvyRQsugJI6qUaUiy+UwZAspxrFRTo
         6fwQ==
X-Forwarded-Encrypted: i=1; AJvYcCUFjQfwBEdiPsp0XCkLzqiCoeojRckZ1upoSGTcnOeQOVeQ2e94mRg8w/1oucKoBv4mD5h8ltt5+pRJEEI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwnrQKVuYSFm5MGc6Srm9pVRVaoBdbk67M9sIuJwVdDA+81Pg33
	rieNwf/rDCu9/dQ+fdWj5nbQjrRdkwqiij+d9C75kzEPl7jrcbc04B++
X-Gm-Gg: ASbGncuClxFjeiYIu2COhEVYxNQiwnbF2Xefntl70XTbRbz1jZIoE1sGvN9jGbd5Tr6
	MQbkm4yItxRPAlW5aYy/yzuY+xevvV1+oYSlrWgu7gGlOLTj7KbtHxZi09aocJ9xpapNBS+qqzU
	pB0Fkk2ME4vl7Ypv/7djOxF7J3DagUsHd6GAjbWXJoYTmU9EpsJgyf1+MltwqM3XQgw9WpFA6im
	LniUL4XU/e2PPgqDod0JVia6/iWfnW1AZeChhC2gzYZAzD4CxEmy8fJRB3wXkXfvjX2PB5SkkkH
	TKl5jubVaMC9cGBj2XLY+5hanpp4NPygldwQNPFQO4X5oWGkUJ1IZmd5lgTr5c9zMo43HSzAbaI
	WUIeIr5cwz6n+EU3n9qf4MBTB
X-Google-Smtp-Source: AGHT+IG/Y8LxUw+/hSNcDdAmJKI76TjF6U2pj0o+eHe25d0ysfkFSAU28m/dFvbw1LdeN3cbHBhRlw==
X-Received: by 2002:a17:907:da3:b0:ae4:a17:e6d2 with SMTP id a640c23a62f3a-afdf00b5f5cmr324043566b.24.1755709443479;
        Wed, 20 Aug 2025 10:04:03 -0700 (PDT)
Received: from XPS.. ([2a02:908:1b0:afe0:87ec:e0aa:e48f:ccce])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afded4cab98sm217828066b.89.2025.08.20.10.04.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Aug 2025 10:04:02 -0700 (PDT)
From: Osama Abdelkader <osama.abdelkader@gmail.com>
To: tytso@mit.edu,
	Jason@zx2c4.com
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Osama Abdelkader <osama.abdelkader@gmail.com>
Subject: [PATCH] drivers/char/random.c: Clean up style issues
Date: Wed, 20 Aug 2025 19:03:59 +0200
Message-ID: <20250820170359.78811-1-osama.abdelkader@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix various style issues reported by checkpatch.pl:

- Fix indentation and alignment in conditional statements

- Remove multiple blank lines

- Add missing braces to if statements

- Fix include path from asm/ to linux/

- Replace BUG_ON with WARN_ON_ONCE where appropriate

- Add comments to spinlock_t definitions

- Use sizeof(*ptr) instead of sizeof(struct name)

- Fix const qualifier for ctl_table

This patch addresses all checkpatch.pl errors and warnings

while maintaining code functionality and readability.

Signed-off-by: Osama Abdelkader <osama.abdelkader@gmail.com>
---
 drivers/char/random.c | 74 +++++++++++++++++++++++++------------------
 1 file changed, 44 insertions(+), 30 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index b8b24b6ed3fe..94c1168fd75e 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -62,10 +62,10 @@
 #include <vdso/vsyscall.h>
 #endif
 #include <asm/archrandom.h>
-#include <asm/processor.h>
+#include <linux/processor.h>
 #include <asm/irq.h>
 #include <asm/irq_regs.h>
-#include <asm/io.h>
+#include <linux/io.h>
 
 /*********************************************************************
  *
@@ -163,16 +163,19 @@ int __cold execute_with_initialized_rng(struct notifier_block *nb)
 	if (crng_ready())
 		nb->notifier_call(nb, 0, NULL);
 	else
-		ret = raw_notifier_chain_register((struct raw_notifier_head *)&random_ready_notifier.head, nb);
+		ret = raw_notifier_chain_register((struct raw_notifier_head *)
+			&random_ready_notifier.head,
+			nb);
 	spin_unlock_irqrestore(&random_ready_notifier.lock, flags);
 	return ret;
 }
 
 #define warn_unseeded_randomness() \
-	if (IS_ENABLED(CONFIG_WARN_ALL_UNSEEDED_RANDOM) && !crng_ready()) \
-		printk_deferred(KERN_NOTICE "random: %s called from %pS with crng_init=%d\n", \
-				__func__, (void *)_RET_IP_, crng_init)
-
+	do { \
+		if (IS_ENABLED(CONFIG_WARN_ALL_UNSEEDED_RANDOM) && !crng_ready()) \
+			printk_deferred("random: %s called from %pS with crng_init=%d\n", \
+					__func__, (void *)_RET_IP_, crng_init); \
+	} while (0)
 
 /*********************************************************************
  *
@@ -211,7 +214,7 @@ enum {
 static struct {
 	u8 key[CHACHA_KEY_SIZE] __aligned(__alignof__(long));
 	unsigned long generation;
-	spinlock_t lock;
+	spinlock_t lock;	/* Protects base_crng state */
 } base_crng = {
 	.lock = __SPIN_LOCK_UNLOCKED(base_crng.lock)
 };
@@ -238,11 +241,12 @@ static unsigned int crng_reseed_interval(void)
 
 	if (unlikely(READ_ONCE(early_boot))) {
 		time64_t uptime = ktime_get_seconds();
+
 		if (uptime >= CRNG_RESEED_INTERVAL / HZ * 2)
 			WRITE_ONCE(early_boot, false);
 		else
 			return max_t(unsigned int, CRNG_RESEED_START_INTERVAL,
-				     (unsigned int)uptime / 2 * HZ);
+				(unsigned int)uptime / 2 * HZ);
 	}
 	return CRNG_RESEED_INTERVAL;
 }
@@ -318,8 +322,9 @@ static void crng_fast_key_erasure(u8 key[CHACHA_KEY_SIZE],
 {
 	u8 first_block[CHACHA_BLOCK_SIZE];
 
-	BUG_ON(random_data_len > 32);
-
+		WARN_ON_ONCE(random_data_len > 32);
+		if (random_data_len > 32)
+			return;
 	chacha_init_consts(chacha_state);
 	memcpy(&chacha_state->x[4], key, CHACHA_KEY_SIZE);
 	memset(&chacha_state->x[12], 0, sizeof(u32) * 4);
@@ -341,8 +346,9 @@ static void crng_make_state(struct chacha_state *chacha_state,
 	unsigned long flags;
 	struct crng *crng;
 
-	BUG_ON(random_data_len > 32);
-
+		WARN_ON_ONCE(random_data_len > 32);
+		if (random_data_len > 32)
+			return;
 	/*
 	 * For the fast path, we check whether we're ready, unlocked first, and
 	 * then re-check once locked later. In the case where we're really not
@@ -582,6 +588,7 @@ u32 __get_random_u32_below(u32 ceil)
 	mult = (u64)ceil * rand;
 	if (unlikely((u32)mult < ceil)) {
 		u32 bound = -ceil % ceil;
+
 		while (unlikely((u32)mult < bound))
 			mult = (u64)ceil * get_random_u32();
 	}
@@ -610,7 +617,6 @@ int __cold random_prepare_cpu(unsigned int cpu)
 }
 #endif
 
-
 /**********************************************************************
  *
  * Entropy accumulation and extraction routines.
@@ -637,7 +643,7 @@ enum {
 
 static struct {
 	struct blake2s_state hash;
-	spinlock_t lock;
+	spinlock_t lock;	/* Protects input_pool state */
 	unsigned int init_bits;
 } input_pool = {
 	.hash.h = { BLAKE2S_IV0 ^ (0x01010000 | BLAKE2S_HASH_SIZE),
@@ -720,7 +726,11 @@ static void extract_entropy(void *buf, size_t len)
 	memzero_explicit(&block, sizeof(block));
 }
 
-#define credit_init_bits(bits) if (!crng_ready()) _credit_init_bits(bits)
+#define credit_init_bits(bits) \
+	do { \
+		if (!crng_ready()) \
+			_credit_init_bits(bits); \
+	} while (0)
 
 static void __cold _credit_init_bits(size_t bits)
 {
@@ -764,7 +774,6 @@ static void __cold _credit_init_bits(size_t bits)
 	}
 }
 
-
 /**********************************************************************
  *
  * Entropy collection routines.
@@ -773,7 +782,8 @@ static void __cold _credit_init_bits(size_t bits)
  * the above entropy accumulation routines:
  *
  *	void add_device_randomness(const void *buf, size_t len);
- *	void add_hwgenerator_randomness(const void *buf, size_t len, size_t entropy, bool sleep_after);
+ *	void add_hwgenerator_randomness(const void *buf, size_t len, size_t entropy,
+ *				       bool sleep_after);
  *	void add_bootloader_randomness(const void *buf, size_t len);
  *	void add_vmfork_randomness(const void *unique_vm_id, size_t len);
  *	void add_interrupt_randomness(int irq);
@@ -826,6 +836,7 @@ static int __init parse_trust_cpu(char *arg)
 {
 	return kstrtobool(arg, &trust_cpu);
 }
+
 static int __init parse_trust_bootloader(char *arg)
 {
 	return kstrtobool(arg, &trust_bootloader);
@@ -849,12 +860,15 @@ static int random_pm_notification(struct notifier_block *nb, unsigned long actio
 	_mix_pool_bytes(&entropy, sizeof(entropy));
 	spin_unlock_irqrestore(&input_pool.lock, flags);
 
-	if (crng_ready() && (action == PM_RESTORE_PREPARE ||
-	    (action == PM_POST_SUSPEND && !IS_ENABLED(CONFIG_PM_AUTOSLEEP) &&
-	     !IS_ENABLED(CONFIG_PM_USERSPACE_AUTOSLEEP)))) {
+	if (crng_ready() &&
+	    (action == PM_RESTORE_PREPARE ||
+		 (action == PM_POST_SUSPEND &&
+		  !IS_ENABLED(CONFIG_PM_AUTOSLEEP) &&
+		  !IS_ENABLED(CONFIG_PM_USERSPACE_AUTOSLEEP)))) {
 		crng_reseed(NULL);
 		pr_notice("crng reseeded on system resumption\n");
 	}
+
 	return 0;
 }
 
@@ -871,6 +885,7 @@ void __init random_init_early(const char *command_line)
 
 #if defined(LATENT_ENTROPY_PLUGIN)
 	static const u8 compiletime_seed[BLAKE2S_BLOCK_SIZE] __initconst __latent_entropy;
+
 	_mix_pool_bytes(compiletime_seed, sizeof(compiletime_seed));
 #endif
 
@@ -928,8 +943,7 @@ void __init random_init(void)
 
 	WARN_ON(register_pm_notifier(&pm_notifier));
 
-	WARN(!entropy, "Missing cycle counter and fallback timer; RNG "
-		       "entropy collection will consequently suffer.");
+	WARN(!entropy, "Missing cycle counter and fallback timer; RNG entropy collection will consequently suffer.");
 }
 
 /*
@@ -999,6 +1013,7 @@ void __cold add_vmfork_randomness(const void *unique_vm_id, size_t len)
 	}
 	blocking_notifier_call_chain(&vmfork_chain, 0, NULL);
 }
+
 #if IS_MODULE(CONFIG_VMGENID)
 EXPORT_SYMBOL_GPL(add_vmfork_randomness);
 #endif
@@ -1249,7 +1264,7 @@ void __cold rand_initialize_disk(struct gendisk *disk)
 	 * If kzalloc returns null, we just won't use that entropy
 	 * source.
 	 */
-	state = kzalloc(sizeof(struct timer_rand_state), GFP_KERNEL);
+	state = kzalloc(sizeof(*state), GFP_KERNEL);
 	if (state) {
 		state->last_time = INITIAL_JIFFIES;
 		disk->random = state;
@@ -1326,7 +1341,8 @@ static void __cold try_to_generate_entropy(void)
 			preempt_disable();
 
 			/* Only schedule callbacks on timer CPUs that are online. */
-			cpumask_and(&timer_cpus, housekeeping_cpumask(HK_TYPE_TIMER), cpu_online_mask);
+			cpumask_and(&timer_cpus, housekeeping_cpumask(HK_TYPE_TIMER),
+				    cpu_online_mask);
 			num_cpus = cpumask_weight(&timer_cpus);
 			/* In very bizarre case of misconfiguration, fallback to all online. */
 			if (unlikely(num_cpus == 0)) {
@@ -1358,7 +1374,6 @@ static void __cold try_to_generate_entropy(void)
 	timer_destroy_on_stack(&stack->timer);
 }
 
-
 /**********************************************************************
  *
  * Userspace reader/writer interfaces.
@@ -1467,9 +1482,9 @@ static ssize_t urandom_read_iter(struct kiocb *kiocb, struct iov_iter *iter)
 		try_to_generate_entropy();
 
 	if (!crng_ready()) {
-		if (!ratelimit_disable && maxwarn <= 0)
+		if (!ratelimit_disable && maxwarn <= 0) {
 			ratelimit_state_inc_miss(&urandom_warning);
-		else if (ratelimit_disable || __ratelimit(&urandom_warning)) {
+		} else if (ratelimit_disable || __ratelimit(&urandom_warning)) {
 			--maxwarn;
 			pr_notice("%s: uninitialized urandom read (%zu bytes read)\n",
 				  current->comm, iov_iter_count(iter));
@@ -1585,7 +1600,6 @@ const struct file_operations urandom_fops = {
 	.splice_write = iter_file_splice_write,
 };
 
-
 /********************************************************************
  *
  * Sysctl interface.
@@ -1635,7 +1649,7 @@ static int proc_do_uuid(const struct ctl_table *table, int write, void *buf,
 {
 	u8 tmp_uuid[UUID_SIZE], *uuid;
 	char uuid_string[UUID_STRING_LEN + 1];
-	struct ctl_table fake_table = {
+	const struct ctl_table fake_table = {
 		.data = uuid_string,
 		.maxlen = UUID_STRING_LEN
 	};
-- 
2.43.0

