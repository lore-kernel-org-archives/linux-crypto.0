Return-Path: <SRS0=ou8b=6Q=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F21B1C3A5A9
	for <linux-crypto@archiver.kernel.org>; Sat,  2 May 2020 18:28:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE4392080C
	for <linux-crypto@archiver.kernel.org>; Sat,  2 May 2020 18:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1588444095;
	bh=FtjmAlBkPtJdiMHAY6s14xRKTrL6TZzRiq8QruBwhtU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=LZtNUqzrYnXfUqikv47LevwuF95xG/0SMbLqDNKRDsTZLONXcK4GB8g3o//q+PHeG
	 PcbGEZJCtF3+Dd8sfwtfdcaT1wG8/6Y+w170ObFVHb4+uzhNs2lSMcXoe5N1gjhhe5
	 TOyuzR+o+O2Gcrko6taZSUw01qTHFBn/uz64FW+s=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728485AbgEBS2P (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 2 May 2020 14:28:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:54626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728461AbgEBS2J (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 2 May 2020 14:28:09 -0400
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 753092098B;
        Sat,  2 May 2020 18:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588444089;
        bh=FtjmAlBkPtJdiMHAY6s14xRKTrL6TZzRiq8QruBwhtU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C/6drDTuFZeNjlr9pb1860QT0Zoz29b0jQpCtPEJwHAVwTcK8SpD1iVUF02GqRNUw
         tzs8ZeTyZ3wr3GBy5msKRI6D5Em7aZgbvgzMvq7kjJD5bxOkh4jf4M+cvu9ujbDhig
         M5S5RerKV8/6JLiSsk3e57+gAMPyiAabpdRQEsq4=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 6/7] crypto: lib/sha1 - remove unnecessary includes of linux/cryptohash.h
Date:   Sat,  2 May 2020 11:24:26 -0700
Message-Id: <20200502182427.104383-7-ebiggers@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200502182427.104383-1-ebiggers@kernel.org>
References: <20200502182427.104383-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

<linux/cryptohash.h> sounds very generic and important, like it's the
header to include if you're doing cryptographic hashing in the kernel.
But actually it only includes the library implementation of the SHA-1
compression function (not even the full SHA-1).  This should basically
never be used anymore; SHA-1 is no longer considered secure, and there
are much better ways to do cryptographic hashing in the kernel.

Most files that include this header don't actually need it.  So in
preparation for removing it, remove all these unneeded includes of it.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/arm/crypto/sha1_glue.c                 | 1 -
 arch/arm/crypto/sha1_neon_glue.c            | 1 -
 arch/arm/crypto/sha256_glue.c               | 1 -
 arch/arm/crypto/sha256_neon_glue.c          | 1 -
 arch/arm/kernel/armksyms.c                  | 1 -
 arch/arm64/crypto/sha256-glue.c             | 1 -
 arch/arm64/crypto/sha512-glue.c             | 1 -
 arch/microblaze/kernel/microblaze_ksyms.c   | 1 -
 arch/mips/cavium-octeon/crypto/octeon-md5.c | 1 -
 arch/powerpc/crypto/md5-glue.c              | 1 -
 arch/powerpc/crypto/sha1-spe-glue.c         | 1 -
 arch/powerpc/crypto/sha256-spe-glue.c       | 1 -
 arch/sparc/crypto/md5_glue.c                | 1 -
 arch/sparc/crypto/sha1_glue.c               | 1 -
 arch/sparc/crypto/sha256_glue.c             | 1 -
 arch/sparc/crypto/sha512_glue.c             | 1 -
 arch/unicore32/kernel/ksyms.c               | 1 -
 arch/x86/crypto/sha1_ssse3_glue.c           | 1 -
 arch/x86/crypto/sha256_ssse3_glue.c         | 1 -
 arch/x86/crypto/sha512_ssse3_glue.c         | 1 -
 drivers/crypto/atmel-sha.c                  | 1 -
 drivers/crypto/chelsio/chcr_algo.c          | 1 -
 drivers/crypto/chelsio/chcr_ipsec.c         | 1 -
 drivers/crypto/omap-sham.c                  | 1 -
 fs/f2fs/hash.c                              | 1 -
 include/net/tcp.h                           | 1 -
 lib/crypto/chacha.c                         | 1 -
 net/core/secure_seq.c                       | 1 -
 net/ipv6/seg6_hmac.c                        | 1 -
 29 files changed, 29 deletions(-)

diff --git a/arch/arm/crypto/sha1_glue.c b/arch/arm/crypto/sha1_glue.c
index c80b0ebfd02ff6..4e954b3f7ecd5d 100644
--- a/arch/arm/crypto/sha1_glue.c
+++ b/arch/arm/crypto/sha1_glue.c
@@ -14,7 +14,6 @@
 #include <crypto/internal/hash.h>
 #include <linux/init.h>
 #include <linux/module.h>
-#include <linux/cryptohash.h>
 #include <linux/types.h>
 #include <crypto/sha.h>
 #include <crypto/sha1_base.h>
diff --git a/arch/arm/crypto/sha1_neon_glue.c b/arch/arm/crypto/sha1_neon_glue.c
index 2c3627334335df..0071e5e4411a24 100644
--- a/arch/arm/crypto/sha1_neon_glue.c
+++ b/arch/arm/crypto/sha1_neon_glue.c
@@ -18,7 +18,6 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/mm.h>
-#include <linux/cryptohash.h>
 #include <linux/types.h>
 #include <crypto/sha.h>
 #include <crypto/sha1_base.h>
diff --git a/arch/arm/crypto/sha256_glue.c b/arch/arm/crypto/sha256_glue.c
index 215497f011f239..b8a4f79020cf8a 100644
--- a/arch/arm/crypto/sha256_glue.c
+++ b/arch/arm/crypto/sha256_glue.c
@@ -15,7 +15,6 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/mm.h>
-#include <linux/cryptohash.h>
 #include <linux/types.h>
 #include <linux/string.h>
 #include <crypto/sha.h>
diff --git a/arch/arm/crypto/sha256_neon_glue.c b/arch/arm/crypto/sha256_neon_glue.c
index 38645e415196e6..79820b9e2541de 100644
--- a/arch/arm/crypto/sha256_neon_glue.c
+++ b/arch/arm/crypto/sha256_neon_glue.c
@@ -11,7 +11,6 @@
 
 #include <crypto/internal/hash.h>
 #include <crypto/internal/simd.h>
-#include <linux/cryptohash.h>
 #include <linux/types.h>
 #include <linux/string.h>
 #include <crypto/sha.h>
diff --git a/arch/arm/kernel/armksyms.c b/arch/arm/kernel/armksyms.c
index 98bdea51089d59..82e96ac836849c 100644
--- a/arch/arm/kernel/armksyms.c
+++ b/arch/arm/kernel/armksyms.c
@@ -7,7 +7,6 @@
 #include <linux/export.h>
 #include <linux/sched.h>
 #include <linux/string.h>
-#include <linux/cryptohash.h>
 #include <linux/delay.h>
 #include <linux/in6.h>
 #include <linux/syscalls.h>
diff --git a/arch/arm64/crypto/sha256-glue.c b/arch/arm64/crypto/sha256-glue.c
index ddf4a0d85c1c20..77bc6e72abae94 100644
--- a/arch/arm64/crypto/sha256-glue.c
+++ b/arch/arm64/crypto/sha256-glue.c
@@ -12,7 +12,6 @@
 #include <crypto/internal/simd.h>
 #include <crypto/sha.h>
 #include <crypto/sha256_base.h>
-#include <linux/cryptohash.h>
 #include <linux/types.h>
 #include <linux/string.h>
 
diff --git a/arch/arm64/crypto/sha512-glue.c b/arch/arm64/crypto/sha512-glue.c
index 78d3083de6b733..370ccb29602fda 100644
--- a/arch/arm64/crypto/sha512-glue.c
+++ b/arch/arm64/crypto/sha512-glue.c
@@ -6,7 +6,6 @@
  */
 
 #include <crypto/internal/hash.h>
-#include <linux/cryptohash.h>
 #include <linux/types.h>
 #include <linux/string.h>
 #include <crypto/sha.h>
diff --git a/arch/microblaze/kernel/microblaze_ksyms.c b/arch/microblaze/kernel/microblaze_ksyms.c
index 92e12c2c2ec1f7..51c43ee5e380bb 100644
--- a/arch/microblaze/kernel/microblaze_ksyms.c
+++ b/arch/microblaze/kernel/microblaze_ksyms.c
@@ -6,7 +6,6 @@
 
 #include <linux/export.h>
 #include <linux/string.h>
-#include <linux/cryptohash.h>
 #include <linux/delay.h>
 #include <linux/in6.h>
 #include <linux/syscalls.h>
diff --git a/arch/mips/cavium-octeon/crypto/octeon-md5.c b/arch/mips/cavium-octeon/crypto/octeon-md5.c
index d1ed066e1a1779..8c8ea139653ed3 100644
--- a/arch/mips/cavium-octeon/crypto/octeon-md5.c
+++ b/arch/mips/cavium-octeon/crypto/octeon-md5.c
@@ -25,7 +25,6 @@
 #include <linux/module.h>
 #include <linux/string.h>
 #include <asm/byteorder.h>
-#include <linux/cryptohash.h>
 #include <asm/octeon/octeon.h>
 #include <crypto/internal/hash.h>
 
diff --git a/arch/powerpc/crypto/md5-glue.c b/arch/powerpc/crypto/md5-glue.c
index 7d1bf2fcf66896..c24f605033bdb3 100644
--- a/arch/powerpc/crypto/md5-glue.c
+++ b/arch/powerpc/crypto/md5-glue.c
@@ -11,7 +11,6 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/mm.h>
-#include <linux/cryptohash.h>
 #include <linux/types.h>
 #include <crypto/md5.h>
 #include <asm/byteorder.h>
diff --git a/arch/powerpc/crypto/sha1-spe-glue.c b/arch/powerpc/crypto/sha1-spe-glue.c
index 6379990bd6044e..cb57be4ada61cd 100644
--- a/arch/powerpc/crypto/sha1-spe-glue.c
+++ b/arch/powerpc/crypto/sha1-spe-glue.c
@@ -11,7 +11,6 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/mm.h>
-#include <linux/cryptohash.h>
 #include <linux/types.h>
 #include <crypto/sha.h>
 #include <asm/byteorder.h>
diff --git a/arch/powerpc/crypto/sha256-spe-glue.c b/arch/powerpc/crypto/sha256-spe-glue.c
index 84939e563b817e..ceb0b6c980b3bb 100644
--- a/arch/powerpc/crypto/sha256-spe-glue.c
+++ b/arch/powerpc/crypto/sha256-spe-glue.c
@@ -12,7 +12,6 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/mm.h>
-#include <linux/cryptohash.h>
 #include <linux/types.h>
 #include <crypto/sha.h>
 #include <asm/byteorder.h>
diff --git a/arch/sparc/crypto/md5_glue.c b/arch/sparc/crypto/md5_glue.c
index 14f6c15be6aecd..111283fe837e8d 100644
--- a/arch/sparc/crypto/md5_glue.c
+++ b/arch/sparc/crypto/md5_glue.c
@@ -18,7 +18,6 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/mm.h>
-#include <linux/cryptohash.h>
 #include <linux/types.h>
 #include <crypto/md5.h>
 
diff --git a/arch/sparc/crypto/sha1_glue.c b/arch/sparc/crypto/sha1_glue.c
index 7c16663044417c..dc017782be523d 100644
--- a/arch/sparc/crypto/sha1_glue.c
+++ b/arch/sparc/crypto/sha1_glue.c
@@ -15,7 +15,6 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/mm.h>
-#include <linux/cryptohash.h>
 #include <linux/types.h>
 #include <crypto/sha.h>
 
diff --git a/arch/sparc/crypto/sha256_glue.c b/arch/sparc/crypto/sha256_glue.c
index f403ce9ba6e4f3..286bc8ecf15b6f 100644
--- a/arch/sparc/crypto/sha256_glue.c
+++ b/arch/sparc/crypto/sha256_glue.c
@@ -15,7 +15,6 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/mm.h>
-#include <linux/cryptohash.h>
 #include <linux/types.h>
 #include <crypto/sha.h>
 
diff --git a/arch/sparc/crypto/sha512_glue.c b/arch/sparc/crypto/sha512_glue.c
index a3b532e43c074e..3b2ca732ff7a5a 100644
--- a/arch/sparc/crypto/sha512_glue.c
+++ b/arch/sparc/crypto/sha512_glue.c
@@ -14,7 +14,6 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/mm.h>
-#include <linux/cryptohash.h>
 #include <linux/types.h>
 #include <crypto/sha.h>
 
diff --git a/arch/unicore32/kernel/ksyms.c b/arch/unicore32/kernel/ksyms.c
index f4b84872d64034..7314450089320a 100644
--- a/arch/unicore32/kernel/ksyms.c
+++ b/arch/unicore32/kernel/ksyms.c
@@ -9,7 +9,6 @@
 #include <linux/module.h>
 #include <linux/sched.h>
 #include <linux/string.h>
-#include <linux/cryptohash.h>
 #include <linux/delay.h>
 #include <linux/in6.h>
 #include <linux/syscalls.h>
diff --git a/arch/x86/crypto/sha1_ssse3_glue.c b/arch/x86/crypto/sha1_ssse3_glue.c
index a801ffc10cbbf7..18200135603fc9 100644
--- a/arch/x86/crypto/sha1_ssse3_glue.c
+++ b/arch/x86/crypto/sha1_ssse3_glue.c
@@ -21,7 +21,6 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/mm.h>
-#include <linux/cryptohash.h>
 #include <linux/types.h>
 #include <crypto/sha.h>
 #include <crypto/sha1_base.h>
diff --git a/arch/x86/crypto/sha256_ssse3_glue.c b/arch/x86/crypto/sha256_ssse3_glue.c
index 6394b5fe8db6da..dd06249229e169 100644
--- a/arch/x86/crypto/sha256_ssse3_glue.c
+++ b/arch/x86/crypto/sha256_ssse3_glue.c
@@ -34,7 +34,6 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/mm.h>
-#include <linux/cryptohash.h>
 #include <linux/types.h>
 #include <crypto/sha.h>
 #include <crypto/sha256_base.h>
diff --git a/arch/x86/crypto/sha512_ssse3_glue.c b/arch/x86/crypto/sha512_ssse3_glue.c
index 82cc1b3ced1dbe..b0b05c93409e16 100644
--- a/arch/x86/crypto/sha512_ssse3_glue.c
+++ b/arch/x86/crypto/sha512_ssse3_glue.c
@@ -32,7 +32,6 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/mm.h>
-#include <linux/cryptohash.h>
 #include <linux/string.h>
 #include <linux/types.h>
 #include <crypto/sha.h>
diff --git a/drivers/crypto/atmel-sha.c b/drivers/crypto/atmel-sha.c
index e536e2a6bbd853..75ccf41a7cb97a 100644
--- a/drivers/crypto/atmel-sha.c
+++ b/drivers/crypto/atmel-sha.c
@@ -31,7 +31,6 @@
 #include <linux/of_device.h>
 #include <linux/delay.h>
 #include <linux/crypto.h>
-#include <linux/cryptohash.h>
 #include <crypto/scatterwalk.h>
 #include <crypto/algapi.h>
 #include <crypto/sha.h>
diff --git a/drivers/crypto/chelsio/chcr_algo.c b/drivers/crypto/chelsio/chcr_algo.c
index 5d3000fdd5f44c..caf1136e7ef98b 100644
--- a/drivers/crypto/chelsio/chcr_algo.c
+++ b/drivers/crypto/chelsio/chcr_algo.c
@@ -44,7 +44,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/crypto.h>
-#include <linux/cryptohash.h>
 #include <linux/skbuff.h>
 #include <linux/rtnetlink.h>
 #include <linux/highmem.h>
diff --git a/drivers/crypto/chelsio/chcr_ipsec.c b/drivers/crypto/chelsio/chcr_ipsec.c
index 9fd3b9d1ec2f5d..25bf6d963066d1 100644
--- a/drivers/crypto/chelsio/chcr_ipsec.c
+++ b/drivers/crypto/chelsio/chcr_ipsec.c
@@ -40,7 +40,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/crypto.h>
-#include <linux/cryptohash.h>
 #include <linux/skbuff.h>
 #include <linux/rtnetlink.h>
 #include <linux/highmem.h>
diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index e4072cd385857c..bab6d1afd85b90 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -33,7 +33,6 @@
 #include <linux/of_irq.h>
 #include <linux/delay.h>
 #include <linux/crypto.h>
-#include <linux/cryptohash.h>
 #include <crypto/scatterwalk.h>
 #include <crypto/algapi.h>
 #include <crypto/sha.h>
diff --git a/fs/f2fs/hash.c b/fs/f2fs/hash.c
index 5bc4dcd8fc03fb..8c4ea5003ef8cb 100644
--- a/fs/f2fs/hash.c
+++ b/fs/f2fs/hash.c
@@ -12,7 +12,6 @@
 #include <linux/types.h>
 #include <linux/fs.h>
 #include <linux/f2fs_fs.h>
-#include <linux/cryptohash.h>
 #include <linux/pagemap.h>
 #include <linux/unicode.h>
 
diff --git a/include/net/tcp.h b/include/net/tcp.h
index 5fa9eacd965a4a..5948c8e4c9e133 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -23,7 +23,6 @@
 #include <linux/cache.h>
 #include <linux/percpu.h>
 #include <linux/skbuff.h>
-#include <linux/cryptohash.h>
 #include <linux/kref.h>
 #include <linux/ktime.h>
 
diff --git a/lib/crypto/chacha.c b/lib/crypto/chacha.c
index 65ead6b0c7e000..4ccbec442469c3 100644
--- a/lib/crypto/chacha.c
+++ b/lib/crypto/chacha.c
@@ -10,7 +10,6 @@
 #include <linux/export.h>
 #include <linux/bitops.h>
 #include <linux/string.h>
-#include <linux/cryptohash.h>
 #include <asm/unaligned.h>
 #include <crypto/chacha.h>
 
diff --git a/net/core/secure_seq.c b/net/core/secure_seq.c
index 7b6b1d2c3d1091..b5bc680d475536 100644
--- a/net/core/secure_seq.c
+++ b/net/core/secure_seq.c
@@ -5,7 +5,6 @@
 
 #include <linux/kernel.h>
 #include <linux/init.h>
-#include <linux/cryptohash.h>
 #include <linux/module.h>
 #include <linux/cache.h>
 #include <linux/random.h>
diff --git a/net/ipv6/seg6_hmac.c b/net/ipv6/seg6_hmac.c
index ffcfcd2b128f3a..85dddfe3a2c6ed 100644
--- a/net/ipv6/seg6_hmac.c
+++ b/net/ipv6/seg6_hmac.c
@@ -34,7 +34,6 @@
 #include <net/addrconf.h>
 #include <net/xfrm.h>
 
-#include <linux/cryptohash.h>
 #include <crypto/hash.h>
 #include <crypto/sha.h>
 #include <net/seg6.h>
-- 
2.26.2

