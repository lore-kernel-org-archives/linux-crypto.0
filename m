From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 2/2] crypto: blowfish-x86_64 - blacklist Pentium 4
Date: Tue, 20 Dec 2011 12:20:21 +0200
Message-ID: <20111220102021.13429.97507.stgit@localhost6.localdomain6>
References: <20111220071942.GA3870@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:52061 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228Ab1LTKUo (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 20 Dec 2011 05:20:44 -0500
In-Reply-To: <20111220071942.GA3870@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Implementation in blowfish-x86_64 uses 64bit rotations which are slow on P4,
making blowfish-x86_64 slower than generic C implementation. Therefore
blacklist P4.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 arch/x86/crypto/blowfish_glue.c |   30 ++++++++++++++++++++++++++++++
 1 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/arch/x86/crypto/blowfish_glue.c b/arch/x86/crypto/blowfish_glue.c
index b05aa16..2970110 100644
--- a/arch/x86/crypto/blowfish_glue.c
+++ b/arch/x86/crypto/blowfish_glue.c
@@ -25,6 +25,7 @@
  *
  */
 
+#include <asm/processor.h>
 #include <crypto/blowfish.h>
 #include <linux/crypto.h>
 #include <linux/init.h>
@@ -446,10 +447,39 @@ static struct crypto_alg blk_ctr_alg = {
 	},
 };
 
+static bool is_blacklisted_cpu(void)
+{
+	if (boot_cpu_data.x86_vendor != X86_VENDOR_INTEL)
+		return false;
+
+	if (boot_cpu_data.x86 == 0x0f) {
+		/*
+		 * On Pentium 4, blowfish-x86_64 is slower than generic C
+		 * implementation because use of 64bit rotates (which are really
+		 * slow on P4). Therefore blacklist P4s.
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
 static int __init init(void)
 {
 	int err;
 
+	if (!force && is_blacklisted_cpu()) {
+		printk(KERN_INFO
+			"blowfish-x86_64: performance on this CPU "
+			"would be suboptimal: disabling "
+			"blowfish-x86_64.\n");
+		return -ENODEV;
+	}
+
 	err = crypto_register_alg(&bf_alg);
 	if (err)
 		goto bf_err;
