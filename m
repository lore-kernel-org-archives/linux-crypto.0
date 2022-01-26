Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AB3DC63684
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Jan 2022 07:07:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237560AbiAZHH2 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 26 Jan 2022 02:07:28 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([81.169.146.165]:42959 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237561AbiAZHH0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 26 Jan 2022 02:07:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1643180841;
    s=strato-dkim-0002; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=Tb+/R4VeZRchDqAEt0T0RO2auPARtJChbG6noS5Z9qM=;
    b=FjLW6l/aYQDmbAVsgRh5zI7DZun6YlmF3FOtkHGxbMTl8psUPYz98icadl8NGI3Beg
    PaakFlwNDw4sxz8IZH+LJff1m/3OQHhZeucqiQAW2QjUIF1GXilckJXL5hdW7aqiH4XE
    /XCV+Qu3KBO61KvVfZNccqPOawvJpv2S/+ysx/fIL869d9Qt6S/oSCksmypS6NyEOFvf
    DCEdTVOFUfPr0fczGFvUDVoPDGCXRls+6LLvNQnfoAUReXvrvry+9az2tAGtZB20uvye
    URUipSCj9cG0P8DRm8+njsW8eapBmni//qQciBf5Lj2oAnXqnP0fE/Uzp5JVIxKqGFT2
    fvPw==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPaJvScdWrN"
X-RZG-CLASS-ID: mo00
Received: from positron.chronox.de
    by smtp.strato.de (RZmta 47.38.0 DYNA|AUTH)
    with ESMTPSA id v5f65ay0Q77KiuQ
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Wed, 26 Jan 2022 08:07:20 +0100 (CET)
From:   Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, simo@redhat.com,
        Nicolai Stange <nstange@suse.de>
Subject: [PATCH 3/7] crypto: Entropy Source and DRNG Manager
Date:   Wed, 26 Jan 2022 08:04:03 +0100
Message-ID: <9995914.tdPhlSkOF2@positron.chronox.de>
In-Reply-To: <2486550.t9SDvczpPo@positron.chronox.de>
References: <2486550.t9SDvczpPo@positron.chronox.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The kernel crypto API contains deterministic random number generators
(DRNG) which a caller must seed and reseed. The task of seeding a DRNG
is a non-trivial task requiring the consideration of a significant
number of aspects. The Entropy Source and DRNG Manager (ESDM) fills
that gap to transparently seed and reseed DRNGs. A user of the ESDM
obtains random numbers from an appropriately seeded and initialized
DRNG. Further, the ESDM controls various entropy sources guaranteeing
that they are properly initialized and managed.

The ESDM consists of two main parts:

- The entropy source (ES) manager implemented in esdm_es_mgr.c
  controls the available entropy sources including pulling appropritate
  amount of data from them for the DRNG manager.

- The DRNG manager provided with esdm_drng_mgr.c controls the DRNG(s)
  and ensures proper seeding and reseeding.

The entropy source manager controls the entropy sources registered in
the esdm_es array. The entropy sources provide a function pointer data
structure that is used to obtain the services from it.

The ES manager triggers the initial seeding of the DRNGs during boot
time in three stages:

1. The DRNG is seeded from the entropy sources if all entropy sources
   collectively have at least 32 bits of entropy available. The goal
   of this step is to ensure that the DRNG receive some initial entropy
   as early as possible.

2. The DRNG is reseeded from the entropy sources if all entropy sources
   collectively have at least 128 bits of entropy available.

3. The DRNG is reseeded from the entropy sources if all entropy sources
   collectively have at least 256 bits of entropy available.

At the time of the reseeding steps, the DRNG requests as much entropy as
is available in order to skip certain steps and reach the seeding level
of 256 bits. This may imply that one or more of the aforementioned steps
are skipped.

In all listed steps, the DRNG is (re)seeded with a number of random bytes
from the entropy pool that is at most the amount of entropy present in
the entropy pool. This means that for example when the entropy pool
contains 128 or more bits of entropy, the DRNG is seeded with that amount
of entropy as well.

Entropy sources (ES) inform the ES manager when new entropy has been
collected using the esdm_es_add_entropy() function. That function
schedules a DRNG (re)seed with the DRNG manager. When the DRNG manager
requests entropy data, the function esdm_fill_seed_buffer fills the seed
buffer by iterating through all available ES. The output of all entropy
sources is concatenated with each other. Further, the seed buffer
contains the amount of entropy each entropy credits its data. Finally a
time stamp is added.

The ES trigger such (re)seeding events only as long as not all DRNGs
are fully seeded with 256 bits of entropy. Once that seeding level is
reached, the triggers are not further processed.

The DRNG manager initializes the initial DRNG instance during late stage
of the kernel boot process before user space is triggered. The DRNG is
seeded at the following occasions:

- when the DRNG is initialized, the available amount of entropy is used,

- during boot time until the DRNG is fully initialized, the reaching of
  the aforementioned seeding steps of 32/128/256 bits of entropy trigger
  a reseed of the DRNG.

- at runtime after the elapse of 600 seconds since the last seeding,
  the DRNG reseeding flag is raised

- at runtime when more than 2^20 generate operations were performed by
  the given DRNG since last reseeding, the reseeding flag is raised

Raising the reseeding flag implies that the DRNG is seeded in process
context the next time a caller requests random numbers.

At runtime, the DRNG manager requires at least 128 bits of entropy from
the entropy sources (or 256 bits when the FIPS mode is active to be
SP800-90C compliant). It may be possible that the entropy sources may
not deliver that amount. The DRNG is reseeded with the available amount
of entropy and continues to operate. Yet, when after 2^30 generate
requests since the last seeding with 128 bits (or 256 bits in FIPS mode)
the DRNG cannot be seeded with 128 bits (or 256 bits), the DRNG becomes
unseeded which means it will not produce random numbers until it is
fully reseeded again.

To support the DRNG manager, a DRNG implementation is provided with
esdm_drng_kcapi.c. It uses the kernel crypto API RNG framework and
allows the specification of the used DRNG with the kernel command line
option of esdm_drng_kcapi.drng_name. If no reference is given, the
default is the SP800-90A DRBG. In case the chosen DRNG requires the seed
to have a certain length, a hash is used bring the entropy buffer into
the proper size.

In addition, the DRNG manager controls the message digest implementation
offered to entropy sources when they want to perform a conditioning
operation. As entropy sources may require the conditioning operation at
any time, the default is a SHA-256 software hash implementation that
neither sleeps nor does it need any memory allocation operation.
Therefore, this hash is available even for the earliest kernel
operations.

The initial drop of the ESDM includes the entropy source of the
"auxiliary" pool. This entropy source must always be present. It is an
entropy pool that is based on the state of a message digest. Every
insertion of data is a hash update operation. In order to obtain data, a
hash final operation is performed. The purpose of this auxiliary pool is
twofold:

- Provide a general interface to inject an arbitrary amount of data from
  any external source. When providing such data, the caller may specify
  the amount of entropy it contains.

- The auxiliary pool also provides the backtracking resistance for all
  entropy sources. Once a seed buffer is filled from all entropy sources
  it is re-inserted into the auxiliary pool at the same time it is used
  for seeding the DRNG. Naturally, the insertion of the seed buffer into
  the auxiliary pool is not credited with any entropy.

If enabled during compile time with the option of
CONFIG_CRYPTO_ESDM_OVERSAMPLE_ENTROPY_SOURCES, the entropy source
oversampling is activated. However, this oversampling is only enforced
if the kernel is booted with fips=1. The oversampling pulls 128 more
bits of entropy than originally requested. This implies that when 256
bits of entropy are requested for a (re)seed of a DRNG, the ES are
queried for 384 bits. This oversampling complies with SP800-90C.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/Kconfig                 |   2 +
 crypto/Makefile                |   1 +
 crypto/esdm/Kconfig            |  79 +++++++
 crypto/esdm/Makefile           |  10 +
 crypto/esdm/esdm_definitions.h | 141 ++++++++++++
 crypto/esdm/esdm_drng_kcapi.c  | 201 +++++++++++++++++
 crypto/esdm/esdm_drng_kcapi.h  |  13 ++
 crypto/esdm/esdm_drng_mgr.c    | 398 +++++++++++++++++++++++++++++++++
 crypto/esdm/esdm_drng_mgr.h    |  85 +++++++
 crypto/esdm/esdm_es_aux.c      | 332 +++++++++++++++++++++++++++
 crypto/esdm/esdm_es_aux.h      |  44 ++++
 crypto/esdm/esdm_es_mgr.c      | 364 ++++++++++++++++++++++++++++++
 crypto/esdm/esdm_es_mgr.h      |  46 ++++
 crypto/esdm/esdm_es_mgr_cb.h   |  67 ++++++
 crypto/esdm/esdm_sha.h         |  14 ++
 crypto/esdm/esdm_sha256.c      |  72 ++++++
 include/crypto/esdm.h          | 115 ++++++++++
 17 files changed, 1984 insertions(+)
 create mode 100644 crypto/esdm/Kconfig
 create mode 100644 crypto/esdm/Makefile
 create mode 100644 crypto/esdm/esdm_definitions.h
 create mode 100644 crypto/esdm/esdm_drng_kcapi.c
 create mode 100644 crypto/esdm/esdm_drng_kcapi.h
 create mode 100644 crypto/esdm/esdm_drng_mgr.c
 create mode 100644 crypto/esdm/esdm_drng_mgr.h
 create mode 100644 crypto/esdm/esdm_es_aux.c
 create mode 100644 crypto/esdm/esdm_es_aux.h
 create mode 100644 crypto/esdm/esdm_es_mgr.c
 create mode 100644 crypto/esdm/esdm_es_mgr.h
 create mode 100644 crypto/esdm/esdm_es_mgr_cb.h
 create mode 100644 crypto/esdm/esdm_sha.h
 create mode 100644 crypto/esdm/esdm_sha256.c
 create mode 100644 include/crypto/esdm.h

diff --git a/crypto/Kconfig b/crypto/Kconfig
index a0de01ab6f0c..91f5ed9aab4f 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1790,6 +1790,8 @@ config CRYPTO_ZSTD
 
 comment "Random Number Generation"
 
+source "crypto/esdm/Kconfig"
+
 config CRYPTO_ANSI_CPRNG
 	tristate "Pseudo Random Number Generation for Cryptographic modules"
 	select CRYPTO_AES
diff --git a/crypto/Makefile b/crypto/Makefile
index d76bff8d0ffd..2b9aadbb5c69 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -159,6 +159,7 @@ obj-$(CONFIG_CRYPTO_LZ4HC) += lz4hc.o
 obj-$(CONFIG_CRYPTO_XXHASH) += xxhash_generic.o
 obj-$(CONFIG_CRYPTO_842) += 842.o
 obj-$(CONFIG_CRYPTO_RNG2) += rng.o
+obj-$(CONFIG_CRYPTO_ESDM) += esdm/
 obj-$(CONFIG_CRYPTO_ANSI_CPRNG) += ansi_cprng.o
 obj-$(CONFIG_CRYPTO_DRBG) += drbg.o
 obj-$(CONFIG_CRYPTO_JITTERENTROPY) += jitterentropy_rng.o
diff --git a/crypto/esdm/Kconfig b/crypto/esdm/Kconfig
new file mode 100644
index 000000000000..1351d4d146dc
--- /dev/null
+++ b/crypto/esdm/Kconfig
@@ -0,0 +1,79 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# Entropy Source and DRNG Manager configuration
+#
+
+config CRYPTO_ESDM
+	bool "ESDM Implementation"
+	default n
+	select CRYPTO_LIB_SHA256 if CRYPTO
+	help
+	  The Entropy Source and DRNG Manager (ESDM) generates entropy
+	  from different entropy sources. Each entropy source can
+	  be enabled and configured independently. The interrupt
+	  entropy source can be configured to be SP800-90B compliant.
+	  The entire ESDM can be configured to be SP800-90C compliant.
+	  Runtime-switchable cryptographic support is available.
+	  The ESDM delivers significant entropy during boot.
+
+	  The ESDM also provides compliance to SP800-90A/B/C.
+
+menu "Entropy Source and DRNG Manager Configuration"
+	depends on CRYPTO_ESDM
+
+if CRYPTO_ESDM
+
+config CRYPTO_ESDM_SHA256
+	bool
+	default y if CRYPTO_LIB_SHA256
+
+menu "Specific DRNG seeding strategies"
+
+config CRYPTO_ESDM_OVERSAMPLE_ENTROPY_SOURCES
+	bool "Oversample entropy sources"
+	default n
+	help
+	  When enabling this option, the entropy sources are
+	  over-sampled with the following approach: First, the
+	  the entropy sources are requested to provide 64 bits more
+	  entropy than the size of the entropy buffer. For example,
+	  if the entropy buffer is 256 bits, 320 bits of entropy
+	  is requested to fill that buffer.
+
+	  Second, the seed operation of the deterministic RNG
+	  requests 128 bits more data from each entropy source than
+	  the security strength of the DRNG during initialization.
+	  A prerequisite for this operation is that the digest size
+	  of the used hash must be at least equally large to generate
+	  that buffer. If the prerequisite is not met, this
+	  oversampling is not applied.
+
+	  This strategy is intended to offset the asymptotic entropy
+	  increase to reach full entropy in a buffer.
+
+	  The strategy is consistent with the requirements in
+	  NIST SP800-90C and is only enforced with fips=1.
+
+	  If unsure, say N.
+
+config CRYPTO_ESDM_OVERSAMPLE_ES_BITS
+	int
+	default 0 if !CRYPTO_ESDM_OVERSAMPLE_ENTROPY_SOURCES
+	default 64 if CRYPTO_ESDM_OVERSAMPLE_ENTROPY_SOURCES
+
+config CRYPTO_ESDM_SEED_BUFFER_INIT_ADD_BITS
+	int
+	default 0 if !CRYPTO_ESDM_OVERSAMPLE_ENTROPY_SOURCES
+	default 128 if CRYPTO_ESDM_OVERSAMPLE_ENTROPY_SOURCES
+
+endmenu # "Specific DRNG seeding strategies"
+
+config CRYPTO_ESDM_DRNG_KCAPI
+	bool
+	depends on CRYPTO
+	select CRYPTO_RNG
+	default y
+
+endif # CRYPTO_ESDM
+
+endmenu # CRYPTO_ESDM
diff --git a/crypto/esdm/Makefile b/crypto/esdm/Makefile
new file mode 100644
index 000000000000..24dc7af234b6
--- /dev/null
+++ b/crypto/esdm/Makefile
@@ -0,0 +1,10 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# Makefile for the Entropy Source and DRNG Manager.
+#
+
+obj-y					+= esdm_es_mgr.o esdm_drng_mgr.o \
+					   esdm_es_aux.o
+obj-$(CONFIG_CRYPTO_ESDM_SHA256)	+= esdm_sha256.o
+
+obj-$(CONFIG_CRYPTO_ESDM_DRNG_KCAPI)	+= esdm_drng_kcapi.o
diff --git a/crypto/esdm/esdm_definitions.h b/crypto/esdm/esdm_definitions.h
new file mode 100644
index 000000000000..e4c5bf5f757c
--- /dev/null
+++ b/crypto/esdm/esdm_definitions.h
@@ -0,0 +1,141 @@
+/* SPDX-License-Identifier: GPL-2.0 OR BSD-2-Clause */
+/*
+ * Copyright (C) 2022, Stephan Mueller <smueller@chronox.de>
+ */
+
+#ifndef _ESDM_DEFINITIONS_H
+#define _ESDM_DEFINITIONS_H
+
+#include <crypto/sha1.h>
+#include <crypto/sha2.h>
+#include <linux/slab.h>
+
+/*************************** General ESDM parameter ***************************/
+
+/* Security strength of ESDM -- this must match DRNG security strength */
+#define ESDM_DRNG_SECURITY_STRENGTH_BYTES 32
+#define ESDM_DRNG_SECURITY_STRENGTH_BITS (ESDM_DRNG_SECURITY_STRENGTH_BYTES * 8)
+#define ESDM_DRNG_INIT_SEED_SIZE_BITS \
+	(ESDM_DRNG_SECURITY_STRENGTH_BITS +      \
+	 CONFIG_CRYPTO_ESDM_SEED_BUFFER_INIT_ADD_BITS)
+#define ESDM_DRNG_INIT_SEED_SIZE_BYTES (ESDM_DRNG_INIT_SEED_SIZE_BITS >> 3)
+
+/*
+ * SP800-90A defines a maximum request size of 1<<16 bytes. The given value is
+ * considered a safer margin.
+ *
+ * This value is allowed to be changed.
+ */
+#define ESDM_DRNG_MAX_REQSIZE		(1<<12)
+
+/*
+ * SP800-90A defines a maximum number of requests between reseeds of 2^48.
+ * The given value is considered a much safer margin, balancing requests for
+ * frequent reseeds with the need to conserve entropy. This value MUST NOT be
+ * larger than INT_MAX because it is used in an atomic_t.
+ *
+ * This value is allowed to be changed.
+ */
+#define ESDM_DRNG_RESEED_THRESH		(1<<20)
+
+/*
+ * Maximum DRNG generation operations without reseed having full entropy
+ * This value defines the absolute maximum value of DRNG generation operations
+ * without a reseed holding full entropy. ESDM_DRNG_RESEED_THRESH is the
+ * threshold when a new reseed is attempted. But it is possible that this fails
+ * to deliver full entropy. In this case the DRNG will continue to provide data
+ * even though it was not reseeded with full entropy. To avoid in the extreme
+ * case that no reseed is performed for too long, this threshold is enforced.
+ * If that absolute low value is reached, the ESDM is marked as not operational.
+ *
+ * This value is allowed to be changed.
+ */
+#define ESDM_DRNG_MAX_WITHOUT_RESEED	(1<<30)
+
+/*
+ * Min required seed entropy is 128 bits covering the minimum entropy
+ * requirement of SP800-131A and the German BSI's TR02102.
+ *
+ * This value is allowed to be changed.
+ */
+#define ESDM_FULL_SEED_ENTROPY_BITS	ESDM_DRNG_SECURITY_STRENGTH_BITS
+#define ESDM_MIN_SEED_ENTROPY_BITS	128
+#define ESDM_INIT_ENTROPY_BITS		32
+
+/*
+ * Wakeup value
+ *
+ * This value is allowed to be changed but must not be larger than the
+ * digest size of the hash operation used update the aux_pool.
+ */
+#ifdef CONFIG_CRYPTO_ESDM_SHA256
+# define ESDM_ATOMIC_DIGEST_SIZE	SHA256_DIGEST_SIZE
+#else
+# define ESDM_ATOMIC_DIGEST_SIZE	SHA1_DIGEST_SIZE
+#endif
+#define ESDM_WRITE_WAKEUP_ENTROPY	ESDM_ATOMIC_DIGEST_SIZE
+
+/*
+ * If the switching support is configured, we must provide support up to
+ * the largest digest size. Without switching support, we know it is only
+ * the built-in digest size.
+ */
+#ifdef CONFIG_CRYPTO_ESDM_CRYPTO_SWITCH
+# define ESDM_MAX_DIGESTSIZE		64
+#else
+# define ESDM_MAX_DIGESTSIZE		ESDM_ATOMIC_DIGEST_SIZE
+#endif
+
+/*
+ * Oversampling factor of timer-based events to obtain
+ * ESDM_DRNG_SECURITY_STRENGTH_BYTES. This factor is used when a
+ * high-resolution time stamp is not available. In this case, jiffies and
+ * register contents are used to fill the entropy pool. These noise sources
+ * are much less entropic than the high-resolution timer. The entropy content
+ * is the entropy content assumed with ESDM_[IRQ|SCHED]_ENTROPY_BITS divided by
+ * ESDM_ES_OVERSAMPLING_FACTOR.
+ *
+ * This value is allowed to be changed.
+ */
+#define ESDM_ES_OVERSAMPLING_FACTOR	10
+
+/* Alignmask that is intended to be identical to CRYPTO_MINALIGN */
+#define ESDM_KCAPI_ALIGN		ARCH_KMALLOC_MINALIGN
+
+/*
+ * This definition must provide a buffer that is equal to SHASH_DESC_ON_STACK
+ * as it will be casted into a struct shash_desc.
+ */
+#define ESDM_POOL_SIZE	(sizeof(struct shash_desc) + HASH_MAX_DESCSIZE)
+
+/****************************** Helper code ***********************************/
+
+static inline u32 esdm_fast_noise_entropylevel(u32 ent_bits, u32 requested_bits)
+{
+	/* Obtain entropy statement */
+	ent_bits = ent_bits * requested_bits / ESDM_DRNG_SECURITY_STRENGTH_BITS;
+	/* Cap entropy to buffer size in bits */
+	ent_bits = min_t(u32, ent_bits, requested_bits);
+	return ent_bits;
+}
+
+/* Convert entropy in bits into nr. of events with the same entropy content. */
+static inline u32 esdm_entropy_to_data(u32 entropy_bits, u32 entropy_rate)
+{
+	return ((entropy_bits * entropy_rate) /
+		ESDM_DRNG_SECURITY_STRENGTH_BITS);
+}
+
+/* Convert number of events into entropy value. */
+static inline u32 esdm_data_to_entropy(u32 irqnum, u32 entropy_rate)
+{
+	return ((irqnum * ESDM_DRNG_SECURITY_STRENGTH_BITS) /
+		entropy_rate);
+}
+
+static inline u32 atomic_read_u32(atomic_t *v)
+{
+	return (u32)atomic_read(v);
+}
+
+#endif /* _ESDM_DEFINITIONS_H */
diff --git a/crypto/esdm/esdm_drng_kcapi.c b/crypto/esdm/esdm_drng_kcapi.c
new file mode 100644
index 000000000000..ae8d2be91b37
--- /dev/null
+++ b/crypto/esdm/esdm_drng_kcapi.c
@@ -0,0 +1,201 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-2-Clause
+/*
+ * Backend for the ESDM providing the cryptographic primitives using the
+ * kernel crypto API.
+ *
+ * Copyright (C) 2022, Stephan Mueller <smueller@chronox.de>
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <crypto/esdm.h>
+#include <crypto/hash.h>
+#include <crypto/rng.h>
+#include <linux/init.h>
+#include <linux/module.h>
+
+#include "esdm_drng_kcapi.h"
+
+static char *drng_name =
+#ifdef CONFIG_CRYPTO_DRBG_CTR
+	/* CTR_DRBG with AES-256 using derivation function */
+	"drbg_nopr_ctr_aes256";
+#elif defined CONFIG_CRYPTO_DRBG_HMAC
+	/* HMAC_DRBG with SHA-512 */
+	"drbg_nopr_hmac_sha512";
+#elif defined CONFIG_CRYPTO_DRBG_HASH
+	/* Hash_DRBG with SHA-512 using derivation function */
+	"drbg_nopr_sha512";
+#else
+	NULL;
+#endif
+module_param(drng_name, charp, 0444);
+MODULE_PARM_DESC(drng_name, "Kernel crypto API name of DRNG");
+
+static char *seed_hash = NULL;
+module_param(seed_hash, charp, 0444);
+MODULE_PARM_DESC(seed_hash,
+		 "Kernel crypto API name of hash with output size equal to seedsize of DRNG to bring seed string to the size required by the DRNG");
+
+struct esdm_drng_info {
+	struct crypto_rng *kcapi_rng;
+	struct crypto_shash *hash_tfm;
+};
+
+static int esdm_kcapi_drng_seed_helper(void *drng, const u8 *inbuf,
+				       u32 inbuflen)
+{
+	struct esdm_drng_info *esdm_drng_info = (struct esdm_drng_info *)drng;
+	struct crypto_rng *kcapi_rng = esdm_drng_info->kcapi_rng;
+	struct crypto_shash *hash_tfm = esdm_drng_info->hash_tfm;
+	SHASH_DESC_ON_STACK(shash, hash_tfm);
+	u32 digestsize;
+	u8 digest[HASH_MAX_DIGESTSIZE] __aligned(8);
+	int ret;
+
+	if (!hash_tfm)
+		return crypto_rng_reset(kcapi_rng, inbuf, inbuflen);
+
+	shash->tfm = hash_tfm;
+	digestsize = crypto_shash_digestsize(hash_tfm);
+
+	ret = crypto_shash_digest(shash, inbuf, inbuflen, digest);
+	shash_desc_zero(shash);
+	if (ret)
+		return ret;
+
+	ret = crypto_rng_reset(kcapi_rng, digest, digestsize);
+	if (ret)
+		return ret;
+
+	memzero_explicit(digest, digestsize);
+	return 0;
+}
+
+static int esdm_kcapi_drng_generate_helper(void *drng, u8 *outbuf,
+					   u32 outbuflen)
+{
+	struct esdm_drng_info *esdm_drng_info = (struct esdm_drng_info *)drng;
+	struct crypto_rng *kcapi_rng = esdm_drng_info->kcapi_rng;
+	int ret = crypto_rng_get_bytes(kcapi_rng, outbuf, outbuflen);
+
+	if (ret < 0)
+		return ret;
+
+	return outbuflen;
+}
+
+static void *esdm_kcapi_drng_alloc(u32 sec_strength)
+{
+	struct esdm_drng_info *esdm_drng_info;
+	struct crypto_rng *kcapi_rng;
+	u32 time = random_get_entropy();
+	int seedsize, rv;
+	void *ret =  ERR_PTR(-ENOMEM);
+
+	if (!drng_name) {
+		pr_err("DRNG name missing\n");
+		return ERR_PTR(-EINVAL);
+	}
+
+	if (!memcmp(drng_name, "stdrng", 6) ||
+	    !memcmp(drng_name, "jitterentropy_rng", 17)) {
+		pr_err("Refusing to load the requested random number generator\n");
+		return ERR_PTR(-EINVAL);
+	}
+
+	esdm_drng_info = kzalloc(sizeof(*esdm_drng_info), GFP_KERNEL);
+	if (!esdm_drng_info)
+		return ERR_PTR(-ENOMEM);
+
+	kcapi_rng = crypto_alloc_rng(drng_name, 0, 0);
+	if (IS_ERR(kcapi_rng)) {
+		pr_err("DRNG %s cannot be allocated\n", drng_name);
+		ret = ERR_CAST(kcapi_rng);
+		goto free;
+	}
+
+	esdm_drng_info->kcapi_rng = kcapi_rng;
+
+	seedsize = crypto_rng_seedsize(kcapi_rng);
+	if (seedsize) {
+		struct crypto_shash *hash_tfm;
+
+		if (!seed_hash) {
+			switch (seedsize) {
+			case 32:
+				seed_hash = "sha256";
+				break;
+			case 48:
+				seed_hash = "sha384";
+				break;
+			case 64:
+				seed_hash = "sha512";
+				break;
+			default:
+				pr_err("Seed size %d cannot be processed\n",
+				       seedsize);
+				goto dealloc;
+			}
+		}
+
+		hash_tfm = crypto_alloc_shash(seed_hash, 0, 0);
+		if (IS_ERR(hash_tfm)) {
+			ret = ERR_CAST(hash_tfm);
+			goto dealloc;
+		}
+
+		if (seedsize != crypto_shash_digestsize(hash_tfm)) {
+			pr_err("Seed hash output size not equal to DRNG seed size\n");
+			crypto_free_shash(hash_tfm);
+			ret = ERR_PTR(-EINVAL);
+			goto dealloc;
+		}
+
+		esdm_drng_info->hash_tfm = hash_tfm;
+
+		pr_info("Seed hash %s allocated\n", seed_hash);
+	}
+
+	rv = esdm_kcapi_drng_seed_helper(esdm_drng_info, (u8 *)(&time),
+					 sizeof(time));
+	if (rv) {
+		ret = ERR_PTR(rv);
+		goto dealloc;
+	}
+
+	pr_info("Kernel crypto API DRNG %s allocated\n", drng_name);
+
+	return esdm_drng_info;
+
+dealloc:
+	crypto_free_rng(kcapi_rng);
+free:
+	kfree(esdm_drng_info);
+	return ret;
+}
+
+static void esdm_kcapi_drng_dealloc(void *drng)
+{
+	struct esdm_drng_info *esdm_drng_info = (struct esdm_drng_info *)drng;
+	struct crypto_rng *kcapi_rng = esdm_drng_info->kcapi_rng;
+
+	crypto_free_rng(kcapi_rng);
+	if (esdm_drng_info->hash_tfm)
+		crypto_free_shash(esdm_drng_info->hash_tfm);
+	kfree(esdm_drng_info);
+	pr_info("DRNG %s deallocated\n", drng_name);
+}
+
+static const char *esdm_kcapi_drng_name(void)
+{
+	return drng_name;
+}
+
+const struct esdm_drng_cb esdm_kcapi_drng_cb = {
+	.drng_name	= esdm_kcapi_drng_name,
+	.drng_alloc	= esdm_kcapi_drng_alloc,
+	.drng_dealloc	= esdm_kcapi_drng_dealloc,
+	.drng_seed	= esdm_kcapi_drng_seed_helper,
+	.drng_generate	= esdm_kcapi_drng_generate_helper,
+};
diff --git a/crypto/esdm/esdm_drng_kcapi.h b/crypto/esdm/esdm_drng_kcapi.h
new file mode 100644
index 000000000000..0950a15fdfaa
--- /dev/null
+++ b/crypto/esdm/esdm_drng_kcapi.h
@@ -0,0 +1,13 @@
+/* SPDX-License-Identifier: GPL-2.0 OR BSD-2-Clause */
+/*
+ * ESDM kernel crypto API DRNG definition
+ *
+ * Copyright (C) 2022, Stephan Mueller <smueller@chronox.de>
+ */
+
+#ifndef _ESDM_KCAPI_DRNG_H
+#define _ESDM_KCAPI_DRNG_H
+
+extern const struct esdm_drng_cb esdm_kcapi_drng_cb;
+
+#endif /* _ESDM_KCAPI_DRNG_H */
diff --git a/crypto/esdm/esdm_drng_mgr.c b/crypto/esdm/esdm_drng_mgr.c
new file mode 100644
index 000000000000..53b683b7ac05
--- /dev/null
+++ b/crypto/esdm/esdm_drng_mgr.c
@@ -0,0 +1,398 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-2-Clause
+/*
+ * ESDM DRNG management
+ *
+ * Copyright (C) 2022, Stephan Mueller <smueller@chronox.de>
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <crypto/esdm.h>
+#include <linux/fips.h>
+#include <linux/module.h>
+#include <linux/sched.h>
+#include <linux/wait.h>
+
+#include "esdm_drng_kcapi.h"
+#include "esdm_drng_mgr.h"
+#include "esdm_es_aux.h"
+#include "esdm_es_mgr.h"
+#include "esdm_sha.h"
+
+/*
+ * Maximum number of seconds between DRNG reseed intervals of the DRNG. Note,
+ * this is enforced with the next request of random numbers from the
+ * DRNG. Setting this value to zero implies a reseeding attempt before every
+ * generated random number.
+ */
+int esdm_drng_reseed_max_time = 600;
+
+/*
+ * Is ESDM for general-purpose use (i.e. is at least the esdm_drng_init
+ * fully allocated)?
+ */
+static atomic_t esdm_avail = ATOMIC_INIT(0);
+
+/*
+ * Default hash callback that provides the crypto primitive right from the
+ * kernel start. It must not perform any memory allocation operation, but
+ * simply perform the hash calculation.
+ */
+const struct esdm_hash_cb *esdm_default_hash_cb = &esdm_sha_hash_cb;
+
+/*
+ * Default DRNG callback that provides the crypto primitive which is
+ * allocated either during late kernel boot stage. So, it is permissible for
+ * the callback to perform memory allocation operations.
+ */
+const struct esdm_drng_cb *esdm_default_drng_cb = &esdm_kcapi_drng_cb;
+
+/* DRNG for non-atomic use cases */
+static struct esdm_drng esdm_drng_init = {
+	ESDM_DRNG_STATE_INIT(esdm_drng_init, NULL, NULL, NULL,
+			     &esdm_sha_hash_cb),
+	.lock = __MUTEX_INITIALIZER(esdm_drng_init.lock),
+};
+
+static u32 max_wo_reseed = ESDM_DRNG_MAX_WITHOUT_RESEED;
+#ifdef CONFIG_CRYPTO_ESDM_RUNTIME_MAX_WO_RESEED_CONFIG
+module_param(max_wo_reseed, uint, 0444);
+MODULE_PARM_DESC(max_wo_reseed,
+		 "Maximum number of DRNG generate operation without full reseed\n");
+#endif
+
+/* Wait queue to wait until the ESDM is initialized - can freely be used */
+DECLARE_WAIT_QUEUE_HEAD(esdm_init_wait);
+
+/********************************** Helper ************************************/
+
+bool esdm_get_available(void)
+{
+	return likely(atomic_read(&esdm_avail));
+}
+
+struct esdm_drng *esdm_drng_init_instance(void)
+{
+	return &esdm_drng_init;
+}
+
+struct esdm_drng *esdm_drng_node_instance(void)
+{
+	return esdm_drng_init_instance();
+}
+
+void esdm_drng_reset(struct esdm_drng *drng)
+{
+	atomic_set(&drng->requests, ESDM_DRNG_RESEED_THRESH);
+	atomic_set(&drng->requests_since_fully_seeded, 0);
+	drng->last_seeded = jiffies;
+	drng->fully_seeded = false;
+	drng->force_reseed = true;
+	pr_debug("reset DRNG\n");
+}
+
+/* Initialize the DRNG, except the mutex lock */
+int esdm_drng_alloc_common(struct esdm_drng *drng,
+			   const struct esdm_drng_cb *drng_cb)
+{
+	if (!drng || !drng_cb)
+		return -EINVAL;
+
+	drng->drng_cb = drng_cb;
+	drng->drng = drng_cb->drng_alloc(ESDM_DRNG_SECURITY_STRENGTH_BYTES);
+	if (IS_ERR(drng->drng))
+		return PTR_ERR(drng->drng);
+
+	esdm_drng_reset(drng);
+	return 0;
+}
+
+/* Initialize the default DRNG during boot and perform its seeding */
+int esdm_drng_initalize(void)
+{
+	int ret;
+
+	if (esdm_get_available())
+		return 0;
+
+	/* Catch programming error */
+	WARN_ON(esdm_drng_init.hash_cb != esdm_default_hash_cb);
+
+	mutex_lock(&esdm_drng_init.lock);
+	if (esdm_get_available()) {
+		mutex_unlock(&esdm_drng_init.lock);
+		return 0;
+	}
+
+	ret = esdm_drng_alloc_common(&esdm_drng_init, esdm_default_drng_cb);
+	mutex_unlock(&esdm_drng_init.lock);
+	if (ret)
+		return ret;
+
+	pr_debug("ESDM for general use is available\n");
+	atomic_set(&esdm_avail, 1);
+
+	/* Seed the DRNG with any entropy available */
+	if (!esdm_pool_trylock()) {
+		pr_info("Initial DRNG initialized triggering first seeding\n");
+		esdm_drng_seed_work(NULL);
+	} else {
+		pr_info("Initial DRNG initialized without seeding\n");
+	}
+
+	return 0;
+}
+
+static int __init esdm_drng_make_available(void)
+{
+	return esdm_drng_initalize();
+}
+late_initcall(esdm_drng_make_available);
+
+bool esdm_sp80090c_compliant(void)
+{
+	if (!IS_ENABLED(CONFIG_CRYPTO_ESDM_OVERSAMPLE_ENTROPY_SOURCES))
+		return false;
+
+	/* SP800-90C only requested in FIPS mode */
+	return fips_enabled;
+}
+
+/************************* Random Number Generation ***************************/
+
+/* Inject a data buffer into the DRNG - caller must hold its lock */
+void esdm_drng_inject(struct esdm_drng *drng, const u8 *inbuf, u32 inbuflen,
+		      bool fully_seeded, const char *drng_type)
+{
+	BUILD_BUG_ON(ESDM_DRNG_RESEED_THRESH > INT_MAX);
+	pr_debug("seeding %s DRNG with %u bytes\n", drng_type, inbuflen);
+	if (drng->drng_cb->drng_seed(drng->drng, inbuf, inbuflen) < 0) {
+		pr_warn("seeding of %s DRNG failed\n", drng_type);
+		drng->force_reseed = true;
+	} else {
+		int gc = ESDM_DRNG_RESEED_THRESH - atomic_read(&drng->requests);
+
+		pr_debug("%s DRNG stats since last seeding: %lu secs; generate calls: %d\n",
+			 drng_type,
+			 (time_after(jiffies, drng->last_seeded) ?
+			  (jiffies - drng->last_seeded) : 0) / HZ, gc);
+
+		/* Count the numbers of generate ops since last fully seeded */
+		if (fully_seeded)
+			atomic_set(&drng->requests_since_fully_seeded, 0);
+		else
+			atomic_add(gc, &drng->requests_since_fully_seeded);
+
+		drng->last_seeded = jiffies;
+		atomic_set(&drng->requests, ESDM_DRNG_RESEED_THRESH);
+		drng->force_reseed = false;
+
+		if (!drng->fully_seeded) {
+			drng->fully_seeded = fully_seeded;
+			if (drng->fully_seeded)
+				pr_debug("%s DRNG fully seeded\n", drng_type);
+		}
+	}
+}
+
+/* Perform the seeding of the DRNG with data from noise source */
+static void esdm_drng_seed_es(struct esdm_drng *drng)
+{
+	struct entropy_buf seedbuf __aligned(ESDM_KCAPI_ALIGN);
+
+	esdm_fill_seed_buffer(&seedbuf,
+			      esdm_get_seed_entropy_osr(drng->fully_seeded));
+
+	mutex_lock(&drng->lock);
+	esdm_drng_inject(drng, (u8 *)&seedbuf, sizeof(seedbuf),
+			 esdm_fully_seeded_eb(drng->fully_seeded, &seedbuf),
+			 "regular");
+	mutex_unlock(&drng->lock);
+
+	/* Set the seeding state of the ESDM */
+	esdm_init_ops(&seedbuf);
+
+	memzero_explicit(&seedbuf, sizeof(seedbuf));
+}
+
+static void esdm_drng_seed(struct esdm_drng *drng)
+{
+	BUILD_BUG_ON(ESDM_MIN_SEED_ENTROPY_BITS >
+		     ESDM_DRNG_SECURITY_STRENGTH_BITS);
+
+	if (esdm_get_available()) {
+		/* (Re-)Seed DRNG */
+		esdm_drng_seed_es(drng);
+	} else {
+		esdm_init_ops(NULL);
+	}
+}
+
+static void _esdm_drng_seed_work(struct esdm_drng *drng, u32 node)
+{
+	pr_debug("reseed triggered by system events for DRNG on NUMA node %d\n",
+		 node);
+	esdm_drng_seed(drng);
+	if (drng->fully_seeded) {
+		/* Prevent reseed storm */
+		drng->last_seeded += node * 100 * HZ;
+	}
+}
+
+/*
+ * DRNG reseed trigger: Kernel thread handler triggered by the schedule_work()
+ */
+void esdm_drng_seed_work(struct work_struct *dummy)
+{
+	if (!esdm_drng_init.fully_seeded) {
+		_esdm_drng_seed_work(&esdm_drng_init, 0);
+		goto out;
+	}
+
+	esdm_pool_all_numa_nodes_seeded(true);
+
+out:
+	/* Allow the seeding operation to be called again */
+	esdm_pool_unlock();
+}
+
+/* Force all DRNGs to reseed before next generation */
+void esdm_drng_force_reseed(void)
+{
+	esdm_drng_init.force_reseed = esdm_drng_init.fully_seeded;
+	pr_debug("force reseed of initial DRNG\n");
+}
+EXPORT_SYMBOL(esdm_drng_force_reseed);
+
+static bool esdm_drng_must_reseed(struct esdm_drng *drng)
+{
+	return (atomic_dec_and_test(&drng->requests) ||
+		drng->force_reseed ||
+		time_after(jiffies,
+			   drng->last_seeded + esdm_drng_reseed_max_time * HZ));
+}
+
+/*
+ * esdm_drng_get() - Get random data out of the DRNG which is reseeded
+ * frequently.
+ *
+ * @drng: DRNG instance
+ * @outbuf: buffer for storing random data
+ * @outbuflen: length of outbuf
+ *
+ * Return:
+ * * < 0 in error case (DRNG generation or update failed)
+ * * >=0 returning the returned number of bytes
+ */
+int esdm_drng_get(struct esdm_drng *drng, u8 *outbuf, u32 outbuflen)
+{
+	u32 processed = 0;
+
+	if (!outbuf || !outbuflen)
+		return 0;
+
+	if (!esdm_get_available())
+		return -EOPNOTSUPP;
+
+	outbuflen = min_t(size_t, outbuflen, INT_MAX);
+
+	/* If DRNG operated without proper reseed for too long, block ESDM */
+	BUILD_BUG_ON(ESDM_DRNG_MAX_WITHOUT_RESEED < ESDM_DRNG_RESEED_THRESH);
+	if (atomic_read_u32(&drng->requests_since_fully_seeded) > max_wo_reseed)
+		esdm_unset_fully_seeded(drng);
+
+	while (outbuflen) {
+		u32 todo = min_t(u32, outbuflen, ESDM_DRNG_MAX_REQSIZE);
+		int ret;
+
+		if (esdm_drng_must_reseed(drng)) {
+			if (esdm_pool_trylock()) {
+				drng->force_reseed = true;
+			} else {
+				esdm_drng_seed(drng);
+				esdm_pool_unlock();
+			}
+		}
+
+		mutex_lock(&drng->lock);
+		ret = drng->drng_cb->drng_generate(drng->drng,
+						   outbuf + processed, todo);
+		mutex_unlock(&drng->lock);
+		if (ret <= 0) {
+			pr_warn("getting random data from DRNG failed (%d)\n",
+				ret);
+			return -EFAULT;
+		}
+		processed += ret;
+		outbuflen -= ret;
+	}
+
+	return processed;
+}
+
+int esdm_drng_get_sleep(u8 *outbuf, u32 outbuflen)
+{
+	struct esdm_drng *drng = &esdm_drng_init;
+	int ret;
+
+	might_sleep();
+
+	ret = esdm_drng_initalize();
+	if (ret)
+		return ret;
+
+	return esdm_drng_get(drng, outbuf, outbuflen);
+}
+
+/* Reset ESDM such that all existing entropy is gone */
+static void _esdm_reset(struct work_struct *work)
+{
+	mutex_lock(&esdm_drng_init.lock);
+	esdm_drng_reset(&esdm_drng_init);
+	mutex_unlock(&esdm_drng_init.lock);
+
+	esdm_set_entropy_thresh(ESDM_INIT_ENTROPY_BITS);
+
+	esdm_reset_state();
+}
+
+static DECLARE_WORK(esdm_reset_work, _esdm_reset);
+
+void esdm_reset(void)
+{
+	schedule_work(&esdm_reset_work);
+}
+
+/******************* Generic ESDM kernel output interfaces ********************/
+
+int esdm_drng_sleep_while_nonoperational(int nonblock)
+{
+	if (likely(!esdm_state_operational()))
+		return 0;
+	if (nonblock)
+		return -EAGAIN;
+	return wait_event_interruptible(esdm_init_wait,
+					esdm_state_operational());
+}
+
+int esdm_drng_sleep_while_non_min_seeded(void)
+{
+	if (likely(esdm_state_min_seeded()))
+		return 0;
+	return wait_event_interruptible(esdm_init_wait,
+					esdm_state_min_seeded());
+}
+
+void esdm_get_random_bytes_full(void *buf, int nbytes)
+{
+	esdm_drng_sleep_while_nonoperational(0);
+	esdm_drng_get_sleep((u8 *)buf, (u32)nbytes);
+}
+EXPORT_SYMBOL(esdm_get_random_bytes_full);
+
+void esdm_get_random_bytes_min(void *buf, int nbytes)
+{
+	esdm_drng_sleep_while_non_min_seeded();
+	esdm_drng_get_sleep((u8 *)buf, (u32)nbytes);
+}
+EXPORT_SYMBOL(esdm_get_random_bytes_min);
diff --git a/crypto/esdm/esdm_drng_mgr.h b/crypto/esdm/esdm_drng_mgr.h
new file mode 100644
index 000000000000..241b94b84bf7
--- /dev/null
+++ b/crypto/esdm/esdm_drng_mgr.h
@@ -0,0 +1,85 @@
+/* SPDX-License-Identifier: GPL-2.0 OR BSD-2-Clause */
+/*
+ * Copyright (C) 2022, Stephan Mueller <smueller@chronox.de>
+ */
+
+#ifndef _ESDM_DRNG_H
+#define _ESDM_DRNG_H
+
+#include <linux/mutex.h>
+#include <linux/spinlock.h>
+#include <linux/workqueue.h>
+
+#include "esdm_definitions.h"
+
+extern struct wait_queue_head esdm_init_wait;
+extern int esdm_drng_reseed_max_time;
+extern struct mutex esdm_crypto_cb_update;
+extern const struct esdm_drng_cb *esdm_default_drng_cb;
+extern const struct esdm_hash_cb *esdm_default_hash_cb;
+
+/* DRNG state handle */
+struct esdm_drng {
+	void *drng;				/* DRNG handle */
+	void *hash;				/* Hash handle */
+	const struct esdm_drng_cb *drng_cb;	/* DRNG callbacks */
+	const struct esdm_hash_cb *hash_cb;	/* Hash callbacks */
+	atomic_t requests;			/* Number of DRNG requests */
+	atomic_t requests_since_fully_seeded;	/* Number DRNG requests since
+						 * last fully seeded
+						 */
+	unsigned long last_seeded;		/* Last time it was seeded */
+	bool fully_seeded;			/* Is DRNG fully seeded? */
+	bool force_reseed;			/* Force a reseed */
+
+	rwlock_t hash_lock;			/* Lock hash_cb replacement */
+	/* Lock write operations on DRNG state, DRNG replacement of drng_cb */
+	struct mutex lock;			/* Non-atomic DRNG operation */
+	spinlock_t spin_lock;			/* Atomic DRNG operation */
+};
+
+#define ESDM_DRNG_STATE_INIT(x, d, h, d_cb, h_cb) \
+	.drng				= d, \
+	.hash				= h, \
+	.drng_cb			= d_cb, \
+	.hash_cb			= h_cb, \
+	.requests			= ATOMIC_INIT(ESDM_DRNG_RESEED_THRESH),\
+	.requests_since_fully_seeded	= ATOMIC_INIT(0), \
+	.last_seeded			= 0, \
+	.fully_seeded			= false, \
+	.force_reseed			= true, \
+	.hash_lock			= __RW_LOCK_UNLOCKED(x.hash_lock)
+
+struct esdm_drng *esdm_drng_init_instance(void);
+struct esdm_drng *esdm_drng_node_instance(void);
+
+void esdm_reset(void);
+int esdm_drng_alloc_common(struct esdm_drng *drng,
+			   const struct esdm_drng_cb *crypto_cb);
+int esdm_drng_initalize(void);
+bool esdm_sp80090c_compliant(void);
+bool esdm_get_available(void);
+void esdm_drng_reset(struct esdm_drng *drng);
+void esdm_drng_inject(struct esdm_drng *drng, const u8 *inbuf, u32 inbuflen,
+		      bool fully_seeded, const char *drng_type);
+int esdm_drng_get(struct esdm_drng *drng, u8 *outbuf, u32 outbuflen);
+int esdm_drng_sleep_while_nonoperational(int nonblock);
+int esdm_drng_sleep_while_non_min_seeded(void);
+int esdm_drng_get_sleep(u8 *outbuf, u32 outbuflen);
+void esdm_drng_seed_work(struct work_struct *dummy);
+void esdm_drng_force_reseed(void);
+
+static inline u32 esdm_compress_osr(void)
+{
+	return esdm_sp80090c_compliant() ?
+	       CONFIG_CRYPTO_ESDM_OVERSAMPLE_ES_BITS : 0;
+}
+
+static inline u32 esdm_reduce_by_osr(u32 entropy_bits)
+{
+	u32 osr_bits = esdm_compress_osr();
+
+	return (entropy_bits >= osr_bits) ? (entropy_bits - osr_bits) : 0;
+}
+
+#endif /* _ESDM_DRNG_H */
diff --git a/crypto/esdm/esdm_es_aux.c b/crypto/esdm/esdm_es_aux.c
new file mode 100644
index 000000000000..9a665eaf856b
--- /dev/null
+++ b/crypto/esdm/esdm_es_aux.c
@@ -0,0 +1,332 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-2-Clause
+/*
+ * ESDM Slow Entropy Source: Auxiliary entropy pool
+ *
+ * Copyright (C) 2022, Stephan Mueller <smueller@chronox.de>
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <crypto/esdm.h>
+
+#include "esdm_es_aux.h"
+#include "esdm_es_mgr.h"
+
+/*
+ * This is the auxiliary pool
+ *
+ * The aux pool array is aligned to 8 bytes to comfort the kernel crypto API
+ * cipher implementations of the hash functions used to read the pool: for some
+ * accelerated implementations, we need an alignment to avoid a realignment
+ * which involves memcpy(). The alignment to 8 bytes should satisfy all crypto
+ * implementations.
+ */
+struct esdm_pool {
+	u8 aux_pool[ESDM_POOL_SIZE];	/* Aux pool: digest state */
+	atomic_t aux_entropy_bits;
+	atomic_t digestsize;		/* Digest size of used hash */
+	bool initialized;		/* Aux pool initialized? */
+
+	/* Serialize read of entropy pool and update of aux pool */
+	spinlock_t lock;
+};
+
+static struct esdm_pool esdm_pool __aligned(ESDM_KCAPI_ALIGN) = {
+	.aux_entropy_bits	= ATOMIC_INIT(0),
+	.digestsize		= ATOMIC_INIT(ESDM_ATOMIC_DIGEST_SIZE),
+	.initialized		= false,
+	.lock			= __SPIN_LOCK_UNLOCKED(esdm_pool.lock)
+};
+
+/********************************** Helper ***********************************/
+
+/* Entropy in bits present in aux pool */
+static u32 esdm_aux_avail_entropy(u32 __unused)
+{
+	/* Cap available entropy with max entropy */
+	u32 avail_bits = min_t(u32, esdm_get_digestsize(),
+			       atomic_read_u32(&esdm_pool.aux_entropy_bits));
+
+	/* Consider oversampling rate due to aux pool conditioning */
+	return esdm_reduce_by_osr(avail_bits);
+}
+
+/* Set the digest size of the used hash in bytes */
+static void esdm_set_digestsize(u32 digestsize)
+{
+	struct esdm_pool *pool = &esdm_pool;
+	u32 ent_bits = atomic_xchg_relaxed(&pool->aux_entropy_bits, 0),
+	    old_digestsize = esdm_get_digestsize();
+
+	atomic_set(&esdm_pool.digestsize, digestsize);
+
+	/*
+	 * Update the write wakeup threshold which must not be larger
+	 * than the digest size of the current conditioning hash.
+	 */
+	digestsize = esdm_reduce_by_osr(digestsize << 3);
+	esdm_write_wakeup_bits = digestsize;
+
+	/*
+	 * In case the new digest is larger than the old one, cap the available
+	 * entropy to the old message digest used to process the existing data.
+	 */
+	ent_bits = min_t(u32, ent_bits, old_digestsize);
+	atomic_add(ent_bits, &pool->aux_entropy_bits);
+}
+
+static int __init esdm_init_wakeup_bits(void)
+{
+	u32 digestsize = esdm_reduce_by_osr(esdm_get_digestsize());
+
+	esdm_write_wakeup_bits = digestsize;
+	return 0;
+}
+core_initcall(esdm_init_wakeup_bits);
+
+/* Obtain the digest size provided by the used hash in bits */
+u32 esdm_get_digestsize(void)
+{
+	return atomic_read_u32(&esdm_pool.digestsize) << 3;
+}
+
+/* Set entropy content in user-space controllable aux pool */
+void esdm_pool_set_entropy(u32 entropy_bits)
+{
+	atomic_set(&esdm_pool.aux_entropy_bits, entropy_bits);
+}
+
+static void esdm_aux_reset(void)
+{
+	esdm_pool_set_entropy(0);
+}
+
+/*
+ * Replace old with new hash for auxiliary pool handling
+ *
+ * Assumption: the caller must guarantee that the new_cb is available during the
+ * entire operation (e.g. it must hold the write lock against pointer updating).
+ */
+static int
+esdm_aux_switch_hash(struct esdm_drng *drng, int __unused,
+		     const struct esdm_hash_cb *new_cb, void *new_hash,
+		     const struct esdm_hash_cb *old_cb)
+{
+	struct esdm_drng *init_drng = esdm_drng_init_instance();
+	struct esdm_pool *pool = &esdm_pool;
+	struct shash_desc *shash = (struct shash_desc *)pool->aux_pool;
+	u8 digest[ESDM_MAX_DIGESTSIZE];
+	int ret;
+
+	if (!IS_ENABLED(CONFIG_CRYPTO_ESDM_CRYPTO_SWITCH))
+		return -EOPNOTSUPP;
+
+	if (unlikely(!pool->initialized))
+		return 0;
+
+	/* We only switch if the processed DRNG is the initial DRNG. */
+	if (init_drng != drng)
+		return 0;
+
+	/* Get the aux pool hash with old digest ... */
+	ret = old_cb->hash_final(shash, digest) ?:
+	      /* ... re-initialize the hash with the new digest ... */
+	      new_cb->hash_init(shash, new_hash) ?:
+	      /*
+	       * ... feed the old hash into the new state. We may feed
+	       * uninitialized memory into the new state, but this is
+	       * considered no issue and even good as we have some more
+	       * uncertainty here.
+	       */
+	      new_cb->hash_update(shash, digest, sizeof(digest));
+	if (!ret) {
+		esdm_set_digestsize(new_cb->hash_digestsize(new_hash));
+		pr_debug("Re-initialize aux entropy pool with hash %s\n",
+			 new_cb->hash_name());
+	}
+
+	memzero_explicit(digest, sizeof(digest));
+	return ret;
+}
+
+/* Insert data into auxiliary pool by using the hash update function. */
+static int
+esdm_aux_pool_insert_locked(const u8 *inbuf, u32 inbuflen, u32 entropy_bits)
+{
+	struct esdm_pool *pool = &esdm_pool;
+	struct shash_desc *shash = (struct shash_desc *)pool->aux_pool;
+	struct esdm_drng *drng = esdm_drng_init_instance();
+	const struct esdm_hash_cb *hash_cb;
+	unsigned long flags;
+	void *hash;
+	int ret;
+
+	entropy_bits = min_t(u32, entropy_bits, inbuflen << 3);
+
+	read_lock_irqsave(&drng->hash_lock, flags);
+	hash_cb = drng->hash_cb;
+	hash = drng->hash;
+
+	if (unlikely(!pool->initialized)) {
+		ret = hash_cb->hash_init(shash, hash);
+		if (ret)
+			goto out;
+		pool->initialized = true;
+	}
+
+	ret = hash_cb->hash_update(shash, inbuf, inbuflen);
+	if (ret)
+		goto out;
+
+	/*
+	 * Cap the available entropy to the hash output size compliant to
+	 * SP800-90B section 3.1.5.1 table 1.
+	 */
+	entropy_bits += atomic_read_u32(&pool->aux_entropy_bits);
+	atomic_set(&pool->aux_entropy_bits,
+		   min_t(u32, entropy_bits,
+			 hash_cb->hash_digestsize(hash) << 3));
+
+out:
+	read_unlock_irqrestore(&drng->hash_lock, flags);
+	return ret;
+}
+
+int esdm_pool_insert_aux(const u8 *inbuf, u32 inbuflen, u32 entropy_bits)
+{
+	struct esdm_pool *pool = &esdm_pool;
+	unsigned long flags;
+	int ret;
+
+	spin_lock_irqsave(&pool->lock, flags);
+	ret = esdm_aux_pool_insert_locked(inbuf, inbuflen, entropy_bits);
+	spin_unlock_irqrestore(&pool->lock, flags);
+
+	esdm_es_add_entropy();
+
+	return ret;
+}
+EXPORT_SYMBOL(esdm_pool_insert_aux);
+
+/************************* Get data from entropy pool *************************/
+
+/*
+ * Get auxiliary entropy pool and its entropy content for seed buffer.
+ * Caller must hold esdm_pool.pool->lock.
+ * @outbuf: buffer to store data in with size requested_bits
+ * @requested_bits: Requested amount of entropy
+ * @return: amount of entropy in outbuf in bits.
+ */
+static u32 esdm_aux_get_pool(u8 *outbuf, u32 requested_bits)
+{
+	struct esdm_pool *pool = &esdm_pool;
+	struct shash_desc *shash = (struct shash_desc *)pool->aux_pool;
+	struct esdm_drng *drng = esdm_drng_init_instance();
+	const struct esdm_hash_cb *hash_cb;
+	unsigned long flags;
+	void *hash;
+	u32 collected_ent_bits, returned_ent_bits, unused_bits = 0,
+	    digestsize, digestsize_bits, requested_bits_osr;
+	u8 aux_output[ESDM_MAX_DIGESTSIZE];
+
+	if (unlikely(!pool->initialized))
+		return 0;
+
+	read_lock_irqsave(&drng->hash_lock, flags);
+
+	hash_cb = drng->hash_cb;
+	hash = drng->hash;
+	digestsize = hash_cb->hash_digestsize(hash);
+	digestsize_bits = digestsize << 3;
+
+	/* Cap to maximum entropy that can ever be generated with given hash */
+	esdm_cap_requested(digestsize_bits, requested_bits);
+
+	/* Ensure that no more than the size of aux_pool can be requested */
+	requested_bits = min_t(u32, requested_bits, (ESDM_MAX_DIGESTSIZE << 3));
+	requested_bits_osr = requested_bits + esdm_compress_osr();
+
+	/* Cap entropy with entropy counter from aux pool and the used digest */
+	collected_ent_bits = min_t(u32, digestsize_bits,
+			       atomic_xchg_relaxed(&pool->aux_entropy_bits, 0));
+
+	/* We collected too much entropy and put the overflow back */
+	if (collected_ent_bits > requested_bits_osr) {
+		/* Amount of bits we collected too much */
+		unused_bits = collected_ent_bits - requested_bits_osr;
+		/* Put entropy back */
+		atomic_add(unused_bits, &pool->aux_entropy_bits);
+		/* Fix collected entropy */
+		collected_ent_bits = requested_bits_osr;
+	}
+
+	/* Apply oversampling: discount requested oversampling rate */
+	returned_ent_bits = esdm_reduce_by_osr(collected_ent_bits);
+
+	pr_debug("obtained %u bits by collecting %u bits of entropy from aux pool, %u bits of entropy remaining\n",
+		 returned_ent_bits, collected_ent_bits, unused_bits);
+
+	/* Get the digest for the aux pool to be returned to the caller ... */
+	if (hash_cb->hash_final(shash, aux_output) ||
+	    /*
+	     * ... and re-initialize the aux state. Do not add the aux pool
+	     * digest for backward secrecy as it will be added with the
+	     * insertion of the complete seed buffer after it has been filled.
+	     */
+	    hash_cb->hash_init(shash, hash)) {
+		returned_ent_bits = 0;
+	} else {
+		/*
+		 * Do not truncate the output size exactly to collected_ent_bits
+		 * as the aux pool may contain data that is not credited with
+		 * entropy, but we want to use them to stir the DRNG state.
+		 */
+		memcpy(outbuf, aux_output, requested_bits >> 3);
+	}
+
+	read_unlock_irqrestore(&drng->hash_lock, flags);
+	memzero_explicit(aux_output, digestsize);
+	return returned_ent_bits;
+}
+
+static void esdm_aux_get_backtrack(struct entropy_buf *eb, u32 requested_bits,
+				   bool __unused)
+{
+	struct esdm_pool *pool = &esdm_pool;
+	unsigned long flags;
+
+	/* Ensure aux pool extraction and backtracking op are atomic */
+	spin_lock_irqsave(&pool->lock, flags);
+
+	eb->e_bits[esdm_ext_es_aux] = esdm_aux_get_pool(eb->e[esdm_ext_es_aux],
+							requested_bits);
+
+	/* Mix the extracted data back into pool for backtracking resistance */
+	if (esdm_aux_pool_insert_locked((u8 *)eb,
+					sizeof(struct entropy_buf), 0))
+		pr_warn("Backtracking resistance operation failed\n");
+
+	spin_unlock_irqrestore(&pool->lock, flags);
+}
+
+static void esdm_aux_es_state(unsigned char *buf, size_t buflen)
+{
+	const struct esdm_drng *esdm_drng_init = esdm_drng_init_instance();
+
+	/* Assume the esdm_drng_init lock is taken by caller */
+	snprintf(buf, buflen,
+		 " Hash for operating entropy pool: %s\n"
+		 " Available entropy: %u\n",
+		 esdm_drng_init->hash_cb->hash_name(),
+		 esdm_aux_avail_entropy(0));
+}
+
+struct esdm_es_cb esdm_es_aux = {
+	.name			= "Auxiliary",
+	.get_ent		= esdm_aux_get_backtrack,
+	.curr_entropy		= esdm_aux_avail_entropy,
+	.max_entropy		= esdm_get_digestsize,
+	.state			= esdm_aux_es_state,
+	.reset			= esdm_aux_reset,
+	.switch_hash		= esdm_aux_switch_hash,
+};
diff --git a/crypto/esdm/esdm_es_aux.h b/crypto/esdm/esdm_es_aux.h
new file mode 100644
index 000000000000..fde7f34696b0
--- /dev/null
+++ b/crypto/esdm/esdm_es_aux.h
@@ -0,0 +1,44 @@
+/* SPDX-License-Identifier: GPL-2.0 OR BSD-2-Clause */
+/*
+ * Copyright (C) 2022, Stephan Mueller <smueller@chronox.de>
+ */
+
+#ifndef _ESDM_ES_AUX_H
+#define _ESDM_ES_AUX_H
+
+#include "esdm_drng_mgr.h"
+#include "esdm_es_mgr_cb.h"
+
+u32 esdm_get_digestsize(void);
+void esdm_pool_set_entropy(u32 entropy_bits);
+int esdm_pool_insert_aux(const u8 *inbuf, u32 inbuflen, u32 entropy_bits);
+
+extern struct esdm_es_cb esdm_es_aux;
+
+/****************************** Helper code ***********************************/
+
+/* Obtain the security strength of the ESDM in bits */
+static inline u32 esdm_security_strength(void)
+{
+	/*
+	 * We use a hash to read the entropy in the entropy pool. According to
+	 * SP800-90B table 1, the entropy can be at most the digest size.
+	 * Considering this together with the last sentence in section 3.1.5.1.2
+	 * the security strength of a (approved) hash is equal to its output
+	 * size. On the other hand the entropy cannot be larger than the
+	 * security strength of the used DRBG.
+	 */
+	return min_t(u32, ESDM_FULL_SEED_ENTROPY_BITS, esdm_get_digestsize());
+}
+
+static inline u32 esdm_get_seed_entropy_osr(bool fully_seeded)
+{
+	u32 requested_bits = esdm_security_strength();
+
+	/* Apply oversampling during initialization according to SP800-90C */
+	if (esdm_sp80090c_compliant() && !fully_seeded)
+		requested_bits += CONFIG_CRYPTO_ESDM_SEED_BUFFER_INIT_ADD_BITS;
+	return requested_bits;
+}
+
+#endif /* _ESDM_ES_AUX_H */
diff --git a/crypto/esdm/esdm_es_mgr.c b/crypto/esdm/esdm_es_mgr.c
new file mode 100644
index 000000000000..8bdef5a934a8
--- /dev/null
+++ b/crypto/esdm/esdm_es_mgr.c
@@ -0,0 +1,364 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-2-Clause
+/*
+ * ESDM Entropy sources management
+ *
+ * Copyright (C) 2022, Stephan Mueller <smueller@chronox.de>
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/random.h>
+#include <linux/utsname.h>
+#include <linux/workqueue.h>
+
+#include "esdm_drng_mgr.h"
+#include "esdm_es_aux.h"
+#include "esdm_es_mgr.h"
+
+struct esdm_state {
+	bool perform_seedwork;		/* Can seed work be performed? */
+	bool esdm_operational;		/* Is DRNG operational? */
+	bool esdm_fully_seeded;		/* Is DRNG fully seeded? */
+	bool esdm_min_seeded;		/* Is DRNG minimally seeded? */
+	bool all_online_numa_node_seeded;/* All NUMA DRNGs seeded? */
+
+	/*
+	 * To ensure that external entropy providers cannot dominate the
+	 * internal noise sources but yet cannot be dominated by internal
+	 * noise sources, the following booleans are intended to allow
+	 * external to provide seed once when a DRNG reseed occurs. This
+	 * triggering of external noise source is performed even when the
+	 * entropy pool has sufficient entropy.
+	 */
+
+	atomic_t boot_entropy_thresh;	/* Reseed threshold */
+	atomic_t reseed_in_progress;	/* Flag for on executing reseed */
+	struct work_struct esdm_seed_work;	/* (re)seed work queue */
+};
+
+static struct esdm_state esdm_state = {
+	false, false, false, false, false,
+	.boot_entropy_thresh	= ATOMIC_INIT(ESDM_INIT_ENTROPY_BITS),
+	.reseed_in_progress	= ATOMIC_INIT(0),
+};
+
+/*
+ * If the entropy count falls under this number of bits, then we
+ * should wake up processes which are selecting or polling on write
+ * access to /dev/random.
+ */
+u32 esdm_write_wakeup_bits = (ESDM_WRITE_WAKEUP_ENTROPY << 3);
+
+/*
+ * The entries must be in the same order as defined by
+ * enum enum esdm_external_es
+ */
+struct esdm_es_cb *esdm_es[] = {
+	&esdm_es_aux
+};
+
+/********************************** Helper ***********************************/
+
+/*
+ * Reading of the ESDM pool is only allowed by one caller. The reading is
+ * only performed to (re)seed DRNGs. Thus, if this "lock" is already taken,
+ * the reseeding operation is in progress. The caller is not intended to wait
+ * but continue with its other operation.
+ */
+int esdm_pool_trylock(void)
+{
+	return atomic_cmpxchg(&esdm_state.reseed_in_progress, 0, 1);
+}
+
+void esdm_pool_unlock(void)
+{
+	atomic_set(&esdm_state.reseed_in_progress, 0);
+}
+
+/* Set new entropy threshold for reseeding during boot */
+void esdm_set_entropy_thresh(u32 new_entropy_bits)
+{
+	atomic_set(&esdm_state.boot_entropy_thresh, new_entropy_bits);
+}
+
+/*
+ * Reset ESDM state - the entropy counters are reset, but the data that may
+ * or may not have entropy remains in the pools as this data will not hurt.
+ */
+void esdm_reset_state(void)
+{
+	u32 i;
+
+	for_each_esdm_es(i) {
+		if (esdm_es[i]->reset)
+			esdm_es[i]->reset();
+	}
+	esdm_state.esdm_operational = false;
+	esdm_state.esdm_fully_seeded = false;
+	esdm_state.esdm_min_seeded = false;
+	esdm_state.all_online_numa_node_seeded = false;
+	pr_debug("reset ESDM\n");
+}
+
+/* Set flag that all DRNGs are fully seeded */
+void esdm_pool_all_numa_nodes_seeded(bool set)
+{
+	esdm_state.all_online_numa_node_seeded = set;
+}
+
+/* Return boolean whether ESDM reached minimally seed level */
+bool esdm_state_min_seeded(void)
+{
+	return esdm_state.esdm_min_seeded;
+}
+
+/* Return boolean whether ESDM reached fully seed level */
+bool esdm_state_fully_seeded(void)
+{
+	return esdm_state.esdm_fully_seeded;
+}
+
+/* Return boolean whether ESDM is considered fully operational */
+bool esdm_state_operational(void)
+{
+	return esdm_state.esdm_operational;
+}
+
+static void esdm_init_wakeup(void)
+{
+	wake_up_all(&esdm_init_wait);
+}
+
+static bool esdm_fully_seeded(bool fully_seeded, u32 collected_entropy)
+{
+	return (collected_entropy >= esdm_get_seed_entropy_osr(fully_seeded));
+}
+
+/* Policy to check whether entropy buffer contains full seeded entropy */
+bool esdm_fully_seeded_eb(bool fully_seeded, struct entropy_buf *eb)
+{
+	u32 i, collected_entropy = 0;
+
+	for_each_esdm_es(i)
+		collected_entropy += eb->e_bits[i];
+
+	return esdm_fully_seeded(fully_seeded, collected_entropy);
+}
+
+/* Mark one DRNG as not fully seeded */
+void esdm_unset_fully_seeded(struct esdm_drng *drng)
+{
+	drng->fully_seeded = false;
+	esdm_pool_all_numa_nodes_seeded(false);
+
+	/*
+	 * The init DRNG instance must always be fully seeded as this instance
+	 * is the fall-back if any of the per-NUMA node DRNG instances is
+	 * insufficiently seeded. Thus, we mark the entire ESDM as
+	 * non-operational if the initial DRNG becomes not fully seeded.
+	 */
+	if (drng == esdm_drng_init_instance() && esdm_state_operational()) {
+		pr_debug("ESDM set to non-operational\n");
+		esdm_state.esdm_operational = false;
+		esdm_state.esdm_fully_seeded = false;
+
+		/* If sufficient entropy is available, reseed now. */
+		esdm_es_add_entropy();
+	}
+}
+
+/* Policy to enable ESDM operational mode */
+static void esdm_set_operational(void)
+{
+	/*
+	 * ESDM is operational if the initial DRNG is fully seeded. This state
+	 * can only occur if either the external entropy sources provided
+	 * sufficient entropy, or the SP800-90B startup test completed for
+	 * the internal ES to supply also entropy data.
+	 */
+	if (esdm_state.esdm_fully_seeded) {
+		esdm_state.esdm_operational = true;
+		esdm_init_wakeup();
+		pr_info("ESDM fully operational\n");
+	}
+}
+
+static u32 esdm_avail_entropy_thresh(void)
+{
+	u32 ent_thresh = esdm_security_strength();
+
+	/*
+	 * Apply oversampling during initialization according to SP800-90C as
+	 * we request a larger buffer from the ES.
+	 */
+	if (esdm_sp80090c_compliant() &&
+	    !esdm_state.all_online_numa_node_seeded)
+		ent_thresh += CONFIG_CRYPTO_ESDM_SEED_BUFFER_INIT_ADD_BITS;
+
+	return ent_thresh;
+}
+
+/* Available entropy in the entire ESDM considering all entropy sources */
+u32 esdm_avail_entropy(void)
+{
+	u32 i, ent = 0, ent_thresh = esdm_avail_entropy_thresh();
+
+	BUILD_BUG_ON(ARRAY_SIZE(esdm_es) != esdm_ext_es_last);
+	for_each_esdm_es(i)
+		ent += esdm_es[i]->curr_entropy(ent_thresh);
+	return ent;
+}
+
+/*
+ * esdm_init_ops() - Set seed stages of ESDM
+ *
+ * Set the slow noise source reseed trigger threshold. The initial threshold
+ * is set to the minimum data size that can be read from the pool: a word. Upon
+ * reaching this value, the next seed threshold of 128 bits is set followed
+ * by 256 bits.
+ *
+ * @eb: buffer containing the size of entropy currently injected into DRNG - if
+ *	NULL, the function obtains the available entropy from the ES.
+ */
+void esdm_init_ops(struct entropy_buf *eb)
+{
+	struct esdm_state *state = &esdm_state;
+	u32 i, requested_bits, seed_bits = 0;
+
+	if (state->esdm_operational)
+		return;
+
+	requested_bits = esdm_get_seed_entropy_osr(
+					state->all_online_numa_node_seeded);
+
+	if (eb) {
+		for_each_esdm_es(i)
+			seed_bits += eb->e_bits[i];
+	} else {
+		u32 ent_thresh = esdm_avail_entropy_thresh();
+
+		for_each_esdm_es(i)
+			seed_bits += esdm_es[i]->curr_entropy(ent_thresh);
+	}
+
+	/* DRNG is seeded with full security strength */
+	if (state->esdm_fully_seeded) {
+		esdm_set_operational();
+		esdm_set_entropy_thresh(requested_bits);
+	} else if (esdm_fully_seeded(state->all_online_numa_node_seeded,
+				     seed_bits)) {
+		state->esdm_fully_seeded = true;
+		esdm_set_operational();
+		state->esdm_min_seeded = true;
+		pr_info("ESDM fully seeded with %u bits of entropy\n",
+			seed_bits);
+		esdm_set_entropy_thresh(requested_bits);
+	} else if (!state->esdm_min_seeded) {
+
+		/* DRNG is seeded with at least 128 bits of entropy */
+		if (seed_bits >= ESDM_MIN_SEED_ENTROPY_BITS) {
+			state->esdm_min_seeded = true;
+			pr_info("ESDM minimally seeded with %u bits of entropy\n",
+				seed_bits);
+			esdm_set_entropy_thresh(requested_bits);
+			esdm_init_wakeup();
+
+		/* DRNG is seeded with at least ESDM_INIT_ENTROPY_BITS bits */
+		} else if (seed_bits >= ESDM_INIT_ENTROPY_BITS) {
+			pr_info("ESDM initial entropy level %u bits of entropy\n",
+				seed_bits);
+			esdm_set_entropy_thresh(ESDM_MIN_SEED_ENTROPY_BITS);
+		}
+	}
+}
+
+int __init esdm_rand_initialize(void)
+{
+	struct seed {
+		ktime_t time;
+		unsigned long data[(ESDM_MAX_DIGESTSIZE /
+				    sizeof(unsigned long))];
+		struct new_utsname utsname;
+	} seed __aligned(ESDM_KCAPI_ALIGN);
+	unsigned int i;
+
+	BUILD_BUG_ON(ESDM_MAX_DIGESTSIZE % sizeof(unsigned long));
+
+	seed.time = ktime_get_real();
+
+	for (i = 0; i < ARRAY_SIZE(seed.data); i++) {
+		if (!arch_get_random_seed_long(&(seed.data[i])) &&
+		    !arch_get_random_long(&seed.data[i]))
+			seed.data[i] = random_get_entropy();
+	}
+	memcpy(&seed.utsname, utsname(), sizeof(*(utsname())));
+
+	esdm_pool_insert_aux((u8 *)&seed, sizeof(seed), 0);
+	memzero_explicit(&seed, sizeof(seed));
+
+	/* Initialize the seed work queue */
+	INIT_WORK(&esdm_state.esdm_seed_work, esdm_drng_seed_work);
+	esdm_state.perform_seedwork = true;
+
+	return 0;
+}
+
+early_initcall(esdm_rand_initialize);
+
+/* Interface requesting a reseed of the DRNG */
+void esdm_es_add_entropy(void)
+{
+	/*
+	 * Once all DRNGs are fully seeded, the system-triggered arrival of
+	 * entropy will not cause any reseeding any more.
+	 */
+	if (likely(esdm_state.all_online_numa_node_seeded))
+		return;
+
+	/* Only trigger the DRNG reseed if we have collected entropy. */
+	if (esdm_avail_entropy() <
+	    atomic_read_u32(&esdm_state.boot_entropy_thresh))
+		return;
+
+	/* Ensure that the seeding only occurs once at any given time. */
+	if (esdm_pool_trylock())
+		return;
+
+	/* Seed the DRNG with any available noise. */
+	if (esdm_state.perform_seedwork)
+		schedule_work(&esdm_state.esdm_seed_work);
+	else
+		esdm_drng_seed_work(NULL);
+}
+
+/* Fill the seed buffer with data from the noise sources */
+void esdm_fill_seed_buffer(struct entropy_buf *eb, u32 requested_bits)
+{
+	struct esdm_state *state = &esdm_state;
+	u32 i, req_ent = esdm_sp80090c_compliant() ?
+			  esdm_security_strength() : ESDM_MIN_SEED_ENTROPY_BITS;
+
+	/* Guarantee that requested bits is a multiple of bytes */
+	BUILD_BUG_ON(ESDM_DRNG_SECURITY_STRENGTH_BITS % 8);
+
+	/* always reseed the DRNG with the current time stamp */
+	eb->now = random_get_entropy();
+
+	/*
+	 * Require at least 128 bits of entropy for any reseed. If the ESDM is
+	 * operated SP800-90C compliant we want to comply with SP800-90A section
+	 * 9.2 mandating that DRNG is reseeded with the security strength.
+	 */
+	if (state->esdm_fully_seeded && (esdm_avail_entropy() < req_ent)) {
+		for_each_esdm_es(i)
+			eb->e_bits[i] = 0;
+
+		return;
+	}
+
+	/* Concatenate the output of the entropy sources. */
+	for_each_esdm_es(i) {
+		esdm_es[i]->get_ent(eb, requested_bits,
+				    state->esdm_fully_seeded);
+	}
+}
diff --git a/crypto/esdm/esdm_es_mgr.h b/crypto/esdm/esdm_es_mgr.h
new file mode 100644
index 000000000000..e1b73fe618d1
--- /dev/null
+++ b/crypto/esdm/esdm_es_mgr.h
@@ -0,0 +1,46 @@
+/* SPDX-License-Identifier: GPL-2.0 OR BSD-2-Clause */
+/*
+ * Copyright (C) 2022, Stephan Mueller <smueller@chronox.de>
+ */
+
+#ifndef _ESDM_ES_MGR_H
+#define _ESDM_ES_MGR_H
+
+#include "esdm_es_mgr_cb.h"
+
+/*************************** General ESDM parameter ***************************/
+
+#define ESDM_DRNG_BLOCKSIZE 64		/* Maximum of DRNG block sizes */
+
+/* Helper to concatenate a macro with an integer type */
+#define ESDM_PASTER(x, y) x ## y
+#define ESDM_UINT32_C(x) ESDM_PASTER(x, U)
+
+/************************* Entropy sources management *************************/
+
+extern struct esdm_es_cb *esdm_es[];
+
+#define for_each_esdm_es(ctr)		\
+	for ((ctr) = 0; (ctr) < esdm_ext_es_last; (ctr)++)
+
+bool esdm_state_min_seeded(void);
+int esdm_rand_initialize(void);
+bool esdm_state_operational(void);
+
+extern u32 esdm_write_wakeup_bits;
+void esdm_set_entropy_thresh(u32 new);
+u32 esdm_avail_entropy(void);
+void esdm_reset_state(void);
+
+bool esdm_state_fully_seeded(void);
+
+int esdm_pool_trylock(void);
+void esdm_pool_unlock(void);
+void esdm_pool_all_numa_nodes_seeded(bool set);
+
+bool esdm_fully_seeded_eb(bool fully_seeded, struct entropy_buf *eb);
+void esdm_unset_fully_seeded(struct esdm_drng *drng);
+void esdm_fill_seed_buffer(struct entropy_buf *eb, u32 requested_bits);
+void esdm_init_ops(struct entropy_buf *eb);
+
+#endif /* _ESDM_ES_MGR_H */
diff --git a/crypto/esdm/esdm_es_mgr_cb.h b/crypto/esdm/esdm_es_mgr_cb.h
new file mode 100644
index 000000000000..41b39983196f
--- /dev/null
+++ b/crypto/esdm/esdm_es_mgr_cb.h
@@ -0,0 +1,67 @@
+/* SPDX-License-Identifier: GPL-2.0 OR BSD-2-Clause */
+/*
+ * Copyright (C) 2022, Stephan Mueller <smueller@chronox.de>
+ *
+ * Definition of an entropy source.
+ */
+
+#ifndef _ESDM_ES_MGR_CB_H
+#define _ESDM_ES_MGR_CB_H
+
+#include <crypto/esdm.h>
+
+#include "esdm_definitions.h"
+#include "esdm_drng_mgr.h"
+
+enum esdm_external_es {
+	esdm_ext_es_aux,			/* MUST BE LAST ES! */
+	esdm_ext_es_last			/* MUST be the last entry */
+};
+
+struct entropy_buf {
+	u8 e[esdm_ext_es_last][ESDM_DRNG_INIT_SEED_SIZE_BYTES];
+	u32 now, e_bits[esdm_ext_es_last];
+};
+
+/*
+ * struct esdm_es_cb - callback defining an entropy source
+ * @name: Name of the entropy source.
+ * @get_ent: Fetch entropy into the entropy_buf. The ES shall only deliver
+ *	     data if its internal initialization is complete, including any
+ *	     SP800-90B startup testing or similar.
+ * @curr_entropy: Return amount of currently available entropy.
+ * @max_entropy: Maximum amount of entropy the entropy source is able to
+ *		 maintain.
+ * @state: Buffer with human-readable ES state.
+ * @reset: Reset entropy source (drop all entropy and reinitialize).
+ *	   This callback may be NULL.
+ * @switch_hash: callback to switch from an old hash callback definition to
+ *		 a new one. This callback may be NULL.
+ */
+struct esdm_es_cb {
+	const char *name;
+	void (*get_ent)(struct entropy_buf *eb, u32 requested_bits,
+			bool fully_seeded);
+	u32 (*curr_entropy)(u32 requested_bits);
+	u32 (*max_entropy)(void);
+	void (*state)(unsigned char *buf, size_t buflen);
+	void (*reset)(void);
+	int (*switch_hash)(struct esdm_drng *drng, int node,
+			   const struct esdm_hash_cb *new_cb, void *new_hash,
+			   const struct esdm_hash_cb *old_cb);
+};
+
+/* Allow entropy sources to tell the ES manager that new entropy is there */
+void esdm_es_add_entropy(void);
+
+/* Cap to maximum entropy that can ever be generated with given hash */
+#define esdm_cap_requested(__digestsize_bits, __requested_bits)		\
+	do {								\
+		if (__digestsize_bits < __requested_bits) {		\
+			pr_debug("Cannot satisfy requested entropy %u due to insufficient hash size %u\n",\
+				 __requested_bits, __digestsize_bits);	\
+			__requested_bits = __digestsize_bits;		\
+		}							\
+	} while (0)
+
+#endif /* _ESDM_ES_MGR_CB_H */
diff --git a/crypto/esdm/esdm_sha.h b/crypto/esdm/esdm_sha.h
new file mode 100644
index 000000000000..c71662881b8d
--- /dev/null
+++ b/crypto/esdm/esdm_sha.h
@@ -0,0 +1,14 @@
+/* SPDX-License-Identifier: GPL-2.0 OR BSD-2-Clause */
+/*
+ * ESDM SHA definition usable in atomic contexts right from the start of the
+ * kernel.
+ *
+ * Copyright (C) 2022, Stephan Mueller <smueller@chronox.de>
+ */
+
+#ifndef _ESDM_SHA_H
+#define _ESDM_SHA_H
+
+extern const struct esdm_hash_cb esdm_sha_hash_cb;
+
+#endif /* _ESDM_SHA_H */
diff --git a/crypto/esdm/esdm_sha256.c b/crypto/esdm/esdm_sha256.c
new file mode 100644
index 000000000000..030c503d09c5
--- /dev/null
+++ b/crypto/esdm/esdm_sha256.c
@@ -0,0 +1,72 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-2-Clause
+/*
+ * Backend for the ESDM providing the SHA-256 implementation that can be used
+ * without the kernel crypto API available including during early boot and in
+ * atomic contexts.
+ *
+ * Copyright (C) 2022, Stephan Mueller <smueller@chronox.de>
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <crypto/esdm.h>
+#include <crypto/sha2.h>
+
+#include "esdm_sha.h"
+
+static u32 esdm_sha256_hash_digestsize(void *hash)
+{
+	return SHA256_DIGEST_SIZE;
+}
+
+static int esdm_sha256_hash_init(struct shash_desc *shash, void *hash)
+{
+	/*
+	 * We do not need a TFM - we only need sufficient space for
+	 * struct sha256_state on the stack.
+	 */
+	sha256_init(shash_desc_ctx(shash));
+	return 0;
+}
+
+static int esdm_sha256_hash_update(struct shash_desc *shash,
+				   const u8 *inbuf, u32 inbuflen)
+{
+	sha256_update(shash_desc_ctx(shash), inbuf, inbuflen);
+	return 0;
+}
+
+static int esdm_sha256_hash_final(struct shash_desc *shash, u8 *digest)
+{
+	sha256_final(shash_desc_ctx(shash), digest);
+	return 0;
+}
+
+static const char *esdm_sha256_hash_name(void)
+{
+	return "SHA-256";
+}
+
+static void esdm_sha256_hash_desc_zero(struct shash_desc *shash)
+{
+	memzero_explicit(shash_desc_ctx(shash), sizeof(struct sha256_state));
+}
+
+static void *esdm_sha256_hash_alloc(void)
+{
+	pr_info("Hash %s allocated\n", esdm_sha256_hash_name());
+	return NULL;
+}
+
+static void esdm_sha256_hash_dealloc(void *hash) { }
+
+const struct esdm_hash_cb esdm_sha_hash_cb = {
+	.hash_name		= esdm_sha256_hash_name,
+	.hash_alloc		= esdm_sha256_hash_alloc,
+	.hash_dealloc		= esdm_sha256_hash_dealloc,
+	.hash_digestsize	= esdm_sha256_hash_digestsize,
+	.hash_init		= esdm_sha256_hash_init,
+	.hash_update		= esdm_sha256_hash_update,
+	.hash_final		= esdm_sha256_hash_final,
+	.hash_desc_zero		= esdm_sha256_hash_desc_zero,
+};
diff --git a/include/crypto/esdm.h b/include/crypto/esdm.h
new file mode 100644
index 000000000000..95a12ea0356e
--- /dev/null
+++ b/include/crypto/esdm.h
@@ -0,0 +1,115 @@
+/* SPDX-License-Identifier: GPL-2.0 OR BSD-2-Clause */
+/*
+ * Copyright (C) 2022, Stephan Mueller <smueller@chronox.de>
+ */
+
+#ifndef _ESDM_H
+#define _ESDM_H
+
+#include <crypto/hash.h>
+#include <linux/errno.h>
+#include <linux/types.h>
+
+/*
+ * struct esdm_drng_cb - cryptographic callback functions defining a DRNG
+ * @drng_name		Name of DRNG
+ * @drng_alloc:		Allocate DRNG -- the provided integer should be used for
+ *			sanity checks.
+ *			return: allocated data structure or PTR_ERR on error
+ * @drng_dealloc:	Deallocate DRNG
+ * @drng_seed:		Seed the DRNG with data of arbitrary length drng: is
+ *			pointer to data structure allocated with drng_alloc
+ *			return: >= 0 on success, < 0 on error
+ * @drng_generate:	Generate random numbers from the DRNG with arbitrary
+ *			length
+ */
+struct esdm_drng_cb {
+	const char *(*drng_name)(void);
+	void *(*drng_alloc)(u32 sec_strength);
+	void (*drng_dealloc)(void *drng);
+	int (*drng_seed)(void *drng, const u8 *inbuf, u32 inbuflen);
+	int (*drng_generate)(void *drng, u8 *outbuf, u32 outbuflen);
+};
+
+/*
+ * struct esdm_hash_cb - cryptographic callback functions defining a hash
+ * @hash_name		Name of Hash used for reading entropy pool arbitrary
+ *			length
+ * @hash_alloc:		Allocate the hash for reading the entropy pool
+ *			return: allocated data structure (NULL is success too)
+ *				or ERR_PTR on error
+ * @hash_dealloc:	Deallocate Hash
+ * @hash_digestsize:	Return the digestsize for the used hash to read out
+ *			entropy pool
+ *			hash: is pointer to data structure allocated with
+ *			      hash_alloc
+ *			return: size of digest of hash in bytes
+ * @hash_init:		Initialize hash
+ *			hash: is pointer to data structure allocated with
+ *			      hash_alloc
+ *			return: 0 on success, < 0 on error
+ * @hash_update:	Update hash operation
+ *			hash: is pointer to data structure allocated with
+ *			      hash_alloc
+ *			return: 0 on success, < 0 on error
+ * @hash_final		Final hash operation
+ *			hash: is pointer to data structure allocated with
+ *			      hash_alloc
+ *			return: 0 on success, < 0 on error
+ * @hash_desc_zero	Zeroization of hash state buffer
+ *
+ * Assumptions:
+ *
+ * 1. Hash operation will not sleep
+ * 2. The hash' volatile state information is provided with *shash by caller.
+ */
+struct esdm_hash_cb {
+	const char *(*hash_name)(void);
+	void *(*hash_alloc)(void);
+	void (*hash_dealloc)(void *hash);
+	u32 (*hash_digestsize)(void *hash);
+	int (*hash_init)(struct shash_desc *shash, void *hash);
+	int (*hash_update)(struct shash_desc *shash, const u8 *inbuf,
+			   u32 inbuflen);
+	int (*hash_final)(struct shash_desc *shash, u8 *digest);
+	void (*hash_desc_zero)(struct shash_desc *shash);
+};
+
+/*
+ * esdm_get_random_bytes_full() - Provider of cryptographic strong
+ * random numbers for kernel-internal usage from a fully initialized ESDM.
+ *
+ * This function will always return random numbers from a fully seeded and
+ * fully initialized ESDM.
+ *
+ * This function is appropriate only for non-atomic use cases as this
+ * function may sleep. It provides access to the full functionality of ESDM
+ * including the switchable DRNG support, that may support other DRNGs such
+ * as the SP800-90A DRBG.
+ *
+ * @buf: buffer to store the random bytes
+ * @nbytes: size of the buffer
+ */
+#ifdef CONFIG_CRYPTO_ESDM
+void esdm_get_random_bytes_full(void *buf, int nbytes);
+#endif
+
+/*
+ * esdm_get_random_bytes_min() - Provider of cryptographic strong
+ * random numbers for kernel-internal usage from at least a minimally seeded
+ * ESDM, which is not necessarily fully initialized yet (e.g. SP800-90C
+ * oversampling applied in FIPS mode is not applied yet).
+ *
+ * This function is appropriate only for non-atomic use cases as this
+ * function may sleep. It provides access to the full functionality of ESDM
+ * including the switchable DRNG support, that may support other DRNGs such
+ * as the SP800-90A DRBG.
+ *
+ * @buf: buffer to store the random bytes
+ * @nbytes: size of the buffer
+ */
+#ifdef CONFIG_CRYPTO_ESDM
+void esdm_get_random_bytes_min(void *buf, int nbytes);
+#endif
+
+#endif /* _ESDM_H */
-- 
2.33.1




