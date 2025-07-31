Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5922C2512DE;
	Thu, 31 Jul 2025 19:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753990045; cv=none; b=PW9RIHuQ/b2G6+afk6ilD9CWsiJfLXm/2rBmUjp/j6zfxoReRCHriu5TPZDF7O1Y3zqINs2SFJMUqi15HCC/QXnNdS4/tx6DDJIQKeeSPoDqI39Oh9viBjW/gdsFk52Silk0AiFk+bguUMt0jup0jqWJ6pqf7qjBPBKpd9nA/xs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753990045; c=relaxed/simple;
	bh=6X6ezduc8UlsWVmDvq11p/5uN+3imLfJvwADkDpblFM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qjbGnkbteEuUR324rUK2hKTksmp1vDk+p2kXcDeEm8WzgeuLz6dFKjRRb7xhJT4z5SrlnBCso4k16S+AUSWGKwRn8pIwRkwlY3CQU6eq+H+nDHRFomjTYl79Hd57hsSxUk86EjS5GwiFIpVRWFeah913xr6Z+EgIFkw1amIMsxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qyx10PxM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qyx10PxM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 782B7C4CEF9;
	Thu, 31 Jul 2025 19:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753990044;
	bh=6X6ezduc8UlsWVmDvq11p/5uN+3imLfJvwADkDpblFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qyx10PxMdEugOcuSKVOI7TIvduWs0tqUHEdt0Zl4NaGJttvngvGFMhjscb9FHeoOG
	 0bDM/aR+0ZAa6VMuwBkTp2b7/qp/mEtCr5iJ6X0xbOxBcGyeICEMzovfCaZLoJt+Z9
	 FIVoblKiRFQS69lAAYDxmrR5pav7sSYI71MjVxbo7y4HlaI8Oq8IcuVCr6KB7793ni
	 +U0B7d9mgJfBLYeSsR3pqalJvCQbEm5sSBXs99UHijLItAo73Zx+OLH1cJGoopzHds
	 lEBSs1Oe03DR/oHpZcrSWYeGHDF+C14gW49Gxv4yTW8x31MMYsuzGc2ZRBJKnw78y0
	 c2SiaI3mVbzog==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-usb@vger.kernel.org,
	Andreas Noever <andreas.noever@gmail.com>,
	Michael Jamet <michael.jamet@intel.com>,
	Mika Westerberg <westeri@kernel.org>,
	Yehezkel Bernat <YehezkelShB@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 2/2] thunderbolt: Use HMAC-SHA256 library instead of crypto_shash
Date: Thu, 31 Jul 2025 12:25:45 -0700
Message-ID: <20250731192545.29869-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250731192545.29869-1-ebiggers@kernel.org>
References: <20250731192545.29869-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use the hmac_sha256_usingrawkey() library function instead of the
"hmac(sha256)" crypto_shash.  This is simpler and faster.

As a cleanup, change the input data parameters from "challenge,
sizeof(hmac)" to "challenge, sizeof(challenge)", so that the size is
being taken of the correct buffer.  This is not a functional change,
since it happens that sizeof(hmac) == sizeof(challenge).

Replace the selection of CRYPTO and CRYPTO_HASH with CRYPTO_LIB_SHA256
and CRYPTO_LIB_UTILS.  The latter is needed for crypto_memneq() which
was previously being pulled in via CRYPTO.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 drivers/thunderbolt/Kconfig  |  4 ++--
 drivers/thunderbolt/domain.c | 44 +++++-------------------------------
 2 files changed, 8 insertions(+), 40 deletions(-)

diff --git a/drivers/thunderbolt/Kconfig b/drivers/thunderbolt/Kconfig
index 0abdb69ee9f43..db3b0bef48f4c 100644
--- a/drivers/thunderbolt/Kconfig
+++ b/drivers/thunderbolt/Kconfig
@@ -2,12 +2,12 @@
 menuconfig USB4
 	tristate "Unified support for USB4 and Thunderbolt"
 	depends on PCI
 	select APPLE_PROPERTIES if EFI_STUB && X86
 	select CRC32
