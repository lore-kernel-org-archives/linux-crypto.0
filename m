Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 412493D903E
	for <linux-crypto@vger.kernel.org>; Thu, 30 Apr 2026 11:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777546955; cv=none; b=rmYyySYpFIL/1K36Zfr560gBZWZ0pxeRq3yIdZkF/xu0VL1kucLHufr1Fgkxsx564ZOlsC7c0VCmphAjiaFD9T0yI177NF2fKfwkOFQho2+yZYPH12WkKQJn/jhcdcAk4uTWFg1CQ5C8O+uaEWX6OAEkaK9p+SvWlwc1x6tyXUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777546955; c=relaxed/simple;
	bh=mMLxCQg3uSgP9sAnyHbBI0tYaS0PJJnfQKyQVqDMYvY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K6ARBrcTDBKc779AqgRgtiYn6pFjYJmMLATiAOpnpZuQmLgQBamWwodjxJQnwOnZY7rPZiX9HagaOp+vv1NsPf6NfYK7rNP6v8e1qkqyBj2RlkQP9ieb+XapG5z4cgjMrfDjVx5ZxF//lahmzZ3TrV76sfz5GHo3l+xaxQqwdb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=frj02aOF; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="frj02aOF"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777546949;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=blgMpnTY/4zk0W1xqmkpcGBJmBbswOZExfGTuwRoF5Y=;
	b=frj02aOFJa1zJD54L7mG/Bmv2uJgLU/M/IfI0cP4wysHEBWj4GCOGJPXbju3MmV7BvsLmX
	T0DZxjlvRjoKxbJGMvMEkeDEjxwsu+W/XHy0pX4ZwGqp6a6VEtPhmzyrrg2hKBhqmPWAtc
	ZmvEJeMfHNq7k5BIDxv+GbPhJ+MDKjs=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Thorsten Blum <thorsten.blum@linux.dev>
Subject: [PATCH 4/4] hwrng: core - use sysfs_emit_at in rng_available_show
Date: Thu, 30 Apr 2026 13:00:51 +0200
Message-ID: <20260430110047.248825-8-thorsten.blum@linux.dev>
In-Reply-To: <20260430110047.248825-5-thorsten.blum@linux.dev>
References: <20260430110047.248825-5-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1749; i=thorsten.blum@linux.dev; h=from:subject; bh=mMLxCQg3uSgP9sAnyHbBI0tYaS0PJJnfQKyQVqDMYvY=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDJmfzRLcSiN6163/x6u2spDx29NZz2PbrOboHPqVXa/S5 Xf0Ir9nRykLgxgXg6yYIsuDWT9m+JbWVG4yidgJM4eVCWQIAxenAExE9hzDP9Xd89cKLijdUZix wdrNasfxPTJT9lgu2D9FZYLT2q8OR2oZGW6ffXxM+Poy05I01UtnHVbaGvXpf5QI5v7jtkr4i0L 6ZX4A
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

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/char/hw_random/core.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index f8f7a2ee73c1..1d1ea4ebde31 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -26,6 +26,7 @@
 #include <linux/sched/signal.h>
 #include <linux/slab.h>
 #include <linux/string.h>
+#include <linux/sysfs.h>
 #include <linux/uaccess.h>
 #include <linux/workqueue.h>
 
@@ -415,21 +416,17 @@ static ssize_t rng_available_show(struct device *dev,
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
