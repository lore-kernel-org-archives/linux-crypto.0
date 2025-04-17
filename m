Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89BB03C0C;
	Thu, 17 Apr 2025 16:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744907941; cv=none; b=U1BIBXQ6ORjNi/hbIscetReScLy0uf0bZd2UkTobIRw1GVfSMB1nDBRzkbefSC16di9zPH5Ppyh5/SBcptvulDhEk0vdkbck8Bp7epKnqi/CtV8eF/BxtygyqGcmi81fA2Y/GDBMVKG+NcEdqxxR+UHf+LZXyNITcJhMBO+CqIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744907941; c=relaxed/simple;
	bh=a09kTRXyeb+tIE08IjODC9KUoIDIkWigBgRcwJ0P5uY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rLW3EuT3NWdexoObxDWA5vYLqN3qW9x+7Vonoby8XuxQXmoQ/DXVePmEhw32ZnCk8O84yb5uoalU+bjLmnsGnV4fZaNYA8wq2tJ5MntcF4YecROukZm2Q70Y+/hUSlJjuo9nCRbdIXrv4aLbZ+DYKUiEWAc2NFntyisrCyKhxAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iWbWcZdy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iWbWcZdy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3751C4CEE4;
	Thu, 17 Apr 2025 16:39:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744907941;
	bh=a09kTRXyeb+tIE08IjODC9KUoIDIkWigBgRcwJ0P5uY=;
	h=From:To:Cc:Subject:Date:From;
	b=iWbWcZdy6eEF7eNIpwCwxm+i22ZZ+S5M362wIfimQc3O+UXJQAD4N2LgKIoMUb6oC
	 BfQYscAmTU5gU+TsFnME2DDguir7oSn/qKPArC+6KXGbUhBFEhHHfBMiYrchNDRwae
	 wlQRS2BhsPqLOFFTHpcN3SpSl062cLQ6zxavtiPcbCgx8pem1lpro+jDYpZt0CGNdL
	 L1N2Kg1mmtm1CoEHYa0zKKGCJ7rZ1ek2uHkf5I6KnVnAWHzTJciuN7vfBfTZfhh9qV
	 0gh7fJG+kXyA9gQjTQXzgG1cvQaLVVhWg8Uh43ln+cT/PpKaItWzMnA0jPCk7VXApR
	 lHTxEjp0y9K6w==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-s390@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH] s390/crc32: Remove no-op module init and exit functions
Date: Thu, 17 Apr 2025 09:38:29 -0700
Message-ID: <20250417163829.4599-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Now that the crc32-s390 module init function is a no-op, there is no
need to define it.  Remove it.  The removal of the init function also
makes the exit function unnecessary, so remove that too.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---

I'll take this via the crc tree.

 arch/s390/lib/crc32-glue.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/arch/s390/lib/crc32-glue.c b/arch/s390/lib/crc32-glue.c
index 649ed7e8b99c..3c4b344417c1 100644
--- a/arch/s390/lib/crc32-glue.c
+++ b/arch/s390/lib/crc32-glue.c
@@ -59,21 +59,10 @@
 
 DEFINE_CRC32_VX(crc32_le_arch, crc32_le_vgfm_16, crc32_le_base)
 DEFINE_CRC32_VX(crc32_be_arch, crc32_be_vgfm_16, crc32_be_base)
 DEFINE_CRC32_VX(crc32c_arch, crc32c_le_vgfm_16, crc32c_base)
 
-static int __init crc32_s390_init(void)
-{
-	return 0;
-}
-arch_initcall(crc32_s390_init);
-
-static void __exit crc32_s390_exit(void)
-{
-}
-module_exit(crc32_s390_exit);
-
 u32 crc32_optimizations(void)
 {
 	if (cpu_has_vx()) {
 		return CRC32_LE_OPTIMIZATION |
 		       CRC32_BE_OPTIMIZATION |

base-commit: 34a3ebfb22d694cc07addae5ce0a8f83139592bd
-- 
2.49.0

