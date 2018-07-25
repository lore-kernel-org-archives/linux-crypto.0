From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH] crypto: arm/chacha20 - always use vrev for 16-bit rotates
Date: Tue, 24 Jul 2018 18:29:07 -0700
Message-ID: <20180725012907.1614-1-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Eric Biggers <ebiggers@google.com>, linux-arm-kernel@lists.infradead.org,
 Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
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

From: Eric Biggers <ebiggers@google.com>

The 4-way ChaCha20 NEON code implements 16-bit rotates with vrev32.16,
but the one-way code (used on remainder blocks) implements it with
vshl + vsri, which is slower.  Switch the one-way code to vrev32.16 too.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/arm/crypto/chacha20-neon-core.S | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/arch/arm/crypto/chacha20-neon-core.S b/arch/arm/crypto/chacha20-neon-core.S
index 3fecb2124c35..451a849ad518 100644
--- a/arch/arm/crypto/chacha20-neon-core.S
+++ b/arch/arm/crypto/chacha20-neon-core.S
@@ -51,9 +51,8 @@ ENTRY(chacha20_block_xor_neon)
 .Ldoubleround:
 	// x0 += x1, x3 = rotl32(x3 ^ x0, 16)
 	vadd.i32	q0, q0, q1
-	veor		q4, q3, q0
-	vshl.u32	q3, q4, #16
-	vsri.u32	q3, q4, #16
+	veor		q3, q3, q0
+	vrev32.16	q3, q3
 
 	// x2 += x3, x1 = rotl32(x1 ^ x2, 12)
 	vadd.i32	q2, q2, q3
@@ -82,9 +81,8 @@ ENTRY(chacha20_block_xor_neon)
 
 	// x0 += x1, x3 = rotl32(x3 ^ x0, 16)
 	vadd.i32	q0, q0, q1
-	veor		q4, q3, q0
-	vshl.u32	q3, q4, #16
-	vsri.u32	q3, q4, #16
+	veor		q3, q3, q0
+	vrev32.16	q3, q3
 
 	// x2 += x3, x1 = rotl32(x1 ^ x2, 12)
 	vadd.i32	q2, q2, q3
-- 
2.18.0
