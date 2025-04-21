Received: from mail.nfschina.com (unknown [42.101.60.213])
	by smtp.subspace.kernel.org (Postfix) with SMTP id 8CFFD3D544;
	Mon, 21 Apr 2025 05:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=42.101.60.213
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745214711; cv=none; b=a4d16XYtSmOG2YzfrP/BqTxqT4jRMw+z68dNLVcXQ3NHUfPtgMeWnNVhMYFr/vxEyxdeK6MNJNJ2Owqs6RW6sto5m08sdLwbY1hBKkhZjKsxIazzYsYqhq5Dbo9XlSnMUlM4APMTz8N8yadIgKSpoACGu2W8kijwYRN1bLYYgvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745214711; c=relaxed/simple;
	bh=FSlYPzQV65b+xksicIvsYL8ehl17TUNbOTzmRKAlkro=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ZCfhJdhlUGY+Q40Re/VcIJsSicptrl++PgkCizStKaQBGvFPUqBf43utE3DBZOAVKC16b5YNIhbFE9XFHD/kN6vsKTu5jADshfC9mZvJraTUp3o8cIIgtns5lSLA1xAj31DB8jccc850a7NzZzFFW64JcxT25RICi9TSyypuUMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nfschina.com; spf=pass smtp.mailfrom=nfschina.com; arc=none smtp.client-ip=42.101.60.213
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nfschina.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nfschina.com
Received: from longsh.shanghai.nfschina.local (unknown [180.167.10.98])
	by mail.nfschina.com (MailData Gateway V2.8.8) with ESMTPSA id 1E5D46024F57F;
	Mon, 21 Apr 2025 13:51:36 +0800 (CST)
X-MD-Sfrom: suhui@nfschina.com
X-MD-SrcIP: 180.167.10.98
From: Su Hui <suhui@nfschina.com>
To: herbert@gondor.apana.org.au,
	davem@davemloft.net
Cc: Su Hui <suhui@nfschina.com>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: [PATCH] crypto: using size_add() for kmalloc()
Date: Mon, 21 Apr 2025 13:51:06 +0800
Message-Id: <20250421055104.663552-1-suhui@nfschina.com>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It's safer to use size_add() to replace open-coded aithmetic in allocator
arguments, because size_add() can prevent possible overflow problem.

Signed-off-by: Su Hui <suhui@nfschina.com>
---
 include/crypto/aead.h     | 3 ++-
 include/crypto/akcipher.h | 4 +++-
 include/crypto/kpp.h      | 3 ++-
 3 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/include/crypto/aead.h b/include/crypto/aead.h
index 0e8a41638678..cf212d28fe18 100644
--- a/include/crypto/aead.h
+++ b/include/crypto/aead.h
@@ -10,6 +10,7 @@
 
 #include <linux/atomic.h>
 #include <linux/container_of.h>
+#include <linux/overflow.h>
 #include <linux/crypto.h>
 #include <linux/slab.h>
 #include <linux/types.h>
@@ -433,7 +434,7 @@ static inline struct aead_request *aead_request_alloc(struct crypto_aead *tfm,
 {
 	struct aead_request *req;
 
-	req = kmalloc(sizeof(*req) + crypto_aead_reqsize(tfm), gfp);
+	req = kmalloc(size_add(sizeof(*req), crypto_aead_reqsize(tfm)), gfp);
 
 	if (likely(req))
 		aead_request_set_tfm(req, tfm);
diff --git a/include/crypto/akcipher.h b/include/crypto/akcipher.h
index cdf7da74bf2f..4c37a602cce5 100644
--- a/include/crypto/akcipher.h
+++ b/include/crypto/akcipher.h
@@ -10,6 +10,7 @@
 
 #include <linux/atomic.h>
 #include <linux/crypto.h>
+#include <linux/overflow.h>
 
 /**
  * struct akcipher_request - public key cipher request
@@ -184,7 +185,8 @@ static inline struct akcipher_request *akcipher_request_alloc(
 {
 	struct akcipher_request *req;
 
-	req = kmalloc(sizeof(*req) + crypto_akcipher_reqsize(tfm), gfp);
+	req = kmalloc(size_add(sizeof(*req),
+			       crypto_akcipher_reqsize(tfm)), gfp);
 	if (likely(req))
 		akcipher_request_set_tfm(req, tfm);
 
diff --git a/include/crypto/kpp.h b/include/crypto/kpp.h
index 2d9c4de57b69..11ae1ad41d2a 100644
--- a/include/crypto/kpp.h
+++ b/include/crypto/kpp.h
@@ -11,6 +11,7 @@
 
 #include <linux/atomic.h>
 #include <linux/container_of.h>
+#include <linux/overflow.h>
 #include <linux/crypto.h>
 #include <linux/slab.h>
 
@@ -182,7 +183,7 @@ static inline struct kpp_request *kpp_request_alloc(struct crypto_kpp *tfm,
 {
 	struct kpp_request *req;
 
-	req = kmalloc(sizeof(*req) + crypto_kpp_reqsize(tfm), gfp);
+	req = kmalloc(size_add(sizeof(*req), crypto_kpp_reqsize(tfm)), gfp);
 	if (likely(req))
 		kpp_request_set_tfm(req, tfm);
 
-- 
2.30.2

