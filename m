Received: from cstnet.cn (smtp25.cstnet.cn [159.226.251.25])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FF1B3AD516;
	Tue, 23 Jun 2026 06:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782194871; cv=none; b=krRvRe44wpUgvvL7yLy7gcpZ+bQ3MPA8ZiwQO2Gnz1f1YfUR2dCeOcapM5gUo4AFuwAzt9n74aZbkTerI7NSXYPnsckVprqbwTX0u9xV150brFuaJO5zSdyaYuiJQJ2YQFaVhj/LAC+1GyKN4+9f3aO/nI586tZDf/sGkn1BfXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782194871; c=relaxed/simple;
	bh=PLXKyLR5ZKA24lqc0LCJzYqORdXmjcnAVqwFCJLCLtk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=R9k9B/HuDtIom2ejbRIN8HeZvtfXLrtHD8juAbwZxu6fzVIDxmLzgzgJ7YVRWZUwKQ2VE4+prj79/Rc5VkDGAxMeb3olOZmzgfEg5JyBM4sNMgSaPVqy0p9HlvwROeTl+Eey5hFWFhlRw5FA8SZ4V1jjoJto3h4tOUA18XFLL7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from localhost.localdomain (unknown [111.196.245.140])
	by APP-05 (Coremail) with SMTP id zQCowACnCt6mIjpqne_JFA--.53044S2;
	Tue, 23 Jun 2026 14:07:35 +0800 (CST)
From: Pengpeng Hou <pengpeng@iscas.ac.cn>
To: Mounika Botcha <mounika.botcha@amd.com>,
	Harsh Jain <h.jain@amd.com>,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Michal Simek <michal.simek@amd.com>,
	linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: Pengpeng Hou <pengpeng@iscas.ac.cn>
Subject: [PATCH] hwrng: xilinx-trng: propagate timeout before any data is read
Date: Tue, 23 Jun 2026 14:07:27 +0800
Message-ID: <20260623060728.18906-1-pengpeng@iscas.ac.cn>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowACnCt6mIjpqne_JFA--.53044S2
X-Coremail-Antispam: 1UD129KBjvJXoWxAw1Dtr4kCr4kGF4UArWxtFb_yoW5Zw17pr
	WrWa9IgrWUGFyxZFZxCa47XFn8uwn3CF4jka17tas7Zr93Xrn3Ja40vF9Yqry5KFWxZFsI
	qF43urWDC3Z3AaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkC14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jrv_JF1lYx0Ex4A2jsIE14v26r4j6F4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7CjxVAaw2AFwI0_
	Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67
	AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIY
	rxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14
	v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWx
	JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfU5iihUU
	UUU
X-CM-SenderInfo: pshqw1xhqjqxpvfd2hldfou0/

xtrng_readblock32() polls for 16-byte chunks but returns the number of
bytes read even when the first poll times out. Its caller then treats a
zero return as a short successful read, and partial reads for full
32-byte blocks can make the tail copy use a fixed block offset rather
than the amount already produced.

Return the poll error when no data has been read, preserve partial
positive returns after some data is available, stop the generator on all
collection exits, and append tail bytes at the current output count.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
---
 drivers/char/hw_random/xilinx-trng.c | 32 +++++++++++++++++++++-------
 1 file changed, 24 insertions(+), 8 deletions(-)

diff --git a/drivers/char/hw_random/xilinx-trng.c b/drivers/char/hw_random/xilinx-trng.c
index f615d5adddde..4a1a168bb46a 100644
--- a/drivers/char/hw_random/xilinx-trng.c
+++ b/drivers/char/hw_random/xilinx-trng.c
@@ -87,8 +87,8 @@ static void xtrng_softreset(struct xilinx_rng *rng)
 	xtrng_readwrite32(rng->rng_base + TRNG_CTRL_OFFSET, TRNG_CTRL_PRNGSRST_MASK, 0);
 }
 
-/* Return no. of bytes read */
-static size_t xtrng_readblock32(void __iomem *rng_base, __be32 *buf, int blocks32, bool wait)
+/* Return no. of bytes read or a negative error before any data is read. */
+static int xtrng_readblock32(void __iomem *rng_base, __be32 *buf, int blocks32, bool wait)
 {
 	int read = 0, ret;
 	int timeout = 1;
@@ -103,8 +103,11 @@ static size_t xtrng_readblock32(void __iomem *rng_base, __be32 *buf, int blocks3
 		ret = readl_poll_timeout(rng_base + TRNG_STATUS_OFFSET, val,
 					 (val & TRNG_STATUS_QCNT_MASK) ==
 					 TRNG_STATUS_QCNT_16_BYTES, !!wait, timeout);
-		if (ret)
+		if (ret) {
+			if (!read)
+				return ret;
 			break;
+		}
 
 		for (idx = 0; idx < TRNG_READ_4_WORD; idx++) {
 			*(buf + read) = cpu_to_be32(ioread32(rng_base + TRNG_CORE_OUTPUT_OFFSET));
@@ -119,27 +122,40 @@ static int xtrng_collect_random_data(struct xilinx_rng *rng, u8 *rand_gen_buf,
 {
 	u8 randbuf[TRNG_SEC_STRENGTH_BYTES];
 	int byteleft, blocks, count = 0;
+	int full_blocks_bytes;
 	int ret;
 
 	byteleft = no_of_random_bytes & (TRNG_SEC_STRENGTH_BYTES - 1);
 	blocks = no_of_random_bytes >> TRNG_SEC_STRENGTH_SHIFT;
+	full_blocks_bytes = blocks * TRNG_SEC_STRENGTH_BYTES;
 	xtrng_readwrite32(rng->rng_base + TRNG_CTRL_OFFSET, TRNG_CTRL_PRNGSTART_MASK,
 			  TRNG_CTRL_PRNGSTART_MASK);
 	if (blocks) {
 		ret = xtrng_readblock32(rng->rng_base, (__be32 *)rand_gen_buf, blocks, wait);
-		if (!ret)
-			return 0;
+		if (ret <= 0) {
+			count = ret;
+			goto out_stop;
+		}
 		count += ret;
+		if (ret < full_blocks_bytes)
+			goto out_stop;
 	}
 
 	if (byteleft) {
 		ret = xtrng_readblock32(rng->rng_base, (__be32 *)randbuf, 1, wait);
+		if (ret < 0) {
+			if (!count)
+				count = ret;
+			goto out_stop;
+		}
 		if (!ret)
-			return count;
-		memcpy(rand_gen_buf + (blocks * TRNG_SEC_STRENGTH_BYTES), randbuf, byteleft);
-		count += byteleft;
+			goto out_stop;
+		ret = min(ret, no_of_random_bytes - count);
+		memcpy(rand_gen_buf + count, randbuf, ret);
+		count += ret;
 	}
 
+out_stop:
 	xtrng_readwrite32(rng->rng_base + TRNG_CTRL_OFFSET,
 			  TRNG_CTRL_PRNGMODE_MASK | TRNG_CTRL_PRNGSTART_MASK, 0U);
 
-- 
2.50.1 (Apple Git-155)

