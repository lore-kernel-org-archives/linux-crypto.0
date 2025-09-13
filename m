Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BB211F4701
	for <linux-crypto@vger.kernel.org>; Sat, 13 Sep 2025 04:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757737503; cv=none; b=DOsTwJsGkIDP4oBjWsG2UrL+P1O5I1hh9p/VKpXDae0PvsB2FkKWDDndqkPtxxMaOR/2OK2C1/u32HGx35Eo6Qdk2wmssr3j5vnzva5peUv47xW+Mvvnpw9xsNcpI+NGf7BToEStAc4NtAF+EWpVo58fIEwS+bbpF39jGzbIfYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757737503; c=relaxed/simple;
	bh=O3gAivGeELSipxShjKUvGHWrS2mP05HflEnbkC8G91s=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=vFh3ggwuru42FmPgj8vaccG703wXXUSN4j/3QokR4zrX94vEETOO/rhtmc4PudJ+aXahC+Fddrx+RGZBwMdWew4yI53woiksFzf1xIM9rcsOT2Gwrh/MNmOyuTIo/NLHh/Tuptt81NKmwZEU8TZH4nWCes1iUxoURQFV3+PzoKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=EuAxvOeE; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="EuAxvOeE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=JWit4UCs7OlDJkoagkOZNq1fAuOCsJGOUPvcebn1h0A=; b=EuAxvOeEYP0cxhd+KDQdseVCl9
	TE/ZbnrgxdkPVFfPhGLvzinG5M0OhKWnLePoltyRqqrJ4y8ss+1wVRvDQHyilDfkmSJ4CTLD2eBFG
	kt+zDzoD3voKFHSSGBcE9nL/bEANU2haAgo9IjYACs55T2919581C5IRMhWH5Yjs2fU3plB3jy9BU
	ncwf6Y4ygZHnFPxfjvmE5ReXqrgzmPKkBUEuXVOAGWhwd75C/i9Ytp9OE4FOiU66LYyswRIHpnuIu
	RIjn59bX1lChhJ+gg1RDWC7eWdM0qYSceI7HarQB8WgouPHPgEjqTWHHQjLQ2TlXMtzIocP6WjgxZ
	f3WS5cog==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uxHZL-0053nC-0H;
	Sat, 13 Sep 2025 12:24:56 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 13 Sep 2025 12:24:55 +0800
Date: Sat, 13 Sep 2025 12:24:55 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Thorsten Blum <thorsten.blum@linux.dev>
Cc: Giovanni Cabiddu <giovanni.cabiddu@intel.com>, qat-linux@intel.com
Subject: [PATCH] crypto: qat - Return pointer directly in
 adf_ctl_alloc_resources
Message-ID: <aMTyFx91lhp9galJ@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Returning values through arguments is confusing and that has
upset the compiler with the recent change to memdup_user:

../drivers/crypto/intel/qat/qat_common/adf_ctl_drv.c: In function ‘adf_ctl_ioctl’:
../drivers/crypto/intel/qat/qat_common/adf_ctl_drv.c:308:26: warning: ‘ctl_data’ may be used uninitialized [-Wmaybe-uninitialized]
  308 |                  ctl_data->device_id);
      |                          ^~
../drivers/crypto/intel/qat/qat_common/adf_ctl_drv.c:294:39: note: ‘ctl_data’ was declared here
  294 |         struct adf_user_cfg_ctl_data *ctl_data;
      |                                       ^~~~~~~~
In function ‘adf_ctl_ioctl_dev_stop’,
    inlined from ‘adf_ctl_ioctl’ at ../drivers/crypto/intel/qat/qat_common/adf_ctl_drv.c:386:9:
../drivers/crypto/intel/qat/qat_common/adf_ctl_drv.c:273:48: warning: ‘ctl_data’ may be used uninitialized [-Wmaybe-uninitialized]
  273 |         ret = adf_ctl_is_device_in_use(ctl_data->device_id);
      |                                        ~~~~~~~~^~~~~~~~~~~
../drivers/crypto/intel/qat/qat_common/adf_ctl_drv.c: In function ‘adf_ctl_ioctl’:
../drivers/crypto/intel/qat/qat_common/adf_ctl_drv.c:261:39: note: ‘ctl_data’ was declared here
  261 |         struct adf_user_cfg_ctl_data *ctl_data;
      |                                       ^~~~~~~~
