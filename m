Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E29E42D6E54;
	Fri, 14 Nov 2025 18:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763144836; cv=none; b=Bzk9954IiKWHV3GymFpLEixz+2pQRFb5Dhx4GpKGvVOHjN/xADf/H5r7DD3yvxuhtKRfp+anQXQJHezh0Z+0oInCVPpwahoXh+vGtgFcVRcqM8AkA4xDe/iPos5hUQbEWsic6PXUpzMXFM7rzcB/YmWDav97edMyoHYSO01SFm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763144836; c=relaxed/simple;
	bh=LhMJfjH+jFkwHCO7adoRqeMeXRoBuV6Gs/enLTwrrO0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=iyzWQ3sftfuAvJJ0xyevHybfxVJjN8KXf/6b5/3l7GBoS4/Ib+Y+lygsRzX75CBuuze5VY7zs2db1GrIMZi+E1EWOd1Pd627AMXFzb2TPRYz3GLdYHv310bIdANELvS8hYkIVxzvD8HFiHQN2y5rcD0YMrH8IpR/+BNM6z/GL4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HTx7EeJW; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HTx7EeJW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763144835; x=1794680835;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=LhMJfjH+jFkwHCO7adoRqeMeXRoBuV6Gs/enLTwrrO0=;
  b=HTx7EeJWm+bzM4zI/UekuHaI3O46OWJ3MbCeC5DyFK0Jgo7j3Bq36ToH
   W9CD6DIprSVoufBNWqT84v5r6UTcs7op+dbpsQKEoElbpeJmOLcOcrXsR
   2xJqIQIMUFS85UAxYFzYhVYWwqL6EjyWZd7KjdFtZ2lLhSf0Zfa9FpWEG
   /v4uIycz3vgb1E8jGx5wDMefV4Z/w+eAtqyRxqzOJtuZk8MJRmg9WlT0f
   ZO9QXEx1Fh4ZfSukvKVf1Y44hPLkT9vSPhKEd16XPEittE7RspkxcqZ/T
   ceGL61pQ5jnWrxIfO+eWME6n90whXeNVbRtti6M6ryevoM4qMvoKd46I2
   A==;
X-CSE-ConnectionGUID: nwltIIjQTtGr/8AeICB5aw==
X-CSE-MsgGUID: /zluCSYARDChQ75fi7Wf6A==
X-IronPort-AV: E=McAfee;i="6800,10657,11613"; a="68868203"
X-IronPort-AV: E=Sophos;i="6.19,305,1754982000"; 
   d="scan'208";a="68868203"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2025 10:27:15 -0800
X-CSE-ConnectionGUID: OBTeTqOiSsShmCpZiTM8nw==
X-CSE-MsgGUID: I2wcZj5PSxemTEuaC0dytA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,305,1754982000"; 
   d="scan'208";a="194833571"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by fmviesa004.fm.intel.com with ESMTP; 14 Nov 2025 10:27:14 -0800
From: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
To: linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	clabbe@baylibre.com,
	ardb@kernel.org,
	ebiggers@google.com,
	surenb@google.com,
	kristen.c.accardi@intel.com,
	vinicius.gomes@intel.com
Cc: wajdi.k.feghali@intel.com,
	vinodh.gopal@intel.com,
	kanchana.p.sridhar@intel.com
Subject: [PATCH] crypto: iaa - Request to add Kanchana P Sridhar to Maintainers.
Date: Fri, 14 Nov 2025 10:27:13 -0800
Message-Id: <20251114182713.32485-1-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

As suggested by Herbert, I would like to request to be added as a
Maintainer for the iaa_crypto driver.

Suggested-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index c1a1732df7b1..b0ccaa3a67d4 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12561,6 +12561,7 @@ F:	drivers/dma/ioat*
 INTEL IAA CRYPTO DRIVER
 M:	Kristen Accardi <kristen.c.accardi@intel.com>
 M:	Vinicius Costa Gomes <vinicius.gomes@intel.com>
+M:	Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
 L:	linux-crypto@vger.kernel.org
 S:	Supported
 F:	Documentation/driver-api/crypto/iaa/iaa-crypto.rst
-- 
2.27.0

