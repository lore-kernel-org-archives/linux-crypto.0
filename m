Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A823C433EF
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Nov 2021 05:10:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1009E61AF0
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Nov 2021 05:10:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229827AbhKSFNg (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 19 Nov 2021 00:13:36 -0500
Received: from wnew1-smtp.messagingengine.com ([64.147.123.26]:36941 "EHLO
        wnew1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229675AbhKSFNe (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 Nov 2021 00:13:34 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailnew.west.internal (Postfix) with ESMTP id 6B1092B01143;
        Fri, 19 Nov 2021 00:10:32 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Fri, 19 Nov 2021 00:10:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sholland.org; h=
        from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=fm1; bh=958dHVlrtoqnp
        /Is71jDQ6iJUv3oa+p7GUL7loCPVBk=; b=RBqKS3zUFnqRpg6Gnh9wsyg4Zb21r
        uJojl9pmATjalSNUxDI0RHt+oYUAdJe1zFVEw2j48z7m0aUPrGjP+Y0URCm9Fd0Q
        RsDK+TVwu9fgwrXAAj0raNYsO5dTQ6tDS1SfyAvm2YHWIUbk0XCp0uQgLyWO6NEE
        2oCJYMUNTAm6CarYNZzEDOiO4FYQ2I48Uk3WGrXYT9fFFAoA+1c+RJvDNYYtA34M
        WgJ6jwAg6pcKRL6mbf0pf3ABOkWLN/SjpsFOCWAtKjPhRJ5A9zfAFrTplaDU8rlK
        63SJWLzgQS62NwxvlQVKNoIeypNmhEj7TTBdknYImWz2+Kz2corfEFgQg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=958dHVlrtoqnp/Is71jDQ6iJUv3oa+p7GUL7loCPVBk=; b=YONPrywN
        v2hI2LsgbO7JOWWEF0Snp2LEumDr5/upUTvJliu3AQaC02Mv+q0flJCnz5l8KkY/
        NK5c8leAGVY6KnFVXenZ4C1vMkB6Ld16eQZOZHTpQ0xO3VDLS4yt+1bv4ydDXwlO
        EOa2dLIgb1c24cOQjF9n4BYsuzBI5lrYMF+XgmjozXB4omHyhAQx0TXg8H1M1P/h
        +PTSaxLknuLHtf4wN01LlaQEf1zQvD80k6R2tOuOhP6DKePKxNVc1TOKj9Ex/MJg
        w3nl7uElcLkqMnamvt7LDFo0b7EDLzigXVAmi1WGtxgoqzQnXwqvI3nes2Ytpdh1
        17xsC/4LQCxcmA==
X-ME-Sender: <xms:xzGXYY-F566_eTJpfU7_jSNXdyYMnvXc3B14mq9OcYcYVEm7scdP-A>
    <xme:xzGXYQt0XOR-VO-sad2uDiF1i2G7i8GXK3zD4dr_6zHphWL51ILt-6x67ptUnhm3K
    tVgrxb317AmBNIYWA>
X-ME-Received: <xmr:xzGXYeCiI8eqfWKWLNqyeykBJ6RbDkDIjXAZBAVURebmsIEiWW_9uP8u0Hf19N4m7Sl1XX7_VN0HAMR29ltwFxJ_e5c_eOVDf1iOPx8AmWxC_Yx5W_LPRDp7EnQk-OV1LFHVDg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrfeejgdejlecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefhvffufffkofgjfhgggfestdekredtredttdenucfhrhhomhepufgrmhhuvghl
    ucfjohhllhgrnhguuceoshgrmhhuvghlsehshhholhhlrghnugdrohhrgheqnecuggftrf
    grthhtvghrnhepudfhjeefvdfhgfefheetgffhieeigfefhefgvddvveefgeejheejvdfg
    jeehueeinecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomh
    epshgrmhhuvghlsehshhholhhlrghnugdrohhrgh
X-ME-Proxy: <xmx:xzGXYYcF5XlCSAxr-xM6PsmP3juriKsu9FUMAU5fvzjWTEYi1JOUHw>
    <xmx:xzGXYdNoMhAXrwZlyCoa8Mu0KUI_tPjTkVzfXE5gW88WMmhfI1-VJw>
    <xmx:xzGXYSnQDk37zgSac3pbyfNaxBZObso3aA9c7aQXs8JIkKlD9holaQ>
    <xmx:yDGXYQqWcvu4G1aNR8AHdaAs1mIpqZEfTddBrz5GUj3GPkWsaMW0vEUjpLA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 19 Nov 2021 00:10:30 -0500 (EST)
From:   Samuel Holland <samuel@sholland.org>
To:     Corentin Labbe <clabbe.montjoie@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
Cc:     Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        linux-sunxi@lists.linux.dev, Samuel Holland <samuel@sholland.org>
Subject: [PATCH 2/2] crypto: sun8i-ce: Add support for the D1 variant
Date:   Thu, 18 Nov 2021 23:10:25 -0600
Message-Id: <20211119051026.13049-2-samuel@sholland.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211119051026.13049-1-samuel@sholland.org>
References: <20211119051026.13049-1-samuel@sholland.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Corentin Labbe <clabbe.montjoie@gmail.com>

The Allwinner D1 SoC has a crypto engine compatible with sun8i-ce.
Add support for it.

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
Signed-off-by: Samuel Holland <samuel@sholland.org>
---

 .../crypto/allwinner/sun8i-ce/sun8i-ce-core.c | 21 +++++++++++++++++++
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h  |  1 +
 2 files changed, 22 insertions(+)

diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
index 00194d1d9ae6..d8623c7e0d1d 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
@@ -106,6 +106,24 @@ static const struct ce_variant ce_a64_variant = {
 	.trng = CE_ID_NOTSUPP,
 };
 
+static const struct ce_variant ce_d1_variant = {
+	.alg_cipher = { CE_ALG_AES, CE_ALG_DES, CE_ALG_3DES,
+	},
+	.alg_hash = { CE_ALG_MD5, CE_ALG_SHA1, CE_ALG_SHA224, CE_ALG_SHA256,
+		CE_ALG_SHA384, CE_ALG_SHA512
+	},
+	.op_mode = { CE_OP_ECB, CE_OP_CBC
+	},
+	.ce_clks = {
+		{ "bus", 0, 200000000 },
+		{ "mod", 300000000, 0 },
+		{ "ram", 0, 400000000 },
+		},
+	.esr = ESR_D1,
+	.prng = CE_ALG_PRNG,
+	.trng = CE_ALG_TRNG,
+};
+
 static const struct ce_variant ce_r40_variant = {
 	.alg_cipher = { CE_ALG_AES, CE_ALG_DES, CE_ALG_3DES,
 	},
@@ -192,6 +210,7 @@ int sun8i_ce_run_task(struct sun8i_ce_dev *ce, int flow, const char *name)
 			dev_err(ce->dev, "CE ERROR: keysram access error for AES\n");
 		break;
 	case ESR_A64:
+	case ESR_D1:
 	case ESR_H5:
 	case ESR_R40:
 		v >>= (flow * 4);
@@ -990,6 +1009,8 @@ static const struct of_device_id sun8i_ce_crypto_of_match_table[] = {
 	  .data = &ce_h3_variant },
 	{ .compatible = "allwinner,sun8i-r40-crypto",
 	  .data = &ce_r40_variant },
+	{ .compatible = "allwinner,sun20i-d1-crypto",
+	  .data = &ce_d1_variant },
 	{ .compatible = "allwinner,sun50i-a64-crypto",
 	  .data = &ce_a64_variant },
 	{ .compatible = "allwinner,sun50i-h5-crypto",
diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
index cec781d5063c..624a5926f21f 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
@@ -94,6 +94,7 @@
 #define ESR_R40	2
 #define ESR_H5	3
 #define ESR_H6	4
+#define ESR_D1	5
 
 #define PRNG_DATA_SIZE (160 / 8)
 #define PRNG_SEED_SIZE DIV_ROUND_UP(175, 8)
-- 
2.32.0

