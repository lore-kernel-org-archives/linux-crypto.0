From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 1/2] crypto: Add struct crypto_alg->cra_check_optimized
Date: Thu, 10 Mar 2011 00:21:11 -0800
Message-ID: <1299745272-25477-2-git-send-email-nab@linux-iscsi.org>
References: <1299745272-25477-1-git-send-email-nab@linux-iscsi.org>
Cc: James Bottomley <James.Bottomley@suse.de>,
	Christoph Hellwig <hch@lst.de>,
	Randy Dunlap <rdunlap@xenotime.net>,
	linux-scsi <linux-scsi@vger.kernel.org>,
	Nicholas Bellinger <nab@linux-iscsi.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
To: linux-kernel <linux-kernel@vger.kernel.org>,
	linux-crypto <linux-crypto@vger.kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <1299745272-25477-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds an optional struct crypto_alg->cra_check_optimized() caller
that can be used by libcrypto algorithms in order to load an architecture
dependent optimized / HW offload module.

This includes adding the call to alg->cra_check_optimized() inside of
crypto_larval_lookup() once the initial generic algorithm has been
loaded via request_module().

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/api.c           |    6 +++++-
 include/linux/crypto.h |    1 +
 2 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/crypto/api.c b/crypto/api.c
index 033a714..4dcbef6 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -226,8 +226,12 @@ struct crypto_alg *crypto_larval_lookup(const char *name, u32 type, u32 mask)
 		alg = crypto_alg_lookup(name, type, mask);
 	}
 
-	if (alg)
+	if (alg) {
+		if (alg->cra_check_optimized)
+			alg->cra_check_optimized(alg);
+
 		return crypto_is_larval(alg) ? crypto_larval_wait(alg) : alg;
+	}
 
 	return crypto_larval_add(name, type, mask);
 }
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index a6a7a1c..ea7c426 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -295,6 +295,7 @@ struct crypto_alg {
 
 	int (*cra_init)(struct crypto_tfm *tfm);
 	void (*cra_exit)(struct crypto_tfm *tfm);
+	void (*cra_check_optimized)(struct crypto_alg *alg);
 	void (*cra_destroy)(struct crypto_alg *alg);
 	
 	struct module *cra_module;
-- 
1.5.6.5

