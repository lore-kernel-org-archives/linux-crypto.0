Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E8712D130C;
	Mon, 30 Jun 2025 18:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.95.48.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751306600; cv=none; b=usVEX8Ft+AtBuIpXrGflSdxssSRBxih5cE6+CBuCa/SePN0IS2xaeByknojKYzLCHreFSD1l4b2SGHCCxJQBEHYedooZYP/ibezExBYs816q4vMTboPGwzoy57W8AcbEW2pOkaUKCROU3T52DAtN8YvC3PkZhRJpBKmY6YDfOm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751306600; c=relaxed/simple;
	bh=VtPaEHzbsyjPMZDdP3QKpoxuzh4twYay+OHSIwMrjuw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UgX2ihjPf83Es2bejvmMcCtxa3zsXgjvdanZf8xSk6JoSNd4xu86AddlZ0dLSD9BFzlMF6cQxV0A2GpkuOu7UIufwInjzvw/AKVkMb9zQv8artg0ANKFRZmacGHyNXxmtM4RN4+wYC3fmaTe9iJPBEoCpYp89dy5XIvyrtWPYq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=UFblBnD9; arc=none smtp.client-ip=52.95.48.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="UFblBnD9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1751306599; x=1782842599;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+KU6P32loWkjmTFz+91f6FsWSqT3kUZVgcNSP0/qzyE=;
  b=UFblBnD91o0D2yDeEKzsJ2x48101/VEz1d4o1bsZpsrfZAClFDHEQS6m
   x9QCCSo98AbPSIjeo3yhWP6Ghh1aVEoCQS1VSzrkXfd28qUG0oeeHeWZP
   hEX1DBZWSqjDNDFvZClWejd6x7pL00/Ju7UlwITWJx0IXbXK6nIdAUkUx
   w/gNAvkEeAgTAmyWgdrhqp0j0jJjS574u0TDItfaKXjubEDYtzFa1W3B5
   b5KA7u7EEDtpyzftswjWeLZMDO7JZecFJvtKf5YsBjQrtjirPto3kX1hL
   3YqXffI8l72m7xZqtRpBDNGTRCi/2ZPUByKoaMtHzBTG+6+9dOPu6DGhl
   w==;
X-IronPort-AV: E=Sophos;i="6.16,278,1744070400"; 
   d="scan'208";a="506687353"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.43.8.2])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2025 18:03:17 +0000
Received: from EX19MTAUWA001.ant.amazon.com [10.0.21.151:26987]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.23.203:2525] with esmtp (Farcaster)
 id 14511fd0-6069-4d10-94a0-ca7564394bf2; Mon, 30 Jun 2025 18:03:15 +0000 (UTC)
X-Farcaster-Flow-ID: 14511fd0-6069-4d10-94a0-ca7564394bf2
Received: from EX19D004UWA004.ant.amazon.com (10.13.138.200) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.217) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14;
 Mon, 30 Jun 2025 18:03:15 +0000
Received: from dev-dsk-wanjay-2c-d25651b4.us-west-2.amazon.com (172.19.198.4)
 by EX19D004UWA004.ant.amazon.com (10.13.138.200) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14;
 Mon, 30 Jun 2025 18:03:14 +0000
From: Jay Wang <wanjay@amazon.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<wanjay@amazon.com>
Subject: [PATCH v6.12 2/2] crypto: rng - Override drivers/char/random only after FIPS RNGs available
Date: Mon, 30 Jun 2025 18:03:12 +0000
Message-ID: <20250630180312.24627-3-wanjay@amazon.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250630180312.24627-1-wanjay@amazon.com>
References: <20250630180312.24627-1-wanjay@amazon.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D044UWA001.ant.amazon.com (10.13.139.100) To
 EX19D004UWA004.ant.amazon.com (10.13.138.200)

