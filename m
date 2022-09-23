Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 669A3C07E9D
	for <linux-crypto@archiver.kernel.org>; Fri, 23 Sep 2022 20:13:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231741AbiIWUNm (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 23 Sep 2022 16:13:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232149AbiIWUNe (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 23 Sep 2022 16:13:34 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 624821231D6
        for <linux-crypto@vger.kernel.org>; Fri, 23 Sep 2022 13:13:31 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id n15so1568546wrq.5
        for <linux-crypto@vger.kernel.org>; Fri, 23 Sep 2022 13:13:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=23/CF7tfLkvh+nww9EnlgmTsumKJWYoWUnec63NKi1A=;
        b=gV+UxtY0g3SlZ6hGfED5aEL/inzqrRA1e4THqvQHPjE2AdW/D+4jgRiTmpGKZ2QqMT
         LtfUMz69xutCsGO2UKesIC2LZlXHkw8Y2dwVvqP74PcsHtSTMYbqVf4xVAGa7KRwBVo2
         IcX3I8KX6Mog4RlYe6IJ9NPEKjyhuwxiF4eg1Lx9RoG3DRj6UpGmG3Ij5lJXKkSG9IPX
         DAeqzrJ1fwVgyAxGkdp2N6XVFUE8ie0Vz9RsFJ7SYRAtKi/9ZF0HWBYm1zcOut8czPdO
         9eL0B02akLrXYpX1xzJrxKKwEtHx9wPxsSNC1WjO/qSxE0W+3+cGnw42grk9udSoLvDm
         FVKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=23/CF7tfLkvh+nww9EnlgmTsumKJWYoWUnec63NKi1A=;
        b=54RJ1Z0dopTJXPJPnrvL4SGRjTbdkIsc29yrTeFZL32VyI+QYBxH8bN38OpZCGk+ZP
         u4RVUSQxpnIIjcbbqVuOS76mIesdLoOHNnIGkVSNCNzWGuuYTzJA+i3Rh582wXMtHclP
         qs+w4qoa66lvlA6RKWmi4zgi8TuhU9sHycvbHSR5Q5IiLBPRjZHVmYMzitOeDgIlAcJa
         uTrG81tReWB9npRqfKA3uNeS7/HrnSupGGLzER1HqfSIXSJsbKnbIfn21+ZMXvt/CbZ0
         ofohMp7Y2rMN7gdDhB3FNQmmx1RCqM4wzMIbz0rWrk8XeZBCrJo6qF5adFKPL5QOq4ig
         qF0A==
X-Gm-Message-State: ACrzQf0uVCa95XxZBU88bzQ7oAsLFThzV0+DF7gxz3Yfuapgf7xQwVKs
        /bEjtFVODAAHgFGHTsXnmICV9g==
X-Google-Smtp-Source: AMsMyM5EXomzqDs/qpu1iRm5KQDCbfOcAkYsGQRSh6u82J4RGOI9uudHf6vEYaDBlN9jF6lciDbH4Q==
X-Received: by 2002:a5d:654d:0:b0:22a:ff55:e9c9 with SMTP id z13-20020a5d654d000000b0022aff55e9c9mr6068725wrv.14.1663964009896;
        Fri, 23 Sep 2022 13:13:29 -0700 (PDT)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id k11-20020a05600c0b4b00b003b492753826sm3281056wmr.43.2022.09.23.13.13.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Sep 2022 13:13:29 -0700 (PDT)
From:   Dmitry Safonov <dima@arista.com>
To:     linux-kernel@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Cc:     Dmitry Safonov <dima@arista.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Ard Biesheuvel <ardb@kernel.org>,
        Bob Gilligan <gilligan@arista.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Ivan Delalande <colona@arista.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Leonard Crestez <cdleonard@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: [PATCH v2 02/35] crypto_pool: Add crypto_pool_reserve_scratch()
Date:   Fri, 23 Sep 2022 21:12:46 +0100
Message-Id: <20220923201319.493208-3-dima@arista.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220923201319.493208-1-dima@arista.com>
References: <20220923201319.493208-1-dima@arista.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Instead of having build-time hardcoded constant, reallocate scratch
area, if needed by user. Different algos, different users may need
different size of temp per-CPU buffer. Only up-sizing supported for
simplicity.

Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 crypto/Kconfig        |  6 +++++
 crypto/crypto_pool.c  | 63 +++++++++++++++++++++++++++++++++----------
 include/crypto/pool.h |  3 +--
 3 files changed, 56 insertions(+), 16 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index aeddaa3dcc77..e5865be483be 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -2134,6 +2134,12 @@ config CRYPTO_POOL
 	help
 	  Per-CPU pool of crypto requests ready for usage in atomic contexts.
 
+config CRYPTO_POOL_DEFAULT_SCRATCH_SIZE
+	hex "Per-CPU default scratch area size"
+	depends on CRYPTO_POOL
+	default 0x100
+	range 0x100 0x10000
+
 source "drivers/crypto/Kconfig"
 source "crypto/asymmetric_keys/Kconfig"
 source "certs/Kconfig"
diff --git a/crypto/crypto_pool.c b/crypto/crypto_pool.c
index 37131952c5a7..a1ad35c24f09 100644
--- a/crypto/crypto_pool.c
+++ b/crypto/crypto_pool.c
@@ -1,13 +1,14 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 
 #include <crypto/pool.h>
+#include <linux/cpu.h>
 #include <linux/kref.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/percpu.h>
 #include <linux/workqueue.h>
 
-static unsigned long scratch_size = DEFAULT_CRYPTO_POOL_SCRATCH_SZ;
+static unsigned long scratch_size = CONFIG_CRYPTO_POOL_DEFAULT_SCRATCH_SIZE;
 static DEFINE_PER_CPU(void *, crypto_pool_scratch);
 
 struct crypto_pool_entry {
@@ -22,26 +23,61 @@ static struct crypto_pool_entry cpool[CPOOL_SIZE];
 static unsigned int cpool_populated;
 static DEFINE_MUTEX(cpool_mutex);
 
-static int crypto_pool_scratch_alloc(void)
+static void __set_scratch(void *scratch)
 {
-	int cpu;
+	kfree(this_cpu_read(crypto_pool_scratch));
+	this_cpu_write(crypto_pool_scratch, scratch);
+}
 
-	lockdep_assert_held(&cpool_mutex);
+/* Slow-path */
+/**
+ * crypto_pool_reserve_scratch - re-allocates scratch buffer, slow-path
+ * @size: request size for the scratch/temp buffer
+ */
+int crypto_pool_reserve_scratch(unsigned long size)
+{
+	int cpu, err = 0;
 
+	mutex_lock(&cpool_mutex);
+	if (size == scratch_size) {
+		for_each_possible_cpu(cpu) {
+			if (per_cpu(crypto_pool_scratch, cpu))
+				continue;
+			goto allocate_scratch;
+		}
+		mutex_unlock(&cpool_mutex);
+		return 0;
+	}
+allocate_scratch:
+	size = max(size, scratch_size);
+	cpus_read_lock();
 	for_each_possible_cpu(cpu) {
-		void *scratch = per_cpu(crypto_pool_scratch, cpu);
+		void *scratch;
 
-		if (scratch)
-			continue;
+		scratch = kmalloc_node(size, GFP_KERNEL, cpu_to_node(cpu));
+		if (!scratch) {
+			err = -ENOMEM;
+			break;
+		}
 
-		scratch = kmalloc_node(scratch_size, GFP_KERNEL,
-				       cpu_to_node(cpu));
-		if (!scratch)
-			return -ENOMEM;
-		per_cpu(crypto_pool_scratch, cpu) = scratch;
+		if (!cpu_online(cpu)) {
+			kfree(per_cpu(crypto_pool_scratch, cpu));
+			per_cpu(crypto_pool_scratch, cpu) = scratch;
+			continue;
+		}
+		err = smp_call_function_single(cpu, __set_scratch, scratch, 1);
+		if (err) {
+			kfree(scratch);
+			break;
+		}
 	}
-	return 0;
+
+	cpus_read_unlock();
+	scratch_size = size;
+	mutex_unlock(&cpool_mutex);
+	return err;
 }
+EXPORT_SYMBOL_GPL(crypto_pool_reserve_scratch);
 
 static void crypto_pool_scratch_free(void)
 {
@@ -138,7 +174,6 @@ int crypto_pool_alloc_ahash(const char *alg)
 
 	/* slow-path */
 	mutex_lock(&cpool_mutex);
-
 	for (i = 0; i < cpool_populated; i++) {
 		if (cpool[i].alg && !strcmp(cpool[i].alg, alg)) {
 			if (kref_read(&cpool[i].kref) > 0) {
diff --git a/include/crypto/pool.h b/include/crypto/pool.h
index 2c61aa45faff..c7d817860cc3 100644
--- a/include/crypto/pool.h
+++ b/include/crypto/pool.h
@@ -4,8 +4,6 @@
 
 #include <crypto/hash.h>
 
-#define DEFAULT_CRYPTO_POOL_SCRATCH_SZ	128
-
 struct crypto_pool {
 	void *scratch;
 };
@@ -20,6 +18,7 @@ struct crypto_pool_ahash {
 	struct ahash_request *req;
 };
 
+int crypto_pool_reserve_scratch(unsigned long size);
 int crypto_pool_alloc_ahash(const char *alg);
 void crypto_pool_add(unsigned int id);
 void crypto_pool_release(unsigned int id);
-- 
2.37.2

