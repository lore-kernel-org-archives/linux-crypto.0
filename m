Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 171B3466B1F;
	Sun, 11 Oct 2026 14:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791729036; cv=none; b=Re4JDldgtbgCAd/yLYlbqsV+EOd2OHoD6SYs+L2VxKPgrEA8HK11ErTTGMLijVSAE5iYJpwq++pYJTeF5rfSGTIPTi3ZtpvJ//LU3xq91wyu4AcobOFel30qVrk50+6ds3asMTOxCPhVdUvHJqLPfduOb0zgke9+WgxZE5PvV5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791729036; c=relaxed/simple;
	bh=f2Ga42+G52t4CNU5u0jbJpl/NH+ifMFTlGknNh3zSbI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eGDEseO91MB87RFOmLeLFGuFrl7k4/HEhZgx+X+lS/jcWNt+t5mh5omvz9/fy9v6CFugakvXCiUmAJu8gN1FJMedaWBCS62wKD7xu+A+bhJhclpIC2xLuPAjJwSHA27qrfhhVKv56fSiMofmlu0g6gtARmpao0JOhbLNn9Rly7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [223.64.68.159])
	by gateway (Coremail) with SMTP id _____8BxW_CCnctqArAUAA--.60281S3;
	Sun, 11 Oct 2026 22:30:26 +0800 (CST)
Received: from kernelserver (unknown [223.64.68.159])
	by front1 (Coremail) with SMTP id qMiowJDxRs1lnctqpSYrAA--.12667S3;
	Sun, 11 Oct 2026 22:30:26 +0800 (CST)
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
Subject: [PATCH 2/2] lib/crc: loongarch: Add 3-way parallel CRC32(C) for large buffers
Date: Sun, 11 Oct 2026 22:29:30 +0800
Message-ID: <20261011142930.492999-2-chenhuacai@loongson.cn>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261011142930.492999-1-chenhuacai@loongson.cn>
References: <20261011142930.492999-1-chenhuacai@loongson.cn>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJDxRs1lnctqpSYrAA--.12667S3
X-CM-SenderInfo: hfkh0x5xdftxo6or00hjvr0hdfq/
X-Coremail-Antispam: 1Uk129KBj93XoWxAF4xGr4DGF1kWw1DCw1DCFX_yoWrCF1fpF
	yDKrn8tFsxZa9rCa15Xw1rtwn0vrs7Jry5tFWaq3y7t3ZrJw18XF4ktFWYq398AFZakryU
	GrWDJ3ZxCF40qrbCm3ZEXasCq-sJn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUkjb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Jr0_Gr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
	Gr0_Gr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2x26I8E6xACxx1l5I
	8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r126r1DMcIj6I8E87Iv67AK
	xVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41l42xK82IYc2Ij64
	vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8G
	jcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2I
	x0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK
	8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I
	0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07j83kZUUUUU=

The crc* loop is a single serial dependency chain: every instruction
consumes the previous one's result. CRC is linear over GF(2), so a
buffer can be split into 3 contiguous lanes processed by independent
chains and combined afterwards:

    crc(A|B|C) = shift(crc(A), |B|+|C|) ^ shift(crc(B), |C|) ^ crc(C)

with lanes B and C seeded with 0. The shift (multiplication by x^(8n)
mod P) is linear, so its multiplier is tabulated at module init as 4x256
tables built from crc32_le_base()/crc32c_base(); each combine then costs
4 lookups instead of a log-time GF(2) square loop.

Lanes use a fixed 2 KiB stride (6 KiB superblock); smaller buffers fall
through to the serial path. The 3-way parallel loop CRC32 is measured on
a Loongson-3C6000 machine (single core, cache-hot, with UAL):

    8 KiB:   8.4 -> 12.0 GB/s
    64 KiB:  8.4 -> 12.4 GB/s   (+45% over the serial hw loop,
                                 ~12x over the generic table)

Correctness was verified bit-exact against crc32c() over all lengths
0..6168 with 3 seeds, plus 3000 random offset/length/seed combinations.

Signed-off-by: Tianyang Zhang <zhangtianyang@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
---
 lib/crc/loongarch/crc32.h | 53 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/lib/crc/loongarch/crc32.h b/lib/crc/loongarch/crc32.h
