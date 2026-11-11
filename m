Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.15
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794440925;
	b=YMRtp6GHORXH9ImzaoYsGw7/XZpPqS1Tw6YmHsFzrbae2DoxpDX+bnbjbzcLSBlnWGWE
	 eSBxG7EgLZaycQMx4d1xSvCx/vAn3G+g8KzlGrPoJm1G1fkmlUSby1X/puUCaDow7E87q
	 othcSuHEItJhMbBnj+PcMPuCeUgfQW27qqBwLRZQDqXMnXnf1J8ITt4CvEkJpnOP5/U3q
	 PYrNY4GxwGE9ivinlGeg7I9ZbhwfLXTj4ae/6odOpshFPq/05vbPq5G/F2MOD4pYVPHrv
	 /392WI5JXXwghv5aK5tHdDEKpDKsDIzN8aZ+tyGTYR6C8hDHDlYTvugh1wLbpSX88Gg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794440925;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=XJOKEouKH2OpPfZtwIGRyzyFEU1XQVmfYEayBgUikfs=;
	b=276UoTonIcqxyWEWHA8sY1U2xjnKYJZHuE51FlSO4C+TCKcavO7ngzWV/DRF0yjUVCtD
	 Skn9lLos4o8vNicVWs0bjBJVuqcwk84Hf1D7cRFe/s0jHqPhjYFdTzIjByeTTBelEcGRR
	 rBR9PAn1JsZbmwXe1v5nVAGHZH6pQavIIWYX9BjDhmdhiLkPtKQsE3+KLusowxsz63qfV
	 Ewo5IJfT38lRn6+zYjwXyICRdnd5QV84NhBiSo4gt5xGwr8KCzberKertwq0x9WYzahja
	 +YBuL5aoLI0O+50QfPCCCTV7210eW661mP113PhtV9AKY8zQFCnmh8vpl7grIhnIiOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=E2QiMpt5;
	arc=none smtp.remote-ip=192.198.163.15
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA620606AE63;
	Wed, 11 Nov 2026 23:48:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CA620606AE63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=E2QiMpt5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794440925; x=1825976925;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=u5AVXTElJz7EZV2h5YwoTsJFHDCSeIjHVrhKH9eyfwI=;
  b=E2QiMpt5MfsPpHXSQPG5TZn+rJlTRWvUM4K5ky6tXx/I0iEjnhOgOS2G
   nxmlZF3+/u+mqIAb59MNyY7mcD30KviPBQ6TsbDBSO+mJIE9tirUDvURv
   pV4S/4oTU5HiISeNALAXNZA0UhBp89N0doGqyarllCqrtVOuMoz+jlx8X
   pvsltLHQvW65pHnHC3eEVwJJS814rHXnCUsab60rWdMukeOUSEtkfZ3Ml
   g6wVdNJGed3bTFYQIKV9b3lwSL5HXDp8bKK6X6ii3OP4k9gQ9njNftHPb
   N5/xLvwXs24XZ6muMaXE14nEpuHx2ogudzNDiPTQE8pcVUUGVKfd5uJWJ
   w==;
X-CSE-ConnectionGUID: wBpGsaGEQym2DyYG5weiJg==
X-CSE-MsgGUID: Ukz2egaRT1+iGwhhRe9LSw==
X-IronPort-AV: E=McAfee;i="6800,10657,11963"; a="3226657"
X-IronPort-AV: E=Sophos;i="6.27,208,1787036400"; 
   d="scan'208";a="3226657"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2026 15:48:44 -0800
X-CSE-ConnectionGUID: o71bEf/wRTCxDbrm4F0BNA==
X-CSE-MsgGUID: YEu72Nx6Sn6B9UBCg1VsnA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,208,1787036400"; 
   d="scan'208";a="8512405"
Received: from pavel-dev.sc.intel.com (HELO pepopov-mobl2.intel.com) ([10.3.206.11])
  by orviesa002.jf.intel.com with ESMTP; 11 Nov 2026 15:48:41 -0800
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
Subject: [PATCH 6/7] tpm: Include <asm/cpu_device_id.h> unconditionally
Date: Wed, 11 Nov 2026 16:48:19 -0700
Message-ID: <20261111234821.4814-7-pavel.e.popov@intel.com>
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

Signed-off-by: Pavel Popov <pavel.e.popov@intel.com>
---
Depends on <asm-generic/cpu_device_id.h> from [1]; please apply after
it is in mainline.

[1] https://lore.kernel.org/r/20261111234439.4098-1-pavel.e.popov@intel.com

 drivers/char/tpm/tpm.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index fa554c5ad80..ad1534aa00c 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -28,9 +28,7 @@
 #include <linux/tpm.h>
 #include <linux/tpm_eventlog.h>
 
-#ifdef CONFIG_X86
 #include <asm/cpu_device_id.h>
-#endif
 
 #define TPM_MINOR		224	/* officially assigned */
 #define TPM_NUM_DEVICES		65536
-- 
2.54.0

