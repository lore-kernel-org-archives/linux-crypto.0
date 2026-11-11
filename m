Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.15
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794440912;
	b=wb8i3bxdvDD7usw7eSOZ+bvf+F24V8j1hOUkyi5zr+S14S25QoDIyvO9kaU8dVzBziEL
	 M9qRx3WCNyvivtpxG8+TJvzKmOhetRxXBpCVA1m2zJeLGkJjun+WHmg7ZSP40pfu5rncr
	 9KBBqBUOiojxUEpm2hl15E3kn2opiXFC4jhP6P9xXjyWrCK9b5fUWuSopVVHy9BPl50BV
	 t0tpqqlTrw7DZwIQYnmiUDD9Wta796fwg865RngR3X3UpLMtfkGtWrNwUknDfLZQKJe4G
	 1GgoTcbrq3xihL4aYoyGb9NB0DOGiY37iMC/YOL2dCdDuSbpqHg8yToxsBNRwSTZsjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794440912;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Iaxxel5eQmGQTudIuvxMVFkeCpIWN6hgvbXS3j/ddMY=;
	b=qQsUdcJylFZ3kB+y4wOnQLS2UApIfE1v1tRGUNt+WPz0HFNZlVpS8/PCy1kfj6XvSnVg
	 P3pumpYxWXNKmQQ8K4AEk7OJ+AXOYwOeoyMK7vW+hT7ZG8yCD/3U0/ARaGosKJBkF8ksT
	 oxnenOjdAIedL2gYNv+/9qh4vRB/Dk3T/k7GwbqhDRe+lF+BuKqREu/1Lw6s6ldhof0uN
	 WewBccnG7njDQmUqlSqODm//EKYAi6ico+2Vz0twM5UefoSBBSsvD1QDnANoBfykGj8AO
	 FSiELaerkFCu8II6MoRm7fs0QhfBhTBb1I3YxQQ3msuf8exU5OqAWKvq3/K4A5zRcFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b="YK/w9e5I";
	arc=none smtp.remote-ip=192.198.163.15
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73EC7606C0B0;
	Wed, 11 Nov 2026 23:48:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 73EC7606C0B0
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=YK/w9e5I
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794440911; x=1825976911;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=F2WuUYmuXTPXL+P5748IfGeMmC4KPLynQ6+J0uAEp+0=;
  b=YK/w9e5IWHuHOGZCpyrIiUoz0lAFiaLXtm0kYASpfId+l4gbZDextDvN
   4jK8UuJ65ggGldkyBBHxkLRGMlRrq4ODK1fOGT3l2iRR3J6EnsWkzwudK
   EYDcUK3z776OVqqQJJ4WtFsw6F1Xa6i/dty4AZe96fBTgnFGqf4N3qOC8
   g9GvxlO2jcQ4WVnettuz8ZQpFxqacfcTe7taY/3kKa5Os0nK+Ys/+19xg
   Dw/hrAD4lfLx/wTqSf4yAE+GKBsAIb+3Kfl9Wigd6bkQ88Tv766WgkPLQ
   x+zgM+4xl0n6DvoRWaeNDX2ORGtb62M81rhn4Zm83Y5vl5PfMpPRAJc6R
   A==;
X-CSE-ConnectionGUID: AFHQjuDlTiq5kbiHN6Yy+Q==
X-CSE-MsgGUID: 72OqXOYOQyCXo7ACfUMtdA==
X-IronPort-AV: E=McAfee;i="6800,10657,11963"; a="3226584"
X-IronPort-AV: E=Sophos;i="6.27,208,1787036400"; 
   d="scan'208";a="3226584"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2026 15:48:31 -0800
X-CSE-ConnectionGUID: L4ZeofTETcawVOXtCfTrDg==
X-CSE-MsgGUID: WFO6/awMR/Gk2uILNvf7Cg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,208,1787036400"; 
   d="scan'208";a="8512363"
Received: from pavel-dev.sc.intel.com (HELO pepopov-mobl2.intel.com) ([10.3.206.11])
  by orviesa002.jf.intel.com with ESMTP; 11 Nov 2026 15:48:28 -0800
From: Pavel Popov <pavel.e.popov@intel.com>
To: "Rafael J. Wysocki" <rafael@kernel.org>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Hans de Goede <hansg@kernel.org>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Peter Huewe <peterhuewe@gmx.de>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: Pavel Popov <pavel.e.popov@intel.com>,
	Leon Romanovsky <leon@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Len Brown <lenb@kernel.org>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	"David S . Miller" <davem@davemloft.net>,
	x86@kernel.org,
	linux-acpi@vger.kernel.org,
	linux-pm@vger.kernel.org,
	intel-gfx@lists.freedesktop.org,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	platform-driver-x86@vger.kernel.org,
	linux-integrity@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/7] drm/i915: Include <asm/cpu_device_id.h> unconditionally
Date: Wed, 11 Nov 2026 16:48:15 -0700
Message-ID: <20261111234821.4814-3-pavel.e.popov@intel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261111234821.4814-1-pavel.e.popov@intel.com>
References: <20261111234821.4814-1-pavel.e.popov@intel.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

<asm/cpu_device_id.h> now has a generic version, so the #ifdef
CONFIG_X86 around the include is no longer needed.

<asm/intel-family.h> is included by <asm/cpu_device_id.h>. The CPU
match table still needs CONFIG_X86 for the INTEL_* model defines.

Signed-off-by: Pavel Popov <pavel.e.popov@intel.com>
---
Depends on <asm-generic/cpu_device_id.h> from [1]; please apply after
it is in mainline.

[1] https://lore.kernel.org/r/20261111234439.4098-1-pavel.e.popov@intel.com

 drivers/gpu/drm/i915/intel_cpu_info.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_cpu_info.c b/drivers/gpu/drm/i915/intel_cpu_info.c
index e52d0ac713a..a6b46cc841a 100644
--- a/drivers/gpu/drm/i915/intel_cpu_info.c
+++ b/drivers/gpu/drm/i915/intel_cpu_info.c
@@ -6,12 +6,11 @@
  * intel_device_info.h by having a separate file.
  */
 
+#include <asm/cpu_device_id.h>
+
 #include "intel_cpu_info.h"
 
 #ifdef CONFIG_X86
-#include <asm/cpu_device_id.h>
-#include <asm/intel-family.h>
-
 static const struct x86_cpu_id g8_cpu_ids[] = {
 	X86_MATCH_VFM(INTEL_ALDERLAKE,		NULL),
 	X86_MATCH_VFM(INTEL_ALDERLAKE_L,	NULL),
-- 
2.54.0

