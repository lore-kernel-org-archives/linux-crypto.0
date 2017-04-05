From: Matthias Kaehlcke <mka@chromium.org>
Subject: [PATCH v2] crypto: arm64/sha: Add constant operand modifier to ASM_EXPORT
Date: Wed,  5 Apr 2017 11:34:58 -0700
Message-ID: <20170405183458.193068-1-mka@chromium.org>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Grant Grundler <grundler@chromium.org>,
        Michael Davidson <md@google.com>,
        Matthias Kaehlcke <mka@chromium.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Greg Hackmann <ghackmann@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Robin Murphy <robin.murphy@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The operand is an integer constant, make the constness explicit by
adding the modifier. This is needed for clang to generate valid code
and also works with gcc.

Also change the constraint of the operand from 'I' ("Integer constant
that is valid as an immediate operand in an ADD instruction", AArch64)
to 'i' ("An immediate integer operand").

Based-on-patch-from: Greg Hackmann <ghackmann@google.com>
Signed-off-by: Greg Hackmann <ghackmann@google.com>
Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
---
Changes in v2:
- Changed operand constraint from I to i
- Updated commit message
- Changed 'From' tag to 'Based-on-patch-from'

 arch/arm64/crypto/sha1-ce-glue.c | 2 +-
 arch/arm64/crypto/sha2-ce-glue.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/crypto/sha1-ce-glue.c b/arch/arm64/crypto/sha1-ce-glue.c
index aefda9868627..6b520e3f3ab1 100644
--- a/arch/arm64/crypto/sha1-ce-glue.c
+++ b/arch/arm64/crypto/sha1-ce-glue.c
@@ -18,7 +18,7 @@
 #include <linux/module.h>
 
 #define ASM_EXPORT(sym, val) \
-	asm(".globl " #sym "; .set " #sym ", %0" :: "I"(val));
+	asm(".globl " #sym "; .set " #sym ", %c0" :: "i"(val));
 
 MODULE_DESCRIPTION("SHA1 secure hash using ARMv8 Crypto Extensions");
 MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
diff --git a/arch/arm64/crypto/sha2-ce-glue.c b/arch/arm64/crypto/sha2-ce-glue.c
index 7cd587564a41..e3abe11de48c 100644
--- a/arch/arm64/crypto/sha2-ce-glue.c
+++ b/arch/arm64/crypto/sha2-ce-glue.c
@@ -18,7 +18,7 @@
 #include <linux/module.h>
 
 #define ASM_EXPORT(sym, val) \
-	asm(".globl " #sym "; .set " #sym ", %0" :: "I"(val));
+	asm(".globl " #sym "; .set " #sym ", %c0" :: "i"(val));
 
 MODULE_DESCRIPTION("SHA-224/SHA-256 secure hash using ARMv8 Crypto Extensions");
 MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
-- 
2.12.2.715.g7642488e1d-goog
