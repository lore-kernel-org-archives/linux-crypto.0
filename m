Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ABBB241103;
	Sat,  8 Feb 2025 17:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739037466; cv=none; b=Rfqs4rm5EAp1HltnXGsw2d5Frc6gIsot4QXb/a72ezSlKJN2asbSaeo+cLajgQCDDwMoBYNHJIF3TYDsLnip0gOGcLOJwxcrmyqAnp1vdjMflZvXsvOkFXrX856Q/dleY3oCyyqpN/XX+XPiXztGwI+zW54IzjnKtqUPX+rkEPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739037466; c=relaxed/simple;
	bh=70Mvfj82x300QBQsD/fuLlfvYaB0Uhdq4+iLuCws1w4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kwr+Hh+JX5h91mk5HuzCR/+0cG+V4hImoJgq1TU2N2gYR8U9bf6ohlbL+VqUs80IDnM07IycMcVDcwQayjDqxIqE1mdxdiP87rHdRIDxzgW8cTsmODubtd46UKqq36dZdPNcUG6wi4lPncjU8rOFUa8Cx9soJgRmF+WGLTiO8pQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XsAySnkt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XsAySnkt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9A25C4CED6;
	Sat,  8 Feb 2025 17:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739037466;
	bh=70Mvfj82x300QBQsD/fuLlfvYaB0Uhdq4+iLuCws1w4=;
	h=From:To:Cc:Subject:Date:From;
	b=XsAySnkt6jiCdDY0mMY0tmVgO2dndP2nU5YVQkyJA6y31m6mlCGYwUbzxLTO7PPy1
	 4+JUSz/iPKAdf+PhRde2hzhHZ8k4nXFIapgUgvkne1AlbauPOcrf817gaGIPnT1mwW
	 fF8qmOiz2Xcp/42xq/2nCDPDH+XJ49o8FxracBSN1ft1VdxMqH+4uazvbKOfE6EpZy
	 fEq39l6/KfKeVgIYjDDYJFGd7xi9QM7bD0+nAc+pCfvIcOlUH9RMMtJEDbqZG25MHC
	 4R8GGwllEKPMOi1NR1xBNnJaCPJP2vF+3Ks/ZbtaXU51XQ2rTfuNpccUcaHiDfBGbd
	 6V/g6+8WTdS3Q==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Zhihang Shao <zhihang.shao.iscas@gmail.com>
Subject: [PATCH] lib/crc-t10dif: remove crc_t10dif_is_optimized()
Date: Sat,  8 Feb 2025 09:56:47 -0800
Message-ID: <20250208175647.12333-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

With the "crct10dif" algorithm having been removed from the crypto API,
crc_t10dif_is_optimized() is no longer used.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---

This applies to
https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=crc-next

 arch/arm/lib/crc-t10dif-glue.c     | 6 ------
 arch/arm64/lib/crc-t10dif-glue.c   | 6 ------
 arch/powerpc/lib/crc-t10dif-glue.c | 6 ------
 arch/x86/lib/crc-t10dif-glue.c     | 6 ------
 include/linux/crc-t10dif.h         | 9 ---------
 5 files changed, 33 deletions(-)

diff --git a/arch/arm/lib/crc-t10dif-glue.c b/arch/arm/lib/crc-t10dif-glue.c
index d24dee62670e..f3584ba70e57 100644
--- a/arch/arm/lib/crc-t10dif-glue.c
+++ b/arch/arm/lib/crc-t10dif-glue.c
@@ -67,14 +67,8 @@ arch_initcall(crc_t10dif_arm_init);
 static void __exit crc_t10dif_arm_exit(void)
 {
 }
 module_exit(crc_t10dif_arm_exit);
 
-bool crc_t10dif_is_optimized(void)
-{
-	return static_key_enabled(&have_neon);
-}
-EXPORT_SYMBOL(crc_t10dif_is_optimized);
-
 MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
 MODULE_DESCRIPTION("Accelerated CRC-T10DIF using ARM NEON and Crypto Extensions");
 MODULE_LICENSE("GPL v2");
