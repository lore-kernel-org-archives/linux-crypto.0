Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8644143888;
	Thu, 30 Jan 2025 03:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738209293; cv=none; b=gJJwLxn7BH0OB94/bqNZbGEq6ofpbvFENIcwqdsbSJf/eN6HYDCnO2jxJw60YNXYUDSAeslbl4E6Qs0Wls4fU9EJsiE4ANjwUVRbHu/EmDQlTctkZuBY7uM97idE7krQ+yY3xL2hH9Kc+r8sGUZ3ncvhQWwHnPirNHnCCYavdSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738209293; c=relaxed/simple;
	bh=Gi/8jr4IGz/3S/0kRQSXTAldgIt4U06ypURIq0uejFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gaA3lZNlTjG4d7g0V64K2X2eiSl6qGKxPDuVpPUEJqSocfIy5Y+WUUtVQ/O3TWnVlAsU9D/VvuGXI2YM9tNswQCl3jYlRonewx7JBPY7cmEShrICnd7nwtY1LrsjfzX7Ug55G9loXN9D/z7hIgErOtpmpa/Kn1o6ges4KUimfpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PyiYkMlT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PyiYkMlT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80FC1C4CEE2;
	Thu, 30 Jan 2025 03:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738209292;
	bh=Gi/8jr4IGz/3S/0kRQSXTAldgIt4U06ypURIq0uejFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PyiYkMlTAjz6iHrR+ZrHjuLimqH9UBBz1qRz9B+wuWiT64BCU5rbrqTl1yKorvOaQ
	 ZfgDFjdNy95b+UnzneuBubUaDa/hUJH+CdXSYDTuIXDR29867soLHXGI2Nu78CJVew
	 yZsq7Jc6/sBLUTAwLzmq/adbA7lPR+leetkC+TFf2mLCv83Tzb1MN7QGT61aQvavhz
	 me2OQFC5zYkcuIqXhcOgGu/EvawcW6K0j4Rjf5lDrqU2D89KRIkJI6Kbg8fiKgdhOz
	 5Sn48yyFhy+vJdRwlQnF6tmb1HAmjqSgoh4+BzUIDyQLfL3dYEtEijol1r5JBxDi1q
	 kC8V9uogJvteQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	x86@kernel.org,
	linux-block@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Keith Busch <kbusch@kernel.org>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v2 01/11] lib/crc64-rocksoft: stop wrapping the crypto API
Date: Wed, 29 Jan 2025 19:51:20 -0800
Message-ID: <20250130035130.180676-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130035130.180676-1-ebiggers@kernel.org>
References: <20250130035130.180676-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Following what was done for the CRC32 and CRC-T10DIF library functions,
get rid of the pointless use of the crypto API and make
crc64_rocksoft_update() call into the library directly.  This is faster
and simpler.

Remove crc64_rocksoft() (the version of the function that did not take a
'crc' argument) since it is unused.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 block/Kconfig         |   2 +-
 include/linux/crc64.h |  13 ++++-
 lib/Kconfig           |   9 ---
 lib/Makefile          |   1 -
 lib/crc64-rocksoft.c  | 126 ------------------------------------------
 lib/crc64.c           |   7 ---
 6 files changed, 12 insertions(+), 146 deletions(-)
 delete mode 100644 lib/crc64-rocksoft.c

diff --git a/block/Kconfig b/block/Kconfig
index 5b623b876d3b..df8973bc0539 100644
--- a/block/Kconfig
+++ b/block/Kconfig
@@ -61,11 +61,11 @@ config BLK_DEV_BSGLIB
 	  If unsure, say N.
 
 config BLK_DEV_INTEGRITY
 	bool "Block layer data integrity support"
 	select CRC_T10DIF
-	select CRC64_ROCKSOFT
+	select CRC64
 	help
 	Some storage devices allow extra information to be
 	stored/retrieved to help protect the data.  The block layer
 	data integrity option provides hooks which can be used by
 	filesystems to ensure better data integrity.
diff --git a/include/linux/crc64.h b/include/linux/crc64.h
index e044c60d1e61..0a595b272166 100644
--- a/include/linux/crc64.h
+++ b/include/linux/crc64.h
@@ -10,9 +10,18 @@
 #define CRC64_ROCKSOFT_STRING "crc64-rocksoft"
 
 u64 __pure crc64_be(u64 crc, const void *p, size_t len);
 u64 __pure crc64_rocksoft_generic(u64 crc, const void *p, size_t len);
 
