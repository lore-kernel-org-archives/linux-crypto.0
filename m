Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9345417A586;
	Sat, 12 Apr 2025 23:33:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744500785; cv=none; b=ecVOX5fPSVfebKMHYoTZ37y6aIopojJZfVhM4mgDhHiPUtN9bk9PgAs+40cgmXfzAsg2raSDpN4Va0l+TqqEz5/Pjh3HQRUIWhv8K3CzuKyavUWxYqc/+79BVvE2wmzWbwGCkaFZirOPH4AM8BNWWWjzJ65l2q+WU0OR/7fgkwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744500785; c=relaxed/simple;
	bh=ZPH/e/v6NifavB3+ggOqjwMMFpXaeZxe2UFED02ot1A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bVu80jviBncbNf6shDXwfDa/2bg6gICRjYvq/vmv7y45m74pGJS/oTGoq6XjZhaQw+RwLqyC+q0ggabIC6qrMFr/TeMSBRWVz/Pgz+bpmi74tM7yDMI3q1mqSnGFo/CfWxwkwryKA2OmSkCY2x6d3hx8wluHZlgTajZvZGBQDow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=i/7kPVAx; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="i/7kPVAx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=MIME-Version:Message-ID:Date:Subject:From:Content-Type:From
	:Subject; bh=lSowut/bbGT9X2CX8uCJCqJot1poQOhEcYPmM/0qq+s=; b=i/7kPVAxJJA+HC9V
	708bSBXwlhqSIiwiV/fV4uCY0XL3wHgoRIZqOQpJ/dWR/Cg2SRPvOU7G0CDhcoaMp7YSJH0NYbUf/
	IkuZif9HEDXxQLW7LFFaDFZxyk44MAOi89BIYV0avrW14GWtkOc3/p9/m7VMZnnCoW23KpCvZb6D9
	uG/JSiMGF0I0vGwxCdqmQEAqUsyi99++hipF6eYF/TM3ebAmcQr6nzXqTpZc65pNDUtlNN9/IufpF
	yutUFBTf5I18t5zAZr7K67IFBqrp6SPVr2QgFnqTd7BwKxSeNMRQ/tAWQr5DwzSI+PQWUHBrCGZR0
	RSgr6DeLH9hvvCJ+iA==;
Received: from localhost ([127.0.0.1] helo=dalek.home.treblig.org)
	by mx.treblig.org with esmtp (Exim 4.96)
	(envelope-from <linux@treblig.org>)
	id 1u3kL8-00Atqa-1v;
	Sat, 12 Apr 2025 23:32:46 +0000
From: linux@treblig.org
To: ardb@kernel.org,
	haren@us.ibm.com,
	herbert@gondor.apana.org.au,
	davem@davemloft.net
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Dr. David Alan Gilbert" <linux@treblig.org>
Subject: [PATCH] crypto: deadcode structs from 'comp' removal
Date: Sun, 13 Apr 2025 00:32:41 +0100
Message-ID: <20250412233241.1167401-1-linux@treblig.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Dr. David Alan Gilbert" <linux@treblig.org>

Ard's recent series of patches removing 'comp' implementations
left behind a bunch of trivial structs, remove them.

These are:
  crypto842_ctx - commit 2d985ff0072f ("crypto: 842 - drop obsolete 'comp'
implementation")
  lz4_ctx       - commit 33335afe33c9 ("crypto: lz4 - drop obsolete 'comp'
implementation")
  lz4hc_ctx     - commit dbae96559eef ("crypto: lz4hc - drop obsolete
'comp' implementation")
  lzo_ctx       - commit a3e43a25bad0 ("crypto: lzo - drop obsolete
'comp' implementation")
  lzorle_ctx    - commit d32da55c5b0c ("crypto: lzo-rle - drop obsolete
'comp' implementation")

Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
---
 crypto/842.c     | 4 ----
 crypto/lz4.c     | 4 ----
 crypto/lz4hc.c   | 4 ----
 crypto/lzo-rle.c | 4 ----
 crypto/lzo.c     | 4 ----
 5 files changed, 20 deletions(-)

diff --git a/crypto/842.c b/crypto/842.c
index 5fb37a925989..881945d44328 100644
--- a/crypto/842.c
+++ b/crypto/842.c
@@ -23,10 +23,6 @@
 #include <linux/module.h>
 #include <linux/sw842.h>
 
-struct crypto842_ctx {
-	void *wmem;	/* working memory for compress */
-};
-
 static void *crypto842_alloc_ctx(void)
 {
 	void *ctx;
diff --git a/crypto/lz4.c b/crypto/lz4.c
index 82588607fb2e..9661ed01692f 100644
--- a/crypto/lz4.c
+++ b/crypto/lz4.c
@@ -12,10 +12,6 @@
 #include <linux/lz4.h>
 #include <crypto/internal/scompress.h>
 
-struct lz4_ctx {
-	void *lz4_comp_mem;
-};
-
 static void *lz4_alloc_ctx(void)
 {
 	void *ctx;
diff --git a/crypto/lz4hc.c b/crypto/lz4hc.c
index 997e76c0183a..a637fddc1ccd 100644
--- a/crypto/lz4hc.c
+++ b/crypto/lz4hc.c
@@ -10,10 +10,6 @@
 #include <linux/vmalloc.h>
 #include <linux/lz4.h>
 
-struct lz4hc_ctx {
-	void *lz4hc_comp_mem;
-};
-
 static void *lz4hc_alloc_ctx(void)
 {
 	void *ctx;
diff --git a/crypto/lzo-rle.c b/crypto/lzo-rle.c
index b1350ae278b8..e7efcf107179 100644
--- a/crypto/lzo-rle.c
+++ b/crypto/lzo-rle.c
@@ -9,10 +9,6 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 
-struct lzorle_ctx {
-	void *lzorle_comp_mem;
-};
-
 static void *lzorle_alloc_ctx(void)
 {
 	void *ctx;
diff --git a/crypto/lzo.c b/crypto/lzo.c
index dfe5a07ca35f..f1b36a1ca6f6 100644
--- a/crypto/lzo.c
+++ b/crypto/lzo.c
@@ -9,10 +9,6 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 
-struct lzo_ctx {
-	void *lzo_comp_mem;
-};
-
 static void *lzo_alloc_ctx(void)
 {
 	void *ctx;
-- 
2.49.0

