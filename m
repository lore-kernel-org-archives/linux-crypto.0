Return-Path: <SRS0=Fqdl=U3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15FE7C4321A
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 09:36:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DDF75208E3
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 09:36:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="R99wdz+l"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726752AbfF1JgJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 Jun 2019 05:36:09 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:33750 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726739AbfF1JgJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Jun 2019 05:36:09 -0400
Received: by mail-wm1-f65.google.com with SMTP id h19so8945066wme.0
        for <linux-crypto@vger.kernel.org>; Fri, 28 Jun 2019 02:36:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GlTPPuF7VX+eSXKr9xKNOwcbjbSTX6Pw4/5JxljOKbg=;
        b=R99wdz+loj1jCCpsahOFYH1v1p70KWDmPGBsVi0AwcVVfSwbMDhdaxhIeIdokvbMv5
         66koERHSLQPo+V+rA6dT0QD5hF0zr1nShxLeHqzp+OFucrD8+BGUnZIzlMaPyGfMJ66P
         p5KoQ02ZMJqGwAIUkwpj4yN4ZcG+5iPOqG14Nam+iYSs0HlGU56ok6CoCFNY6opzNlPQ
         rnud2xdn0TUNGWsNHDTg9mZKJ76bjqzkzt1A1hHBYqxqE7kUA9N43+TJW6l8k1IjKEn2
         XnsU5sfpzd7PQWvNCNvxI3rlvPQmaG0PCkU4/JVZUcmiv9fN42m+UB/knQpTylqZtHRS
         xsAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GlTPPuF7VX+eSXKr9xKNOwcbjbSTX6Pw4/5JxljOKbg=;
        b=inBN1uPJQn5GfNZ/wapulZVKUuF393hEhyviW2skJTfdaTYFdNzXU3kGb3iwzi2gTf
         h65Zf2UgsEG3ijGybZSW4d5gm2AX5bxuaWtQx8kvdPxU8fGiNoPj4EK3PUEHJN3/2a+/
         vDUZQ8bje1jPw33cu+yg1mrepqmAQOqQlniUhq0+Nm9QgYkoMoBnsTCZZ3liwdeNwzam
         55eaDC9uXhNeFa9FgyuVOwM+4W7rFvDEzVDD3ARNDDmPRyAfb1tEoL/xZ0lPvZb2iomR
         FX6MS3wIPYanoYBhvxsywfgRuXXoxTA7o/hfbREO2HWJUdQD6Bbuj56Ku5+MvaLtsmXk
         sjEQ==
X-Gm-Message-State: APjAAAVX+6SEFeq/oX0BaivfLfLYzS6Ner/kHJCkKZCEFFW3+tAQMk09
        LIsd/K2O1PZj87j2HObEFFlFtsIBb4l0oA==
X-Google-Smtp-Source: APXvYqwcYqIOOLN2Fh90zDySJ9PL9TQUMx4ErdqkO4hIhIhgBitUfvtJDgjvWjkuGkFPs8E92myX9A==
X-Received: by 2002:a1c:4b1a:: with SMTP id y26mr6562300wma.105.1561714566492;
        Fri, 28 Jun 2019 02:36:06 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id m24sm1709910wmi.39.2019.06.28.02.36.05
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 28 Jun 2019 02:36:05 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        horia.geanta@nxp.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v3 26/30] crypto: des - remove unused function
Date:   Fri, 28 Jun 2019 11:35:25 +0200
Message-Id: <20190628093529.12281-27-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190628093529.12281-1-ard.biesheuvel@linaro.org>
References: <20190628093529.12281-1-ard.biesheuvel@linaro.org>
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

