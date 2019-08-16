Return-Path: <SRS0=FgZY=WM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D4E6C3A59C
	for <linux-crypto@archiver.kernel.org>; Fri, 16 Aug 2019 12:35:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7118020644
	for <linux-crypto@archiver.kernel.org>; Fri, 16 Aug 2019 12:35:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="G2N/p4oN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726981AbfHPMf5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 16 Aug 2019 08:35:57 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:38176 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727194AbfHPMf5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 16 Aug 2019 08:35:57 -0400
Received: by mail-wm1-f65.google.com with SMTP id m125so3946465wmm.3
        for <linux-crypto@vger.kernel.org>; Fri, 16 Aug 2019 05:35:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=KwGTj9MadW2uA0xPCMC6ymqxz6VCNxTyOA8nd35Nmhw=;
        b=G2N/p4oNYSX6WLzGsJakUi/5/XgFJwLKRg+H0yInBrVM2nkFfdOnO4Sx5s7Fk+gt+i
         TXVl2hd890+fbbTtcL6wZn2bXmG/h/evEim9nlO3K8N8PC3+2DG66FLb7uytohKZeBJv
         nnCPESUKDDEX3DVKDkhHQzmLgJUTelAOVMKqlRHdnY6KVb1ZMo2bx9IMpkfOlY9y8A8N
         HDIfSDDkrJt9/zZKlgVDFVHuZmQTqabhOGEsifXkrh1+aDmDx/ciLawbkzz8dFqcmV2B
         b8Fa2hGOsgKY0NLtPiI0jMVbMXCt/Xe/vDl0aTJP0eaFxBIeCcWnkeCrrkSg56GVcHcL
         0tPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=KwGTj9MadW2uA0xPCMC6ymqxz6VCNxTyOA8nd35Nmhw=;
        b=Q9C/n+H7YeEfUX3p0YHnmqWoRhzzZTthZWV9md8YZ2MBttk75dink5B6T3CmvBcRve
         LPp1Ra7S7A31wg9tt4ChOW4DLPFIaQIzJ9Q8ZrP1Z2yVWQyXWDl8MzMLbrgex7YOBWUz
         8bmD3P0jdMTFRZXSTdp5s+oy1ir/wQuJ241RDvkAf2TmqCe4y6HoqfiulE7If6qw0V+A
         Zm95jYI0KiaAW355U6xLgozmwuUKvLo0FH5idC4U3SRdM8NbNOMo8jR1+2gJVeRL8i1Q
         L28FXwB0eCKAidSLvbZ8f4SSzt9YgBpygul6RL57geLKNotjJNtx0qdbmPgJJtKmeeeM
         uUGA==
X-Gm-Message-State: APjAAAXhXt9CnhHcE05lcAtxws7HBYS97mnwcSJgtoxJUe+ztubkcpqK
        mYf5ABb0AHcVX6G5imtEU/bpJSMCeRSQZWgp
X-Google-Smtp-Source: APXvYqwJPq+mvMHYfkzSJaDaNtdr6H+t7bT2MA2LX8QUMIl5otvakbRDAVgnuIpYHjNgWcnblXOPeg==
X-Received: by 2002:a1c:a957:: with SMTP id s84mr7308060wme.65.1565958955178;
        Fri, 16 Aug 2019 05:35:55 -0700 (PDT)
Received: from localhost.localdomain ([2a02:587:a407:da00:f1b5:e68c:5f7f:79e7])
        by smtp.gmail.com with ESMTPSA id o17sm4427187wrx.60.2019.08.16.05.35.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 16 Aug 2019 05:35:54 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        linux-s390@vger.kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH] crypto: s390/xts-aes - invoke fallback for ciphertext stealing
Date:   Fri, 16 Aug 2019 15:35:45 +0300
Message-Id: <20190816123545.22848-1-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

For correctness and compliance with the XTS-AES specification, we are
adding support for ciphertext stealing to XTS implementations, even
though no use cases are known that will be enabled by this.

Since the s390 implementation already has a fallback skcipher standby
for other purposes, let's use it for this purpose as well. If ciphertext
stealing use cases ever become a bottleneck, we can always revisit this.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/s390/crypto/aes_s390.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/s390/crypto/aes_s390.c b/arch/s390/crypto/aes_s390.c
index dc0f72dd6e03..a34faadc757e 100644
--- a/arch/s390/crypto/aes_s390.c
+++ b/arch/s390/crypto/aes_s390.c
@@ -512,7 +512,7 @@ static int xts_aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
 	unsigned long fc;
 	int err;
 
-	err = xts_check_key(tfm, in_key, key_len);
+	err = xts_fallback_setkey(tfm, in_key, key_len);
 	if (err)
 		return err;
 
@@ -529,7 +529,7 @@ static int xts_aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
 	/* Check if the function code is available */
 	xts_ctx->fc = (fc && cpacf_test_func(&km_functions, fc)) ? fc : 0;
 	if (!xts_ctx->fc)
-		return xts_fallback_setkey(tfm, in_key, key_len);
+		return 0;
 
 	/* Split the XTS key into the two subkeys */
 	key_len = key_len / 2;
@@ -586,7 +586,7 @@ static int xts_aes_encrypt(struct blkcipher_desc *desc,
 	struct s390_xts_ctx *xts_ctx = crypto_blkcipher_ctx(desc->tfm);
 	struct blkcipher_walk walk;
 
-	if (unlikely(!xts_ctx->fc))
+	if (unlikely(!xts_ctx->fc || (nbytes % XTS_BLOCKSIZE) != 0))
 		return xts_fallback_encrypt(desc, dst, src, nbytes);
 
 	blkcipher_walk_init(&walk, dst, src, nbytes);
@@ -600,7 +600,7 @@ static int xts_aes_decrypt(struct blkcipher_desc *desc,
 	struct s390_xts_ctx *xts_ctx = crypto_blkcipher_ctx(desc->tfm);
 	struct blkcipher_walk walk;
 
-	if (unlikely(!xts_ctx->fc))
+	if (unlikely(!xts_ctx->fc || (nbytes % XTS_BLOCKSIZE) != 0))
 		return xts_fallback_decrypt(desc, dst, src, nbytes);
 
 	blkcipher_walk_init(&walk, dst, src, nbytes);
-- 
2.17.1

