From: Leonidas S Barbosa <leosilva@linux.vnet.ibm.com>
Subject: [PATCH 1/2] Fixing vmx-crypto AES-CTR counter bug
Date: Fri, 14 Aug 2015 10:12:22 -0300
Message-ID: <20150814131218.GA11746@bluepex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: linux-kernel@vger.kernel.org,
	Paulo Smorigo <pfsmorigo@linux.vnet.ibm.com>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

AES-CTR is using a counter 8bytes-8bytes what miss match with
kernel specs.

In the previous code a vadduwm was done to increment counter.
Replacing this for a vadduqm now considering both cases counter
8-8 bytes and full 16bytes.

Signed-off-by: Leonidas S Barbosa <leosilva@linux.vnet.ibm.com>
---
 drivers/crypto/vmx/aes_ctr.c    |  8 +++++++-
 drivers/crypto/vmx/aesp8-ppc.pl | 34 +++++++++++++++++-----------------
 2 files changed, 24 insertions(+), 18 deletions(-)

diff --git a/drivers/crypto/vmx/aes_ctr.c b/drivers/crypto/vmx/aes_ctr.c
index 1e754ae..8c3847c 100644
--- a/drivers/crypto/vmx/aes_ctr.c
+++ b/drivers/crypto/vmx/aes_ctr.c
@@ -115,6 +115,7 @@ static int p8_aes_ctr_crypt(struct blkcipher_desc *desc,
 			    struct scatterlist *src, unsigned int nbytes)
 {
 	int ret;
+	u64 inc;
 	struct blkcipher_walk walk;
 	struct p8_aes_ctr_ctx *ctx =
 		crypto_tfm_ctx(crypto_blkcipher_tfm(desc->tfm));
@@ -142,8 +143,13 @@ static int p8_aes_ctr_crypt(struct blkcipher_desc *desc,
 						    &ctx->enc_key,
 						    walk.iv);
 			pagefault_enable();
+
+			/* We need to update IV mostly for last bytes/round */
+			inc = (nbytes & AES_BLOCK_MASK) / AES_BLOCK_SIZE;
+			if (inc > 0)
+				while (inc--)
+					crypto_inc(walk.iv, AES_BLOCK_SIZE);
 
-			crypto_inc(walk.iv, AES_BLOCK_SIZE);
 			nbytes &= AES_BLOCK_SIZE - 1;
 			ret = blkcipher_walk_done(desc, &walk, nbytes);
 		}
diff --git a/drivers/crypto/vmx/aesp8-ppc.pl b/drivers/crypto/vmx/aesp8-ppc.pl
index 6c5c20c..2280539 100644
--- a/drivers/crypto/vmx/aesp8-ppc.pl
+++ b/drivers/crypto/vmx/aesp8-ppc.pl
@@ -1437,28 +1437,28 @@ Load_ctr32_enc_key:
 	?vperm		v31,v31,$out0,$keyperm
 	lvx		v25,$x10,$key_		# pre-load round[2]
 
-	vadduwm		$two,$one,$one
+	vadduqm		$two,$one,$one
 	subi		$inp,$inp,15		# undo "caller"
 	$SHL		$len,$len,4
 
-	vadduwm		$out1,$ivec,$one	# counter values ...
-	vadduwm		$out2,$ivec,$two
+	vadduqm		$out1,$ivec,$one	# counter values ...
+	vadduqm		$out2,$ivec,$two
 	vxor		$out0,$ivec,$rndkey0	# ... xored with rndkey[0]
 	 le?li		$idx,8
-	vadduwm		$out3,$out1,$two
+	vadduqm		$out3,$out1,$two
 	vxor		$out1,$out1,$rndkey0
 	 le?lvsl	$inpperm,0,$idx
-	vadduwm		$out4,$out2,$two
+	vadduqm		$out4,$out2,$two
 	vxor		$out2,$out2,$rndkey0
 	 le?vspltisb	$tmp,0x0f
-	vadduwm		$out5,$out3,$two
+	vadduqm		$out5,$out3,$two
 	vxor		$out3,$out3,$rndkey0
 	 le?vxor	$inpperm,$inpperm,$tmp	# transform for lvx_u/stvx_u
-	vadduwm		$out6,$out4,$two
+	vadduqm		$out6,$out4,$two
 	vxor		$out4,$out4,$rndkey0
-	vadduwm		$out7,$out5,$two
+	vadduqm		$out7,$out5,$two
 	vxor		$out5,$out5,$rndkey0
-	vadduwm		$ivec,$out6,$two	# next counter value
+	vadduqm		$ivec,$out6,$two	# next counter value
 	vxor		$out6,$out6,$rndkey0
 	vxor		$out7,$out7,$rndkey0
 
@@ -1594,27 +1594,27 @@ Loop_ctr32_enc8x_middle:
 
 	vcipherlast	$in0,$out0,$in0
 	vcipherlast	$in1,$out1,$in1
-	 vadduwm	$out1,$ivec,$one	# counter values ...
+	 vadduqm	$out1,$ivec,$one	# counter values ...
 	vcipherlast	$in2,$out2,$in2
-	 vadduwm	$out2,$ivec,$two
+	 vadduqm	$out2,$ivec,$two
 	 vxor		$out0,$ivec,$rndkey0	# ... xored with rndkey[0]
 	vcipherlast	$in3,$out3,$in3
-	 vadduwm	$out3,$out1,$two
+	 vadduqm	$out3,$out1,$two
 	 vxor		$out1,$out1,$rndkey0
 	vcipherlast	$in4,$out4,$in4
-	 vadduwm	$out4,$out2,$two
+	 vadduqm	$out4,$out2,$two
 	 vxor		$out2,$out2,$rndkey0
 	vcipherlast	$in5,$out5,$in5
-	 vadduwm	$out5,$out3,$two
+	 vadduqm	$out5,$out3,$two
 	 vxor		$out3,$out3,$rndkey0
 	vcipherlast	$in6,$out6,$in6
-	 vadduwm	$out6,$out4,$two
+	 vadduqm	$out6,$out4,$two
 	 vxor		$out4,$out4,$rndkey0
 	vcipherlast	$in7,$out7,$in7
-	 vadduwm	$out7,$out5,$two
+	 vadduqm	$out7,$out5,$two
 	 vxor		$out5,$out5,$rndkey0
 	le?vperm	$in0,$in0,$in0,$inpperm
-	 vadduwm	$ivec,$out6,$two	# next counter value
+	 vadduqm	$ivec,$out6,$two	# next counter value
 	 vxor		$out6,$out6,$rndkey0
 	le?vperm	$in1,$in1,$in1,$inpperm
 	 vxor		$out7,$out7,$rndkey0
-- 
2.1.0
