From: Lee Jones <lee.jones@linaro.org>
Subject: [PATCH v2 2/7] hwrng: Kconfig: Fix device node name reference /dev/hw_random => /dev/hwrng
Date: Thu, 17 Sep 2015 14:45:52 +0100
Message-ID: <1442497557-9271-3-git-send-email-lee.jones@linaro.org>
References: <1442497557-9271-1-git-send-email-lee.jones@linaro.org>
Cc: kernel@stlinux.com, Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org, herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org, peter@korsgaard.com,
	festevam@gmail.com, kieranbingham@gmail.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1442497557-9271-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

In April 2009, commit d405640 ("Driver Core: misc: add node name support
for misc devices.") inadvertently changed the device node name from
/dev/hw_random to /dev/hwrng.  Since 6 years has passed since the change
it seems unpractical to change it back, as this node name is probably
considered ABI by now.  So instead, we'll just change the Kconfig help
to match the current situation.

NB: It looks like rng-tools have already been updated.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/char/hw_random/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
index f48cf11..8998108 100644
--- a/drivers/char/hw_random/Kconfig
+++ b/drivers/char/hw_random/Kconfig
@@ -10,7 +10,7 @@ menuconfig HW_RANDOM
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called rng-core.  This provides a device
-	  that's usually called /dev/hw_random, and which exposes one
+	  that's usually called /dev/hwrng, and which exposes one
 	  of possibly several hardware random number generators.
 
 	  These hardware random number generators do not feed directly
-- 
1.9.1
