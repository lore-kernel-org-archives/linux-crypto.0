Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F10FC1F463C
	for <linux-crypto@vger.kernel.org>; Wed, 26 Mar 2025 16:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743004905; cv=none; b=gZHAHQqZOXyGXuV1gwJZEtPqS8xtjgiImNKVi3Wx6oFw2n2wIRKpgZlSO3wxOKsOxFO5ri8SiqwqA8QcxlJZM03x4rE0sikGbc80fd7W7HuBqL7V4Deh2fetpoybLf2seiqV/GUE5ScXN0qn8snNjVBO1ALq+r3Sll2n6mWXpC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743004905; c=relaxed/simple;
	bh=qak0j7OU4AEygUIlXTFjLmoMNicCcU6hCQ0G9kD7Lw0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sxhpIZX5S5Un/gstbaEDE9UNSR+OYahmG7zmcOTgnZF5fpakVgL+O+cA1bSCcdUCWqRaLN5x3YUi7oVu/ZhTq5h8THrlsFnVe2FTdandcv8K/4fzYGnzKU8DZnRxDL3w7wWVxOGpIcyoa4N6Rjh+Nmpjt7dOh95JYUH44VgBfRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BojDCLI7; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BojDCLI7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1743004904; x=1774540904;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=qak0j7OU4AEygUIlXTFjLmoMNicCcU6hCQ0G9kD7Lw0=;
  b=BojDCLI7SYTwO08XNKOXmLZYMK1887f4fRIG2BFZglHfxwaHSVsxF/9q
   a2+iiYKr8+zsGoUeX+KjKJ1wFdsoMnH38QxTPlBQGRb6B1UFeL5JH6Yuh
   iwtNyzl7DLC0l44uRZ8QHzxq5vgkyyDrTRk4g3Dt9eHxcLjBDhLc8iVli
   ta0d7/MJANgxCk9xG0JExJq8o9qOk0hC/C2JXzwITv0AgvMImOsellvOY
   IMCWpKkWkKTdvaNaDPFG3ribWUsZLwMCep9olDHzI/LamEuFsACk38iV/
   GPpHJ93Z7GZ/XKOHwWsRk0YChv8u2BVZ23mcHdCRDp30wtdDdhuEjvq/L
   g==;
X-CSE-ConnectionGUID: U6tG+3PbQaCiwQ1n90Y6aA==
X-CSE-MsgGUID: LfpJ3lDfS/KVQc+WJTgYlg==
X-IronPort-AV: E=McAfee;i="6700,10204,11385"; a="61823861"
X-IronPort-AV: E=Sophos;i="6.14,278,1736841600"; 
   d="scan'208";a="61823861"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2025 09:01:43 -0700
X-CSE-ConnectionGUID: xZvxDoKDSr695cD3ipeDAA==
X-CSE-MsgGUID: 5MHSCNAkSVKSc5O52thJ7w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,278,1736841600"; 
   d="scan'208";a="129928540"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.223.204])
  by fmviesa004.fm.intel.com with ESMTP; 26 Mar 2025 09:01:40 -0700
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	andriy.shevchenko@intel.com,
	qat-linux@intel.com,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 0/8] crypto: qat - fix warm reboot
Date: Wed, 26 Mar 2025 15:59:45 +0000
Message-ID: <20250326160116.102699-2-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit

This series of patches addresses the warm reboot problem that affects
all QAT devices. When a reset is performed using kexec, QAT devices
fail to recover due to improper shutdown.

This implement the shutdown() handler, which integrates with the
reboot notifier list to ensure proper device shutdown during reboots.

Each patch in this series targets a specific device driver which has a
different commit id, therefore a different `Fixes` tag.

Giovanni Cabiddu (8):
  crypto: qat - add shutdown handler to qat_4xxx
  crypto: qat - add shutdown handler to qat_420xx
  crypto: qat - remove redundant prototypes in qat_dh895xcc
  crypto: qat - add shutdown handler to qat_dh895xcc
  crypto: qat - remove redundant prototypes in qat_c62x
  crypto: qat - add shutdown handler to qat_c62x
  crypto: qat - remove redundant prototypes in qat_c3xxx
  crypto: qat - add shutdown handler to qat_c3xxx

 drivers/crypto/intel/qat/qat_420xx/adf_drv.c  |  8 ++++
 drivers/crypto/intel/qat/qat_4xxx/adf_drv.c   |  8 ++++
 drivers/crypto/intel/qat/qat_c3xxx/adf_drv.c  | 41 +++++++++++--------
 drivers/crypto/intel/qat/qat_c62x/adf_drv.c   | 41 +++++++++++--------
 .../crypto/intel/qat/qat_dh895xcc/adf_drv.c   | 41 +++++++++++--------
 5 files changed, 85 insertions(+), 54 deletions(-)

-- 
2.48.1

