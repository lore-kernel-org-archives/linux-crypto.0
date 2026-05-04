Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2C121A23A6;
	Mon,  4 May 2026 13:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777899857; cv=none; b=VJ8F8dBCwDAK5hksQM9zTAn8I/XZkmrhzs/KMjn0HR7uz87g2b/udbgI1fbeI3FAB12CXMmSRz7+5TlknBDtU7zvHxIrH/2JerOC3AZEaN83xYmEDwwaMFdWYjc92+Rla5yYgTCgLnWDABLw1MZDa6WT/Y4icJ0SLMkDV1rONGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777899857; c=relaxed/simple;
	bh=ZWCjcXSWq3NJ9r4XZojtNF650LUxvaS95/9Kx0tsl8I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Qk7QHUl/pUWWm4hbps9TgtZn/7wfUUsVg/j18xQfkXhyVXRGTaH8+5+RqZSDXKgq/3gurkgI1Wl2ePRQnxB0AzoKataCdAo24NtNvVOFsMTv/LGBvlKsZTo/rbYEwEp4tsAWEmY/y6k4sG9ySOuhGWlPuSHsF6cn5RrXPgnwXSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EuK7RQV4; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EuK7RQV4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777899855; x=1809435855;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ZWCjcXSWq3NJ9r4XZojtNF650LUxvaS95/9Kx0tsl8I=;
  b=EuK7RQV4ebIfpixJPeF+ywy8CdO7w8dD7GptIY02pJo4iu4BOWyZy8zU
   iGIjCfvqDqweG3Yil5vJ/LV+AhBOH+ITsvrH1VkA+mZX1IPuGTzJ617tw
   jrqj0v6WcJ2O9JmQTpHCN1ne/RpHCJkHAad1AsSvaCeO8OqhfT60fD+D0
   v1YZ9eq9qEmTRAqeY+Clco22JMzdMs4m4nzzic+qraHkYSIcsXtbub2tK
   RX7DOGk6cbrPB8xeKI22B0dkvFT8j8q+SEIbK0kUz4vNlHMknGC1/jC2B
   NuZQl67ChT2kPau4LBN/RKkLsn2pe0+lrMy+hbjvDrYI9QW2ju2VmBWqp
   Q==;
X-CSE-ConnectionGUID: 8oxkZSHNT9SZX7L4TUV6zw==
X-CSE-MsgGUID: GcQIJ3c9TG6Dyb8ycGqFLw==
X-IronPort-AV: E=McAfee;i="6800,10657,11776"; a="78745721"
X-IronPort-AV: E=Sophos;i="6.23,215,1770624000"; 
   d="scan'208";a="78745721"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2026 06:04:14 -0700
X-CSE-ConnectionGUID: adPfvxA8Re2Kn5akDRzP0w==
X-CSE-MsgGUID: asrbLTf5Q22fdcn3hEXAhg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,215,1770624000"; 
   d="scan'208";a="235564781"
Received: from black.igk.intel.com ([10.91.253.5])
  by orviesa009.jf.intel.com with ESMTP; 04 May 2026 06:04:12 -0700
Received: by black.igk.intel.com (Postfix, from userid 1003)
	id 03B5B98; Mon, 04 May 2026 15:04:11 +0200 (CEST)
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Lianjie Wang <karin0.zst@gmail.com>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Olivia Mackall <olivia@selenic.com>,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Manuel Ebner <manuelebner@mailbox.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 1/1] hwrng: core - Replace strlcat() with better alternative
Date: Mon,  4 May 2026 15:02:59 +0200
Message-ID: <20260504130259.473382-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

strlcpy() and strlcat() are confusing APIs and the former one already
gone from the kernel.

In preparation to kill strlcat() replace it with the better alternative.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/char/hw_random/core.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index aba92d777f72..c789699bd773 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -418,21 +418,21 @@ static ssize_t rng_available_show(struct device *dev,
 				  struct device_attribute *attr,
 				  char *buf)
 {
+	int len = 0;
 	int err;
 	struct hwrng *rng;
 
 	err = mutex_lock_interruptible(&rng_mutex);
 	if (err)
 		return -ERESTARTSYS;
-	buf[0] = '\0';
-	list_for_each_entry(rng, &rng_list, list) {
-		strlcat(buf, rng->name, PAGE_SIZE);
-		strlcat(buf, " ", PAGE_SIZE);
-	}
-	strlcat(buf, "none\n", PAGE_SIZE);
+
+	list_for_each_entry(rng, &rng_list, list)
+		len += sysfs_emit_at(buf, len, "%s ", rng->name);
+	len += sysfs_emit_at(buf, len, "none\n");
+
 	mutex_unlock(&rng_mutex);
 
-	return strlen(buf);
+	return len;
 }
 
 static ssize_t rng_selected_show(struct device *dev,
-- 
2.50.1

