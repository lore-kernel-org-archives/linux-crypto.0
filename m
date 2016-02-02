From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH v5 3/3] crypto: public_key: remove MPIs from
 public_key_signature struct
Date: Tue, 02 Feb 2016 10:09:03 -0800
Message-ID: <20160202180903.2887.62996.stgit@tstruk-mobl1>
References: <20160202180848.2887.9937.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: tadeusz.struk@intel.com, linux-kernel@vger.kernel.org,
	dhowells@redhat.com, linux-security-module@vger.kernel.org,
	linux-crypto@vger.kernel.org, zohar@linux.vnet.ibm.com
To: herbert@gondor.apana.org.au
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160202180848.2887.9937.stgit@tstruk-mobl1>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

After digsig_asymmetric.c is converted the MPIs can be now
safely removed from the public_key_signature structure.

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 include/crypto/public_key.h |   14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/include/crypto/public_key.h b/include/crypto/public_key.h
index 50ac875..a1693ed 100644
--- a/include/crypto/public_key.h
+++ b/include/crypto/public_key.h
@@ -14,7 +14,6 @@
 #ifndef _LINUX_PUBLIC_KEY_H
 #define _LINUX_PUBLIC_KEY_H
 
-#include <linux/mpi.h>
 #include <crypto/hash_info.h>
 
 enum pkey_algo {
@@ -73,20 +72,9 @@ struct public_key_signature {
 	u8 *s;			/* Signature */
 	u32 s_size;		/* Number of bytes in signature */
 	u8 *digest;
-	u8 digest_size;			/* Number of bytes in digest */
-	u8 nr_mpi;			/* Occupancy of mpi[] */
+	u8 digest_size;		/* Number of bytes in digest */
 	enum pkey_algo pkey_algo : 8;
 	enum hash_algo pkey_hash_algo : 8;
-	union {
-		MPI mpi[2];
-		struct {
-			MPI s;		/* m^d mod n */
-		} rsa;
-		struct {
-			MPI r;
-			MPI s;
-		} dsa;
-	};
 };
 
 extern struct asymmetric_key_subtype public_key_subtype;
