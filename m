Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B707145C70E;
	Tue,  6 Oct 2026 15:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791299201; cv=none; b=XzANtS/IJpSSFeDdj9NUMrOXP+4D1s8lFWyOi7cKXzAcGIDdXRQEuctETjiy9kw6SvBwe+ozyUQCrXRT7tuJFdSP6mopsZNTF6vYi8FjIbFHJnqexPdcBO36EaFoghZ0/yYX5XfuV5kRya+nUXjVjweGqUGobEc5T2ru6iQ1DW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791299201; c=relaxed/simple;
	bh=yP8RzR5iQAN+u2txSV/oOvSf+wl5uvunEqkCAftXqWk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AfCFDqurEZaJfKLKuSrYqHWuv/lVwgcBArHe98N61y7C+HbcA4+Rl/Dywd13xTaEULwE0XmdceFbnPfV1NsD8/sUW9LfbCRIAyLh8+biaoWKBhanYf9W7MPqOMH/4kVBy7UeN6+GfdwcDKlgx2nuVYcvHhdP+jVdB5OrxpgXpOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=e42AO6rH; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="e42AO6rH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791299200; x=1822835200;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yP8RzR5iQAN+u2txSV/oOvSf+wl5uvunEqkCAftXqWk=;
  b=e42AO6rH2ALfqlM4yIe6vzTwlHRuSOxmHkkikhMXL4a1nIocj+atw8Ut
   tT6/KaEDSfn4DSDmQzg5HnHy7RAFKl1lo8ngxxV+UU3Az7vqdXE3vg5nA
   hJ0Zu5LqFuAdwCk8TN/l4PJEzuk+2d64Ge3nbhw0kbLMjlsoWTcNwX6uc
   MmefG7sqQdUlBuu39ZtLawhswenvR9sdDNMP/19dV/j/2f4nBv8s7S4mX
   RWAyd64hyTv4NMu2ZS/ZoBb1BxMMDE9I9rlJg0rjsRCp+EDUT1NHsl4YB
   bPpi0dl2gKSBslBwf5XCTk3K1J5WZgOxZb9Vh0+4OpKaXi/kKti7kKUzJ
   g==;
X-CSE-ConnectionGUID: Uc/yz9+5QGG8a4suh7AQZA==
X-CSE-MsgGUID: ZtylLelcSeOSNIUCWOc03A==
X-IronPort-AV: E=McAfee;i="6800,10657,11927"; a="102513638"
X-IronPort-AV: E=Sophos;i="6.27,143,1787036400"; 
   d="scan'208";a="102513638"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2026 08:06:40 -0700
X-CSE-ConnectionGUID: +ByMW13GSnav3jid/Ctvow==
X-CSE-MsgGUID: cX0auxu7TuCBUPYDYBjXfA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,143,1787036400"; 
   d="scan'208";a="285270245"
Received: from silpixa00401812.ir.intel.com ([10.20.226.90])
  by fmviesa005.fm.intel.com with ESMTP; 06 Oct 2026 08:06:38 -0700
From: Ahsan Atta <ahsan.atta@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Ahsan Atta <ahsan.atta@intel.com>,
	stable@vger.kernel.org,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 2/2] crypto: qat - fix use of destroyed vf2pf_lock on VF restart
Date: Tue,  6 Oct 2026 16:06:48 +0100
Message-ID: <20261006150649.2517748-3-ahsan.atta@intel.com>
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

adf_dev_stop_async() sends the RESTARTING_COMPLETE message after
adf_dev_down() has returned, but adf_dev_down() already destroyed the
lock that message takes.

Both run in sequence in the same worker, so every PF restart locks a
destroyed mutex. With CONFIG_DEBUG_MUTEXES on a dh895xcc with 32 host-bound
VFs this trips on the first PF reset:

  DEBUG_LOCKS_WARN_ON(lock->magic != lock)
  WARNING: kernel/locking/mutex.c:159 at mutex_lock+0x171/0x1c0
  Workqueue: adf_vf_stop_wq adf_dev_stop_async [intel_qat]
  Call Trace:
   adf_gen2_pfvf_send+0x210/0x530 [intel_qat]
   adf_vf2pf_notify_restart_complete+0x55/0x80 [intel_qat]
   adf_dev_stop_async+0xdb/0x140 [intel_qat]

The notification cannot move before adf_dev_down(): the PF waits for it
before its own reset and the VF must tear down its rings first.

vf2pf_lock protects the VF2PF CSR and is unrelated to the PF2VF bottom half
it is initialised alongside. Tie its lifetime to the accel device, next to
state_lock in adf_devmgr_add_dev()/adf_devmgr_rm_dev(), so it stays valid
for messages sent outside the device up/down cycle. It is only touched for
VFs, which set is_vf before adf_devmgr_add_dev() and keep it set until
adf_devmgr_rm_dev().

Fixes: 6f1b5236348f ("crypto: qat - fix recovery flow for VFs")
Cc: stable@vger.kernel.org
Signed-off-by: Ahsan Atta <ahsan.atta@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/intel/qat/qat_common/adf_dev_mgr.c | 8 ++++++++
 drivers/crypto/intel/qat/qat_common/adf_vf_isr.c  | 2 --
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_dev_mgr.c b/drivers/crypto/intel/qat/qat_common/adf_dev_mgr.c
index 26b40dd59965..4e6d860c9a60 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_dev_mgr.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_dev_mgr.c
@@ -138,6 +138,12 @@ int adf_devmgr_add_dev(struct adf_accel_dev *accel_dev,
 	mutex_lock(&table_lock);
 	atomic_set(&accel_dev->ref_count, 0);
 	mutex_init(&accel_dev->state_lock);
+	/*
+	 * The VF2PF lock is used to send messages to the PF outside of the
+	 * device up/down cycle, so it must live as long as the accel device.
+	 */
+	if (accel_dev->is_vf)
+		mutex_init(&accel_dev->vf.vf2pf_lock);
 
 	/* PF on host or VF on guest - optimized to remove redundant is_vf */
 	if (!accel_dev->is_vf || !pf) {
@@ -257,6 +263,8 @@ void adf_devmgr_rm_dev(struct adf_accel_dev *accel_dev,
 		}
 	}
 unlock:
+	if (accel_dev->is_vf)
+		mutex_destroy(&accel_dev->vf.vf2pf_lock);
 	mutex_destroy(&accel_dev->state_lock);
 	list_del(&accel_dev->list);
 	mutex_unlock(&table_lock);
diff --git a/drivers/crypto/intel/qat/qat_common/adf_vf_isr.c b/drivers/crypto/intel/qat/qat_common/adf_vf_isr.c
index 9ffaa56def67..1f28655ec051 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_vf_isr.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_vf_isr.c
@@ -118,7 +118,6 @@ static int adf_setup_pf2vf_bh(struct adf_accel_dev *accel_dev)
 	tasklet_init(&accel_dev->vf.pf2vf_bh_tasklet,
 		     (void *)adf_pf2vf_bh_handler, (unsigned long)accel_dev);
 
-	mutex_init(&accel_dev->vf.vf2pf_lock);
 	return 0;
 }
 
@@ -126,7 +125,6 @@ static void adf_cleanup_pf2vf_bh(struct adf_accel_dev *accel_dev)
 {
 	tasklet_disable(&accel_dev->vf.pf2vf_bh_tasklet);
 	tasklet_kill(&accel_dev->vf.pf2vf_bh_tasklet);
-	mutex_destroy(&accel_dev->vf.vf2pf_lock);
 }
 
 static irqreturn_t adf_isr(int irq, void *privdata)
-- 
2.50.1

