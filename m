Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.15
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794440908;
	b=0RjZTok0xpDR3zoQAEMsEPSDTcMBDxZm33EWlfoKJ22YJoZWBTHMNmpkwR/FAvppi48s
	 7oxl5Kgond7EkhiQCRDn2+kqbrKoQghiBCpqsZIEX5Bylr26VOfcqktUSiRmIIOhn1OPV
	 7i0CoeZ2yuXSaLLGf8GJtUmbnSoQnunFP6+BGmsB9Cz5H51yNI96RJiBlsGL6KueJ8whh
	 eGXIoUpydbdIBoY4srj5d6J7/sWX2ZAd0UZsJbJOTHMT38dpattAFkDMEIN6dpFYC4Bz3
	 a8EgwOBbgk6PidUL4912JKeZjyu964cDQf2+8PuNqABDKrqwY6FVB7U0wtJGRceJDWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794440908;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=XO1zQrLz3nIsHawtV3uJziG/lt6mZI7/S/VXd3Xpoi8=;
	b=K7hUhUPoh2o88OBRcaPfF4IYK+0gxWnjWSr+I05mNIx6MKmNploc0EToTeLGBh4CnB6a
	 L479QzNkiAihgXz3AIs+vU07PYvPuFDo1r6oXR1nmHTrrBId2jnhCB9k1H9oFATm7zpoX
	 rNf9TDMW+n1EbGmbjoIL7wwYKQwGDZzwqrWdLsFFfio/fuIka+LN4YLvbbZXBPC/l398h
	 NLC7rRA6N4c6mvEsDCbaxaFOE1tkGdLiSFPg3ZHfNufNJVdWdwhGuSuE7+k4pmi3GVYv0
	 xEpSKs2m3OBQAiZMlpJBwHcHLf3dLWP/yjepgXg90p3LbIAIGPG9z1h3fCp1SFjkNSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=BQ4GfNMt;
	arc=none smtp.remote-ip=192.198.163.15
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2791E606B5F7;
	Wed, 11 Nov 2026 23:48:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2791E606B5F7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=BQ4GfNMt
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794440908; x=1825976908;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=q1YR4O6Pn8a/WBsLbrw9tPRH3nJNXpm/xlU+/ogg2iY=;
  b=BQ4GfNMttcAeoC0VG7NCztOU4xqbzRr3/lTWWsfs74GtED7WwEwDlmy2
   /fwKYT4gdnM/M/5zZXQ2kyF5Ko6wc8rbGpjspTeVelJBYxCZWfCA1auan
   CEld6MfUAX1624K0mZaG6IqPErcUPtUDJ+LED36lSeUCMgwPjLrN2XQhl
   PmaH4NDbrC0x1t2k7V/aeXuV9KiG0QB41fMoO2IV0YBw+IDN6qiJU3qCC
   30QAXSLx4SpwNKLp1gIerFVSOzJR+dXB0HXbJfV1wpIXkgjImcd+3mLzn
   8eUvI7oFK9QYl8MKBQDVnR+dHkHvmwq1Avt/2fy/w+/vQ0UtVm83mtF/I
   Q==;
X-CSE-ConnectionGUID: VZ4dhDsDQwOwa/NHXpDUvw==
X-CSE-MsgGUID: isGGlXKiTMKSktYl2qeibg==
X-IronPort-AV: E=McAfee;i="6800,10657,11963"; a="3226568"
X-IronPort-AV: E=Sophos;i="6.27,208,1787036400"; 
   d="scan'208";a="3226568"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2026 15:48:27 -0800
X-CSE-ConnectionGUID: F05e9Uf3T3Wyn+R/qG/Pzw==
X-CSE-MsgGUID: Xo/xsAjGQ+KBqS19hoz1WA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,208,1787036400"; 
   d="scan'208";a="8512353"
Received: from pavel-dev.sc.intel.com (HELO pepopov-mobl2.intel.com) ([10.3.206.11])
  by orviesa002.jf.intel.com with ESMTP; 11 Nov 2026 15:48:24 -0800
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
Subject: [PATCH 1/7] ACPI: mipi-disco-img: Include <asm/cpu_device_id.h> unconditionally
Date: Wed, 11 Nov 2026 16:48:14 -0700
Message-ID: <20261111234821.4814-2-pavel.e.popov@intel.com>
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

 drivers/acpi/mipi-disco-img.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/mipi-disco-img.c b/drivers/acpi/mipi-disco-img.c
index ea4bffe3c02..3d841d2bdfd 100644
--- a/drivers/acpi/mipi-disco-img.c
+++ b/drivers/acpi/mipi-disco-img.c
@@ -30,6 +30,8 @@
 
 #include <media/v4l2-fwnode.h>
 
+#include <asm/cpu_device_id.h>
+
 #include "internal.h"
 
 static LIST_HEAD(acpi_mipi_crs_csi2_list);
@@ -724,9 +726,6 @@ void acpi_mipi_crs_csi2_cleanup(void)
 }
 
 #ifdef CONFIG_X86
-#include <asm/cpu_device_id.h>
-#include <asm/intel-family.h>
-
 /* CPU matches for Dell generations with broken ACPI MIPI DISCO info */
 static const struct x86_cpu_id dell_broken_mipi_disco_cpu_gens[] = {
 	X86_MATCH_VFM(INTEL_TIGERLAKE, NULL),
-- 
2.54.0

