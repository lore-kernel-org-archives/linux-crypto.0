Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DC7316FF4E;
	Sat, 23 Nov 2024 07:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732345293; cv=none; b=mLRFtwiNqwm6fuRfmd23uSk5NQpGMQEOevpsb591VZ6VQEcb6+3Zn7mcvIHRcg6bW4enq8pfRb7O7dbc2K3lpEKwkVXGIJu2jHywaQMor3Td4EZcYbNSWrtmz7RfryfF3RP/Q8xXRp9PmI42x1Jk6zbpDkQS2MaVarfZ1scDg1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732345293; c=relaxed/simple;
	bh=QbVPHifD6kbvaQyPWicO/+NjbMZ0sYtZbDpqlwtWffY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=I4wjnzBN/ZmkTcptHRZ7Hi7ibnOALQwGQniXtPjczc8glfSG/D4wHuUPgQVYJiyPwSFNHT2YJsPtShN9AIbiM1ra3lVGK2Cj62sy8aRU3FRt9x6fDDwCe46FBh9CDmsgrdFE+cV0eibXV4wOtgVzu5fJjpAJq9SQKy3R2W+N4YE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aL7Q7PKm; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aL7Q7PKm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732345293; x=1763881293;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QbVPHifD6kbvaQyPWicO/+NjbMZ0sYtZbDpqlwtWffY=;
  b=aL7Q7PKm+eu8QKY4NMdDJqkvr3IA11XEDbCJPNr+EqSh1IdPsHdvYlFi
   O61V6v2zOGE/4qu5C/1n75eE84cUUn+aLIIPjVDPR9Xr38S5MZGzcOI4s
   UDz0rfU6gqqyPlks1DsAv+cSQlQBKTZxw/0IGW6rC0RDcuLAtFi0gaUoY
   iQzK7o02eSwfF75IQvnSWzDXzHelXno1xxJK38bHBjKAoC9YR67DD3unO
   91C4B1lx7/15acgFCaAO1yZHwdhQBsOreq1MulJNMcCxcJEpNoVyYMjNY
   mxXENrha0Y7ezWadQdgA3OVAUXRufycEJibo6oK/BOwccybB9R/kR89R2
   g==;
X-CSE-ConnectionGUID: 9a8oV29mTTq4Gy5PYv0kDQ==
X-CSE-MsgGUID: n1aMPIQ9TpSepIXsDmJ0tg==
X-IronPort-AV: E=McAfee;i="6700,10204,11264"; a="32435496"
X-IronPort-AV: E=Sophos;i="6.12,178,1728975600"; 
   d="scan'208";a="32435496"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2024 23:01:29 -0800
X-CSE-ConnectionGUID: ObQFb837QdKzc06jS1W0Yw==
X-CSE-MsgGUID: +0JuenxqTvCxqHgsFnoJTQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,178,1728975600"; 
   d="scan'208";a="91573556"
Received: from unknown (HELO JF5300-B11A338T.jf.intel.com) ([10.242.51.115])
  by orviesa008.jf.intel.com with ESMTP; 22 Nov 2024 23:01:28 -0800
From: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	hannes@cmpxchg.org,
	yosryahmed@google.com,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	usamaarif642@gmail.com,
	ryan.roberts@arm.com,
	ying.huang@intel.com,
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
Subject: [PATCH v4 04/10] crypto: iaa - Make async mode the default.
Date: Fri, 22 Nov 2024 23:01:21 -0800
Message-Id: <20241123070127.332773-5-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20241123070127.332773-1-kanchana.p.sridhar@intel.com>
References: <20241123070127.332773-1-kanchana.p.sridhar@intel.com>
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
submission of descriptors, followed by polling for job completions.
Earlier, the "sync" mode used to be the default.

This way, anyone that wants to use IAA can do so after building the kernel,
and without having to go through these steps to use async poll:

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
index cbf147a3c3cb..bd2db0b6f145 100644
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

