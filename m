Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EF871DFCE
	for <linux-crypto@vger.kernel.org>; Fri, 19 Jan 2024 16:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.55.52.88
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705681948; cv=none; b=PXI+YmY9iM43NK1bvEb+FMUmK4GWkgez6nLCHh2OwvFXeoypMTTlEl0PoHGzsPF5/4Ti+0lJrOxZDmD4huI3sS4LdS9SfwCdQPyJCMbMK78YSEcUgU59KrU4AKHUZOA0VAcH0sNoqJveoGtHu8uSasqM44RCBJk0pAp6yvuylgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705681948; c=relaxed/simple;
	bh=ESGzXkEJAMtBPKG2gER5PmCZuip7IECQ4M9FRQiRBbw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VBGHNs3IriVlhYXYkWedxWR+uY5bf5Wo4hT9yd6qdqVv9Qh4rc49DWBo7tcMuDoChctIQhJNfu5Zx58qNR3eR6XOpCrdcXQ1tTwYmCMxf0BI0BFUsTv/2ReV8ObwIs1AELQoN9/lXbeKoOnk5pS1v9XUvosKN2dR3q/iP33nJlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iqc9WpAP; arc=none smtp.client-ip=192.55.52.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iqc9WpAP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705681946; x=1737217946;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ESGzXkEJAMtBPKG2gER5PmCZuip7IECQ4M9FRQiRBbw=;
  b=iqc9WpAP4iF1GSe/IKNFT74qbZTRzBJb7cdMbNGI1eg0nyATTEWJTMRw
   wcaSYP1cB3RxcGpsAGONuD1k+Pp1AQ1ifEGJr4FidKkHWhDIN4EuteFAn
   MasMn+RlVgYhbI2V0+jMlEO3T3hQJVYN6ILa1G9Bjw7EsddW9v+EdGpve
   5+AGZJKMtO9J/Zo2xQSs8bfr3nfsGeWvkLc2SWCy5X3pAeaRDf4crTJ3b
   bJeH4YclIhP+yEpyao1EEGnz71hrrELvoc1Ex8ND0qRUN06Uy3+bdtynP
   O9cM+1EF3RBVT8yAA2WSAZZdyHGKkKETZrhKJCIPn7AeygS/uUTz1/aZR
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10957"; a="431955909"
X-IronPort-AV: E=Sophos;i="6.05,204,1701158400"; 
   d="scan'208";a="431955909"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2024 08:32:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10957"; a="904191363"
X-IronPort-AV: E=Sophos;i="6.05,204,1701158400"; 
   d="scan'208";a="904191363"
Received: from r031s002_zp31l10c01.deacluster.intel.com (HELO localhost.localdomain) ([10.219.171.29])
  by fmsmga002.fm.intel.com with ESMTP; 19 Jan 2024 08:32:25 -0800
From: Damian Muszynski <damian.muszynski@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Damian Muszynski <damian.muszynski@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH] crypto: qat - fix arbiter mapping generation algorithm for QAT 402xx
Date: Fri, 19 Jan 2024 17:12:38 +0100
Message-ID: <20240119161325.12582-1-damian.muszynski@intel.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Technology Poland sp. z o.o. - ul. Slowackiego 173, 80-298 Gdansk - KRS 101882 - NIP 957-07-52-316
Content-Transfer-Encoding: 8bit

The commit "crypto: qat - generate dynamically arbiter mappings"
introduced a regression on qat_402xx devices.
This is reported when the driver probes the device, as indicated by
the following error messages:

  4xxx 0000:0b:00.0: enabling device (0140 -> 0142)
  4xxx 0000:0b:00.0: Generate of the thread to arbiter map failed
  4xxx 0000:0b:00.0: Direct firmware load for qat_402xx_mmp.bin failed with error -2

The root cause of this issue was the omission of a necessary function
pointer required by the mapping algorithm during the implementation.
Fix it by adding the missing function pointer.

Fixes: 5da6a2d5353e ("crypto: qat - generate dynamically arbiter mappings")
Signed-off-by: Damian Muszynski <damian.muszynski@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c b/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
index 479062aa5e6b..94a0ebb03d8c 100644
--- a/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
@@ -463,6 +463,7 @@ void adf_init_hw_data_4xxx(struct adf_hw_device_data *hw_data, u32 dev_id)
 		hw_data->fw_name = ADF_402XX_FW;
 		hw_data->fw_mmp_name = ADF_402XX_MMP;
 		hw_data->uof_get_name = uof_get_name_402xx;
+		hw_data->get_ena_thd_mask = get_ena_thd_mask;
 		break;
 	case ADF_401XX_PCI_DEVICE_ID:
 		hw_data->fw_name = ADF_4XXX_FW;

base-commit: 71518f53f4c3c3fadafdf3af86c98fa4c6ca1abc
-- 
2.43.0

