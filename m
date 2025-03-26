Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E614C1F4276
	for <linux-crypto@vger.kernel.org>; Wed, 26 Mar 2025 16:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743006199; cv=none; b=UkNIi/AnAabJQnzgA6ikhfxVSyAes7b14QJ6t+IMIODdwwDPe6xXuAXMKDFXMzXLluhEWkXaeDwF8E+ETYeoMzfW/4TcjAj7mXuMZvHzwq0EtvyoI4HhWKvfwVtdBwXaYrwAWZmu2c3it3jl/bSuKfLanSBWusOvqRlrScQr/bE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743006199; c=relaxed/simple;
	bh=DmAiWbb9kYHodrsrZFLLJzfsLtE4J0u6OwUUssxz6vI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SN27/qkUoKWTXefnUCSvk4nY8ie7W/tmYI+AEgswFSYfSlEr0/14Fel0bgrwD2uo9awwvhxbyRO9RW943AhuMhAGyRwq3DetafVbqltrTzr/2N1oP5XHUhFBOPhP03Ds+khAibr4F4JfzO38T1h7SCxLnW3d+nPOVIiMf01+kcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VO1nkgUA; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VO1nkgUA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1743006197; x=1774542197;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=DmAiWbb9kYHodrsrZFLLJzfsLtE4J0u6OwUUssxz6vI=;
  b=VO1nkgUARERRwEBFrSJwS0hWA6stUyDd36QQ3QPbuP+VNPh1P1/J3vcq
   RfU5O2uzBewG6BMoPbSi6ddx2ReQ8bzrE09bBLURDbWd7r8ZaEi2glZW3
   dy4KlZOCCbe9b02BACz7wpreWxpowzgEZSEwZfYPaUW1OP0bqsviqssuJ
   TuUfJkGe9xR+YYn9m4Nezj1a4Q5JJ/bYhib/3XIRh2d2P5JBGgtpQEMuZ
   XISP1JijgtsPl+X0YFs/1hLxs2ZqFZOZ9Lq95bSwkbiMdaJmiRSKvHRr4
   lEQuuStCGsrlUe2qzg2eMsyEK4rQUQlhvzI8S4nEayNEnU9qEyxx68ozl
   w==;
X-CSE-ConnectionGUID: udyh12orQGK0fzTPrPpzIw==
X-CSE-MsgGUID: Qqdze8pFRbyNXgzGFTtL1Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11385"; a="44489301"
X-IronPort-AV: E=Sophos;i="6.14,278,1736841600"; 
   d="scan'208";a="44489301"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2025 09:23:16 -0700
X-CSE-ConnectionGUID: Sxrb9N4OSmaUTRLw3d192A==
X-CSE-MsgGUID: yL3WFFPDSQ+6jsbiTV8hgw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,278,1736841600"; 
   d="scan'208";a="129930827"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.223.204])
  by fmviesa004.fm.intel.com with ESMTP; 26 Mar 2025 09:23:15 -0700
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH] crypto: qat - remove initialization in device class
Date: Wed, 26 Mar 2025 16:23:01 +0000
Message-ID: <20250326162309.107998-1-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit

The structures adf_hw_device_class_* are static.
Remove initialization to zero of the field instance as it is zero
by C convention.

This does not introduce any functional change.

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c           | 1 -
 drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c             | 1 -
 drivers/crypto/intel/qat/qat_c3xxx/adf_c3xxx_hw_data.c           | 1 -
 drivers/crypto/intel/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c       | 1 -
 drivers/crypto/intel/qat/qat_c62x/adf_c62x_hw_data.c             | 1 -
 drivers/crypto/intel/qat/qat_c62xvf/adf_c62xvf_hw_data.c         | 1 -
 drivers/crypto/intel/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c     | 1 -
 drivers/crypto/intel/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c | 1 -
 8 files changed, 8 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c b/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c
