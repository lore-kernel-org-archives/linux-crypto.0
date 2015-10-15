From: LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: [PATCH] lib/mpi: clean unused SHA1_DIGEST_LENGTH
Date: Thu, 15 Oct 2015 20:34:53 +0200
Message-ID: <1444934124-3883-1-git-send-email-clabbe.montjoie@gmail.com>
References: <1444849860-16334-1-git-send-email-clabbe.montjoie@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: clabbe.montjoie@gmail.com, herbert@gondor.apana.org.au,
	tadeusz.struk@intel.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1444849860-16334-1-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The define SHA1_DIGEST_LENGTH is not used anywhere, so remove it.

Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
---
 include/linux/mpi.h | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/include/linux/mpi.h b/include/linux/mpi.h
index 641b7d6..a792b38 100644
--- a/include/linux/mpi.h
+++ b/include/linux/mpi.h
@@ -32,12 +32,6 @@
 
 #include <linux/types.h>
 
-/* DSI defines */
-
-#define SHA1_DIGEST_LENGTH   20
-
-/*end of DSI defines */
-
 #define BYTES_PER_MPI_LIMB	(BITS_PER_LONG / 8)
 #define BITS_PER_MPI_LIMB	BITS_PER_LONG
 
-- 
2.4.9
