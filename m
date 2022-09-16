Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2F3EC54EE9
	for <linux-crypto@archiver.kernel.org>; Fri, 16 Sep 2022 12:58:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231144AbiIPM6U (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 16 Sep 2022 08:58:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230255AbiIPM6J (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 16 Sep 2022 08:58:09 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 936BB82848
        for <linux-crypto@vger.kernel.org>; Fri, 16 Sep 2022 05:58:08 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id w20so9298154ply.12
        for <linux-crypto@vger.kernel.org>; Fri, 16 Sep 2022 05:58:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date;
        bh=MChY+3qzFMbti+v+jshiVlILus9rn7tvRtsJY0xB/tc=;
        b=Mlk2GRrTHcYfmHOUIWnlc4yzE6V3qsJquhHE0yZmKaxLkJSGm8fr+zcpdPofwzPBKw
         E7I8j4lrRIMiQgaOeDMs0EtxVMXUmLPc/sFuenGv4Ctj5MoB9vnzDdSYoTNYWMmcY1hM
         7FCtRF40hXmwAEToDmFixDDS0XQYnIWVa02jJtLKsqpR65IeEhQuoK73xmbYa7JXNz9v
         NjV1QYr33tzh6V5GDPR+15k7RQ/N8cK/vBQoHlzPj5Jr3a4kbeYIjm28AauDu0GXGhV0
         m5pYMd8NsNW8G48oWerO64C3ADA04HW5JjZvuARe3MrRS7/DAD2Ns1KOMjz97Dp++t3i
         tcsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date;
        bh=MChY+3qzFMbti+v+jshiVlILus9rn7tvRtsJY0xB/tc=;
        b=TbK5QnOYbl0bS+nQ30rCuOBS871DJqgVPK8lK1K8UZJUr+oGCe4dGQoXkZD+K7wvfb
         tRz4jMYk9DqBfUVXjQr6pRWemz8DxWf/keQuEzJIOjaJElB0Os823O4CrdHQjW4Fwdb7
         oV54H/VuKvtTIiBsiUdrhcZrCYwEDbCUIPA+eUNKA3h75mF6qlhn/hV1FmcHqvOZklWe
         CuZ/YmwDP3cBOqUkQ0iWlNbIdtF3TT3W8m6KN5fsCFENyxbj1nNiy7aTUEa+pA8wjMCC
         0oOEcg9CpT29rRkYnk2rScTYW9KfRIsrFGg+RWWGNkBNhXcEfDwtv3hI5r86/Pjljn17
         NLmg==
X-Gm-Message-State: ACrzQf3gnrVMpgWc2MS0lEeXXOOsgueEDu5Wh3zSHRbCGBXREuMRUko4
        Y+u7iA9CbYBp7/S/AgrjsfRMAmoQ8QE=
X-Google-Smtp-Source: AMsMyM4gTnbxAfe8QXCYM8adrFI04c0a/My93YmR+26pgdGu+H5yHCOa82Tlbfoc7Gkz983A0WJpSg==
X-Received: by 2002:a17:902:6a8a:b0:173:14f5:1d89 with SMTP id n10-20020a1709026a8a00b0017314f51d89mr4583279plk.89.1663333087775;
        Fri, 16 Sep 2022 05:58:07 -0700 (PDT)
Received: from localhost.localdomain ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id f20-20020a170902f39400b0017829a3df46sm11941062ple.204.2022.09.16.05.58.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Sep 2022 05:58:07 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, jussi.kivilinna@iki.fi, elliott@hpe.com,
        peterz@infradead.org
Cc:     ap420073@gmail.com
Subject: [PATCH v4 3/3] crypto: tcrypt: add async speed test for aria cipher
Date:   Fri, 16 Sep 2022 12:57:36 +0000
Message-Id: <20220916125736.23598-4-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220916125736.23598-1-ap420073@gmail.com>
References: <20220916125736.23598-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

In order to test for the performance of aria-avx implementation, it needs
an async speed test.
So, it adds async speed tests to the tcrypt.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v4:
 - No changes.

v3:
 - Add aria-ctr async speed test.
 - Add aria-gcm multi buffer speed test

v2:
 - No changes.

 crypto/tcrypt.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index e85f623c3c54..a82679b576bb 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -2205,6 +2205,13 @@ static int do_test(const char *alg, u32 type, u32 mask, int m, u32 num_mb)
 				NULL, 0, 16, 8, speed_template_16_24_32);
 		break;
 
+	case 229:
+		test_mb_aead_speed("gcm(aria)", ENCRYPT, sec, NULL, 0, 16, 8,
+				   speed_template_16, num_mb);
+		test_mb_aead_speed("gcm(aria)", DECRYPT, sec, NULL, 0, 16, 8,
+				   speed_template_16, num_mb);
+		break;
+
 	case 300:
 		if (alg) {
 			test_hash_speed(alg, sec, generic_hash_speed_template);
@@ -2625,6 +2632,17 @@ static int do_test(const char *alg, u32 type, u32 mask, int m, u32 num_mb)
 				speed_template_16);
 		break;
 
+	case 519:
+		test_acipher_speed("ecb(aria)", ENCRYPT, sec, NULL, 0,
+				   speed_template_16_24_32);
+		test_acipher_speed("ecb(aria)", DECRYPT, sec, NULL, 0,
+				   speed_template_16_24_32);
+		test_acipher_speed("ctr(aria)", ENCRYPT, sec, NULL, 0,
+				   speed_template_16_24_32);
+		test_acipher_speed("ctr(aria)", DECRYPT, sec, NULL, 0,
+				   speed_template_16_24_32);
+		break;
+
 	case 600:
 		test_mb_skcipher_speed("ecb(aes)", ENCRYPT, sec, NULL, 0,
 				       speed_template_16_24_32, num_mb);
@@ -2836,6 +2854,18 @@ static int do_test(const char *alg, u32 type, u32 mask, int m, u32 num_mb)
 		test_mb_skcipher_speed("ctr(blowfish)", DECRYPT, sec, NULL, 0,
 				       speed_template_8_32, num_mb);
 		break;
+
+	case 610:
+		test_mb_skcipher_speed("ecb(aria)", ENCRYPT, sec, NULL, 0,
+				       speed_template_16_32, num_mb);
+		test_mb_skcipher_speed("ecb(aria)", DECRYPT, sec, NULL, 0,
+				       speed_template_16_32, num_mb);
+		test_mb_skcipher_speed("ctr(aria)", ENCRYPT, sec, NULL, 0,
+				       speed_template_16_32, num_mb);
+		test_mb_skcipher_speed("ctr(aria)", DECRYPT, sec, NULL, 0,
+				       speed_template_16_32, num_mb);
+		break;
+
 	}
 
 	return ret;
-- 
2.17.1

