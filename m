Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF632E7D0A2
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Sep 2023 19:44:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229874AbjIUTo5 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 Sep 2023 15:44:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231262AbjIUTo3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Sep 2023 15:44:29 -0400
Received: from mo4-p00-ob.smtp.rzone.de (mo4-p00-ob.smtp.rzone.de [81.169.146.160])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30CD7269D
        for <linux-crypto@vger.kernel.org>; Thu, 21 Sep 2023 10:50:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1695297004; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=cKq8zdRzfLELdyAHh3cFw+gXdBWVBfyVBQxmWbloiAT9G32KO9ClTSXlPBV6dBZsNZ
    Ra+Jh1G6Urrnc0Al4SIenMjkGeASbFFuCVgo5hPTg5s5dvAoJnwTTz9V0SeRWbmaAynN
    qrRIZ9tcBMTOpy84GxS5VrPAF6nVw1pNeWtAdX1PvTRzCML4mPUTvOyM3MgzLre0cZON
    7GWY7+SeSECuU3fujVugpejmyEdXIEYEnw9k6xv2lvEiqesUAi5v9O95Sb8QN7V+JNGO
    qUBsDzPAEmVlRc+frC9PqcSgQQQRVIagOHMxCabUWmmtw2QxEApkNrkMQCO5SG49+MEL
    18BQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1695297004;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=Ka8P0tZszT1efAJLSIadVgwgNlSa3VyJ55rFxWkc4L8=;
    b=lsWPvWtz/hfrXXeEW/pTQlyFW77TvA2aNTjWOHQScNiVm7yfk/X7V1WRdIybpp+SuM
    i0G325BMmFyHyyA6Nv/NL7ouB0nmkGuU7S+/N5KDibLN67vdawhmkYUc/bWnrymNJOAL
    rU4i5ESduPzY23s3v16bwEnOLdVh/uh+xCqHurq3W3TI1oqt+nlgdo+kxndq7hQu3YzW
    1IDAfnVOyfLujtUHdW2XFK4elzjlSY/FnFErznsiPqjwIIn/Qph4li5z1d9AHL8gIwZK
    7zRKKvDy/rFc4N2KVsyRjv2dO3p3eL8CMAJcW6MbMlElY6C6hyQHXYZLNidhPt2G6fmg
    GY7w==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo00
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1695297004;
    s=strato-dkim-0002; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=Ka8P0tZszT1efAJLSIadVgwgNlSa3VyJ55rFxWkc4L8=;
    b=QJgeOH4Pcfpc3LLUM5ZROjfYm7Xg+uIjFhq8RNY8/sytyLcKbyNYU7LtkuEPhFj+1s
    PF1EXBUWVqjpbATQC6R1EWopQtU6MDdOg4AG5X9gSO23TT7oGw47CVj+yY45K4L9S8Vb
    Ni25ff2ZIWb00BnSI4+ji023xDI4Kgyt0N3svpAQvMKVesS14wuFJ257Y4/blA4kETbn
    vEi+HNIjuJHOMU1S9MEy/LZv2ufZUVgq2K8bxQH5xmUM/nqTRcpz/bC/iGPn9LbKFZxv
    iVUkJOJskwHRa2r6VQXwbMdqY/tC6nyKD10YZbnU6YgTbsPXfOSnPLJw7UQI66QytWie
    DCyQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1695297004;
    s=strato-dkim-0003; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=Ka8P0tZszT1efAJLSIadVgwgNlSa3VyJ55rFxWkc4L8=;
    b=Bqe8nUTiljFZJ28nxJgEz8hONIVCTVspzqz60Hq91tXDmhAAwftdW7y0sZf7YtVJh3
    LAVm8OPfoQPNcJbqJ3Aw==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9yGwdNoa/n6V4wJnv+Q=="
