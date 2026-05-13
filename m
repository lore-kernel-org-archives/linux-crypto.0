Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DD6827442
	for <linux-crypto@vger.kernel.org>; Wed, 13 May 2026 15:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778686412; cv=none; b=QRRdnAPho/zih6acLLdGGGPdh1VUGmqJakKbtEU/1unl5l9/xyE3Eq3qUZ2bC9lp+zYeQ7/Eym5jXPppu7XuAhzsOb7FxdNV2tCOB7JtOcFXxh0TZivn8zDtS/livFvEAKrGOIjkzWVPhVJ1IXgKugYYYvkbF/dOn26A76vNgW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778686412; c=relaxed/simple;
	bh=WjTG+hED0D3CSbUxzhIJGLKkhosJqIXmDoTFHofVXio=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iXs32ZwaziQq7ot2InvbjxsFYqjmpjZ3NWQ8xsIzV2RK+jKvuSiTtcH6uSr6vL/M/5OAcLLHM2YZhY73b23YbSQRkZE/RHyv2HJxwvYmRv0Poj0jYW/0Z2+fPVha6mDkYA3GxbcvFIstbBNLSqYpOdId2jueIcjbpjxck1tJBgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dtXKzVHI; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dtXKzVHI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778686411; x=1810222411;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=WjTG+hED0D3CSbUxzhIJGLKkhosJqIXmDoTFHofVXio=;
  b=dtXKzVHIkmmaUI4bOlBL8YqXiFdP7yiCEgBoGKzNBOVcF0i2b7Te6qtc
   vNnAG2bdD2icVWELumH9VtYcKYRv6l/yPBcWp7AxiRzcKCmZqY2xbN6YK
   EYsg1QcOruh+Tjya5abQYVgdmy5eLvd1eiaJ7XVtum5CTuzIrS/TxPtDL
   vHke6v0fQf7ZwGuhE3dvWTYPoIV+IBH/pHhRdcFMEKMs67av9kGPIWcR5
   /4PbSzf/PIN1ZbaEUt0Z6JuDUJBXK1XtqUAfWi0yDN95cXDV5DJZOjmyI
   LI97Eudu4Igud1hBL/N8uZOHVhbgNzAq9TuIG51EoEK1fEtF4w3C0znzj
   w==;
X-CSE-ConnectionGUID: CI2poggTQliooIbfYzcDgA==
X-CSE-MsgGUID: BE8857MuROC5yykbb6+wGQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11785"; a="83230752"
X-IronPort-AV: E=Sophos;i="6.23,233,1770624000"; 
   d="scan'208";a="83230752"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2026 08:33:31 -0700
X-CSE-ConnectionGUID: KX6ULEJyTIm4HXZvAoJlwQ==
X-CSE-MsgGUID: KpojcKaZTc6MhwLtqjX4bA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,233,1770624000"; 
   d="scan'208";a="242120640"
Received: from unknown (HELO fedora.iind.intel.com) ([10.49.0.89])
  by orviesa003.jf.intel.com with ESMTP; 13 May 2026 08:33:29 -0700
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Fiona Trahe <fiona.trahe@intel.com>,
	Ahsan Atta <ahsan.atta@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH] Documentation: qat_rl: make rate limiting wording clearer
Date: Wed, 13 May 2026 16:33:08 +0100
Message-ID: <20260513153317.32355-1-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit

From: Fiona Trahe <fiona.trahe@intel.com>

The term "capability" typically refers to an ability to perform an
action, whereas "capacity" denotes a measurable amount of resources.

Since the sysfs-driver-qat_rl document describes remaining resources
available to perform work, "capacity" is the more accurate term.

Replace "capability" with "capacity" in the document.

Signed-off-by: Fiona Trahe <fiona.trahe@intel.com>
Reviewed-by: Ahsan Atta <ahsan.atta@intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 Documentation/ABI/testing/sysfs-driver-qat_rl | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/ABI/testing/sysfs-driver-qat_rl b/Documentation/ABI/testing/sysfs-driver-qat_rl
index d534f89b4971..422333a0eb69 100644
--- a/Documentation/ABI/testing/sysfs-driver-qat_rl
+++ b/Documentation/ABI/testing/sysfs-driver-qat_rl
@@ -209,7 +209,7 @@ Date:		January 2024
 KernelVersion:	6.7
 Contact:	qat-linux@intel.com
 Description:
-		(RW) This file will return the remaining capability for a
+		(RW) This file will return the remaining capacity for a
 		particular service/sla. This is the remaining value that a new
 		SLA can be set to or a current SLA can be increased with.
 
-- 
2.54.0

