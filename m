From: Jan Engelhardt <jengelh@medozas.de>
Subject: crypto: libcrc32c should select crc32c
Date: Sat, 17 Jan 2009 23:48:42 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0901172346500.14505@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:40573 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761143AbZAQWso (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 17 Jan 2009 17:48:44 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

parent 683fd3522476a2b9e9278d99a7bb367c887faa5a (v2.6.29-rc2-19-g683fd35)
commit db86cb2732110f756b95f7d5a2aa37f35ba67cff
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Sat Jan 17 20:40:45 2009 +0100

crypto: libcrc32c should select crc32c

Whilst trying to make use of btrfs of a root fs with 2.6.29-rc1/rc2,
I get the following output from my initramfs:

	[...]
	Mounting root /dev/sda3
	modprobe: WARNING: Error inserting libcrc32c
	(/lib/modules/2.6.29-rc2-jen73-experimental/kernel/lib/libcrc32c.ko.gz):
	Unknown symbol in module, or unknown parameter (see dmesg)

	<4>btrfs: Unknown symbol crc32c
	modprobe: FATAL: Error inserting btrfs
	(/lib/modules/2.6.29-rc2-jen73-experimental/kernel/fs/btrfs/btrfs.ko.gz):
	Unknown symbol in module, or unknown parameter (see dmesg)

	mount: unknown filesystem type 'btrfs'

Since "unknown symbol crc32c" is the only kernel-reported message,
just what keeps libcrc32c from loading -- especially because it does
not depend on any other symbol from another kernel module according
to modinfo.

Looking at libcrc32c.c shows that it essentially depends on the
crc32c crypto module, which was not packed into my initramfs image
by mkinitrd because.. there is no dependency.

Because a simple Kconfig "select" will not make mkinitrd aware of the
dependency, this patch adds a source-level dep similar to what
Netfilter does with need_conntrack().

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 crypto/crc32c.c        |    6 ++++++
 include/linux/crc32c.h |    1 +
 lib/libcrc32c.c        |    2 ++
 3 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/crypto/crc32c.c b/crypto/crc32c.c
index 973bc2c..b3dd3ec 100644
--- a/crypto/crc32c.c
+++ b/crypto/crc32c.c
@@ -242,6 +242,12 @@ static struct shash_alg alg = {
 	}
 };
 
+/* Some modules need us, but do not depend directly on any symbol. */
+void need_crc32c(void)
+{
+}
+EXPORT_SYMBOL_GPL(need_crc32c);
+
 static int __init crc32c_mod_init(void)
 {
 	return crypto_register_shash(&alg);
diff --git a/include/linux/crc32c.h b/include/linux/crc32c.h
index bd8b44d..139416a 100644
--- a/include/linux/crc32c.h
+++ b/include/linux/crc32c.h
@@ -3,6 +3,7 @@
 
 #include <linux/types.h>
 
+extern void need_crc32c(void);
 extern u32 crc32c(u32 crc, const void *address, unsigned int length);
 
 /* This macro exists for backwards-compatibility. */
diff --git a/lib/libcrc32c.c b/lib/libcrc32c.c
index 244f548..948f50a 100644
--- a/lib/libcrc32c.c
+++ b/lib/libcrc32c.c
@@ -32,6 +32,7 @@
  */
 
 #include <crypto/hash.h>
+#include <linux/crc32c.h>
 #include <linux/err.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
@@ -61,6 +62,7 @@ EXPORT_SYMBOL(crc32c);
 
 static int __init libcrc32c_mod_init(void)
 {
+	need_crc32c();
 	tfm = crypto_alloc_shash("crc32c", 0, 0);
 	if (IS_ERR(tfm))
 		return PTR_ERR(tfm);
-- 
# Created with git-export-patch

