Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE267381C4;
	Fri,  9 Feb 2024 13:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.55.52.88
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707483772; cv=none; b=JNEcBLhgMaJz8LpMBade+YmMOy2usZF0M72DVPC6lDDQ8XhZePaqtdJ34B3MTuJOH9BPPS7ZwytV9ccykKDtjYxMvscKRRpzggqto4zzTKjF+hBocS8RgTYRGwFfZphj+xeCDVe875rdDKeV5I8wcA+U/XlmH66vdpJ2mUuVVn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707483772; c=relaxed/simple;
	bh=TrzC6Q+ENQub50IvZdjXEQf8L/dRuTrBN8Z7LS3tSDo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SPDwDpv+PwLIVydwx7sBXo2dyxZkOpjDCv6a+T6/KgYlrJvVXpQWZ0i6P84xvKBsyx7bHiHnBmYT4wbJ4+6x8ZzU5cnFM38zc02RNYu9W5E2UeH0t9syNcuu92UhyFboev5uGgc73TLPzkZ4HohBLlp2ufB2k3uRWuDq+l699ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dn/joOpM; arc=none smtp.client-ip=192.55.52.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dn/joOpM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707483770; x=1739019770;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=TrzC6Q+ENQub50IvZdjXEQf8L/dRuTrBN8Z7LS3tSDo=;
  b=dn/joOpMFEOoaZRVdlMXFYgxHYw/TKxCyElajYRPBGukzQ4raK+vZroS
   2n5ks1JLY9sCyeVoD3KZ6I+sp+6Q2057qQuy46uOhUAS3zXogz8NPiaHi
   Gpr9FM+nEy6NXluxA0tkIN602M1kV2zV6CAkcU0gHaaOkS7yaELC+35zg
   D8aSz/g8y+blh0poTr9urJCgwKuQqPT7wXOmben9s2w/z6iSKkcVKQAGv
   cwbv1i8le0SleE0wq6Bpt9dRh6MKOcfO1hZcNE/i+3TmBs5j+ItlNwf3u
   frfSLV0Uk7Sq6zrIiqX6DYQZES+bH5v8KPvvYWt5aVd54TazJ6m4Lv/Cq
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10978"; a="436561160"
X-IronPort-AV: E=Sophos;i="6.05,256,1701158400"; 
   d="scan'208";a="436561160"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2024 05:02:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,256,1701158400"; 
   d="scan'208";a="6577599"
Received: from r031s002_zp31l10c01.deacluster.intel.com (HELO localhost.localdomain) ([10.219.171.29])
  by orviesa005.jf.intel.com with ESMTP; 09 Feb 2024 05:02:47 -0800
From: Damian Muszynski <damian.muszynski@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Damian Muszynski <damian.muszynski@intel.com>,
	stable@vger.kernel.org,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH] crypto: qat - change SLAs cleanup flow at shutdown
Date: Fri,  9 Feb 2024 13:42:07 +0100
Message-ID: <20240209124237.44530-1-damian.muszynski@intel.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Technology Poland sp. z o.o. - ul. Slowackiego 173, 80-298 Gdansk - KRS 101882 - NIP 957-07-52-316
Content-Transfer-Encoding: 8bit

The implementation of the Rate Limiting (RL) feature includes the cleanup
of all SLAs during device shutdown. For each SLA, the firmware is notified
of the removal through an admin message, the data structures that take
into account the budgets are updated and the memory is freed.
However, this explicit cleanup is not necessary as (1) the device is
reset, and the firmware state is lost and (2) all RL data structures
are freed anyway.

In addition, if the device is unresponsive, for example after a PCI
AER error is detected, the admin interface might not be available.
This might slow down the shutdown sequence and cause a timeout in
the recovery flows which in turn makes the driver believe that the
device is not recoverable.

Fix by replacing the explicit SLAs removal with just a free of the
SLA data structures.

Fixes: d9fb8408376e ("crypto: qat - add rate limiting feature to qat_4xxx")
Cc: <stable@vger.kernel.org>
Signed-off-by: Damian Muszynski <damian.muszynski@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/intel/qat/qat_common/adf_rl.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_rl.c b/drivers/crypto/intel/qat/qat_common/adf_rl.c
index de1b214dba1f..d4f2db3c53d8 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_rl.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_rl.c
@@ -788,6 +788,24 @@ static void clear_sla(struct adf_rl *rl_data, struct rl_sla *sla)
 	sla_type_arr[node_id] = NULL;
 }
 
+static void free_all_sla(struct adf_accel_dev *accel_dev)
+{
+	struct adf_rl *rl_data = accel_dev->rate_limiting;
+	int sla_id;
+
+	mutex_lock(&rl_data->rl_lock);
+
+	for (sla_id = 0; sla_id < RL_NODES_CNT_MAX; sla_id++) {
+		if (!rl_data->sla[sla_id])
+			continue;
+
+		kfree(rl_data->sla[sla_id]);
+		rl_data->sla[sla_id] = NULL;
+	}
+
+	mutex_unlock(&rl_data->rl_lock);
+}
+
 /**
  * add_update_sla() - handles the creation and the update of an SLA
  * @accel_dev: pointer to acceleration device structure
@@ -1155,7 +1173,7 @@ void adf_rl_stop(struct adf_accel_dev *accel_dev)
 		return;
 
 	adf_sysfs_rl_rm(accel_dev);
-	adf_rl_remove_sla_all(accel_dev, true);
+	free_all_sla(accel_dev);
 }
 
 void adf_rl_exit(struct adf_accel_dev *accel_dev)

base-commit: 84c2f23ad68a847e36dc9cae44f21c5e321a321c
-- 
2.43.0

