Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CD9523373A;
	Mon, 17 Mar 2025 10:13:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742206436; cv=none; b=bsk0lVOQg0TrkqxOpQud96x5zM15Hq1beCE8P5vfS6RYOj+UgE1+11SZGp8CKcn3+lpyiK7WLWSzDd0qhQUb9PdfyrwLYTp8fxrDpQhxxXG5H7KtgblLCY1G3z54vKcTE/qUy218c5Vn7JftlejbV8zMaqtMniWxIC1Pdc/xqyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742206436; c=relaxed/simple;
	bh=W3iR8KyjlR4HJ4ebZ4zdbJscuXyuwHmntWmxKR0MThg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=S3sAr1xmuHAMfekH9CvWg4DyfWNtJ2vtu3s8TPy4dkugMcvPc5srQs0hJJLqtIeohZat+y99SDKlz8ISk0GLcFtAbcOG7Mzwuy1vw5AnBNxyBRB4mTado3m61cdRHeVgqyUJwWaFdkL1GY9AvFi/GYeMpKf6D53s72nCf9YuhSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8C9BD2573;
	Mon, 17 Mar 2025 03:14:03 -0700 (PDT)
Received: from e133711.arm.com (e133711.arm.com [10.1.196.55])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 74D523F673;
	Mon, 17 Mar 2025 03:13:53 -0700 (PDT)
From: Sudeep Holla <sudeep.holla@arm.com>
Date: Mon, 17 Mar 2025 10:13:14 +0000
Subject: [PATCH 2/9] hwrng: arm-smccc-trng - transition to the faux device
 interface
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250317-plat2faux_dev-v1-2-5fe67c085ad5@arm.com>
References: <20250317-plat2faux_dev-v1-0-5fe67c085ad5@arm.com>
In-Reply-To: <20250317-plat2faux_dev-v1-0-5fe67c085ad5@arm.com>
To: linux-kernel@vger.kernel.org
Cc: Sudeep Holla <sudeep.holla@arm.com>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Andre Przywara <andre.przywara@arm.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 Jeff Johnson <jeff.johnson@oss.qualcomm.com>, linux-crypto@vger.kernel.org
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=4989; i=sudeep.holla@arm.com;
 h=from:subject:message-id; bh=W3iR8KyjlR4HJ4ebZ4zdbJscuXyuwHmntWmxKR0MThg=;
 b=owEBbQKS/ZANAwAIAQBBurwxfuKYAcsmYgBn1/XbzQBCOprmjqQXP8AvPYDsVkXXAwu4hW/9j
 bUHAw5iPGuJAjMEAAEIAB0WIQS6ceUSBvMeskPdk+EAQbq8MX7imAUCZ9f12wAKCRAAQbq8MX7i
 mOK4D/wJDZIpz0HVPixe2YLXS2h4mgkw4nAlBTPrkjzL+jBjHJiYBuFHBMlGheXq0rOX545pDnW
 IK63VTS+lLKoFEnWeAYG4/ue0Ypu5BULhIRnD1t2P3qOaAFcm05eh3QWzmNkM0t0vzYNAhfANKz
 g6vrHf4KCdIEcmMzxqzbEn5zUGIpJ2RR0sO5xQG3DsYq79gcvajCqrgMfy4AkFVO4G9BldljaHB
 R6piMew3fE87FLqerinW/5iWJe/9c1S04eO2p9t+6BmTQ0HoH/fEfWMdY1oGP9yB1/EfkH2nNVc
 xqoPfRu432JGKioPfMyt21cdZgfjjvngphIK9Weh4RUQK18D5P/Qvi+z6bBoKMwYQ0aN5t6/XDc
 rPAu64977zZJDa3rkonMe9TS+8PKTOlbTRn4ZFfwkQ0U67nL8vskuTENquUiE+H4Yf7ZItLEspF
 rvjwVoLNhGk+bOpeqMFkCeGUxCRXDNg7wTULBW3fs9ndhhYqONM0ia5hlYumONjgyHY0tTTond3
 D1Iz29F/jVugpAgZlEEttvSK/K/p6jBSpCEVtJd4HzjktnZs1bP28wYpuGLhLKdDxkZKOLjKi0G
 OtiQ5wJ2tY7FbgQaWvhe2AeE2YBG4pCvdf1ND9rr3lbZ8QFAhNULN2n820Hl9cTSPTTBAGF5nZI
 TxonQGwQvcTMSYw==
X-Developer-Key: i=sudeep.holla@arm.com; a=openpgp;
 fpr=7360A21742ADF5A11767C1C139CFD4755FE2D5B4

The Arm SMCCC based true random number generator driver does not require
the creation of a platform device/driver. Originally, this approach was
chosen for simplicity when the driver was first implemented.

With the introduction of the lightweight faux device interface, we now
have a more appropriate alternative. Migrate the driver to utilize the
faux bus, given that the platform device it previously created was not
a real one anyway. This will simplify the code, reducing its footprint
while maintaining functionality.

Cc: Andre Przywara <andre.przywara@arm.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Cc: linux-crypto@vger.kernel.org
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
---
 drivers/char/hw_random/arm_smccc_trng.c | 40 ++++++++++++++++++++++++---------
 drivers/firmware/smccc/smccc.c          | 21 -----------------
 2 files changed, 29 insertions(+), 32 deletions(-)

