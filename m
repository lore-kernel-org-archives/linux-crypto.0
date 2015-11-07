From: Sandy Harris <sandyinchina@gmail.com>
Subject: [PATCH 2/7] Two new CONFIG options for the random(4) driver
Date: Sat,  7 Nov 2015 09:30:37 -0500
Message-ID: <1446906642-19372-2-git-send-email-sandyinchina@gmail.com>
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
 drivers/char/Kconfig | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index a043107..0e0e6b5 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -603,5 +603,28 @@ config TILE_SROM
 
 source "drivers/char/xillybus/Kconfig"
 
+
+config RANDOM_INIT
+	bool "Initialise random(4) pools with random data (NEW)"
+	default n
+	help
+	  Use /dev/urandom on development machine to set
+	  up pools, different for each compile.
+	  Compiles scripts/gen_random_init.c
+	  Creates include/generated/random_init.h
+
+config RANDOM_GCM
+	bool "modified random(4) driver (EXPERIMENTAL)"
+	depends on RANDOM_INIT
+	default n
+	help
+	  New version using the hash from AES-GCM.
+	  Main goal decoupling so that heavy use of
+	  /dev/urandom cannot deplete entropy for
+	  /dev/random.
+	  Should not be used in production before much
+	  more analysis and testing is done.
+	  When in doubt, say "N".
+
 endmenu
 
-- 
2.5.0
