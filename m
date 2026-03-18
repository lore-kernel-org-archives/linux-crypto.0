Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2E042BCF5D;
	Wed, 18 Mar 2026 16:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773852261; cv=none; b=LRzINi7V74Ki1cthUyIxUoRXFNq5621DUesaBZgURmJXMitWr9bb4w8TcntoajmV2y621v36EG6mfOeATsx15HOwuyUce6mkM8pmz9s968sMgj+IHrIkaS2xMZXp23twZHOBIDyjpuUyBy9cqRYNgWRfXI+ph6dTjJ9xeZqwAQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773852261; c=relaxed/simple;
	bh=S1I1v1JYfYCSBVnYBSTqKOzREgSZiDwGWB5rfcKR+vM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FH7QLVFBfQNqCfeF6bD9Sw37+/zw80VIrxP7oFgxYHoJ+fR4YXybENBDmue+EGhYzkSNevnDc4pekKI9CWLUIB0hLllpkETN9dBpCpdu84Uu9W2lZaSfj0hacfV9gCBg4hihRTo/xLY9dFS8NblLM/GcbVEPv9OSaLn5Rsl4WWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d6mvj7DN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d6mvj7DN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 622A1C19421;
	Wed, 18 Mar 2026 16:44:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773852260;
	bh=S1I1v1JYfYCSBVnYBSTqKOzREgSZiDwGWB5rfcKR+vM=;
	h=From:To:Cc:Subject:Date:From;
	b=d6mvj7DNDWgKkzfFkbfYW9eeSYxibO6RiZqEg9h6Dn2+secwTwG6nnjTauU3W6jKr
	 RSb3ZSfted+AgYIDhA2yJ3JrWt3UGfDushpMUr0uARNKAHzsoddaKL4FCNRXMg3io7
	 eOrEFL20SMGehUDup1W/uropK5Y6tKHzijuLvK6Qbglxn7i7YM3srpgrcZmtWKTPpQ
	 2siyksNI8Ovwiby5yikKy9GuTn4SrQJqcDqAamezv+2wem26YBv2MVU1L2TylEnPCd
	 +PmqLaY9k6Hyx5gtbMjtLYVjp3xrABDeBFhaeXDlVYLchXz97dLNNpo/2R8oeDtB2b
	 2ll8jx3iikD1g==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Arnd Bergmann <arnd@kernel.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Dionna Amalie Glaze <dionnaglaze@google.com>,
	Cedric Xing <cedric.xing@intel.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Zi Li <zi.li@linux.dev>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Zhou Yuhang <zhouyuhang@kylinos.cn>,
	Colin Ian King <colin.i.king@gmail.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH] sample/tsm-mr: Use SHA-2 library APIs
Date: Wed, 18 Mar 2026 09:42:33 -0700
Message-ID: <20260318164233.19800-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Given that tsm_mr_sample has a particular set of algorithms that it
wants, just use the library APIs for those algorithms rather than
crypto_shash.  This is more straightforward and a bit more efficient.

This fixes an issue where this module failed to build due to the kconfig
options CRYPTO and CRYPTO_HASH not being selected.  Also, even if it
built, crypto_alloc_shash() could fail at runtime due to the needed
algorithms not being available.

The library functions simply use direct linking.  So if it builds, which
it will due to the kconfig options being enabled, they are available.

Fixes: f6953f1f9ec4 ("tsm-mr: Add tsm-mr sample code")
Fixes: 44a3873df811 ("coco/guest: Remove unneeded selection of CRYPTO")
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---

I'd like to take this via libcrypto-next, as that is where
"coco/guest: Remove unneeded selection of CRYPTO" is.

This is an alternative to
https://lore.kernel.org/r/20260318105200.1985712-1-arnd@kernel.org

 samples/Kconfig                |  2 +
 samples/tsm-mr/tsm_mr_sample.c | 68 +++++++++++++++++-----------------
 2 files changed, 35 insertions(+), 35 deletions(-)

diff --git a/samples/Kconfig b/samples/Kconfig
index 5bc7c9e5a59e..a75e8e78330d 100644
--- a/samples/Kconfig
+++ b/samples/Kconfig
@@ -184,10 +184,12 @@ config SAMPLE_TIMER
 	bool "Timer sample"
 	depends on CC_CAN_LINK && HEADERS_INSTALL
 
 config SAMPLE_TSM_MR
 	tristate "TSM measurement sample"
+	select CRYPTO_LIB_SHA256
+	select CRYPTO_LIB_SHA512
 	select TSM_MEASUREMENTS
 	select VIRT_DRIVERS
 	help
 	  Build a sample module that emulates MRs (Measurement Registers) and
 	  exposes them to user mode applications through the TSM sysfs
