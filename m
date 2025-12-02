Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 063AF2DE70D;
	Tue,  2 Dec 2025 05:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764653157; cv=none; b=Yb4R9/z8Mr4CJV0zS25HNB33yg4xbBFrFUAI8sHsM+m+NeQzOUXZ3YtwjHlXkmKWvIJl6O4uIChgO79fMxg/sSjojQh0W4J35s151uf00IUemN6zjehRVwDASx0+xwdPHBtu/IAH+a8ku0gV3Vp15cySkcj56cOMoW/4y0Omllw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764653157; c=relaxed/simple;
	bh=fCv3EXAKf78DHOTL5ea5s28MTwLpcdNLKJTHDlgoZ94=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=MF2jKuSa0Rq30PYX3InG/LEYibPnhRWd+wnZGdebm/u/tyKI6g/iFTSJMt6kkcWh6r4JF6YO8uh//7RkBsNzS4QmixIwqV/FFVIXeWenb5U89jtFRqdmxmvcKi7hSgY0s6aDrMTgwAkfbaYUhaJs0eqkCCTHHqF7VlBjc7JN+Dg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from [127.0.0.2] (unknown [114.241.82.59])
	by APP-03 (Coremail) with SMTP id rQCowAAHlthSeC5pKwLkAg--.34172S2;
	Tue, 02 Dec 2025 13:25:38 +0800 (CST)
From: Vivian Wang <wangruikang@iscas.ac.cn>
Date: Tue, 02 Dec 2025 13:25:07 +0800
Subject: [PATCH v2] lib/crypto: riscv/chacha: Avoid s0/fp register
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251202-riscv-chacha_zvkb-fp-v2-1-7bd00098c9dc@iscas.ac.cn>
X-B4-Tracking: v=1; b=H4sIADJ4LmkC/32Oyw6CMBBFf4XM2iG0QmlY+R8GTSmDNIaHLTYq6
 b9bYW8ymzP3kbuCI2vIQZWsYMkbZ6YxAj8koHs13ghNGxl4xgvGjhla47THqMW7fvy9wW7GQuQ
 5tVI2THGI0dlSZ15b7bne2dLjGduX/QmNcoR6GgazVIkXKZNoNbusAX7+3rhlsu9tlWdb4P8Az
 5ChkNSVSrR5WapTdCmXKp3qEeoQwhfEOT5G6gAAAA==
X-Change-ID: 20251130-riscv-chacha_zvkb-fp-5644ed88b1a2
To: Jerry Shih <jerry.shih@sifive.com>, Eric Biggers <ebiggers@kernel.org>, 
 "Jason A. Donenfeld" <Jason@zx2c4.com>, Ard Biesheuvel <ardb@kernel.org>, 
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>
Cc: linux-crypto@vger.kernel.org, linux-riscv@lists.infradead.org, 
 linux-kernel@vger.kernel.org, Vivian Wang <wangruikang@iscas.ac.cn>
X-Mailer: b4 0.14.3
X-CM-TRANSID:rQCowAAHlthSeC5pKwLkAg--.34172S2
X-Coremail-Antispam: 1UD129KBjvJXoW7tr1DurWDZF13uw47Kry3Jwb_yoW8CrykpF
	Z8W3s2krW8Jr97C3y2kF4ftw4fuF9Fkry3W34jqw15tay8Jr1xZFn2934rXF1rZFy8GFyq
	yrs8C3Za9F98ZaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9Y14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AKxVWxJr
	0_GcWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2
	Y2ka0xkIwI1lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x
	0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2
	zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF
	4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWU
	CwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCT
	nIWIevJa73UjIFyTuYvjfUFg4SDUUUU
X-CM-SenderInfo: pzdqw2pxlnt03j6l2u1dvotugofq/

In chacha_zvkb, avoid using the s0 register, which is the frame pointer,
by reallocating KEY0 to t5. This makes stack traces available if e.g. a
crash happens in chacha_zvkb.

No frame pointer maintenence is otherwise required since this is a leaf
function.

Signed-off-by: Vivian Wang <wangruikang@iscas.ac.cn>
---
Changes in v2:
- Remove frame pointer maintenance, and simply avoid touching s0. Since
  this is a leaf function, this also allows unwinding to work.
- Link to v1: https://lore.kernel.org/r/20251130-riscv-chacha_zvkb-fp-v1-1-68ef7a6d477a@iscas.ac.cn
---

Found while diagnosing a crypto_zvkb "load address misaligned" crash [1]

[1]: https://lore.kernel.org/r/b3cfcdac-0337-4db0-a611-258f2868855f@iscas.ac.cn/
---
 lib/crypto/riscv/chacha-riscv64-zvkb.S | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/lib/crypto/riscv/chacha-riscv64-zvkb.S b/lib/crypto/riscv/chacha-riscv64-zvkb.S
index b777d0b4e379..3d183ec818f5 100644
--- a/lib/crypto/riscv/chacha-riscv64-zvkb.S
+++ b/lib/crypto/riscv/chacha-riscv64-zvkb.S
@@ -60,7 +60,8 @@
 #define VL		t2
 #define STRIDE		t3
 #define ROUND_CTR	t4
-#define KEY0		s0
+#define KEY0		t5
+// Avoid s0/fp to allow for unwinding
 #define KEY1		s1
 #define KEY2		s2
 #define KEY3		s3
@@ -143,7 +144,6 @@
 // The updated 32-bit counter is written back to state->x[12] before returning.
 SYM_FUNC_START(chacha_zvkb)
 	addi		sp, sp, -96
-	sd		s0, 0(sp)
 	sd		s1, 8(sp)
 	sd		s2, 16(sp)
 	sd		s3, 24(sp)
@@ -280,7 +280,6 @@ SYM_FUNC_START(chacha_zvkb)
 	bnez		NBLOCKS, .Lblock_loop
 
 	sw		COUNTER, 48(STATEP)
-	ld		s0, 0(sp)
 	ld		s1, 8(sp)
 	ld		s2, 16(sp)
 	ld		s3, 24(sp)

---
base-commit: 3a8660878839faadb4f1a6dd72c3179c1df56787
change-id: 20251130-riscv-chacha_zvkb-fp-5644ed88b1a2

Best regards,
-- 
Vivian "dramforever" Wang