Received: from positron.chronox.de
    by smtp.strato.de (RZmta 49.8.2 AUTH)
    with ESMTPSA id u045efz8LBo28tb
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Thu, 21 Sep 2023 13:50:02 +0200 (CEST)
From:   Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, "Ospan, Abylay" <aospan@amazon.com>
Subject: [PATCH 2/3] crypto: jitter - Allow configuration of memory size
Date:   Thu, 21 Sep 2023 13:48:33 +0200
Message-ID: <4514361.LvFx2qVVIh@positron.chronox.de>
In-Reply-To: <2700818.mvXUDI8C0e@positron.chronox.de>
References: <2700818.mvXUDI8C0e@positron.chronox.de>
MIME-Version: 1.0
Autocrypt: addr=smueller@chronox.de;
 keydata=
 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
 kBFBHm+xdudNab2U0OpfqrWerOw3WcGd2
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The memory size consumed by the Jitter RNG is one contributing factor in
the amount of entropy that is gathered. As the amount of entropy
directly correlates with the distance of the memory from the CPU, the
caches that are possibly present on a given system have an impact on the
collected entropy.

Thus, the kernel compile time should offer a means to configure the
amount of memory used by the Jitter RNG. Although this option could be
turned into a runtime option (e.g. a kernel command line option), it
should remain a compile time option as otherwise adminsitrators who may
not have performed an entropy assessment may select a value that is
inappropriate.

The default value selected by the configuration is identical to the
current Jitter RNG value. Thus, the patch should not lead to any change
in the Jitter RNG behavior.

To accommodate larger memory buffers, kvzalloc / kvfree is used.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/Kconfig               | 43 ++++++++++++++++++++++++++++++++++++
 crypto/jitterentropy-kcapi.c | 11 +++++++++
 crypto/jitterentropy.c       | 16 ++++++++------
 crypto/jitterentropy.h       |  2 ++
 4 files changed, 65 insertions(+), 7 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 650b1b3620d8..00c827d9f0d2 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1296,6 +1296,49 @@ config CRYPTO_JITTERENTROPY
 
 	  See https://www.chronox.de/jent.html
 
+choice
+	prompt "CPU Jitter RNG Memory Size"
+	default CRYPTO_JITTERENTROPY_MEMSIZE_2
+	depends on CRYPTO_JITTERENTROPY
+	help
+	  The Jitter RNG measures the execution time of memory accesses.
+	  Multiple consecutive memory accesses are performed. If the memory
+	  size fits into a cache (e.g. L1), only the memory access timing
+	  to that cache is measured. The closer the cache is to the CPU
+	  the less variations are measured and thus the less entropy is
+	  obtained. Thus, if the memory size fits into the L1 cache, the
+	  obtained entropy is less than if the memory size fits within
+	  L1 + L2, which in turn is less if the memory fits into
+	  L1 + L2 + L3. Thus, by selecting a different memory size,
+	  the entropy rate produced by the Jitter RNG can be modified.
+
+	config CRYPTO_JITTERENTROPY_MEMSIZE_2
+		bool "2048 Bytes (default)"
+
+	config CRYPTO_JITTERENTROPY_MEMSIZE_128
+		bool "128 kBytes"
+
+	config CRYPTO_JITTERENTROPY_MEMSIZE_1024
+		bool "1024 kBytes"
+
+	config CRYPTO_JITTERENTROPY_MEMSIZE_8192
+		bool "8192 kBytes"
+endchoice
+
+config CRYPTO_JITTERENTROPY_MEMORY_BLOCKS
+	int
+	default 64 if CRYPTO_JITTERENTROPY_MEMSIZE_2
+	default 512 if CRYPTO_JITTERENTROPY_MEMSIZE_128
+	default 1024 if CRYPTO_JITTERENTROPY_MEMSIZE_1024
+	default 4096 if CRYPTO_JITTERENTROPY_MEMSIZE_8192
+
+config CRYPTO_JITTERENTROPY_MEMORY_BLOCKSIZE
+	int
+	default 32 if CRYPTO_JITTERENTROPY_MEMSIZE_2
+	default 256 if CRYPTO_JITTERENTROPY_MEMSIZE_128
+	default 1024 if CRYPTO_JITTERENTROPY_MEMSIZE_1024
+	default 2048 if CRYPTO_JITTERENTROPY_MEMSIZE_8192
+
 config CRYPTO_JITTERENTROPY_TESTINTERFACE
 	bool "CPU Jitter RNG Test Interface"
 	depends on CRYPTO_JITTERENTROPY
