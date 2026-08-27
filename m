Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 505BE48662D;
	Thu, 27 Aug 2026 15:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787845887; cv=none; b=OpnML5054+gBx3XlzAwU5LmkDDkeY2awr0/smJivaY5jiWn015wFAIURrDGvsD8jmPgwW5Wz1FbDRcp6D9g/iIR/WEj2byJviFdzK3hasF8Xe92tLFFqBfgNeMbHhwhHELsmKTeCOl0q86E3cEsTAoR5jo3cgJngLU/fy7GFRug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787845887; c=relaxed/simple;
	bh=JQEA3P4mDGyLajqRCVZSW5kMkSPvgf5cDQmcexUrxZU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nV69ampRiPHiSsbS8QnrLNRmCDmmEZx9mx1re/tlsxwH4NSLhxjjxQ5Wjlya00TYe/9SFat/gYdJOp+vUGLwi/zr9L417Xl0g2r2andM+8EkLpURvZcegpVX/Twwm9jW9X9xBewl30DFZxuNn45p/ebbBvqCZxQp1LPL4BCxv/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YeGObAY7; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YeGObAY7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787845886; x=1819381886;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=JQEA3P4mDGyLajqRCVZSW5kMkSPvgf5cDQmcexUrxZU=;
  b=YeGObAY79ddeWDk5iovX8n5joBijJCCFl34ThxKkUoYuFkWx0Fn6xcLi
   DM/ANRlBMlxVzhCcmRZYlzOpbBzkw7oWvx9G5745ohki4ju51ExC8aaGt
   lfWdQQkiIYGaL0XokWWU4Ogq57NuF6mJEMgOqpjlnGKkzgq/Cwi5QQ9es
   roT12jMy78zEWKeuYgnRidEeXRhgLoZ0ODKBqJwvrU4Om4Oif0BPnTBn/
   pRQRhbeaqfwDJCFNo5FFmJw/WUBqm3zPIk8KwTUqDTTibjgYeygvWV9js
   qjdNIPnh1wq2I9AV1WvKiwZbWssBlDLK1ZCyF1uiXoZnNet1YxsJqNKw0
   g==;
X-CSE-ConnectionGUID: rVyyMb4NQXSvbFfvU6EW+Q==
X-CSE-MsgGUID: brg+qereRBm11wcXG58OVg==
X-IronPort-AV: E=McAfee;i="6800,10657,11888"; a="99510542"
X-IronPort-AV: E=Sophos;i="6.25,246,1779174000"; 
   d="scan'208";a="99510542"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2026 08:51:25 -0700
X-CSE-ConnectionGUID: DaDQK5qXQcGCrvgYh8EZJg==
X-CSE-MsgGUID: Tls2E0W3SvuYcDvH5ZiRBQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,246,1779174000"; 
   d="scan'208";a="297793920"
Received: from smtp.ostc.intel.com ([10.54.69.131])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2026 08:51:25 -0700
Received: from ray2.intel.com (unknown [10.125.109.108])
	by smtp.ostc.intel.com (Postfix) with ESMTP id EEEA65E92;
	Thu, 27 Aug 2026 08:51:24 -0700 (PDT)
From: Dave Hansen <dave.hansen@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Dave Hansen <dave.hansen@linux.intel.com>,
	Prabhjot Khurana <prabhjot.khurana@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
Subject: [PATCH] crypto: keembay - Remove bouncing maintainer
Date: Thu, 27 Aug 2026 08:51:20 -0700
Message-ID: <20260827155120.2334898-1-dave.hansen@linux.intel.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The email for Mark Gross is bouncing. Remove the entry.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Prabhjot Khurana <prabhjot.khurana@intel.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org
---
 MAINTAINERS | 1 -
 1 file changed, 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 7f147a95940ee..6d8de95f10ab8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13282,7 +13282,6 @@ F:	drivers/crypto/intel/keembay/ocs-aes.h
 
 INTEL KEEM BAY OCS ECC CRYPTO DRIVER
 M:	Prabhjot Khurana <prabhjot.khurana@intel.com>
-M:	Mark Gross <mgross@linux.intel.com>
 S:	Maintained
 F:	Documentation/devicetree/bindings/crypto/intel,keembay-ocs-ecc.yaml
 F:	drivers/crypto/intel/keembay/Kconfig
-- 
2.43.0

