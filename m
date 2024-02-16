Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72F4C134CC8
	for <linux-crypto@vger.kernel.org>; Fri, 16 Feb 2024 15:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708097923; cv=none; b=lBnhFPviczKA1OYO5oaybI+OKEGia7AAQsQxtYpUtY+2mLgHOqEsPsrZqVkU+K15bIvymcbjcm9lWGsCNOHaetfk2kBqeAdnywvZ5Y4WbzEn2FP8f9jgLCOg61tms/ZGVTCCvWDDi69MatsGPf9gZ0WFCW4vjx7v/HEw6jJeDJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708097923; c=relaxed/simple;
	bh=1svJpBeoKPTG7RxSJ6pjNnVim87jOmiIf7DSmYutcrY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GCz6SkbHIrjO3/0f2yAeKL2/XC0MROy/eDffnd8s/wCo0Ee0plQsNk5HlwVyQCQdIWNVl2Gv/d3CTFNekeLYw0nVTwE9R+tfbtNGWLJfE2s4r9TO2e/8d+LSboE/Bl9n6ledsQ4WiKB22R4w6nnrEXioYenauiIjDUJwMuHZ18Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=n2VZHRx5; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="n2VZHRx5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708097921; x=1739633921;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1svJpBeoKPTG7RxSJ6pjNnVim87jOmiIf7DSmYutcrY=;
  b=n2VZHRx5+cUhUZ6wyXnGXFcWjVJIBAzxY8GTjSuTwMshZoOhWzpswRaE
   g8yi63tjFuGBCfMasFL8B10KpU2gXLAAayaX+qfSzVxEE82x++3fVNEHQ
   xDbw6hWzcFUGoUXmYlC79SsyEoZ2EZb+zj9hLKydSTkQIhHHTguQnjJj4
   T+MqFx7VZJZcFamP5cq7PATlvQYsFMwkh3FbH2P49mpdIgrCZv9FGnmQD
   0ywJtcLEAevWRxEc5+h3lX07xLzFnsuyhwavo6Lsl23JOau5ej9vgfF2/
   mM4Oj4HRu80yaTY2Ze6pDo8ttugojylmImngop5YgS/zPeBvT4lZwxy2h
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10986"; a="13622791"
X-IronPort-AV: E=Sophos;i="6.06,165,1705392000"; 
   d="scan'208";a="13622791"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2024 07:38:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10986"; a="935861516"
X-IronPort-AV: E=Sophos;i="6.06,165,1705392000"; 
   d="scan'208";a="935861516"
Received: from silpixa00400295.ir.intel.com ([10.237.213.194])
  by fmsmga001.fm.intel.com with ESMTP; 16 Feb 2024 07:38:39 -0800
From: Adam Guerin <adam.guerin@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Adam Guerin <adam.guerin@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 6/6] crypto: qat - fix comment structure
Date: Fri, 16 Feb 2024 15:20:00 +0000
Message-Id: <20240216151959.19382-7-adam.guerin@intel.com>
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

Move comment description to the same line as the function name.

This is to fix the following warning when compiling the QAT driver
using the clang compiler with CC=clang W=2:
    drivers/crypto/intel/qat/qat_common/qat_crypto.c:108: warning: missing initial short description on line:
     * qat_crypto_vf_dev_config()

Signed-off-by: Adam Guerin <adam.guerin@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/intel/qat/qat_common/qat_crypto.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/qat_crypto.c b/drivers/crypto/intel/qat/qat_common/qat_crypto.c
index 40c8e74d1cf9..101c6ea41673 100644
--- a/drivers/crypto/intel/qat/qat_common/qat_crypto.c
+++ b/drivers/crypto/intel/qat/qat_common/qat_crypto.c
@@ -105,8 +105,8 @@ struct qat_crypto_instance *qat_crypto_get_instance_node(int node)
 }
 
 /**
- * qat_crypto_vf_dev_config()
- *     create dev config required to create crypto inst.
+ * qat_crypto_vf_dev_config() - create dev config required to create
+ * crypto inst.
  *
  * @accel_dev: Pointer to acceleration device.
  *
-- 
2.40.1

