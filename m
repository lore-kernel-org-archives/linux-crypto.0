From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 2/2] lib/mpi: use "static inline" instead of "extern inline"
Date: Fri, 26 Feb 2016 13:46:27 +0100
Message-ID: <1456490794-1034544-2-git-send-email-arnd@arndb.de>
References: <1456490794-1034544-1-git-send-email-arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
	Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
	linux-crypto@vger.kernel.org, David Howells <dhowells@redhat.com>,
	Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.133]:64601 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753959AbcBZMrg (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 26 Feb 2016 07:47:36 -0500
In-Reply-To: <1456490794-1034544-1-git-send-email-arnd@arndb.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

When we use CONFIG_PROFILE_ALL_BRANCHES, every 'if()' introduces
a static variable, but that is not allowed in 'extern inline'
functions:

mpi-inline.h:116:204: warning: '______f' is static but declared in inline function 'mpihelp_sub' which is not static
mpi-inline.h:113:184: warning: '______f' is static but declared in inline function 'mpihelp_sub' which is not static
mpi-inline.h:70:184: warning: '______f' is static but declared in inline function 'mpihelp_add' which is not static
mpi-inline.h:56:204: warning: '______f' is static but declared in inline function 'mpihelp_add_1' which is not static

This changes the MPI code to use 'static inline' instead, to get
rid of hundreds of warnings.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 lib/mpi/mpi-inline.h   | 2 +-
 lib/mpi/mpi-internal.h | 8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/lib/mpi/mpi-inline.h b/lib/mpi/mpi-inline.h
index e2b39852b30a..c245ea31f785 100644
--- a/lib/mpi/mpi-inline.h
+++ b/lib/mpi/mpi-inline.h
@@ -30,7 +30,7 @@
 #define G10_MPI_INLINE_H
 
 #ifndef G10_MPI_INLINE_DECL
-#define G10_MPI_INLINE_DECL  extern inline
+#define G10_MPI_INLINE_DECL  static inline
 #endif
 
 G10_MPI_INLINE_DECL mpi_limb_t
diff --git a/lib/mpi/mpi-internal.h b/lib/mpi/mpi-internal.h
index c65dd1bff45a..7eceeddb3fb8 100644
--- a/lib/mpi/mpi-internal.h
+++ b/lib/mpi/mpi-internal.h
@@ -168,19 +168,19 @@ void mpi_rshift_limbs(MPI a, unsigned int count);
 int mpi_lshift_limbs(MPI a, unsigned int count);
 
 /*-- mpihelp-add.c --*/
-mpi_limb_t mpihelp_add_1(mpi_ptr_t res_ptr, mpi_ptr_t s1_ptr,
+static inline mpi_limb_t mpihelp_add_1(mpi_ptr_t res_ptr, mpi_ptr_t s1_ptr,
 			 mpi_size_t s1_size, mpi_limb_t s2_limb);
 mpi_limb_t mpihelp_add_n(mpi_ptr_t res_ptr, mpi_ptr_t s1_ptr,
 			 mpi_ptr_t s2_ptr, mpi_size_t size);
-mpi_limb_t mpihelp_add(mpi_ptr_t res_ptr, mpi_ptr_t s1_ptr, mpi_size_t s1_size,
+static inline mpi_limb_t mpihelp_add(mpi_ptr_t res_ptr, mpi_ptr_t s1_ptr, mpi_size_t s1_size,
 		       mpi_ptr_t s2_ptr, mpi_size_t s2_size);
 
 /*-- mpihelp-sub.c --*/
-mpi_limb_t mpihelp_sub_1(mpi_ptr_t res_ptr, mpi_ptr_t s1_ptr,
+static inline mpi_limb_t mpihelp_sub_1(mpi_ptr_t res_ptr, mpi_ptr_t s1_ptr,
 			 mpi_size_t s1_size, mpi_limb_t s2_limb);
 mpi_limb_t mpihelp_sub_n(mpi_ptr_t res_ptr, mpi_ptr_t s1_ptr,
 			 mpi_ptr_t s2_ptr, mpi_size_t size);
-mpi_limb_t mpihelp_sub(mpi_ptr_t res_ptr, mpi_ptr_t s1_ptr, mpi_size_t s1_size,
+static inline mpi_limb_t mpihelp_sub(mpi_ptr_t res_ptr, mpi_ptr_t s1_ptr, mpi_size_t s1_size,
 		       mpi_ptr_t s2_ptr, mpi_size_t s2_size);
 
 /*-- mpihelp-cmp.c --*/
-- 
2.7.0
