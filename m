Return-Path: <SRS0=xIDj=ZV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AD67C432C3
	for <linux-crypto@archiver.kernel.org>; Fri, 29 Nov 2019 18:24:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 20D7E21774
	for <linux-crypto@archiver.kernel.org>; Fri, 29 Nov 2019 18:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1575051858;
	bh=K3ZVOScrIP2Y8Vd/IodAYj2iHgVtdhrhc4wQKk0Yi2U=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=ISiLtLC1LakBTkMbNk5nABuvlDQ38M4Gu5/uny5qPgZpmq1s1gZ7xiyu6IDPt1Gff
	 wOsHQeganjdXpb5e+NgccsroTT+vRfCOVLS6NPJGwRoq2NgmIhaCvPmhS3VAOsr3lb
	 W8lFSOb6hNP3Uh7xmmEQfyC0qriIW/gSA/VSc2yw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727040AbfK2SYR (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 29 Nov 2019 13:24:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:57246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727022AbfK2SYR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 29 Nov 2019 13:24:17 -0500
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D18F02176D
        for <linux-crypto@vger.kernel.org>; Fri, 29 Nov 2019 18:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575051856;
        bh=K3ZVOScrIP2Y8Vd/IodAYj2iHgVtdhrhc4wQKk0Yi2U=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=0gOACvFjsieCRX0T9hxGFGkcTtcPZehk+2YqcU8mkflJjK+9YCgPtGaPw4d/y7LLE
         HvahM6/Sj+7Cug1sXix2M5FDx00cHGezYCz0TZ+dUdPwXUOeqdzDBFqzWTpg3/FffL
         tuqbNZ6QXb2lpBoormBqofc5iGl46v20VNhMncaE=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 1/6] crypto: skcipher - remove crypto_skcipher::ivsize
Date:   Fri, 29 Nov 2019 10:23:03 -0800
Message-Id: <20191129182308.53961-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191129182308.53961-1-ebiggers@kernel.org>
References: <20191129182308.53961-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Due to the removal of the blkcipher and ablkcipher algorithm types,
crypto_skcipher::ivsize is now redundant since it always equals
crypto_skcipher_alg(tfm)->ivsize.

Remove it and update crypto_skcipher_ivsize() accordingly.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/skcipher.c         | 1 -
 include/crypto/skcipher.h | 3 +--
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index 13da43c84b64..7d2e722e82af 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -686,7 +686,6 @@ static int crypto_skcipher_init_tfm(struct crypto_tfm *tfm)
 	skcipher->setkey = skcipher_setkey;
 	skcipher->encrypt = alg->encrypt;
 	skcipher->decrypt = alg->decrypt;
-	skcipher->ivsize = alg->ivsize;
 	skcipher->keysize = alg->max_keysize;
 
 	skcipher_set_needkey(skcipher);
diff --git a/include/crypto/skcipher.h b/include/crypto/skcipher.h
index b4655d91661f..bf656a97cb65 100644
--- a/include/crypto/skcipher.h
+++ b/include/crypto/skcipher.h
@@ -40,7 +40,6 @@ struct crypto_skcipher {
 	int (*encrypt)(struct skcipher_request *req);
 	int (*decrypt)(struct skcipher_request *req);
 
-	unsigned int ivsize;
 	unsigned int reqsize;
 	unsigned int keysize;
 
@@ -255,7 +254,7 @@ static inline unsigned int crypto_skcipher_alg_ivsize(struct skcipher_alg *alg)
  */
 static inline unsigned int crypto_skcipher_ivsize(struct crypto_skcipher *tfm)
 {
-	return tfm->ivsize;
+	return crypto_skcipher_alg(tfm)->ivsize;
 }
 
 static inline unsigned int crypto_sync_skcipher_ivsize(
-- 
2.24.0

