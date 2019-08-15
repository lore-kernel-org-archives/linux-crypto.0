Return-Path: <SRS0=pRBs=WL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB1C6C433FF
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Aug 2019 09:02:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 92073218A6
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Aug 2019 09:02:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="W/ovov2u"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730816AbfHOJCM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 15 Aug 2019 05:02:12 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:52610 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730559AbfHOJCL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Aug 2019 05:02:11 -0400
Received: by mail-wm1-f68.google.com with SMTP id o4so678926wmh.2
        for <linux-crypto@vger.kernel.org>; Thu, 15 Aug 2019 02:02:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=pe1t6EIo+yRXqpRd0fashi/U/Hk4eqLBq4nJecNCty0=;
        b=W/ovov2u3wtU15EPm5SECrUm13XhWagQwor2qxMXuxW2Ikx/vrfjdS3x8rOzxRru72
         AwYscZrWdSKOYXDE8E0pWfOc9Wo70FX/G3xID3avY+Iygb5oE9uQfNqF1rK36YOWqojg
         nbVoFWUJjIevv2JZeQASw5S2uvte2VaQ/5qRcK7YT3ZUbQ6HEpRmx0o/4h+5PmM79OKU
         o81pwwgolqTNZv+USmnL1de8R4dkQjRWOIPP9Z2gM5glU39Th1lWsc+PIElFxIqnsEgq
         exudf3z8toOtSfYBprmuunk2kAJOAeEiq20/EHuhWuPYthENxr2sUMrlm+uINXpj7tbC
         L+DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=pe1t6EIo+yRXqpRd0fashi/U/Hk4eqLBq4nJecNCty0=;
        b=boTYDGxyEahQ+bONIsqU0mCp07aBiPUrqxQKmNo2HQYEwgBsbGm9XCHlr9/5hPhbuu
         Ee6sV9B+35z6JeRkr7GcdWlj/lbUePavV3EnwmTG2mdLEtnlbiL6FozjHYztoN8PMBGy
         kqqNmCN2yE5c2ShIilfghG2bjfrlG0YhCSZlJH87kHTjt5i/OuhzKeNUfeaYwJ8SfzjF
         F856g4bbyrFd7sxVgR8VRKr0jIeGiPjVWbtws5fP0KvBgcIvpAY9URAw7AZtjYP+dmvv
         Uk7jedMbG6dUKUi1a56HXUR+vEQMr9hSMZZMziaQ+5lzKbQCtQ6oY8k6guzwUzWVi27s
         j6eg==
X-Gm-Message-State: APjAAAUTRLoTHk5Ut8qeCymHJx6JQFYFW5msuptf8K2b3vPEgOFaSmA7
        f9AxfvS28PlrHjx2NA/kuifwJo2Ri5oWZzQC
X-Google-Smtp-Source: APXvYqwHI/VlUbZBe6cXEhhcLbTaRDiPf5OthGk0ocytITVsNvTMJyWCKyWCDRqdk2SjPg2Hz5zi2w==
X-Received: by 2002:a1c:5a56:: with SMTP id o83mr1664675wmb.103.1565859729783;
        Thu, 15 Aug 2019 02:02:09 -0700 (PDT)
Received: from localhost.localdomain ([2a02:587:a407:da00:f1b5:e68c:5f7f:79e7])
        by smtp.gmail.com with ESMTPSA id x20sm3857533wrg.10.2019.08.15.02.02.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Aug 2019 02:02:09 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v5 26/30] crypto: des - remove unused function
Date:   Thu, 15 Aug 2019 12:01:08 +0300
Message-Id: <20190815090112.9377-27-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190815090112.9377-1-ard.biesheuvel@linaro.org>
References: <20190815090112.9377-1-ard.biesheuvel@linaro.org>
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
2.17.1

