Return-Path: <SRS0=nLyl=CJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2268CC433E2
	for <linux-crypto@archiver.kernel.org>; Mon, 31 Aug 2020 07:32:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A2B720738
	for <linux-crypto@archiver.kernel.org>; Mon, 31 Aug 2020 07:32:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728019AbgHaHcd (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 31 Aug 2020 03:32:33 -0400
Received: from gw.c-home.cz ([89.24.150.100]:41466 "EHLO dmz.c-home.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726618AbgHaHcc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 31 Aug 2020 03:32:32 -0400
Received: from ubuntu1804.c-home.cz (intra-239.c-home.cz [192.168.1.239])
        by dmz.c-home.cz (8.14.4+Sun/8.14.4) with ESMTP id 07V7VPlJ005879;
        Mon, 31 Aug 2020 09:31:37 +0200 (CEST)
From:   Martin Cerveny <m.cerveny@computer.org>
To:     Corentin Labbe <clabbe.montjoie@gmail.com>
Cc:     Martin Cerveny <m.cerveny@computer.org>,
        Chen-Yu Tsai <wens@csie.org>,
        "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, Maxime Ripard <mripard@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Subject: [PATCH v2 3/3] crypto: sun4i-ss - add the V3s variant of SS
Date:   Mon, 31 Aug 2020 09:31:01 +0200
Message-Id: <20200831073101.3608-4-m.cerveny@computer.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200831073101.3608-1-m.cerveny@computer.org>
References: <20200831073101.3608-1-m.cerveny@computer.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Like A33 "sun4i-ss" has a difference, it give SHA1 digest
directly in BE. So add new compatible.

Tested-by: Martin Cerveny <m.cerveny@computer.org>
Signed-off-by: Martin Cerveny <m.cerveny@computer.org>
---
 drivers/crypto/allwinner/sun4i-ss/sun4i-ss-core.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-core.c b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-core.c
index a2b67f7f8..d24496cac 100644
--- a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-core.c
+++ b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-core.c
@@ -31,6 +31,10 @@ static const struct ss_variant ss_a33_variant = {
 	.sha1_in_be = true,
 };
 
+static const struct ss_variant ss_v3s_variant = {
+	.sha1_in_be = true,
+};
+
 static struct sun4i_ss_alg_template ss_algs[] = {
 {       .type = CRYPTO_ALG_TYPE_AHASH,
 	.mode = SS_OP_MD5,
@@ -505,6 +509,9 @@ static const struct of_device_id a20ss_crypto_of_match_table[] = {
 	{ .compatible = "allwinner,sun8i-a33-crypto",
 	  .data = &ss_a33_variant
 	},
+	{ .compatible = "allwinner,sun8i-v3s-crypto",
+	  .data = &ss_v3s_variant
+	},
 	{}
 };
 MODULE_DEVICE_TABLE(of, a20ss_crypto_of_match_table);
-- 
2.17.1

