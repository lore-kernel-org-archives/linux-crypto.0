Return-Path: <SRS0=i+zF=BU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B701DC433E1
	for <linux-crypto@archiver.kernel.org>; Mon, 10 Aug 2020 19:26:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E3A42080C
	for <linux-crypto@archiver.kernel.org>; Mon, 10 Aug 2020 19:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597087587;
	bh=2K2iG1CjBSTPdSLSG5ajTMC50p1FwenSlUrZitpjRWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=JQjGwX15if+wtNTU6yAzaXn+3Nm3KYOfa8FIbN22jZHTN3C6pQIIap4ANBYMJoZxW
	 8Yl1AkWJ46FOybYlg5D6JkB8AisxBWyeLWWXIO5cLf8wZQcqcsNV4Jdn/BvYKEb3Tz
	 0hsgN9nurJrU2/h3q96W/1h3XGuDPMKW0oUo7rpA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729167AbgHJT0W (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 10 Aug 2020 15:26:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:40638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729414AbgHJTLu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 Aug 2020 15:11:50 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3F1AD22BED;
        Mon, 10 Aug 2020 19:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597086710;
        bh=2K2iG1CjBSTPdSLSG5ajTMC50p1FwenSlUrZitpjRWY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sASTmFKia7lY4Xrq9LIs+2PklDrutaes823Js8953dH/ujPmcaea5Dqzka1ZDBUJK
         s9vt9kAt3fTpuM4JcOsszApmUCJ1G94xdH2kf4l367NCjRCZclFZz1wTO1HcGeHNOF
         zYM061LoXQYFAC/WpDw8GRHxhUNgW8IY/oWfR9WA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 59/60] crypto: caam - silence .setkey in case of bad key length
Date:   Mon, 10 Aug 2020 15:10:27 -0400
Message-Id: <20200810191028.3793884-59-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200810191028.3793884-1-sashal@kernel.org>
References: <20200810191028.3793884-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Horia Geantă <horia.geanta@nxp.com>

[ Upstream commit da6a66853a381864f4b040832cf11f0dbba0a097 ]

In case of bad key length, driver emits "key size mismatch" messages,
but only for xts(aes) algorithms.

Reduce verbosity by making them visible only when debugging.
This way crypto fuzz testing log cleans up a bit.

Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/caam/caamalg.c     | 2 +-
 drivers/crypto/caam/caamalg_qi.c  | 2 +-
 drivers/crypto/caam/caamalg_qi2.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index b2f9882bc010f..bf90a4fcabd1f 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -838,7 +838,7 @@ static int xts_skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
 	u32 *desc;
 
 	if (keylen != 2 * AES_MIN_KEY_SIZE  && keylen != 2 * AES_MAX_KEY_SIZE) {
-		dev_err(jrdev, "key size mismatch\n");
+		dev_dbg(jrdev, "key size mismatch\n");
 		return -EINVAL;
 	}
 
diff --git a/drivers/crypto/caam/caamalg_qi.c b/drivers/crypto/caam/caamalg_qi.c
index 27e36bdf6163b..315d53499ce85 100644
--- a/drivers/crypto/caam/caamalg_qi.c
+++ b/drivers/crypto/caam/caamalg_qi.c
@@ -728,7 +728,7 @@ static int xts_skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
 	int ret = 0;
 
 	if (keylen != 2 * AES_MIN_KEY_SIZE  && keylen != 2 * AES_MAX_KEY_SIZE) {
-		dev_err(jrdev, "key size mismatch\n");
+		dev_dbg(jrdev, "key size mismatch\n");
 		return -EINVAL;
 	}
 
diff --git a/drivers/crypto/caam/caamalg_qi2.c b/drivers/crypto/caam/caamalg_qi2.c
index 28669cbecf77c..e1b6bc6ef091b 100644
--- a/drivers/crypto/caam/caamalg_qi2.c
+++ b/drivers/crypto/caam/caamalg_qi2.c
@@ -1058,7 +1058,7 @@ static int xts_skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
 	u32 *desc;
 
 	if (keylen != 2 * AES_MIN_KEY_SIZE  && keylen != 2 * AES_MAX_KEY_SIZE) {
-		dev_err(dev, "key size mismatch\n");
+		dev_dbg(dev, "key size mismatch\n");
 		return -EINVAL;
 	}
 
-- 
2.25.1

