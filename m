Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.15
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794440915;
	b=Mxw8nA5ns7Fi2Qz9DWQnvzeVzI7+ptFINwkIzj7B1RmBr1Fvz55LOm9/sXjZ8l77ctOP
	 vz3w0/GTqRQVHB/PQIKgk9CJsx2Us691BVgzcI3xK/njXbckGeGU1+wRnYRKrPvw+Jjcz
	 v8IzNggiGYd3dNeKX5jqxCrdav8i2sFf3DCQ7njzCA/guJM90g8FUc65THCAB0y3xAR3Y
	 HZSRWNBM5LwN9mYXThLOTj7RrDYaauM4HG7g4h6a6MjhkYXa67Q5WjFrQIMswDBT0idjM
	 f+SQtc8pyZxHVL/EGLET0fhAYlfr3K3Z94EJW5lqJBKXWN+K5hd6PuitiIj3hHeXXuA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794440915;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=NQx89/FMbumuaF97KkX7Rzg2TMLNreMdQ6e/+/UlUyQ=;
	b=pjDGlIcYjtMkBZio0gZWqESJgoX4E4FFH39aA4EywapJBDgpRksdAaMPk135yHYzVW3a
	 8vq8awUA03yxw1Tx3zGd17hXBNshOscVp3WxNSdWjIO9lGsuO9BPaxAEGVpLwaXjgBTkB
	 sQIseYIS09SGs5waV9NLjc+WR1h8XAFsihxiTIW7QNx+aQKCm04ovbLi9wCEuvcdG1IhW
	 JYZeDjsbpiy6LgHTRNCJtxt1WN1Uw3N+hGbfj1jps6Je4YBzq/whcPrO3/qPUaYmJ8BZM
	 hAJ2WjOfzZiDn5Io+VXj7PICZwW/1O4A1ZdW/gc52nrHstDmsqaeaK9rIkReoumiUZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=CHiFtZWu;
	arc=none smtp.remote-ip=192.198.163.15
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98EC6606B5F7;
	Wed, 11 Nov 2026 23:48:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 98EC6606B5F7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=CHiFtZWu
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794440914; x=1825976914;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=d/q7ALXLdCkJJkZQuQByGC710SnlqrlqU7uR1PxYHvk=;
  b=CHiFtZWu6HhsgWUcC4X/jFNfyPXRngSvyRZUqepLBP68WhkMoRUkd5II
   0afJi6N+xGKMx1zgnXGOb6zVsMYzsZRn7ZUKnu7t4qT7Mm7MTVvZBP1kk
   YB6G8UNVShsgo9ptgTtdqKjsMqeDzsHg8ywz0WxPwAkdPaU2BgI23uBOp
   WxHRbjiH0IveNvmdz2zJAEXBXSp+btqSthRIDaSwz4NJdxtPTxE/8qui5
   o8c1h3/31NV4calu/cYYlxjWiMyxEd/fFM1MZC1tRI4mD7JQLlHY5s7zq
   0Wv1XKwedjTfXhHC2jLkSxq3ZG8+UuCmanDtc/e3Wq4PgO6B7FOs4rfn/
   g==;
X-CSE-ConnectionGUID: trxomHrwQMeHF6kYW7GmNQ==
X-CSE-MsgGUID: jutdpttVRgeMXUzpqGY4vw==
X-IronPort-AV: E=McAfee;i="6800,10657,11963"; a="3226601"
X-IronPort-AV: E=Sophos;i="6.27,208,1787036400"; 
   d="scan'208";a="3226601"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2026 15:48:34 -0800
X-CSE-ConnectionGUID: djsE3xf9RyyMNtRku7cWRA==
X-CSE-MsgGUID: 80aUsZCoRNu+l8Tm+TbN1Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,208,1787036400"; 
   d="scan'208";a="8512370"
Received: from pavel-dev.sc.intel.com (HELO pepopov-mobl2.intel.com) ([10.3.206.11])
  by orviesa002.jf.intel.com with ESMTP; 11 Nov 2026 15:48:31 -0800
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
Subject: [PATCH 3/7] drm/amdgpu: Include <asm/cpu_device_id.h> unconditionally
Date: Wed, 11 Nov 2026 16:48:16 -0700
Message-ID: <20261111234821.4814-4-pavel.e.popov@intel.com>
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

<asm/intel-family.h> is included by <asm/cpu_device_id.h>.

Signed-off-by: Pavel Popov <pavel.e.popov@intel.com>
---
Depends on <asm-generic/cpu_device_id.h> from [1]; please apply after
it is in mainline.

[1] https://lore.kernel.org/r/20261111234439.4098-1-pavel.e.popov@intel.com

 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 19a566187df..fc4e7273630 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -88,10 +88,7 @@
 
 #include <drm/drm_drv.h>
 
-#if IS_ENABLED(CONFIG_X86)
-#include <asm/intel-family.h>
 #include <asm/cpu_device_id.h>
-#endif
 
 MODULE_FIRMWARE("amdgpu/vega10_gpu_info.bin");
 MODULE_FIRMWARE("amdgpu/vega12_gpu_info.bin");
-- 
2.54.0

