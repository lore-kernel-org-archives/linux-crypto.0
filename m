From: Matthias Kaehlcke <mka@chromium.org>
Subject: [PATCH] crypto: arm64/sha: use %c constraint code in ASM_EXPORT
Date: Wed,  5 Apr 2017 09:56:03 -0700
Message-ID: <20170405165603.87264-1-mka@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Grant Grundler <grundler@chromium.org>, linux-kernel@vger.kernel.org,
 Michael Davidson <md@google.com>, Matthias Kaehlcke <mka@chromium.org>,
 linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
 Greg Hackmann <ghackmann@google.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S . Miller" <davem@davemloft.net>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will.deacon@arm.com>
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

From: Greg Hackmann <ghackmann@google.com>

The current definition of ASM_EXPORT doesn't work properly with clang,
according to https://bugs.llvm.org//show_bug.cgi?id=27250#c3 it relies on
gcc specific behavior. Change the constraint from an intermediate to an
output expression which works with both gcc and clang.

From: Greg Hackmann <ghackmann@google.com>
Commit-message-by: Matthias Kaehlcke <mka@chromium.org>
Signed-off-by: Greg Hackmann <ghackmann@google.com>
Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
---
 arch/arm64/crypto/sha1-ce-glue.c | 2 +-
 arch/arm64/crypto/sha2-ce-glue.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/crypto/sha1-ce-glue.c b/arch/arm64/crypto/sha1-ce-glue.c
index aefda9868627..c71e94ba0e43 100644
--- a/arch/arm64/crypto/sha1-ce-glue.c
+++ b/arch/arm64/crypto/sha1-ce-glue.c
@@ -18,7 +18,7 @@
 #include <linux/module.h>
 
 #define ASM_EXPORT(sym, val) \
-	asm(".globl " #sym "; .set " #sym ", %0" :: "I"(val));
+	asm(".globl " #sym "; .set " #sym ", %c0" :: "I"(val));
 
 MODULE_DESCRIPTION("SHA1 secure hash using ARMv8 Crypto Extensions");
 MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
diff --git a/arch/arm64/crypto/sha2-ce-glue.c b/arch/arm64/crypto/sha2-ce-glue.c
index 7cd587564a41..381b5fb2dcb2 100644
--- a/arch/arm64/crypto/sha2-ce-glue.c
+++ b/arch/arm64/crypto/sha2-ce-glue.c
@@ -18,7 +18,7 @@
 #include <linux/module.h>
 
 #define ASM_EXPORT(sym, val) \
-	asm(".globl " #sym "; .set " #sym ", %0" :: "I"(val));
+	asm(".globl " #sym "; .set " #sym ", %c0" :: "I"(val));
 
 MODULE_DESCRIPTION("SHA-224/SHA-256 secure hash using ARMv8 Crypto Extensions");
 MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
-- 
2.12.2.715.g7642488e1d-goog
