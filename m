Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB2132C21FF
	for <linux-crypto@vger.kernel.org>; Tue,  5 May 2026 09:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777974417; cv=none; b=jA6oM/jkstVpGe+mj8/IAwZ+uAQDcSe36ak2VerAwtzKJUMwCfagPIWOxKDY+HlkwSSb/wzXZ/ZYi+Y944a/CE+y9ghWnu4tgdtHSXOfrfmgPtF5xfu3npy5R3AgMejfSZxvhgDEhqNLpZlwzZLZ7DC9r2qOcYD+EKkVK49NX9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777974417; c=relaxed/simple;
	bh=KldV5wsJquMvrGYc/a3OtzhDmzeSx0siiHjVGIloIVc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iQhSWpgeF1cSJy3uTCSzLz/aigVGQ+ki0ezUtGcL9s81ESWh+2IUE4lYYRTo6xHysh55wXBv/+WQIwjDkz1U7WXmKsn97cvCc7caudljJJK2u/HL0VlekwQVR/bq84UgF1Rfy25pHgMvYlJXsFzQGSyB7Q+Rh1+tMprZK5hqjPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=BNuC2yvI; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="BNuC2yvI"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777974414;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2iNP/d54Vkczsnl6tfHWb49/CSrLhW3Q2n4mkjVYy6Q=;
	b=BNuC2yvIAWvVPrGi9X1a8vx2vPExqWgXVvyUx2SSL7iTrv9cT3MGFLX8aQmcahjXaq/AMZ
	QB552SD4meowa6IuePGy4ZLKOlL6jSDr3ouVaEaOOCUixJXUq0SwxZYE4PF8DMYp+m6kgu
	yIcNvXAbf4SVDlBEGxiLz98OBZ/gSvo=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Lianjie Wang <karin0.zst@gmail.com>,
	Jonathan McDowell <noodles@meta.com>,
	David Laight <david.laight.linux@gmail.com>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/4] hwrng: core - use sysfs_emit_at in rng_available_show
Date: Tue,  5 May 2026 11:45:58 +0200
Message-ID: <20260505094555.158017-9-thorsten.blum@linux.dev>
In-Reply-To: <20260505094555.158017-6-thorsten.blum@linux.dev>
References: <20260505094555.158017-6-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1840; i=thorsten.blum@linux.dev; h=from:subject; bh=KldV5wsJquMvrGYc/a3OtzhDmzeSx0siiHjVGIloIVc=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDJk/98T4HNwgmPtdnclknmcBW3Cj3OX9KznKTz/em7Sgc +2CTr+nHSUsDGJcDLJiiiwPZv2Y4VtaU7nJJGInzBxWJpAhDFycAjCRuVsY/soLNH31uzNDx+Gf d8rWX6J8HVN053p7M5fLyYrOu8e2t4bhu5vVl5nOtza68+1aEBRy58zUxupjR0Q5IkRb1dPV+qt YAQ==
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Replace strlcat() with sysfs_emit_at() in rng_available_show() and add
'int len' to keep track of the number of bytes written. sysfs_emit_at()
is preferred for formatting sysfs output because it provides safer
bounds checking.

Inline mutex_lock_interruptible() and drop the now-unused local error
variable. Remove the unnecessary 'buf' NUL initialization. Return 'len'
directly instead of strlen(buf).

Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
No changes in patch 4/4.
---
 drivers/char/hw_random/core.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index 26c46cd90a83..6931657ad2ca 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -25,6 +25,7 @@
 #include <linux/sched/signal.h>
 #include <linux/slab.h>
 #include <linux/string.h>
+#include <linux/sysfs.h>
 #include <linux/uaccess.h>
 #include <linux/workqueue.h>
 
@@ -414,21 +415,17 @@ static ssize_t rng_available_show(struct device *dev,
 				  struct device_attribute *attr,
 				  char *buf)
 {
-	int err;
 	struct hwrng *rng;
+	int len = 0;
 
-	err = mutex_lock_interruptible(&rng_mutex);
-	if (err)
+	if (mutex_lock_interruptible(&rng_mutex))
 		return -ERESTARTSYS;
-	buf[0] = '\0';
-	list_for_each_entry(rng, &rng_list, list) {
-		strlcat(buf, rng->name, PAGE_SIZE);
-		strlcat(buf, " ", PAGE_SIZE);
-	}
-	strlcat(buf, "none\n", PAGE_SIZE);
+	list_for_each_entry(rng, &rng_list, list)
+		len += sysfs_emit_at(buf, len, "%s ", rng->name);
+	len += sysfs_emit_at(buf, len, "none\n");
 	mutex_unlock(&rng_mutex);
 
-	return strlen(buf);
+	return len;
 }
 
 static ssize_t rng_selected_show(struct device *dev,
