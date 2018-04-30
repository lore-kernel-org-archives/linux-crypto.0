From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH resend 10/10] crypto: arm64/sha512-ce - yield NEON after every
 block of input
Date: Mon, 30 Apr 2018 18:18:30 +0200
Message-ID: <20180430161830.14892-11-ard.biesheuvel@linaro.org>
References: <20180430161830.14892-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: will.deacon@arm.com, dave.martin@arm.com,
 linux-arm-kernel@lists.infradead.org,
 Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org,
	herbert@gondor.apana.org.au
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180430161830.14892-1-ard.biesheuvel@linaro.org>
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

Avoid excessive scheduling delays under a preemptible kernel by
conditionally yielding the NEON after every block of input.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/crypto/sha512-ce-core.S | 27 +++++++++++++++-----
 1 file changed, 21 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/crypto/sha512-ce-core.S b/arch/arm64/crypto/sha512-ce-core.S
index 7f3bca5c59a2..ce65e3abe4f2 100644
--- a/arch/arm64/crypto/sha512-ce-core.S
+++ b/arch/arm64/crypto/sha512-ce-core.S
@@ -107,17 +107,23 @@
 	 */
 	.text
 ENTRY(sha512_ce_transform)
+	frame_push	3
+
+	mov		x19, x0
+	mov		x20, x1
+	mov		x21, x2
+
 	/* load state */
-	ld1		{v8.2d-v11.2d}, [x0]
+0:	ld1		{v8.2d-v11.2d}, [x19]
 
 	/* load first 4 round constants */
 	adr_l		x3, .Lsha512_rcon
 	ld1		{v20.2d-v23.2d}, [x3], #64
 
 	/* load input */
-0:	ld1		{v12.2d-v15.2d}, [x1], #64
-	ld1		{v16.2d-v19.2d}, [x1], #64
-	sub		w2, w2, #1
+1:	ld1		{v12.2d-v15.2d}, [x20], #64
+	ld1		{v16.2d-v19.2d}, [x20], #64
+	sub		w21, w21, #1
 
 CPU_LE(	rev64		v12.16b, v12.16b	)
 CPU_LE(	rev64		v13.16b, v13.16b	)
@@ -196,9 +202,18 @@ CPU_LE(	rev64		v19.16b, v19.16b	)
 	add		v11.2d, v11.2d, v3.2d
 
 	/* handled all input blocks? */
-	cbnz		w2, 0b
+	cbz		w21, 3f
+
+	if_will_cond_yield_neon
+	st1		{v8.2d-v11.2d}, [x19]
+	do_cond_yield_neon
+	b		0b
+	endif_yield_neon
+
+	b		1b
 
 	/* store new state */
-3:	st1		{v8.2d-v11.2d}, [x0]
+3:	st1		{v8.2d-v11.2d}, [x19]
+	frame_pop
 	ret
 ENDPROC(sha512_ce_transform)
-- 
2.17.0
