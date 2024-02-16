Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE53F132C1E
	for <linux-crypto@vger.kernel.org>; Fri, 16 Feb 2024 17:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708105534; cv=none; b=ZZ8fuZ7OBICsIlZyv4H69NvSPV7hkF3T9lo5UdaeKlsDhLAbBpiJOHe9QIuins+KylGiPvakxBOrlUwLDkp1hP0mnRbwkzI4Gg5nkmKdxf/btrX9K5vhYcmsygWpBYAeObOC/0D0UFxv0EMG1HcsbQjUuj7sSLR0E0N58hjfk30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708105534; c=relaxed/simple;
	bh=/l6K6+Jo45rbjIxVE64EnVNxZis/lqmX/+MFD5DAFTM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=u8EvLSh3yYF/dh5+mHwWdTZTo1924YpZBF0/w5oNgNFG/B/2u6XpDdINWb1btyPp1UbKKLXuNtfvumfvUWeQ72tLlkozfM/yewy/Y+prxoamWZeCqC4uPvP8HWnwR1OysXkW8kyD62TBK+Kj0TnpPfOwgL64NFHK6VHXg+OQahw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=URQ6Ph5o; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="URQ6Ph5o"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708105534; x=1739641534;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=/l6K6+Jo45rbjIxVE64EnVNxZis/lqmX/+MFD5DAFTM=;
  b=URQ6Ph5o1YewAytBVFduaxVn48jYgnqagkxw66GGeRWjGFZXh+BQjNqm
   YYIvEgH7SHGCjiDXKCEUr6BfCoXupdHSrkzws0y+Mcscj8kpiLsv7g3wr
   1fQICqROIFAXWf4rStcT2Qes/W6EccBWQ3HLdYthpv1vgIiJjm9bw2Nsk
   YkLLzh3ArGgTRvujV7kvySlV1ABrT15vXDkGDEDsm4FgCVawWO+nujy61
   akP3Va1eUKcfGbunMMmm6e2Vfi0t2azZQAuDRM3gqx5i3WWisgpDMNy4D
   1eZfXOcX3S4+rZAG7N7aBDbrnAyyetrCz6nInefSgA2o+c7pKxqP5qlfj
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10986"; a="2097813"
X-IronPort-AV: E=Sophos;i="6.06,165,1705392000"; 
   d="scan'208";a="2097813"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2024 09:45:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,165,1705392000"; 
   d="scan'208";a="8507235"
Received: from r031s002_zp31l10c01.deacluster.intel.com (HELO localhost.localdomain) ([10.219.171.29])
  by fmviesa003.fm.intel.com with ESMTP; 16 Feb 2024 09:45:32 -0800
From: Damian Muszynski <damian.muszynski@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Damian Muszynski <damian.muszynski@intel.com>
Subject: [PATCH 0/3] crypto: qat - fix and make common ring to service map in QAT GEN4
Date: Fri, 16 Feb 2024 18:21:53 +0100
Message-ID: <20240216172545.177303-1-damian.muszynski@intel.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Technology Poland sp. z o.o. - ul. Slowackiego 173, 80-298 Gdansk - KRS 101882 - NIP 957-07-52-316
Content-Transfer-Encoding: 8bit

This set is revamping the method that generates the ring-to-service maps
in QAT. The initial two patches rectify the existing algorithm version
for use cases when the dcc service was enabled. The final patch
eliminates the function's duplication in device-specific code and
relocates it to a shared file.

Damian Muszynski (3):
  crypto: qat - fix ring to service map for dcc in 4xxx
  crypto: qat - fix ring to service map for dcc in 420xx
  crypto: qat - make ring to service map common for QAT GEN4

 .../intel/qat/qat_420xx/adf_420xx_hw_data.c   | 64 +++++--------------
 .../intel/qat/qat_4xxx/adf_4xxx_hw_data.c     | 64 +++++--------------
 .../intel/qat/qat_common/adf_accel_devices.h  |  1 +
 .../intel/qat/qat_common/adf_gen4_hw_data.c   | 56 ++++++++++++++++
 .../intel/qat/qat_common/adf_gen4_hw_data.h   |  1 +
 5 files changed, 90 insertions(+), 96 deletions(-)


base-commit: 48f0668106f3664f4101c9f24fdb3b8c13f5880d
-- 
2.43.0

