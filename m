Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.15
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794440928;
	b=LvpzVZdJCUkstlfSHhlG4NRYEpBvjdN4cHzVzdXwOrO6DWwGzvH7qdBPLUi9w5VqIJUq
	 ZgPaXNsxhHvi6/cU3CuOmVDYzVRu3Osl94sy2wsPd5LTCXfZN6xR422e5xnO77YyRjQ8W
	 wMcsVbNSRLBIFc1gCYnLoBM131fj0RYgIT4rVnJlu0ez5+QNWs8xu96UuLNuiqeuW1svn
	 4bfqLSusWYi4ucQQ4XuMgwjuQpSTc0xEjFZThWmWZMbVDTGSWvdAqPkjvHUd5RXPgYA3S
	 Qk01JaNn+Gcm6Ec7nt1XzMa2zsnPHLOFy0EXH6pa9t3GBR67DUyI7nWm/4ZBq6cWRuw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794440928;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=A1jBRaJ7IPwE2sDCpHaNOCIbdJ7uMRcnix54sujkwSo=;
	b=FTh0S+leK1xQmvYKYMw68innqaxJFMOdyizEzMtdqZwrnhwVNHnwpYQRB5SvvN/LocrA
	 6ayODy7Nn2WFV/IM3cIqaxE8WR5sUYWSTfw6nKYdRu/gMLnoD3SO/xq9mLYIkPf+74Fbf
	 XD0BJH7AY8p7KkrteshZCJI1OvZZWLmTBmSN8Y16+G5Wil0jNmMZuCaRbw4Sb+D3HiSAz
	 8jgAWH3oAqMx8mDmG2PVzSdnpiwj1mBYOnLcYO/yFO6QWlAREDDOKe9i3/XrHnrGj7SWv
	 v8sd5+fuZlrIc1dLkuoB1HeORSQfjHtGXBLWyli/M4ZlopUCnZSQ//4LOvRUf3ZziKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=MyDwC8CY;
	arc=none smtp.remote-ip=192.198.163.15
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D968160A5BC7;
	Wed, 11 Nov 2026 23:48:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D968160A5BC7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=MyDwC8CY
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794440928; x=1825976928;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nn492t9vwWyNrSlbHv+ImXuNJXcsvtoFtn2kqzaYrJE=;
  b=MyDwC8CYx58Gq1PPnGXos1jG0sRdsLBAZkO4R6vtLizUvYgnf+cBUBc3
   iime9MArLvER9vGVqyWYWf14A2ZaQs4FPUFGUvasqPLNy4F++bb2zsOXP
   vZ6BMaicqrY2qPOnavtZO+dZxmU8qTFtSZiAfaMZqa1iVgkXVnh8Zemym
   xqq+4DxxDyOm61u8DDb/2Zt2pNn7+9C8Xw9jg0VzoIwb/hfRUQGVDkSp9
   fPrR28e8LkPb17HhzvI/d9IhCNHLfqUkI8PoLMnRk2s/rTzmmFH1/eAFG
   5Sz4b/gQrcWo6+O85yx+bNU9fwLotYyUqpkM4hna+Wku7usmfPeWXgAcD
   g==;
X-CSE-ConnectionGUID: DaE+ss0pT66KkDdYCI+5iQ==
X-CSE-MsgGUID: 23FasaAKTsqDdgMt+40lKw==
X-IronPort-AV: E=McAfee;i="6800,10657,11963"; a="3226675"
X-IronPort-AV: E=Sophos;i="6.27,208,1787036400"; 
   d="scan'208";a="3226675"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2026 15:48:47 -0800
X-CSE-ConnectionGUID: meJAifVaQEOpz/aGc9pt4Q==
X-CSE-MsgGUID: YrrcqYuLTPOSRGb2SidOoA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,208,1787036400"; 
   d="scan'208";a="8512421"
Received: from pavel-dev.sc.intel.com (HELO pepopov-mobl2.intel.com) ([10.3.206.11])
  by orviesa002.jf.intel.com with ESMTP; 11 Nov 2026 15:48:44 -0800
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
Subject: [PATCH 7/7] crypto: ccp - Drop unused <asm/cpu_device_id.h> include
Date: Wed, 11 Nov 2026 16:48:20 -0700
Message-ID: <20261111234821.4814-8-pavel.e.popov@intel.com>
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

Nothing in ccp-dev.c uses <asm/cpu_device_id.h>; the CPU match table
it was included for is long gone. Drop the include and the #ifdef
CONFIG_X86 around it.

Signed-off-by: Pavel Popov <pavel.e.popov@intel.com>
---
 drivers/crypto/ccp/ccp-dev.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-dev.c b/drivers/crypto/ccp/ccp-dev.c
index 41d9bdac95d..017e7a6551f 100644
--- a/drivers/crypto/ccp/ccp-dev.c
+++ b/drivers/crypto/ccp/ccp-dev.c
@@ -21,9 +21,6 @@
 #include <linux/hw_random.h>
 #include <linux/cpu.h>
 #include <linux/atomic.h>
-#ifdef CONFIG_X86
-#include <asm/cpu_device_id.h>
-#endif
 #include <linux/ccp.h>
 
 #include "ccp-dev.h"
-- 
2.54.0

