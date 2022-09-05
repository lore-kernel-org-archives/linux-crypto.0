Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91A16ECAAD3
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Sep 2022 09:45:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237163AbiIEJpj (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 5 Sep 2022 05:45:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237333AbiIEJpa (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Sep 2022 05:45:30 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACBFC33E24
        for <linux-crypto@vger.kernel.org>; Mon,  5 Sep 2022 02:45:29 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id p1-20020a17090a2d8100b0020040a3f75eso3216917pjd.4
        for <linux-crypto@vger.kernel.org>; Mon, 05 Sep 2022 02:45:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date;
        bh=zhSZbhhKiPWBvOPbGf5V+IYxN8K7IIW4g7o4RFndtuM=;
        b=Zqqd2+8GwKDPYxYdQUqt8gZQIw7vHd81WKxdefofW3F0eRNAR4vWLBNrQxjVR45X9k
         RNt362g8X4YHGuYuTRzZnFRooYPP+lXXpjwBL/L0B2WE7y5ESmhNw3MIFF5GeUc+Z4pZ
         qPWakA7WHLbJRr9IyPtqeu0rSbAu3eJI8YwuZdzhbPbXxFtbBdqhD/fAUa2IXVo5CpZy
         Ikxcf4IBOjqTW4ru4Ij7WsJDMXevjLW7VWx4Ozffpwc0PndmLyfQTy1NWu1xTi0hdckO
         k23+3dLBiT+m8jS1JGDu9UvbRHxaQNj2JiEJHV8Z9pfjKo2mOJyPlHooWrDu0JQBgFM/
         udmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date;
        bh=zhSZbhhKiPWBvOPbGf5V+IYxN8K7IIW4g7o4RFndtuM=;
        b=4berFOsRIWgC3ehPqjcw0P48v05ZF0zClMBCgWCtWcLv+rscJb7V3EDNlbJAj0AOtr
         yeSPWe4zbN3Yp6Y3dJP7n0NVCbAV3R9UA0T00m4nNFC6VqtHPwv93BhCTMwGdPrY8kQW
         DAcUxupnGTPAEJ/r3r/1kz17DfT1cQ4cCsydhGrY3p/zEEgp3bYEXpJenY9R3IFco0ld
         K6A4wg0F5ExtHvQSqas/71ZjVgsfowmu8ch74BF00eJqcIWy4paoZHH+Ow15pnsCM/VZ
         ID2hlM7qP7ULpBcUdJOuAqE0xi5/XPuy/xA3H2eFVxSWaZ7fHtn+sEDORymoSQSr/laZ
         ud8w==
X-Gm-Message-State: ACgBeo1kATzsW2gV6FUUT7Gg1FY41jPXaktvezSZELU8E+ughjbxpJwI
        VwF2n4ThUt3Wqp3mPl5KX+n2h7GVNYg=
X-Google-Smtp-Source: AA6agR7v8HmP0nLW3hciFh4YhcoNPiKuY8oALw8bN2L3cNIyouqNzL0vjPTB5dyOtjQPzGDU5c6UWQ==
X-Received: by 2002:a17:90a:8d09:b0:1fd:744a:f78 with SMTP id c9-20020a17090a8d0900b001fd744a0f78mr18995804pjo.241.1662371129027;
        Mon, 05 Sep 2022 02:45:29 -0700 (PDT)
Received: from localhost.localdomain ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id b3-20020a170903228300b00176bfd3b6bdsm545617plh.132.2022.09.05.02.45.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Sep 2022 02:45:28 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, jussi.kivilinna@iki.fi, elliott@hpe.com
Cc:     ap420073@gmail.com
Subject: [PATCH v3 3/3] crypto: tcrypt: add async speed test for aria cipher
Date:   Mon,  5 Sep 2022 09:45:03 +0000
Message-Id: <20220905094503.25651-4-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220905094503.25651-1-ap420073@gmail.com>
References: <20220905094503.25651-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

In order to test for the performance of aria-avx implementation, it needs
an async speed test.
So, it adds async speed tests to the tcrypt.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v3:
 - Add ctr(aria) async speed test.
 - Add gcm(aria) multi buffer speed test
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

