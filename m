Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70D76C433F5
	for <linux-crypto@archiver.kernel.org>; Wed,  9 Feb 2022 07:06:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235596AbiBIHGO (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 9 Feb 2022 02:06:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233202AbiBIHGM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 9 Feb 2022 02:06:12 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E031CC0612BF
        for <linux-crypto@vger.kernel.org>; Tue,  8 Feb 2022 23:06:15 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id k18so2299735wrg.11
        for <linux-crypto@vger.kernel.org>; Tue, 08 Feb 2022 23:06:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6ObdsU8xJPCCncm3b4zun78zfhQSiXHrwXPxP1BSB1g=;
        b=5dVENlZcT2Twchomim/tmvpOhGJOLH11MAZSjkbYEPmgQjfFWoF+mYa2wG9p98Qyra
         zuIhZabCMsV5NrrGowTm/pWkS6J/Pesc/345hZP6WO3fNy4KOjWJSGkUPTX83TOpU3dK
         zDS3bjl5lS9sdSq6rwmFGinhYU+ZCiXhILpfbaUXdTlTBv2FABjlgYXp1mObLIbHF1IL
         SW9ZswJpFr4T+/t68T9hgSjFNxPenxoPoaRcerKClDrEoyhoA1Yr0reWShJnWNe+ds2A
         ArLFiFjg/9Zs6lG0aRmnq7osXMcHmfi4rsyHRnXL7q7KmCQM7PFX0C7AwKQBJocjnc2m
         V7Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6ObdsU8xJPCCncm3b4zun78zfhQSiXHrwXPxP1BSB1g=;
        b=NTnyXz9qmN7VElyZY2HyOjCD/9Iz6C+Sh8FirVzRgzqTSnWUR/Hwqxfi9gGtGQBPRw
         b2yOfQcTtj5yQGY1LCWIJ3e9B8EvbX7rfvZblbK/ETzh0EEgrd2VfiSS5fQebGRcVqIw
         j6Mxa5QJfccgAP/zSwlBipgjNcPwBPDpTwMSQoTO8zeYZUKVPoPyH5x6A6lU4mPteoQX
         ZEG30DBCcbRd3OGf8yl0dQLFsuX3QZtjAoTtqAYi2/hLUbaLQyGU+B67zTQhbGpCoT4b
         iBKaJN/3+Mu1ZZpB/Urm3CaKzzAoeQ1O+mDLMfIQ0OcJJ/r4lLy6ht0JkjM6VgHOJNHc
         PV1w==
X-Gm-Message-State: AOAM532R0UMS8HESrRP11WLodBOG3Z6VZMlgMWWgBEw0cknhQt01OFk9
        by0vMHZDQMB6aDgCuuNoMuWjvA==
X-Google-Smtp-Source: ABdhPJx083h00yJ9wJBg8BzwxGv5QO29NKEvrGGAo9G3u9YLN4rgyVmq/wsSU2reR2oPp3RiR2+hBw==
X-Received: by 2002:adf:e281:: with SMTP id v1mr870761wri.308.1644390374407;
        Tue, 08 Feb 2022 23:06:14 -0800 (PST)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id n10sm8853553wrt.93.2022.02.08.23.06.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Feb 2022 23:06:13 -0800 (PST)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     davem@davemloft.net, gilad@benyossef.com,
        herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH] crypto: ccree: fix xts-aes-ccree blocksize
Date:   Wed,  9 Feb 2022 07:06:08 +0000
Message-Id: <20220209070608.985213-1-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

loading ccree on next-20220207 with CRYPTO_MANAGER_EXTRA_TESTS show a warning:
alg: skcipher: blocksize for xts-aes-ccree (1) doesn't match generic impl (16)
alg: self-tests for xts-aes-ccree (xts(aes)) failed (rc=-22)

After setting the correct blocksize, selftests pass.

Fixes: 67caef08a71f ("crypto: ccree - enable CTS support in AES-XTS")
Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/crypto/ccree/cc_cipher.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/ccree/cc_cipher.c b/drivers/crypto/ccree/cc_cipher.c
index 78833491f534..d955fe15cf40 100644
--- a/drivers/crypto/ccree/cc_cipher.c
+++ b/drivers/crypto/ccree/cc_cipher.c
@@ -1010,7 +1010,7 @@ static const struct cc_alg_template skcipher_algs[] = {
 	{
 		.name = "xts(paes)",
 		.driver_name = "xts-paes-ccree",
-		.blocksize = 1,
+		.blocksize = XTS_BLOCK_SIZE,
 		.template_skcipher = {
 			.setkey = cc_cipher_sethkey,
 			.encrypt = cc_cipher_encrypt,
@@ -1140,7 +1140,7 @@ static const struct cc_alg_template skcipher_algs[] = {
 		 */
 		.name = "xts(aes)",
 		.driver_name = "xts-aes-ccree",
-		.blocksize = 1,
+		.blocksize = XTS_BLOCK_SIZE,
 		.template_skcipher = {
 			.setkey = cc_cipher_setkey,
 			.encrypt = cc_cipher_encrypt,
-- 
2.34.1

