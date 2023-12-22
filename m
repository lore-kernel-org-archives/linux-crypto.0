Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF733168A2
	for <linux-crypto@vger.kernel.org>; Fri, 22 Dec 2023 10:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Na+q2T1B"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1703241487; x=1734777487;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sjtj9VMfw/xN3qHBdz1BJCFoWFloQV6ttWn+AVmHTGs=;
  b=Na+q2T1BIDRxuXZPbh4WknjB+YWG19mHzX+vohLxrklk6kCXKbQqy1qC
   IXymyaoeH9aatKxDhquEF1NBlWvACX9c00ee3lLIlRZrQGBmicB8NlwAQ
   Wdi7jTCqSem0TKMVgYnqldK4Mi55X08tZ0J20lCgyEwCcsq0DbuuhcFXn
   /gy7BcsFhEZzUc44FUy2SavVZYV4fJydz1cvT7aad+aIwp54ntwu7H74I
   4JtAFZtzC0LWSYV7EY4bmIw8NZkfTm8mRB0mzBLZfEpXky6NQ7OQS7tq0
   qcvTHvioNS6bWZEe4nujacVBkxzS0hItc5KAZvpSypaO+cEudcnHvlOid
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10931"; a="2948167"
X-IronPort-AV: E=Sophos;i="6.04,296,1695711600"; 
   d="scan'208";a="2948167"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Dec 2023 02:38:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10931"; a="726742868"
X-IronPort-AV: E=Sophos;i="6.04,296,1695711600"; 
   d="scan'208";a="726742868"
Received: from r007s007_zp31l10c01.deacluster.intel.com (HELO fedora.deacluster.intel.com) ([10.219.171.169])
  by orsmga003.jf.intel.com with ESMTP; 22 Dec 2023 02:38:05 -0800
From: Lucas Segarra Fernandez <lucas.segarra.fernandez@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Lucas Segarra Fernandez <lucas.segarra.fernandez@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Damian Muszynski <damian.muszynski@intel.com>
Subject: [PATCH v2 1/4] crypto: qat - include pci.h for GET_DEV()
Date: Fri, 22 Dec 2023 11:35:05 +0100
Message-ID: <20231222103508.1037442-2-lucas.segarra.fernandez@intel.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231222103508.1037442-1-lucas.segarra.fernandez@intel.com>
References: <20231222103508.1037442-1-lucas.segarra.fernandez@intel.com>
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

