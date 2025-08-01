Received: from mail-m93179.xmail.ntesmail.com (mail-m93179.xmail.ntesmail.com [103.126.93.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EB6A3398A;
	Fri,  1 Aug 2025 01:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.126.93.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754013481; cv=none; b=YgctYZTRgy3608eJBclwQs23mVTuMDl+4H1Cg9e9BAsP04cNf6LXFla/F6U5C9ldIr5slH2GfJtq4LNdcheXVFkqszHJOlPqmFqUrzN59c0cClDTeRfMGRn/zqtPWjRm1L/gOsY4z+mtI0EPcU5nHsechxQGqNy4lbzwCxP7m9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754013481; c=relaxed/simple;
	bh=UgPYaQwlWJc9Zen37DK75P/yQXewXknsnjFDmjKxJWM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RxiGIy/A72FkKpbxhnQLRGsyKiczX4/1EmCspOy7z0NFVOtc7SIWjbeYzs3/4j9Li9rli01C/ByUpUXdIeie96cbGS4OWOMgDE7sszmaZtI7UM2dJQf5HR/nnKyyl8Z+suEiKoKJ8VDJwwpbS9OjdNaNyGGuz21/9Pf2hJpMgUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ustc.edu; spf=pass smtp.mailfrom=ustc.edu; arc=none smtp.client-ip=103.126.93.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ustc.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ustc.edu
Received: from localhost (unknown [14.116.239.35])
	by smtp.qiye.163.com (Hmail) with ESMTP id 1dec532e3;
	Fri, 1 Aug 2025 09:57:51 +0800 (GMT+08:00)
From: Chunsheng Luo <luochunsheng@ustc.edu>
To: olivia@selenic.com,
	herbert@gondor.apana.org.au
Cc: rubini@unipv.it,
	linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	Chunsheng Luo <luochunsheng@ustc.edu>
Subject: [PATCH] hw_random: nomadik: add missing dependency on ARM_AMBA
Date: Fri,  1 Aug 2025 09:57:49 +0800
Message-ID: <20250801015749.20-1-luochunsheng@ustc.edu>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a986359932d03a2kunm2aeeb72939b53
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWS1ZQUlXWQ8JGhUIEh9ZQVkZHU8fVkJKSUpPT0IeQ0NIQ1YeHw5VEwETFhoSFy
	QUDg9ZV1kYEgtZQVlKT1VKSk1VSUhCVUhOWVdZFhoPEhUdFFlBWUtVS1VLVUtZBg++

Compiling without CONFIG_ARM_AMBA causes undefined reference errors:
 ld: vmlinux.o: in function `nmk_rng_remove':
 nomadik-rng.c:(.text+0x6f64917): undefined reference to `amba_release_regions'
 ld: vmlinux.o: in function `nmk_rng_probe':
 nomadik-rng.c:(.text+0x6f649ee): undefined reference to `amba_request_regions'
 nomadik-rng.c:(.text+0x6f64aba): undefined reference to `amba_release_regions'
 nomadik-rng.c:(.text+0x6f64ae0): undefined reference to `amba_release_regions'

The Nomadik RNG driver uses AMBA bus interfaces (amba_request_regions/amba_release_regions)
which are only available when CONFIG_ARM_AMBA is enabled. The existing dependency
on ARCH_NOMADIK implicitly selects ARM_AMBA, but when building with COMPILE_TEST
on non-ARM platforms, this dependency breaks.

Fix by explicitly adding dependency on ARM_AMBA to Kconfig, ensuring the driver
only compiles when AMBA support is available.

Signed-off-by: Chunsheng Luo <luochunsheng@ustc.edu>
---
 drivers/char/hw_random/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
index c85827843447..09abd1acb99f 100644
--- a/drivers/char/hw_random/Kconfig
+++ b/drivers/char/hw_random/Kconfig
@@ -311,7 +311,7 @@ config HW_RANDOM_INGENIC_TRNG
 
 config HW_RANDOM_NOMADIK
 	tristate "ST-Ericsson Nomadik Random Number Generator support"
-	depends on ARCH_NOMADIK || COMPILE_TEST
+	depends on ARM_AMBA && (ARCH_NOMADIK || COMPILE_TEST)
 	default HW_RANDOM
 	help
 	  This driver provides kernel-side support for the Random Number
-- 
2.43.0

