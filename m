Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B12B7134743
	for <linux-crypto@vger.kernel.org>; Fri, 16 Feb 2024 15:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708097901; cv=none; b=Ug2lD5ZV3EVKeCL85B6oaTNO38G8ziVlqD7xzSr5whYMGJ+8fLehHgmi8dKxogsBAEFNzG8nayOlDsY9pTduZP16MFpyZBFgSJJDxapARJzR9RBffog65nnpN7GnSpCbBDzTshJ/Q37IkNQ71+eMZRKNBhjFQG+flWHPMC3O58s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708097901; c=relaxed/simple;
	bh=2w9GKgQIDKfioQKEPUufnlRayU2NVlKOQjZZRZ5hrvQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bPDXebo61lyXIPml97RnMMms9LQiBxh67glQ3fYZ7PjClBB8r3bF/mTih1iz8FHqbBERk8Y7PWtMv4WX7HvY++YomsHyAjtcHp3jNqBpmp2gGD7rmDE6QGGHLUEQCT+j8fCKPT3gzz/lPznpWInHBI2qLxusguVdPCKZu14q8I8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jNne3yrQ; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jNne3yrQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708097900; x=1739633900;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2w9GKgQIDKfioQKEPUufnlRayU2NVlKOQjZZRZ5hrvQ=;
  b=jNne3yrQ9nThAXfYREb7qK11qgrL3UisHkwoiZpg7Jj5UB1EVEzA5Hbo
   r/2QOImsvImLvWm/+J3Yz5lUOO5oMbnakmBLpY5AHJYCOTTJByCtBnsfg
   PDiTTwQBvPc49ozpLtcasvjljd1g3XVMvGhIHHnxc6k3TgC27pglFZG77
   9hrQZAcc+3aVH9mu3qJKVMFneFUfJNTP7RfvVuvbb5RJwLVmWL6CSR9hX
   Pd6cficwVS5rVmlefaAPmELJ+MTlD9uTLo9IxkiHiKKqEL821/bulFXef
   jP+qcElBi62/gXL0LzbcC5VhiXOvst/hjOOoacp1oN5YxlyMsToV2GxpL
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10986"; a="13622743"
X-IronPort-AV: E=Sophos;i="6.06,165,1705392000"; 
   d="scan'208";a="13622743"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2024 07:38:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10986"; a="935861479"
X-IronPort-AV: E=Sophos;i="6.06,165,1705392000"; 
   d="scan'208";a="935861479"
Received: from silpixa00400295.ir.intel.com ([10.237.213.194])
  by fmsmga001.fm.intel.com with ESMTP; 16 Feb 2024 07:38:18 -0800
From: Adam Guerin <adam.guerin@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Adam Guerin <adam.guerin@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 4/6] crypto: qat - remove double initialization of value
Date: Fri, 16 Feb 2024 15:19:58 +0000
Message-Id: <20240216151959.19382-5-adam.guerin@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20240216151959.19382-1-adam.guerin@intel.com>
References: <20240216151959.19382-1-adam.guerin@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organisation: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare, Ireland
Content-Transfer-Encoding: 8bit

Remove double initialization of the reg variable.

This is to fix the following warning when compiling the QAT driver
using clang scan-build:
    drivers/crypto/intel/qat/qat_common/adf_gen4_ras.c:1010:6: warning: Value stored to 'reg' during its initialization is never read [deadcode.DeadStores]
     1010 |         u32 reg = ADF_CSR_RD(csr, ADF_GEN4_SSMCPPERR);
          |             ^~~   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    drivers/crypto/intel/qat/qat_common/adf_gen4_ras.c:1109:6: warning: Value stored to 'reg' during its initialization is never read [deadcode.DeadStores]
     1109 |         u32 reg = ADF_CSR_RD(csr, ADF_GEN4_SER_ERR_SSMSH);
          |             ^~~   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Fixes: 99b1c9826e48 ("crypto: qat - count QAT GEN4 errors")
Signed-off-by: Adam Guerin <adam.guerin@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/intel/qat/qat_common/adf_gen4_ras.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_gen4_ras.c b/drivers/crypto/intel/qat/qat_common/adf_gen4_ras.c
index 048c24607939..2dd3772bf58a 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_gen4_ras.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_gen4_ras.c
@@ -1007,8 +1007,7 @@ static bool adf_handle_spppar_err(struct adf_accel_dev *accel_dev,
 static bool adf_handle_ssmcpppar_err(struct adf_accel_dev *accel_dev,
 				     void __iomem *csr, u32 iastatssm)
 {
-	u32 reg = ADF_CSR_RD(csr, ADF_GEN4_SSMCPPERR);
-	u32 bits_num = BITS_PER_REG(reg);
+	u32 reg, bits_num = BITS_PER_REG(reg);
 	bool reset_required = false;
 	unsigned long errs_bits;
 	u32 bit_iterator;
@@ -1106,8 +1105,7 @@ static bool adf_handle_rf_parr_err(struct adf_accel_dev *accel_dev,
 static bool adf_handle_ser_err_ssmsh(struct adf_accel_dev *accel_dev,
 				     void __iomem *csr, u32 iastatssm)
 {
-	u32 reg = ADF_CSR_RD(csr, ADF_GEN4_SER_ERR_SSMSH);
-	u32 bits_num = BITS_PER_REG(reg);
+	u32 reg, bits_num = BITS_PER_REG(reg);
 	bool reset_required = false;
 	unsigned long errs_bits;
 	u32 bit_iterator;
-- 
2.40.1

