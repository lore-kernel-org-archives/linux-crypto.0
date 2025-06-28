Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6048821ADA4;
	Sat, 28 Jun 2025 04:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.95.48.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751084993; cv=none; b=IJMYhHtYbiTfAw3iASRyDvbNKTIa1yTUyhug9I9cNoK/NoX7dFKN8aOapvM7pxkkaHazRc9wZEpDbzNH3tsPBJlwMQTfHClQDigD0aBhyybDkKnaFBv+T+Pkw97ktqYtp3VgXfHlkhxZEtvJK9kUgqb4+aEUcRUBVTP3ZdumawU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751084993; c=relaxed/simple;
	bh=i57aY6b/VBwNfQr+17AgLcZaMScIYT7e7ELO0U+WDyk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z3PbRbzsKXwrrn8+50ygd1JrLu16KDSIeq9nKa5LeXW0k80toxS2TRMUX/7CsxS1VFTi+cXgFetevfSiSiYkdIZqMPHXhez57H6MDGxONeORGcevLZBlrUN9fQs3gZrFVdahzYg4h14jBHS4zGHqNCMHVCr3q2gaKq8TlEGR88s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=RcviS5Md; arc=none smtp.client-ip=52.95.48.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="RcviS5Md"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1751084992; x=1782620992;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Q1D7WWeaxaSCAsGUlZxiCe64pymHNFwC6tzuACqvdaQ=;
  b=RcviS5Mdt8B1PWxoES0T89C+XwB271Ulo/Jk6m4ZlZ1l+ZQln6L4WHoV
   eH4m64e7NCRJUfpRuXdoqeQvyRsyO3jCxdQzxL3Bs93ro9nhGXatAA9/8
   zRBRkFwl9udNiyZWuG1PIFGsNTLyur3gF6/2EdkzubHMeq3OJ4KK5AWcL
   PRcqMM4J7Maposz8zk8wHegd2YsSsXLK89PgUoa8XahfxoHP8qeqgqcJ4
   wDSxufnxfo2LHDBzw9RyBvj0TwKBZRpEPzKj1rmoT0ROaWIRd9/rXQy88
   36tbfrYFtpxjENkLxmLg163A3rM0vUqQ6YBK19idHomj190i6zDMwfhZJ
   A==;
X-IronPort-AV: E=Sophos;i="6.16,272,1744070400"; 
   d="scan'208";a="506296231"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.43.8.2])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2025 04:29:50 +0000
Received: from EX19MTAUWA001.ant.amazon.com [10.0.21.151:5420]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.0.172:2525] with esmtp (Farcaster)
 id 9584ed8d-f58c-46b2-b8b7-62010b839f54; Sat, 28 Jun 2025 04:29:49 +0000 (UTC)
X-Farcaster-Flow-ID: 9584ed8d-f58c-46b2-b8b7-62010b839f54
Received: from EX19D004UWA004.ant.amazon.com (10.13.138.200) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.217) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14;
 Sat, 28 Jun 2025 04:29:48 +0000
Received: from dev-dsk-wanjay-2c-d25651b4.us-west-2.amazon.com (172.19.198.4)
 by EX19D004UWA004.ant.amazon.com (10.13.138.200) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14;
 Sat, 28 Jun 2025 04:29:48 +0000
From: Jay Wang <wanjay@amazon.com>
To: <stable@vger.kernel.org>
CC: Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller"
	<davem@davemloft.net>, <linux-crypto@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <wanjay@amazon.com>, Herbert Xu
	<herbert.xu@redhat.com>, Samuel Mendoza-Jonas <samjonas@amazon.com>, "Elena
 Avila" <ellavila@amazon.com>
Subject: [PATCH 1/2] crypto: rng - Override drivers/char/random in FIPS mode
Date: Sat, 28 Jun 2025 04:29:17 +0000
Message-ID: <20250628042918.32253-2-wanjay@amazon.com>
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

From: Herbert Xu <herbert.xu@redhat.com>

Upstream: RHEL only
Bugzilla: 1984784

This patch overrides the drivers/char/random RNGs with the FIPS
RNG from Crypto API when FIPS mode is enabled.

Cc: stable@vger.kernel.org
Signed-off-by: Herbert Xu <herbert.xu@redhat.com>
(cherry picked from commit 37e0042aaf43d4494bcbea2113605366d0fe6187)
Signed-off-by: Samuel Mendoza-Jonas <samjonas@amazon.com>
[6.12: Resolve minor merge conflicts]
Signed-off-by: Elena Avila <ellavila@amazon.com>
---
 crypto/rng.c | 71 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 71 insertions(+)

diff --git a/crypto/rng.c b/crypto/rng.c
index 9d8804e46422..cdba806846e2 100644
--- a/crypto/rng.c
+++ b/crypto/rng.c
@@ -12,11 +12,14 @@
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
 #include <net/netlink.h>
@@ -217,5 +220,73 @@ void crypto_unregister_rngs(struct rng_alg *algs, int count)
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
+static int __init crypto_rng_init(void)
+{
+	if (fips_enabled)
+		random_register_extrng(&crypto_devrandom_rng);
+	return 0;
+}
+
+static void __exit crypto_rng_exit(void)
+{
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

