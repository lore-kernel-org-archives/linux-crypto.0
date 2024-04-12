Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9764C3BBC3
	for <linux-crypto@vger.kernel.org>; Fri, 12 Apr 2024 12:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712926014; cv=none; b=rycJSC9culs3yehctZQhIyCfykSj1xRdCLF8nLrgDSR1u0jmgcz05gzzqFWhSC2mh2Bfbide59rfaR67CxUQJoYxaZt7WikA4/qO1l/d3VezKI/XhrPV9V29e7etrpQ3xqerY10ZRAqBtaSYtHC5+JsL2pM62BZwXGxAGo0edhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712926014; c=relaxed/simple;
	bh=o6pjyZP/Akq0QlT9WKEkG+Xkt9uqgWN7Li854uFEgOI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TEWcFZkKpt7qwpX2MWOvFP3sfrIAcDsdmZU0MzI3/i3eeOzlPj2KhMYCqsZ+tmz1nj1EkQ3ztYHPF/AZ7nLeEB2a3xV1w+eprzkmuLwNAA/SWEvxwo1upI5IwDh2i4WnMsCDUOlSvzAQKb/RcR/9amC2WEuBj6Vhqy/5P2CDTVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ITIxQT1j; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ITIxQT1j"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712926013; x=1744462013;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=o6pjyZP/Akq0QlT9WKEkG+Xkt9uqgWN7Li854uFEgOI=;
  b=ITIxQT1j2wR7XePlRUXRBzOVpIHlINtlQxqqTuWWX1kik+bMmuOmBAY4
   8STK8RVm+trdlCThWtvvGY5pTmO68Xlhf2vbz8VYrJ149Ypsd8VG8Qy26
   ID4x/JX8n1P/3xXugHMTNyYAmiUQJUvYh6s2aaoqRBw+/QpA7ifKnnJiW
   kygXonqfboqqEwaFhoCFMieMawhOLptMT3KsiLJCzl5tw3om0Q+KYpQVF
   FaPyTwTBKtaaavfK/9Wer6+zZR7xUpRkNy5w/Oy+0Mw7hWm2LYj1t5kzO
   6T3vy46JJYyxWc3Fsk4XpD1KGm9aWiKioWqIUsqOJhh4iL0yO9hWtKG1c
   Q==;
X-CSE-ConnectionGUID: gztyjucmQ/SFVVQqLciCGw==
X-CSE-MsgGUID: YwubvW6fRoKhtirhhCuLyQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11041"; a="19529109"
X-IronPort-AV: E=Sophos;i="6.07,196,1708416000"; 
   d="scan'208";a="19529109"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2024 05:46:53 -0700
X-CSE-ConnectionGUID: 6DDMtEfeT9+zIAH6IXM6hA==
X-CSE-MsgGUID: wfi0LuE8Sim9g1fgelEn9Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,196,1708416000"; 
   d="scan'208";a="25902115"
Received: from silpixa00400295.ir.intel.com ([10.237.213.194])
  by orviesa003.jf.intel.com with ESMTP; 12 Apr 2024 05:46:51 -0700
From: Adam Guerin <adam.guerin@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Adam Guerin <adam.guerin@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH v2 1/2] crypto: qat - improve error message in adf_get_arbiter_mapping()
Date: Fri, 12 Apr 2024 13:24:02 +0100
Message-Id: <20240412122401.243378-2-adam.guerin@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20240412122401.243378-1-adam.guerin@intel.com>
References: <20240412122401.243378-1-adam.guerin@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organisation: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare, Ireland
Content-Transfer-Encoding: 8bit

Improve error message to be more readable.

Fixes: 5da6a2d5353e ("crypto: qat - generate dynamically arbiter mappings")
Signed-off-by: Adam Guerin <adam.guerin@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c | 2 +-
 drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c   | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c b/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c
index d255cb3ebd9c..78f0ea49254d 100644
--- a/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c
@@ -298,7 +298,7 @@ static const u32 *adf_get_arbiter_mapping(struct adf_accel_dev *accel_dev)
 {
 	if (adf_gen4_init_thd2arb_map(accel_dev))
 		dev_warn(&GET_DEV(accel_dev),
-			 "Generate of the thread to arbiter map failed");
+			 "Failed to generate thread to arbiter mapping");
 
 	return GET_HW_DATA(accel_dev)->thd_to_arb_map;
 }
diff --git a/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c b/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
index 1e77e189a938..9fd7ec53b9f3 100644
--- a/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
@@ -210,7 +210,7 @@ static const u32 *adf_get_arbiter_mapping(struct adf_accel_dev *accel_dev)
 {
 	if (adf_gen4_init_thd2arb_map(accel_dev))
 		dev_warn(&GET_DEV(accel_dev),
-			 "Generate of the thread to arbiter map failed");
+			 "Failed to generate thread to arbiter mapping");
 
 	return GET_HW_DATA(accel_dev)->thd_to_arb_map;
 }
-- 
2.40.1

