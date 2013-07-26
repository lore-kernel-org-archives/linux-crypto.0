From: Lokesh Vutla <lokeshvutla@ti.com>
Subject: [PATCH 2/4] crypto: omap-sham: Add OMAP5/AM43XX SHAM Support
Date: Fri, 26 Jul 2013 12:29:15 +0530
Message-ID: <1374821957-30141-3-git-send-email-lokeshvutla@ti.com>
References: <1374821957-30141-1-git-send-email-lokeshvutla@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-arm-kernel@lists.infradead.org>, <davem@davemloft.net>,
	<herbert@gondor.hengli.com.au>, <rnayak@ti.com>, <nsekhar@ti.com>,
	<joelf@ti.com>, <lokeshvutla@ti.com>
To: <linux-crypto@vger.kernel.org>, <linux-omap@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:38504 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752680Ab3GZG7x (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 26 Jul 2013 02:59:53 -0400
In-Reply-To: <1374821957-30141-1-git-send-email-lokeshvutla@ti.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add support for the OMAP5 version of the SHAM module
that is present on OMAP5 and AM43xx SoCs.

This module is very simialar to OMAP4 version of SHAM module,
and adds SHA384 SHA512 hardware-accelerated hash functions to it.
To handle the higher digest size of SHA512, few SHA512_DIGEST_i
(i=1-16, and first 8 registers are duplicated from SHA_DIGEST_i
registers) registers are added at the end of register set.
So adding the above register offsets and module info in pdata.

Signed-off-by: Lokesh Vutla <lokeshvutla@ti.com>
---
 drivers/crypto/omap-sham.c |   44 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index f73b1e0..a6eb6a8 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -1718,6 +1718,46 @@ static const struct omap_sham_pdata omap_sham_pdata_omap4 = {
 	.minor_shift	= 0,
 };
 
+static struct omap_sham_algs_info omap_sham_algs_info_omap5[] = {
+	{
+		.algs_list	= algs_sha1_md5,
+		.size		= ARRAY_SIZE(algs_sha1_md5),
+	},
+	{
+		.algs_list	= algs_sha224_sha256,
+		.size		= ARRAY_SIZE(algs_sha224_sha256),
+	},
+	{
+		.algs_list	= algs_sha384_sha512,
+		.size		= ARRAY_SIZE(algs_sha384_sha512),
+	},
+};
+
+static const struct omap_sham_pdata omap_sham_pdata_omap5 = {
+	.algs_info	= omap_sham_algs_info_omap5,
+	.algs_info_size	= ARRAY_SIZE(omap_sham_algs_info_omap5),
+	.flags		= BIT(FLAGS_AUTO_XOR),
+	.digest_size	= SHA512_DIGEST_SIZE,
+	.copy_hash	= omap_sham_copy_hash_omap4,
+	.write_ctrl	= omap_sham_write_ctrl_omap4,
+	.trigger	= omap_sham_trigger_omap4,
+	.poll_irq	= omap_sham_poll_irq_omap4,
+	.intr_hdlr	= omap_sham_irq_omap4,
+	.idigest_ofs	= 0x240,
+	.odigest_ofs	= 0x200,
+	.din_ofs	= 0x080,
+	.digcnt_ofs	= 0x280,
+	.rev_ofs	= 0x100,
+	.mask_ofs	= 0x110,
+	.sysstatus_ofs	= 0x114,
+	.mode_ofs	= 0x284,
+	.length_ofs	= 0x288,
+	.major_mask	= 0x0700,
+	.major_shift	= 8,
+	.minor_mask	= 0x003f,
+	.minor_shift	= 0,
+};
+
 static const struct of_device_id omap_sham_of_match[] = {
 	{
 		.compatible	= "ti,omap2-sham",
@@ -1727,6 +1767,10 @@ static const struct of_device_id omap_sham_of_match[] = {
 		.compatible	= "ti,omap4-sham",
 		.data		= &omap_sham_pdata_omap4,
 	},
+	{
+		.compatible	= "ti,omap5-sham",
+		.data		= &omap_sham_pdata_omap5,
+	},
 	{},
 };
 MODULE_DEVICE_TABLE(of, omap_sham_of_match);
-- 
1.7.9.5