-u64 crc64_rocksoft(const unsigned char *buffer, size_t len);
-u64 crc64_rocksoft_update(u64 crc, const unsigned char *buffer, size_t len);
+/**
+ * crc64_rocksoft_update - Calculate bitwise Rocksoft CRC64
+ * @crc: seed value for computation. 0 for a new CRC calculation, or the
+ *	 previous crc64 value if computing incrementally.
+ * @p: pointer to buffer over which CRC64 is run
+ * @len: length of buffer @p
+ */
+static inline u64 crc64_rocksoft_update(u64 crc, const u8 *p, size_t len)
+{
+	return crc64_rocksoft_generic(crc, p, len);
+}
 
 #endif /* _LINUX_CRC64_H */
diff --git a/lib/Kconfig b/lib/Kconfig
index dccb61b7d698..da07fd39cf97 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -166,19 +166,10 @@ config ARCH_HAS_CRC_T10DIF
 
 config CRC_T10DIF_ARCH
 	tristate
 	default CRC_T10DIF if ARCH_HAS_CRC_T10DIF && CRC_OPTIMIZATIONS
 
-config CRC64_ROCKSOFT
-	tristate "CRC calculation for the Rocksoft model CRC64"
-	select CRC64
-	select CRYPTO
-	select CRYPTO_CRC64_ROCKSOFT
-	help
-	  This option provides a CRC64 API to a registered crypto driver.
-	  This is used with the block layer's data integrity subsystem.
-
 config CRC_ITU_T
 	tristate "CRC ITU-T V.41 functions"
 	help
 	  This option is provided for the case where no in-kernel-tree
 	  modules require CRC ITU-T V.41 functions, but a module built outside
diff --git a/lib/Makefile b/lib/Makefile
index f1c6e9d76a7c..518018b2a5d4 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -164,11 +164,10 @@ obj-$(CONFIG_CRC_ITU_T)	+= crc-itu-t.o
 obj-$(CONFIG_CRC32)	+= crc32.o
 obj-$(CONFIG_CRC64)     += crc64.o
 obj-$(CONFIG_CRC4)	+= crc4.o
 obj-$(CONFIG_CRC7)	+= crc7.o
 obj-$(CONFIG_CRC8)	+= crc8.o
-obj-$(CONFIG_CRC64_ROCKSOFT) += crc64-rocksoft.o
 obj-$(CONFIG_XXHASH)	+= xxhash.o
 obj-$(CONFIG_GENERIC_ALLOCATOR) += genalloc.o
 
 obj-$(CONFIG_842_COMPRESS) += 842/
 obj-$(CONFIG_842_DECOMPRESS) += 842/
