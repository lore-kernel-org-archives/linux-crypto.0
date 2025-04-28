Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0530D28F517
	for <linux-crypto@vger.kernel.org>; Mon, 28 Apr 2025 17:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745861115; cv=none; b=SazwFyLysmYBz4e/LaMFAsQZHKom2mYJwaYGdxq6IbDjccEkYsNbimt8UqXU4RLjcp5fnpPP7BbwKGZWBPVnxBRb2RpUdP8bS2QDu6L/BijDQqZnFbtNidvaCsg4O5J6yB8e+rZNrN7iMlGDLZw0bQQwSAy5OxTVbxwEvkMFuSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745861115; c=relaxed/simple;
	bh=GegeX8gwQEhw54f3rtV1DHxdjTQabCDQnYUDXJFaLig=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=i79QeNQSldt3/7qYsQAeYNxyAdsuR8Cw83Tog9OIJ8OjCh0u4CSUV/Ca/AnapapyKTKxKW+IN9GCO8mZs9hAmko2yyUHA80iK68Jv9F+mDn3LeMXzcRZuMBbUmZD+x/4g2AkS8ZBUX5Xn0J8Hq4EDr/9bN9nIAY2l/WNvYCXG4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=O0e1bwTV; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="O0e1bwTV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745861113; x=1777397113;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=GegeX8gwQEhw54f3rtV1DHxdjTQabCDQnYUDXJFaLig=;
  b=O0e1bwTVzoFWaGQF1czHihdsuoDVb+MrQ4ACHQMDtpG7QzuC8XFWXdOc
   c+WMnvoRxW30UjfGHUtehLmUPeuIonqay6rproQlvmx50PzQUDEeaXbrs
   cYwGHzkleyqiVEpARKgha1WQiJTzGJ4NCcLD8RYTT3STr/iLfoqRe0wLw
   yni5FY7w/cWw9cGcAyWoZh7xqHHqtW8GcnyOX84NDqOcredKdQ/I+/4KI
   kqMaWdzkXLOEE1qoswdaPSyF/hcdLDqWbTswgMH/W3HmsY+YyVC9dyJ15
   aeBSF5XEKP+SrG+C2lFdHR5B78PxL4pVVj2dsqXUbaunPhBPHXYX8E+iL
   Q==;
X-CSE-ConnectionGUID: cQtSl/tSSRiwm5eUApoRYg==
X-CSE-MsgGUID: JhXt6tZ1QSO2SmCbSBRu8g==
X-IronPort-AV: E=McAfee;i="6700,10204,11417"; a="47340994"
X-IronPort-AV: E=Sophos;i="6.15,246,1739865600"; 
   d="scan'208";a="47340994"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2025 10:25:12 -0700
X-CSE-ConnectionGUID: rLJVyJNER26CCmI/4FNc8g==
X-CSE-MsgGUID: qvyQr0UmSTm1ViNFgf+AUQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,246,1739865600"; 
   d="scan'208";a="170808392"
Received: from t21-qat.iind.intel.com ([10.49.15.35])
  by orviesa001.jf.intel.com with ESMTP; 28 Apr 2025 10:25:10 -0700
From: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH] crypto: qat - include qat_common in top Makefile
Date: Mon, 28 Apr 2025 18:24:26 +0100
Message-Id: <20250428172426.861977-1-suman.kumar.chakraborty@intel.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

To ensure proper functionality, each specific driver needs to access
functions located in the qat_common folder.

Move the include path for qat_common to the top-level Makefile.
This eliminates the need for redundant include directives in the
Makefiles of individual drivers.

Suggested-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/intel/qat/Makefile                | 1 +
 drivers/crypto/intel/qat/qat_420xx/Makefile      | 1 -
 drivers/crypto/intel/qat/qat_4xxx/Makefile       | 1 -
 drivers/crypto/intel/qat/qat_c3xxx/Makefile      | 1 -
 drivers/crypto/intel/qat/qat_c3xxxvf/Makefile    | 1 -
 drivers/crypto/intel/qat/qat_c62x/Makefile       | 1 -
 drivers/crypto/intel/qat/qat_c62xvf/Makefile     | 1 -
 drivers/crypto/intel/qat/qat_dh895xcc/Makefile   | 1 -
 drivers/crypto/intel/qat/qat_dh895xccvf/Makefile | 1 -
 9 files changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/crypto/intel/qat/Makefile b/drivers/crypto/intel/qat/Makefile
index 235b69f4f3f7..1eda8dc18515 100644
--- a/drivers/crypto/intel/qat/Makefile
+++ b/drivers/crypto/intel/qat/Makefile
@@ -1,4 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
+subdir-ccflags-y := -I$(src)/qat_common
 obj-$(CONFIG_CRYPTO_DEV_QAT) += qat_common/
 obj-$(CONFIG_CRYPTO_DEV_QAT_DH895xCC) += qat_dh895xcc/
 obj-$(CONFIG_CRYPTO_DEV_QAT_C3XXX) += qat_c3xxx/
diff --git a/drivers/crypto/intel/qat/qat_420xx/Makefile b/drivers/crypto/intel/qat/qat_420xx/Makefile
index 72b24b1804cf..f6df54d2993e 100644
--- a/drivers/crypto/intel/qat/qat_420xx/Makefile
+++ b/drivers/crypto/intel/qat/qat_420xx/Makefile
@@ -1,4 +1,3 @@
 # SPDX-License-Identifier: GPL-2.0-only
