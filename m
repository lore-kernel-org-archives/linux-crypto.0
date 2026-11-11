Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.15
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794440918;
	b=VTj3FwD3Jt5uxiEu8Z/D4Pl6k1P38EixCRmS/FcZu3NHIsDM8qKPhH3jOXApXVTakP5u
	 LPnbQ7uzpASB05X5R+YIQqzM7bceIbdVrUkdoWZDQvalODwSRaxCHG3Wy3JaDqq+iDOkv
	 iPOiitMGUy2N8gQOdsbgWK1fusHLCE1qlpT4uvjz8jl/KiFVbHP0CzlQ3zRzIUnd3wqOm
	 2KaPe0bB6bQYHQAyZxWdQAS7tCUtEH/VqzeX+SRbCGjoldEMFOVSaZgYioMPxQqs+Hvx6
	 7QuNN1514scFP2oAwoFtsWBhnRqV7E2a1s4FeABbSR5icCGoFbD93GweZ7NPlON8Ygg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794440918;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=RTEzT24mGfCmMXNTDbKofHgfVLGW6QdVWlksf5weadY=;
	b=spGrhYzkISjRVo0YRn2KuG/AOUKRcnHTr2IEMtemzhzQqBkLMvMup4xE73WgoRG2+sLh
	 mwMvvTVvfghwElfaKoBgjJI9FgudgZ+wyvrnhxWKmqa23/GOYSEzoIeNRQjDIBsAL+oNp
	 9L8D0yJqxE47p4/2756TsVeFtIPgPLHe5MX1zpW581T0VQOMfl4nfYEcvnEPiDm7Zeqa4
	 7s8dDqWVwi4SSZAzBW+wJ0eO6zdh6XVLpjv46m9p76RCbRcxStCZsCz9nJPaWy06CSfll
	 JuKQ+U0f83ovZ0SifRYDgCrCuEJ4Vll2vctH1l2m4Q4/RK2q12bPwRvlthNSq9vgH+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=gyAGYXu0;
	arc=none smtp.remote-ip=192.198.163.15
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1A2C60A2622;
	Wed, 11 Nov 2026 23:48:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E1A2C60A2622
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=gyAGYXu0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794440918; x=1825976918;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qiTprQcvixtyWKG6YcvfO8nQP3PU4VUrniMboE6NSkI=;
  b=gyAGYXu0++GouxpOqlvz4AE0UESwZiHddy1GtCYInd4ZlrehbkYhRlUS
   6e8Hz+pLp5W/fJ0NWTiK65HE6GIAwM+0my0QS1OF8JzK44J4ot8aBYyb7
   i+9SWp2KFqMCwzNFDgR5HpO8wntHWySXxhDftp7AFRBzXi4JzSmu0FFyS
   oHsM8lPMo4g81t6nzOB3Pmg8mJIrPwn0LnJ1oHHp+2HDWskrfoGr9dm5y
   0+0jdhqTvxnTEyLyEssOJ7pa7dcljB2d1gqYbY8TR/aXHxfWzgrRFowpQ
   RcqorQm77jx+WDNuJsF1sesslbNczN3ECI+rn+Il94jv94TGlZZua77fi
   A==;
X-CSE-ConnectionGUID: KCyVcGU2TjSmtUi5mP2wkg==
X-CSE-MsgGUID: 5YR98Z95TNGWExXLbwV9Pw==
X-IronPort-AV: E=McAfee;i="6800,10657,11963"; a="3226618"
X-IronPort-AV: E=Sophos;i="6.27,208,1787036400"; 
   d="scan'208";a="3226618"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2026 15:48:37 -0800
X-CSE-ConnectionGUID: VLtbyyzhTuu5gT0SuDLr3w==
X-CSE-MsgGUID: LreG1qb0TWiBf5byqg7Q0g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,208,1787036400"; 
   d="scan'208";a="8512387"
Received: from pavel-dev.sc.intel.com (HELO pepopov-mobl2.intel.com) ([10.3.206.11])
  by orviesa002.jf.intel.com with ESMTP; 11 Nov 2026 15:48:34 -0800
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
Subject: [PATCH 4/7] cpufreq: ondemand: Include <asm/cpu_device_id.h> unconditionally
Date: Wed, 11 Nov 2026 16:48:17 -0700
Message-ID: <20261111234821.4814-5-pavel.e.popov@intel.com>
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

od_should_io_be_busy() still needs CONFIG_X86 for boot_cpu_data.

Signed-off-by: Pavel Popov <pavel.e.popov@intel.com>
---
Depends on <asm-generic/cpu_device_id.h> from [1]; please apply after
it is in mainline.

[1] https://lore.kernel.org/r/20261111234439.4098-1-pavel.e.popov@intel.com

 drivers/cpufreq/cpufreq_ondemand.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/cpufreq_ondemand.h b/drivers/cpufreq/cpufreq_ondemand.h
index 2ca8f1aaf2e..0e33865f9d3 100644
--- a/drivers/cpufreq/cpufreq_ondemand.h
+++ b/drivers/cpufreq/cpufreq_ondemand.h
@@ -6,6 +6,8 @@
  * Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
  */
 
+#include <asm/cpu_device_id.h>
+
 #include "cpufreq_governor.h"
 
 struct od_policy_dbs_info {
@@ -26,8 +28,6 @@ struct od_dbs_tuners {
 };
 
 #ifdef CONFIG_X86
-#include <asm/cpu_device_id.h>
-
 /*
  * Not all CPUs want IO time to be accounted as busy; this depends on
  * how efficient idling at a higher frequency/voltage is.
-- 
2.54.0

