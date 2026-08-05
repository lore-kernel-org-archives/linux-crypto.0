Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA3093E8C65;
	Wed,  5 Aug 2026 21:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785964815; cv=none; b=adJPNFrfpR/eMXnAOCVCBDyvl9uyKnFbgyjXSNqEcpOrWLmXb8MZ7EL8llsGRJ0C834xjT4jk67uGlo15jhgWk8iZWtEEOVDFIhu/BF40yu7fo8drOrqHQ/drdrSA1aNjkS3jCbQ9clbdz5hn5aEVjH85Mc6LFZNhTXPRpvIg0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785964815; c=relaxed/simple;
	bh=Bkj/TkmC38OQHd9BxPXJNS5cfJdj/J4ToKSU/+HlcOs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=jXM8Hd9UNqEI4dMbjxhczc3asD4OvU1L+3+tEzKQCumdo6UUffJ7fQx2fZDlrs+D8pLS7ngDwBeoP3t9bvfUfT+NPXX4xGn5vTY5ck1yS3eTY7iXljVRHAC1GYixvLtfjaSWGa7DDyDXoBc2pAAjNCqoE6hmNyTwSEyHmSfLLfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ob5o5lsq; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ob5o5lsq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785964808; x=1817500808;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=Bkj/TkmC38OQHd9BxPXJNS5cfJdj/J4ToKSU/+HlcOs=;
  b=Ob5o5lsq//DIAFZ0odCWFPjbS0lLfucsamJBVfuC/tlBBEcNsUU/77IK
   NIA9dSCIRb9Q5Sma6UfWukQT5aaDSfqUWC/kksldk4n8jhSlYEezlB4zs
   JDgcyOWffmqhDMmkg0ObHUH3XX0biZHGBXj04Kz1pyoUTAAzgR5RqPwMy
   ktkYAyZj7dPc35hVcPOVtiA4XScFdh6pNupVmqJgpt8LuZcsThB8hvQbt
   zB6myz0Z36W1t+o84sJoJ7a63XUyBxXdMENA8lG9DFOT3pM1dGuZBQbgv
   qZyb6GSaMkxLoDcgsoVmwRXCWumCivN9O33YHNDEwZTAimC9c6gxNXuFL
   A==;
X-CSE-ConnectionGUID: XQOBQVHhSOKtgRfniYf5GA==
X-CSE-MsgGUID: 8brnOda1SAOJqitKBjlnUQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11866"; a="109341671"
X-IronPort-AV: E=Sophos;i="6.25,207,1779174000"; 
   d="scan'208";a="109341671"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2026 14:19:49 -0700
X-CSE-ConnectionGUID: 56lWxJejS0ebB0duRwn5WQ==
X-CSE-MsgGUID: Ufo9sTw6QJOOXYMgV3ZwBA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,207,1779174000"; 
   d="scan'208";a="300138475"
Received: from vcostago-desk1.jf.intel.com (HELO [10.88.27.144]) ([10.88.27.144])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2026 14:19:49 -0700
From: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Date: Wed, 05 Aug 2026 14:19:22 -0700
Subject: [PATCH v2 1/5] dmaengine: idxd: assign all engines to group 0 in
 IAA defaults
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260805-iaa-crypto-fixes-zswap-v2-1-55c02694f499@intel.com>
References: <20260805-iaa-crypto-fixes-zswap-v2-0-55c02694f499@intel.com>
In-Reply-To: <20260805-iaa-crypto-fixes-zswap-v2-0-55c02694f499@intel.com>
To: Dave Jiang <dave.jiang@intel.com>, Vinod Koul <vkoul@kernel.org>, 
 Frank Li <Frank.Li@kernel.org>, 
 Kristen Accardi <kristen.c.accardi@intel.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, 
 Andrew Morton <akpm@linux-foundation.org>, Yosry Ahmed <yosry@kernel.org>, 
 Nhat Pham <nphamcs@gmail.com>
Cc: dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-crypto@vger.kernel.org, 
 Vinicius Costa Gomes <vinicius.gomes@intel.com>, 
 Giovanni Cabiddu <giovanni.cabiddu@intel.com>
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785964788; l=1611;
 i=vinicius.gomes@intel.com; s=20230921; h=from:subject:message-id;
 bh=4xJecnjuJZxGefDI/e9EVeBv1K3O7sNfo98hKPVMPyU=;
 b=hlGRaEjiI1Q6EBmLbZjOOpCJGJjPjE5QND0ws6GpI6FZpcA5jsKRMwrlDBNNLnK6BR1Vuu5HH
 dRsYlnSuhTSDRxF1YEni1uh1bz7sUKrSjI977RzsHRh1F6B9ro5ajus
X-Developer-Key: i=vinicius.gomes@intel.com; a=ed25519;
 pk=aJkrtgqgT6TZ8iIHSG8/rTPsmlYnjMrUjCsMYvCzntk=

From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

The IAA device defaults only assigned engine 0 to group 0, leaving
engines 1 through max_engines-1 unassigned (group_id = -1). This means
that by default only a single engine processed descriptors, limiting
throughput to one engine's capacity.

Assign all available engines to group 0 so that the full hardware
parallelism is used out of the box without requiring manual
accel-config setup.

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/dma/idxd/defaults.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/dma/idxd/defaults.c b/drivers/dma/idxd/defaults.c
index 2bbbcd02a0da..26ebfa2ca144 100644
--- a/drivers/dma/idxd/defaults.c
+++ b/drivers/dma/idxd/defaults.c
@@ -8,6 +8,7 @@ int idxd_load_iaa_device_defaults(struct idxd_device *idxd)
 	struct idxd_engine *engine;
 	struct idxd_group *group;
 	struct idxd_wq *wq;
+	int i;
 
 	if (!test_bit(IDXD_FLAG_CONFIGURABLE, &idxd->flags))
 		return 0;
@@ -41,11 +42,12 @@ int idxd_load_iaa_device_defaults(struct idxd_device *idxd)
 	/* set driver_name to "crypto" */
 	strscpy_pad(wq->driver_name, "crypto");
 
-	engine = idxd->engines[0];
-
-	/* set engine group to 0 */
-	engine->group = idxd->groups[0];
-	engine->group->num_engines++;
+	/* assign all engines to group 0 */
+	for (i = 0; i < idxd->max_engines; i++) {
+		engine = idxd->engines[i];
+		engine->group = group;
+		group->num_engines++;
+	}
 
 	return 0;
 }

-- 
2.55.0