index 692a4165eca2..1750c6eb4a01 100644
--- a/lib/crc/loongarch/crc32.h
+++ b/lib/crc/loongarch/crc32.h
@@ -12,6 +12,9 @@
 #include <asm/cpu-features.h>
 #include <linux/unaligned.h>
 
+#define CRC3WAY_STRIDE	SZ_2K
+#define CRC3WAY_BLOCK	(3 * CRC3WAY_STRIDE)
+
 #define _CRC32(crc, value, size, type)			\
 do {							\
 	__asm__ __volatile__(				\
@@ -27,6 +30,50 @@ do {							\
 static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_ual);
 static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_crc32);
 
+static const u8 zero[4] = {0};
+static u32 crc32_k1tab[4][256], crc32_k2tab[4][256];
+static u32 crc32c_k1tab[4][256], crc32c_k2tab[4][256];
+
+static void crc3way_build_table(u32 tab[4][256],
+		u32 (*init)(u32, const u8 *p, size_t), size_t len)
+{
+	int i, j;
+
+	for (i = 0; i < 4; i++)
+		for (j = 0; j < 256; j++)
+			tab[i][j] = init((u32)j << (8 * i), zero, len);
+}
+
+static void crc3way_table_init(void)
+{
+	crc3way_build_table(crc32_k1tab, crc32_le_base, CRC3WAY_STRIDE);
+	crc3way_build_table(crc32_k2tab, crc32_le_base, 2 * CRC3WAY_STRIDE);
+	crc3way_build_table(crc32c_k1tab, crc32c_base, CRC3WAY_STRIDE);
+	crc3way_build_table(crc32c_k2tab, crc32c_base, 2 * CRC3WAY_STRIDE);
+}
+
+static inline u32 crc3way_shift(const u32 tab[4][256], u32 crc)
+{
+	return tab[0][crc & 0xff] ^ tab[1][(crc >> 8) & 0xff] ^
+	       tab[2][(crc >> 16) & 0xff] ^ tab[3][crc >> 24];
+}
+
+#define CRC3WAY_LOOP(crc, p, len, type, k1tab, k2tab)			\
+while ((len) >= CRC3WAY_BLOCK) {					\
+	unsigned int i;							\
+	u32 c0 = (crc), c1 = 0, c2 = 0;					\
+	const u8 *p1 = (p) + CRC3WAY_STRIDE;				\
+	const u8 *p2 = (p) + 2 * CRC3WAY_STRIDE;			\
+									\
+	for (i = 0; i < CRC3WAY_STRIDE; i += sizeof(u64)) {		\
+		_CRC32(c0, get_le64((p) + i), d, type);			\
+		_CRC32(c1, get_le64((p1) + i), d, type);		\
+		_CRC32(c2, get_le64((p2) + i), d, type);		\
+	}								\
+	(p) += CRC3WAY_BLOCK; (len) -= CRC3WAY_BLOCK;			\
+	crc = crc3way_shift(k2tab, c0) ^ crc3way_shift(k1tab, c1) ^ c2;	\
+}
+
 static inline u16 get_le16(const void *p)
 {
 	if (static_branch_likely(&have_ual))
@@ -56,6 +103,8 @@ static inline u32 crc32_le_arch(u32 crc, const u8 *p, size_t len)
 	if (!static_branch_likely(&have_crc32))
 		return crc32_le_base(crc, p, len);
 
+	CRC3WAY_LOOP(crc, p, len, crc, crc32_k1tab, crc32_k2tab);
+
 	while (len >= sizeof(u64)) {
 		u64 value = get_le64(p);
 
@@ -92,6 +141,8 @@ static inline u32 crc32c_arch(u32 crc, const u8 *p, size_t len)
 	if (!static_branch_likely(&have_crc32))
 		return crc32c_base(crc, p, len);
 
+	CRC3WAY_LOOP(crc, p, len, crcc, crc32c_k1tab, crc32c_k2tab);
+
 	while (len >= sizeof(u64)) {
 		u64 value = get_le64(p);
 
@@ -128,6 +179,8 @@ static inline u32 crc32c_arch(u32 crc, const u8 *p, size_t len)
 #define crc32_mod_init_arch crc32_mod_init_arch
 static void crc32_mod_init_arch(void)
 {
+	crc3way_table_init();
+
 	if (cpu_has_ual)
 		static_branch_enable(&have_ual);
 	if (cpu_has_crc32)
-- 
2.52.0

