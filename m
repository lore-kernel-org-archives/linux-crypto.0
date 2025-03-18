Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC529211A3C;
	Tue, 18 Mar 2025 17:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742317356; cv=none; b=U5BnfFH60WB6KO/HC9h4l+UtK01f5P/OCqCxljGKyMk6i67Z67cQ9VYnYJMJJStk8yJPf7GdUZ+cirDX9aK0/a+OzK1EE3P4jY0hCbwptnXKxgsBvSAQs9a2YoEyq39BAikIi5mV3Cit6eGeH0ELdyG5I7NcPCul6A6fMxpiMys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742317356; c=relaxed/simple;
	bh=ob85jxBOyOzqJOSx4lN4UtyjGcEY7Ygqfx6BmaDo+vY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=c9FQ8yNiwYobLSj20czvJYekm+3nymQcm4I6bvPvpa2I4kCXGMBR2CoTDOdiZu/xjALXkR6ofkXxe/Vqf8sf77v+0QvxEFtkOCSI1H6pSI2aenyiFSfr6LCdTGzT2+Z+wbtZIj8vOtqsEh5MwY8VAZ5is3M4LKRYhuQIHOIw+tk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B302F1A25;
	Tue, 18 Mar 2025 10:02:42 -0700 (PDT)
Received: from e133711.arm.com (e133711.arm.com [10.1.196.55])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1B0EB3F673;
	Tue, 18 Mar 2025 10:02:32 -0700 (PDT)
From: Sudeep Holla <sudeep.holla@arm.com>
Date: Tue, 18 Mar 2025 17:01:41 +0000
Subject: [PATCH v2 3/8] hwrng: arm-smccc-trng - transition to the faux
 device interface
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250318-plat2faux_dev-v2-3-e6cc73f78478@arm.com>
References: <20250318-plat2faux_dev-v2-0-e6cc73f78478@arm.com>
In-Reply-To: <20250318-plat2faux_dev-v2-0-e6cc73f78478@arm.com>
To: linux-kernel@vger.kernel.org
Cc: Sudeep Holla <sudeep.holla@arm.com>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Andre Przywara <andre.przywara@arm.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 Jeff Johnson <jeff.johnson@oss.qualcomm.com>, linux-crypto@vger.kernel.org
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=3652; i=sudeep.holla@arm.com;
 h=from:subject:message-id; bh=ob85jxBOyOzqJOSx4lN4UtyjGcEY7Ygqfx6BmaDo+vY=;
 b=owEBbQKS/ZANAwAIAQBBurwxfuKYAcsmYgBn2aciwZGAMleW3NcjgDCN5dHz2z6Vsk/HAPqNI
 A6SJbAiJ6iJAjMEAAEIAB0WIQS6ceUSBvMeskPdk+EAQbq8MX7imAUCZ9mnIgAKCRAAQbq8MX7i
 mLcwD/93elWVanJoCev4Qc0VH+TNl1c45MuHNW9+X7PzawOQgnfbkAbHOmFstIU5JPjBtNUo0Xg
 CZUUolNCJs0Ci1P0HQPHu7PRkV3pBs9T58EjtT09y+EtCB+Z/2koEpxU67uUu4ssqpi8CRseLUT
 YXHe1sUz4qLBy/ddnodUMXVRiz9LdWbZ10/ZkDZIvpXLeKZPmGVu3NTZSbNvidTR2zvYxZiZCJ/
 7PSHXl1FIvPHte9ag8Bc3vzwuaezGkSK1GfihqYk5gEKfxKdxrr3m2I+sC31mYDSBvqCQLL/Olp
 q9DUnDSv2+DU1eobec28QSeRVFhDY7pcFddOuqQP9xGHslBKcBhiA3z1FOBdaMNeZOKNaFK/J/O
 ZYEaNur9iEXyDSMD++JQPVtqlxTQXK2Ifkh/fIHIyyQ8cJI7RimJtIy1ajkFzDPpeLkCkkaEUib
 3Je8v3Y+BQERUQ7JeX1KiufNbQXeWRFsz31mkSyvFE1obFa+hLWkWqRwuc+lCDqvBJ637USxzUo
 Ok65Nyh/ibICmkDk+YKXcWYlS75aWTDdkfkRhaBhitCJnfUWiQn1ewriR509q5cjZuQHcz39dT9
 O45QwjdryMeSCkYdKKJ/GVj/eT2YSmhJdhE2Ep4YfhKd8WIDftVVjjrbbihxJ+KBltjVI1HaM1C
 OkFPgxDV/bO2G+A==
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
 drivers/char/hw_random/arm_smccc_trng.c | 19 +++++++------------
 drivers/firmware/smccc/smccc.c          | 17 -----------------
 2 files changed, 7 insertions(+), 29 deletions(-)

diff --git a/drivers/char/hw_random/arm_smccc_trng.c b/drivers/char/hw_random/arm_smccc_trng.c
index dcb8e7f37f25c6b39f76050369b9f324b7fb2e33..1c70e8bbea956c8e1f07a8083c33a8d011772c26 100644
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
@@ -94,29 +96,22 @@ static int smccc_trng_read(struct hwrng *rng, void *data, size_t max, bool wait)
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
-};
-module_platform_driver(smccc_trng_driver);
+module_faux_driver(smccc_trng, smccc_trng_probe, NULL, smccc_trng_available);
 
-MODULE_ALIAS("platform:smccc_trng");
 MODULE_AUTHOR("Andre Przywara");
 MODULE_DESCRIPTION("Arm SMCCC TRNG firmware interface support");
 MODULE_LICENSE("GPL");
diff --git a/drivers/firmware/smccc/smccc.c b/drivers/firmware/smccc/smccc.c
index a74600d9f2d72a5aa0096004f53088c255927a43..cc131894623eff95f906ebf08511c123add7fe88 100644
--- a/drivers/firmware/smccc/smccc.c
+++ b/drivers/firmware/smccc/smccc.c
@@ -9,7 +9,6 @@
 #include <linux/init.h>
 #include <linux/arm-smccc.h>
 #include <linux/kernel.h>
-#include <linux/platform_device.h>
 #include <asm/archrandom.h>
 
 static u32 smccc_version = ARM_SMCCC_VERSION_1_0;
@@ -66,19 +65,3 @@ s32 arm_smccc_get_soc_id_revision(void)
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

