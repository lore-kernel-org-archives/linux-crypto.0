Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF41022F388
	for <linux-crypto@vger.kernel.org>; Mon,  7 Apr 2025 10:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744020693; cv=none; b=OmGdRbkrU0swmWZAPyMjaK6H4Bl4Rb2lFi2JDge1flm9QWFPUVAo43AzIicakhpB3hu7s+PTgPJmAiWACh6A+VZ6/J+D3X3RJgqbmXZYn28j4/ImE7zuhsXFVXmJnbxDU90srkvJO0Xo9clo4xCjsxAjS9jcIzdPKSYofb0kRWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744020693; c=relaxed/simple;
	bh=y2NBWM4ms2gsBYxD72dK8spaouVGT7VI93Obb6JJKCo=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=lj3Kauy5WLY/5XCy0i+sZFNewETDpLaR6ckCjD1cps//gaVMY2X4YkgzwiVWU+IXYidXpcthRpZW8ZcXQok2KmJFHdsh/YyVvdASgMVp1kFB0vTyR+Zlp86v5ynWB+S3T3CYhYL/80dGDcS6mAtUpDhiT5w3NAs7GKfIVfEOjTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=VqAUHZjO; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="VqAUHZjO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=w4PiHwgvNdsY4mSJkxv2SaoXma9x2SwTvWLVGHfePF4=; b=VqAUHZjON4g26g6tuSOy7Gvb/n
	bcZqH8JdTEDyFoYyehoK6RWZ/Smz+v+N0yPvMNbhMaKqlGJZELU7JGC/BO42fJCVrQrx0bykweNDs
	C+aA86Hjx5oKplrROTsW+rR8VHCKqCDQvMlY4MULsZD16f/OyZnBOermCP0kwVAHlMJz/mLY4Msmd
	J3ML56x5/VoTr/RUM9W07lLJStb9tVbVQDA0TfxMkefsFQbJ56mu16yrobEoeydhsN1UCOOrpkguX
	XhvFfBHcISmTnBieK5U4wm3LVuGgkmJHsvH33I5AGm8KHjtJVGuN3ojvKBDWozDlbQeg1wNk2tXzG
	kLKk+pVw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u1jRu-00DTPL-1O;
	Mon, 07 Apr 2025 18:11:27 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 07 Apr 2025 18:11:26 +0800
Date: Mon, 07 Apr 2025 18:11:26 +0800
Message-Id: <a863078c2f4d8358c856f00fac5e041ef5f4bcbf.1744020575.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1744020575.git.herbert@gondor.apana.org.au>
References: <cover.1744020575.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 1/4] crypto: nx - Add missing header inclusions
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The gutting of crypto/ctr.h uncovered missing header inclusions.
Add them.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 drivers/crypto/nx/nx-aes-cbc.c | 8 +++++---
 drivers/crypto/nx/nx-aes-ctr.c | 8 +++++---
 drivers/crypto/nx/nx-aes-ecb.c | 8 +++++---
 drivers/crypto/nx/nx.c         | 4 ++--
 drivers/crypto/nx/nx.h         | 5 ++++-
 5 files changed, 21 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/nx/nx-aes-cbc.c b/drivers/crypto/nx/nx-aes-cbc.c
index 0e440f704a8f..35fa5bad1d9f 100644
--- a/drivers/crypto/nx/nx-aes-cbc.c
+++ b/drivers/crypto/nx/nx-aes-cbc.c
@@ -8,10 +8,12 @@
  */
 
 #include <crypto/aes.h>
-#include <crypto/algapi.h>
+#include <crypto/internal/skcipher.h>
+#include <linux/err.h>
+#include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/types.h>
-#include <linux/crypto.h>
+#include <linux/spinlock.h>
+#include <linux/string.h>
 #include <asm/vio.h>
 
 #include "nx_csbcpb.h"
diff --git a/drivers/crypto/nx/nx-aes-ctr.c b/drivers/crypto/nx/nx-aes-ctr.c
index dfa3ad1a12f2..709b3ee74657 100644
--- a/drivers/crypto/nx/nx-aes-ctr.c
+++ b/drivers/crypto/nx/nx-aes-ctr.c
@@ -9,10 +9,12 @@
 
 #include <crypto/aes.h>
 #include <crypto/ctr.h>
-#include <crypto/algapi.h>
+#include <crypto/internal/skcipher.h>
+#include <linux/err.h>
+#include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/types.h>
-#include <linux/crypto.h>
+#include <linux/spinlock.h>
+#include <linux/string.h>
 #include <asm/vio.h>
 
 #include "nx_csbcpb.h"
diff --git a/drivers/crypto/nx/nx-aes-ecb.c b/drivers/crypto/nx/nx-aes-ecb.c
index 502a565074e9..4039cf3b22d4 100644
--- a/drivers/crypto/nx/nx-aes-ecb.c
+++ b/drivers/crypto/nx/nx-aes-ecb.c
@@ -8,10 +8,12 @@
  */
 
 #include <crypto/aes.h>
-#include <crypto/algapi.h>
+#include <crypto/internal/skcipher.h>
+#include <linux/err.h>
+#include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/types.h>
-#include <linux/crypto.h>
+#include <linux/spinlock.h>
+#include <linux/string.h>
 #include <asm/vio.h>
 
 #include "nx_csbcpb.h"
diff --git a/drivers/crypto/nx/nx.c b/drivers/crypto/nx/nx.c
index a3b979193d9b..4e4a371ba390 100644
--- a/drivers/crypto/nx/nx.c
+++ b/drivers/crypto/nx/nx.c
@@ -7,11 +7,11 @@
  * Author: Kent Yoder <yoder1@us.ibm.com>
  */
 
+#include <crypto/aes.h>
 #include <crypto/internal/aead.h>
 #include <crypto/internal/hash.h>
-#include <crypto/aes.h>
+#include <crypto/internal/skcipher.h>
 #include <crypto/sha2.h>
-#include <crypto/algapi.h>
 #include <crypto/scatterwalk.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
diff --git a/drivers/crypto/nx/nx.h b/drivers/crypto/nx/nx.h
index e1b4b6927bec..b1f6634a1644 100644
--- a/drivers/crypto/nx/nx.h
+++ b/drivers/crypto/nx/nx.h
@@ -4,6 +4,9 @@
 #define __NX_H__
 
 #include <crypto/ctr.h>
+#include <crypto/internal/aead.h>
+#include <crypto/internal/hash.h>
+#include <crypto/internal/skcipher.h>
 
 #define NX_NAME		"nx-crypto"
 #define NX_STRING	"IBM Power7+ Nest Accelerator Crypto Driver"
@@ -139,7 +142,7 @@ struct nx_crypto_ctx {
 	} priv;
 };
 
-struct crypto_aead;
+struct scatterlist;
 
 /* prototypes */
 int nx_crypto_ctx_aes_ccm_init(struct crypto_aead *tfm);
-- 
2.39.5

