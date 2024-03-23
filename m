Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6DA047A58
	for <linux-crypto@vger.kernel.org>; Sat, 23 Mar 2024 16:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711212262; cv=none; b=rkeCHP5lIrzkL0equmzt2c5h7rG91dgoZ42aZKQfEpHdLw69nQvCmBrjdYl7mgzBmtak+OfDxaWrwa8tLrI6d1F7cGd5af1f9drq7yO7VihIONrDtd9SabzW8TYZs5o322F4srkJCQ1/QUJpDURBxlZetGdRXfE+jXbSQL3i+/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711212262; c=relaxed/simple;
	bh=SsQrRejK0w4EjROLcLU+YTlqAB1NnSbndHoHZRoGtMc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jIh9JzNtyATnjOAiUulBcB4qEs2rwo8sG/a8j/t2XwVFjYvbh80tXMZfb1xnav+Vw67YscZ+yStPxTTQV4nfSRKCEqeSoN09SaGm1Jat6a/cvk5HVJ2Hl9io+7R8pV48Uoc5aNGlnK4ewivOxV2qIGCj2S29B1t7cEJ9MKWxic8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YL0U+Pdw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YL0U+Pdw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36624C433C7;
	Sat, 23 Mar 2024 16:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711212261;
	bh=SsQrRejK0w4EjROLcLU+YTlqAB1NnSbndHoHZRoGtMc=;
	h=From:List-Id:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YL0U+Pdw87dwIB0KF6tRoqyubTzRQdW+PdSzoW1DCs9GTGT9iUDT1YPW+qtL8vNEi
	 lCZ/j3K35rVTdbWZoUytLdLG8YeH3Bq3DpIDgPjlIe2e2/c9e6V94e6sO/LvZEJagu
	 xsIpIMB8aDfV3QgV048vR9Ux/6ZSuJesx38TsuZxhKXacuNKtgSEtF309mmmE9pXtd
	 93/P69j07gxh36J/YAtL+ZkOIfxPrjR9VmNrHOfhHW9RGHqOk3oAyLXPtDA4HBsQBm
	 JuMUSbzFNyapVB4T7B/Pay2tUan7Un8GD0Du+/3DNIkTfT2SEWmpSC3hMNCsXaLmEU
	 Qm5/OmoGC7/0w==
From: =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To: Arnd Bergmann <arnd@arndb.de>,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	soc@kernel.org,
	arm@kernel.org,
	Hans de Goede <hdegoede@redhat.com>,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	=?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	Gaurav Jain <gaurav.jain@nxp.com>,
	linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH v5 06/11] devm-helpers: Add resource managed version of irq_create_mapping()
Date: Sat, 23 Mar 2024 17:43:54 +0100
Message-ID: <20240323164359.21642-7-kabel@kernel.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240323164359.21642-1-kabel@kernel.org>
References: <20240323164359.21642-1-kabel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Add resource managed version of irq_create_mapping(), to help drivers
automatically dispose a linux irq mapping when driver is detached.

The new function devm_irq_create_mapping() is not yet used, but the
action function can be used in the FSL CAAM driver.

Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/crypto/caam/jr.c     |  8 ++----
 include/linux/devm-helpers.h | 54 ++++++++++++++++++++++++++++++++++++
 2 files changed, 56 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c
index 26eba7de3fb0..ad0295b055f8 100644
--- a/drivers/crypto/caam/jr.c
+++ b/drivers/crypto/caam/jr.c
@@ -7,6 +7,7 @@
  * Copyright 2019, 2023 NXP
  */
 
+#include <linux/devm-helpers.h>
 #include <linux/of_irq.h>
 #include <linux/of_address.h>
 #include <linux/platform_device.h>
@@ -576,11 +577,6 @@ static int caam_jr_init(struct device *dev)
 	return error;
 }
 
-static void caam_jr_irq_dispose_mapping(void *data)
-{
-	irq_dispose_mapping((unsigned long)data);
-}
-
 /*
  * Probe routine for each detected JobR subsystem.
  */
@@ -656,7 +652,7 @@ static int caam_jr_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	error = devm_add_action_or_reset(jrdev, caam_jr_irq_dispose_mapping,
+	error = devm_add_action_or_reset(jrdev, devm_irq_mapping_drop,
 					 (void *)(unsigned long)jrpriv->irq);
 	if (error)
 		return error;
diff --git a/include/linux/devm-helpers.h b/include/linux/devm-helpers.h
index 74891802200d..3805551fd433 100644
--- a/include/linux/devm-helpers.h
+++ b/include/linux/devm-helpers.h
@@ -24,6 +24,8 @@
  */
 
 #include <linux/device.h>
+#include <linux/kconfig.h>
+#include <linux/irqdomain.h>
 #include <linux/workqueue.h>
 
 static inline void devm_delayed_work_drop(void *res)
@@ -76,4 +78,56 @@ static inline int devm_work_autocancel(struct device *dev,
 	return devm_add_action(dev, devm_work_drop, w);
 }
 
+/**
+ * devm_irq_mapping_drop - devm action for disposing an irq mapping
+ * @res:	linux irq number cast to the void * type
+ *
+ * devm_irq_mapping_drop() can be used as an action parameter for the
+ * devm_add_action_or_reset() function in order to automatically dispose
+ * a linux irq mapping when a device driver is detached.
+ */
+static inline void devm_irq_mapping_drop(void *res)
+{
+	irq_dispose_mapping((unsigned int)(unsigned long)res);
+}
+
+/**
+ * devm_irq_create_mapping - Resource managed version of irq_create_mapping()
+ * @dev:	Device which lifetime the mapping is bound to
+ * @domain:	domain owning this hardware interrupt or NULL for default domain
+ * @hwirq:	hardware irq number in that domain space
+ *
+ * Create an irq mapping to linux irq space which is automatically disposed when
+ * the driver is detached.
+ * devm_irq_create_mapping() can be used to omit the explicit
+ * irq_dispose_mapping() call when driver is detached.
+ *
+ * Returns a linux irq number on success, 0 if mapping could not be created, or
+ * a negative error number if devm action could not be added.
+ */
+static inline int devm_irq_create_mapping(struct device *dev,
+					  struct irq_domain *domain,
+					  irq_hw_number_t hwirq)
+{
+	unsigned int virq = irq_create_mapping(domain, hwirq);
+
+	if (!virq)
+		return 0;
+
+	/*
+	 * irq_dispose_mapping() is an empty function if CONFIG_IRQ_DOMAIN is
+	 * disabled. No need to register an action in that case.
+	 */
+	if (IS_ENABLED(CONFIG_IRQ_DOMAIN)) {
+		int err;
+
+		err = devm_add_action_or_reset(dev, devm_irq_mapping_drop,
+					       (void *)(unsigned long)virq);
+		if (err)
+			return err;
+	}
+
+	return virq;
+}
+
 #endif
-- 
2.43.2

