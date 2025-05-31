Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A79B210E4;
	Sat, 31 May 2025 21:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748725239; cv=none; b=uhNOxN54D+CzLRD2ycQIwbFBfEybFTrQ3teDI1cLPR0mzUCZBKfpAHDCX0c8ZT2Aqva4IFBD3eMawoGo6/W14EQY2HqrGcSnsYQPELS9YCL0Z5nekbfDzNqf8VuOx1J/j6NHxf0p6rzG9OqxDu9JI8kgcmN8KibAWTxVTia43lQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748725239; c=relaxed/simple;
	bh=0AtzGeGU5tvavJEPBxWpExOFRe9wmzzbQRgq6JLo1II=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CraX3h7CzHFvDu8J9bQSkJHUIMcRL+T/Y++FKeK7S/09lgd+IHlrioWww2tkDeKWgmuyNjsndNkVyUeMh2e+7DaOLBU7WAzZyii97unTLQJzN+MFxnWJJJgwtQm6THUja/N/i5Vz9LzYaUxmL6Nfvs/wGuQpxuj1c7J9ULN/a/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=afG6uBbN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="afG6uBbN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0280CC4CEE3;
	Sat, 31 May 2025 21:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748725239;
	bh=0AtzGeGU5tvavJEPBxWpExOFRe9wmzzbQRgq6JLo1II=;
	h=From:To:Cc:Subject:Date:From;
	b=afG6uBbNcdBTK92l8ge/3X2iwharYVp+9DWjtGKth7yGYx++9U1iYMDLgBt0yx5ab
	 R3ZrEMBWNowya2tjiN4jG6IlkkR8esOGWG13joGmIG0ftGhCd5z2wlF1ozNhKAzfq/
	 zlzux/z2OqMAkT6irq01TMhmKCBslw9uiXsgpoRQ/NGoPApA2+M+lhe18+tJFhruh8
	 +6OzKrjuMQVj2Dv507dVKFUZedvBJgKLyMugEuhlk4h32dDXgw7zaHng6rE+Gdv82O
	 nRhFAcvn7ixAv3y5XEor3njCX/g1RkaPd97tJ2JNAiRtGSKAGLB9vEyDz1tof7RMRn
	 G0qtah8mgNHqw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH] crypto: testmgr - remove crc32c context format test
Date: Sat, 31 May 2025 13:59:37 -0700
Message-ID: <20250531205937.63008-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

This is no longer needed now that the code that used to directly access
the descriptor context of "crc32c" (libcrc32c and ext4) now just calls
crc32c().  Keep just the generic hash test.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---

I'm planning to take this via the crc tree.

 crypto/testmgr.c | 55 +-----------------------------------------------
 1 file changed, 1 insertion(+), 54 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 72005074a5c26..54a93e071446e 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -3539,63 +3539,10 @@ static int alg_test_comp(const struct alg_test_desc *desc, const char *driver,
 			 desc->suite.comp.decomp.count);
 	crypto_free_acomp(acomp);
 	return err;
 }
 
-static int alg_test_crc32c(const struct alg_test_desc *desc,
-			   const char *driver, u32 type, u32 mask)
-{
-	struct crypto_shash *tfm;
-	__le32 val;
-	int err;
-
-	err = alg_test_hash(desc, driver, type, mask);
-	if (err)
-		return err;
-
-	tfm = crypto_alloc_shash(driver, type, mask);
-	if (IS_ERR(tfm)) {
-		if (PTR_ERR(tfm) == -ENOENT) {
-			/*
-			 * This crc32c implementation is only available through
-			 * ahash API, not the shash API, so the remaining part
-			 * of the test is not applicable to it.
-			 */
-			return 0;
-		}
-		printk(KERN_ERR "alg: crc32c: Failed to load transform for %s: "
-		       "%ld\n", driver, PTR_ERR(tfm));
-		return PTR_ERR(tfm);
-	}
-	driver = crypto_shash_driver_name(tfm);
-
-	do {
-		SHASH_DESC_ON_STACK(shash, tfm);
-		u32 *ctx = (u32 *)shash_desc_ctx(shash);
-
-		shash->tfm = tfm;
-
-		*ctx = 420553207;
-		err = crypto_shash_final(shash, (u8 *)&val);
-		if (err) {
-			printk(KERN_ERR "alg: crc32c: Operation failed for "
-			       "%s: %d\n", driver, err);
-			break;
-		}
-
-		if (val != cpu_to_le32(~420553207)) {
-			pr_err("alg: crc32c: Test failed for %s: %u\n",
-			       driver, le32_to_cpu(val));
-			err = -EINVAL;
-		}
-	} while (0);
-
-	crypto_free_shash(tfm);
-
-	return err;
-}
-
 static int alg_test_cprng(const struct alg_test_desc *desc, const char *driver,
 			  u32 type, u32 mask)
 {
 	struct crypto_rng *rng;
 	int err;
@@ -4551,11 +4498,11 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.suite = {
 			.hash = __VECS(crc32_tv_template)
 		}
 	}, {
 		.alg = "crc32c",
-		.test = alg_test_crc32c,
+		.test = alg_test_hash,
 		.fips_allowed = 1,
 		.suite = {
 			.hash = __VECS(crc32c_tv_template)
 		}
 	}, {

base-commit: 4cb6c8af8591135ec000fbe4bb474139ceec595d
-- 
2.49.0

