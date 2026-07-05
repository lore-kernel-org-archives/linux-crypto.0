Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54FEF1F2BAD
	for <linux-crypto@vger.kernel.org>; Sun,  5 Jul 2026 13:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783258810; cv=none; b=VhUxZVz1apVeM5J/mkfMjx5+ssB4p0ECirqAuq93uwAl8aS/+ExTJr50z3tvaJQsgbaEMPxAeLBtrL9xpA6XK/TF79G65/HPTD4EY292B0qTOWpvjvhW7sLp5l5swwivY39a2j59b2pwtJWftyTnoqBxbNe8FRLJttiyyyvNGvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783258810; c=relaxed/simple;
	bh=/OZvJOvI1PL0D/wSWmrUH5T4ZRQ1U/XO++N6dh2H0ls=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HUkI4T1EIVDvhPnrbV7gMuwmUcxHGkDsvX2SLNaeSWmOqze+IeBEt2MCxClbeQlU7DdcPXcXwArvD1HP62LVYa9wByHbVhH237WHfMOvi1TLpRqpFet1qfN/Rix26f6LDXzYidnxvhSuOPOnnDjuZKl+1um/K2i1wdLsFLSt+zQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=PoUfvTtF; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="PoUfvTtF"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783258805;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Gx0b9X1DrIhwbxB4sLi/dxLiDIMLF/pnkQIt2rZZR0c=;
	b=PoUfvTtFt7JvmDWm5qfdBqF0YkdHMGabmL2gAL6VQSKtQN0e2rUhAPWr2h0IfZePqq2KNz
	JDyvVvM0bCHEavgXEzLXfl3Sk4YIzBJjI84WM08wMZD+9NQSQ6Si/3nMXLehBcS8icgL7m
	Vahr6jehQhxVFI2J0creqSQQOCkO6C8=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>,
	Thorsten Blum <thorsten.blum@linux.dev>
Cc: qat-linux@intel.com,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: qat - use strscpy_pad to simplify adf_service_string_to_mask
Date: Sun,  5 Jul 2026 15:38:39 +0200
Message-ID: <20260705133842.241401-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4507; i=thorsten.blum@linux.dev; h=from:subject; bh=/OZvJOvI1PL0D/wSWmrUH5T4ZRQ1U/XO++N6dh2H0ls=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFleccky6usmB66/9335nY5VKRE/9xT8SHb9Ff/vpNL3w E8pIaaBHaUsDGJcDLJiiiwPZv2Y4VtaU7nJJGInzBxWJpAhDFycAjCRN/6MDK+bz0QfmzDVbm4p o8vmnlb+hhN+VzJUV8h1On8UvabIeJjhr/SXB2eXaM+U2Rgr933Pl+Se+eJBssH3J3bsi3hynfW aNz8A
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Use strscpy_pad() to copy buf and zero-pad any trailing bytes instead of
zero-initializing the local services buffer and then using strscpy() to
copy into it. Also use the strscpy_pad() return value to detect string
truncation instead of checking the caller-provided length.

Remove the now-unused length parameters from
adf_service_string_to_mask() and adf_parse_service_string(). Also remove
the redundant strnlen() call in adf_get_service_mask(), which only
computed the removed length argument.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 .../intel/qat/qat_common/adf_cfg_services.c       | 15 ++++++---------
 .../intel/qat/qat_common/adf_cfg_services.h       |  2 +-
 drivers/crypto/intel/qat/qat_common/adf_sysfs.c   |  2 +-
 3 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_cfg_services.c b/drivers/crypto/intel/qat/qat_common/adf_cfg_services.c
