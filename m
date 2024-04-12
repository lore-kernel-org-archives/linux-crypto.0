Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77C904C624
	for <linux-crypto@vger.kernel.org>; Fri, 12 Apr 2024 12:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712926002; cv=none; b=irDRRie/Xj+lpSPKQ25h2moJhUeeCTYDfC2Mt7xCodBUFCe7JKcdk5CgI8DmD58EFFYoMo+54v5sTyNV3KEc4KVwkQO4JMnBTOLJDnYq83I06lfyDiEhLq0BUSuTS1HH9KHwf6pXlziQcbdezysKAIncqAPQtO6kPWfajjzHNpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712926002; c=relaxed/simple;
	bh=tZ1ZbqAnT8ir9mCfI1SAc5683Xq2nUN8AWo0xR6nHdo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=QMTY758CQwZIBAuweanraIRfdqfbETnXfb9zomZWuAGI0t/Ps1dUejPCNhesgs3aJMsSfFJUX6Lhnc+O7uEhmSJTuVV8kCRWDiwqCKM1bKNwRbZWd0fvENoHktn8wiXNlcTuO3a6qcu1jHxmOCTQuZSlopnHilCBhHtACdNkzls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=I3MR8ipI; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="I3MR8ipI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712926001; x=1744462001;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=tZ1ZbqAnT8ir9mCfI1SAc5683Xq2nUN8AWo0xR6nHdo=;
  b=I3MR8ipIRgmNcIZu44anJ/VxePRiKBswLupM22qxW4kZ9fsorsGzw7zQ
   TnqJY7n1bSbVkVNpRELh802nAc1Poxx7etG5MBiU0lGhbQI9lMBpQJt6C
   NUlgnP0XGjHXDZFpSx9U6cpyHMh2ThQzvNagn6tcdfZ99KfeTX9ywT30k
   ZXxOzGZwaIjtDQn9JllbL8uCx1ll3s7I2KWs4GX1OKvOq/ZJoFLKLJ493
   fRmwq8EtaqTmh5y0QE/4kf6klWLXA+TBpHOwyIdVDKbWMoYNStHKSzs2A
   6crIkUGkGaFpajU1tR+5JtGhWhyyyabkUhPjkO+XKSnBef0RJ7JS4FhR9
   g==;
X-CSE-ConnectionGUID: dy8E/Z2IQ9KcFFMkeLPWxA==
X-CSE-MsgGUID: vsoKezBfQSurlK1xgGxeQw==
X-IronPort-AV: E=McAfee;i="6600,9927,11041"; a="19529091"
X-IronPort-AV: E=Sophos;i="6.07,196,1708416000"; 
   d="scan'208";a="19529091"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2024 05:46:40 -0700
X-CSE-ConnectionGUID: spt6bk7QTDCnwhLiqghgcw==
X-CSE-MsgGUID: WUmQaofmSiKvQL5B+Mfxzw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,196,1708416000"; 
   d="scan'208";a="25902077"
Received: from silpixa00400295.ir.intel.com ([10.237.213.194])
  by orviesa003.jf.intel.com with ESMTP; 12 Apr 2024 05:46:38 -0700
From: Adam Guerin <adam.guerin@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Adam Guerin <adam.guerin@intel.com>
Subject: [PATCH v2 0/2] Improve error logging in the qat driver
Date: Fri, 12 Apr 2024 13:24:00 +0100
Message-Id: <20240412122401.243378-1-adam.guerin@intel.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organisation: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare, Ireland
Content-Transfer-Encoding: 8bit

This set simply improves error logging in the driver, making error logging
consistent between rate limiting and telemetry and improve readability
of logging in adf_get_arbiter_mapping().

v1 -> v2:
 -fixed commit id in fixes tag of both patches to be 12 char long.

Adam Guerin (2):
  crypto: qat - improve error message in adf_get_arbiter_mapping()
  crypto: qat - improve error logging to be consistent across features

 drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c | 2 +-
 drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c   | 2 +-
 drivers/crypto/intel/qat/qat_common/adf_rl.c           | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)


base-commit: 0419fa6732b2b98ea185ac05f2a3c430b7de2abb
-- 
2.40.1

