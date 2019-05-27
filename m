Return-Path: <SRS0=ER81=T3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0A51C04AB3
	for <linux-crypto@archiver.kernel.org>; Mon, 27 May 2019 14:51:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A4B082081C
	for <linux-crypto@archiver.kernel.org>; Mon, 27 May 2019 14:51:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726803AbfE0Ovg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 May 2019 10:51:36 -0400
Received: from relay12.mail.gandi.net ([217.70.178.232]:37715 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726772AbfE0Ove (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 May 2019 10:51:34 -0400
Received: from localhost (aaubervilliers-681-1-27-134.w90-88.abo.wanadoo.fr [90.88.147.134])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id 31EFB200013;
        Mon, 27 May 2019 14:51:31 +0000 (UTC)
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     herbert@gondor.apana.org.au, davem@davemloft.net
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, maxime.chevallier@bootlin.com,
        gregory.clement@bootlin.com, miquel.raynal@bootlin.com,
        nadavh@marvell.com, igall@marvell.com
Subject: [PATCH 07/14] crypto: inside-secure - enable context reuse
Date:   Mon, 27 May 2019 16:50:59 +0200
Message-Id: <20190527145106.8693-8-antoine.tenart@bootlin.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190527145106.8693-1-antoine.tenart@bootlin.com>
References: <20190527145106.8693-1-antoine.tenart@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The context given to the crypto engine can be reused over time. While
the driver was designed to allow this, the feature wasn't enabled in the
hardware engine. This patch enables it.

Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
---
 drivers/crypto/inside-secure/safexcel.c      | 6 ++++++
 drivers/crypto/inside-secure/safexcel.h      | 7 +++++++
 drivers/crypto/inside-secure/safexcel_ring.c | 3 +++
 3 files changed, 16 insertions(+)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index 316e5e4c1c74..df43a2c6933b 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -398,6 +398,12 @@ static int safexcel_hw_init(struct safexcel_crypto_priv *priv)
 
 		/* Processing Engine configuration */
 
+		/* Token & context configuration */
+		val = EIP197_PE_EIP96_TOKEN_CTRL_CTX_UPDATES |
+		      EIP197_PE_EIP96_TOKEN_CTRL_REUSE_CTX |
+		      EIP197_PE_EIP96_TOKEN_CTRL_POST_REUSE_CTX;
+		writel(val, EIP197_PE(priv) + EIP197_PE_EIP96_TOKEN_CTRL(pe));
+
 		/* H/W capabilities selection */
 		val = EIP197_FUNCTION_RSVD;
 		val |= EIP197_PROTOCOL_ENCRYPT_ONLY | EIP197_PROTOCOL_HASH_ONLY;
diff --git a/drivers/crypto/inside-secure/safexcel.h b/drivers/crypto/inside-secure/safexcel.h
index 65624a81f0fd..0bc8859f9d06 100644
--- a/drivers/crypto/inside-secure/safexcel.h
+++ b/drivers/crypto/inside-secure/safexcel.h
@@ -118,6 +118,7 @@
 #define EIP197_PE_ICE_SCRATCH_CTRL(n)		(0x0d04 + (0x2000 * (n)))
 #define EIP197_PE_ICE_FPP_CTRL(n)		(0x0d80 + (0x2000 * (n)))
 #define EIP197_PE_ICE_RAM_CTRL(n)		(0x0ff0 + (0x2000 * (n)))
+#define EIP197_PE_EIP96_TOKEN_CTRL(n)		(0x1000 + (0x2000 * (n)))
 #define EIP197_PE_EIP96_FUNCTION_EN(n)		(0x1004 + (0x2000 * (n)))
 #define EIP197_PE_EIP96_CONTEXT_CTRL(n)		(0x1008 + (0x2000 * (n)))
 #define EIP197_PE_EIP96_CONTEXT_STAT(n)		(0x100c + (0x2000 * (n)))
@@ -249,6 +250,11 @@
 #define EIP197_PE_ICE_RAM_CTRL_PUE_PROG_EN	BIT(0)
 #define EIP197_PE_ICE_RAM_CTRL_FPP_PROG_EN	BIT(1)
 
+/* EIP197_PE_EIP96_TOKEN_CTRL */
+#define EIP197_PE_EIP96_TOKEN_CTRL_CTX_UPDATES		BIT(16)
+#define EIP197_PE_EIP96_TOKEN_CTRL_REUSE_CTX		BIT(19)
+#define EIP197_PE_EIP96_TOKEN_CTRL_POST_REUSE_CTX	BIT(20)
+
 /* EIP197_PE_EIP96_FUNCTION_EN */
 #define EIP197_FUNCTION_RSVD			(BIT(6) | BIT(15) | BIT(20) | BIT(23))
 #define EIP197_PROTOCOL_HASH_ONLY		BIT(0)
@@ -468,6 +474,7 @@ struct safexcel_control_data_desc {
 
 #define EIP197_OPTION_MAGIC_VALUE	BIT(0)
 #define EIP197_OPTION_64BIT_CTX		BIT(1)
+#define EIP197_OPTION_RC_AUTO		(0x2 << 3)
 #define EIP197_OPTION_CTX_CTRL_IN_CMD	BIT(8)
 #define EIP197_OPTION_2_TOKEN_IV_CMD	GENMASK(11, 10)
 #define EIP197_OPTION_4_TOKEN_IV_CMD	GENMASK(11, 9)
diff --git a/drivers/crypto/inside-secure/safexcel_ring.c b/drivers/crypto/inside-secure/safexcel_ring.c
index eb75fa684876..142bc3f5c45c 100644
--- a/drivers/crypto/inside-secure/safexcel_ring.c
+++ b/drivers/crypto/inside-secure/safexcel_ring.c
@@ -145,6 +145,9 @@ struct safexcel_command_desc *safexcel_add_cdesc(struct safexcel_crypto_priv *pr
 			(lower_32_bits(context) & GENMASK(31, 2)) >> 2;
 		cdesc->control_data.context_hi = upper_32_bits(context);
 
+		if (priv->version == EIP197B || priv->version == EIP197D)
+			cdesc->control_data.options |= EIP197_OPTION_RC_AUTO;
+
 		/* TODO: large xform HMAC with SHA-384/512 uses refresh = 3 */
 		cdesc->control_data.refresh = 2;
 
-- 
2.21.0