index 7d00bcb41ce7..21b21ac78e53 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_cfg_services.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_cfg_services.c
@@ -49,18 +49,17 @@ static_assert(sizeof(ADF_CFG_SYM ADF_SERVICES_DELIMITER
 		     ADF_CFG_DCC) < ADF_CFG_MAX_VAL_LEN_IN_BYTES);
 
 static int adf_service_string_to_mask(struct adf_accel_dev *accel_dev, const char *buf,
-				      size_t len, unsigned long *out_mask)
+				      unsigned long *out_mask)
 {
 	struct adf_hw_device_data *hw_data = GET_HW_DATA(accel_dev);
-	char services[ADF_CFG_MAX_VAL_LEN_IN_BYTES] = { };
+	char services[ADF_CFG_MAX_VAL_LEN_IN_BYTES];
 	unsigned long mask = 0;
 	char *substr, *token;
 	int id, num_svc = 0;
 
-	if (len > ADF_CFG_MAX_VAL_LEN_IN_BYTES - 1)
+	if (strscpy_pad(services, buf) < 0)
 		return -EINVAL;
 
-	strscpy(services, buf);
 	substr = services;
 
 	while ((token = strsep(&substr, ADF_SERVICES_DELIMITER))) {
@@ -104,12 +103,12 @@ static int adf_service_mask_to_string(unsigned long mask, char *buf, size_t len)
 }
 
 int adf_parse_service_string(struct adf_accel_dev *accel_dev, const char *in,
-			     size_t in_len, char *out, size_t out_len)
+			     char *out, size_t out_len)
 {
 	unsigned long mask;
 	int ret;
 
-	ret = adf_service_string_to_mask(accel_dev, in, in_len, &mask);
+	ret = adf_service_string_to_mask(accel_dev, in, &mask);
 	if (ret)
 		return ret;
 
@@ -122,7 +121,6 @@ int adf_parse_service_string(struct adf_accel_dev *accel_dev, const char *in,
 int adf_get_service_mask(struct adf_accel_dev *accel_dev, unsigned long *mask)
 {
 	char services[ADF_CFG_MAX_VAL_LEN_IN_BYTES] = { };
-	size_t len;
 	int ret;
 
 	ret = adf_cfg_get_param_value(accel_dev, ADF_GENERAL_SEC,
@@ -133,8 +131,7 @@ int adf_get_service_mask(struct adf_accel_dev *accel_dev, unsigned long *mask)
 		return ret;
 	}
 
-	len = strnlen(services, ADF_CFG_MAX_VAL_LEN_IN_BYTES);
-	ret = adf_service_string_to_mask(accel_dev, services, len, mask);
+	ret = adf_service_string_to_mask(accel_dev, services, mask);
 	if (ret)
 		dev_err(&GET_DEV(accel_dev), "Invalid value of %s param: %s\n",
 			ADF_SERVICES_ENABLED, services);
diff --git a/drivers/crypto/intel/qat/qat_common/adf_cfg_services.h b/drivers/crypto/intel/qat/qat_common/adf_cfg_services.h
index 913d717280af..89be2f2c7233 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_cfg_services.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_cfg_services.h
@@ -35,7 +35,7 @@ enum {
 #define MAX_NUM_CONCURR_SVC	ADF_THREE_SERVICES
 
 int adf_parse_service_string(struct adf_accel_dev *accel_dev, const char *in,
-			     size_t in_len, char *out, size_t out_len);
+			     char *out, size_t out_len);
 int adf_get_service_enabled(struct adf_accel_dev *accel_dev);
 int adf_get_service_mask(struct adf_accel_dev *accel_dev, unsigned long *mask);
 enum adf_cfg_service_type adf_srv_to_cfg_svc_type(enum adf_base_services svc);
diff --git a/drivers/crypto/intel/qat/qat_common/adf_sysfs.c b/drivers/crypto/intel/qat/qat_common/adf_sysfs.c
index 79c63dfa8ff3..8daa69a76b01 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_sysfs.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_sysfs.c
@@ -125,7 +125,7 @@ static ssize_t cfg_services_store(struct device *dev, struct device_attribute *a
 	if (!accel_dev)
 		return -EINVAL;
 
-	ret = adf_parse_service_string(accel_dev, buf, count, services,
+	ret = adf_parse_service_string(accel_dev, buf, services,
 				       ADF_CFG_MAX_VAL_LEN_IN_BYTES);
 	if (ret)
 		return ret;
