Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 384AA40B38A
	for <linux-crypto@vger.kernel.org>; Mon,  8 Jun 2026 15:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780930877; cv=none; b=r/xJRBXfjmeQeNBTzL+XoXQxwYq93u8XUsV53GjtsOGjWKtz9SRmgf3pNVcoGGs7fmiJE3qGKvQ6DWoNGqkxrpS4v4UIma+UarCkog2DjjXPjl3Mtq3DjmVt0vIPTXfR9oMVMUXAa8cUbEa8ESu6Jks8OOxYez9MKxxWrOBPg1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780930877; c=relaxed/simple;
	bh=xOsBiar0SrK1NKqeyGjcLM8ZLx8NWWaQlyLPLB5v5c0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=R67QreZNPLfCu8tTBvSAmsYUuuTtmVWJY5Hnl5z3fkjEjVbV7BPqEUOb/dPLCa9Xva7g0VXKWQZ9JBXTNm6ssMEYYODBOA7U0stwTK7LcTv5d70QgHgDJpYbwkWXfra/ZBDfuq5+CLs5n+WmzMlFQ4lLPwQtiEem2OMeB1VIkQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=M8JIVBAe; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="M8JIVBAe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780930871; x=1812466871;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=xOsBiar0SrK1NKqeyGjcLM8ZLx8NWWaQlyLPLB5v5c0=;
  b=M8JIVBAe0s7Td1Hchgx0tlhgnubFUqYROF8KrHmUwIJ5j3W23x3+6OHC
   BLiYDVsOIEh8Ydrx+NF4OkRfN2UbFOONpCEGmYtwUzZgQxhJzXsjC5LoL
   ZoDbtHJUs9k195EHSWON3KTrlUykUb6t3lG1Rwmnmf2AZ/ozyPsg1eRho
   lOi6s6WFzp0Xp8PrbI5ea8fGSqgUmDfZNtPKbCpGD3rL76Xjqudn4sMbn
   oyZXbOmieDrPgbyWYwcZ6jb8ZqSKX0eP2Qwnmi4Yj6/HmhjLCV6gXm7EB
   VsjlkS6BB/IKfx9LOl9XRetRlqaD25jHJIXA5K1i2P92t5hpYu22rGcZP
   A==;
X-CSE-ConnectionGUID: J0ZRDHmaQ5i4LVyEUoy7CA==
X-CSE-MsgGUID: tZKRvBViToe8wLaY+KKfuA==
X-IronPort-AV: E=McAfee;i="6800,10657,11811"; a="81412970"
X-IronPort-AV: E=Sophos;i="6.24,194,1774335600"; 
   d="scan'208";a="81412970"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2026 08:01:10 -0700
X-CSE-ConnectionGUID: HqPU0AvjRU+vzj+7WW7hIQ==
X-CSE-MsgGUID: 9mN86Wh0TZuAvGh68qFFDA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,194,1774335600"; 
   d="scan'208";a="250491548"
Received: from silpixa00401971.ir.intel.com ([10.20.226.106])
  by orviesa005.jf.intel.com with ESMTP; 08 Jun 2026 08:01:10 -0700
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Ahsan Atta <ahsan.atta@intel.com>
Subject: [PATCH] crypto: qat - cancel work on re-enable SR-IOV timeout
Date: Mon,  8 Jun 2026 15:59:40 +0100
Message-ID: <20260608150104.135313-1-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit

The QAT reset worker queues SR-IOV reenable work using a work_struct and
completion embedded in an on-stack adf_sriov_dev_data. If the completion
wait times out, the reset worker can return while device_sriov_wq still
holds or executes the stack-backed work item.

Cancel the work on the device_sriov_wq on timeout before the stack frame
unwinds.

Fixes: 4469f9b23468 ("crypto: qat - re-enable sriov after pf reset")
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Ahsan Atta <ahsan.atta@intel.com>
---
 drivers/crypto/intel/qat/qat_common/adf_aer.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_aer.c b/drivers/crypto/intel/qat/qat_common/adf_aer.c
index d58cd7fbf707..afded3030e9a 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_aer.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_aer.c
@@ -189,6 +189,8 @@ static void adf_device_reset_worker(struct work_struct *work)
 	queue_work(device_sriov_wq, &sriov_data.sriov_work);
 	if (wait_for_completion_timeout(&sriov_data.compl, wait_jiffies))
 		adf_pf2vf_notify_restarted(accel_dev);
+	else
+		cancel_work_sync(&sriov_data.sriov_work);
 
 	adf_dev_restarted_notify(accel_dev);
 	clear_bit(ADF_STATUS_RESTARTING, &accel_dev->status);

base-commit: 36d82ddc0f8a88444e8d65646a3c43147005ed35
-- 
2.54.0