diff --git a/samples/tsm-mr/tsm_mr_sample.c b/samples/tsm-mr/tsm_mr_sample.c
index a2c652148639..c79dbc1e0456 100644
--- a/samples/tsm-mr/tsm_mr_sample.c
+++ b/samples/tsm-mr/tsm_mr_sample.c
@@ -4,11 +4,11 @@
 #define pr_fmt(x) KBUILD_MODNAME ": " x
 
 #include <linux/module.h>
 #include <linux/tsm-mr.h>
 #include <linux/miscdevice.h>
-#include <crypto/hash.h>
+#include <crypto/sha2.h>
 
 static struct {
 	u8 static_mr[SHA384_DIGEST_SIZE];
 	u8 config_mr[SHA512_DIGEST_SIZE];
 	u8 rtmr0[SHA256_DIGEST_SIZE];
@@ -21,51 +21,49 @@ static struct {
 	.rtmr1 = "rtmr1",
 };
 
 static int sample_report_refresh(const struct tsm_measurements *tm)
 {
-	struct crypto_shash *tfm;
-	int rc;
-
-	tfm = crypto_alloc_shash(hash_algo_name[HASH_ALGO_SHA512], 0, 0);
-	if (IS_ERR(tfm)) {
-		pr_err("crypto_alloc_shash failed: %ld\n", PTR_ERR(tfm));
-		return PTR_ERR(tfm);
-	}
-
-	rc = crypto_shash_tfm_digest(tfm, (u8 *)&sample_report,
-				     offsetof(typeof(sample_report),
-					      report_digest),
-				     sample_report.report_digest);
-	crypto_free_shash(tfm);
-	if (rc)
-		pr_err("crypto_shash_tfm_digest failed: %d\n", rc);
-	return rc;
+	sha512((const u8 *)&sample_report,
+	       offsetof(typeof(sample_report), report_digest),
+	       sample_report.report_digest);
+	return 0;
 }
 
 static int sample_report_extend_mr(const struct tsm_measurements *tm,
 				   const struct tsm_measurement_register *mr,
 				   const u8 *data)
 {
-	SHASH_DESC_ON_STACK(desc, 0);
-	int rc;
-
-	desc->tfm = crypto_alloc_shash(hash_algo_name[mr->mr_hash], 0, 0);
-	if (IS_ERR(desc->tfm)) {
-		pr_err("crypto_alloc_shash failed: %ld\n", PTR_ERR(desc->tfm));
-		return PTR_ERR(desc->tfm);
+	union {
+		struct sha256_ctx sha256;
+		struct sha384_ctx sha384;
+		struct sha512_ctx sha512;
+	} ctx;
+
+	switch (mr->mr_hash) {
+	case HASH_ALGO_SHA256:
+		sha256_init(&ctx.sha256);
+		sha256_update(&ctx.sha256, mr->mr_value, mr->mr_size);
+		sha256_update(&ctx.sha256, data, mr->mr_size);
+		sha256_final(&ctx.sha256, mr->mr_value);
+		return 0;
+	case HASH_ALGO_SHA384:
+		sha384_init(&ctx.sha384);
+		sha384_update(&ctx.sha384, mr->mr_value, mr->mr_size);
+		sha384_update(&ctx.sha384, data, mr->mr_size);
+		sha384_final(&ctx.sha384, mr->mr_value);
+		return 0;
+	case HASH_ALGO_SHA512:
+		sha512_init(&ctx.sha512);
+		sha512_update(&ctx.sha512, mr->mr_value, mr->mr_size);
+		sha512_update(&ctx.sha512, data, mr->mr_size);
+		sha512_final(&ctx.sha512, mr->mr_value);
+		return 0;
+	default:
+		pr_err("Unsupported hash algorithm: %d\n", mr->mr_hash);
+		return -EOPNOTSUPP;
 	}
-
-	rc = crypto_shash_init(desc);
-	if (!rc)
-		rc = crypto_shash_update(desc, mr->mr_value, mr->mr_size);
-	if (!rc)
-		rc = crypto_shash_finup(desc, data, mr->mr_size, mr->mr_value);
-	crypto_free_shash(desc->tfm);
-	if (rc)
-		pr_err("SHA calculation failed: %d\n", rc);
-	return rc;
 }
 
 #define MR_(mr, hash) .mr_value = &sample_report.mr, TSM_MR_(mr, hash)
 static const struct tsm_measurement_register sample_mrs[] = {
 	/* static MR, read-only */
-- 
2.53.0

