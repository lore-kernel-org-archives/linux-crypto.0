From: Sandy Harris <sandyinchina@gmail.com>
Subject: [PATCH 7/7] Create generated/random_init.h, used by random driver
Date: Sat,  7 Nov 2015 09:30:42 -0500
Message-ID: <1446906642-19372-7-git-send-email-sandyinchina@gmail.com>
References: <1446906642-19372-1-git-send-email-sandyinchina@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: "Theodore Ts\\'o" <tytso@mit.edu>,
	Jason Cooper <jason@lakedaemon.net>,
	"H. Peter Anvin" <hpa@zytor.com>, John Denker <jsd@av8n.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qg0-f47.google.com ([209.85.192.47]:32824 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753548AbbKGOaw (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 7 Nov 2015 09:30:52 -0500
In-Reply-To: <1446906642-19372-1-git-send-email-sandyinchina@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Sandy Harris <sandyinchina@gmail.com>
---
 Kbuild           | 21 +++++++++++++++++++++
 scripts/Makefile |  1 +
 2 files changed, 22 insertions(+)

diff --git a/Kbuild b/Kbuild
index f55cefd..494c665 100644
--- a/Kbuild
+++ b/Kbuild
@@ -5,6 +5,7 @@
 # 2) Generate timeconst.h
 # 3) Generate asm-offsets.h (may need bounds.h and timeconst.h)
 # 4) Check for missing system calls
+# 5) Generate random_init.h
 
 # Default sed regexp - multiline due to syntax constraints
 define sed-y
@@ -98,3 +99,23 @@ missing-syscalls: scripts/checksyscalls.sh $(offsets-file) FORCE
 
 # Keep these three files during make clean
 no-clean-files := $(bounds-file) $(offsets-file) $(timeconst-file)
+
+#####
+# 5) Generate random_init.h
+
+ifdef CONFIG_RANDOM_INIT
+init-file := include/generated/random_init.h
+used-file := scripts/gen_random
+source-file := $(used-file).c
+always  += $(init-file)
+targets  += $(init-file)
+$(init-file) : $(used-file)
+	$(Q) $(used-file) > $(init-file)
+ifdef CONFIG_RANDOM_GCM
+$(used-file) : $(source-file)
+	$(CC) $< -DCONFIG_RANDOM_GCM -o $@
+else
+$(used-file) : $(source-file)
+	$(CC) $< -o $@
+endif
+endif
diff --git a/scripts/Makefile b/scripts/Makefile
index 1b26617..3cea546 100644
--- a/scripts/Makefile
+++ b/scripts/Makefile
@@ -18,6 +18,7 @@ hostprogs-$(CONFIG_BUILDTIME_EXTABLE_SORT) += sortextable
 hostprogs-$(CONFIG_ASN1)	 += asn1_compiler
 hostprogs-$(CONFIG_MODULE_SIG)	 += sign-file
 hostprogs-$(CONFIG_SYSTEM_TRUSTED_KEYRING) += extract-cert
+hostprogs-$(CONFIG_RANDOM_INIT)	 += gen_random
 
 HOSTCFLAGS_sortextable.o = -I$(srctree)/tools/include
 HOSTCFLAGS_asn1_compiler.o = -I$(srctree)/include
-- 
2.5.0
