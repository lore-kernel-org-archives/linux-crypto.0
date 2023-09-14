Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A6DDEDE995
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Sep 2023 08:28:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236443AbjINI26 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 14 Sep 2023 04:28:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236519AbjINI2m (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 14 Sep 2023 04:28:42 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A20D2100
        for <linux-crypto@vger.kernel.org>; Thu, 14 Sep 2023 01:28:37 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id d9443c01a7336-1c1ff5b741cso5918215ad.2
        for <linux-crypto@vger.kernel.org>; Thu, 14 Sep 2023 01:28:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694680116; x=1695284916; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FdEqlcPWsYxp5HDjE3Py/AOHU+OcTvL4ZWqDK101xPg=;
        b=ed/P092ZCtT4oxqromSYj6NScBGv0+oOEdkYaS79F519ivDDqkU30PfLoJ23p37CQG
         +7TCWhEkTOVexdHOjvkzHbFKyeorxh3KAcuV4igLwbODwVTRmF3nqFyuZHDfH822PEqw
         n5xMuKiYOJNrja8h5tCy65FKkQw12QzjUZqmgdKbeWu+Gpn6A+B6k5VdDE7TKiDxEPSK
         qNbyzrUIfluN/X7MkGGmr7VOgBWSExTIQGEG0aDH59BYr708bxMQqRJ2ny3b7U+AnQhW
         GAX68PnbZfgWcjRML/PkSbMJoV+tLoXO2OpSjK89iiaX71AnW/N3f2MRaovE+RZcR4pM
         biiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694680116; x=1695284916;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=FdEqlcPWsYxp5HDjE3Py/AOHU+OcTvL4ZWqDK101xPg=;
        b=hP4Pf/ZJDac23GikAWY7ss0/OzxDuc81L/lVWaP8OsePNx53Jy5ZLFBdLM/M3xZbSq
         OhcAao2w/GImcrct8BcWF5QiJSq0zI345t/JIk93zSsSv2YWORgd8F6CHfZcIaww6CyM
         sgwHxeJHPoT6ajUI2/6oWEikHQwF9fu/wi7mDuc/IhZ7zR0iOm6gAvhlLMDfqVWDF6/1
         PVjQJ9hC+5OhdA3G9qF3y46I0yll85GuIEKGTsjbSHTzP5Q6PImdvHUzJfvuXTMStpp7
         gqSf/u5d69/vogRC+hTigzecg+bV6d1+4pDcEQ0otrdRzOjcWmx8dbNfPGjCuZqM0C8d
         giSQ==
X-Gm-Message-State: AOJu0YyigQ19L28R1E6RXu3fNSVci3dDAjSglFxJNDgm45Y80OEPxBCd
        pEVeRtp7x2oP0ebStR7rSHwRvRGwz/A=
X-Google-Smtp-Source: AGHT+IEBC2VZv5BbWKKBOvcNrYFg3lTmRsu/AOEHUcDiwfnoJ2JEel5B1tEUZWC/Slqlma3whI7OZg==
X-Received: by 2002:a17:902:c403:b0:1c3:f745:1cd5 with SMTP id k3-20020a170902c40300b001c3f7451cd5mr3181302plk.34.1694680116535;
        Thu, 14 Sep 2023 01:28:36 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([2404:c804:1b2a:5507:c00a:8aff:fe00:b003])
        by smtp.gmail.com with ESMTPSA id b13-20020a170902d50d00b001bba3a4888bsm976242plg.102.2023.09.14.01.28.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Sep 2023 01:28:36 -0700 (PDT)
Sender: Herbert Xu <herbertx@gmail.com>
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc:     Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 6/8] crypto: testmgr - Add support for lskcipher algorithms
Date:   Thu, 14 Sep 2023 16:28:26 +0800
Message-Id: <20230914082828.895403-7-herbert@gondor.apana.org.au>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230914082828.895403-1-herbert@gondor.apana.org.au>
References: <20230914082828.895403-1-herbert@gondor.apana.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Test lskcipher algorithms using the same logic as cipher algorithms.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/testmgr.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 216878c8bc3d..aed4a6bf47ad 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -5945,6 +5945,25 @@ int alg_test(const char *driver, const char *alg, u32 type, u32 mask)
 	return rc;
 
 notest:
+	if ((type & CRYPTO_ALG_TYPE_MASK) == CRYPTO_ALG_TYPE_LSKCIPHER) {
+		char nalg[CRYPTO_MAX_ALG_NAME];
+
+		if (snprintf(nalg, sizeof(nalg), "ecb(%s)", alg) >=
+		    sizeof(nalg))
+			goto notest2;
+
+		i = alg_find_test(nalg);
+		if (i < 0)
+			goto notest2;
+
+		if (fips_enabled && !alg_test_descs[i].fips_allowed)
+			goto non_fips_alg;
+
+		rc = alg_test_skcipher(alg_test_descs + i, driver, type, mask);
+		goto test_done;
+	}
+
+notest2:
 	printk(KERN_INFO "alg: No test for %s (%s)\n", alg, driver);
 
 	if (type & CRYPTO_ALG_FIPS_INTERNAL)
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

