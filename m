Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD0F04A4EE6;
	Mon,  5 Oct 2026 16:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791217396; cv=none; b=f5YdndlsVTwDLw8P2g7MVUYIebsgqYtjIYNnpKr+Jot7NsTplRQgKhnAX5jykz6XZy0LEIKE5TnviAJrE+C1EcFygcPGMLbJZirc3ITo8hiDUBnLKLNTOVjr2v33pkvcF8/DdpHFCRHpOhhOx5b7H2v3oHDlvOtKoYtt/9iYNSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791217396; c=relaxed/simple;
	bh=Y+mYSXG7sOxQkecidf0lc3JWzlGyd8J8+bTbdmTk65Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IJ+gxvMgr3mF4QpT7U4oYJoxLssok0QmISVcZ8IdnTSkxAzMDmjnsxe2s9eHnQCvKu04HizgyMZIzYnSCkI8lyySOCkCH7yoJyc5PEY5b1TEcMmGfElOPWoQOWdSGKwnHqo7HKAHDUIgI1EO73juWsDF6kfe10hfljbAxHsSymA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=XicBDFAx; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="XicBDFAx"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A18D7152B;
	Mon,  5 Oct 2026 09:23:10 -0700 (PDT)
Received: from NH27D9T0LF.arm.com (unknown [10.57.12.192])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1AD743F66F;
	Mon,  5 Oct 2026 09:23:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791217394; bh=Y+mYSXG7sOxQkecidf0lc3JWzlGyd8J8+bTbdmTk65Q=;
	h=From:To:Cc:Subject:Date:From;
	b=XicBDFAxgNQFcfVbFd7ubsuA4RrfeC8ebyoDYn5yCRtpFPVytb7e31MnzkZ7zgglR
	 Z9nJWr1jD6nfGR9mz2IJ7LqVGTtJZw7cep50soMkG9FFUwkVBq1b9lFORHXxV8/k2A
	 upGhKZ+sYZQN3muofn4A1rZVsLWm5v/1b7kXumLE=
From: Emanuele Rocca <emanuele.rocca@arm.com>
To: Sunil Goutham <sgoutham@marvell.com>
Cc: Geetha sowjanya <gakula@marvell.com>,
	Ratheesh Kannoth <rkannoth@marvell.com>,
	Subbaraya Sundeep <sbhatta@marvell.com>,
	Bharat Bhushan <bbhushan2@marvell.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Srujana Challa <schalla@marvell.com>,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Tamar Christina <Tamar.Christina@arm.com>,
	Jeremy Linton <Jeremy.Linton@arm.com>,
	Emanuele Rocca <emanuele.rocca@arm.com>
Subject: [PATCH net] octeontx2: use arch_extension to enable LSE
Date: Mon,  5 Oct 2026 18:21:37 +0200
Message-ID: <20261005162137.71397-1-emanuele.rocca@arm.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Instead of using ".cpu generic+lse", use ".arch_extension lse" to
enable LSE.

The ".cpu generic+lse" directive replaces the assembler's current feature
set with generic+lse, dropping other previously enabled features. In
contrast, ".arch_extension lse" enables LSE while preserving the current
feature set.

For example, the following code is rejected with "selected processor does
not support retaa", because ".cpu generic+lse" drops PAuth even though it
was enabled by armv9-a:

 .arch armv9-a
 .text
 .cpu generic+lse
 retaa

We encountered this issue while building the kernel with GCC configured
using --with-arch=armv9-a. Since Armv9-A includes pointer authentication,
GCC can assume that PAuth instructions are available and may use retaa
when generating PAuth-protected returns.

Fixes: caa2da34fd25a ("octeontx2-pf: Initialize and config queues")
Signed-off-by: Emanuele Rocca <emanuele.rocca@arm.com>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h | 2 +-
 include/linux/soc/marvell/octeontx2/asm.h                | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index eecee612b7b2..c525c557b38e 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -786,7 +786,7 @@ static inline u64 otx2_atomic64_add(u64 incr, void __iomem *addr)
 	u64 __iomem *ptr = addr;
 	u64 result;
 
-	__asm__ volatile(".cpu   generic+lse\n"
+	__asm__ volatile(".arch_extension lse\n"
 			 "ldadd %x[i], %x[r], [%[b]]"
 			 : [r]"=r"(result), "+m"(*ptr)
 			 : [i]"r"(incr), [b]"r"(ptr)
diff --git a/include/linux/soc/marvell/octeontx2/asm.h b/include/linux/soc/marvell/octeontx2/asm.h
index d683251a0b40..a9d29f5d6eeb 100644
--- a/include/linux/soc/marvell/octeontx2/asm.h
+++ b/include/linux/soc/marvell/octeontx2/asm.h
@@ -17,7 +17,7 @@
 #define otx2_lmt_flush(ioaddr)                          \
 ({                                                      \
 	u64 result = 0;                                 \
-	__asm__ volatile(".cpu  generic+lse\n"          \
+	__asm__ volatile(".arch_extension lse\n"	\
 			 "ldeor xzr, %x[rf], [%[rs]]"   \
 			 : [rf]"=r" (result)            \
 			 : [rs]"r" (ioaddr));           \
@@ -30,7 +30,7 @@
  */
 #define cn10k_lmt_flush(val, addr)			\
 ({							\
-	__asm__ volatile(".cpu  generic+lse\n"		\
+	__asm__ volatile(".arch_extension lse\n"	\
 			 "steorl %x[rf],[%[rs]]"		\
 			 : [rf] "+r"(val)		\
 			 : [rs] "r"(addr));		\
@@ -40,7 +40,7 @@ static inline u64 otx2_atomic64_fetch_add(u64 incr, u64 *ptr)
 {
 	u64 result;
 
-	asm volatile (".cpu  generic+lse\n"
+	asm volatile (".arch_extension lse\n"
 		      "ldadda %x[i], %x[r], [%[b]]"
 		      : [r] "=r" (result), "+m" (*ptr)
 		      : [i] "r" (incr), [b] "r" (ptr)
-- 
2.47.3

