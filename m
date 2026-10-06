Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5BDD3B71C9
	for <linux-crypto@vger.kernel.org>; Tue,  6 Oct 2026 14:48:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791298113; cv=none; b=apzepBzd30Bq3l0awWlHxF5C7yxCMXpLbswAY8au5zalxIU30h4LQNPxf22rRR19OzH9WR6Pa8qNKcHZ/+iCpU9u3LE8ld3oSpcp775q6sWtO3nf4Sy+o6dUsGQ1JyoyNhxoprHF6jas8tjwnUZDkM4NITMplsPJa8SMlwOaFmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791298113; c=relaxed/simple;
	bh=hgamFFdtwFhF7P0xfkrYYUXesUQtJNAznKhQkw8jUU4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p4I+ZDpAq+T+F1kDkQ2C11roEOnyuAZ5tSH3Ylt4NE2HPVDBh7WvxYOh1KuNVSFoMAg8UGtIvia9iM7BoDv2m17xqQ3gq2ePNn8jHYyiNILajCOnpKCnOhdkOklUTmfLxc1xzA3xy2MoOrCg5UdhjQyOTow2Iwd5aSY1BTjtptI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QaAROpLF; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QaAROpLF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791298111; x=1822834111;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hgamFFdtwFhF7P0xfkrYYUXesUQtJNAznKhQkw8jUU4=;
  b=QaAROpLFgNyz71QjSM+TFS8nfCqI83148MqQ4zKyEswy1inmfKrA8fPm
   HRGkI0p1xn1KuQxx9jJGA2XuBMNX6AaiF4PwheWVaDT6i6OJ43EOSRohB
   yJRK3+BCk24GYdr/LfZEzRMt6Z86kVzntO+yXmV6/d8hoSBbEXe14ZlFY
   hnP6MdwUznJaQ7e9Zoc5U3FLcK7XMP7Cu774v+zHLzo7Wo3Xz414v8Xy/
   RKx6iW1C1gqzUm9bMWrxeMsSes58BU7xmi0dCmPKHexYO3uPy17h4pdXy
   G9u2T8wbHYM6iVWf/NTStrsUcK+e2HjnmvTtsQRWzzLbE+MAj5i7/CE77
   g==;
X-CSE-ConnectionGUID: tuzIQzoMSm6dxwRtUj6C3g==
X-CSE-MsgGUID: /GPtbRIoTtC/KzsFmc0lEA==
X-IronPort-AV: E=McAfee;i="6800,10657,11927"; a="117509917"
X-IronPort-AV: E=Sophos;i="6.27,143,1787036400"; 
   d="scan'208";a="117509917"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2026 07:48:31 -0700
X-CSE-ConnectionGUID: r3oFxeseQx6dfUgBrPDxTQ==
X-CSE-MsgGUID: qa7xoXjKTjeMISjmfbgyUw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,143,1787036400"; 
   d="scan'208";a="305115573"
Received: from silpixa00401812.ir.intel.com ([10.20.226.90])
  by fmviesa001.fm.intel.com with ESMTP; 06 Oct 2026 07:48:29 -0700
From: Ahsan Atta <ahsan.atta@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Bairavi Alagappan <bairavix.alagappan@intel.com>,
	Ahsan Atta <ahsan.atta@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 2/2] Documentation: qat: document three-service mode for QAT GEN5 devices
Date: Tue,  6 Oct 2026 15:48:40 +0100
Message-ID: <20261006144840.2514754-3-ahsan.atta@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20261006144840.2514754-1-ahsan.atta@intel.com>
References: <20261006144840.2514754-1-ahsan.atta@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit

From: Bairavi Alagappan <bairavix.alagappan@intel.com>

Update the cfg_services sysfs attribute documentation to describe
support for concurrent symmetric crypto, asymmetric crypto, and
compression services on QAT GEN5 devices.

Signed-off-by: Bairavi Alagappan <bairavix.alagappan@intel.com>
Signed-off-by: Ahsan Atta <ahsan.atta@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 Documentation/ABI/testing/sysfs-driver-qat | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-driver-qat b/Documentation/ABI/testing/sysfs-driver-qat
index b0561b9fc4eb..48e17de3e0fd 100644
--- a/Documentation/ABI/testing/sysfs-driver-qat
+++ b/Documentation/ABI/testing/sysfs-driver-qat
@@ -41,8 +41,8 @@ Description:	(RW) Reports the current configuration of the QAT device.
 
 		Service combinations are permitted for all services except dcc.
 		On QAT GEN4 devices (qat_4xxx driver) a maximum of two services can be
-		combined and on QAT GEN6 devices (qat_6xxx driver ) a maximum of three
-		services can be combined.
+		combined. On QAT GEN5 devices (qat_420xx driver) and GEN6 devices
+		(qat_6xxx driver) a maximum of three services can be combined.
 		The order of services is not significant. For instance, sym;asym is
 		functionally equivalent to asym;sym.
 
-- 
2.50.1

