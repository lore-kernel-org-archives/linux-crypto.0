Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9293134CC8
	for <linux-crypto@vger.kernel.org>; Fri, 16 Feb 2024 15:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708097905; cv=none; b=fxkwYMAlty4paSLonTEuvyQEI67bZhYTgS41lXi5oQtR3/bLVOPmjQkzo2ETbhC1XiVQ0LE5tnC/sKmARh6DL+J3+7VhkbQTomBufRfnZHP9lzqPFLH2l2ZTC4YfH3mu19rFrc7MDddwv/QHsed70Ed03wWMSrRMEPeDtMkb2Qk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708097905; c=relaxed/simple;
	bh=cCUm1Kkkg+CfUo6zVGhxnMCovD8n73SY/FX8dCxcl3I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JasAmOdpCwVJYyRQhxyCL0erctAgFLxee8Z5nFccPkUqkt326w/69unYstJTTzaa6ukaQ6c2MKZMKXodSp/uNP5yn8iapp93I3yIYQQN0Wh9lhh5z+22CYCS9kDbzKJHl5K2/WP6bQfMn9/+tPM7Deg0P1PtxrAUzw2nFBErVlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=U3o5lQjn; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="U3o5lQjn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708097904; x=1739633904;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cCUm1Kkkg+CfUo6zVGhxnMCovD8n73SY/FX8dCxcl3I=;
  b=U3o5lQjn2UQ3c4FWnTfnWFb5+NH5axssQTW+Gez4MxTJOS+CiOnCjh7M
   deBIBCv1NgIxa19HHTATcLaS0eAJghxJsapDmZwQf8A+tEDx+OaBXYb8H
   MduWKeq+bKdocprpDyCLvTrG0Poy9JYRq6jJWljCtoSBGN1Q1ypXYx6tB
   SUqiYxrp7JBV/knZraw8BNPIr0w8M6nKR8P6gWjLdBGejd4uDSuQ4XmXd
   nJkoydXGPYDyl6sCTNhybO2SF+m8N/bVQagI+JqYiuJwxOWzcVSIqnsqr
   NBAwtpeUMf8SCr/3kjDhUDpx0GJj43JHxBSu17QncXSCBTGivE1Brx3jU
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10986"; a="13622748"
X-IronPort-AV: E=Sophos;i="6.06,165,1705392000"; 
   d="scan'208";a="13622748"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2024 07:38:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10986"; a="935861484"
X-IronPort-AV: E=Sophos;i="6.06,165,1705392000"; 
   d="scan'208";a="935861484"
Received: from silpixa00400295.ir.intel.com ([10.237.213.194])
  by fmsmga001.fm.intel.com with ESMTP; 16 Feb 2024 07:38:22 -0800
From: Adam Guerin <adam.guerin@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Adam Guerin <adam.guerin@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 5/6] crypto: qat - remove unnecessary description from comment
Date: Fri, 16 Feb 2024 15:19:59 +0000
Message-Id: <20240216151959.19382-6-adam.guerin@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20240216151959.19382-1-adam.guerin@intel.com>
References: <20240216151959.19382-1-adam.guerin@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organisation: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare, Ireland
Content-Transfer-Encoding: 8bit

Remove extra description from comments as it is not required.

This is to fix the following warning when compiling the QAT driver
using the clang compiler with CC=clang W=2:
    drivers/crypto/intel/qat/qat_common/adf_dev_mgr.c:65: warning: contents before sections
    drivers/crypto/intel/qat/qat_common/adf_isr.c:380: warning: contents before sections
    drivers/crypto/intel/qat/qat_common/adf_vf_isr.c:298: warning: contents before sections

Signed-off-by: Adam Guerin <adam.guerin@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/intel/qat/qat_common/adf_dev_mgr.c | 4 ++--
 drivers/crypto/intel/qat/qat_common/adf_isr.c     | 2 --
 drivers/crypto/intel/qat/qat_common/adf_vf_isr.c  | 2 --
 3 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_dev_mgr.c b/drivers/crypto/intel/qat/qat_common/adf_dev_mgr.c
index 86ee36feefad..f07b748795f7 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_dev_mgr.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_dev_mgr.c
@@ -60,10 +60,10 @@ static int adf_get_vf_real_id(u32 fake)
 
 /**
  * adf_clean_vf_map() - Cleans VF id mapings
- *
- * Function cleans internal ids for virtual functions.
  * @vf: flag indicating whether mappings is cleaned
  *	for vfs only or for vfs and pfs
+ *
+ * Function cleans internal ids for virtual functions.
  */
 void adf_clean_vf_map(bool vf)
 {
diff --git a/drivers/crypto/intel/qat/qat_common/adf_isr.c b/drivers/crypto/intel/qat/qat_common/adf_isr.c
index 020d213f4c99..cae1aee5479a 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_isr.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_isr.c
@@ -380,8 +380,6 @@ EXPORT_SYMBOL_GPL(adf_isr_resource_alloc);
 /**
  * adf_init_misc_wq() - Init misc workqueue
  *
- * Function init workqueue 'qat_misc_wq' for general purpose.
- *
  * Return: 0 on success, error code otherwise.
  */
 int __init adf_init_misc_wq(void)
diff --git a/drivers/crypto/intel/qat/qat_common/adf_vf_isr.c b/drivers/crypto/intel/qat/qat_common/adf_vf_isr.c
index b05c3957a160..cdbb2d687b1b 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_vf_isr.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_vf_isr.c
@@ -293,8 +293,6 @@ EXPORT_SYMBOL_GPL(adf_flush_vf_wq);
 /**
  * adf_init_vf_wq() - Init workqueue for VF
  *
- * Function init workqueue 'adf_vf_stop_wq' for VF.
- *
  * Return: 0 on success, error code otherwise.
  */
 int __init adf_init_vf_wq(void)
-- 
2.40.1

