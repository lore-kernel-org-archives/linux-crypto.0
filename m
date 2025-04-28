Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9CE94CE08;
	Mon, 28 Apr 2025 18:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745865077; cv=none; b=Mmkuvqal2vHpFfc9Y7DVSH2kam8Kt4dbOlgCZGdB1V9FFQrqOYLpDrLzzfjWpB9v+v9x7WN4tno8zyGZECCahEBOCE35k0bxkqbaYs52RgXfc0bsI3gCtL6gJ9xRWT7K1//zzb4m4nmOwTOOgKfFJ472NxR7hotmuF2VgM3oCpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745865077; c=relaxed/simple;
	bh=u/UEZ2LwoTe0u9ORsoPmYNUt+dowE6a64WYG1PeQFbE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Q552ukYqrH2a2wLGTQcvRoQ7v5dFBFt38pW+cqXPkq2zm7QTS9X6jjxu0Jn6em3amA7hAsDmiWnuN2e2UgkXB+kILeBy3xCNTc83MXvDA0vdT81hpefV+hW4jwQ0t39vGiB0HBUDL9tiBrMinuyAA4AgFnORooNTXOpgM1qKzks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Cc+mBvSU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Cc+mBvSU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DB59C4CEF0;
	Mon, 28 Apr 2025 18:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745865076;
	bh=u/UEZ2LwoTe0u9ORsoPmYNUt+dowE6a64WYG1PeQFbE=;
	h=From:To:Cc:Subject:Date:From;
	b=Cc+mBvSUUZe+z9eDqVN+ZtvZI6oNlF1nhdRuSvRvCY3AyK0A0tFfLsrffwsYiuu3R
	 npMBys7Nm1A3TpenPLIkMhAGjNbXs3HKkxOgSE0rMuUkjG1Ud7DSFB866eesYESWzk
	 WlbJNx0z+uFN4vfxfG6ahTJY1dytoI7bRIeXcsckyllRI1Z2NTCdiRaDKbkum3Bnaf
	 nC9WanMzdWDufv++bU1bFtn+wIf1+1JvqUW5jzORoOVPl5GToxZsa90m+ac/YdOce6
	 8c/sHqyEI5P4koYYy6YSLEO2hN/MwSJUni2a6+FB35bisun2FeVh8tejsTjXZ0xNgv
	 2GLWv1qMRISzw==
From: Eric Biggers <ebiggers@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	Borislav Petkov <bp@alien8.de>
Subject: [PATCH] x86/microcode/AMD: Use sha256() instead of init/update/final
Date: Mon, 28 Apr 2025 11:30:06 -0700
Message-ID: <20250428183006.782501-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Just call sha256() instead of doing the init/update/final sequence.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---

This patch is targeting the x86 tree.

 arch/x86/kernel/cpu/microcode/amd.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/microcode/amd.c b/arch/x86/kernel/cpu/microcode/amd.c
index 1798a6c027f89..f1fae6e282215 100644
--- a/arch/x86/kernel/cpu/microcode/amd.c
+++ b/arch/x86/kernel/cpu/microcode/amd.c
@@ -215,11 +215,10 @@ static bool need_sha_check(u32 cur_rev)
 
 static bool verify_sha256_digest(u32 patch_id, u32 cur_rev, const u8 *data, unsigned int len)
 {
 	struct patch_digest *pd = NULL;
 	u8 digest[SHA256_DIGEST_SIZE];
-	struct sha256_state s;
 	int i;
 
 	if (x86_family(bsp_cpuid_1_eax) < 0x17)
 		return true;
 
@@ -233,13 +232,11 @@ static bool verify_sha256_digest(u32 patch_id, u32 cur_rev, const u8 *data, unsi
 	if (!pd) {
 		pr_err("No sha256 digest for patch ID: 0x%x found\n", patch_id);
 		return false;
 	}
 
-	sha256_init(&s);
-	sha256_update(&s, data, len);
-	sha256_final(&s, digest);
+	sha256(data, len, digest);
 
 	if (memcmp(digest, pd->sha256, sizeof(digest))) {
 		pr_err("Patch 0x%x SHA256 digest mismatch!\n", patch_id);
 
 		for (i = 0; i < SHA256_DIGEST_SIZE; i++)

base-commit: 33035b665157558254b3c21c3f049fd728e72368
-- 
2.49.0

