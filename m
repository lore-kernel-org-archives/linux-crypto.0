From: Sandy Harris <sandyinchina@gmail.com>
Subject: [PATCH 5/7] Conditionals for CONFIG_RANDOM_INIT and CONFIG_RANDOM_GCM
Date: Sat,  7 Nov 2015 09:30:40 -0500
Message-ID: <1446906642-19372-5-git-send-email-sandyinchina@gmail.com>
References: <1446906642-19372-1-git-send-email-sandyinchina@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: "Theodore Ts\\'o" <tytso@mit.edu>,
	Jason Cooper <jason@lakedaemon.net>,
	"H. Peter Anvin" <hpa@zytor.com>, John Denker <jsd@av8n.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1446906642-19372-1-git-send-email-sandyinchina@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Signed-off-by: Sandy Harris <sandyinchina@gmail.com>
---
 drivers/char/Makefile | 25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/drivers/char/Makefile b/drivers/char/Makefile
index d8a7579..7d095e5 100644
--- a/drivers/char/Makefile
+++ b/drivers/char/Makefile
@@ -2,7 +2,30 @@
 # Makefile for the kernel character device drivers.
 #
 
-obj-y				+= mem.o random.o
+obj-y				+= mem.o
+
+ifeq ($(CONFIG_RANDOM_GCM),y)
+  random_c		= random_gcm.c
+  random_o		= random_gcm.o
+  random_no		= random.o
+else
+  random_c		= random.c
+  random_o		= random.o
+  random_no		= random_gcm.o
+endif
+obj-y				+= $(random_o)
+
+# remove the generated file after use so that
+# a fresh one is built (by scripts/gen_random)
+# for every compile
+# remove random_no so it will not get linked
+ifeq ($(CONFIG_RANDOM_INIT),y)
+init-file = include/generated/random_init.h
+$(random_o): $(random_c) $(init-file)
+	$(CC) $< -o $@
+	$(Q) rm --force $(init-file) $(random_no)
+endif
+
 obj-$(CONFIG_TTY_PRINTK)	+= ttyprintk.o
 obj-y				+= misc.o
 obj-$(CONFIG_ATARI_DSP56K)	+= dsp56k.o
-- 
2.5.0
