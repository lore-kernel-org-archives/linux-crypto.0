Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC0888F54
	for <linux-crypto@vger.kernel.org>; Fri, 14 Mar 2025 13:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741957783; cv=none; b=Pznn1oEkVbLTR9qziiJgvnyZ3oQKgUp/nt37WcdOZLUzFAIr/kAhiX4PEtArfd/Y3bsj+9TsRqr0s1dIWcYh1Xd751Vmc7EbGicIDxV57iOz+ABF9ztKImZ6PLWbP0bZjVwTrx3fgIv2viDgfKbCo2TQHZNt+Cm9EbviVXT+oAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741957783; c=relaxed/simple;
	bh=Z47Dp2pwt1ENr+mpX/vC5/WKte+mc+0OceffUCSQOzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ocCRt9imCBjR+J6Zmms34YH+oN8e3+lTgVpo41NKs1+qk9daOroykUHRm7YIBs0p1Kl1Khl/5gJaJ89mvHMpZT4dHahnxA+MtNzMa3GLFZmoWEffEQYKdBbGoUabY8bLhEbXRxp1y8wh0ykjaiRs8dP52zAFg2tot9i+ooY5I8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FrUYBnDn; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FrUYBnDn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741957782; x=1773493782;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Z47Dp2pwt1ENr+mpX/vC5/WKte+mc+0OceffUCSQOzM=;
  b=FrUYBnDnQY+mq0FWssg4OjR8CFBCC6DaIgcQeCQFczAZ8/cbtBBSAfzd
   EcA1yoXtMNpRc42nChambFFnHK6KYwv5qNjFFESUuclKynBUFCdS7RokV
   Avix6cvXUOlZNUVY3KA8Gc6lnUfqAW5rY0eN4eOlftNIP01tkOVzW/uzu
   AmfhcEbLxbM4QyTGlFPqZUJ8TPT0KQB7AmgPHzrYrRLNXPYtOUpq5ei5v
   AFTlIgcbwKDNRO3ZxqtAu6kLj7HqO5Uyu55Dtflx+RFzbTBPw5mvZevD0
   zZ6qh9IWdiJ1yxLPXcaiHtLWMgpiKwfMOaEOLdjQejh29mor3Lu2UF1Wv
   w==;
X-CSE-ConnectionGUID: a8SFMEDNRmuA3o9Rs4DwRw==
X-CSE-MsgGUID: 3Qa5O00OS0qsnvOZwRgGMg==
X-IronPort-AV: E=McAfee;i="6700,10204,11373"; a="53762324"
X-IronPort-AV: E=Sophos;i="6.14,246,1736841600"; 
   d="scan'208";a="53762324"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2025 06:09:41 -0700
X-CSE-ConnectionGUID: tCIAOR0tTYyK8C1NmIZUMw==
X-CSE-MsgGUID: mAvs8qR/RuumkcaafKpR5Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,246,1736841600"; 
   d="scan'208";a="121072104"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.223.204])
  by fmviesa006.fm.intel.com with ESMTP; 14 Mar 2025 06:09:39 -0700
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Jack Xu <jack.xu@intel.com>,
	Ahsan Atta <ahsan.atta@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 1/3] crypto: qat - remove unused members in suof structure
Date: Fri, 14 Mar 2025 12:57:52 +0000
Message-ID: <20250314130918.11877-3-giovanni.cabiddu@intel.com>
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

Remove the members `css_key` and `css_signature` which are not used for
doing the firmware authentication.

The signed image pointer can be calculated using the pointer to the CSS
header and the length of the CSS header, making these members redundant.

Signed-off-by: Jack Xu <jack.xu@intel.com>
Reviewed-by: Ahsan Atta <ahsan.atta@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/intel/qat/qat_common/icp_qat_uclo.h | 2 --
 drivers/crypto/intel/qat/qat_common/qat_uclo.c     | 9 ++-------
 2 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/icp_qat_uclo.h b/drivers/crypto/intel/qat/qat_common/icp_qat_uclo.h
index e28241bdd0f4..4b5e7dcd11d1 100644
--- a/drivers/crypto/intel/qat/qat_common/icp_qat_uclo.h
+++ b/drivers/crypto/intel/qat/qat_common/icp_qat_uclo.h
@@ -404,8 +404,6 @@ struct icp_qat_suof_img_hdr {
 	char          *simg_buf;
 	unsigned long simg_len;
 	char          *css_header;
-	char          *css_key;
-	char          *css_signature;
 	char          *css_simg;
 	unsigned long simg_size;
 	unsigned int  ae_num;
diff --git a/drivers/crypto/intel/qat/qat_common/qat_uclo.c b/drivers/crypto/intel/qat/qat_common/qat_uclo.c
index 7ea40b4f6e5b..5ace036addec 100644
--- a/drivers/crypto/intel/qat/qat_common/qat_uclo.c
+++ b/drivers/crypto/intel/qat/qat_common/qat_uclo.c
@@ -1064,6 +1064,7 @@ static void qat_uclo_map_simg(struct icp_qat_fw_loader_handle *handle,
 			      struct icp_qat_suof_chunk_hdr *suof_chunk_hdr)
 {
 	struct icp_qat_suof_handle *suof_handle = handle->sobj_handle;
+	unsigned int offset = ICP_QAT_AE_IMG_OFFSET(handle);
 	struct icp_qat_simg_ae_mode *ae_mode;
 	struct icp_qat_suof_objhdr *suof_objhdr;
 
@@ -1075,13 +1076,7 @@ static void qat_uclo_map_simg(struct icp_qat_fw_loader_handle *handle,
 				   suof_chunk_hdr->offset))->img_length;
 
 	suof_img_hdr->css_header = suof_img_hdr->simg_buf;
-	suof_img_hdr->css_key = (suof_img_hdr->css_header +
-				 sizeof(struct icp_qat_css_hdr));
-	suof_img_hdr->css_signature = suof_img_hdr->css_key +
-				      ICP_QAT_CSS_FWSK_MODULUS_LEN(handle) +
-				      ICP_QAT_CSS_FWSK_EXPONENT_LEN(handle);
-	suof_img_hdr->css_simg = suof_img_hdr->css_signature +
-				 ICP_QAT_CSS_SIGNATURE_LEN(handle);
+	suof_img_hdr->css_simg = suof_img_hdr->css_header + offset;
 
 	ae_mode = (struct icp_qat_simg_ae_mode *)(suof_img_hdr->css_simg);
 	suof_img_hdr->ae_mask = ae_mode->ae_mask;
-- 
2.48.1

