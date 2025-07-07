Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 430334EB38
	for <linux-crypto@vger.kernel.org>; Mon,  7 Jul 2025 12:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751891334; cv=none; b=e3Ejo6Xunyeq0c1BDIE65snl+WXrBFRehsFPnEEgtpfAp/0NzH1adSbGNo4ix+Wsk7M2bIE8ZqOPxemy6RaS+XyvO+ge1xnwJ+keKpS0ERJEaM+KGA3RZisFQwz45aEtFubfINNRsNGqvRzxjl06g+gTMaEhjlmw3RlKH/DbW2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751891334; c=relaxed/simple;
	bh=q9+5ndTetqTSFlVyLBKno2k+4G8Jtryh30K0PEP4v7Y=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=guC5ZGfbe36XrksSiGmP3YALlleb898Kqv7DWie0asqtomsIwwZLa6rNNdQ+uQ8AWewodX8iZP9lsiOP1V85MFOWmJrWJwz3fFaL4hQbVPniNZW4cCwmrVs1P7iiFkYT9Ckuu8UBAUcJfoJ9HB1bDX/j9jQDazFNRvyHNfk9jFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=R666rEaQ; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="R666rEaQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751891334; x=1783427334;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=q9+5ndTetqTSFlVyLBKno2k+4G8Jtryh30K0PEP4v7Y=;
  b=R666rEaQh03HxbzOSAm3aepeeN6Y54WueVoARi+J9qdJCqZ8a1S5V9qo
   09MUe6FvzKRzg6OTjEXu3uP0iNDlFBxkYzwoO3Ra99l+O8ZQc+JD/wd7b
   Isr2T9I3SNHRI0cTlR6NEaGllmJH9pv3vPqgrNjSoODOtyiR6bJWRGrdD
   wtsFzeRUvqkLbirKP5PyWtx33HUnDAkChLZp2sdK9ZWs3Yz8cHkd3Uq/n
   bGd8zJAtYz54D9JA05i2bOZyXRsPZUMBxahnTd3I1wIjKrcjzLJzKlXZf
   fTnT0A+lOHFAr0vQhxlD2Z9xc2AsPJCEfrCQYW2q1F9eSHoVlKJP1Cfyd
   w==;
X-CSE-ConnectionGUID: 6tjRVV/HSommDVZ9rgIhiQ==
X-CSE-MsgGUID: ox6W2aChTRSgl4WxxQW8jA==
X-IronPort-AV: E=McAfee;i="6800,10657,11487"; a="57779489"
X-IronPort-AV: E=Sophos;i="6.16,294,1744095600"; 
   d="scan'208";a="57779489"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2025 05:28:53 -0700
X-CSE-ConnectionGUID: mD+VjyZrQh2EWX+BaOJ4Hg==
X-CSE-MsgGUID: +U4D5Y66RhugbPXa0GANeg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,294,1744095600"; 
   d="scan'208";a="159474527"
Received: from t21-qat.iind.intel.com ([10.49.15.35])
  by fmviesa005.fm.intel.com with ESMTP; 07 Jul 2025 05:28:51 -0700
From: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com
Subject: [PATCH 0/2] crypto: qat - add support for PM debugfs logging for GEN6 devices 
Date: Mon,  7 Jul 2025 13:28:44 +0100
Message-Id: <20250707122846.1308115-1-suman.kumar.chakraborty@intel.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This set relocates the power management debugfs helpers to a common
location to enable code reuse across generations and adds support for
reporting power management (PM) information via debugfs for QAT GEN6
devices.

George Abraham P (2):
  crypto: qat - relocate power management debugfs helper APIs
  crypto: qat - enable power management debugfs for GEN6 devices

 Documentation/ABI/testing/debugfs-driver-qat  |   2 +-
 .../intel/qat/qat_6xxx/adf_6xxx_hw_data.c     |  11 +-
 drivers/crypto/intel/qat/qat_common/Makefile  |   2 +
 .../qat/qat_common/adf_gen4_pm_debugfs.c      | 105 +++------------
 .../crypto/intel/qat/qat_common/adf_gen6_pm.h |  24 ++++
 .../intel/qat/qat_common/adf_gen6_pm_dbgfs.c  | 124 ++++++++++++++++++
 .../intel/qat/qat_common/adf_pm_dbgfs_utils.c |  52 ++++++++
 .../intel/qat/qat_common/adf_pm_dbgfs_utils.h |  36 +++++
 8 files changed, 268 insertions(+), 88 deletions(-)
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_gen6_pm_dbgfs.c
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_pm_dbgfs_utils.c
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_pm_dbgfs_utils.h


base-commit: ecc44172b0776fab44be35922982b0156ce43807
-- 
2.40.1

