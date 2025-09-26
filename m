Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B746B26F44D;
	Fri, 26 Sep 2025 03:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758857715; cv=none; b=Ku8Gn5yJlxr1HAvkYf+aPyV+x7i00Uy1FHJSPXdeP3uA7sJgqAQxTzX/vUc5BfAzcfLrBAYXnyJAOZZtQ3uHvHD6TtOghjeu91BwYz9snJdirZBi8573b3vitV83czRxoDphLFEUp+vEWqFedaeqUIWcH7kMAAGY/BPjAjtYVJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758857715; c=relaxed/simple;
	bh=W86GZRwDZO7beezGCFVV/NiDdvS+RJYh/KFbuBLr8uM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Tp3Sb9bhDntMzXF7Iyo+TzBKFiq5y9rOqYp78rX7dh1yXxgcxizSTCLzfRaS9sjzoifdPL/tct1TxSOvkgJGxv1R+DIrYzIT3i/6iSIJf8AHBpMjm7sAqppVA+SaL8GIgzFsIMtf5wb+3OGSrNXRr3AX1KIOdZKfdzW3d2lv/LY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BPusNP0j; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BPusNP0j"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758857714; x=1790393714;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=W86GZRwDZO7beezGCFVV/NiDdvS+RJYh/KFbuBLr8uM=;
  b=BPusNP0jHuwNoJ+mJCvsOK6nWb+x3Vqg/znBxjcjjamxZmBSNz45Pipn
   6Ed0oDmGST7+atoX1PYkE7KsYR7UfOLBsDFpsCfyYtHwv4UHZqyXYzYqP
   E6ESPCiyorFHYqRF1GqP7jw8rOVv1tdBXcnuQ5JyoWlgy5Po9hlafbsuw
   1TBRtyT/kH84jssyJDCKyG1ld336Cpbx21Rzm0OakQYc0RdN6Y+p4fh62
   R++8gGW+wpTCpSarsz0JLkGxEHuxSm8MlC23p82lhoE8ad8emh4ou2oH0
   t7kAznNnG6G9WOQW2WYq4WAu0MMln+4jDbCsGyfgDv9pM72bxHGTZ1GeP
   g==;
X-CSE-ConnectionGUID: bJcZ0Zm8T7eig6TGfsWxOQ==
X-CSE-MsgGUID: Hzc8zmw6R+SkWVkoxvu23A==
X-IronPort-AV: E=McAfee;i="6800,10657,11564"; a="63819522"
X-IronPort-AV: E=Sophos;i="6.18,294,1751266800"; 
   d="scan'208";a="63819522"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 20:35:05 -0700
X-CSE-ConnectionGUID: C0oLLjWxRGqYnyTAnjQ5wg==
X-CSE-MsgGUID: RG5o64MGTdivpZT0qFXZUw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,294,1751266800"; 
   d="scan'208";a="214636574"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by orviesa001.jf.intel.com with ESMTP; 25 Sep 2025 20:35:04 -0700
From: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	hannes@cmpxchg.org,
	yosry.ahmed@linux.dev,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	usamaarif642@gmail.com,
	ryan.roberts@arm.com,
	21cnbao@gmail.com,
	ying.huang@linux.alibaba.com,
	akpm@linux-foundation.org,
	senozhatsky@chromium.org,
	sj@kernel.org,
	kasong@tencent.com,
	linux-crypto@vger.kernel.org,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	clabbe@baylibre.com,
	ardb@kernel.org,
	ebiggers@google.com,
	surenb@google.com,
	kristen.c.accardi@intel.com,
	vinicius.gomes@intel.com
Cc: wajdi.k.feghali@intel.com,
	vinodh.gopal@intel.com,
	kanchana.p.sridhar@intel.com
Subject: [PATCH v12 09/23] crypto: iaa - Deprecate exporting add/remove IAA compression modes.
Date: Thu, 25 Sep 2025 20:34:48 -0700
Message-Id: <20250926033502.7486-10-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20250926033502.7486-1-kanchana.p.sridhar@intel.com>
References: <20250926033502.7486-1-kanchana.p.sridhar@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There is no use case right now for kernel users to dynamically
add/remove IAA compression modes; hence this commit deletes the symbol
exports of add_iaa_compression_mode() and remove_iaa_compression_mode().

The only supported usage model of IAA compression modes is for the code
to be statically linked during the iaa_crypto module build,
e.g. iaa_crypto_comp_fixed.c, and for available modes to be registered
when the first IAA device wq is probed.

Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
---
 drivers/crypto/intel/iaa/iaa_crypto_main.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/intel/iaa/iaa_crypto_main.c
index cac39b418cf0..dd7c4831e092 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -367,10 +367,6 @@ static void free_iaa_compression_mode(struct iaa_compression_mode *mode)
  * These tables are typically generated and captured using statistics
  * collected from running actual compress/decompress workloads.
  *
- * A module or other kernel code can add and remove compression modes
- * with a given name using the exported @add_iaa_compression_mode()
- * and @remove_iaa_compression_mode functions.
- *
  * When a new compression mode is added, the tables are saved in a
  * global compression mode list.  When IAA devices are added, a
  * per-IAA device dma mapping is created for each IAA device, for each
@@ -404,7 +400,6 @@ void remove_iaa_compression_mode(const char *name)
 out:
 	mutex_unlock(&iaa_devices_lock);
 }
-EXPORT_SYMBOL_GPL(remove_iaa_compression_mode);
 
 /**
  * add_iaa_compression_mode - Add an IAA compression mode
@@ -481,7 +476,6 @@ int add_iaa_compression_mode(const char *name,
 	free_iaa_compression_mode(mode);
 	goto out;
 }
-EXPORT_SYMBOL_GPL(add_iaa_compression_mode);
 
 static void free_device_compression_mode(struct iaa_device *iaa_device,
 					 struct iaa_device_compression_mode *device_mode)
-- 
2.27.0

