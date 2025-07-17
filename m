Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C0CC1DE8A3
	for <linux-crypto@vger.kernel.org>; Thu, 17 Jul 2025 10:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752746816; cv=none; b=MkjFIsSLLVfRifTW/Hg82JAluamFyzIHtGhmswFiJRlBglHVcFuVW1Arv87yLzZasLGyJOV4n8TGwtjzffcUqVFJcx0R9DCRYkEZPetU/OdwOi4XdoEnF+kTyk7zlHV94rY5a7boTtgy1slyg5Go/7/JgT5dE3afu7whY3uFcW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752746816; c=relaxed/simple;
	bh=tMafA6DBnhgmgP64WVGX8yWK7Ddeywbi16XDCS+NHNE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZGPlIOU/6ib+cUCs4wfm/CKnrflypmy+Wsilc0FadcU4J8cS7Vt66LRD0ztAFjVwylY8WvRi9Jd5047PiHZZP959RlAC2X4ZDQb/STArL8S+2JUzyAls4z1HkLk6Hfy9v4+/EIXtbIRW1M8bwWype4ageSN+Ldgv0bszL+/JzRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eJ3qn+iz; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eJ3qn+iz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752746815; x=1784282815;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=tMafA6DBnhgmgP64WVGX8yWK7Ddeywbi16XDCS+NHNE=;
  b=eJ3qn+izDDOOH2uSG+F3OGbytC9mjJatMrhuH8ymw3AF8AIEYckptN41
   OyVqumRV0XpDtGyG8oW6THpgNYYPWOQm6D/1hDQB1wssvszRlTHimNGDX
   mlt8lIcx5mGr7PBOrwGxaCkW3n79MSFI/gxdIHiJ0DkNXgBbTvYMazD57
   9ZzCl/NLzI0Vf1BkRwKX7kcLvmrE7QdOTb3QnVZvAK5SzWvd1KvkwD4Si
   eUYQTW5392goghZaZbzwiTJuVDhjnWoBwAgwFqNXWIZqD/D+r8zaW6CV3
   0W2ffMbG0sHOM+yEJM8Cm2jV8vTsLyYOQsX7ooJIzvCM95W0eGyYM+3hh
   g==;
X-CSE-ConnectionGUID: Wgf1WIujRhm5JmLh6BP6zw==
X-CSE-MsgGUID: fODzy5KaS0ufJ4I4eGYahw==
X-IronPort-AV: E=McAfee;i="6800,10657,11493"; a="72470122"
X-IronPort-AV: E=Sophos;i="6.16,318,1744095600"; 
   d="scan'208";a="72470122"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2025 03:06:54 -0700
X-CSE-ConnectionGUID: sSzTU0yeT5a8w6pDa0MmjA==
X-CSE-MsgGUID: Pyy0oY+/QnqbS4uEcmvC9g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,318,1744095600"; 
   d="scan'208";a="157125135"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.223.204])
  by orviesa006.jf.intel.com with ESMTP; 17 Jul 2025 03:06:51 -0700
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Ahsan Atta <ahsan.atta@intel.com>
Subject: [PATCH] crypto: qat - make adf_dev_autoreset() static
Date: Thu, 17 Jul 2025 11:05:43 +0100
Message-ID: <20250717100647.6680-1-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.50.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit

The function adf_dev_autoreset() is only used within adf_aer.c and does
not need to be exposed outside the compilation unit.  Make it static and
remove it from the header adf_common_drv.h.

This does not introduce any functional change.

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Ahsan Atta <ahsan.atta@intel.com>
---
 drivers/crypto/intel/qat/qat_common/adf_aer.c        | 2 +-
 drivers/crypto/intel/qat/qat_common/adf_common_drv.h | 1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_aer.c b/drivers/crypto/intel/qat/qat_common/adf_aer.c
index 4cb8bd83f570..35679b21ff63 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_aer.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_aer.c
@@ -229,7 +229,7 @@ const struct pci_error_handlers adf_err_handler = {
 };
 EXPORT_SYMBOL_GPL(adf_err_handler);
 
-int adf_dev_autoreset(struct adf_accel_dev *accel_dev)
+static int adf_dev_autoreset(struct adf_accel_dev *accel_dev)
 {
 	if (accel_dev->autoreset_on_error)
 		return adf_dev_aer_schedule_reset(accel_dev, ADF_DEV_RESET_ASYNC);
diff --git a/drivers/crypto/intel/qat/qat_common/adf_common_drv.h b/drivers/crypto/intel/qat/qat_common/adf_common_drv.h
index 7a022bd4ae07..6cf3a95489e8 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_common_drv.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_common_drv.h
@@ -86,7 +86,6 @@ int adf_ae_stop(struct adf_accel_dev *accel_dev);
 extern const struct pci_error_handlers adf_err_handler;
 void adf_reset_sbr(struct adf_accel_dev *accel_dev);
 void adf_reset_flr(struct adf_accel_dev *accel_dev);
-int adf_dev_autoreset(struct adf_accel_dev *accel_dev);
 void adf_dev_restore(struct adf_accel_dev *accel_dev);
 int adf_init_aer(void);
 void adf_exit_aer(void);

base-commit: abe42c61a8b8de9df1856f1d35e8571bc4f19a38
-- 
2.50.0

