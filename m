Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.15
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794440921;
	b=pPBdb31EaCUk8HYxJ+BV6WMbr3VerIK/hTZkxH+Wd6xJyhg+4qG1ICYS0j/fBQQFl9om
	 M7h1LY4jmKTr4ZPmkVIqvie5lNSApRi6X4fUgqyPGPQyApq2ZjIpNQd/x1FV1kFu73kZm
	 BwymkNdozb+RFPfvmBwWId3PfFNhnqkhRRC/N24sMMsbBKATUTZ0/2IN1UGSWpgpzVcPZ
	 R6bFI5iRh0jK8XIJ1HrJxwpg+2Ecmc/SWfNCI/g8ty5PgZJE7SMH8LD61flxfEPeGOyQs
	 NIyktHikejkAaXKAmd5YV7qTo965oXlZvBKFv7n68f0L4M18bONPtFzzMUvc765DtWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794440921;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=teUkDlBsFC75QpkoWcN48OfuKOIq3Y+BujDYIw7Usi0=;
	b=snUQJx1k5aXaeSFAqKA2V5yyuKgGRNYrkz51monfhCzcG9gjkp3dYWw4ULCuEnbycIkE
	 6Ewp2xfglI6be1+9/FP76NzbPBRUvIdkpY/LUX9o38EQzd6QAvMqr88b8sZ5TnOFnAc4m
	 OPu0DQig1aQgPfIr1w535kWE6uvJGFEJZsCF1FpnaWpgZGiBMyzOmw0tYkAS/f1hG9MHy
	 39Fmuon42QLurM4hIb4vTo2uStjJC2dzPDsJbrGwOFx80g8gpLFeiG95vyKM2yJLZFgJD
	 mW4O3g/3cJJLxciWmGlJErUBfXPjVeDCg/ijZt5DoDvH0CxNGeqXi7vc6kWg87zLPgw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=OWCjr9mn;
	arc=none smtp.remote-ip=192.198.163.15
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1715460A381C;
	Wed, 11 Nov 2026 23:48:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1715460A381C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=OWCjr9mn
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794440921; x=1825976921;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LbqPMUJ9s/Em7VE9Jtp+i/h5pc5nAbcke2q0A+92Q/4=;
  b=OWCjr9mn2nrc02WoAPRWSRHQ9v37iSYqrxZTgxm7zYLIhNxZ4zNc87vu
   6qfa9ss42iJOsMKDH9GZffzbf/3z7ogkk56r8Ni2hrtRSfScDlbTYpxOJ
   xrpWwziBFXuPjubyOxhRM3Uf7QvDILGYfOnBkaO0M5IV+ZdIWNcOPsVRX
   S0ACPrVm+zNuiu2fb95TtznXI4hZh8+/pYoljn/WmkGhDZRJitRGqHoz/
   Mhs7hKorIkR6gQwy3buCs2VEjXaoTl4cUH5k/JWOebinWHKDhaya+DEZP
   TprKFgtL9Xako1nM0X+99rzX3vCj7c3htLcfPCocA9/HoybdbYHthsctn
   w==;
X-CSE-ConnectionGUID: 7uYHuc8pS4q8h47nK4GIYA==
X-CSE-MsgGUID: brKyZ++rQfq523FBg8z/dA==
X-IronPort-AV: E=McAfee;i="6800,10657,11963"; a="3226637"
X-IronPort-AV: E=Sophos;i="6.27,208,1787036400"; 
   d="scan'208";a="3226637"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2026 15:48:40 -0800
X-CSE-ConnectionGUID: /wS0d+LcQ1G5pwpb06qR5Q==
X-CSE-MsgGUID: CH9XoWbpTHm6yFq5s4nd8A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,208,1787036400"; 
   d="scan'208";a="8512393"
Received: from pavel-dev.sc.intel.com (HELO pepopov-mobl2.intel.com) ([10.3.206.11])
  by orviesa002.jf.intel.com with ESMTP; 11 Nov 2026 15:48:37 -0800
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
Subject: [PATCH 5/7] platform/x86: Include <asm/cpu_device_id.h> unconditionally in soc.h
Date: Wed, 11 Nov 2026 16:48:18 -0700
Message-ID: <20261111234821.4814-6-pavel.e.popov@intel.com>
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
CONFIG_X86 around the include is no longer needed. The include of
<linux/device-id/x86_cpu.h>, which is generic, moves out of the
#ifdef as well.

The soc_intel_is_*() helpers still need CONFIG_X86 for the INTEL_*
model defines.

Signed-off-by: Pavel Popov <pavel.e.popov@intel.com>
---
Depends on <asm-generic/cpu_device_id.h> from [1]; please apply after
it is in mainline.

[1] https://lore.kernel.org/r/20261111234439.4098-1-pavel.e.popov@intel.com

 include/linux/platform_data/x86/soc.h | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/include/linux/platform_data/x86/soc.h b/include/linux/platform_data/x86/soc.h
index a6a6b313dfa..ee696e576a0 100644
--- a/include/linux/platform_data/x86/soc.h
+++ b/include/linux/platform_data/x86/soc.h
@@ -9,13 +9,12 @@
 #define __PLATFORM_DATA_X86_SOC_H
 
 #include <linux/types.h>
-
-#if IS_ENABLED(CONFIG_X86)
-
 #include <linux/device-id/x86_cpu.h>
 
 #include <asm/cpu_device_id.h>
 
+#if IS_ENABLED(CONFIG_X86)
+
 #define SOC_INTEL_IS_CPU(soc, type)				\
 static inline bool soc_intel_is_##soc(void)			\
 {								\
-- 
2.54.0

