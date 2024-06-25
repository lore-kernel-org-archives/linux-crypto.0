Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DD001BC57
	for <linux-crypto@vger.kernel.org>; Tue, 25 Jun 2024 14:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719326224; cv=none; b=cgRjjOwxZDXyteEqjvfEamKaxlEKT2sHkdEib1z5d2Os+NqRqnZY4KETV6q4GggLRDttM+tHfqFTxUH7y08plALDtya/zTYjyXk67lG+tSH00Mj5KhCApR7vJAlEiIAMnfbaoaq4F31J/1QkLQHUSHJkNdU2GUho1yuV6OoPZoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719326224; c=relaxed/simple;
	bh=JABPh5kbiWufGNmHKqZxbo988NZNSUexAQHsXt+D1PA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=olLl7QFw5BvKXg8845/lj/1shSvZaGp8qHC0w2bmLc2GyV0GBbsGSld22x4/h8XPykfuSPMcEeSJZXv+savjC0bgL6DvDj1t+6C5sc2E3zwGyestL+vhLXiviobfw9piCGZj/rcGqbWt3Lx/LnM4HsVXJMqslALrmakqEnPPyo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=m7WzfKBX; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="m7WzfKBX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719326222; x=1750862222;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=JABPh5kbiWufGNmHKqZxbo988NZNSUexAQHsXt+D1PA=;
  b=m7WzfKBXmzT5xXDh4zt9icVqRRkQXRCrb79D+/gPrEyTZ9J6oeUAvwDQ
   3r4ox8lLj2heI7ax0cdn8WZoF5UQjbCIJEMpvfsWrvrzODj36xdH/RcFy
   JEwgSPTtQXqA0hyzVr3B7dUnXBguUpezvQunuykultxu/KylQHCdsrzkQ
   O49IhKxY4ga76gVVoq0ipJEb2Ecc1vMqvd618GjUkfx3f01/Kb9Vftulv
   dS61FY4AbFUELBhw5ISM9GYsQV0JJSZd5kBQEb5GF/uIZn9ELTtAUsm6L
   9ukH0Pq/2p8Cc1THi0EEiRk7/0zUd0GyqIeXREtHX3IzG6gZdXNEV91E2
   A==;
X-CSE-ConnectionGUID: LlRthfnyRXOA5yZ8+lZvZQ==
X-CSE-MsgGUID: z4nFh/TKRF+5D8WnwlyNcw==
X-IronPort-AV: E=McAfee;i="6700,10204,11114"; a="27755784"
X-IronPort-AV: E=Sophos;i="6.08,264,1712646000"; 
   d="scan'208";a="27755784"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2024 07:37:02 -0700
X-CSE-ConnectionGUID: jLJpuN8bRRik3o6sHYi1pQ==
X-CSE-MsgGUID: Cw7RF2tXSb6copCPVVUOJQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,264,1712646000"; 
   d="scan'208";a="43539878"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.216])
  by fmviesa007.fm.intel.com with ESMTP; 25 Jun 2024 07:37:00 -0700
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Damian Muszynski <damian.muszynski@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH] Documentation: qat: fix auto_reset attribute details
Date: Tue, 25 Jun 2024 15:36:44 +0100
Message-ID: <20240625143657.3381-1-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit

From: Damian Muszynski <damian.muszynski@intel.com>

The auto_reset attribute was introduced in kernel 6.9. Fix version and
date in documentation.

Fixes: f5419a4239af ("crypto: qat - add auto reset on error")
Signed-off-by: Damian Muszynski <damian.muszynski@intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 Documentation/ABI/testing/sysfs-driver-qat | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-driver-qat b/Documentation/ABI/testing/sysfs-driver-qat
index 96020fb051c3..f290e77cd590 100644
--- a/Documentation/ABI/testing/sysfs-driver-qat
+++ b/Documentation/ABI/testing/sysfs-driver-qat
@@ -143,8 +143,8 @@ Description:
 		This attribute is only available for qat_4xxx devices.
 
 What:		/sys/bus/pci/devices/<BDF>/qat/auto_reset
-Date:		March 2024
-KernelVersion:	6.8
+Date:		May 2024
+KernelVersion:	6.9
 Contact:	qat-linux@intel.com
 Description:	(RW) Reports the current state of the autoreset feature
 		for a QAT device
-- 
2.44.0

