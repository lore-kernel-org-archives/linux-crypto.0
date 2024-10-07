Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ECDC14AD17
	for <linux-crypto@vger.kernel.org>; Mon,  7 Oct 2024 13:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728308574; cv=none; b=IbNXR85wW3UFCipyM0K8U2dZGrC2Nwpjn7K4TzomvWnBuetzGpZBIHfIvFt21qt/c58bUB0/lybzFFKsVNrcaLTK8ZWN7txJBbgZ8j/nQL6mrYgneI1hd/P2XzcENjRAjsybZVGCeNaDdxpwKtRUKpfL/4PerSo5NWwy+r2yB40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728308574; c=relaxed/simple;
	bh=ykWbEmOc0cTMIS7NTd2d6mgKnPXcLUzyYMeiivYxloE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=KFSlYUl9EYd6YwFBi32KT0iYyxVx6Kp53s+SBGJhSifBdHt2uWWQPnjCuqmz1Il7BU+cjJg7fRK2j+HGwaTgL5cgoQHhHC+77swTPXL48VXOhn5mWoklcpkUVGipMzzoZE0jlDVeBnT0TWbAA0bKBiOIBTJZC+NzFDHEp/NJoDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=none smtp.mailfrom=ecsmtp.ir.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Hu3x9qoW; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ecsmtp.ir.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Hu3x9qoW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728308574; x=1759844574;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ykWbEmOc0cTMIS7NTd2d6mgKnPXcLUzyYMeiivYxloE=;
  b=Hu3x9qoWgFIciSua+PuXn1eWQrQL7XP9Tdxi7JDJoQDEpE1LCwpb7aE2
   9EEe2/Hzg0XGHh/CeWooK4Rhfh8TbG91axsbRZ2JEyjCJBlxnFTleMbnf
   to751WBAVRAf+ky7+FUmAma3ANRIVdLKAkrWnlpTOjHTA2ZdZBSxvKwIP
   J0SigHhcXKNr6ypU4uWsm8LOwwMbfOAoqfabmlMKoBDqpjRX1B+BTM+kp
   VLIKT3mA1TOvjpjdKKdGQxOnZB2bSAo0w46LDYS98F76x1UG/+PRiE4AI
   kO7D9J1AUp2tSyPmAnrIZ47kBjsRigPbb2/ZtBV621kyE9HC7nLxwsCdU
   A==;
X-CSE-ConnectionGUID: gJCr1aRgRNWLv2TmSIacEg==
X-CSE-MsgGUID: iCGeWEHkQaOl+UCvg8KUqQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11218"; a="38585133"
X-IronPort-AV: E=Sophos;i="6.11,184,1725346800"; 
   d="scan'208";a="38585133"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2024 06:42:53 -0700
X-CSE-ConnectionGUID: jmvMIOsZStmVbpHk3xbVmw==
X-CSE-MsgGUID: 3y9dAU+VTyqelBd5bkJNuA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,184,1725346800"; 
   d="scan'208";a="80310233"
Received: from irvmail002.ir.intel.com ([10.43.11.120])
  by orviesa003.jf.intel.com with ESMTP; 07 Oct 2024 06:42:51 -0700
Received: from sivswdev10.ir.intel.com (sivswdev10.ir.intel.com [10.237.217.4])
	by irvmail002.ir.intel.com (Postfix) with ESMTP id B9C9B27BD9;
	Mon,  7 Oct 2024 14:42:50 +0100 (IST)
Received: by sivswdev10.ir.intel.com (Postfix, from userid 11379147)
	id 88FC118007ED; Mon,  7 Oct 2024 14:42:50 +0100 (IST)
From: Ahsan Atta <ahsan.atta@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Ahsan Atta <ahsan.atta@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH] crypto: qat - remove faulty arbiter config reset
Date: Mon,  7 Oct 2024 14:42:40 +0100
Message-Id: <20241007134240.12278-1-ahsan.atta@intel.com>
X-Mailer: git-send-email 2.32.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Resetting the service arbiter config can cause potential issues
related to response ordering and ring flow control check in the
event of AER or device hang. This is because it results in changing
the default response ring size from 32 bytes to 16 bytes. The service
arbiter config reset also disables response ring flow control check.
Thus, by removing this reset we can prevent the service arbiter from
being configured inappropriately, which leads to undesired device
behaviour in the event of errors.

Fixes: 7afa232e76ce ("crypto: qat - Intel(R) QAT DH895xcc accelerator")
Signed-off-by: Ahsan Atta <ahsan.atta@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/intel/qat/qat_common/adf_hw_arbiter.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_hw_arbiter.c b/drivers/crypto/intel/qat/qat_common/adf_hw_arbiter.c
index 65bd26b25abc..f93d9cca70ce 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_hw_arbiter.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_hw_arbiter.c
@@ -90,10 +90,6 @@ void adf_exit_arb(struct adf_accel_dev *accel_dev)
 
 	hw_data->get_arb_info(&info);
 
-	/* Reset arbiter configuration */
-	for (i = 0; i < ADF_ARB_NUM; i++)
-		WRITE_CSR_ARB_SARCONFIG(csr, arb_off, i, 0);
-
 	/* Unmap worker threads to service arbiters */
 	for (i = 0; i < hw_data->num_engines; i++)
 		WRITE_CSR_ARB_WT2SAM(csr, arb_off, wt_off, i, 0);
-- 
2.32.0

