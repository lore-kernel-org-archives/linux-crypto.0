Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.15
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794440906;
	b=e4qmqC59oyBEpiQNfwsXY3bFhHOY0gbhLKOjGWvlNrCRogxDH7w4FlWVTTyyPNHsQzYF
	 skS1aWmTTj+UwDMJmrTn4Z2S8mOH/gzt1Mk+5YdqMnfTHC7k8EHm6pNneXhHb8BhS5TuV
	 +uUzWNkSorbwm8UVxKPYU6KgNAS1EZhXzSf4e9EMkmHWq9JfbzaVVu8n7pfFkZWnQm1tl
	 zBvlYhRnA4DXcFYUkZzbzaMdc9/htiN4NPmnNdExQFXzZS0e64NqOV1Q4cVweVHqFvPSO
	 5mexJmqq1nxBm+zcjvB0BgLkaQi88JMuNgkq0VbaQq1oxNYrNAySOEQQggU1sA9lcNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794440906;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=o13O8owmD+D7aAocojuQlucbQ1j1UddkBba8uNnH+YQ=;
	b=CKAq7eBdGz/RCTSWyZX0lfJOG3B+K4Wu6A2pCouWWhmrNk8Dg5WdVjSAnuLN7j2tAbvz
	 pCdbrAxSevCdkVX1FYUTKr6lnswdH5ug8iNZY6CJLNdEv5ptnXENMS2TD7yawJ5SmNk6S
	 TAWSAmnLBj68PbnKoOQfO7vKgbAz60wA79LvP8Ry1kTqQHtFEP14UQM+i6KEluagthR+e
	 57nFxJgAOFmScve9sa+St+kCjwt3AJ/FwGLECJPP/RsbbX/xYNR3OsvrZe3EEFULCra39
	 ppr39DhXS8ZKBYC+drnk0HuUIPpfRFJRmOdkVAXYd42i/0PBOXJIiXF+pG6FSskv7Vg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=YKkCWlIq;
	arc=none smtp.remote-ip=192.198.163.15
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8128F606A8A5;
	Wed, 11 Nov 2026 23:48:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8128F606A8A5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=YKkCWlIq
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794440905; x=1825976905;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=9Cuegc/MuoDCo4oN8xNnf/pcpxsFdQP4keN2fSB0lfE=;
  b=YKkCWlIqbv+MntrVW1kAk69u3zKeJW/GD1CSSwTDnD0Ob5D5SSbeHTyk
   sn4s6B0i5m3smTrzwoOWuw267qBIEuwr6p478RQ98VMyz4jaTZMRqa8OI
   Mp21r62yVLog0SEOLH8g9oiiS+XJw8tIDfKJLWcW1+WPpeAw7Cp5eQZYK
   VUs4fCT9XSPPNw8Gz3Q+/XOcj+Zu8+5r8UpZ/bTqN71fy78UofwJ3iQkr
   kIUQnTrIexfFu5g6wwamCCXnSwSedS8eioqwBWo9afJjbK3YH1HEW9vGu
   ncLWDOk5VcDaCWPjN3+VQ7Q1bvv0OXHnM/7WRmlUPz3VLUvNTmBaQVuq2
   g==;
X-CSE-ConnectionGUID: CoDb8OI1Tyi/PFsg04QF8w==
X-CSE-MsgGUID: 5vdL11maS5+oamVRHcg31w==
X-IronPort-AV: E=McAfee;i="6800,10657,11963"; a="3226550"
X-IronPort-AV: E=Sophos;i="6.27,208,1787036400"; 
   d="scan'208";a="3226550"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2026 15:48:24 -0800
X-CSE-ConnectionGUID: OBrl5lPZQVGsO4ZZ0YyItw==
X-CSE-MsgGUID: Wdq4BZXQSVqd2thien9rrw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,208,1787036400"; 
   d="scan'208";a="8512350"
Received: from pavel-dev.sc.intel.com (HELO pepopov-mobl2.intel.com) ([10.3.206.11])
  by orviesa002.jf.intel.com with ESMTP; 11 Nov 2026 15:48:21 -0800
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
Subject: [PATCH 0/7] Include <asm/cpu_device_id.h> without #ifdef CONFIG_X86
Date: Wed, 11 Nov 2026 16:48:13 -0700
Message-ID: <20261111234821.4814-1-pavel.e.popov@intel.com>
X-Mailer: git-send-email 2.54.0
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

<asm/cpu_device_id.h> exists only on x86, so generic code that uses it
wraps the include in #ifdef CONFIG_X86. The P2PDMA series [1] adds a
generic version of the header, so the include can be unconditional.

This series drops the #ifdef around the include in the remaining
users, and in ccp, which does not use the header, the include itself.
Some of them also include <asm/intel-family.h>, which has no
generic version. That include is removed: on x86 it is already pulled
in by <asm/cpu_device_id.h>, and on other architectures the INTEL_*
model defines are not used. The #ifdef stays around code that needs
x86 for other reasons: CPU match tables using the INTEL_* model
defines and boot_cpu_data accesses.

Patches 1-6 are independent of each other and can go through the
respective trees once [1] has landed. Patch 7 does not depend on [1].

Based on mainline (7.4-rc2+) plus [1]. Built with x86_64 and arm64
allmodconfig, each patch separately.

[1] https://lore.kernel.org/r/20261111234439.4098-1-pavel.e.popov@intel.com

Pavel Popov (7):
  ACPI: mipi-disco-img: Include <asm/cpu_device_id.h> unconditionally
  drm/i915: Include <asm/cpu_device_id.h> unconditionally
  drm/amdgpu: Include <asm/cpu_device_id.h> unconditionally
  cpufreq: ondemand: Include <asm/cpu_device_id.h> unconditionally
  platform/x86: Include <asm/cpu_device_id.h> unconditionally in soc.h
  tpm: Include <asm/cpu_device_id.h> unconditionally
  crypto: ccp - Drop unused <asm/cpu_device_id.h> include

 drivers/acpi/mipi-disco-img.c              | 5 ++---
 drivers/char/tpm/tpm.h                     | 2 --
 drivers/cpufreq/cpufreq_ondemand.h         | 4 ++--
 drivers/crypto/ccp/ccp-dev.c               | 3 ---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 3 ---
 drivers/gpu/drm/i915/intel_cpu_info.c      | 5 ++---
 include/linux/platform_data/x86/soc.h      | 5 ++---
 7 files changed, 8 insertions(+), 19 deletions(-)


base-commit: 067c5c24cef23d913b67eaaf71ae67e7169a6620
prerequisite-patch-id: 2a8952c8b8b6b019585a8bc449db628f458658cb
prerequisite-patch-id: 6b1715c7e4f230fedfcadf38303ce5966922caff
prerequisite-patch-id: 88872ad297c6b8ec80cb4ec4057ab281e10c148d
-- 
2.54.0

