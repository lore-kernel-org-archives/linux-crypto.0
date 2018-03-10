From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v5 09/23] crypto: arm64/sha256-neon - play nice with
 CONFIG_PREEMPT kernels
Date: Sat, 10 Mar 2018 15:21:54 +0000
Message-ID: <20180310152208.10369-10-ard.biesheuvel@linaro.org>
References: <20180310152208.10369-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Mark Rutland <mark.rutland@arm.com>, herbert@gondor.apana.org.au,
 Ard Biesheuvel <ard.biesheuvel@linaro.org>,
 Peter Zijlstra <peterz@infradead.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Will Deacon <will.deacon@arm.com>,
 Russell King - ARM Linux <linux@armlinux.org.uk>,
 Steven Rostedt <rostedt@goodmis.org>, Thomas Gleixner <tglx@linutronix.de>,
 Dave Martin <Dave.Martin@arm.com>, linux-arm-kernel@lists.infradead.org,
 linux-rt-users@vger.kernel.org
To: linux-crypto@vger.kernel.org
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180310152208.10369-1-ard.biesheuvel@linaro.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

Tweak the SHA256 update routines to invoke the SHA256 block transform
block by block, to avoid excessive scheduling delays caused by the
NEON algorithm running with preemption disabled.

Also, remove a stale comment which no longer applies now that kernel
mode NEON is actually disallowed in some contexts.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/crypto/sha256-glue.c | 36 +++++++++++++-------
 1 file changed, 23 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/crypto/sha256-glue.c b/arch/arm64/crypto/sha256-glue.c
index b064d925fe2a..e8880ccdc71f 100644
--- a/arch/arm64/crypto/sha256-glue.c
+++ b/arch/arm64/crypto/sha256-glue.c
@@ -89,21 +89,32 @@ static struct shash_alg algs[] = { {
 static int sha256_update_neon(struct shash_desc *desc, const u8 *data,
 			      unsigned int len)
 {
-	/*
-	 * Stacking and unstacking a substantial slice of the NEON register
-	 * file may significantly affect performance for small updates when
-	 * executing in interrupt context, so fall back to the scalar code
-	 * in that case.
-	 */
+	struct sha256_state *sctx = shash_desc_ctx(desc);
+
 	if (!may_use_simd())
 		return sha256_base_do_update(desc, data, len,
 				(sha256_block_fn *)sha256_block_data_order);
 
-	kernel_neon_begin();
-	sha256_base_do_update(desc, data, len,
-				(sha256_block_fn *)sha256_block_neon);
-	kernel_neon_end();
+	while (len > 0) {
+		unsigned int chunk = len;
+
+		/*
+		 * Don't hog the CPU for the entire time it takes to process all
+		 * input when running on a preemptible kernel, but process the
+		 * data block by block instead.
+		 */
+		if (IS_ENABLED(CONFIG_PREEMPT) &&
+		    chunk + sctx->count % SHA256_BLOCK_SIZE > SHA256_BLOCK_SIZE)
+			chunk = SHA256_BLOCK_SIZE -
+				sctx->count % SHA256_BLOCK_SIZE;
 
+		kernel_neon_begin();
+		sha256_base_do_update(desc, data, chunk,
+				      (sha256_block_fn *)sha256_block_neon);
+		kernel_neon_end();
+		data += chunk;
+		len -= chunk;
+	}
 	return 0;
 }
 
@@ -117,10 +128,9 @@ static int sha256_finup_neon(struct shash_desc *desc, const u8 *data,
 		sha256_base_do_finalize(desc,
 				(sha256_block_fn *)sha256_block_data_order);
 	} else {
-		kernel_neon_begin();
 		if (len)
-			sha256_base_do_update(desc, data, len,
-				(sha256_block_fn *)sha256_block_neon);
+			sha256_update_neon(desc, data, len);
+		kernel_neon_begin();
 		sha256_base_do_finalize(desc,
 				(sha256_block_fn *)sha256_block_neon);
 		kernel_neon_end();
-- 
2.15.1
