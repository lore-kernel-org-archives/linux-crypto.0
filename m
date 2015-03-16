From: Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 07/35 linux-next] char: constify of_device_id array
Date: Mon, 16 Mar 2015 20:17:13 +0100
Message-ID: <1426533469-25458-8-git-send-email-fabf@skynet.be>
References: <1426533469-25458-1-git-send-email-fabf@skynet.be>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Fabian Frederick <fabf@skynet.be>,
	Olof Johansson <olof@lixom.net>,
	Matt Mackall <mpm@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Corey Minyard <minyard@acm.org>,
	Eli Billauer <eli.billauer@gmail.com>,
	linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org,
	openipmi-developer@lists.sourceforge.net
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1426533469-25458-1-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

of_device_id is always used as const.
(See driver.of_match_table and open firmware functions)

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/char/hw_random/pasemi-rng.c  | 2 +-
 drivers/char/hw_random/powernv-rng.c | 2 +-
 drivers/char/hw_random/ppc4xx-rng.c  | 2 +-
 drivers/char/ipmi/ipmi_si_intf.c     | 4 ++--
 drivers/char/xillybus/xillybus_of.c  | 2 +-
 5 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/char/hw_random/pasemi-rng.c b/drivers/char/hw_random/pasemi-rng.c
index 3eb7bdd..51cb1d5 100644
--- a/drivers/char/hw_random/pasemi-rng.c
+++ b/drivers/char/hw_random/pasemi-rng.c
@@ -133,7 +133,7 @@ static int rng_remove(struct platform_device *dev)
 	return 0;
 }
 
-static struct of_device_id rng_match[] = {
+static const struct of_device_id rng_match[] = {
 	{ .compatible      = "1682m-rng", },
 	{ .compatible      = "pasemi,pwrficient-rng", },
 	{ },
diff --git a/drivers/char/hw_random/powernv-rng.c b/drivers/char/hw_random/powernv-rng.c
index 3f4f632..263a5bb 100644
--- a/drivers/char/hw_random/powernv-rng.c
+++ b/drivers/char/hw_random/powernv-rng.c
@@ -61,7 +61,7 @@ static int powernv_rng_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static struct of_device_id powernv_rng_match[] = {
+static const struct of_device_id powernv_rng_match[] = {
 	{ .compatible	= "ibm,power-rng",},
 	{},
 };
diff --git a/drivers/char/hw_random/ppc4xx-rng.c b/drivers/char/hw_random/ppc4xx-rng.c
index c85d31a..b2cfda0 100644
--- a/drivers/char/hw_random/ppc4xx-rng.c
+++ b/drivers/char/hw_random/ppc4xx-rng.c
@@ -123,7 +123,7 @@ static int ppc4xx_rng_remove(struct platform_device *dev)
 	return 0;
 }
 
-static struct of_device_id ppc4xx_rng_match[] = {
+static const struct of_device_id ppc4xx_rng_match[] = {
 	{ .compatible = "ppc4xx-rng", },
 	{ .compatible = "amcc,ppc460ex-rng", },
 	{ .compatible = "amcc,ppc440epx-rng", },
diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_intf.c
index 003b4c1..97cf9c2 100644
--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -2664,7 +2664,7 @@ static struct pci_driver ipmi_pci_driver = {
 };
 #endif /* CONFIG_PCI */
 
-static struct of_device_id ipmi_match[];
+static const struct of_device_id ipmi_match[];
 static int ipmi_probe(struct platform_device *dev)
 {
 #ifdef CONFIG_OF
@@ -2761,7 +2761,7 @@ static int ipmi_remove(struct platform_device *dev)
 	return 0;
 }
 
-static struct of_device_id ipmi_match[] =
+static const struct of_device_id ipmi_match[] =
 {
 	{ .type = "ipmi", .compatible = "ipmi-kcs",
 	  .data = (void *)(unsigned long) SI_KCS },
diff --git a/drivers/char/xillybus/xillybus_of.c b/drivers/char/xillybus/xillybus_of.c
index 2002a3a..7818650 100644
--- a/drivers/char/xillybus/xillybus_of.c
+++ b/drivers/char/xillybus/xillybus_of.c
@@ -31,7 +31,7 @@ MODULE_LICENSE("GPL v2");
 static const char xillyname[] = "xillybus_of";
 
 /* Match table for of_platform binding */
-static struct of_device_id xillybus_of_match[] = {
+static const struct of_device_id xillybus_of_match[] = {
 	{ .compatible = "xillybus,xillybus-1.00.a", },
 	{ .compatible = "xlnx,xillybus-1.00.a", }, /* Deprecated */
 	{}
-- 
2.1.0