-	select CRYPTO
-	select CRYPTO_HASH
+	select CRYPTO_LIB_SHA256
+	select CRYPTO_LIB_UTILS
 	select NVMEM
 	help
 	  USB4 and Thunderbolt driver. USB4 is the public specification
 	  based on the Thunderbolt 3 protocol. This driver is required if
 	  you want to hotplug Thunderbolt and USB4 compliant devices on
diff --git a/drivers/thunderbolt/domain.c b/drivers/thunderbolt/domain.c
index 7e0eb3c07f1c7..5272c255e046d 100644
--- a/drivers/thunderbolt/domain.c
+++ b/drivers/thunderbolt/domain.c
@@ -10,11 +10,11 @@
 #include <linux/idr.h>
 #include <linux/module.h>
 #include <linux/pm_runtime.h>
 #include <linux/slab.h>
 #include <linux/random.h>
-#include <crypto/hash.h>
+#include <crypto/sha2.h>
 #include <crypto/utils.h>
 
 #include "tb.h"
 
 static DEFINE_IDA(tb_domain_ida);
@@ -707,12 +707,10 @@ int tb_domain_challenge_switch_key(struct tb *tb, struct tb_switch *sw)
 {
 	u8 challenge[TB_SWITCH_KEY_SIZE];
 	u8 response[TB_SWITCH_KEY_SIZE];
 	u8 hmac[TB_SWITCH_KEY_SIZE];
 	struct tb_switch *parent_sw;
-	struct crypto_shash *tfm;
-	struct shash_desc *shash;
 	int ret;
 
 	if (!tb->cm_ops->approve_switch || !tb->cm_ops->challenge_switch_key)
 		return -EPERM;
 
@@ -724,49 +722,19 @@ int tb_domain_challenge_switch_key(struct tb *tb, struct tb_switch *sw)
 	get_random_bytes(challenge, sizeof(challenge));
 	ret = tb->cm_ops->challenge_switch_key(tb, sw, challenge, response);
 	if (ret)
 		return ret;
 
-	tfm = crypto_alloc_shash("hmac(sha256)", 0, 0);
-	if (IS_ERR(tfm))
-		return PTR_ERR(tfm);
-
-	ret = crypto_shash_setkey(tfm, sw->key, TB_SWITCH_KEY_SIZE);
-	if (ret)
-		goto err_free_tfm;
-
-	shash = kzalloc(sizeof(*shash) + crypto_shash_descsize(tfm),
-			GFP_KERNEL);
-	if (!shash) {
-		ret = -ENOMEM;
-		goto err_free_tfm;
-	}
-
-	shash->tfm = tfm;
-
-	memset(hmac, 0, sizeof(hmac));
-	ret = crypto_shash_digest(shash, challenge, sizeof(hmac), hmac);
-	if (ret)
-		goto err_free_shash;
+	static_assert(sizeof(hmac) == SHA256_DIGEST_SIZE);
+	hmac_sha256_usingrawkey(sw->key, TB_SWITCH_KEY_SIZE,
+				challenge, sizeof(challenge), hmac);
 
 	/* The returned HMAC must match the one we calculated */
-	if (crypto_memneq(response, hmac, sizeof(hmac))) {
-		ret = -EKEYREJECTED;
-		goto err_free_shash;
-	}
-
-	crypto_free_shash(tfm);
-	kfree(shash);
+	if (crypto_memneq(response, hmac, sizeof(hmac)))
+		return -EKEYREJECTED;
 
 	return tb->cm_ops->approve_switch(tb, sw);
-
-err_free_shash:
-	kfree(shash);
-err_free_tfm:
-	crypto_free_shash(tfm);
-
-	return ret;
 }
 
 /**
  * tb_domain_disconnect_pcie_paths() - Disconnect all PCIe paths
  * @tb: Domain whose PCIe paths to disconnect
-- 
2.50.1

