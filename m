Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C09E1B644;
	Fri,  1 Aug 2025 23:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754092566; cv=none; b=q8T+wnY4IAu/xqrcEcFjx5zQkxoXgMJMwmUdQ+EQSQ9lPX6bL5rWcSpmJJsyYyOMZ4ueApOOdvvdb4DdxmaEWZi/AB8XVq8k1DBJwKU+9LxR5cPwoHm55S3oiIBt85Fjmv8yipoxOa1TQMEo+UnKz9rJJa6xAkIRjDAOSmTAMCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754092566; c=relaxed/simple;
	bh=dbaFLzCG/5EkHTeHj907dORnHsrShX2dlh1BlaIdXok=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DPOPklhs/VYV/G4HNrxDaEuBr4cM+10WmaUV1rGeLkrfVKQUqe49GttbjAtYtMTpT3a1dtCgZiQnFuK5AbOZFFJhu+KPSeo4E48RrZE6D5OrzYUeyNINzvTvdZez8hrW9g7Ce8reHf1N8qNJESibDYYWrpUW60iFUcLIMWh3CCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p8a1t5NY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p8a1t5NY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D4A3C4CEE7;
	Fri,  1 Aug 2025 23:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754092566;
	bh=dbaFLzCG/5EkHTeHj907dORnHsrShX2dlh1BlaIdXok=;
	h=From:To:Cc:Subject:Date:From;
	b=p8a1t5NYG6c2K+OI6nAVg88FYPTy/1li6BCKUEzy4rRRTpg8B/6Y3zLka/U7RjFgy
	 PKKbeziwCQJh3gPrHoWMyrlM/WixH/isi29k61/aNlTAuS+zMdqawoZhNaacTq4FsH
	 NqKEF81yw2JuzXpKrB3R6Pu1MVawZmdyYyRMpTP7TEDeCp9n77VwvyWi2Tvzsk+xXT
	 LLfYahxLDKgyGxeV3uPf9NrBt7sscnMCw9wZeWboYTaNA622HT+d5qc5Rr7p46AtVh
	 Emvs0Ir8MuMTUPxCuIgCmsBwfCasaCsiPbzIzKbyslliw7+6Abto6e6tEp0F0Rbmx1
	 DwCTYmtLjSOKQ==
From: Eric Biggers <ebiggers@kernel.org>
To: Jens Wiklander <jens.wiklander@linaro.org>,
	Sumit Garg <sumit.garg@kernel.org>,
	op-tee@lists.trustedfirmware.org
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH] tee: Use SHA-1 library instead of crypto_shash
Date: Fri,  1 Aug 2025 16:55:41 -0700
Message-ID: <20250801235541.14050-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use the SHA-1 library functions instead of crypto_shash.  This is
simpler and faster.

Change uuid_v5() to return void, since it can no longer fail.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---

Note: this patch depends on the SHA-1 library functions that were merged
in v6.17-rc1.

 drivers/tee/Kconfig    |  3 +--
 drivers/tee/tee_core.c | 55 +++++++-----------------------------------
 2 files changed, 10 insertions(+), 48 deletions(-)

diff --git a/drivers/tee/Kconfig b/drivers/tee/Kconfig
index 61b507c187801..a84767940fbfc 100644
--- a/drivers/tee/Kconfig
+++ b/drivers/tee/Kconfig
@@ -1,12 +1,11 @@
 # SPDX-License-Identifier: GPL-2.0-only
 # Generic Trusted Execution Environment Configuration
 menuconfig TEE
 	tristate "Trusted Execution Environment support"
 	depends on HAVE_ARM_SMCCC || COMPILE_TEST || CPU_SUP_AMD
-	select CRYPTO
-	select CRYPTO_SHA1
+	select CRYPTO_LIB_SHA1
 	select DMA_SHARED_BUFFER
 	select GENERIC_ALLOCATOR
 	help
 	  This implements a generic interface towards a Trusted Execution
 	  Environment (TEE).
