Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1053C202C42;
	Wed, 16 Apr 2025 17:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744823720; cv=none; b=ITRnwPoyQdFo3lHx4Int74Z99qZUWoyik6YX1XsoM5a8UzUHpssuiA3P8dnKpa5NdtrPkeEhT6Tdl7K1cg/ydpn2lWxTPTgMKUmFcqTJm9NgNyXKRceDuvd4G0P/qPegq40E+Ald10KW4T2tPaMbs3UDEHRNmF2AVjOch9fML0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744823720; c=relaxed/simple;
	bh=PtS50I1JEx78saTBfrIr2/aVCZOH4dhGGysijRowgC0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NsmV80yDRMp+S41O9NLwPwV14RHKD4tegtDpG1fqhojav37K5pC2FGxwp9mNXLoWMvrlf34I3g8fwNXeAzpbuyu5yKz6rnwknjh40jbfHloMad6IdefdyWpu3mgeVntx66ipMli5H9nrp+8ZsehrkpQk/cNm/P+mc4Lsr5sTJEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n2e8LiJd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n2e8LiJd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31A4AC4CEE2;
	Wed, 16 Apr 2025 17:15:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744823719;
	bh=PtS50I1JEx78saTBfrIr2/aVCZOH4dhGGysijRowgC0=;
	h=From:To:Cc:Subject:Date:From;
	b=n2e8LiJdxP35mPYrF33YC5NWI2GA+R0A0NF6IRn0hMETQmeIcY5FFKS3l3Pix3PdO
	 69prvrhfe8abkQ1K2+OlkHPXSW1Fr0fwi7gbZ4s8RXkD3Tz8ldD7QJv/C5tov6JQhN
	 jxXo8hrW5kUdv1jmXLqu4GZ1guwGgx2cxoEFgyoIoGJp0PvhkIKBwRPWV08D5Nm1Ag
	 1hzez+mN7o/2o/9XMYNztpaox4toV76lfYFvc3ppOnJpSU99ucndmkn6fL5Sz1FwVN
	 nLeNWyIzxMc//AEA+yU8Go2QDi8bttOejLpDK0/07/eKo+9rSotdY6cNIoBe0fauhi
	 DRAYJ4ru+k83Q==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH] powerpc/crc: include <linux/uaccess.h>
Date: Wed, 16 Apr 2025 10:14:39 -0700
Message-ID: <20250416171439.226938-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Since <asm/simd.h> no longer transitively includes <linux/uaccess.h>
which provides pagefault_disable() and pagefault_enable(),
<linux/uaccess.h> now needs to be included directly.

Fixes: 7ba8df47810f ("asm-generic: Make simd.h more resilient")
Signed-off-by: Eric Biggers <ebiggers@google.com>
---

I can take this via the crc tree, but it really should go via crypto
since the patch that broke this is in there...

 arch/powerpc/lib/crc-t10dif-glue.c | 1 +
 arch/powerpc/lib/crc32-glue.c      | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/powerpc/lib/crc-t10dif-glue.c b/arch/powerpc/lib/crc-t10dif-glue.c
index ddd5c4088f50..c48284f7b582 100644
--- a/arch/powerpc/lib/crc-t10dif-glue.c
+++ b/arch/powerpc/lib/crc-t10dif-glue.c
@@ -11,10 +11,11 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/string.h>
 #include <linux/kernel.h>
 #include <linux/cpufeature.h>
+#include <linux/uaccess.h>
 #include <asm/simd.h>
 #include <asm/switch_to.h>
 
 #define VMX_ALIGN		16
 #define VMX_ALIGN_MASK		(VMX_ALIGN-1)
diff --git a/arch/powerpc/lib/crc32-glue.c b/arch/powerpc/lib/crc32-glue.c
index 42f2dd3c85dd..d7f57576c74e 100644
--- a/arch/powerpc/lib/crc32-glue.c
+++ b/arch/powerpc/lib/crc32-glue.c
@@ -3,10 +3,11 @@
 #include <crypto/internal/simd.h>
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/cpufeature.h>
+#include <linux/uaccess.h>
 #include <asm/simd.h>
 #include <asm/switch_to.h>
 
 #define VMX_ALIGN		16
 #define VMX_ALIGN_MASK		(VMX_ALIGN-1)

base-commit: 5f7325fbb3d416ba66f163a9272e17d70f1d9bf4
-- 
2.49.0