-ccflags-y := -I $(src)/../qat_common
 obj-$(CONFIG_CRYPTO_DEV_QAT_420XX) += qat_420xx.o
 qat_420xx-y := adf_drv.o adf_420xx_hw_data.o
diff --git a/drivers/crypto/intel/qat/qat_4xxx/Makefile b/drivers/crypto/intel/qat/qat_4xxx/Makefile
index e8480bb80dee..188b611445e6 100644
--- a/drivers/crypto/intel/qat/qat_4xxx/Makefile
+++ b/drivers/crypto/intel/qat/qat_4xxx/Makefile
@@ -1,4 +1,3 @@
 # SPDX-License-Identifier: (BSD-3-Clause OR GPL-2.0-only)
-ccflags-y := -I $(src)/../qat_common
 obj-$(CONFIG_CRYPTO_DEV_QAT_4XXX) += qat_4xxx.o
 qat_4xxx-y := adf_drv.o adf_4xxx_hw_data.o
diff --git a/drivers/crypto/intel/qat/qat_c3xxx/Makefile b/drivers/crypto/intel/qat/qat_c3xxx/Makefile
index d9e568572da8..43604c025f0c 100644
--- a/drivers/crypto/intel/qat/qat_c3xxx/Makefile
+++ b/drivers/crypto/intel/qat/qat_c3xxx/Makefile
@@ -1,4 +1,3 @@
 # SPDX-License-Identifier: GPL-2.0-only
-ccflags-y := -I $(src)/../qat_common
 obj-$(CONFIG_CRYPTO_DEV_QAT_C3XXX) += qat_c3xxx.o
 qat_c3xxx-y := adf_drv.o adf_c3xxx_hw_data.o
diff --git a/drivers/crypto/intel/qat/qat_c3xxxvf/Makefile b/drivers/crypto/intel/qat/qat_c3xxxvf/Makefile
index 31a908a211ac..03f6745b4aa2 100644
--- a/drivers/crypto/intel/qat/qat_c3xxxvf/Makefile
+++ b/drivers/crypto/intel/qat/qat_c3xxxvf/Makefile
@@ -1,4 +1,3 @@
 # SPDX-License-Identifier: GPL-2.0-only
-ccflags-y := -I $(src)/../qat_common
 obj-$(CONFIG_CRYPTO_DEV_QAT_C3XXXVF) += qat_c3xxxvf.o
 qat_c3xxxvf-y := adf_drv.o adf_c3xxxvf_hw_data.o
diff --git a/drivers/crypto/intel/qat/qat_c62x/Makefile b/drivers/crypto/intel/qat/qat_c62x/Makefile
index cbdaaa135e84..f3d722bef088 100644
--- a/drivers/crypto/intel/qat/qat_c62x/Makefile
+++ b/drivers/crypto/intel/qat/qat_c62x/Makefile
@@ -1,4 +1,3 @@
 # SPDX-License-Identifier: GPL-2.0-only
-ccflags-y := -I $(src)/../qat_common
 obj-$(CONFIG_CRYPTO_DEV_QAT_C62X) += qat_c62x.o
 qat_c62x-y := adf_drv.o adf_c62x_hw_data.o
diff --git a/drivers/crypto/intel/qat/qat_c62xvf/Makefile b/drivers/crypto/intel/qat/qat_c62xvf/Makefile
index 60e499b041ec..ed7f3f722d99 100644
--- a/drivers/crypto/intel/qat/qat_c62xvf/Makefile
+++ b/drivers/crypto/intel/qat/qat_c62xvf/Makefile
@@ -1,4 +1,3 @@
 # SPDX-License-Identifier: GPL-2.0-only
-ccflags-y := -I $(src)/../qat_common
 obj-$(CONFIG_CRYPTO_DEV_QAT_C62XVF) += qat_c62xvf.o
 qat_c62xvf-y := adf_drv.o adf_c62xvf_hw_data.o
diff --git a/drivers/crypto/intel/qat/qat_dh895xcc/Makefile b/drivers/crypto/intel/qat/qat_dh895xcc/Makefile
index 5bf5c890c362..1427fe76f171 100644
--- a/drivers/crypto/intel/qat/qat_dh895xcc/Makefile
+++ b/drivers/crypto/intel/qat/qat_dh895xcc/Makefile
@@ -1,4 +1,3 @@
 # SPDX-License-Identifier: GPL-2.0-only
-ccflags-y := -I $(src)/../qat_common
 obj-$(CONFIG_CRYPTO_DEV_QAT_DH895xCC) += qat_dh895xcc.o
 qat_dh895xcc-y := adf_drv.o adf_dh895xcc_hw_data.o
diff --git a/drivers/crypto/intel/qat/qat_dh895xccvf/Makefile b/drivers/crypto/intel/qat/qat_dh895xccvf/Makefile
index 93f9c81edf09..c2fdb6e0f68f 100644
--- a/drivers/crypto/intel/qat/qat_dh895xccvf/Makefile
+++ b/drivers/crypto/intel/qat/qat_dh895xccvf/Makefile
@@ -1,4 +1,3 @@
 # SPDX-License-Identifier: GPL-2.0-only
-ccflags-y := -I $(src)/../qat_common
 obj-$(CONFIG_CRYPTO_DEV_QAT_DH895xCCVF) += qat_dh895xccvf.o
 qat_dh895xccvf-y := adf_drv.o adf_dh895xccvf_hw_data.o

base-commit: 2a603eac8926f981a481389e721a14c8ab576e47
-- 
2.40.1

