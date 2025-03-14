Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B7351FA272
	for <linux-crypto@vger.kernel.org>; Fri, 14 Mar 2025 13:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741957781; cv=none; b=JzJ00fAzsJ6+124Q9v8P2XNKcWR7iTetqPpOXwd9jbifD29Lg5AKHu7pgYkNxpsCBH6b5Psu+konn14rHxgfb1PrP+FiDjbZFjJOAkBeIKGi+16GMjQxR5CrorbXeWq+N1hv8ToVa8pFlKqU8BGpiszOKCKzqoTr0U87S0DZ7uU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741957781; c=relaxed/simple;
	bh=x61soED9cEAZuhXI3ZEXRJyIZbZZarbiTe0BKXVMlis=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sBjyaelCleEbD6yn+J17wvFzXQan2GpFKO3xvEZRbblOUdYWqi5+zEezGPdXXai1tfXiZ0FoInG58v1kPTG+nUuCvt7+o25+m7DYgwj0snAsr/biM2sOI6vabl91h1zDpp6gFFBaxWFXhON12f8/qLP9VT1UXJi8AJ9+b7GMdTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bu3fOWJ2; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bu3fOWJ2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741957780; x=1773493780;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=x61soED9cEAZuhXI3ZEXRJyIZbZZarbiTe0BKXVMlis=;
  b=bu3fOWJ28ewNmdrUePpPgwGm3iCprtIJzuxrvhCaI4yq/qEs9JO1dSQw
   YfLh7MIQs9cx7XwqQVQPuUACynx1wFK9zxjwAUFiYOP1s7nwXLOVSJlPi
   UUJgCAL+7cYghZLoJJ8w9C4Yv9JxvDbiDnPXfDIk0Sm+wIna5KxrhouvL
   u6UfaLBznd69i/I0q7poVnkpEn8mhGmr1LpS9juYMLHmVjv2zVjqbbBKA
   9JgYLVmnPEGaLrae6DGnT9goUY2IeWnuTHlGzVbztytEdBnLMVp8nQvFh
   uyrvwRr4B4GpVriEIVixhfIb2a+NaQ+KYQCboMmJXbKKCQYgbvT0QRiT+
   Q==;
X-CSE-ConnectionGUID: M87K8MEEQzKgGORILiwRDg==
X-CSE-MsgGUID: CgZWO+1vTMSmsT+G7RIzog==
X-IronPort-AV: E=McAfee;i="6700,10204,11373"; a="53762321"
X-IronPort-AV: E=Sophos;i="6.14,246,1736841600"; 
   d="scan'208";a="53762321"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2025 06:09:39 -0700
X-CSE-ConnectionGUID: gAwOWBYzQbSLbFUXICFrqw==
X-CSE-MsgGUID: hDfLoyioTmKsPaemX3PYnQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,246,1736841600"; 
   d="scan'208";a="121072099"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.223.204])
  by fmviesa006.fm.intel.com with ESMTP; 14 Mar 2025 06:09:38 -0700
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 0/3] crypto: qat - add improvements to FW loader
Date: Fri, 14 Mar 2025 12:57:51 +0000
Message-ID: <20250314130918.11877-2-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit

This small set of patches adds some minor improvements to the QAT
firmware loader.

- Patch #1 removes some unused members in a structure that are not used
  for doing the firmware authentication.
- Patch #2 removes a redundant check on the size of the firmware image.
- Patch #3 simplifies the allocations for the firmware authentication
  an introduces an additional check to ensure that the allocated memory
  meets the requirements of the authentication firmware.

Jack Xu (3):
  crypto: qat - remove unused members in suof structure
  crypto: qat - remove redundant FW image size check
  crypto: qat - optimize allocations for fw authentication

 .../intel/qat/qat_common/icp_qat_uclo.h       | 10 -----
 .../crypto/intel/qat/qat_common/qat_uclo.c    | 38 ++++++++++---------
 2 files changed, 21 insertions(+), 27 deletions(-)

-- 
2.48.1

