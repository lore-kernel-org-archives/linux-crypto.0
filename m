Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4210739769B;
	Thu,  5 Mar 2026 17:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772731297; cv=none; b=mBayAM+cDJs2+2dneOfZfYRzdh/jsnsN3BA4yFXbMYJCywuMuaF4wVyHVOO4rfkxfggAV2BVsHevGRXfUKTt23GnUOksNN+Km5NYeMqotLkokQjkNtyhYlJA3jaeQFPTu6K+x14XFj0ReUys7JYzjsJSVfwJmK5iXdCOl1ohORg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772731297; c=relaxed/simple;
	bh=TRF4WWmLTvVF3SQv8Ac1yD/4yuMQAmfLl4QTKwPs9a0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HW3Kfz3DHeoqkPvL13W5mOa1DW+c1tmiK3YjSc4j25qN7ByWrS0sVPcViQeqJCBrTFWc6f1WxAGaHmi9XupZoFeVYgDR1o+WnGEh2Qb3q8/1ijH3bOwrvp5Y3rtJMNfCy9j5aXfg4rDnUJGu4psaPtfwjjODSZafW1KCZ0w3WSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DIK33vcY; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DIK33vcY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772731297; x=1804267297;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=TRF4WWmLTvVF3SQv8Ac1yD/4yuMQAmfLl4QTKwPs9a0=;
  b=DIK33vcYU4tO7lZdtQh51Olq9cMXkJZ80NEqUiyRoXp5FKAsckZIzzUu
   yZ31mvsJ3vLHjHSUbK62rZ18phvo6Jt6TRY9aH/KalFT4aStL1X3JQbBE
   dx5nxRB3v1GC/HS0kTaRGu+YvEc0dwJqL7sBAUC3jnYI+X1IXjoqTz0Wy
   ySjk3i15NFdQaVgznYOPm+c8f9nawZd8PGDdeMMunAXr8SrT6uzIylNtE
   709MSy+vBCEaj7nXu/OIeUMPcg2Lb93mKqdup0TBlQLuAgCkTSZXznHJC
   Ef4gey69DrHFUInEIYlRXWad9pVd/h0q4s2Fyag9knNRd+Ua9j4MGBglE
   w==;
X-CSE-ConnectionGUID: s5jK2gt8SsKIjJpeLzJ1Zg==
X-CSE-MsgGUID: cwfKc4ffSJi2WCpVuQNR3g==
X-IronPort-AV: E=McAfee;i="6800,10657,11720"; a="73733179"
X-IronPort-AV: E=Sophos;i="6.23,103,1770624000"; 
   d="scan'208";a="73733179"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 09:21:36 -0800
X-CSE-ConnectionGUID: XnqORNy/Q56kVaZ6I0cevg==
X-CSE-MsgGUID: e7ZxotIpQcySBGjebIdTuA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,103,1770624000"; 
   d="scan'208";a="256641405"
Received: from smtp.ostc.intel.com ([10.54.29.231])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 09:21:36 -0800
Received: from ray2.sr71.net (unknown [10.125.109.20])
	by smtp.ostc.intel.com (Postfix) with ESMTP id 835126362;
	Thu,  5 Mar 2026 09:21:35 -0800 (PST)
From: Dave Hansen <dave.hansen@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Dave Hansen <dave.hansen@linux.intel.com>,
	Kristen Accardi <kristen.c.accardi@intel.com>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
Subject: [PATCH] MAINTAINERS: Remove bouncing maintaner for IAA driver
Date: Thu,  5 Mar 2026 09:21:33 -0800
Message-ID: <20260305172133.3115510-1-dave.hansen@linux.intel.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This maintainer's email is now bouncing. Remove them.

Cc: Kristen Accardi <kristen.c.accardi@intel.com>
Cc: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org
---
 MAINTAINERS | 1 -
 1 file changed, 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index d010689fa91a9..7c03c6f2e7328 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12875,7 +12875,6 @@ F:	drivers/dma/ioat*
 INTEL IAA CRYPTO DRIVER
 M:	Kristen Accardi <kristen.c.accardi@intel.com>
 M:	Vinicius Costa Gomes <vinicius.gomes@intel.com>
-M:	Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
 L:	linux-crypto@vger.kernel.org
 S:	Supported
 F:	Documentation/driver-api/crypto/iaa/iaa-crypto.rst
-- 
2.43.0

