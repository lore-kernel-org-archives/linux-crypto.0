Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 434F8558B6;
	Mon, 10 Jun 2024 08:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718007542; cv=none; b=u2TYudjW7bnEX1DFzBvWRG/pdaN6xJwqGHjyqpVNmn3ACOhPKmHKI0OnAfo1p3c+jYb38wbq+jfvhu+5vUAyOzFJoEhoQk068p1VG17oU9QP04q5jpIMuUMM7y5Ck23U4NX5Ri2yZEPjb85DKSi+T745lN+LLv2/iWnX3FU6104=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718007542; c=relaxed/simple;
	bh=kgqY93lTGjd/rFRkPgpwnmsYm+8zkWQeLQ6sBmfQibM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bXyu6aPyRS3zKBrs5DWsWNw79P270ZbHQpEIurfxdO+TgntRpMh/aMf0XiW3AwSh7QbHiTpHO4o8MZ5z0yVWDbRbe0aTtLvYeUUcTB6SF7xoUXrt22vTnsMGGXqSXth8/rUnee+G7sWOdeABJvECYQxq6vZVdKWg6QmQgeQ6BTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0gVItKzW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0gVItKzW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D005C2BBFC;
	Mon, 10 Jun 2024 08:19:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718007542;
	bh=kgqY93lTGjd/rFRkPgpwnmsYm+8zkWQeLQ6sBmfQibM=;
	h=From:To:Cc:Subject:Date:From;
	b=0gVItKzWG86UPiA6HNFgzbSPOaGcN4S123TKGVomBgxpjUOwmwV/lVDDlhpwtbu/b
	 ViCq5Mk13W141I01Sp/9J8OCFWX8mxazWkXnN1DIxGpNW4zBCRLRdxMwPOKxE5TqwI
	 asGxfomliADhEdmAzBC5DOT9BbYpu041nufpU+WQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: herbert@gondor.apana.org.au
Cc: linux-kernel@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Adam Guerin <adam.guerin@intel.com>,
	Benjamin Tissoires <benjamin.tissoires@redhat.com>,
	Tom Zanussi <tom.zanussi@linux.intel.com>,
	Shashank Gupta <shashank.gupta@intel.com>,
	qat-linux@intel.com,
	linux-crypto@vger.kernel.org
Subject: [PATCH] crypto: qat: make adf_ctl_class constant
Date: Mon, 10 Jun 2024 10:18:51 +0200
Message-ID: <2024061050-scale-presume-f311@gregkh>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3047; i=gregkh@linuxfoundation.org; h=from:subject:message-id; bh=kgqY93lTGjd/rFRkPgpwnmsYm+8zkWQeLQ6sBmfQibM=; b=owGbwMvMwCRo6H6F97bub03G02pJDGlp2165Tz9wg9niwryvpo+D5TrfP/WdozPjbVzV88kvf BacOvSmtiOWhUGQiUFWTJHlyzaeo/srDil6GdqehpnDygQyhIGLUwAmknuMYUGHk3Sgq88L1YOT TuswaIc/klOZZsWw4Ah7Y/a/R1dUW7r31h/X+vhRIzTzIAA=
X-Developer-Key: i=gregkh@linuxfoundation.org; a=openpgp; fpr=F4B60CC5BF78C2214A313DCB3147D40DDB2DFB29
Content-Transfer-Encoding: 8bit

Now that the driver core allows for struct class to be in read-only
memory, we should make all 'class' structures declared at build time
placing them into read-only memory, instead of having to be dynamically
allocated at runtime.

Cc: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Adam Guerin <adam.guerin@intel.com>
Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: Tom Zanussi <tom.zanussi@linux.intel.com>
Cc: Shashank Gupta <shashank.gupta@intel.com>
Cc: qat-linux@intel.com
Cc: linux-crypto@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 .../crypto/intel/qat/qat_common/adf_ctl_drv.c | 21 +++++++++++--------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_ctl_drv.c b/drivers/crypto/intel/qat/qat_common/adf_ctl_drv.c
index 29c4422f243c..26a1662fafbb 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_ctl_drv.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_ctl_drv.c
@@ -31,19 +31,22 @@ static const struct file_operations adf_ctl_ops = {
 	.compat_ioctl = compat_ptr_ioctl,
 };
 
+static const struct class adf_ctl_class = {
+	.name = DEVICE_NAME,
+};
+
 struct adf_ctl_drv_info {
 	unsigned int major;
 	struct cdev drv_cdev;
-	struct class *drv_class;
 };
 
 static struct adf_ctl_drv_info adf_ctl_drv;
 
 static void adf_chr_drv_destroy(void)
 {
-	device_destroy(adf_ctl_drv.drv_class, MKDEV(adf_ctl_drv.major, 0));
+	device_destroy(&adf_ctl_class, MKDEV(adf_ctl_drv.major, 0));
 	cdev_del(&adf_ctl_drv.drv_cdev);
-	class_destroy(adf_ctl_drv.drv_class);
+	class_unregister(&adf_ctl_class);
 	unregister_chrdev_region(MKDEV(adf_ctl_drv.major, 0), 1);
 }
 
@@ -51,17 +54,17 @@ static int adf_chr_drv_create(void)
 {
 	dev_t dev_id;
 	struct device *drv_device;
+	int ret;
 
 	if (alloc_chrdev_region(&dev_id, 0, 1, DEVICE_NAME)) {
 		pr_err("QAT: unable to allocate chrdev region\n");
 		return -EFAULT;
 	}
 
-	adf_ctl_drv.drv_class = class_create(DEVICE_NAME);
-	if (IS_ERR(adf_ctl_drv.drv_class)) {
-		pr_err("QAT: class_create failed for adf_ctl\n");
+	ret = class_register(&adf_ctl_class);
+	if (ret)
 		goto err_chrdev_unreg;
-	}
+
 	adf_ctl_drv.major = MAJOR(dev_id);
 	cdev_init(&adf_ctl_drv.drv_cdev, &adf_ctl_ops);
 	if (cdev_add(&adf_ctl_drv.drv_cdev, dev_id, 1)) {
@@ -69,7 +72,7 @@ static int adf_chr_drv_create(void)
 		goto err_class_destr;
 	}
 
-	drv_device = device_create(adf_ctl_drv.drv_class, NULL,
+	drv_device = device_create(&adf_ctl_class, NULL,
 				   MKDEV(adf_ctl_drv.major, 0),
 				   NULL, DEVICE_NAME);
 	if (IS_ERR(drv_device)) {
@@ -80,7 +83,7 @@ static int adf_chr_drv_create(void)
 err_cdev_del:
 	cdev_del(&adf_ctl_drv.drv_cdev);
 err_class_destr:
-	class_destroy(adf_ctl_drv.drv_class);
+	class_unregister(&adf_ctl_class);
 err_chrdev_unreg:
 	unregister_chrdev_region(dev_id, 1);
 	return -EFAULT;
-- 
2.45.2