index 4feeef83f7a3..795f4598400b 100644
--- a/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c
@@ -93,7 +93,6 @@ static const struct adf_fw_config adf_fw_dcc_config[] = {
 static struct adf_hw_device_class adf_420xx_class = {
 	.name = ADF_420XX_DEVICE_NAME,
 	.type = DEV_420XX,
-	.instances = 0,
 };
 
 static u32 get_ae_mask(struct adf_hw_device_data *self)
diff --git a/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c b/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
index 4eb6ef99efdd..63c7c8e90cca 100644
--- a/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
@@ -96,7 +96,6 @@ static_assert(ARRAY_SIZE(adf_fw_cy_config) == ARRAY_SIZE(adf_fw_dcc_config));
 static struct adf_hw_device_class adf_4xxx_class = {
 	.name = ADF_4XXX_DEVICE_NAME,
 	.type = DEV_4XXX,
-	.instances = 0,
 };
 
 static u32 get_ae_mask(struct adf_hw_device_data *self)
diff --git a/drivers/crypto/intel/qat/qat_c3xxx/adf_c3xxx_hw_data.c b/drivers/crypto/intel/qat/qat_c3xxx/adf_c3xxx_hw_data.c
index e78f7bfd30b8..9425af26d34c 100644
--- a/drivers/crypto/intel/qat/qat_c3xxx/adf_c3xxx_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_c3xxx/adf_c3xxx_hw_data.c
@@ -22,7 +22,6 @@ static const u32 thrd_to_arb_map[ADF_C3XXX_MAX_ACCELENGINES] = {
 static struct adf_hw_device_class c3xxx_class = {
 	.name = ADF_C3XXX_DEVICE_NAME,
 	.type = DEV_C3XXX,
-	.instances = 0
 };
 
 static u32 get_accel_mask(struct adf_hw_device_data *self)
diff --git a/drivers/crypto/intel/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c b/drivers/crypto/intel/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c
index a512ca4efd3f..f73d9a4a9ab7 100644
--- a/drivers/crypto/intel/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c
@@ -13,7 +13,6 @@
 static struct adf_hw_device_class c3xxxiov_class = {
 	.name = ADF_C3XXXVF_DEVICE_NAME,
 	.type = DEV_C3XXXVF,
-	.instances = 0
 };
 
 static u32 get_accel_mask(struct adf_hw_device_data *self)
diff --git a/drivers/crypto/intel/qat/qat_c62x/adf_c62x_hw_data.c b/drivers/crypto/intel/qat/qat_c62x/adf_c62x_hw_data.c
index 32ebe09477a8..1a2f36b603fb 100644
--- a/drivers/crypto/intel/qat/qat_c62x/adf_c62x_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_c62x/adf_c62x_hw_data.c
@@ -22,7 +22,6 @@ static const u32 thrd_to_arb_map[ADF_C62X_MAX_ACCELENGINES] = {
 static struct adf_hw_device_class c62x_class = {
 	.name = ADF_C62X_DEVICE_NAME,
 	.type = DEV_C62X,
-	.instances = 0
 };
 
 static u32 get_accel_mask(struct adf_hw_device_data *self)
diff --git a/drivers/crypto/intel/qat/qat_c62xvf/adf_c62xvf_hw_data.c b/drivers/crypto/intel/qat/qat_c62xvf/adf_c62xvf_hw_data.c
index 4aaaaf921734..29e53b41a895 100644
--- a/drivers/crypto/intel/qat/qat_c62xvf/adf_c62xvf_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_c62xvf/adf_c62xvf_hw_data.c
@@ -13,7 +13,6 @@
 static struct adf_hw_device_class c62xiov_class = {
 	.name = ADF_C62XVF_DEVICE_NAME,
 	.type = DEV_C62XVF,
-	.instances = 0
 };
 
 static u32 get_accel_mask(struct adf_hw_device_data *self)
diff --git a/drivers/crypto/intel/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c b/drivers/crypto/intel/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
index e48bcf1818cd..bf9e8f34f451 100644
--- a/drivers/crypto/intel/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
@@ -24,7 +24,6 @@ static const u32 thrd_to_arb_map[ADF_DH895XCC_MAX_ACCELENGINES] = {
 static struct adf_hw_device_class dh895xcc_class = {
 	.name = ADF_DH895XCC_DEVICE_NAME,
 	.type = DEV_DH895XCC,
-	.instances = 0
 };
 
 static u32 get_accel_mask(struct adf_hw_device_data *self)
diff --git a/drivers/crypto/intel/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c b/drivers/crypto/intel/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c
index f4ee4c2e00da..bc59c1473eef 100644
--- a/drivers/crypto/intel/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c
@@ -13,7 +13,6 @@
 static struct adf_hw_device_class dh895xcciov_class = {
 	.name = ADF_DH895XCCVF_DEVICE_NAME,
 	.type = DEV_DH895XCCVF,
-	.instances = 0
 };
 
 static u32 get_accel_mask(struct adf_hw_device_data *self)

base-commit: b5e7a3efc641f681c2d611d4c5c582f3e5871b22
-- 
2.48.1

