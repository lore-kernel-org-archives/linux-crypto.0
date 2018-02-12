From: Jinbum Park <jinb.park7@gmail.com>
Subject: [PATCH] crypto: arm/aes-cipher - move S-box to .rodata section
Date: Mon, 12 Feb 2018 22:52:37 +0900
Message-ID: <20180212135237.GA3011@pjb1027-Latitude-E5410>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
        ard.biesheuvel@linaro.org
To: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Move the AES inverse S-box to the .rodata section
where it is safe from abuse by speculation.

Signed-off-by: Jinbum Park <jinb.park7@gmail.com>
---
 arch/arm/crypto/aes-cipher-core.S | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/arch/arm/crypto/aes-cipher-core.S b/arch/arm/crypto/aes-cipher-core.S
index 54b3840..184d6c2 100644
--- a/arch/arm/crypto/aes-cipher-core.S
+++ b/arch/arm/crypto/aes-cipher-core.S
@@ -174,6 +174,16 @@
 	.ltorg
 	.endm
 
+ENTRY(__aes_arm_encrypt)
+	do_crypt	fround, crypto_ft_tab, crypto_ft_tab + 1, 2
+ENDPROC(__aes_arm_encrypt)
+
+	.align		5
+ENTRY(__aes_arm_decrypt)
+	do_crypt	iround, crypto_it_tab, __aes_arm_inverse_sbox, 0
+ENDPROC(__aes_arm_decrypt)
+
+	.section	".rodata", "a"
 	.align		L1_CACHE_SHIFT
 	.type		__aes_arm_inverse_sbox, %object
 __aes_arm_inverse_sbox:
@@ -210,12 +220,3 @@ __aes_arm_inverse_sbox:
 	.byte		0x17, 0x2b, 0x04, 0x7e, 0xba, 0x77, 0xd6, 0x26
 	.byte		0xe1, 0x69, 0x14, 0x63, 0x55, 0x21, 0x0c, 0x7d
 	.size		__aes_arm_inverse_sbox, . - __aes_arm_inverse_sbox
-
-ENTRY(__aes_arm_encrypt)
-	do_crypt	fround, crypto_ft_tab, crypto_ft_tab + 1, 2
-ENDPROC(__aes_arm_encrypt)
-
-	.align		5
-ENTRY(__aes_arm_decrypt)
-	do_crypt	iround, crypto_it_tab, __aes_arm_inverse_sbox, 0
-ENDPROC(__aes_arm_decrypt)
-- 
1.9.1
