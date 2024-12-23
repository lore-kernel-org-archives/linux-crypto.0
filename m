Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD9B6624
	for <linux-crypto@vger.kernel.org>; Mon, 23 Dec 2024 07:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734940485; cv=none; b=MJRYk+h4rkhJRh+erP3pPMxT0wrosbtNR+adgZOvCIZC/7BhfKQD7fEDZAgHv2kTRv+bi8kxvMw1cA3aOW3q3+cgHcBUeeVinUvrbgoofES5fFS1enpETwUWXIbLr5RxbpD7zUqQoSW5la5OT8W2zQps1j7V4HWFy1RCWz/6BAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734940485; c=relaxed/simple;
	bh=Nmi7L7mSBoifqD9YyWbTtM3sPONzHLG4WM6kGpBFWnA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IaBvCmaorinT8jfVduCy+OZ3akAlXEVUcNtqM5BEf8Pv0/y3125/PDzbbrMcdmoUPXFAm7EZ23aerUBY+oeaKYmfBg/WVC8C1gqpRO8ngAAW5kZKrQ1EejbbzP8B2BqUMYq/P8yUyOp12EU1kRxhs2t8NRTBX5ujODzZRcBJgVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=phoKGfbW; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="phoKGfbW"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1734940480;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=oxozabtdLqGpWHIGBtKzCeSM1qSjFnULALmYBoJIHRY=;
	b=phoKGfbWpcPCVoC9gKsu2jRIPOI0yTPMVIzaVEFE5zSOnFO0tHPT6XaqcxlYEfluWAIWmZ
	eTUipT+qjvIWNK6vYRR7dfBVRhcS8Rg70a/8Xrw7nqw3K2QiR/IqwRTgfKY7ND285Cghun
	8GWw7PQ8BVQUjzS/1sbrXKLAgEDkEnM=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: fips - Use str_enabled_disabled() helper in fips_enable()
Date: Mon, 23 Dec 2024 08:54:11 +0100
Message-ID: <20241223075410.405632-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Remove hard-coded strings by using the str_enabled_disabled() helper
function.

Use pr_info() instead of printk(KERN_INFO) to silence a checkpatch
warning.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 crypto/fips.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/fips.c b/crypto/fips.c
index 8a784018ebfc..a58e7750f532 100644
--- a/crypto/fips.c
+++ b/crypto/fips.c
@@ -12,6 +12,7 @@
 #include <linux/kernel.h>
 #include <linux/sysctl.h>
 #include <linux/notifier.h>
+#include <linux/string_choices.h>
 #include <generated/utsrelease.h>
 
 int fips_enabled;
@@ -24,8 +25,7 @@ EXPORT_SYMBOL_GPL(fips_fail_notif_chain);
 static int fips_enable(char *str)
 {
 	fips_enabled = !!simple_strtol(str, NULL, 0);
-	printk(KERN_INFO "fips mode: %s\n",
-		fips_enabled ? "enabled" : "disabled");
+	pr_info("fips mode: %s\n", str_enabled_disabled(fips_enabled));
 	return 1;
 }
 
-- 
2.47.1

