Received: from bmailout3.hostsharing.net (bmailout3.hostsharing.net [176.9.242.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 731552500CE;
	Sun, 24 Nov 2024 16:16:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=176.9.242.62
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732464983; cv=none; b=d0Lhhh7DswHxjneOl4LxEjwu3/lcX58Yr3WrHYd8sKO2K6CWU6Pyrb8MKLVuUprnxFTyoAv7viBfexhE0QXunEg8viYLCLeKSIbzWJCNeT92vVBZQqwokSvTCXGjKeHZEjAPR7S5mJkslQF0KAT/+y8Qhuwd2xv4wnGVlC4NwMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732464983; c=relaxed/simple;
	bh=04RyrCigpAh94frnQiTaXhrwqzPX445WtuMSL5hVZw4=;
	h=Message-Id:From:Date:Subject:To:Cc; b=ULx/1BNY/xIybfc/dWGvCFwhvQslkYK5VJXX80rTlytPHjV/ZZDDG4FLy4kZfRxZvQ7PgMjGZ++0EP6SVJ4omyj9d5WLnccjvI4Q6Rtuc7I9LZQZrg4MfwQDyzu/1IUJEt78x+xDsGJgaBI58f3BTROTLqAR1+hD9ai8DPT8jkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de; spf=pass smtp.mailfrom=wunner.de; arc=none smtp.client-ip=176.9.242.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wunner.de
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
	 client-signature RSA-PSS (4096 bits) client-digest SHA256)
	(Client CN "*.hostsharing.net", Issuer "RapidSSL TLS RSA CA G1" (verified OK))
	by bmailout3.hostsharing.net (Postfix) with ESMTPS id E9A32100E2027;
	Sun, 24 Nov 2024 17:16:09 +0100 (CET)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
	id A91511DB74D; Sun, 24 Nov 2024 17:16:09 +0100 (CET)
Message-Id: <90667b2b7f773308318261f96ebefd1a67133c4c.1732464395.git.lukas@wunner.de>
From: Lukas Wunner <lukas@wunner.de>
Date: Sun, 24 Nov 2024 17:15:27 +0100
Subject: [PATCH for-next/fixes] arm64/mm: Fix false-positive
 !virt_addr_valid() for kernel image
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, Zorro Lang <zlang@redhat.com>, Ard Biesheuvel <ardb@kernel.org>, Vegard Nossum <vegard.nossum@oracle.com>, Joey Gouly <joey.gouly@arm.com>, linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Zorro reports a false-positive BUG_ON() when running crypto selftests on
boot:  Since commit 1e562deacecc ("crypto: rsassa-pkcs1 - Migrate to
sig_alg backend"), test_sig_one() invokes an RSA verify operation with a
test vector in the kernel's .rodata section.  The test vector is passed
to sg_set_buf(), which performs a virt_addr_valid() check.

On arm64, virt_addr_valid() returns false for kernel image addresses
such as this one, even though they're valid virtual addresses.
x86 returns true for kernel image addresses, so the BUG_ON() does not
occur there.  In fact, x86 has been doing so for 16 years, i.e. since
commit af5c2bd16ac2 ("x86: fix virt_addr_valid() with
CONFIG_DEBUG_VIRTUAL=y, v2").

Do the same on arm64 to avoid the false-positive BUG_ON() and to achieve
consistent virt_addr_valid() behavior across arches.

Silence a WARN splat in __virt_to_phys() which occurs once the BUG_ON()
is avoided.

The is_kernel_address() helper introduced herein cannot be put directly
in the virt_addr_valid() macro:  It has to be part of the kernel proper
so that it has visibility of the _text and _end symbols (referenced
through KERNEL_START and KERNEL_END).  These symbols are not exported,
so modules expanding the virt_addr_valid() macro could not access them.
For almost all invocations of virt_addr_valid(), __is_lm_address()
returns true, so jumping to the is_kernel_address() helper hardly ever
occurs and its performance impact is thus negligible.

Likewise, calling is_kernel_address() from the functions in physaddr.c
ought to be fine as they depend on CONFIG_DEBUG_VIRTUAL=y, which is
explicitly described as "costly" in the Kconfig help text.  (And this
doesn't add much cost really.)

Abridged stack trace:

  kernel BUG at include/linux/scatterlist.h:187!
  sg_init_one()
  rsassa_pkcs1_verify()
  test_sig_one()
  alg_test_sig()
  alg_test()
  cryptomgr_test()

Fixes: 1e562deacecc ("crypto: rsassa-pkcs1 - Migrate to sig_alg backend")
Reported-by: Zorro Lang <zlang@redhat.com>
Closes: https://lore.kernel.org/r/20241122045106.tzhvm2wrqvttub6k@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com/
Signed-off-by: Lukas Wunner <lukas@wunner.de>
---
Just from looking at the code it seems arm's virt_addr_valid() returns
true for kernel image addresses, so apparently arm64 is the odd man out.

Note that this fix would have obviated the need for commit c02e7c5c6da8
("arm64/mm: use lm_alias() with addresses passed to memblock_free()").

 arch/arm64/include/asm/memory.h | 6 +++++-
 arch/arm64/mm/init.c            | 7 +++++++
 arch/arm64/mm/physaddr.c        | 6 +++---
 3 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memory.h
index b9b9929..bb83315 100644
--- a/arch/arm64/include/asm/memory.h
+++ b/arch/arm64/include/asm/memory.h
@@ -416,9 +416,13 @@ static inline unsigned long virt_to_pfn(const void *kaddr)
 })
 #endif /* CONFIG_DEBUG_VIRTUAL */
 
+bool is_kernel_address(unsigned long x);
+
 #define virt_addr_valid(addr)	({					\
 	__typeof__(addr) __addr = __tag_reset(addr);			\
-	__is_lm_address(__addr) && pfn_is_map_memory(virt_to_pfn(__addr));	\
+	(__is_lm_address(__addr) ||					\
+	 is_kernel_address((unsigned long)__addr)) &&			\
+	pfn_is_map_memory(virt_to_pfn(__addr));				\
 })
 
 void dump_mem_limit(void);
diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
index d21f67d..2e8a00f 100644
--- a/arch/arm64/mm/init.c
+++ b/arch/arm64/mm/init.c
@@ -156,6 +156,13 @@ static void __init zone_sizes_init(void)
 	free_area_init(max_zone_pfns);
 }
 
+bool is_kernel_address(unsigned long x)
+{
+	return x >= (unsigned long) KERNEL_START &&
+	       x <= (unsigned long) KERNEL_END;
+}
+EXPORT_SYMBOL(is_kernel_address);
+
 int pfn_is_map_memory(unsigned long pfn)
 {
 	phys_addr_t addr = PFN_PHYS(pfn);
diff --git a/arch/arm64/mm/physaddr.c b/arch/arm64/mm/physaddr.c
index cde44c1..2d6755b 100644
--- a/arch/arm64/mm/physaddr.c
+++ b/arch/arm64/mm/physaddr.c
@@ -9,7 +9,8 @@
 
 phys_addr_t __virt_to_phys(unsigned long x)
 {
-	WARN(!__is_lm_address(__tag_reset(x)),
+	WARN(!__is_lm_address(__tag_reset(x)) &&
+	     !is_kernel_address(__tag_reset(x)),
 	     "virt_to_phys used for non-linear address: %pK (%pS)\n",
 	      (void *)x,
 	      (void *)x);
@@ -24,8 +25,7 @@ phys_addr_t __phys_addr_symbol(unsigned long x)
 	 * This is bounds checking against the kernel image only.
 	 * __pa_symbol should only be used on kernel symbol addresses.
 	 */
-	VIRTUAL_BUG_ON(x < (unsigned long) KERNEL_START ||
-		       x > (unsigned long) KERNEL_END);
+	VIRTUAL_BUG_ON(!is_kernel_address(x));
 	return __pa_symbol_nodebug(x);
 }
 EXPORT_SYMBOL(__phys_addr_symbol);
-- 
2.43.0

