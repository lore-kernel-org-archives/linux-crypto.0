Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 614FFC433FE
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Oct 2022 04:34:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbiJFEe3 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 6 Oct 2022 00:34:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbiJFEe2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 6 Oct 2022 00:34:28 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09DE28981C
        for <linux-crypto@vger.kernel.org>; Wed,  5 Oct 2022 21:34:26 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id b4so811111wrs.1
        for <linux-crypto@vger.kernel.org>; Wed, 05 Oct 2022 21:34:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=2+q4B77y4492OMsLSwltTjFCfBaNdGlc5g1vRjEyo3g=;
        b=2wFJjHlwVyr1e0k1AXHQd1abfAAdqyKs3yxiEy2rMVLvl00/Z2ER9PrhBplnR4VAMc
         a0UQPjzaqILUbow5I4EUnT5BPmVCno5ncMVszIlEFCCATeFYaClwMum+A6Ze12PiT4Fj
         5bxRjAbbdMDgUBnzhJyk9b2nSC/ovqtWaJs0C5Qaee5eszNy4VHLlJtkN2L2w83hxxri
         Gz063zBGv2XcPwUlxltNG2JIiIe6J8wyYwTtz2Qe6YzQScaz6uHChNxsJ+Q7QKWNKR8C
         hbKwMGexOIvw918S8S2kvkkmEz0EgXXQ9GHm7UMB64WhYL0GwVlv4AGwXDPg9tZOzOg+
         qqBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=2+q4B77y4492OMsLSwltTjFCfBaNdGlc5g1vRjEyo3g=;
        b=m5+AfC0hCH7CgSSoPdNwk0K3VpmCcP08fI/6rTo5EORH5fK2ZkBERr4Acl/WuffRy/
         pfTH6F/gf+NHdmNpXTsVMkLKpUCBsCs2Ta9hyISWd88wHxTqQlAA99OlmJFQVO5meV33
         wQmAW5r5pBRF1Mr6lsTfTuquTMvnYP5f04GE9bHYXEYzSXUPzqDC6Vzal840yDiuNxVE
         qzKL43p7sPmxC2kHfGA2AJ63/36gfrVc5lPVRqHaFY7COYN5+rfUEVwHbza0yBznosXy
         mFV6yEynZtnvRMThLsx/W/Z2DVizyfgWedc4U6vTxgTfWkFBlzjQyctWC8RIsUzPbVme
         Ud5w==
X-Gm-Message-State: ACrzQf3KTHziOcdQ20v7fyhl3tXCqYZCNy2eYpYfbuTCjNBvTXrwcpmO
        IUwatpWeKIKnP2wXcBiFDa8kzQ==
X-Google-Smtp-Source: AMsMyM68fvNTKc7Kj9S8HiFOC1YknIuea7TFI8ga2VspcWpmb3pOpp/8tJGMH9bSF5nT9gyfGZ3QEA==
X-Received: by 2002:a5d:4a41:0:b0:228:48c6:7386 with SMTP id v1-20020a5d4a41000000b0022848c67386mr1630387wrs.649.1665030864572;
        Wed, 05 Oct 2022 21:34:24 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id p3-20020a5d4e03000000b002238ea5750csm19627163wrt.72.2022.10.05.21.34.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Oct 2022 21:34:24 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     davem@davemloft.net, eike-kernel@sf-tec.de,
        herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Corentin Labbe <clabbe@baylibre.com>, stable@kernel.org
Subject: [PATCH] crypto: n2: add missing hash statesize
Date:   Thu,  6 Oct 2022 04:34:19 +0000
Message-Id: <20221006043419.3892520-1-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add missing statesize to hash templates.
This is mandatory otherwise no algorithms can be registered as the core
requires statesize to be set.

CC: stable@kernel.org # 4.3+
Reported-by: Rolf Eike Beer <eike-kernel@sf-tec.de>
Tested-by: Rolf Eike Beer <eike-kernel@sf-tec.de>
Fixes: 0a625fd2abaa ("crypto: n2 - Add Niagara2 crypto driver")
Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/crypto/n2_core.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/crypto/n2_core.c b/drivers/crypto/n2_core.c
index 31e24df18877..20d0dcd50344 100644
--- a/drivers/crypto/n2_core.c
+++ b/drivers/crypto/n2_core.c
@@ -1229,6 +1229,7 @@ struct n2_hash_tmpl {
 	const u8	*hash_init;
 	u8		hw_op_hashsz;
 	u8		digest_size;
+	u8		statesize;
 	u8		block_size;
 	u8		auth_type;
 	u8		hmac_type;
@@ -1260,6 +1261,7 @@ static const struct n2_hash_tmpl hash_tmpls[] = {
 	  .hmac_type	= AUTH_TYPE_HMAC_MD5,
 	  .hw_op_hashsz	= MD5_DIGEST_SIZE,
 	  .digest_size	= MD5_DIGEST_SIZE,
+	  .statesize	= sizeof(struct md5_state),
 	  .block_size	= MD5_HMAC_BLOCK_SIZE },
 	{ .name		= "sha1",
 	  .hash_zero	= sha1_zero_message_hash,
@@ -1268,6 +1270,7 @@ static const struct n2_hash_tmpl hash_tmpls[] = {
 	  .hmac_type	= AUTH_TYPE_HMAC_SHA1,
 	  .hw_op_hashsz	= SHA1_DIGEST_SIZE,
 	  .digest_size	= SHA1_DIGEST_SIZE,
+	  .statesize	= sizeof(struct sha1_state),
 	  .block_size	= SHA1_BLOCK_SIZE },
 	{ .name		= "sha256",
 	  .hash_zero	= sha256_zero_message_hash,
@@ -1276,6 +1279,7 @@ static const struct n2_hash_tmpl hash_tmpls[] = {
 	  .hmac_type	= AUTH_TYPE_HMAC_SHA256,
 	  .hw_op_hashsz	= SHA256_DIGEST_SIZE,
 	  .digest_size	= SHA256_DIGEST_SIZE,
+	  .statesize	= sizeof(struct sha256_state),
 	  .block_size	= SHA256_BLOCK_SIZE },
 	{ .name		= "sha224",
 	  .hash_zero	= sha224_zero_message_hash,
@@ -1284,6 +1288,7 @@ static const struct n2_hash_tmpl hash_tmpls[] = {
 	  .hmac_type	= AUTH_TYPE_RESERVED,
 	  .hw_op_hashsz	= SHA256_DIGEST_SIZE,
 	  .digest_size	= SHA224_DIGEST_SIZE,
+	  .statesize	= sizeof(struct sha256_state),
 	  .block_size	= SHA224_BLOCK_SIZE },
 };
 #define NUM_HASH_TMPLS ARRAY_SIZE(hash_tmpls)
@@ -1424,6 +1429,7 @@ static int __n2_register_one_ahash(const struct n2_hash_tmpl *tmpl)
 
 	halg = &ahash->halg;
 	halg->digestsize = tmpl->digest_size;
+	halg->statesize = tmpl->statesize;
 
 	base = &halg->base;
 	snprintf(base->cra_name, CRYPTO_MAX_ALG_NAME, "%s", tmpl->name);
-- 
2.35.1

