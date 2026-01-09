Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 815BB336EDA
	for <linux-crypto@vger.kernel.org>; Fri,  9 Jan 2026 12:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962232; cv=none; b=Ns/jhouUrlUm7Y9jJcvvyEmeXWHJTFzYpj9fllwF7eMSBHK8DG1RwyHdrCYDARMsRgvExZas0S+eCTEelVlI6PuUDM2kRXgzO6dcrmRxszgNaWXzBb7XY8wTA1JXwTFL5AeaSD20woDq9G8Okz3wt/F+3Rk2uGMdc+t9ajfeeq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962232; c=relaxed/simple;
	bh=2qehh8spQ78BT/TtILml7A8mWqFMKvKayvknOp8dt+c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HrlDHA0MwJbTeLxs9FaRI3h0ytQoWTjaX7t5PS7Bv8A7287TGgAJhsih5mqqO/ruEeHjN2pIE8xOGBvaWl0iDNCm/kltwgSYjW92zP6kXof+8E0Ynvq3E4LJSWUs5fD5BHSQdSVKPozlaSE1+gdmTkZU6X2JN70u5iRxmc5Jegs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xcvBYveD; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xcvBYveD"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767962218;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=KXR6/cPGYe+HxL32Q0437izcLNL83HrrAnfxhj6a3MA=;
	b=xcvBYveD3XwuZuqAVBRn6BUnqIvjGueGH14L684x3nFi5f30VvsDioWHH7OmMAtxTpeNUR
	WR9+j6XI+jLxkHXceNqd17VFrtBUzmj8yj5FmksUnpr+GFr1c3nGYTjiYrZD8mqRLS1ImJ
	9SeBu+4KsOSJCKroxAS1WV/byTyL3b4=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: omap - Use sysfs_emit in sysfs show functions
Date: Fri,  9 Jan 2026 13:36:40 +0100
Message-ID: <20260109123640.170491-1-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Replace sprintf() with sysfs_emit() in sysfs show functions.
sysfs_emit() is preferred to format sysfs output as it provides better
bounds checking.  No functional changes.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/crypto/omap-aes.c  | 3 ++-
 drivers/crypto/omap-sham.c | 5 +++--
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index 3cc802622dd5..3eadaf7a64fa 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -32,6 +32,7 @@
 #include <linux/pm_runtime.h>
 #include <linux/scatterlist.h>
 #include <linux/string.h>
+#include <linux/sysfs.h>
 #include <linux/workqueue.h>
 
 #include "omap-crypto.h"
@@ -1042,7 +1043,7 @@ static ssize_t queue_len_show(struct device *dev, struct device_attribute *attr,
 {
 	struct omap_aes_dev *dd = dev_get_drvdata(dev);
 
-	return sprintf(buf, "%d\n", dd->engine->queue.max_qlen);
+	return sysfs_emit(buf, "%d\n", dd->engine->queue.max_qlen);
 }
 
 static ssize_t queue_len_store(struct device *dev,
diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index ff8aac02994a..1ffc240e016a 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -37,6 +37,7 @@
 #include <linux/scatterlist.h>
 #include <linux/slab.h>
 #include <linux/string.h>
+#include <linux/sysfs.h>
 #include <linux/workqueue.h>
 
 #define MD5_DIGEST_SIZE			16
@@ -1973,7 +1974,7 @@ static ssize_t fallback_show(struct device *dev, struct device_attribute *attr,
 {
 	struct omap_sham_dev *dd = dev_get_drvdata(dev);
 
-	return sprintf(buf, "%d\n", dd->fallback_sz);
+	return sysfs_emit(buf, "%d\n", dd->fallback_sz);
 }
 
 static ssize_t fallback_store(struct device *dev, struct device_attribute *attr,
@@ -2003,7 +2004,7 @@ static ssize_t queue_len_show(struct device *dev, struct device_attribute *attr,
 {
 	struct omap_sham_dev *dd = dev_get_drvdata(dev);
 
-	return sprintf(buf, "%d\n", dd->queue.max_qlen);
+	return sysfs_emit(buf, "%d\n", dd->queue.max_qlen);
 }
 
 static ssize_t queue_len_store(struct device *dev,
-- 
Thorsten Blum <thorsten.blum@linux.dev>
GPG: 1D60 735E 8AEF 3BE4 73B6  9D84 7336 78FD 8DFE EAD4

