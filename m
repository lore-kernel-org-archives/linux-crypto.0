Return-Path: <SRS0=uowK=SU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39879C10F0E
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 08:18:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0AAF2214DA
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 08:18:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A9S7ERqP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388304AbfDRIR7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Apr 2019 04:17:59 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:39498 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733205AbfDRIRx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Apr 2019 04:17:53 -0400
Received: by mail-wr1-f65.google.com with SMTP id j9so1817520wrn.6;
        Thu, 18 Apr 2019 01:17:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2Oa4Mo8b8dqWphkeFQAL0N8F8rFHV+7qiodUTdHFrPA=;
        b=A9S7ERqPxCdpYEOO92/iiqJT0FDISgCqfUojAtdwbZVNI3kDYFplGyNoamMhpzotXd
         +KB6YmhtdMoB9V+HrBw8kozqvClVqD2zD1nvx1zoNJ3p/7nWdA/M86IACynN2APSX3d1
         84t3EYpYiwqCBUxxvku+zmuBnhoz/8Hfpi0c2LDRQ6pddGY58ot5mT4ud/yLtHh+acdz
         ozW+P11h5X9NFwtUrw1GGrd7fGH1uzoAhk5ELgqgIMJ3MOf33/3FHpdM5XyPuVrPV46i
         9JNXdvvTWpJTHLOgCJfW8RLwhzqluP+Ofy3uI/PyU9L/w8jRDTWc741lFzqYxqyUmvik
         ABdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2Oa4Mo8b8dqWphkeFQAL0N8F8rFHV+7qiodUTdHFrPA=;
        b=eQxJc/5lw0wFhNGZVa53yqJFCYwGwVNg7WlEEfBkZ55GkRzYi3U5bEpS16S7ppi/EG
         Qe4kfXOMwnkQxRsH3N9ZBsMOa1uw9EnOi7muVlJ1L03hvGQvFoFRUCRoS+L1pnvLyQF5
         G14O3JrlFFcC/4EZydMxWlmGLqfMC/g5ma1CS6PcjSkbVGbEwAOgs2DYPMSD2YH2Uv5+
         GBPy7V2+yBxMByVEMXIFaoosGhE3jTRQTO7e/83LAVZSYVjHEoO0t1FZEb/t1F63YsF1
         IB15jKUm4T2na247J2CnhJ+1Nd42oILYNZ5/+9Kn8jBerEHsRhRhZWBbkerYLHxUKsMO
         5b9w==
X-Gm-Message-State: APjAAAUWL7Vkcmu9NaIqNRhxMOePN3LAS6HKa2Uf9pkiHszeRmEppuxY
        XIQVDoEPwbISo/LotjQlDvM=
X-Google-Smtp-Source: APXvYqxqwn40/5+L9A3+eP89pCq6/pHgjFgjoZcWIcs6d3AsCTW0oN9srLawfCgS3eEVWRAahhCjFA==
X-Received: by 2002:adf:f90c:: with SMTP id b12mr36495886wrr.63.1555575471082;
        Thu, 18 Apr 2019 01:17:51 -0700 (PDT)
Received: from Red.localdomain ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id w11sm2350619wre.15.2019.04.18.01.17.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Apr 2019 01:17:50 -0700 (PDT)
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        maxime.ripard@bootlin.com, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        ebiggers@kernel.org, Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH 2/4] crypto: sun4i-ss: remove ivsize from ECB
Date:   Thu, 18 Apr 2019 10:17:33 +0200
Message-Id: <20190418081735.19002-3-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190418081735.19002-1-clabbe.montjoie@gmail.com>
References: <20190418081735.19002-1-clabbe.montjoie@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

ECB algos does not need IV.

Fixes: 6298e948215f ("crypto: sunxi-ss - Add Allwinner Security System crypto accelerator")
Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 drivers/crypto/sunxi-ss/sun4i-ss-core.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/crypto/sunxi-ss/sun4i-ss-core.c b/drivers/crypto/sunxi-ss/sun4i-ss-core.c
index 6b2e186dfa8b..3d9c5ad6cbb8 100644
--- a/drivers/crypto/sunxi-ss/sun4i-ss-core.c
+++ b/drivers/crypto/sunxi-ss/sun4i-ss-core.c
@@ -107,7 +107,6 @@ static struct sun4i_ss_alg_template ss_algs[] = {
 		.decrypt        = sun4i_ss_ecb_aes_decrypt,
 		.min_keysize	= AES_MIN_KEY_SIZE,
 		.max_keysize	= AES_MAX_KEY_SIZE,
-		.ivsize		= AES_BLOCK_SIZE,
 		.base = {
 			.cra_name = "ecb(aes)",
 			.cra_driver_name = "ecb-aes-sun4i-ss",
@@ -190,7 +189,6 @@ static struct sun4i_ss_alg_template ss_algs[] = {
 		.decrypt        = sun4i_ss_ecb_des3_decrypt,
 		.min_keysize    = DES3_EDE_KEY_SIZE,
 		.max_keysize    = DES3_EDE_KEY_SIZE,
-		.ivsize         = DES3_EDE_BLOCK_SIZE,
 		.base = {
 			.cra_name = "ecb(des3_ede)",
 			.cra_driver_name = "ecb-des3-sun4i-ss",
-- 
2.21.0

