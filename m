Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C6C7313E31
	for <linux-crypto@vger.kernel.org>; Fri, 27 Feb 2026 11:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772193258; cv=none; b=Vj/kP6HAI1CM9ptNjsaBIoRcPz2anC1f5yrnqnYTPQbTZghUfxJa4WvyHPa5Nsc6VrT68tyruRcdd0sVRoLPs2Uab08RrBgsboo43s8oZNDkZv6wW0U7sR401RCcxajnun6pXujz6FdSOPS+hC3LTSdFVhZFj3v4jbAM4kZMOw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772193258; c=relaxed/simple;
	bh=y/PDTjQXRUzo4W88pPZi5N/QJim3WitIzdW3T2iaeCM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Tgi22T/DtLvLNswwxrbp41ZBDUl15hH11VhJvdDDDU22sTec8YCNgUVrljEae22eP/9aUyELo+PjbAL0XroM9EvAktkpihB+NYm6w5/cm4rxW+VyTDzgewRNTEA5HLwlP2Sndz34CuOvIi4GJFc0/ZhpCZNjQCLk7d/t8dv97/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=mxOcOb0M; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="mxOcOb0M"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772193254;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=uNepdi4YzAZmv+UJthxEnt8C0jRt1QzuKFhCKeWy+pI=;
	b=mxOcOb0MHtEi+RTK2A+8dxLVIG/iyymWbiASGxnqB5v6DKwBeodHKXx7SSIo+C/rNys6w/
	cy5+EelcRQA+fAzKlO1i5TPxvf17vXUJdZiuR/8Jw9VKk/sKjIzIKYIRXPOb+3LBgfe8yZ
	s3bmSE0Z2hv8kxLAtpYDz+teymGGvTk=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	qat-linux@intel.com,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: qat - Drop redundant local variables
Date: Fri, 27 Feb 2026 12:53:56 +0100
Message-ID: <20260227115359.804976-1-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Return sysfs_emit() directly and drop 'ret' in cap_rem_show().

In cap_rem_store(), use 'ret' when calling set_param_u() instead of
assigning it to 'val' first, and remove 'val'.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/crypto/intel/qat/qat_common/adf_sysfs_rl.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_sysfs_rl.c b/drivers/crypto/intel/qat/qat_common/adf_sysfs_rl.c
index f31556beed8b..89bfd8761d75 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_sysfs_rl.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_sysfs_rl.c
@@ -321,7 +321,7 @@ static ssize_t cap_rem_show(struct device *dev, struct device_attribute *attr,
 {
 	struct adf_rl_interface_data *data;
 	struct adf_accel_dev *accel_dev;
-	int ret, rem_cap;
+	int rem_cap;
 
 	accel_dev = adf_devmgr_pci_to_accel_dev(to_pci_dev(dev));
 	if (!accel_dev)
@@ -336,23 +336,19 @@ static ssize_t cap_rem_show(struct device *dev, struct device_attribute *attr,
 	if (rem_cap < 0)
 		return rem_cap;
 
-	ret = sysfs_emit(buf, "%u\n", rem_cap);
-
-	return ret;
+	return sysfs_emit(buf, "%u\n", rem_cap);
 }
 
 static ssize_t cap_rem_store(struct device *dev, struct device_attribute *attr,
 			     const char *buf, size_t count)
 {
-	unsigned int val;
 	int ret;
 
 	ret = sysfs_match_string(rl_services, buf);
 	if (ret < 0)
 		return ret;
 
-	val = ret;
-	ret = set_param_u(dev, CAP_REM_SRV, val);
+	ret = set_param_u(dev, CAP_REM_SRV, ret);
 	if (ret)
 		return ret;
 
-- 
Thorsten Blum <thorsten.blum@linux.dev>
GPG: 1D60 735E 8AEF 3BE4 73B6  9D84 7336 78FD 8DFE EAD4

