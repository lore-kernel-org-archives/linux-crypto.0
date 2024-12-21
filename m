Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C4351EC4EF;
	Sat, 21 Dec 2024 06:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734762686; cv=none; b=G4+2MLo/PREyyn2iLD74fPW3VNRvj/G7FqlM5RouKd+dUSzJpwhcRI5rhJXHebpszuOdiftC8ZC6G3n7hJ5ajDK8/HJydfjVj/AYvPOZXZ1B72BlIng9nKH/P18yJddyZN1RDKBer0rv4QWHIZKbrrvcNy5Q1GZ7Rd4EzzlHZe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734762686; c=relaxed/simple;
	bh=dnKV2MmLzoI9vkZttcUmEHeNbzmt/yFATHDDvqZCCxA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pg+QNiXTMkG6IRENZUYtIAajcRPJ9sTr82mg83RkcMgwFnO8dgpT7WEJjBNKSOLmfA056lCMO9zEerwXn6U607UxyqzZmQ83yCRfEvDaTvi/dDDXujHslfuzxb7TMLoKupYeL5EC+dlzPeAlThev7ehWibudN5yrSYveQayfO7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kewq4JpJ; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kewq4JpJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1734762685; x=1766298685;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dnKV2MmLzoI9vkZttcUmEHeNbzmt/yFATHDDvqZCCxA=;
  b=kewq4JpJM5Z9kM39oFXoZFmYLukN8U+tcppwK1N1k7dcEGhiUHy3sOOz
   yHyyL5+e2uKXzuxLM6rvMlQQdir9VVIwRHvtq3P1XUiqlQPaHURVPoBc/
   /1QXhfCDh72bMwvex36kye/DmMjpg8fYonC7B7+5Mwl4QKEa585IfjXaE
   CcxGVLqzZSaN7WT9Z2kQ5Gp/cZVk3nvy4LfE7Jx1DOVnBVNEDZJK4LQPM
   Q0Oi4Pr2llRohPNitbiiA56cqWQJ3Mqh7Lm14LAOh4Fk3yztfYhue+LbC
   DhjiflV7aJDId9NtM+3+miIVO+O1bIh0jXXiM0tAlnawrAOJb4mOmpws6
   Q==;
X-CSE-ConnectionGUID: J+PS75KbSnKKZaV8ty8jFg==
X-CSE-MsgGUID: YV2l6wD7QiqWSQkNNVeCog==
X-IronPort-AV: E=McAfee;i="6700,10204,11292"; a="35021663"
X-IronPort-AV: E=Sophos;i="6.12,253,1728975600"; 
   d="scan'208";a="35021663"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2024 22:31:20 -0800
X-CSE-ConnectionGUID: g4t7vpBRTiCPemeEulVYqg==
X-CSE-MsgGUID: R3oSL3RUTZmqIk7E3UgbMA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="99184588"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by orviesa007.jf.intel.com with ESMTP; 20 Dec 2024 22:31:20 -0800
From: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	hannes@cmpxchg.org,
	yosryahmed@google.com,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	usamaarif642@gmail.com,
	ryan.roberts@arm.com,
	21cnbao@gmail.com,
	akpm@linux-foundation.org,
	linux-crypto@vger.kernel.org,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	clabbe@baylibre.com,
	ardb@kernel.org,
	ebiggers@google.com,
	surenb@google.com,
	kristen.c.accardi@intel.com
Cc: wajdi.k.feghali@intel.com,
	vinodh.gopal@intel.com,
	kanchana.p.sridhar@intel.com
Subject: [PATCH v5 05/12] crypto: iaa - Make async mode the default.
Date: Fri, 20 Dec 2024 22:31:12 -0800
Message-Id: <20241221063119.29140-6-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20241221063119.29140-1-kanchana.p.sridhar@intel.com>
References: <20241221063119.29140-1-kanchana.p.sridhar@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch makes it easier for IAA hardware acceleration in the iaa_crypto
driver to be loaded by default in the most efficient/recommended "async"
mode for parallel compressions/decompressions, namely, asynchronous
submission of descriptors, followed by polling for job completions with
request chaining. Earlier, the "sync" mode used to be the default.

This way, anyone who wants to use IAA for zswap/zram can do so after
building the kernel, and without having to go through these steps to use
async request chaining:

  1) disable all the IAA device/wq bindings that happen at boot time
  2) rmmod iaa_crypto
  3) modprobe iaa_crypto
  4) echo async > /sys/bus/dsa/drivers/crypto/sync_mode
  5) re-run initialization of the IAA devices and wqs

Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
---
 drivers/crypto/intel/iaa/iaa_crypto_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/intel/iaa/iaa_crypto_main.c
index b51b0b4b9ac3..6d49f82165fe 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -153,7 +153,7 @@ static DRIVER_ATTR_RW(verify_compress);
  */
 
 /* Use async mode */
-static bool async_mode;
+static bool async_mode = true;
 /* Use interrupts */
 static bool use_irq;
 
-- 
2.27.0

