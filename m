From: Romain Perier <romain.perier@free-electrons.com>
Subject: [PATCH 6/9] hwrng: omap - Add support for 128-bit output of data
Date: Tue,  6 Sep 2016 17:38:54 +0200
Message-ID: <20160906153857.5503-7-romain.perier@free-electrons.com>
References: <20160906153857.5503-1-romain.perier@free-electrons.com>
Cc: Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Romain Perier <romain.perier@free-electrons.com>,
        Nadav Haklai <nadavh@marvell.com>,
        Omri Itach <omrii@marvell.com>,
        Shadi Ammouri <shadi@marvell.com>,
        Yahuda Yitschak <yehuday@marvell.com>,
        Hanna Hawa <hannah@marvell.com>,
        Neta Zur Hershkovits <neta@marvell.com>,
        Igal Liberman <igall@marvell.com>,
        Marcin Wojtas <mw@semihalf.com>, linux-crypto@vger.kernel.org
To: dsaxena@plexity.net, mpm@selenic.com,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:59298 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S933412AbcIFPkP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 6 Sep 2016 11:40:15 -0400
In-Reply-To: <20160906153857.5503-1-romain.perier@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

So far, this driver only supports up to 64 bits of output data generated
by an RNG. Some IP blocks, like the SafeXcel IP-76 supports up to 128
bits of output data. This commits renames registers descriptions
OUTPUT_L_REG and OUTPUT_H_REG to OUTPUT_0_REG and OUPUT_1_REG,
respectively. It also adds two new values to the enumeration of existing
registers: OUTPUT_2_REG and OUTPUT_3_REG.

Signed-off-by: Romain Perier <romain.perier@free-electrons.com>
---
 drivers/char/hw_random/omap-rng.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/char/hw_random/omap-rng.c b/drivers/char/hw_random/omap-rng.c
index f9a99b2..6a3aaad 100644
--- a/drivers/char/hw_random/omap-rng.c
+++ b/drivers/char/hw_random/omap-rng.c
@@ -65,8 +65,10 @@
 #define OMAP4_RNG_OUTPUT_SIZE			0x8
 
 enum {
-	RNG_OUTPUT_L_REG = 0,
-	RNG_OUTPUT_H_REG,
+	RNG_OUTPUT_0_REG = 0,
+	RNG_OUTPUT_1_REG,
+	RNG_OUTPUT_2_REG,
+	RNG_OUTPUT_3_REG,
 	RNG_STATUS_REG,
 	RNG_INTMASK_REG,
 	RNG_INTACK_REG,
@@ -82,7 +84,7 @@ enum {
 };
 
 static const u16 reg_map_omap2[] = {
-	[RNG_OUTPUT_L_REG]	= 0x0,
+	[RNG_OUTPUT_0_REG]	= 0x0,
 	[RNG_STATUS_REG]	= 0x4,
 	[RNG_CONFIG_REG]	= 0x28,
 	[RNG_REV_REG]		= 0x3c,
@@ -90,8 +92,8 @@ static const u16 reg_map_omap2[] = {
 };
 
 static const u16 reg_map_omap4[] = {
-	[RNG_OUTPUT_L_REG]	= 0x0,
-	[RNG_OUTPUT_H_REG]	= 0x4,
+	[RNG_OUTPUT_0_REG]	= 0x0,
+	[RNG_OUTPUT_1_REG]	= 0x4,
 	[RNG_STATUS_REG]	= 0x8,
 	[RNG_INTMASK_REG]	= 0xc,
 	[RNG_INTACK_REG]	= 0x10,
@@ -155,7 +157,7 @@ static int omap_rng_do_read(struct hwrng *rng, void *data, size_t max,
 	if (!priv->pdata->data_present(priv))
 		return 0;
 
-	memcpy_fromio(data, priv->base + priv->pdata->regs[RNG_OUTPUT_L_REG],
+	memcpy_fromio(data, priv->base + priv->pdata->regs[RNG_OUTPUT_0_REG],
 		      priv->pdata->data_size);
 
 	if (priv->pdata->regs[RNG_INTACK_REG])
-- 
2.9.3