diff --git a/arch/arm64/lib/crc-t10dif-glue.c b/arch/arm64/lib/crc-t10dif-glue.c
index dab7e3796232..a007d0c5f3fe 100644
--- a/arch/arm64/lib/crc-t10dif-glue.c
+++ b/arch/arm64/lib/crc-t10dif-glue.c
@@ -68,14 +68,8 @@ arch_initcall(crc_t10dif_arm64_init);
 static void __exit crc_t10dif_arm64_exit(void)
 {
 }
 module_exit(crc_t10dif_arm64_exit);
 
-bool crc_t10dif_is_optimized(void)
-{
-	return static_key_enabled(&have_asimd);
-}
-EXPORT_SYMBOL(crc_t10dif_is_optimized);
-
 MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
 MODULE_DESCRIPTION("CRC-T10DIF using arm64 NEON and Crypto Extensions");
 MODULE_LICENSE("GPL v2");
diff --git a/arch/powerpc/lib/crc-t10dif-glue.c b/arch/powerpc/lib/crc-t10dif-glue.c
index 730850dbc51d..f411b0120cc5 100644
--- a/arch/powerpc/lib/crc-t10dif-glue.c
+++ b/arch/powerpc/lib/crc-t10dif-glue.c
@@ -76,14 +76,8 @@ arch_initcall(crc_t10dif_powerpc_init);
 static void __exit crc_t10dif_powerpc_exit(void)
 {
 }
 module_exit(crc_t10dif_powerpc_exit);
 
-bool crc_t10dif_is_optimized(void)
-{
-	return static_key_enabled(&have_vec_crypto);
-}
-EXPORT_SYMBOL(crc_t10dif_is_optimized);
-
 MODULE_AUTHOR("Daniel Axtens <dja@axtens.net>");
 MODULE_DESCRIPTION("CRCT10DIF using vector polynomial multiply-sum instructions");
 MODULE_LICENSE("GPL");
diff --git a/arch/x86/lib/crc-t10dif-glue.c b/arch/x86/lib/crc-t10dif-glue.c
index 13f07ddc9122..7734bdbc2e39 100644
--- a/arch/x86/lib/crc-t10dif-glue.c
+++ b/arch/x86/lib/crc-t10dif-glue.c
@@ -39,13 +39,7 @@ arch_initcall(crc_t10dif_x86_init);
 static void __exit crc_t10dif_x86_exit(void)
 {
 }
 module_exit(crc_t10dif_x86_exit);
 
-bool crc_t10dif_is_optimized(void)
-{
-	return static_key_enabled(&have_pclmulqdq);
-}
-EXPORT_SYMBOL(crc_t10dif_is_optimized);
-
 MODULE_DESCRIPTION("CRC-T10DIF using PCLMULQDQ instructions");
 MODULE_LICENSE("GPL");
diff --git a/include/linux/crc-t10dif.h b/include/linux/crc-t10dif.h
index d0706544fc11..a559fdff3f7e 100644
--- a/include/linux/crc-t10dif.h
+++ b/include/linux/crc-t10dif.h
@@ -17,15 +17,6 @@ static inline u16 crc_t10dif_update(u16 crc, const u8 *p, size_t len)
 static inline u16 crc_t10dif(const u8 *p, size_t len)
 {
 	return crc_t10dif_update(0, p, len);
 }
 
-#if IS_ENABLED(CONFIG_CRC_T10DIF_ARCH)
-bool crc_t10dif_is_optimized(void);
-#else
-static inline bool crc_t10dif_is_optimized(void)
-{
-	return false;
-}
-#endif
-
 #endif

base-commit: 3dceb9c4f1202d2c374976936ef803bf4b076fa7
-- 
2.48.1

