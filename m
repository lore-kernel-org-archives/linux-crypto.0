Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92395154C18
	for <linux-crypto@vger.kernel.org>; Tue, 25 Jun 2024 14:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719326345; cv=none; b=Clal5leqId1qTkcoysxCGzozUUVCEllQIA1gWyHhn62fohCAl6gC5MtgGCAKVylvYA7dEqqqjaWexQiVXjva0uhMRYIzoA9wIZUEnxmPTyWDhwYBgrYLv6nMLau4ZpZUD/T/DUovVmnyF71z1de1T8NvMUSrQpgsxnZG4Fv+I5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719326345; c=relaxed/simple;
	bh=ejEto1qvfKbvtF0c33giZ5oov2DqFV0klyKmleu1wTA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=glwAKBwkatdvjqZMBNx4Y6zjYFoy8E1d65Ss5Yvu18zr9uNtkZd/G0NKk5PiTluSssduIIxKFkVkhrpGZbNNENbtpspEtZw8qHj3F+RxMILYBf5K6WwOJTCKWpNdWYPcojBNBY9uCxr0Or1JUOvVUfGPGgS5Zz4Y8z+O/TsHyPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fZoWuTs5; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fZoWuTs5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719326344; x=1750862344;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ejEto1qvfKbvtF0c33giZ5oov2DqFV0klyKmleu1wTA=;
  b=fZoWuTs58Getkhtg6Pm1gn3r4mCoTTKUp6tnAhDpqYJrAWwBLN4n5fBy
   KRWjanau/4WJXSZQn4b/UjZQ685jtFLfy5oFAifAlFG2FyvjcJm1Olwcy
   7G59qZipIvAdva26TyekMOq9ejbbbp5qpjcAZmgFp4kj9mSEphhCM/zUf
   9r/o2arfHwDh4eQ+TIdbFzpkYNmo79wq+oRMigS1RUEfGvWuWgtOeacKw
   alo/ofR2mX1e5EVhg1pmBwsOxCB02FxIS7nn2t0M3EeqidCE58NMtcTR6
   rOVsC0ThUPayY+HamencpX9EQAqgoYZEZD5Q70evqd9TKFNK+dQd4RCFu
   A==;
X-CSE-ConnectionGUID: CnFkIYmoTXe3ku18Eg1DrA==
X-CSE-MsgGUID: GFwyyfFPQFCacIn9nllrdw==
X-IronPort-AV: E=McAfee;i="6700,10204,11114"; a="20230657"
X-IronPort-AV: E=Sophos;i="6.08,264,1712646000"; 
   d="scan'208";a="20230657"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2024 07:39:02 -0700
X-CSE-ConnectionGUID: 5i8VSgkPSvy6WOMhInA3Hw==
X-CSE-MsgGUID: ZRdlcL5XTbiWULJBIxdRoA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,264,1712646000"; 
   d="scan'208";a="48065991"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.216])
  by fmviesa003.fm.intel.com with ESMTP; 25 Jun 2024 07:38:59 -0700
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Nivas Varadharajan Mugunthakumar <nivasx.varadharajan.mugunthakumar@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH] crypto: qat - extend scope of lock in adf_cfg_add_key_value_param()
Date: Tue, 25 Jun 2024 15:38:50 +0100
Message-ID: <20240625143857.5778-1-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit

From: Nivas Varadharajan Mugunthakumar <nivasx.varadharajan.mugunthakumar@intel.com>

The function adf_cfg_add_key_value_param() attempts to access and modify
the key value store of the driver without locking.

Extend the scope of cfg->lock to avoid a potential race condition.

Fixes: 92bf269fbfe9 ("crypto: qat - change behaviour of adf_cfg_add_key_value_param()")
Signed-off-by: Nivas Varadharajan Mugunthakumar <nivasx.varadharajan.mugunthakumar@intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/intel/qat/qat_common/adf_cfg.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_cfg.c b/drivers/crypto/intel/qat/qat_common/adf_cfg.c
index 8836f015c39c..2cf102ad4ca8 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_cfg.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_cfg.c
@@ -290,17 +290,19 @@ int adf_cfg_add_key_value_param(struct adf_accel_dev *accel_dev,
 	 * 3. if the key exists with the same value, then return without doing
 	 *    anything (the newly created key_val is freed).
 	 */
+	down_write(&cfg->lock);
 	if (!adf_cfg_key_val_get(accel_dev, section_name, key, temp_val)) {
 		if (strncmp(temp_val, key_val->val, sizeof(temp_val))) {
 			adf_cfg_keyval_remove(key, section);
 		} else {
 			kfree(key_val);
-			return 0;
+			goto out;
 		}
 	}
 
-	down_write(&cfg->lock);
 	adf_cfg_keyval_add(key_val, section);
+
+out:
 	up_write(&cfg->lock);
 	return 0;
 }
-- 
2.44.0

