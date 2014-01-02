From: Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH RFC] CRYPTO: Fix more AES build errors:
Date: Thu, 02 Jan 2014 17:17:56 +0000
Message-ID: <E1Vylu8-0005Q9-MO@rmk-PC.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>
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

Building a multi-arch kernel results in:

arch/arm/crypto/built-in.o: In function `aesbs_xts_decrypt':
sha1_glue.c:(.text+0x15c8): undefined reference to `bsaes_xts_decrypt'
arch/arm/crypto/built-in.o: In function `aesbs_xts_encrypt':
sha1_glue.c:(.text+0x1664): undefined reference to `bsaes_xts_encrypt'
arch/arm/crypto/built-in.o: In function `aesbs_ctr_encrypt':
sha1_glue.c:(.text+0x184c): undefined reference to `bsaes_ctr32_encrypt_blocks'
arch/arm/crypto/built-in.o: In function `aesbs_cbc_decrypt':
sha1_glue.c:(.text+0x19b4): undefined reference to `bsaes_cbc_encrypt'

This code is already runtime-conditional on NEON being supported, so
there's no point compiling it out depending on the minimum build
architecture.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
This is more a request for acks since I'd like to keep it/push it through
my tree to reduce the autobuilder failures.

 arch/arm/crypto/bsaes-armv7.pl |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/crypto/bsaes-armv7.pl b/arch/arm/crypto/bsaes-armv7.pl
index f3d96d932573..be068db960ee 100644
--- a/arch/arm/crypto/bsaes-armv7.pl
+++ b/arch/arm/crypto/bsaes-armv7.pl
@@ -701,7 +701,7 @@ $code.=<<___;
 # define VFP_ABI_FRAME	0
 # define BSAES_ASM_EXTENDED_KEY
 # define XTS_CHAIN_TWEAK
-# define __ARM_ARCH__ __LINUX_ARM_ARCH__
+# define __ARM_ARCH__	7
 #endif
 
 #ifdef __thumb__
-- 
1.7.4.4
