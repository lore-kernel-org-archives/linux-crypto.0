Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF1F31FF1C9
	for <linux-crypto@vger.kernel.org>; Fri, 14 Mar 2025 13:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741957784; cv=none; b=A4g/BPul2j1G27dRaoY846VjAr0YFq1vI9C7FQjljQXDIUeNy6WEpNcQsWrh96y6h6M8ZayTRYd4CUmwluhPw2l7MFVPrRr8XOfoM5CPQuBdt92awCYWz1S4rtjpZZiFdnmXr7H0IiqixZXiHoje99eCXWvbRR12mZPSeel/CPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741957784; c=relaxed/simple;
	bh=Z0PXwf42jCLYzPYuPRIfVC2OwrPxn8Y7IeYJr12lg2c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cOlfWme9XkjtbV3cpa/w/4Vg/i7FFtvHMOaVsQqNXcRbfKr611d14UZq+1lkYEvwvfz1zdz5z2ad1OMtqVJYpf8k2Ba+N4R4x9cNRhlGhtcphLbCdLlslTLT0sLCqxfbl2AG9GFHrApYtHjZ3R7lrGUMufSdKVBce6/ZsWQPEwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Bjz/SxIu; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Bjz/SxIu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741957783; x=1773493783;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Z0PXwf42jCLYzPYuPRIfVC2OwrPxn8Y7IeYJr12lg2c=;
  b=Bjz/SxIus4E2vJEt0x2Ta98zGy1L9RkP+6MEO7dVf810L0CHgZqp7Khl
   8HgmVPUERYxgpcLXfeeNtgpud+sP9Qle/xUj/MVXjMmjMTUMbu2whcbCS
   ck1rPHR2/76FOW5K4RP3keM8Cz5gVEUdtzzrLi/MYtVSqIyNdgQyXysmY
   nWdVYxVTY06W2q7FEbaEdD6KeUYFbRkkRf2S9FeY9zCq3ZoqqmcjR5rd4
   5eQgfUxOZiAaxkOOECEFMpTcSYPLgQGS0qxwZIb/joFD9SGt2eavmxfWw
   ZU15N8x+oZpNRVu0/aU+6RYzc/iMbE+X+7L2ePZdxxfrULidOkAl4T8hH
   w==;
X-CSE-ConnectionGUID: I7iwzZpTSGmvBnxqQUPSFA==
X-CSE-MsgGUID: ktx4sprCTpGhq/rFyCZlQQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11373"; a="53762328"
X-IronPort-AV: E=Sophos;i="6.14,246,1736841600"; 
   d="scan'208";a="53762328"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2025 06:09:43 -0700
X-CSE-ConnectionGUID: 6M+cqggxRqqELOIqOPQHcA==
X-CSE-MsgGUID: ZhsynVnUS7WD1k7QyoyN+w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,246,1736841600"; 
   d="scan'208";a="121072107"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.223.204])
  by fmviesa006.fm.intel.com with ESMTP; 14 Mar 2025 06:09:41 -0700
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Jack Xu <jack.xu@intel.com>,
	Ahsan Atta <ahsan.atta@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 2/3] crypto: qat - remove redundant FW image size check
Date: Fri, 14 Mar 2025 12:57:53 +0000
Message-ID: <20250314130918.11877-4-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250314130918.11877-2-giovanni.cabiddu@intel.com>
References: <20250314130918.11877-2-giovanni.cabiddu@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit

From: Jack Xu <jack.xu@intel.com>

The FW image size check is already performed in the function
qat_uclo_check_image() before calling `qat_uclo_map_auth_fw()`.
Therefore, the additional check in `qat_uclo_map_auth_fw()` is redundant
and can be safely removed.

Signed-off-by: Jack Xu <jack.xu@intel.com>
Reviewed-by: Ahsan Atta <ahsan.atta@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/intel/qat/qat_common/qat_uclo.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/qat_uclo.c b/drivers/crypto/intel/qat/qat_common/qat_uclo.c
index 5ace036addec..61be6df50684 100644
--- a/drivers/crypto/intel/qat/qat_common/qat_uclo.c
+++ b/drivers/crypto/intel/qat/qat_common/qat_uclo.c
@@ -1418,10 +1418,6 @@ static int qat_uclo_map_auth_fw(struct icp_qat_fw_loader_handle *handle,
 	struct icp_qat_simg_ae_mode *simg_ae_mode;
 	struct icp_firml_dram_desc img_desc;
 
-	if (size > (ICP_QAT_AE_IMG_OFFSET(handle) + ICP_QAT_CSS_RSA4K_MAX_IMAGE_LEN)) {
-		pr_err("QAT: error, input image size overflow %d\n", size);
-		return -EINVAL;
-	}
 	length = (css_hdr->fw_type == CSS_AE_FIRMWARE) ?
 		 ICP_QAT_CSS_AE_SIMG_LEN(handle) + simg_offset :
 		 size + ICP_QAT_CSS_FWSK_PAD_LEN(handle) + simg_offset;
-- 
2.48.1