In function ‘adf_ctl_ioctl_dev_config’,
    inlined from ‘adf_ctl_ioctl’ at ../drivers/crypto/intel/qat/qat_common/adf_ctl_drv.c:382:9:
../drivers/crypto/intel/qat/qat_common/adf_ctl_drv.c:192:54: warning: ‘ctl_data’ may be used uninitialized [-Wmaybe-uninitialized]
  192 |         accel_dev = adf_devmgr_get_dev_by_id(ctl_data->device_id);
      |                                              ~~~~~~~~^~~~~~~~~~~
../drivers/crypto/intel/qat/qat_common/adf_ctl_drv.c: In function ‘adf_ctl_ioctl’:
../drivers/crypto/intel/qat/qat_common/adf_ctl_drv.c:185:39: note: ‘ctl_data’ was declared here
  185 |         struct adf_user_cfg_ctl_data *ctl_data;
      |                                       ^~~~~~~~

Fix this by returning the pointer directly.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/intel/qat/qat_common/adf_ctl_drv.c b/drivers/crypto/intel/qat/qat_common/adf_ctl_drv.c
index 84bc89e16742..c2e6f0cb7480 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_ctl_drv.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_ctl_drv.c
@@ -89,19 +89,14 @@ static int adf_chr_drv_create(void)
 	return -EFAULT;
 }
 
-static int adf_ctl_alloc_resources(struct adf_user_cfg_ctl_data **ctl_data,
-				   unsigned long arg)
+static struct adf_user_cfg_ctl_data *adf_ctl_alloc_resources(unsigned long arg)
 {
 	struct adf_user_cfg_ctl_data *cfg_data;
 
 	cfg_data = memdup_user((void __user *)arg, sizeof(*cfg_data));
-	if (IS_ERR(cfg_data)) {
+	if (IS_ERR(cfg_data))
 		pr_err("QAT: failed to copy from user cfg_data.\n");
-		return PTR_ERR(cfg_data);
-	}
-
-	*ctl_data = cfg_data;
-	return 0;
+	return cfg_data;
 }
 
 static int adf_add_key_value_data(struct adf_accel_dev *accel_dev,
@@ -181,13 +176,13 @@ static int adf_copy_key_value_data(struct adf_accel_dev *accel_dev,
 static int adf_ctl_ioctl_dev_config(struct file *fp, unsigned int cmd,
 				    unsigned long arg)
 {
-	int ret;
 	struct adf_user_cfg_ctl_data *ctl_data;
 	struct adf_accel_dev *accel_dev;
+	int ret = 0;
 
-	ret = adf_ctl_alloc_resources(&ctl_data, arg);
-	if (ret)
-		return ret;
+	ctl_data = adf_ctl_alloc_resources(arg);
+	if (IS_ERR(ctl_data))
+		return PTR_ERR(ctl_data);
 
 	accel_dev = adf_devmgr_get_dev_by_id(ctl_data->device_id);
 	if (!accel_dev) {
@@ -260,9 +255,9 @@ static int adf_ctl_ioctl_dev_stop(struct file *fp, unsigned int cmd,
 	int ret;
 	struct adf_user_cfg_ctl_data *ctl_data;
 
-	ret = adf_ctl_alloc_resources(&ctl_data, arg);
-	if (ret)
-		return ret;
+	ctl_data = adf_ctl_alloc_resources(arg);
+	if (IS_ERR(ctl_data))
+		return PTR_ERR(ctl_data);
 
 	if (adf_devmgr_verify_id(ctl_data->device_id)) {
 		pr_err("QAT: Device %d not found\n", ctl_data->device_id);
@@ -294,9 +289,9 @@ static int adf_ctl_ioctl_dev_start(struct file *fp, unsigned int cmd,
 	struct adf_user_cfg_ctl_data *ctl_data;
 	struct adf_accel_dev *accel_dev;
 
-	ret = adf_ctl_alloc_resources(&ctl_data, arg);
-	if (ret)
-		return ret;
+	ctl_data = adf_ctl_alloc_resources(arg);
+	if (IS_ERR(ctl_data))
+		return PTR_ERR(ctl_data);
 
 	ret = -ENODEV;
 	accel_dev = adf_devmgr_get_dev_by_id(ctl_data->device_id);
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
