Received: from smtp-fw-9106.amazon.com (smtp-fw-9106.amazon.com [207.171.188.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0918F21C165;
	Sat, 28 Jun 2025 04:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.171.188.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751084993; cv=none; b=YH09v6MbGMQjYk25bISfNd/PBzSWfjkgl7ypqJ5ZHB5c06vC4XmiMWTJ1yJolY5GuKiS5xZXfN3Y5JYoavcrsEzjG3EzLlfu9iKDtZ56axVbtq+O/YGqOQlLNBwn3vjViulJ9PMIk9afTOrdQiyOb2ngtwA/aJW7nflaH9zgoZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751084993; c=relaxed/simple;
	bh=i77A5XCUHcIOVt0/cWC91d2Ce6ppRLjHadDh4nLSPOk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MO8QdQyRlGs6isqqCEwIc9JBtq+SDimvxyRi496sHtty0IGBoeD1oYXODCbfZhHupTB6w1QjDmccAabewi/1Rar8UzWcAIne0Gqd0WvgTOwKiovlKcGsZazlipsg7cZkQIn6/qfDMoaZ4Tf8aPtTMz+wjlGUC95dXwWQP0foTdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=JIVV2Yfm; arc=none smtp.client-ip=207.171.188.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="JIVV2Yfm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1751084992; x=1782620992;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JtmtAgjT6GrKggVQt5ZyPqF9++lDcxTJnobwkrZbgn0=;
  b=JIVV2YfmT5n27qSl7Aygu+a157ODvHQqC+YOcgpDLFpMTqn534WohHrs
   6PzhgASCs49TYtGXp5ujN2Trqjpk4BeNMRqSjLLpuVqCMkajwYpWOwnce
   HabPxOKHSNnjvG9eqX3SbGdqQ1HjSMOWVi/Cwo+Q1jadOIZpD7OvFVe4y
   Vh65wX4x5wf1qIcFEN605gUpAZBBmFNyn57OKTrJ9G/sznwLOu5QfrFM/
   Ydb3SUHCflS+kNULAHJ7c93PYZeaKDVAyYPvkxoO3cR+RmJNlYUvqWAtz
   txcplF5IdQ/PmacnvRSrol86iITq9GPjDU4DSR6/ksFsKcJ+RZs9KOxJN
   Q==;
X-IronPort-AV: E=Sophos;i="6.16,272,1744070400"; 
   d="scan'208";a="838949078"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.25.36.210])
  by smtp-border-fw-9106.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2025 04:29:51 +0000
Received: from EX19MTAUWC001.ant.amazon.com [10.0.21.151:17730]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.0.172:2525] with esmtp (Farcaster)
 id 0580bc00-561e-4033-8d3b-c6d5dcacd8f4; Sat, 28 Jun 2025 04:29:51 +0000 (UTC)
X-Farcaster-Flow-ID: 0580bc00-561e-4033-8d3b-c6d5dcacd8f4
Received: from EX19D004UWA004.ant.amazon.com (10.13.138.200) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14;
 Sat, 28 Jun 2025 04:29:51 +0000
Received: from dev-dsk-wanjay-2c-d25651b4.us-west-2.amazon.com (172.19.198.4)
 by EX19D004UWA004.ant.amazon.com (10.13.138.200) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14;
 Sat, 28 Jun 2025 04:29:50 +0000
From: Jay Wang <wanjay@amazon.com>
To: <stable@vger.kernel.org>
CC: Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller"
	<davem@davemloft.net>, <linux-crypto@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <wanjay@amazon.com>
Subject: [PATCH 2/2] Override drivers/char/random only after FIPS-mode RNGs become available
Date: Sat, 28 Jun 2025 04:29:18 +0000
Message-ID: <20250628042918.32253-3-wanjay@amazon.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250628042918.32253-1-wanjay@amazon.com>
References: <20250628042918.32253-1-wanjay@amazon.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D037UWC001.ant.amazon.com (10.13.139.197) To
 EX19D004UWA004.ant.amazon.com (10.13.138.200)

This commit fixes a timing issue introduced in the previous commit
"crypto: rng - Override drivers/char/random in FIPS mode" where the crypto RNG
was attempting to override the drivers/char/random interface before the default
RNG became available. The previous implementation would immediately register the
external RNG during module initialization, which could fail if the default RNG
wasn't ready.

Changes:
- Introduce workqueue-based initialization for FIPS mode
- Add crypto_rng_register_work_func() to wait for default RNG availability
- Move random_register_extrng() call to the work function with proper error handling

This ensures the crypto ext RNG is properly registered only after all dependencies
 are satisfied, preventing potential boot failures in FIPS-enabled environments.

Cc: stable@vger.kernel.org
Signed-off-by: Jay Wang <wanjay@amazon.com>
---
 crypto/rng.c | 25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/crypto/rng.c b/crypto/rng.c
index cdba806846e2..250166d67fd0 100644
--- a/crypto/rng.c
+++ b/crypto/rng.c
@@ -22,6 +22,7 @@
 #include <linux/sched/signal.h>
 #include <linux/slab.h>
 #include <linux/string.h>
+#include <linux/workqueue.h>
 #include <net/netlink.h>
 
 #include "internal.h"
@@ -273,15 +274,35 @@ static const struct random_extrng crypto_devrandom_rng = {
 	.owner = THIS_MODULE,
 };
 
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
 static int __init crypto_rng_init(void)
 {
-	if (fips_enabled)
-		random_register_extrng(&crypto_devrandom_rng);
+	if (fips_enabled) {
+		INIT_WORK(&crypto_rng_register_work, crypto_rng_register_work_func);
+		schedule_work(&crypto_rng_register_work);
+ 	}
+		
 	return 0;
 }
 
 static void __exit crypto_rng_exit(void)
 {
+	cancel_work_sync(&crypto_rng_register_work);
 	random_unregister_extrng();
 }
 
-- 
2.47.1