diff --git a/lib/crc64-rocksoft.c b/lib/crc64-rocksoft.c
deleted file mode 100644
index fc9ae0da5df7..000000000000
--- a/lib/crc64-rocksoft.c
+++ /dev/null
@@ -1,126 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-
-#include <linux/types.h>
-#include <linux/module.h>
-#include <linux/crc64.h>
-#include <linux/err.h>
-#include <linux/init.h>
-#include <crypto/hash.h>
-#include <crypto/algapi.h>
-#include <linux/static_key.h>
-#include <linux/notifier.h>
-
-static struct crypto_shash __rcu *crc64_rocksoft_tfm;
-static DEFINE_STATIC_KEY_TRUE(crc64_rocksoft_fallback);
-static DEFINE_MUTEX(crc64_rocksoft_mutex);
-static struct work_struct crc64_rocksoft_rehash_work;
-
-static int crc64_rocksoft_notify(struct notifier_block *self, unsigned long val, void *data)
-{
-	struct crypto_alg *alg = data;
-
-	if (val != CRYPTO_MSG_ALG_LOADED ||
-	    strcmp(alg->cra_name, CRC64_ROCKSOFT_STRING))
-		return NOTIFY_DONE;
-
-	schedule_work(&crc64_rocksoft_rehash_work);
-	return NOTIFY_OK;
-}
-
-static void crc64_rocksoft_rehash(struct work_struct *work)
-{
-	struct crypto_shash *new, *old;
-
-	mutex_lock(&crc64_rocksoft_mutex);
-	old = rcu_dereference_protected(crc64_rocksoft_tfm,
-					lockdep_is_held(&crc64_rocksoft_mutex));
-	new = crypto_alloc_shash(CRC64_ROCKSOFT_STRING, 0, 0);
-	if (IS_ERR(new)) {
-		mutex_unlock(&crc64_rocksoft_mutex);
-		return;
-	}
-	rcu_assign_pointer(crc64_rocksoft_tfm, new);
-	mutex_unlock(&crc64_rocksoft_mutex);
-
-	if (old) {
-		synchronize_rcu();
-		crypto_free_shash(old);
-	} else {
-		static_branch_disable(&crc64_rocksoft_fallback);
-	}
-}
-
-static struct notifier_block crc64_rocksoft_nb = {
-	.notifier_call = crc64_rocksoft_notify,
-};
-
-u64 crc64_rocksoft_update(u64 crc, const unsigned char *buffer, size_t len)
-{
-	struct {
-		struct shash_desc shash;
-		u64 crc;
-	} desc;
-	int err;
-
-	if (static_branch_unlikely(&crc64_rocksoft_fallback))
-		return crc64_rocksoft_generic(crc, buffer, len);
-
-	rcu_read_lock();
-	desc.shash.tfm = rcu_dereference(crc64_rocksoft_tfm);
-	desc.crc = crc;
-	err = crypto_shash_update(&desc.shash, buffer, len);
-	rcu_read_unlock();
-
-	BUG_ON(err);
-
-	return desc.crc;
-}
-EXPORT_SYMBOL_GPL(crc64_rocksoft_update);
-
-u64 crc64_rocksoft(const unsigned char *buffer, size_t len)
-{
-	return crc64_rocksoft_update(0, buffer, len);
-}
-EXPORT_SYMBOL_GPL(crc64_rocksoft);
-
-static int __init crc64_rocksoft_mod_init(void)
-{
-	INIT_WORK(&crc64_rocksoft_rehash_work, crc64_rocksoft_rehash);
-	crypto_register_notifier(&crc64_rocksoft_nb);
-	crc64_rocksoft_rehash(&crc64_rocksoft_rehash_work);
-	return 0;
-}
-
-static void __exit crc64_rocksoft_mod_fini(void)
-{
-	crypto_unregister_notifier(&crc64_rocksoft_nb);
-	cancel_work_sync(&crc64_rocksoft_rehash_work);
-	crypto_free_shash(rcu_dereference_protected(crc64_rocksoft_tfm, 1));
-}
-
-module_init(crc64_rocksoft_mod_init);
-module_exit(crc64_rocksoft_mod_fini);
-
-static int crc64_rocksoft_transform_show(char *buffer, const struct kernel_param *kp)
-{
-	struct crypto_shash *tfm;
-	int len;
-
-	if (static_branch_unlikely(&crc64_rocksoft_fallback))
-		return sprintf(buffer, "fallback\n");
-
-	rcu_read_lock();
-	tfm = rcu_dereference(crc64_rocksoft_tfm);
-	len = snprintf(buffer, PAGE_SIZE, "%s\n",
-		       crypto_shash_driver_name(tfm));
-	rcu_read_unlock();
-
-	return len;
-}
-
-module_param_call(transform, NULL, crc64_rocksoft_transform_show, NULL, 0444);
-
-MODULE_AUTHOR("Keith Busch <kbusch@kernel.org>");
-MODULE_DESCRIPTION("Rocksoft model CRC64 calculation (library API)");
-MODULE_LICENSE("GPL");
-MODULE_SOFTDEP("pre: crc64");
diff --git a/lib/crc64.c b/lib/crc64.c
index 61ae8dfb6a1c..b5136fb4c199 100644
--- a/lib/crc64.c
+++ b/lib/crc64.c
@@ -61,17 +61,10 @@ u64 __pure crc64_be(u64 crc, const void *p, size_t len)
 
 	return crc;
 }
 EXPORT_SYMBOL_GPL(crc64_be);
 
-/**
- * crc64_rocksoft_generic - Calculate bitwise Rocksoft CRC64
- * @crc: seed value for computation. 0 for a new CRC calculation, or the
- * 	 previous crc64 value if computing incrementally.
- * @p: pointer to buffer over which CRC64 is run
- * @len: length of buffer @p
- */
 u64 __pure crc64_rocksoft_generic(u64 crc, const void *p, size_t len)
 {
 	const unsigned char *_p = p;
 	size_t i;
 
-- 
2.48.1