diff --git a/drivers/tee/tee_core.c b/drivers/tee/tee_core.c
index acc7998758ad8..d079aeee0690a 100644
--- a/drivers/tee/tee_core.c
+++ b/drivers/tee/tee_core.c
@@ -12,11 +12,10 @@
 #include <linux/module.h>
 #include <linux/overflow.h>
 #include <linux/slab.h>
 #include <linux/tee_core.h>
 #include <linux/uaccess.h>
-#include <crypto/hash.h>
 #include <crypto/sha1.h>
 #include "tee_private.h"
 
 #define TEE_NUM_DEVICES	32
 
@@ -140,72 +139,36 @@ static int tee_release(struct inode *inode, struct file *filp)
  * UUIDv5 is specific in RFC 4122.
  *
  * This implements section (for SHA-1):
  * 4.3.  Algorithm for Creating a Name-Based UUID
  */
-static int uuid_v5(uuid_t *uuid, const uuid_t *ns, const void *name,
-		   size_t size)
+static void uuid_v5(uuid_t *uuid, const uuid_t *ns, const void *name,
+		    size_t size)
 {
 	unsigned char hash[SHA1_DIGEST_SIZE];
-	struct crypto_shash *shash = NULL;
-	struct shash_desc *desc = NULL;
-	int rc;
-
-	shash = crypto_alloc_shash("sha1", 0, 0);
-	if (IS_ERR(shash)) {
-		rc = PTR_ERR(shash);
-		pr_err("shash(sha1) allocation failed\n");
-		return rc;
-	}
-
-	desc = kzalloc(sizeof(*desc) + crypto_shash_descsize(shash),
-		       GFP_KERNEL);
-	if (!desc) {
-		rc = -ENOMEM;
-		goto out_free_shash;
-	}
-
-	desc->tfm = shash;
+	struct sha1_ctx ctx;
 
-	rc = crypto_shash_init(desc);
-	if (rc < 0)
-		goto out_free_desc;
-
-	rc = crypto_shash_update(desc, (const u8 *)ns, sizeof(*ns));
-	if (rc < 0)
-		goto out_free_desc;
-
-	rc = crypto_shash_update(desc, (const u8 *)name, size);
-	if (rc < 0)
-		goto out_free_desc;
-
-	rc = crypto_shash_final(desc, hash);
-	if (rc < 0)
-		goto out_free_desc;
+	sha1_init(&ctx);
+	sha1_update(&ctx, (const u8 *)ns, sizeof(*ns));
+	sha1_update(&ctx, (const u8 *)name, size);
+	sha1_final(&ctx, hash);
 
 	memcpy(uuid->b, hash, UUID_SIZE);
 
 	/* Tag for version 5 */
 	uuid->b[6] = (hash[6] & 0x0F) | 0x50;
 	uuid->b[8] = (hash[8] & 0x3F) | 0x80;
-
-out_free_desc:
-	kfree(desc);
-
-out_free_shash:
-	crypto_free_shash(shash);
-	return rc;
 }
 
 int tee_session_calc_client_uuid(uuid_t *uuid, u32 connection_method,
 				 const u8 connection_data[TEE_IOCTL_UUID_LEN])
 {
 	gid_t ns_grp = (gid_t)-1;
 	kgid_t grp = INVALID_GID;
 	char *name = NULL;
 	int name_len;
-	int rc;
+	int rc = 0;
 
 	if (connection_method == TEE_IOCTL_LOGIN_PUBLIC ||
 	    connection_method == TEE_IOCTL_LOGIN_REE_KERNEL) {
 		/* Nil UUID to be passed to TEE environment */
 		uuid_copy(uuid, &uuid_null);
@@ -258,11 +221,11 @@ int tee_session_calc_client_uuid(uuid_t *uuid, u32 connection_method,
 	default:
 		rc = -EINVAL;
 		goto out_free_name;
 	}
 
-	rc = uuid_v5(uuid, &tee_client_uuid_ns, name, name_len);
+	uuid_v5(uuid, &tee_client_uuid_ns, name, name_len);
 out_free_name:
 	kfree(name);
 
 	return rc;
 }

base-commit: 0905809b38bda1fa0b206986c44d846e46f13c1d
-- 
2.50.1

