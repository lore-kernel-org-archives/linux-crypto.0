Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06B333126B8
	for <linux-crypto@vger.kernel.org>; Mon, 15 Dec 2025 07:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765783487; cv=none; b=sAe2zMCn2qicbasXJpY2MhrZfShsqTMzVICu0Zsm83ENPdDo8v1Koe3QivbDTRcUtq+p11ubB9p6m6QiVIhQzF0lmsr/ru+GvvN0xymZSuwOKJ0T4zcRI57YNIWTwaHkuxX6d38VdV639M9auat3QZWnU5XGIgmPAHGI6g1EiJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765783487; c=relaxed/simple;
	bh=i4Y1T6zZD+TdLCWmH2zDBJfnBv3TuSmi0uvUZKSKJ2w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dQgVH2VuUpq5LSu8ZPahtz1fyauK5RDhYs99fS7Vg9naQeBxYse2/gtuaXJAqVKQ1Uztmf84Y65dEx6bHa2XxpC/2f3++HDKm2gTGSH+ovnsEGcUZOeYgDbDM8dfJfeZvXEqlBJTL9UY61RzoKWoc39SW371uQEIVGpqI8zhs9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xJEfS+Wl; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xJEfS+Wl"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765783482;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=guR/0S+W58rjVmEAkOZwh0wmdwAO5CE7xFnWbm3IZXw=;
	b=xJEfS+WlP3GdSS3aD04bfb3/OOV9qaaBLfEY3c67NibAxmvGkkQuZlvx8x6LfR0NNhr9vd
	9GQbXMwDdCmNDYNiDVZT4OQMO+BvmIOFRVznu03a0hNWBNau8lLOwBwP/2/ehgHRFrCu6E
	DtOeFA3L3/3twIJHglPW1Jl9FdI03IA=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Kristen Accardi <kristen.c.accardi@intel.com>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Kanchana P Sridhar <kanchana.p.sridhar@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: iaa - Replace sprintf with sysfs_emit in sysfs show functions
Date: Mon, 15 Dec 2025 08:23:52 +0100
Message-ID: <20251215072351.279432-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Replace sprintf() with sysfs_emit() in verify_compress_show() and
sync_mode_show(). sysfs_emit() is preferred to format sysfs output as it
provides better bounds checking.  No functional changes.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/crypto/intel/iaa/iaa_crypto_main.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/intel/iaa/iaa_crypto_main.c
index d0058757b000..9e2a17c473ef 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -5,6 +5,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/pci.h>
+#include <linux/sysfs.h>
 #include <linux/device.h>
 #include <linux/iommu.h>
 #include <uapi/linux/idxd.h>
@@ -96,7 +97,7 @@ static bool iaa_verify_compress = true;
 
 static ssize_t verify_compress_show(struct device_driver *driver, char *buf)
 {
-	return sprintf(buf, "%d\n", iaa_verify_compress);
+	return sysfs_emit(buf, "%d\n", iaa_verify_compress);
 }
 
 static ssize_t verify_compress_store(struct device_driver *driver,
@@ -188,11 +189,11 @@ static ssize_t sync_mode_show(struct device_driver *driver, char *buf)
 	int ret = 0;
 
 	if (!async_mode && !use_irq)
-		ret = sprintf(buf, "%s\n", "sync");
+		ret = sysfs_emit(buf, "%s\n", "sync");
 	else if (async_mode && !use_irq)
-		ret = sprintf(buf, "%s\n", "async");
+		ret = sysfs_emit(buf, "%s\n", "async");
 	else if (async_mode && use_irq)
-		ret = sprintf(buf, "%s\n", "async_irq");
+		ret = sysfs_emit(buf, "%s\n", "async_irq");
 
 	return ret;
 }
-- 
Thorsten Blum <thorsten.blum@linux.dev>
GPG: 1D60 735E 8AEF 3BE4 73B6  9D84 7336 78FD 8DFE EAD4

