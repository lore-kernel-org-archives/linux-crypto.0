From: Harald Freudenberger <freude@linux.vnet.ibm.com>
Subject: [PATCH] s390/crypto: fix aes,des ctr mode concurrency finding.
Date: Wed,  7 May 2014 16:51:29 +0200
Message-ID: <1399474290-2332-1-git-send-email-freude@linux.vnet.ibm.com>
Cc: linux-crypto@vger.kernel.org,
	Martin Schwidefsky <schwidefsky@de.ibm.com>,
	Ingo Tuchscherer <ingo.tuchscherer@linux.vnet.ibm.com>,
	Hendrik Brueckner <brueckner@de.ibm.com>,
	Gerald Schaefer <gerald.schaefer@de.ibm.com>,
	Harald Freudenberger <freude@de.ibm.com>,
	stable@vger.kernel.org,
	Harald Freudenberger <freude@linux.vnet.ibm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

An additional testcase found an issue with the last
series of patches applied: the fallback solution may
not save the iv value after operation. This very small
fix just makes sure the iv is copied back to the
walk/desc struct.

Signed-off-by: Harald Freudenberger <freude@linux.vnet.ibm.com>
---
 arch/s390/crypto/aes_s390.c |    3 +++
 arch/s390/crypto/des_s390.c |    3 +++
 2 files changed, 6 insertions(+)

diff --git a/arch/s390/crypto/aes_s390.c b/arch/s390/crypto/aes_s390.c
index cf3c008..23223cd 100644
--- a/arch/s390/crypto/aes_s390.c
+++ b/arch/s390/crypto/aes_s390.c
@@ -820,6 +820,9 @@ static int ctr_aes_crypt(struct blkcipher_desc *desc, long func,
 		else
 			memcpy(walk->iv, ctrptr, AES_BLOCK_SIZE);
 		spin_unlock(&ctrblk_lock);
+	} else {
+		if (!nbytes)
+			memcpy(walk->iv, ctrptr, AES_BLOCK_SIZE);
 	}
 	/*
 	 * final block may be < AES_BLOCK_SIZE, copy only nbytes
diff --git a/arch/s390/crypto/des_s390.c b/arch/s390/crypto/des_s390.c
index 0a5aac8..7acb77f 100644
--- a/arch/s390/crypto/des_s390.c
+++ b/arch/s390/crypto/des_s390.c
@@ -429,6 +429,9 @@ static int ctr_desall_crypt(struct blkcipher_desc *desc, long func,
 		else
 			memcpy(walk->iv, ctrptr, DES_BLOCK_SIZE);
 		spin_unlock(&ctrblk_lock);
+	} else {
+		if (!nbytes)
+			memcpy(walk->iv, ctrptr, DES_BLOCK_SIZE);
 	}
 	/* final block may be < DES_BLOCK_SIZE, copy only nbytes */
 	if (nbytes) {
-- 
1.7.9.5
