Return-Path: <SRS0=xIDj=ZV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB1C7C432C0
	for <linux-crypto@archiver.kernel.org>; Fri, 29 Nov 2019 18:24:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B53AB21736
	for <linux-crypto@archiver.kernel.org>; Fri, 29 Nov 2019 18:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1575051859;
	bh=hRREJsy40CatH0AaogDQyxLMyyXcdvCKth2Ur8Mmybo=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=hyxZFsBM49D53LbAAAaiN4m3hBfnmDex4eU0O+qRFBEvU19eqh7AADabe18pCxtYn
	 uMKxHkBMd6UwmkHPwLNw0oiv1mc7TFjlQ0DceIB4gSXE6Hy/soaWguWTxM9RvnSsyQ
	 rr4qcFCf1xj+v5dToZE8iw34tJfyZNSCYy5Atiwc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727073AbfK2SYT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 29 Nov 2019 13:24:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:57250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727005AbfK2SYS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 29 Nov 2019 13:24:18 -0500
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CBF84217AB
        for <linux-crypto@vger.kernel.org>; Fri, 29 Nov 2019 18:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575051857;
        bh=hRREJsy40CatH0AaogDQyxLMyyXcdvCKth2Ur8Mmybo=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=oYRs39XGZ8OlgyRK4R9OxnsXMdePiX/z41trHpALdDvqfTSx+mBVfRhaMe+1YQ1n4
         VSohQYQfWEWzKxWJi0JDuc0Zw6CS0Pik3HBkdSsILgfbfS9FKtvWttD2rmCODyx10a
         OXClkzsnHiP+5CDe9EBpwTWwB/sLCZo/3aFujN2E=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 6/6] crypto: skcipher - remove crypto_skcipher_extsize()
Date:   Fri, 29 Nov 2019 10:23:08 -0800
Message-Id: <20191129182308.53961-7-ebiggers@kernel.org>
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
crypto_skcipher_extsize() now simply calls crypto_alg_extsize().  So
remove it and just use crypto_alg_extsize().

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/skcipher.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index e4e4a445dc66..39a718d99220 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -578,11 +578,6 @@ int skcipher_walk_aead_decrypt(struct skcipher_walk *walk,
 }
 EXPORT_SYMBOL_GPL(skcipher_walk_aead_decrypt);
 
-static unsigned int crypto_skcipher_extsize(struct crypto_alg *alg)
-{
-	return crypto_alg_extsize(alg);
-}
-
 static void skcipher_set_needkey(struct crypto_skcipher *tfm)
 {
 	if (crypto_skcipher_max_keysize(tfm) != 0)
@@ -749,7 +744,7 @@ static int crypto_skcipher_report(struct sk_buff *skb, struct crypto_alg *alg)
 #endif
 
 static const struct crypto_type crypto_skcipher_type = {
-	.extsize = crypto_skcipher_extsize,
+	.extsize = crypto_alg_extsize,
 	.init_tfm = crypto_skcipher_init_tfm,
 	.free = crypto_skcipher_free_instance,
 #ifdef CONFIG_PROC_FS
-- 
2.24.0

