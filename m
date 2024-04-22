Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E7A9150999
	for <linux-crypto@vger.kernel.org>; Mon, 22 Apr 2024 14:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713795214; cv=none; b=hvZxqJfysFVxm+EnpBy/yBON6YQS9jyJPTabQi0twO3fT2Zwq6EA7Hk1mzLuPK8q6Txrx2kFQ1kWfFxbWjm1o59pvX6ni4psXvaSZI2mqTvt7jwbW6QZqb6H3UQV2vg3tYIvh6pSPbhpHDS6CD5iPz4LAloCzgGFOqvNNkYjgrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713795214; c=relaxed/simple;
	bh=EzNx+uIFpNNslhnYcCknio7SDGIbjDccse6FEyl2DT4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=C8PghUgEhAIuPHFb0YfBRUwwjkfE7UddhwdZeLwvuKedXwegRsCHnsRpqGYIeyJPoBRtWen2oNUjAyF7RFQNKLnYnnC6+GI8csUa3CkaXkdJsNj+mmTyUodQeXQ/EAKDrrPLiN+b+FNBq+Eqhb3hqbR4k6EmWLTk3dviBeFp+/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FEnAvAmQ; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FEnAvAmQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713795214; x=1745331214;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=EzNx+uIFpNNslhnYcCknio7SDGIbjDccse6FEyl2DT4=;
  b=FEnAvAmQr+Cky5r1xfAXpJOpKdYZZZq1ghRNFuvg1CT19t/ZXGsPls+F
   1S+b1I7ivMElquaL3te79A7CGM1CWCeXkoTOWwdGrMXHyD/jjEB0GR2Mj
   IUODPNIZOtVUD/Eon3RiS5sLtHiblRt9wTXicPru+61yA/lXu9+YghMx1
   JXFqgE/O7thI/Y+3ZcwCGYqGxxEk4uV6Mn71NaNQGHZOm5W7Q9l7QwQlI
   KbTh1zGFak83m/4ds8mQfpmhtvUCtwGZpRlo1R/TzPQQ69xPIncZu94sD
   xk/9kq1Z1Oz6HcbWsGztjeB1WjsMV81eACkoLb+oSmGig2OuABJj+KZOO
   A==;
X-CSE-ConnectionGUID: 7O/G9c3pQlmrEzxys96tXA==
X-CSE-MsgGUID: 08FgYPpLS9u4hSfveo3vUg==
X-IronPort-AV: E=McAfee;i="6600,9927,11052"; a="13170880"
X-IronPort-AV: E=Sophos;i="6.07,220,1708416000"; 
   d="scan'208";a="13170880"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2024 07:13:32 -0700
X-CSE-ConnectionGUID: j0shISczRCyQZmykB9FICg==
X-CSE-MsgGUID: ngM/HuXIRH+vKUOL0qJDvw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,220,1708416000"; 
   d="scan'208";a="54966245"
Received: from unknown (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.216])
  by orviesa002.jf.intel.com with ESMTP; 22 Apr 2024 07:13:29 -0700
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Damian Muszynski <damian.muszynski@intel.com>
Subject: [PATCH] crypto: qat - specify firmware files for 402xx
Date: Mon, 22 Apr 2024 15:13:17 +0100
Message-ID: <20240422141324.7138-1-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit

The 4xxx driver can probe 4xxx and 402xx devices. However, the driver
only specifies the firmware images required for 4xxx.
This might result in external tools missing these binaries, if required,
in the initramfs.

Specify the firmware image used by 402xx with the MODULE_FIRMWARE()
macros in the 4xxx driver.

Fixes: a3e8c919b993 ("crypto: qat - add support for 402xx devices")
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Damian Muszynski <damian.muszynski@intel.com>
---
 drivers/crypto/intel/qat/qat_4xxx/adf_drv.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/intel/qat/qat_4xxx/adf_drv.c b/drivers/crypto/intel/qat/qat_4xxx/adf_drv.c
index 9762f2bf7727..d26564cebdec 100644
--- a/drivers/crypto/intel/qat/qat_4xxx/adf_drv.c
+++ b/drivers/crypto/intel/qat/qat_4xxx/adf_drv.c
@@ -197,7 +197,9 @@ module_pci_driver(adf_driver);
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_AUTHOR("Intel");
 MODULE_FIRMWARE(ADF_4XXX_FW);
+MODULE_FIRMWARE(ADF_402XX_FW);
 MODULE_FIRMWARE(ADF_4XXX_MMP);
+MODULE_FIRMWARE(ADF_402XX_MMP);
 MODULE_DESCRIPTION("Intel(R) QuickAssist Technology");
 MODULE_VERSION(ADF_DRV_VERSION);
 MODULE_SOFTDEP("pre: crypto-intel_qat");
-- 
2.44.0

