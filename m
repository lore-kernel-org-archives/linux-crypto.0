From: Randy Dunlap <rdunlap@xenotime.net>
Subject: [PATCH -next] digsig: fix build errors
Date: Sun, 20 Nov 2011 22:12:34 -0800
Message-ID: <4EC9EBD2.3040708@xenotime.net>
References: <20111121133936.ae0ecadbf39ae50da6b842d1@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20111121133936.ae0ecadbf39ae50da6b842d1@canb.auug.org.au>
Sender: linux-next-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Fix build errors by adding kconfig dependency on KEYS:

lib/digsig.c:106:16: error: dereferencing pointer to incomplete type
lib/digsig.c:107:11: error: dereferencing pointer to incomplete type
lib/digsig.c:184:14: error: dereferencing pointer to incomplete type
lib/digsig.c:223:3: error: 'key_ref_t' undeclared (first use in this function)
lib/digsig.c:223:13: error: expected ';' before 'kref'
lib/digsig.c:224:3: error: 'kref' undeclared (first use in this function)
lib/digsig.c:224:3: error: implicit declaration of function 'keyring_search'
lib/digsig.c:231:3: error: implicit declaration of function 'request_key'

and after changing lib/Kconfig:
warning: (INTEGRITY_DIGSIG) selects DIGSIG which has unmet direct dependencies (CRYPTO && KEYS)

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
---
 lib/Kconfig                |    4 ++--
 security/integrity/Kconfig |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- next-2011-1121.orig/lib/Kconfig
+++ next-2011-1121/lib/Kconfig
@@ -294,10 +294,10 @@ config MPILIB_EXTRA
 
 config DIGSIG
 	tristate "In-kernel signature checker"
-	depends on CRYPTO
+	depends on CRYPTO && KEYS
 	select MPILIB
 	help
 	  Digital signature verification. Currently only RSA is supported.
-	  Implementation is done using GnuPG MPI library
+	  Implementation is done using GnuPG MPI library.
 
 endmenu
--- next-2011-1121.orig/security/integrity/Kconfig
+++ next-2011-1121/security/integrity/Kconfig
@@ -5,7 +5,7 @@ config INTEGRITY
 
 config INTEGRITY_DIGSIG
 	boolean "Digital signature verification using multiple keyrings"
-	depends on INTEGRITY
+	depends on INTEGRITY && CRYPTO && KEYS
 	default n
 	select DIGSIG
 	help
