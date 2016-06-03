From: Neil Armstrong <narmstrong@baylibre.com>
Subject: [PATCH 1/3] char: hw_random: Add Amlogic Meson Hardware Random
 Generator
Date: Fri,  3 Jun 2016 10:46:59 +0200
Message-ID: <1464943621-18278-2-git-send-email-narmstrong@baylibre.com>
References: <1464943621-18278-1-git-send-email-narmstrong@baylibre.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, linux-amlogic@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Neil Armstrong <narmstrong@baylibre.com>
To: Matt Mackall <mpm@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1464943621-18278-1-git-send-email-narmstrong@baylibre.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

Add support for the Amlogic Meson SoCs hardware random generator.

Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
---
 drivers/char/hw_random/Kconfig     |  13 ++++
 drivers/char/hw_random/Makefile    |   1 +
 drivers/char/hw_random/meson-rng.c | 128 +++++++++++++++++++++++++++++++++++++
 3 files changed, 142 insertions(+)
 create mode 100644 drivers/char/hw_random/meson-rng.c

diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
index ac51149..6f349bb 100644
--- a/drivers/char/hw_random/Kconfig
+++ b/drivers/char/hw_random/Kconfig
@@ -396,6 +396,19 @@ config HW_RANDOM_PIC32
 
 	  If unsure, say Y.
 
+config HW_RANDOM_MESON
+	tristate "Amlogic Meson Random Number Generator support"
+	depends on HW_RANDOM && ARCH_MESON
+	default y
+	---help---
+	  This driver provides kernel-side support for the Random Number
+	  Generator hardware found on Amlogic Meson SoCs.
+
+	  To compile this driver as a module, choose M here. the
+	  module will be called meson-rng.
+
+	  If unsure, say Y.
+
 endif # HW_RANDOM
 
 config UML_RANDOM
diff --git a/drivers/char/hw_random/Makefile b/drivers/char/hw_random/Makefile
index 63022b4..04bb0b0 100644
--- a/drivers/char/hw_random/Makefile
+++ b/drivers/char/hw_random/Makefile
@@ -34,3 +34,4 @@ obj-$(CONFIG_HW_RANDOM_ST) += st-rng.o
 obj-$(CONFIG_HW_RANDOM_XGENE) += xgene-rng.o
 obj-$(CONFIG_HW_RANDOM_STM32) += stm32-rng.o
 obj-$(CONFIG_HW_RANDOM_PIC32) += pic32-rng.o
+obj-$(CONFIG_HW_RANDOM_MESON) += meson-rng.o
diff --git a/drivers/char/hw_random/meson-rng.c b/drivers/char/hw_random/meson-rng.c
new file mode 100644
index 0000000..58bef39
--- /dev/null
+++ b/drivers/char/hw_random/meson-rng.c
@@ -0,0 +1,128 @@
+/*
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright (c) 2016 BayLibre, SAS.
+ * Author: Neil Armstrong <narmstrong@baylibre.com>
+ * Copyright (C) 2014 Amlogic, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see <http://www.gnu.org/licenses/>.
+ * The full GNU General Public License is included in this distribution
+ * in the file called COPYING.
+ *
+ * BSD LICENSE
+ *
+ * Copyright (c) 2016 BayLibre, SAS.
+ * Author: Neil Armstrong <narmstrong@baylibre.com>
+ * Copyright (C) 2014 Amlogic, Inc.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *   * Redistributions of source code must retain the above copyright
+ *     notice, this list of conditions and the following disclaimer.
+ *   * Redistributions in binary form must reproduce the above copyright
+ *     notice, this list of conditions and the following disclaimer in
+ *     the documentation and/or other materials provided with the
+ *     distribution.
+ *   * Neither the name of Intel Corporation nor the names of its
+ *     contributors may be used to endorse or promote products derived
+ *     from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ */
+#include <linux/err.h>
+#include <linux/module.h>
+#include <linux/io.h>
+#include <linux/platform_device.h>
+#include <linux/hw_random.h>
+#include <linux/slab.h>
+#include <linux/types.h>
+#include <linux/of.h>
+
+#define RNG_DATA 0x00
+
+struct meson_rng_data {
+	void __iomem *base;
+	struct platform_device *pdev;
+	struct hwrng rng;
+};
+
+static int meson_rng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
+{
+	struct meson_rng_data *data =
+			container_of(rng, struct meson_rng_data, rng);
+
+	*(u32 *)buf = readl_relaxed(data->base + RNG_DATA);
+
+	return sizeof(u32);
+}
+
+static int meson_rng_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct meson_rng_data *data;
+	struct resource *res;
+
+	data = devm_kzalloc(dev, sizeof(*data), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	data->pdev = pdev;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	data->base = devm_ioremap_resource(dev, res);
+	if (IS_ERR(data->base))
+		return PTR_ERR(data->base);
+
+	data->rng.name = pdev->name;
+	data->rng.read = meson_rng_read;
+
+	platform_set_drvdata(pdev, data);
+
+	return devm_hwrng_register(dev, &data->rng);
+}
+
+static const struct of_device_id meson_rng_of_match[] = {
+	{ .compatible = "amlogic,meson-rng", },
+	{},
+};
+
+static struct platform_driver meson_rng_driver = {
+	.probe	= meson_rng_probe,
+	.driver	= {
+		.name = "meson-rng",
+		.of_match_table = meson_rng_of_match,
+	},
+};
+
+module_platform_driver(meson_rng_driver);
+
+MODULE_ALIAS("platform:meson-rng");
+MODULE_DESCRIPTION("Meson H/W Random Number Generator driver");
+MODULE_AUTHOR("Lawrence Mok <lawrence.mok@amlogic.com>");
+MODULE_AUTHOR("Neil Armstrong <narmstrong@baylibre.com>");
+MODULE_LICENSE("Dual BSD/GPL");
-- 
2.7.0
