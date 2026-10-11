Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D06FE45D925;
	Sun, 11 Oct 2026 14:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791729023; cv=none; b=rfNN3bP8Hj3RDodXecerXsZt6mhUqjZr5Z1pfhbF60lgHvrtdXtSvVVDO8GX5TQ/umcPla9OVFThUKYWPHYIpjb7eyt5GnoLJble4y9FnyVdQg9/VxuyNcxSkB0JgupVtGoyUcDWbe7kwPKvvHna2hT1MngSy4jrM2Ffo4NoDho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791729023; c=relaxed/simple;
	bh=72qUgiSaHSs/OtjdwuJYNHnpyqD0mBkihaiADxgjWy4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rkGuOGYSuogR4jrZQ8GbDbed/IJQMmvu17hXIB4Xyua9CcC8dRJcEvpOWRPL7YhmXeVn1NUb3XvdHYXHvg0Lv+ltVcrkg+4yRvd/R6arRHqQ9/l1Yk7y5gs+J5W0Zc3XY0zFYHbQ7xgMNGiqERIXHFxFM/XYgee0l04QCkOuZrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [223.64.68.159])
	by gateway (Coremail) with SMTP id _____8CxPtN5nctq+68UAA--.60124S3;
	Sun, 11 Oct 2026 22:30:17 +0800 (CST)
Received: from kernelserver (unknown [223.64.68.159])
	by front1 (Coremail) with SMTP id qMiowJDxRs1lnctqpSYrAA--.12667S2;
	Sun, 11 Oct 2026 22:30:16 +0800 (CST)
From: Huacai Chen <chenhuacai@loongson.cn>
To: Eric Biggers <ebiggers@kernel.org>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>,
	linux-crypto@vger.kernel.org,
	WANG Xuerui <kernel@xen0n.name>,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Huacai Chen <chenhuacai@loongson.cn>,
	Tianyang Zhang <zhangtianyang@loongson.cn>
Subject: [PATCH 1/2] lib/crc: loongarch: Use hardware unaligned load in CRC32(C) loops
Date: Sun, 11 Oct 2026 22:29:29 +0800
Message-ID: <20261011142930.492999-1-chenhuacai@loongson.cn>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJDxRs1lnctqpSYrAA--.12667S2
X-CM-SenderInfo: hfkh0x5xdftxo6or00hjvr0hdfq/
X-Coremail-Antispam: 1Uk129KBj93XoWxWF1DGF1xtF1fWrykCr47Jrc_yoW5Kr4UpF
	Z0kF9IgF15XFZ3WFyYqw4fG3Z8Z393JrZIqFZ3K34xC3W7Jw17JFWkuFyYvFy5Cr929r1j
	grs5XFnxKF4vqwbCm3ZEXasCq-sJn29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUkjb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Jr0_Gr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
	Gr0_Gr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2x26I8E6xACxx1l5I
	8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r106r15McIj6I8E87Iv67AK
	xVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41l42xK82IYc2Ij64
	vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8G
	jcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2I
	x0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK
	8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I
	0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07jUsqXUUUUU=

With CONFIG_ARCH_STRICT_ALIGN=y the kernel is built with -mstrict-align,
so get_unaligned_le{16,32,64}() compiles into a byte-by-byte load/shift/
or sequence (~22 instructions per 8 bytes). On a Loongson-3C6000 machine
this throttles the CRC pipeline to ~5.7 cycles per 8 bytes (2.8 GB/s),
while the crcc.* instruction itself runs at ~1.1 cycles (latency) / ~0.8
cycles (throughput) -- the CRC unit sits idle waiting for loads.

CPU cores with the UAL feature handle unaligned accesses in hardware,
so issue real ld.{h,w,d} instructions when possible and keep the generic
get_unaligned*() path for cores without UAL.

Measured on Loongson-3C6000 (single core):

    before: 2.8 GB/s
    after:  8.4 GB/s   (~3x)

Signed-off-by: Tianyang Zhang <zhangtianyang@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
---
 lib/crc/loongarch/crc32.h | 39 +++++++++++++++++++++++++++++++++------
 1 file changed, 33 insertions(+), 6 deletions(-)

diff --git a/lib/crc/loongarch/crc32.h b/lib/crc/loongarch/crc32.h
index d34fa4c68632..692a4165eca2 100644
--- a/lib/crc/loongarch/crc32.h
+++ b/lib/crc/loongarch/crc32.h
@@ -24,15 +24,40 @@ do {							\
 #define CRC32(crc, value, size)		_CRC32(crc, value, size, crc)
 #define CRC32C(crc, value, size)	_CRC32(crc, value, size, crcc)
 
+static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_ual);
 static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_crc32);
 
+static inline u16 get_le16(const void *p)
+{
+	if (static_branch_likely(&have_ual))
+		return *((__le16 *)p);
+	else
+		return get_unaligned_le16(p);
+}
+
+static inline u32 get_le32(const void *p)
+{
+	if (static_branch_likely(&have_ual))
+		return *((__le32 *)p);
+	else
+		return get_unaligned_le32(p);
+}
+
+static inline u64 get_le64(const void *p)
+{
+	if (static_branch_likely(&have_ual))
+		return *((__le64 *)p);
+	else
+		return get_unaligned_le64(p);
+}
+
 static inline u32 crc32_le_arch(u32 crc, const u8 *p, size_t len)
 {
 	if (!static_branch_likely(&have_crc32))
 		return crc32_le_base(crc, p, len);
 
 	while (len >= sizeof(u64)) {
-		u64 value = get_unaligned_le64(p);
+		u64 value = get_le64(p);
 
 		CRC32(crc, value, d);
 		p += sizeof(u64);
@@ -40,14 +65,14 @@ static inline u32 crc32_le_arch(u32 crc, const u8 *p, size_t len)
 	}
 
 	if (len & sizeof(u32)) {
-		u32 value = get_unaligned_le32(p);
+		u32 value = get_le32(p);
 
 		CRC32(crc, value, w);
 		p += sizeof(u32);
 	}
 
 	if (len & sizeof(u16)) {
-		u16 value = get_unaligned_le16(p);
+		u16 value = get_le16(p);
 
 		CRC32(crc, value, h);
 		p += sizeof(u16);
@@ -68,7 +93,7 @@ static inline u32 crc32c_arch(u32 crc, const u8 *p, size_t len)
 		return crc32c_base(crc, p, len);
 
 	while (len >= sizeof(u64)) {
-		u64 value = get_unaligned_le64(p);
+		u64 value = get_le64(p);
 
 		CRC32C(crc, value, d);
 		p += sizeof(u64);
@@ -76,14 +101,14 @@ static inline u32 crc32c_arch(u32 crc, const u8 *p, size_t len)
 	}
 
 	if (len & sizeof(u32)) {
-		u32 value = get_unaligned_le32(p);
+		u32 value = get_le32(p);
 
 		CRC32C(crc, value, w);
 		p += sizeof(u32);
 	}
 
 	if (len & sizeof(u16)) {
-		u16 value = get_unaligned_le16(p);
+		u16 value = get_le16(p);
 
 		CRC32C(crc, value, h);
 		p += sizeof(u16);
@@ -103,6 +128,8 @@ static inline u32 crc32c_arch(u32 crc, const u8 *p, size_t len)
 #define crc32_mod_init_arch crc32_mod_init_arch
 static void crc32_mod_init_arch(void)
 {
+	if (cpu_has_ual)
+		static_branch_enable(&have_ual);
 	if (cpu_has_crc32)
 		static_branch_enable(&have_crc32);
 }
-- 
2.52.0

