Return-Path: <SRS0=jNyN=2V=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DE6FC2D0CE
	for <linux-crypto@archiver.kernel.org>; Tue, 31 Dec 2019 03:21:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4A9922077B
	for <linux-crypto@archiver.kernel.org>; Tue, 31 Dec 2019 03:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1577762485;
	bh=Ym52PuGdKcvcb/SXwku4G3+tvPGZHkPzG/UhdznB2Tc=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=kpN5b4SQs15D9bUNG1CsLVdlb6pCobiX33KWcu6ttj8uQOPCiUojHMfuH+xVOQHLS
	 jZBnJiv1reCLcnbHSyXN+xB9AJRM2qaD+2q7ZSLNzLMnzXQ0kw5cBmlKhyZYZmMZrq
	 KLeAlkyHmpeqHKeqo/blXABmpIMwgkczstQUxggc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726388AbfLaDUz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 30 Dec 2019 22:20:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:59168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725813AbfLaDUz (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 30 Dec 2019 22:20:55 -0500
Received: from zzz.tds (h75-100-12-111.burkwi.broadband.dynamic.tds.net [75.100.12.111])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6F01920748
        for <linux-crypto@vger.kernel.org>; Tue, 31 Dec 2019 03:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577762454;
        bh=Ym52PuGdKcvcb/SXwku4G3+tvPGZHkPzG/UhdznB2Tc=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=NOFK4Rj8aaICLhfXsQfmdRPBVJNM7rt6nQrELP0tc4ueZ/TA3j4CWMr0guHc4Cdm6
         ev5seFVDZxBCX6FEy1cjujsq26HknJbVIj+cc54oE8IWRqT/a8FUVQ2Prm43TwDnI1
         E+xZ1RWXEef+sdiRYZnnS0PxGK416WJZm7BX2JuY=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 3/8] crypto: atmel-sha - fix error handling when setting hmac key
Date:   Mon, 30 Dec 2019 21:19:33 -0600
Message-Id: <20191231031938.241705-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191231031938.241705-1-ebiggers@kernel.org>
References: <20191231031938.241705-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

HMAC keys can be of any length, and atmel_sha_hmac_key_set() can only
fail due to -ENOMEM.  But atmel_sha_hmac_setkey() incorrectly treated
any error as a "bad key length" error.  Fix it to correctly propagate
the -ENOMEM error code and not set any tfm result flags.

Fixes: 81d8750b2b59 ("crypto: atmel-sha - add support to hmac(shaX)")
Cc: Nicolas Ferre <nicolas.ferre@microchip.com>
Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc: Ludovic Desroches <ludovic.desroches@microchip.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/crypto/atmel-sha.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/crypto/atmel-sha.c b/drivers/crypto/atmel-sha.c
index e8e4200c1ab3..d3bcd14201c2 100644
--- a/drivers/crypto/atmel-sha.c
+++ b/drivers/crypto/atmel-sha.c
@@ -1853,12 +1853,7 @@ static int atmel_sha_hmac_setkey(struct crypto_ahash *tfm, const u8 *key,
 {
 	struct atmel_sha_hmac_ctx *hmac = crypto_ahash_ctx(tfm);
 
-	if (atmel_sha_hmac_key_set(&hmac->hkey, key, keylen)) {
-		crypto_ahash_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
-		return -EINVAL;
-	}
-
-	return 0;
+	return atmel_sha_hmac_key_set(&hmac->hkey, key, keylen);
 }
 
 static int atmel_sha_hmac_init(struct ahash_request *req)
-- 
2.24.1

