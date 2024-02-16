Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B4B51339BE
	for <linux-crypto@vger.kernel.org>; Fri, 16 Feb 2024 15:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708097889; cv=none; b=axDVss3P10B75mjhwqwPWXbUwWeCKZlxuTSw5KvEm9q3H28djl/hSLbE8cY0o6uWWGvYldpswXZ+ia+TIBhIAVNJI2c7Veatj9CduE0K/hObR1H608xSheW7BHIBSkKasY1toM2Jfy3Mk+Z8Hp1KRZtr77ufZJkqFhcRA/KQiHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708097889; c=relaxed/simple;
	bh=4Nx676GjhlrO2ieWVHXGRi7yvtMx/n9XroKkfZFe3HE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hlJlNVwTacfyqUVQZtk21U9RlRW3XTVNv1euwvSOk3rcccRtE7gQsuBwJ63FfeWhtD0CFz1ezjUfP1Yfho2XFIvxP88Dmv4D93NCi5ddK9wBCmtEVsFPXjsEowJMPqvaekLxWgjk1CieACtyCPaWAdC5xCkDgyUZAOy3qVMxQZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=F019ZlIV; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="F019ZlIV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708097888; x=1739633888;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4Nx676GjhlrO2ieWVHXGRi7yvtMx/n9XroKkfZFe3HE=;
  b=F019ZlIVwa17Ez0tfNawsFnctNMezjSh9IHC+pcMlo5aw7pFAo2J1iv3
   v+CRcFu2IyaBARXwrNxXV+8nqJQasLzVSLhypYHxlieyObX7FECF+ZRSD
   3dqNsDCcJekK7KYrXIDHE/aAPSNSK3v579K9K8O7U5VQucGVIDGt0Y92U
   NlOV+DGeCY8hVX+ywTXpr/83utCyxNDCmhwZrOBNIhkxv0fj7Ml9CR6gi
   Hv9lokbXhX6uB8u9aOj9zVu6lfyv13qj3+h8eQ7gMB5LE9oT/tIN1rz4t
   h13E8EJczEm8ObdIQzKdCoUfJADYVc+6PHKVSZBc9REPIC5mXJhnte4qW
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10986"; a="13622730"
X-IronPort-AV: E=Sophos;i="6.06,165,1705392000"; 
   d="scan'208";a="13622730"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2024 07:38:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10986"; a="935861461"
X-IronPort-AV: E=Sophos;i="6.06,165,1705392000"; 
   d="scan'208";a="935861461"
Received: from silpixa00400295.ir.intel.com ([10.237.213.194])
  by fmsmga001.fm.intel.com with ESMTP; 16 Feb 2024 07:38:06 -0800
From: Adam Guerin <adam.guerin@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Adam Guerin <adam.guerin@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 1/6] crypto: qat - remove unused macros in qat_comp_alg.c
Date: Fri, 16 Feb 2024 15:19:55 +0000
Message-Id: <20240216151959.19382-2-adam.guerin@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20240216151959.19382-1-adam.guerin@intel.com>
References: <20240216151959.19382-1-adam.guerin@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organisation: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare, Ireland
Content-Transfer-Encoding: 8bit

As a result of the removal of qat_zlib_deflate, some defines where not
removed. Remove them.

This is to fix the following warning when compiling the QAT driver
using the clang compiler with CC=clang W=2:
    drivers/crypto/intel/qat/qat_common/qat_comp_algs.c:21:9: warning: macro is not used [-Wunused-macros]
       21 | #define QAT_RFC_1950_CM_OFFSET 4
          |         ^
    drivers/crypto/intel/qat/qat_common/qat_comp_algs.c:16:9: warning: macro is not used [-Wunused-macros]
       16 | #define QAT_RFC_1950_HDR_SIZE 2
          |         ^
    drivers/crypto/intel/qat/qat_common/qat_comp_algs.c:17:9: warning: macro is not used [-Wunused-macros]
       17 | #define QAT_RFC_1950_FOOTER_SIZE 4
          |         ^
    drivers/crypto/intel/qat/qat_common/qat_comp_algs.c:22:9: warning: macro is not used [-Wunused-macros]
       22 | #define QAT_RFC_1950_DICT_MASK 0x20
          |         ^
    drivers/crypto/intel/qat/qat_common/qat_comp_algs.c:18:9: warning: macro is not used [-Wunused-macros]
       18 | #define QAT_RFC_1950_CM_DEFLATE 8
          |         ^
    drivers/crypto/intel/qat/qat_common/qat_comp_algs.c:20:9: warning: macro is not used [-Wunused-macros]
       20 | #define QAT_RFC_1950_CM_MASK 0x0f
          |         ^
    drivers/crypto/intel/qat/qat_common/qat_comp_algs.c:23:9: warning: macro is not used [-Wunused-macros]
       23 | #define QAT_RFC_1950_COMP_HDR 0x785e
          |         ^
    drivers/crypto/intel/qat/qat_common/qat_comp_algs.c:19:9: warning: macro is not used [-Wunused-macros]
       19 | #define QAT_RFC_1950_CM_DEFLATE_CINFO_32K 7
          |         ^

Fixes: e9dd20e0e5f6 ("crypto: qat - Remove zlib-deflate")
Signed-off-by: Adam Guerin <adam.guerin@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/intel/qat/qat_common/qat_comp_algs.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/qat_comp_algs.c b/drivers/crypto/intel/qat/qat_common/qat_comp_algs.c
index bf8c0ee62917..2ba4aa22e092 100644
--- a/drivers/crypto/intel/qat/qat_common/qat_comp_algs.c
+++ b/drivers/crypto/intel/qat/qat_common/qat_comp_algs.c
@@ -13,15 +13,6 @@
 #include "qat_compression.h"
 #include "qat_algs_send.h"
 
-#define QAT_RFC_1950_HDR_SIZE 2
-#define QAT_RFC_1950_FOOTER_SIZE 4
-#define QAT_RFC_1950_CM_DEFLATE 8
-#define QAT_RFC_1950_CM_DEFLATE_CINFO_32K 7
-#define QAT_RFC_1950_CM_MASK 0x0f
-#define QAT_RFC_1950_CM_OFFSET 4
-#define QAT_RFC_1950_DICT_MASK 0x20
-#define QAT_RFC_1950_COMP_HDR 0x785e
-
 static DEFINE_MUTEX(algs_lock);
 static unsigned int active_devs;
 
-- 
2.40.1

