Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CCC1433A4
	for <linux-crypto@vger.kernel.org>; Wed,  7 May 2025 17:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746637768; cv=none; b=pvdhnOqOrDgwCx2lNb2uGeElDJSrgiXB1dAjNv8Ea0ow5HILpvjnlMGOx87Mv0HsYaclDM9KnZ8Gd+fXHC+VT2Aw2y2oLp7hT4QgiXqfJ6YYJmUdWdAg7Br4pWYtViNZ6LU4yQr4sA/ou4ZAUEUgvuNHf3jIRs8Q+ixn1d8FSl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746637768; c=relaxed/simple;
	bh=LKN9UrZmkZDWKM6V8K9YPnMN6DJF323WVpBAQbD5AK8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dyUZ3F1lkGs/BrcgMzaPrAcaMZ5Y67fIPMXkOK9WVUfE0eygCCCrG8aNgd5adpgCf8Uj/uNFkyrfodjl6snSqYzKX+E6OrwDu+hqhv4V1TyACqLq5T0nUqmT9sd3hIMmgBGq/ewmaGu0TJ/nvTp18f+OblS1iwMA5yyn6Fvjsp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mNHSRgAH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mNHSRgAH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 689C9C4CEE9;
	Wed,  7 May 2025 17:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746637767;
	bh=LKN9UrZmkZDWKM6V8K9YPnMN6DJF323WVpBAQbD5AK8=;
	h=From:To:Cc:Subject:Date:From;
	b=mNHSRgAHSslqnTQD/UlvWhDv6WRD6vsEYR8EBO1DuzOZyzQKIEPYTNw+LIxWj7x67
	 Ld7tYgEk54SKHQGmrUWl96y5V9xwnLmHM3BJDUgEcl1cHiecC8fqlXb2PHQ3V8nWDm
	 c8MSRqKBQXpaNApyqgpmeGzsIj4/HuaY9aOVqA7/rvaYE7C+wfl+ug8My0Rc6osmkD
	 VV/3HY5LzTJvxVxX9D8wKrdXSHLnJxmQrAQzWGZPTMAgcHO8zK8gbBmHqCMM55ZTzq
	 LBGjhxLqdiuC/0sUcDSr2IPdwVRkCKBmvq2LWEXtaDWWS7/DwaM4m0rWkrn4GV+HcX
	 JFTlDXnzx2fXQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Thorsten Leemhuis <linux@leemhuis.info>,
	kernel test robot <lkp@intel.com>
Subject: [PATCH] crypto: arm64/sha256 - fix build when CONFIG_PREEMPT_VOLUNTARY=y
Date: Wed,  7 May 2025 10:09:01 -0700
Message-ID: <20250507170901.151548-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Fix the build of sha256-ce.S when CONFIG_PREEMPT_VOLUNTARY=y by passing
the correct label to the cond_yield macro.  Also adjust the code to
execute only one branch instruction when CONFIG_PREEMPT_VOLUNTARY=n.

Fixes: 6e36be511d28 ("crypto: arm64/sha256 - implement library instead of shash")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202505071811.yYpLUbav-lkp@intel.com/
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/arm64/lib/crypto/sha256-ce.S | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/lib/crypto/sha256-ce.S b/arch/arm64/lib/crypto/sha256-ce.S
index a8461d6dad634..f3e21c6d87d2e 100644
--- a/arch/arm64/lib/crypto/sha256-ce.S
+++ b/arch/arm64/lib/crypto/sha256-ce.S
@@ -121,14 +121,15 @@ CPU_LE(	rev32		v19.16b, v19.16b	)
 
 	/* update state */
 	add		dgav.4s, dgav.4s, dg0v.4s
 	add		dgbv.4s, dgbv.4s, dg1v.4s
 
+	/* return early if voluntary preemption is needed */
+	cond_yield	1f, x5, x6
+
 	/* handled all input blocks? */
-	cbz		x2, 1f
-	cond_yield	3f, x5, x6
-	b		0b
+	cbnz		x2, 0b
 
 	/* store new state */
 1:	st1		{dgav.4s, dgbv.4s}, [x0]
 	mov		x0, x2
 	ret

base-commit: 20e9579f11b6cbdf0556d9cd85a0aa7653caf341
-- 
2.49.0

