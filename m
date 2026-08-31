Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBE9C34F483
	for <linux-crypto@vger.kernel.org>; Mon, 31 Aug 2026 06:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788158118; cv=none; b=l4J4bELWYZAqYOFa+3nQYOzK51nMKVLMQlgrebak6qN5ksPbia66xJMhqe5taZADgKaJoG+7kLVgDdRyuzVbj+iEDAPqVk4YH9wJ3Q0dYtK1iB+R+TcTdKK0T2xZiAeV1G4z7nVz6lp748l5BvVCpjKxv3cU7UG4jMD0oYN9qmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788158118; c=relaxed/simple;
	bh=hTb2t+3opPqcQFUm/70eHVfvPmAjFEnzyA+sJq1Hgz4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H3aztODosSYqn8LxY+jo5MsdDklU4e6U9RQpqayeifTpIKDGaqTYwVaUuNP3br2DqtbTHIJkqdlhc5ALjpkfIAGGSk4PT6mKHvCHYQL5M/UNGTew18RwpcnwQrqv/v0aIi47uozwPtnmbPYfY1fTiLjjB5ZVVcq49KgvLQRuLcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=d5h3OOmw; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="d5h3OOmw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788158117; x=1819694117;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hTb2t+3opPqcQFUm/70eHVfvPmAjFEnzyA+sJq1Hgz4=;
  b=d5h3OOmwuewL2f8nrs7XrIASFW+igQH7Jah4scwS+aJrv+zd/zEaPfkw
   1uF3hVqW+JV2e25PrqEwXF9iVGq+wUBEcdN2gxMUQ5AKsFMJhRxh3Kjbp
   K7kkXtf4filNnzl8EouAMCTlJ/2f5Ghql4Zy0rB5P1zaT/fgRj+mWwkHK
   0UyM5ebdm2ivg/UlK1TkC6MZ9QziiObCOCZI3DYT1TEqazGDZyQJtuuPk
   piutBrzAFnpmAPW0mK57uoRWDB3UJXGd6DLGYdJtSHruGK2lWhiKhWYuQ
   gU2QbfweaGwxJF6Jqv4gZpMbrklVpffnXkZpG4T1Amn6FfIKvlx3S/owK
   w==;
X-CSE-ConnectionGUID: UFlMd0/GR9S08nqFIdobWA==
X-CSE-MsgGUID: f+/7ED1ZTEKRYUn899Grbg==
X-IronPort-AV: E=McAfee;i="6800,10657,11891"; a="105930212"
X-IronPort-AV: E=Sophos;i="6.25,252,1779174000"; 
   d="scan'208";a="105930212"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2026 23:35:17 -0700
X-CSE-ConnectionGUID: rcIeIMyMTXOXQkZL14YFjA==
X-CSE-MsgGUID: BmT13zMrQuSNhVZquAH+6g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,252,1779174000"; 
   d="scan'208";a="267377687"
Received: from dmr-bkc.iind.intel.com ([10.49.111.53])
  by orviesa010.jf.intel.com with ESMTP; 30 Aug 2026 23:35:16 -0700
From: nitesh.venkatesh@intel.com
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Nitesh Venkatesh <nitesh.venkatesh@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Ahsan Atta <ahsan.atta@intel.com>
Subject: [PATCH 2/2] Documentation: qat: clarify KPT enable device-state requirement
Date: Mon, 31 Aug 2026 06:32:34 +0000
Message-ID: <20260831063355.668528-3-nitesh.venkatesh@intel.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260831063355.668528-1-nitesh.venkatesh@intel.com>
References: <20260831063355.668528-1-nitesh.venkatesh@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Nitesh Venkatesh <nitesh.venkatesh@intel.com>

The ABI description for /sys/bus/pci/devices/<BDF>/qat_kpt/enable did
not mention that the device must be in the down state before the KPT
enable attribute can be written. This requirement is enforced by the
driver for both enabling and disabling KPT, but was not reflected in
the ABI documentation, leaving users to discover it via -EINVAL.

Update the description to note that the device must be in the down
state before changing the KPT state.

Signed-off-by: Nitesh Venkatesh <nitesh.venkatesh@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Ahsan Atta <ahsan.atta@intel.com>
---
 Documentation/ABI/testing/sysfs-driver-qat_kpt | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/ABI/testing/sysfs-driver-qat_kpt b/Documentation/ABI/testing/sysfs-driver-qat_kpt
index c6480ea1fa4f..80831ce3d2ca 100644
--- a/Documentation/ABI/testing/sysfs-driver-qat_kpt
+++ b/Documentation/ABI/testing/sysfs-driver-qat_kpt
@@ -14,7 +14,8 @@ Contact:	qat-linux@intel.com
 Description:
 		(RW) Enables or disables Key Protection Technology (KPT).
 
-		Write 1 to enable KPT, or 0 to disable it.
+		Write 1 to enable KPT, or 0 to disable it. The device must be
+		in the down state before changing the KPT state.
 
 		Example usage::
 
-- 
2.52.0

