Return-Path: <SRS0=RljO=UV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26693C48BE0
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Jun 2019 00:32:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F00942084E
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Jun 2019 00:32:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="iPi8nc45"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726246AbfFVAcN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 21 Jun 2019 20:32:13 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:34629 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726237AbfFVAcN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Jun 2019 20:32:13 -0400
Received: by mail-wr1-f67.google.com with SMTP id k11so8144751wrl.1
        for <linux-crypto@vger.kernel.org>; Fri, 21 Jun 2019 17:32:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GlTPPuF7VX+eSXKr9xKNOwcbjbSTX6Pw4/5JxljOKbg=;
        b=iPi8nc45G1O5UoLYxlDzUR4fdl2tpSItDMz/Dr+rvbkBvg9zqZ4sNo/1JU69yl0OiU
         Gt1aKpxu2Pv3kUMm0eVdt5mPhmdc2LLF4Ql3QpXImq+rnMOBryPuKg4r3tzi2vF9+aTT
         c2KvnpiPtFbWLMkT3hOHQ9BZ4w8drzRQJuc3ysDWb3tHng6RDGPT3+ypSWhXKwXC6NRd
         JIcYmomeywsftvZogkuScilR2M+ap0xkgDitcksqyTEpxD+5Mz9JPz++6BZXNHD+gwDG
         sux2XrdfFwpJyolnaWQZwu9xa9qAxbhVjH5NYSiS7KNZQwLRTi+jn7JK7Q5nY7MV2Fwp
         Ki1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GlTPPuF7VX+eSXKr9xKNOwcbjbSTX6Pw4/5JxljOKbg=;
        b=K6JRl5R+br6DBCi4IVLDFvjRzZ7JobDael1laynAGVM0vQ0xgDin7mw0SXhBawcK8n
         ZciE6LuVdzlVuQQmQ/5VSwq31jGN8NXUBlPl5BHK9sOsqNEciagUNP6wYqxbU8M+i2ET
         iMQnx5bEm/sJaKC5P02naxpsfw1gQS5IYnCFxJGqOZkfsAOuegXWzyXVUoLp5x7ubEDp
         3W+c5N38cLR2jK2f4QtyPVxcJ+UW1wHQTQd8frHye7Tep9xLQkT3hQG2z57yw1IHnMQC
         sRM4l0Q4BfuKygiaJF1dBzBS9vTfj1EbUhawCHP2P1yvlYaG2mVpxOioncLvD3VGa0UR
         Gzkw==
X-Gm-Message-State: APjAAAUdXoVnPRGTYVWzuX1VFE2FrtfcqvFGimld24E79KeoKhBKcrDd
        E56p6o634dg1+RZp/8ZEDwMVnA2c9Bzmg4cq
X-Google-Smtp-Source: APXvYqzOhWhOkXipjXDOVjoy10YfOlnBa2u7Rbt7JnhLaMjgzFtH4cQzlomr7/RylSeYamjESR4aqQ==
X-Received: by 2002:adf:fc45:: with SMTP id e5mr6733064wrs.240.1561163531312;
        Fri, 21 Jun 2019 17:32:11 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:99d4:1ff0:ed6:dfbb])
        by smtp.gmail.com with ESMTPSA id v18sm4792019wrd.51.2019.06.21.17.32.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 21 Jun 2019 17:32:10 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@google.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC PATCH 26/30] crypto: des - remove unused function
Date:   Sat, 22 Jun 2019 02:31:08 +0200
Message-Id: <20190622003112.31033-27-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190622003112.31033-1-ard.biesheuvel@linaro.org>
References: <20190622003112.31033-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Remove the old DES3 verification functions that are no longer used.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 include/crypto/des.h | 41 --------------------
 1 file changed, 41 deletions(-)

diff --git a/include/crypto/des.h b/include/crypto/des.h
index 72c7c8e5a5a7..31b04ba835b1 100644
--- a/include/crypto/des.h
+++ b/include/crypto/des.h
@@ -19,47 +19,6 @@
 #define DES3_EDE_EXPKEY_WORDS	(3 * DES_EXPKEY_WORDS)
 #define DES3_EDE_BLOCK_SIZE	DES_BLOCK_SIZE
 
-static inline int __des3_verify_key(u32 *flags, const u8 *key)
-{
-	int err = -EINVAL;
-	u32 K[6];
-
-	memcpy(K, key, DES3_EDE_KEY_SIZE);
-
-	if (unlikely(!((K[0] ^ K[2]) | (K[1] ^ K[3])) ||
-		     !((K[2] ^ K[4]) | (K[3] ^ K[5]))) &&
-		     (fips_enabled ||
-		      (*flags & CRYPTO_TFM_REQ_FORBID_WEAK_KEYS)))
-		goto bad;
-
-	if (unlikely(!((K[0] ^ K[4]) | (K[1] ^ K[5]))) && fips_enabled)
-		goto bad;
-
-	err = 0;
-
-out:
-	memzero_explicit(K, DES3_EDE_KEY_SIZE);
-
-	return err;
-
-bad:
-	*flags |= CRYPTO_TFM_RES_WEAK_KEY;
-	goto out;
-}
-
-static inline int des3_verify_key(struct crypto_skcipher *tfm, const u8 *key)
-{
-	u32 flags;
-	int err;
-
-	flags = crypto_skcipher_get_flags(tfm);
-	err = __des3_verify_key(&flags, key);
-	crypto_skcipher_set_flags(tfm, flags);
-	return err;
-}
-
-extern unsigned long des_ekey(u32 *pe, const u8 *k);
-
 extern int __des3_ede_setkey(u32 *expkey, u32 *flags, const u8 *key,
 			     unsigned int keylen);
 
-- 
2.20.1

