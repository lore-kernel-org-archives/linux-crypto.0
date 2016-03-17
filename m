From: Vinicius Tinti <viniciustinti@gmail.com>
Subject: [PATCH] x86: Avoid undefined behavior in macro expansion
Date: Wed, 16 Mar 2016 23:48:49 -0300
Message-ID: <1458182929-23866-1-git-send-email-viniciustinti@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Vinicius Tinti <viniciustinti@gmail.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net,
	tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

C11 standard (at 6.10.3.3) says that ## operator (paste) has undefined
behavior when one of the result operands is not a valid preprocessing
token.

Therefore the macro expansion may depend on compiler implementation
which may or no preserve the leading white space.

Moreover other places in kernel use CONCAT(a,b) instead of CONCAT(a, b).
Changing favors concise usage.

Signed-off-by: Vinicius Tinti <viniciustinti@gmail.com>
Acked-by: Behan Webster <behanw@converseincode.com>
---
 arch/x86/crypto/aes_ctrby8_avx-x86_64.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/crypto/aes_ctrby8_avx-x86_64.S b/arch/x86/crypto/aes_ctrby8_avx-x86_64.S
index a916c4a..7a71553 100644
--- a/arch/x86/crypto/aes_ctrby8_avx-x86_64.S
+++ b/arch/x86/crypto/aes_ctrby8_avx-x86_64.S
@@ -93,7 +93,7 @@
 
 #define tmp		%r10
 #define	DDQ(i)		CONCAT(ddq_add_,i)
-#define	XMM(i)		CONCAT(%xmm, i)
+#define	XMM(i)		CONCAT(%xmm,i)
 #define	DDQ_DATA	0
 #define	XDATA		1
 #define KEY_128		1
-- 
2.7.3