This commit overrides the drivers/char/random RNGs with the FIPS RNG
from Crypto API when FIPS mode is enabled. This commit is developed
based on a previous commit "crypto: rng - Override drivers/char/random
in FIPS mode", but it has a timing issue where the crypto RNG was
attempting to override the drivers/char/random interface before the
default RNG became available. The previous implementation would
immediately register the external RNG during module initialization,
which could fail if the default RNG wasn't ready.

Changes compared to previous commit:
- Introduce workqueue-based initialization for FIPS mode
- Add crypto_rng_register_work_func() to wait for default RNG
  availability
- Move random_register_extrng() call to the work function with proper
  error handling

This ensures the crypto ext RNG is properly registered only after all
dependencies are satisfied, preventing potential boot failures in
FIPS-enabled environments.

Cc: stable@vger.kernel.org
Signed-off-by: Jay Wang <wanjay@amazon.com>
---
 crypto/rng.c | 92 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 92 insertions(+)

diff --git a/crypto/rng.c b/crypto/rng.c
index 9d8804e46422..250166d67fd0 100644
--- a/crypto/rng.c
+++ b/crypto/rng.c
@@ -12,13 +12,17 @@
 #include <linux/atomic.h>
 #include <linux/cryptouser.h>
 #include <linux/err.h>
+#include <linux/fips.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/random.h>
 #include <linux/seq_file.h>
+#include <linux/sched.h>
+#include <linux/sched/signal.h>
 #include <linux/slab.h>
 #include <linux/string.h>
+#include <linux/workqueue.h>
 #include <net/netlink.h>

 #include "internal.h"
@@ -217,5 +221,93 @@ void crypto_unregister_rngs(struct rng_alg *algs, int count)
 }
 EXPORT_SYMBOL_GPL(crypto_unregister_rngs);

+static ssize_t crypto_devrandom_read(void __user *buf, size_t buflen)
+{
+	u8 tmp[256];
+	ssize_t ret;
+
+	if (!buflen)
+		return 0;
+
+	ret = crypto_get_default_rng();
+	if (ret)
+		return ret;
+
+	for (;;) {
+		int err;
+		int i;
+
+		i = min_t(int, buflen, sizeof(tmp));
+		err = crypto_rng_get_bytes(crypto_default_rng, tmp, i);
+		if (err) {
+			ret = err;
+			break;
+		}
+
+		if (copy_to_user(buf, tmp, i)) {
+			ret = -EFAULT;
+			break;
+		}
+
+		buflen -= i;
+		buf += i;
+		ret += i;
+
+		if (!buflen)
+			break;
+
+		if (need_resched()) {
+			if (signal_pending(current))
+				break;
+			schedule();
+		}
+	}
+
+	crypto_put_default_rng();
+	memzero_explicit(tmp, sizeof(tmp));
+
+	return ret;
+}
+
+static const struct random_extrng crypto_devrandom_rng = {
+	.extrng_read = crypto_devrandom_read,
+	.owner = THIS_MODULE,
+};
+
+static struct work_struct crypto_rng_register_work;
+
+static void crypto_rng_register_work_func(struct work_struct *work)
+{
+	/* Wait until default rng becomes avaiable, then
+		Overwrite the extrng.
+	*/
+	int ret = crypto_get_default_rng();
+	if (ret){
+		printk(KERN_ERR "crypto_rng: Failed to get default RNG (error %d)\n", ret);
+		return;
+	}
+	printk(KERN_INFO "Overwrite extrng\n");
+	random_register_extrng(&crypto_devrandom_rng);
+}
+
+static int __init crypto_rng_init(void)
+{
+	if (fips_enabled) {
+		INIT_WORK(&crypto_rng_register_work, crypto_rng_register_work_func);
+		schedule_work(&crypto_rng_register_work);
+	}
+
+	return 0;
+}
+
+static void __exit crypto_rng_exit(void)
+{
+	cancel_work_sync(&crypto_rng_register_work);
+	random_unregister_extrng();
+}
+
+late_initcall(crypto_rng_init);
+module_exit(crypto_rng_exit);
+
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Random Number Generator");
--
2.47.1

