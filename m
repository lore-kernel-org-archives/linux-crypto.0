From: Jason Cooper <jason@lakedaemon.net>
Subject: [PATCH] staging: crypto: skein: depend upon CRYPTO
Date: Fri, 25 Apr 2014 16:45:09 +0000
Message-ID: <1398444309-24672-1-git-send-email-jason@lakedaemon.net>
References: <20140425151554.GB31117@localhost>
Cc: Jason Cooper <jason@lakedaemon.net>,
	Fengguang Wu <fengguang.wu@intel.com>, kbuild-all@01.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140425151554.GB31117@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Fengguang's randconfig kernel build tester discovered the following
warnings:

warning: (CRYPTO_THREEFISH) selects CRYPTO_ALGAPI which has unmet direct dependencies (CRYPTO)
warning: (DM_VERITY && CRYPTO_SKEIN) selects CRYPTO_HASH which has unmet direct dependencies (CRYPTO)

Fix this in the Kconfig by depending on CRYPTO.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Jason Cooper <jason@lakedaemon.net>
---
 drivers/staging/skein/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/skein/Kconfig b/drivers/staging/skein/Kconfig
index 8f5a72a90ced..b9172bfcdc1b 100644
--- a/drivers/staging/skein/Kconfig
+++ b/drivers/staging/skein/Kconfig
@@ -1,6 +1,6 @@
 config CRYPTO_SKEIN
 	bool "Skein digest algorithm"
-	depends on (X86 || UML_X86) && 64BIT
+	depends on (X86 || UML_X86) && 64BIT && CRYPTO
 	select CRYPTO_THREEFISH
 	select CRYPTO_HASH
 	help
@@ -17,7 +17,7 @@ config CRYPTO_SKEIN
 
 config CRYPTO_THREEFISH
 	bool "Threefish tweakable block cipher"
-	depends on (X86 || UML_X86) && 64BIT
+	depends on (X86 || UML_X86) && 64BIT && CRYPTO
 	select CRYPTO_ALGAPI
 	help
 	  Threefish cipher algorithm is the tweakable block cipher underneath
-- 
1.9.2
