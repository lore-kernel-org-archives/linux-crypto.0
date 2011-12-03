From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 3.2] crypto: twofish-x86_64-3way - blacklist pentium4 and atom
Date: Sat, 03 Dec 2011 16:10:04 +0200
Message-ID: <20111203141004.4329.29784.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:34825 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502Ab1LCOKI (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 3 Dec 2011 09:10:08 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Performance of twofish-x86_64-3way on Intel Pentium 4 and Atom is lower than
of twofish-x86_64 module. So blacklist these CPUs.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 arch/x86/crypto/twofish_glue_3way.c |   47 +++++++++++++++++++++++++++++++++++
 1 files changed, 47 insertions(+), 0 deletions(-)

diff --git a/arch/x86/crypto/twofish_glue_3way.c b/arch/x86/crypto/twofish_glue_3way.c
index 5ede9c4..4897b6b 100644
--- a/arch/x86/crypto/twofish_glue_3way.c
+++ b/arch/x86/crypto/twofish_glue_3way.c
@@ -25,6 +25,7 @@
  *
  */
 
+#include <asm/processor.h>
 #include <linux/crypto.h>
 #include <linux/init.h>
 #include <linux/module.h>
@@ -432,10 +433,56 @@ static struct crypto_alg blk_ctr_alg = {
 	},
 };
 
+static bool is_blacklisted_cpu(void)
+{
+	if (boot_cpu_data.x86_vendor != X86_VENDOR_INTEL)
+		return false;
+
+	if (boot_cpu_data.x86 == 0x06 &&
+		(boot_cpu_data.x86_model == 0x1c ||
+		 boot_cpu_data.x86_model == 0x26 ||
+		 boot_cpu_data.x86_model == 0x36)) {
+		/*
+		 * On Atom, twofish-3way is slower than original assembler
+		 * implementation. Twofish-3way trades off some performance in
+		 * storing blocks in 64bit registers to allow three blocks to
+		 * be processed parallel. Parallel operation then allows gaining
+		 * more performance than was trade off, on out-of-order CPUs.
+		 * However Atom does not benefit from this parallellism and
+		 * should be blacklisted.
+		 */
+		return true;
+	}
+
+	if (boot_cpu_data.x86 == 0x0f) {
+		/*
+		 * On Pentium 4, twofish-3way is slower than original assembler
+		 * implementation because excessive uses of 64bit rotate and
+		 * left-shifts (which are really slow on P4) needed to store and
+		 * handle 128bit block in two 64bit registers.
+		 */
+		return true;
+	}
+
+	return false;
+}
+
+static int force;
+module_param(force, int, 0);
+MODULE_PARM_DESC(force, "Force module load, ignore CPU blacklist");
+
 int __init init(void)
 {
 	int err;
 
+	if (!force && is_blacklisted_cpu()) {
+		printk(KERN_INFO
+			"twofish-x86_64-3way: performance on this CPU "
+			"would be suboptimal: disabling "
+			"twofish-x86_64-3way.\n");
+		return -ENODEV;
+	}
+
 	err = crypto_register_alg(&blk_ecb_alg);
 	if (err)
 		goto ecb_err;
