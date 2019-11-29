Return-Path: <SRS0=xIDj=ZV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC2C3C33CA0
	for <linux-crypto@archiver.kernel.org>; Fri, 29 Nov 2019 18:24:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 97ECB21736
	for <linux-crypto@archiver.kernel.org>; Fri, 29 Nov 2019 18:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1575051860;
	bh=mjBiq95fkQXF7X08ZBKjZvlPfz4Gtl8jwfOlCfbI+jI=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=wkBXsLpX/QfzZtkX0k6eLPTBzJWcfdg6RkV2NaUakwLpgKncAYzKo6u7cwA+d/vAv
	 xj5gPZT4pNv6EigcHo7XtLvhN8SI5I61/e2//9ku3NmxqhTdhR3gkeipzYIGiLXUTI
	 F3lYE5/2qIkMU1ez8Lvl7fmjL+ow0j9Fahjb/spI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727030AbfK2SYT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 29 Nov 2019 13:24:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:57254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727043AbfK2SYS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 29 Nov 2019 13:24:18 -0500
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9C54F2176D
        for <linux-crypto@vger.kernel.org>; Fri, 29 Nov 2019 18:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575051857;
        bh=mjBiq95fkQXF7X08ZBKjZvlPfz4Gtl8jwfOlCfbI+jI=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=OAuNFYeJIp1bIEdDZjV4PlE1QsJmO10mBP4cTLq7YoV5+sexpwluF20ltHibmixbH
         NURTezxmWO2ogVJyP36XEW8QotC20hcGfDCvsWQct3SDVLQp9aGNL6kLk1m/ewdavC
         MwUngK2H9CYBfAXnWIuj6vTG7NZKIjRZ8qx0ImZU=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 5/6] crypto: skcipher - remove crypto_skcipher::decrypt
Date:   Fri, 29 Nov 2019 10:23:07 -0800
Message-Id: <20191129182308.53961-6-ebiggers@kernel.org>
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
crypto_skcipher::decrypt is now redundant since it always equals
crypto_skcipher_alg(tfm)->decrypt.

Remove it and update crypto_skcipher_decrypt() accordingly.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/skcipher.c         | 4 +---
 include/crypto/skcipher.h | 2 --
 2 files changed, 1 insertion(+), 5 deletions(-)

diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index 926295ce1b07..e4e4a445dc66 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -665,7 +665,7 @@ int crypto_skcipher_decrypt(struct skcipher_request *req)
 	if (crypto_skcipher_get_flags(tfm) & CRYPTO_TFM_NEED_KEY)
 		ret = -ENOKEY;
 	else
-		ret = tfm->decrypt(req);
+		ret = crypto_skcipher_alg(tfm)->decrypt(req);
 	crypto_stats_skcipher_decrypt(cryptlen, ret, alg);
 	return ret;
 }
@@ -684,8 +684,6 @@ static int crypto_skcipher_init_tfm(struct crypto_tfm *tfm)
 	struct crypto_skcipher *skcipher = __crypto_skcipher_cast(tfm);
 	struct skcipher_alg *alg = crypto_skcipher_alg(skcipher);
 
-	skcipher->decrypt = alg->decrypt;
-
 	skcipher_set_needkey(skcipher);
 
 	if (alg->exit)
diff --git a/include/crypto/skcipher.h b/include/crypto/skcipher.h
index 694215a59719..8ebf4167632b 100644
--- a/include/crypto/skcipher.h
+++ b/include/crypto/skcipher.h
@@ -35,8 +35,6 @@ struct skcipher_request {
 };
 
 struct crypto_skcipher {
-	int (*decrypt)(struct skcipher_request *req);
-
 	unsigned int reqsize;
 
 	struct crypto_tfm base;
-- 
2.24.0

