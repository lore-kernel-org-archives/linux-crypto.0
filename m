Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30F2B381D3
	for <linux-crypto@vger.kernel.org>; Fri, 15 Dec 2023 15:27:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="j3KG+vUu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702654051; x=1734190051;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=sjtj9VMfw/xN3qHBdz1BJCFoWFloQV6ttWn+AVmHTGs=;
  b=j3KG+vUuymqhXrlpnFOtyPx30srfXpcT7Df5aBaD1B+BiYSQShewHDp8
   4uSxSSsdzaFj46WIPFPMyGcwVBtbIUE0Ls+5Yw4cgYs6s/b6qzV4X4nKZ
   fahTOvmLrGai2FJJLk9v5pIDEX5jiCtbHY8i+tat2jO0GV0XYE+9m2oUT
   gQa9Y/flMqFF8HHyLsRuMnSGy4eM5jf3uD8prUyp2weIB99bqDLj6yBVc
   D8gJQ96VlSUtY77EBjSutcuASftgWPhKQ1Q4y+8xXBRyUgDHKRLI4UQHM
   Dq4CYIlR8aZD8p0awLziuybARqUAIkb/YlEeH6QyeoxUDLF/CHEOaIO8c
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10924"; a="461750490"
X-IronPort-AV: E=Sophos;i="6.04,279,1695711600"; 
   d="scan'208";a="461750490"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2023 07:27:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10924"; a="898173254"
X-IronPort-AV: E=Sophos;i="6.04,279,1695711600"; 
   d="scan'208";a="898173254"
Received: from r007s007_zp31l10c01.deacluster.intel.com (HELO fedora.deacluster.intel.com) ([10.219.171.169])
  by orsmga004.jf.intel.com with ESMTP; 15 Dec 2023 07:27:29 -0800
From: Lucas Segarra Fernandez <lucas.segarra.fernandez@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Lucas Segarra Fernandez <lucas.segarra.fernandez@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Damian Muszynski <damian.muszynski@intel.com>
Subject: [PATCH 2/5] crypto: qat - include pci.h for GET_DEV()
Date: Fri, 15 Dec 2023 16:25:13 +0100
Message-ID: <20231215152513.34550-1-lucas.segarra.fernandez@intel.com>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

GET_DEV() macro expansion relies on struct pci_dev being defined.

Include <linux/pci.h> at adf_accel_devices.h.

Signed-off-by: Lucas Segarra Fernandez <lucas.segarra.fernandez@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Damian Muszynski <damian.muszynski@intel.com>
---
 drivers/crypto/intel/qat/qat_common/adf_accel_devices.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h b/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
index 7df6336ddd62..fc7786d71e96 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
@@ -6,6 +6,7 @@
 #include <linux/module.h>
 #include <linux/list.h>
 #include <linux/io.h>
+#include <linux/pci.h>
 #include <linux/ratelimit.h>
 #include <linux/types.h>
 #include "adf_cfg_common.h"
-- 
2.41.0