diff --git a/drivers/char/hw_random/arm_smccc_trng.c b/drivers/char/hw_random/arm_smccc_trng.c
index dcb8e7f37f25c6b39f76050369b9f324b7fb2e33..2ceab17f6360baaee999a23f3d7370b7b5b7d246 100644
--- a/drivers/char/hw_random/arm_smccc_trng.c
+++ b/drivers/char/hw_random/arm_smccc_trng.c
@@ -16,9 +16,11 @@
 #include <linux/device.h>
 #include <linux/hw_random.h>
 #include <linux/module.h>
-#include <linux/platform_device.h>
+#include <linux/device/faux.h>
 #include <linux/arm-smccc.h>
 
+#include <asm/archrandom.h>
+
 #ifdef CONFIG_ARM64
 #define ARM_SMCCC_TRNG_RND	ARM_SMCCC_TRNG_RND64
 #define MAX_BITS_PER_CALL	(3 * 64UL)
@@ -33,6 +35,8 @@
 #define SMCCC_RET_TRNG_INVALID_PARAMETER	-2
 #define SMCCC_RET_TRNG_NO_ENTROPY		-3
 
+bool __ro_after_init smccc_trng_available;
+
 static int copy_from_registers(char *buf, struct arm_smccc_res *res,
 			       size_t bytes)
 {
@@ -94,29 +98,43 @@ static int smccc_trng_read(struct hwrng *rng, void *data, size_t max, bool wait)
 	return copied;
 }
 
-static int smccc_trng_probe(struct platform_device *pdev)
+static int smccc_trng_probe(struct faux_device *fdev)
 {
 	struct hwrng *trng;
 
-	trng = devm_kzalloc(&pdev->dev, sizeof(*trng), GFP_KERNEL);
+	trng = devm_kzalloc(&fdev->dev, sizeof(*trng), GFP_KERNEL);
 	if (!trng)
 		return -ENOMEM;
 
 	trng->name = "smccc_trng";
 	trng->read = smccc_trng_read;
 
-	return devm_hwrng_register(&pdev->dev, trng);
+	return devm_hwrng_register(&fdev->dev, trng);
 }
 
-static struct platform_driver smccc_trng_driver = {
-	.driver = {
-		.name		= "smccc_trng",
-	},
-	.probe		= smccc_trng_probe,
+static struct faux_device_ops smccc_trng_ops = {
+	.probe = smccc_trng_probe,
 };
-module_platform_driver(smccc_trng_driver);
 
-MODULE_ALIAS("platform:smccc_trng");
+static int __init smccc_trng_init(void)
+{
+	struct faux_device *fdev;
+
+	smccc_trng_available = smccc_probe_trng();
+	if (!smccc_trng_available)
+		return 0;
+
+	fdev = faux_device_create("smccc_trng", NULL, &smccc_trng_ops);
+	if (!fdev) {
+		pr_err("smccc_trng: could not create the device\n");
+		return -ENODEV;
+	}
+
+	return 0;
+}
+device_initcall(smccc_trng_init);
+
+MODULE_ALIAS("faux:smccc_trng");
 MODULE_AUTHOR("Andre Przywara");
 MODULE_DESCRIPTION("Arm SMCCC TRNG firmware interface support");
 MODULE_LICENSE("GPL");
diff --git a/drivers/firmware/smccc/smccc.c b/drivers/firmware/smccc/smccc.c
index a74600d9f2d72a5aa0096004f53088c255927a43..0fcd175a53eeaa957d06071b3b26f4c3a3c7116e 100644
--- a/drivers/firmware/smccc/smccc.c
+++ b/drivers/firmware/smccc/smccc.c
@@ -9,13 +9,10 @@
 #include <linux/init.h>
 #include <linux/arm-smccc.h>
 #include <linux/kernel.h>
-#include <linux/platform_device.h>
-#include <asm/archrandom.h>
 
 static u32 smccc_version = ARM_SMCCC_VERSION_1_0;
 static enum arm_smccc_conduit smccc_conduit = SMCCC_CONDUIT_NONE;
 
-bool __ro_after_init smccc_trng_available = false;
 s32 __ro_after_init smccc_soc_id_version = SMCCC_RET_NOT_SUPPORTED;
 s32 __ro_after_init smccc_soc_id_revision = SMCCC_RET_NOT_SUPPORTED;
 
@@ -26,8 +23,6 @@ void __init arm_smccc_version_init(u32 version, enum arm_smccc_conduit conduit)
 	smccc_version = version;
 	smccc_conduit = conduit;
 
-	smccc_trng_available = smccc_probe_trng();
-
 	if ((smccc_version >= ARM_SMCCC_VERSION_1_2) &&
 	    (smccc_conduit != SMCCC_CONDUIT_NONE)) {
 		arm_smccc_1_1_invoke(ARM_SMCCC_ARCH_FEATURES_FUNC_ID,
@@ -66,19 +61,3 @@ s32 arm_smccc_get_soc_id_revision(void)
 	return smccc_soc_id_revision;
 }
 EXPORT_SYMBOL_GPL(arm_smccc_get_soc_id_revision);
-
-static int __init smccc_devices_init(void)
-{
-	struct platform_device *pdev;
-
-	if (smccc_trng_available) {
-		pdev = platform_device_register_simple("smccc_trng", -1,
-						       NULL, 0);
-		if (IS_ERR(pdev))
-			pr_err("smccc_trng: could not register device: %ld\n",
-			       PTR_ERR(pdev));
-	}
-
-	return 0;
-}
-device_initcall(smccc_devices_init);

-- 
2.34.1

