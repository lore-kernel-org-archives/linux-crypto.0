Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48A9F3271FD
	for <linux-crypto@vger.kernel.org>; Mon, 30 Mar 2026 14:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774882005; cv=none; b=CiPjyXpFRI29SHd3HSUmhVlCk+nUThvsrJ7UfGJRjhK5biGeFTko6J6xcnS8ojIJ4Fec7F4aZdurKVv5q2axmHO+Tggec90MFAfhFHLpmeZSzoOwwBfGplIBXQ2quyBOIezokq47VqlLT3NWXV8vpWgs5DdAbSgo6j2ZNGso2IQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774882005; c=relaxed/simple;
	bh=fAIBhC+LS5rsHZRLsEihWNrSlr1ZuUtu4ZmF07BHqog=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z+MePPfBEZnk0sb+7BfpMAlWKi/GFPnCuDYh2MfIvNbaumtYKUEv3Qrqlym0xGCANj/Xsy7fvgSOWFu/cKXyzHMIoDBA0NVjgawdAiVh5eUNbnOV1UiHdK+654etB2wIJSdRB6leNmA3xfBfTRKmPY+WsaIMr36zAXSOCU+3HsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NSwxlE1d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NSwxlE1d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DD61C19423;
	Mon, 30 Mar 2026 14:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774882005;
	bh=fAIBhC+LS5rsHZRLsEihWNrSlr1ZuUtu4ZmF07BHqog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NSwxlE1di3ozYoRomiji1GzZVuvPUlLR6iuQFkbfdRuRdfbZibnuNXm734/cII0Wg
	 9nOOxf7oSgUSiPQrqFjmsrqY72mxneS3Z5OP0Y8OPfppeJBrGNX+he/TvMxabWEKFg
	 VRVbKaTX0uQ+lE3os6fFA9A3HP2wEJG72SVdudX5fogoQGgr0krvQJsa681tX+LhgM
	 UkCW/GlgKZTPJwUbhbuH53wKXEa0jXhvbLEm03w404fuBhhkL+jaZU/wlPRC46Gr0N
	 t05GanApVtlUXBC1MlpYJWxryIljY9T6O+MHy37Jay8uuchWttilfOZNtRwrCKaj+2
	 NVfHIziIZ4mJw==
From: Ard Biesheuvel <ardb@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Demian Shulhan <demyansh@gmail.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 2/5] lib/crc: arm64: Use existing macros for kernel-mode FPU cflags
Date: Mon, 30 Mar 2026 16:46:33 +0200
Message-ID: <20260330144630.33026-9-ardb@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260330144630.33026-7-ardb@kernel.org>
References: <20260330144630.33026-7-ardb@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1145; i=ardb@kernel.org; h=from:subject; bh=fAIBhC+LS5rsHZRLsEihWNrSlr1ZuUtu4ZmF07BHqog=; b=owGbwMvMwCn83sBh/rljoYmMp9WSGDJP9Ry/GXTvwAzbr+9l9S1qeJObxU/mKLG2LUp+/un3w mWmW5KMOqayMAhzMsiKKbLsVM7pfu0i+k5foTIHZg4rE8gQBi5OAZjIfnnGhtuqlZ+fZ76PDPg/ MZ7zhcmFjmsfLtv/+zJfL4vXKF3wt8pEuWrt0FsrE7VF9ixbmfZEjrHORkp3q+b7qxHKW19+nBz BUW/nrHTh9hFhruCkW59X8n4I2RmmfTAuXS7s9CnN23dm7owAAA==
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit

Use the existing CC_FPU_CFLAGS and CC_NO_FPU_CFLAGS to pass the
appropriate compiler command line options for building kernel mode NEON
intrinsics code. This is tidier, and will make it easier to reuse the
code for 32-bit ARM.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 lib/crc/Makefile | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/lib/crc/Makefile b/lib/crc/Makefile
index c9c35419b39c..ff213590e4e3 100644
--- a/lib/crc/Makefile
+++ b/lib/crc/Makefile
@@ -39,9 +39,8 @@ crc64-y := crc64-main.o
 ifeq ($(CONFIG_CRC64_ARCH),y)
 CFLAGS_crc64-main.o += -I$(src)/$(SRCARCH)
 
-CFLAGS_REMOVE_arm64/crc64-neon-inner.o += -mgeneral-regs-only
-CFLAGS_arm64/crc64-neon-inner.o += -ffreestanding -march=armv8-a+crypto
-CFLAGS_arm64/crc64-neon-inner.o += -isystem $(shell $(CC) -print-file-name=include)
+CFLAGS_REMOVE_arm64/crc64-neon-inner.o += $(CC_FLAGS_NO_FPU)
+CFLAGS_arm64/crc64-neon-inner.o += $(CC_FLAGS_FPU) -march=armv8-a+crypto
 crc64-$(CONFIG_ARM64) += arm64/crc64-neon-inner.o
 
 crc64-$(CONFIG_RISCV) += riscv/crc64_lsb.o riscv/crc64_msb.o
-- 
2.53.0.1018.g2bb0e51243-goog

