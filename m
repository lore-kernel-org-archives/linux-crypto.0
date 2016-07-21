From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: [PATCH] crypto: x86/glue_helper make bool
Date: Thu, 21 Jul 2016 15:13:00 -0700
Message-ID: <1469139180-26863-1-git-send-email-mcgrof@kernel.org>
Cc: lkp@01.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@kernel.org>
To: herbert@gondor.apana.org.au, davem@davemloft.net,
	paul.gortmaker@windriver.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:37214 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754464AbcGUWNI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 21 Jul 2016 18:13:08 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Paul's changes to remove MODULE_LICENSE() out of the x86 glue_helper
causes a kernel with CONFIG_CRYPTO_GLUE_HELPER_X86=m to taint since
it now detects the license is missing if you try to build the driver
as a module, log below.

Fix this by removing the module option for it via Kconfig as it
cannot be a module.

glue_helper: module license 'unspecified' taints kernel.
glue_helper: module license 'unspecified' taints kernel.
Disabling lock debugging due to kernel taint
glue_helper: Unknown symbol blkcipher_walk_done (err 0)
glue_helper: Unknown symbol blkcipher_walk_virt (err 0)
glue_helper: Unknown symbol kernel_fpu_end (err 0)
glue_helper: Unknown symbol kernel_fpu_begin (err 0)
glue_helper: Unknown symbol blkcipher_walk_virt_block (err 0)
glue_helper: Unknown symbol blkcipher_walk_done (err 0)
glue_helper: Unknown symbol blkcipher_walk_virt (err 0)
glue_helper: Unknown symbol kernel_fpu_end (err 0)
glue_helper: Unknown symbol kernel_fpu_begin (err 0)
glue_helper: Unknown symbol blkcipher_walk_virt_block (err 0)
glue_helper: Unknown symbol blkcipher_walk_done (err 0)
glue_helper: Unknown symbol blkcipher_walk_virt (err 0)
glue_helper: Unknown symbol kernel_fpu_end (err 0)
glue_helper: Unknown symbol kernel_fpu_begin (err 0)
glue_helper: Unknown symbol blkcipher_walk_virt_block (err 0)
glue_helper: Unknown symbol blkcipher_walk_done (err 0)
glue_helper: Unknown symbol blkcipher_walk_virt (err 0)
glue_helper: Unknown symbol kernel_fpu_end (err 0)
glue_helper: Unknown symbol kernel_fpu_begin (err 0)
glue_helper: Unknown symbol blkcipher_walk_virt_block (err 0)

Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
---
 crypto/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index a9377bef25e3..ed6abf4bbf3b 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -237,7 +237,7 @@ config CRYPTO_ABLK_HELPER
 	select CRYPTO_CRYPTD
 
 config CRYPTO_GLUE_HELPER_X86
-	tristate
+	bool
 	depends on X86
 	select CRYPTO_ALGAPI
 
-- 
2.8.4