diff --git a/crypto/jitterentropy-kcapi.c b/crypto/jitterentropy-kcapi.c
index 1de730f94683..a8e7bbd28c6e 100644
--- a/crypto/jitterentropy-kcapi.c
+++ b/crypto/jitterentropy-kcapi.c
@@ -54,6 +54,17 @@
  * Helper function
  ***************************************************************************/
 
+void *jent_kvzalloc(unsigned int len)
+{
+	return kvzalloc(len, GFP_KERNEL);
+}
+
+void jent_kvzfree(void *ptr, unsigned int len)
+{
+	memzero_explicit(ptr, len);
+	kvfree(ptr);
+}
+
 void *jent_zalloc(unsigned int len)
 {
 	return kzalloc(len, GFP_KERNEL);
diff --git a/crypto/jitterentropy.c b/crypto/jitterentropy.c
index c99734af82b8..f224ceb1e2e3 100644
--- a/crypto/jitterentropy.c
+++ b/crypto/jitterentropy.c
@@ -75,10 +75,10 @@ struct rand_data {
 
 	unsigned int flags;		/* Flags used to initialize */
 	unsigned int osr;		/* Oversample rate */
-#define JENT_MEMORY_BLOCKS 64
-#define JENT_MEMORY_BLOCKSIZE 32
 #define JENT_MEMORY_ACCESSLOOPS 128
-#define JENT_MEMORY_SIZE (JENT_MEMORY_BLOCKS*JENT_MEMORY_BLOCKSIZE)
+#define JENT_MEMORY_SIZE						\
+	(CONFIG_CRYPTO_JITTERENTROPY_MEMORY_BLOCKS *			\
+	 CONFIG_CRYPTO_JITTERENTROPY_MEMORY_BLOCKSIZE)
 	unsigned char *mem;	/* Memory access location with size of
 				 * memblocks * memblocksize */
 	unsigned int memlocation; /* Pointer to byte in *mem */
@@ -650,13 +650,15 @@ struct rand_data *jent_entropy_collector_alloc(unsigned int osr,
 		/* Allocate memory for adding variations based on memory
 		 * access
 		 */
-		entropy_collector->mem = jent_zalloc(JENT_MEMORY_SIZE);
+		entropy_collector->mem = jent_kvzalloc(JENT_MEMORY_SIZE);
 		if (!entropy_collector->mem) {
 			jent_zfree(entropy_collector);
 			return NULL;
 		}
-		entropy_collector->memblocksize = JENT_MEMORY_BLOCKSIZE;
-		entropy_collector->memblocks = JENT_MEMORY_BLOCKS;
+		entropy_collector->memblocksize =
+			CONFIG_CRYPTO_JITTERENTROPY_MEMORY_BLOCKSIZE;
+		entropy_collector->memblocks =
+			CONFIG_CRYPTO_JITTERENTROPY_MEMORY_BLOCKS;
 		entropy_collector->memaccessloops = JENT_MEMORY_ACCESSLOOPS;
 	}
 
@@ -679,7 +681,7 @@ struct rand_data *jent_entropy_collector_alloc(unsigned int osr,
 
 void jent_entropy_collector_free(struct rand_data *entropy_collector)
 {
-	jent_zfree(entropy_collector->mem);
+	jent_kvzfree(entropy_collector->mem, JENT_MEMORY_SIZE);
 	entropy_collector->mem = NULL;
 	jent_zfree(entropy_collector);
 }
diff --git a/crypto/jitterentropy.h b/crypto/jitterentropy.h
index 626c6228b7e2..e31661ee00d3 100644
--- a/crypto/jitterentropy.h
+++ b/crypto/jitterentropy.h
@@ -1,5 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 
+extern void *jent_kvzalloc(unsigned int len);
+extern void jent_kvzfree(void *ptr, unsigned int len);
 extern void *jent_zalloc(unsigned int len);
 extern void jent_zfree(void *ptr);
 extern void jent_get_nstime(__u64 *out);
-- 
2.42.0




