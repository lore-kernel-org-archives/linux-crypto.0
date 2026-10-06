Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1421144F55D;
	Tue,  6 Oct 2026 15:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791299199; cv=none; b=qC4BaYV4/NoYwBSGl9SYFTXccaVCoCR0dYO55otRH2MHWhDpu9q5bAw0e8rPxtA5rhP0nTiLnE3VKuMsmwtlIRHGZeD01Kil4pRhoy083tmrdFMAMiXddr+CGUOPJNmTv2Pk8DU27kL1IFooPWkHOBWdK2GilDkNiSjliUk1GEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791299199; c=relaxed/simple;
	bh=uZcGqudl71Ebaj1hwn3Xx+MV7/oVqAFE4S/A9YXdjpk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j613rhehyrrlTprMD9V1IxBuIwweTtCiBMvU1LRt8FZuosi8Nes5ufnJ5Ccrp7G3PIGvAhUB57/Y+8+R73jrGuih/71m9yAUcSYM/B34CYAYDZ2CJALe8uoKtNkmH/2/ShX8HGTJujlajHlAt0+v6e38kT2B/lkP9N7iA53iteo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hD5S6eut; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hD5S6eut"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791299198; x=1822835198;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uZcGqudl71Ebaj1hwn3Xx+MV7/oVqAFE4S/A9YXdjpk=;
  b=hD5S6eutI/bvPs0aQJ/p0vSwefpfOIN1hNOQuOlPeUP2DnDwLUIwvHMw
   +rJk7FlYu72zx3gGEsZCyJSYiveu5mfqTveLkUWv+YbJuH0mlFfpEi6RO
   +pRJZAddiRTeRwxIaBsjW+TSlkYF8XsZM0hl8Y0j73LD5YLvWtd6Dhsu1
   Ext2iUC+sIdVruuTHOd4mVJxV4Jdjcr7va3AHdW9i5YNCoYzUeFoQoaAB
   XvVyDHHXAqsQHv5WGmMjHF3LYDibyg5rs/uZHCqAmuG5yDxWIJS3HBpui
   kv0oi/GmlzKLJ8z+tZOZJzDOEwc1Sgy5hWl6pXibBwFMFx3cQyRiGIA3v
   A==;
X-CSE-ConnectionGUID: Dxmw/rOPSwqfcs9Ynn7wkw==
X-CSE-MsgGUID: KSyaXioBR4Kdosh7mHrfuA==
X-IronPort-AV: E=McAfee;i="6800,10657,11927"; a="102513633"
X-IronPort-AV: E=Sophos;i="6.27,143,1787036400"; 
   d="scan'208";a="102513633"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2026 08:06:38 -0700
X-CSE-ConnectionGUID: eiB1z4GbQwCFFR+sR05CdA==
X-CSE-MsgGUID: dkk2BpeXTS2j670FwnQs9w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,143,1787036400"; 
   d="scan'208";a="285270240"
Received: from silpixa00401812.ir.intel.com ([10.20.226.90])
  by fmviesa005.fm.intel.com with ESMTP; 06 Oct 2026 08:06:36 -0700
From: Ahsan Atta <ahsan.atta@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Ahsan Atta <ahsan.atta@intel.com>,
	stable@vger.kernel.org,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 1/2] crypto: qat - initialise state_lock on every path in adf_devmgr_add_dev()
Date: Tue,  6 Oct 2026 16:06:47 +0100
Message-ID: <20261006150649.2517748-2-ahsan.atta@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20261006150649.2517748-1-ahsan.atta@intel.com>
References: <20261006150649.2517748-1-ahsan.atta@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit

state_lock is initialised at the end of adf_devmgr_add_dev(), but the VF
on host path whose id mapping already exists returns earlier via
'goto unlock'. That mapping outlives the VF, so this path is taken every
time a VF is recreated on a BDF that already hosted one, e.g.:

	echo 0 > sriov_numvfs
	echo 32 > sriov_numvfs

accel_dev is freshly allocated on each probe, so state_lock is left zeroed
and adf_dev_up() takes an uninitialised mutex. With CONFIG_DEBUG_MUTEXES
this is reported on a dh895xcc with 32 host-bound VFs:

  DEBUG_LOCKS_WARN_ON(lock->magic != lock)
  WARNING: kernel/locking/mutex.c:159 at mutex_lock+0x171/0x1c0
  Call Trace:
   adf_dev_up+0x27/0xe0 [intel_qat]
   adf_probe+0x700/0xa80 [qat_dh895xccvf]
   local_pci_probe+0xd5/0x190

The same happens on teardown when adf_dev_down() locks it again.

Initialise the lock next to the other per-device state, before the tables
are updated, so it is done on every path.

Fixes: 1bdc85550a2b ("crypto: qat - fix concurrency issue when device state changes")
Cc: stable@vger.kernel.org
Signed-off-by: Ahsan Atta <ahsan.atta@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/intel/qat/qat_common/adf_dev_mgr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_dev_mgr.c b/drivers/crypto/intel/qat/qat_common/adf_dev_mgr.c
index 161863841a52..26b40dd59965 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_dev_mgr.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_dev_mgr.c
@@ -137,6 +137,7 @@ int adf_devmgr_add_dev(struct adf_accel_dev *accel_dev,
 
 	mutex_lock(&table_lock);
 	atomic_set(&accel_dev->ref_count, 0);
+	mutex_init(&accel_dev->state_lock);
 
 	/* PF on host or VF on guest - optimized to remove redundant is_vf */
 	if (!accel_dev->is_vf || !pf) {
@@ -210,7 +211,6 @@ int adf_devmgr_add_dev(struct adf_accel_dev *accel_dev,
 		map->attached = true;
 		list_add_tail(&map->list, &vfs_table);
 	}
-	mutex_init(&accel_dev->state_lock);
 unlock:
 	mutex_unlock(&table_lock);
 	return ret;
-- 
2.50.1

