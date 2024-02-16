Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BC861339B1
	for <linux-crypto@vger.kernel.org>; Fri, 16 Feb 2024 15:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708097885; cv=none; b=XbKkTKPRt2roxtzdSsETMgsZj8C1aiQ6VUBOPNR7nrmc9hIKYbPUD3JIu9cdnVbrNx7g7YfhgKrEnjmKqJclIus4uOpv1ljlDJVr6aFyXsY4bqejNQPy8miRlFpy9/YDtqaP1t8ReOtzAfZguB7wP3GJ5YYvqrVgAUIm5BMMomU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708097885; c=relaxed/simple;
	bh=KNNzJYsRXz/djhcA10PNG33OwY0MmK+Mtu/bDGukVtc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=jTGHmXDoRQug9GwBaRr37IHgR5QOO7PBT699btwiMk8sPc5rXsAT0hEobAthRJSbccYMUI8Y9E+d229SF8Fcn3lnNCSf+8jxgy3DIfxJQ6F/ZfA4GsHMh8I5xSdbrMd9+cQvgl9Yu5JjgelMGoiNZH71wM98qIgnfE6q8FnMjyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Zjg7CX+/; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Zjg7CX+/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708097884; x=1739633884;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=KNNzJYsRXz/djhcA10PNG33OwY0MmK+Mtu/bDGukVtc=;
  b=Zjg7CX+/aHYymAhwQLhbSiPjMS1kjuIDJZ5v3x5l3p//FfIq+u6xzyM0
   EAmy4IAuIN9T5NySZZstd9FZe0jCUImd/lNUdBFBOnRElvAuBocDJ6fxo
   P23VrdvnvEo0oUo1cgUnxKPmcjFHtLZl1QlVaFm+nfzlJAz29nstLdKw3
   knSqOla3yvwNR7nFDyuaR0iT0WVVycqC/Jzui2cDsxe37tWcijuw25XRp
   bJKFmK1yqs/S9WgC1+fDcHUm/x58uFD5azrYXyNQDkW8k6Ibh/4Zh0IEq
   Bfi11Bh6565UoyZUtWwBPXf72BDoY1J5nrSUdtMCog856MWIxX3RWUlPr
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10986"; a="13622723"
X-IronPort-AV: E=Sophos;i="6.06,165,1705392000"; 
   d="scan'208";a="13622723"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2024 07:38:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10986"; a="935861443"
X-IronPort-AV: E=Sophos;i="6.06,165,1705392000"; 
   d="scan'208";a="935861443"
Received: from silpixa00400295.ir.intel.com ([10.237.213.194])
  by fmsmga001.fm.intel.com with ESMTP; 16 Feb 2024 07:37:57 -0800
From: Adam Guerin <adam.guerin@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Adam Guerin <adam.guerin@intel.com>
Subject: [PATCH 0/6] crypto: qat - fix warnings reported by clang
Date: Fri, 16 Feb 2024 15:19:54 +0000
Message-Id: <20240216151959.19382-1-adam.guerin@intel.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organisation: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare, Ireland
Content-Transfer-Encoding: 8bit

This set fixes a list of warnings found by compiling the QAT driver with
"CC=clang W=2" and with the Clang tool scan-build.

These fixes include removing unused macros in both adf_cnv_dbgfs.c and
qat_comp_alg.c, fix initialization of multiple variables, check that
delta_us is not 0, and fixing the comment structures in multiple files.

Adam Guerin (6):
  crypto: qat - remove unused macros in qat_comp_alg.c
  crypto: qat - removed unused macro in adf_cnv_dbgfs.c
  crypto: qat - avoid division by zero
  crypto: qat - remove double initialization of value
  crypto: qat - remove unnecessary description from comment
  crypto: qat - fix comment structure

 drivers/crypto/intel/qat/qat_common/adf_clock.c     | 3 +++
 drivers/crypto/intel/qat/qat_common/adf_cnv_dbgfs.c | 1 -
 drivers/crypto/intel/qat/qat_common/adf_dev_mgr.c   | 4 ++--
 drivers/crypto/intel/qat/qat_common/adf_gen4_ras.c  | 6 ++----
 drivers/crypto/intel/qat/qat_common/adf_isr.c       | 2 --
 drivers/crypto/intel/qat/qat_common/adf_vf_isr.c    | 2 --
 drivers/crypto/intel/qat/qat_common/qat_comp_algs.c | 9 ---------
 drivers/crypto/intel/qat/qat_common/qat_crypto.c    | 4 ++--
 8 files changed, 9 insertions(+), 22 deletions(-)


base-commit: 7a35f3adf4535a9a56ef7b3e75355806632030ca
-- 
2.40.1

