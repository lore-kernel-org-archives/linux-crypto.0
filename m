Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04F0BC41535
	for <linux-crypto@archiver.kernel.org>; Sun, 29 Oct 2023 20:48:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230440AbjJ2Usw (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 29 Oct 2023 16:48:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230382AbjJ2Usu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 29 Oct 2023 16:48:50 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77301E9
        for <linux-crypto@vger.kernel.org>; Sun, 29 Oct 2023 13:48:45 -0700 (PDT)
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com [209.85.221.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 8B1B63FD43
        for <linux-crypto@vger.kernel.org>; Sun, 29 Oct 2023 20:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1698612522;
        bh=D+t9WK33ZVldEiPiicjGvkN9bUf9a57a5jRCbansvZI=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=mJJ1DesxL5h7yD2e+dj0Bt7Rf0uR30tQWbKWMVrs7RpZPt0x0VTQzcBbAldUv1Jzg
         g+dRrFBcDwcFAO2563QVNeKUl2w62anucHFjS10I4aPhwQI6oWz3SQZB9wgABps2vY
         c/MQCS/NZ/WP9RmMKI/KNQtuBrsMkp4rznZTBYvDPkM7NLOPy80h8EB08E16Zxl8sN
         pU0suALW5hrNa8vo9nSAfQZ1adt2d/Y6qCT+2TVkMISL7WMQY9ZzfwrYSCnnezm9OQ
         dVL8yJZu7FtS6E/LPwqJYA7+pb4ph5/Y3yDu1dx5XlTlnS+TJikM4hPdsh+3y/Ht21
         45dHeHvETzx1g==
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-32f521150aaso1819523f8f.1
        for <linux-crypto@vger.kernel.org>; Sun, 29 Oct 2023 13:48:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698612517; x=1699217317;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D+t9WK33ZVldEiPiicjGvkN9bUf9a57a5jRCbansvZI=;
        b=M4AcdxX6TzvQBsnI0S6QV+QnTCbanMeW7TQ99dNv0ws/X0yRJ6YQfEHMrl/3SFshHr
         hz8TJu+VZARA2Rwkk50Mm6qpsgvN2aG8y8V5ZUU7P5w3S3trqOXr1qlQ9t7YGJfXx5hk
         hwAqWFmnxpTvKMFd8FgmWIq59iPAXBLU5L4BNKY6XXvT+hNIXJIySmNLVPg9d7wZck71
         ynuJnStscY+xcw/nkF2+F3fkb0hFiDp8vzCbmDezouarHC+qtt4s17uIEY3SxRU56ykw
         WImzu/DB0A95mvpkZdwUCbVivSv+1VMPCfq160LwfmefXHBAzDTchQbewHsVe+BcHmWR
         kNXg==
X-Gm-Message-State: AOJu0YzwHOjzs6NrgpHdcEBkYYuudkW8ioTUkmiNG1CVOaKuJpmONcI3
        IyIlGcvXQ2SzuMu+93RsoY/gCY7cx19CkKPSU/UDSEKxpbA4CzlSGrMLOOQ7Q0RMGNeaK94L4AK
        SrloxbuXnzIP1Xtgg8t2NIHjJZcgqDoN6cE67X6sNpw==
X-Received: by 2002:a05:6000:186c:b0:32f:7c4a:4f28 with SMTP id d12-20020a056000186c00b0032f7c4a4f28mr3694526wri.65.1698612517401;
        Sun, 29 Oct 2023 13:48:37 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHsHenVmm1UaPVZaYRrLCgir8dk0xL3UaoH6fChxyf4x2jNAP6txXUbdB0H3Py4ubLecZFXcQ==
X-Received: by 2002:a05:6000:186c:b0:32f:7c4a:4f28 with SMTP id d12-20020a056000186c00b0032f7c4a4f28mr3694518wri.65.1698612517100;
        Sun, 29 Oct 2023 13:48:37 -0700 (PDT)
Received: from localhost ([2001:67c:1560:8007::aac:c15c])
        by smtp.gmail.com with ESMTPSA id y2-20020adffa42000000b0032f7f4089b7sm3382079wrr.43.2023.10.29.13.48.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Oct 2023 13:48:36 -0700 (PDT)
From:   Dimitri John Ledkov <dimitri.ledkov@canonical.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        simo Sorce <simo@redhat.com>,
        =?UTF-8?q?Stephan=20M=C3=BCller?= <smueller@chronox.de>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] crypto: drbg - ensure drbg hmac sha512 is used in FIPS selftests
Date:   Sun, 29 Oct 2023 22:48:22 +0200
Message-Id: <20231029204823.663930-3-dimitri.ledkov@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231029204823.663930-1-dimitri.ledkov@canonical.com>
References: <20231029204823.663930-1-dimitri.ledkov@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Update code comment, self test & healthcheck to use HMAC SHA512,
instead of HMAC SHA256. These changes are in dead-code, or FIPS
enabled code-paths only and have not effect on usual kernel builds.

On systems booting in FIPS mode that has the effect of switch sanity
selftest to HMAC sha512 based (which has been the default DRBG).

Fixes: 9b7b94683a ("crypto: DRBG - switch to HMAC SHA512 DRBG as default DRBG")
Signed-off-by: Dimitri John Ledkov <dimitri.ledkov@canonical.com>
---
 crypto/drbg.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index b120e2866b..99666193d9 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -111,9 +111,9 @@
  * as stdrng. Each DRBG receives an increasing cra_priority values the later
  * they are defined in this array (see drbg_fill_array).
  *
- * HMAC DRBGs are favored over Hash DRBGs over CTR DRBGs, and
- * the SHA256 / AES 256 over other ciphers. Thus, the favored
- * DRBGs are the latest entries in this array.
+ * HMAC DRBGs are favored over Hash DRBGs over CTR DRBGs, and the
+ * HMAC-SHA512 / SHA256 / AES 256 over other ciphers. Thus, the
+ * favored DRBGs are the latest entries in this array.
  */
 static const struct drbg_core drbg_cores[] = {
 #ifdef CONFIG_CRYPTO_DRBG_CTR
@@ -1475,8 +1475,8 @@ static int drbg_generate(struct drbg_state *drbg,
 		int err = 0;
 		pr_devel("DRBG: start to perform self test\n");
 		if (drbg->core->flags & DRBG_HMAC)
-			err = alg_test("drbg_pr_hmac_sha256",
-				       "drbg_pr_hmac_sha256", 0, 0);
+			err = alg_test("drbg_pr_hmac_sha512",
+				       "drbg_pr_hmac_sha512", 0, 0);
 		else if (drbg->core->flags & DRBG_CTR)
 			err = alg_test("drbg_pr_ctr_aes256",
 				       "drbg_pr_ctr_aes256", 0, 0);
@@ -2023,7 +2023,7 @@ static inline int __init drbg_healthcheck_sanity(void)
 	drbg_convert_tfm_core("drbg_nopr_sha256", &coreref, &pr);
 #endif
 #ifdef CONFIG_CRYPTO_DRBG_HMAC
-	drbg_convert_tfm_core("drbg_nopr_hmac_sha256", &coreref, &pr);
+	drbg_convert_tfm_core("drbg_nopr_hmac_sha512", &coreref, &pr);
 #endif
 
 	drbg = kzalloc(sizeof(struct drbg_state), GFP_KERNEL);
-- 
2.34.1

