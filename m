Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9666C32796
	for <linux-crypto@archiver.kernel.org>; Wed, 24 Aug 2022 15:59:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239245AbiHXP73 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 24 Aug 2022 11:59:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239134AbiHXP71 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 24 Aug 2022 11:59:27 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4C317D1E4
        for <linux-crypto@vger.kernel.org>; Wed, 24 Aug 2022 08:59:18 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id g8so12145421plq.11
        for <linux-crypto@vger.kernel.org>; Wed, 24 Aug 2022 08:59:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc;
        bh=r33vbnbC3ICdUpiPyswA76h0Zvt58All93SEm8vAzto=;
        b=BpzNZHhCe+0qPqupqzlIbhUXy0j3dTKZOiSo0+yXSeABlSVsCZWcyVPQ6U3t5SjNEp
         E9dFC1Vi8ggyalnx8CcQizCiiFDfQLN9v/z8wWTAybw4HrAj+E+vi9+HvLyYc9fphr95
         zKM6uS75ZZ1VHRby3xbBhZ7MbyFdqiSbL2EQ/Bk1/7DR1V4VcBszqjmdBW6uY1u+mdnF
         DcOt4g91NkKmDWda5uQ7r01Ish61c6LMtZ/SW17rbTZm/5iBO7YuwHdJsPByBRD3MI5Y
         64mjYCleEWkvrTaHqNE08Iq+sX/YwdznPpwIE1mwk5JCghE5WbMzHkRh/XyolaLbPjEG
         t1RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc;
        bh=r33vbnbC3ICdUpiPyswA76h0Zvt58All93SEm8vAzto=;
        b=MTdoWuxybVjqJtVwVaWYoixnu/OKVTtqk2w4C3X8dmg8kbdiRT6+/KOw91S75PtfGR
         NBzyC5pBruEvuirZ5v92KOktmUF5uWGE/Ve4SuXM9ThVtqC4jWbnuh8Qy5QR3i2ykLXl
         tkUO39IVFj2hOQjokCUOYOJcBTGZZCek6xfqf9TJ3pJLWRuS+JEdA17S9GbStdC+YHKJ
         NemIFRKYCTHZ7SkpJbHJMrDEGE0VyhakGTnrEVq4A5MdIFSlsJFENAALlJMimQevaWX/
         CjiM8Tglxof4XJ6SWUX/0xpZWKBSCKZIOn1S85S0Sr89KfxitmqLnX6LSRMh7pgDCP29
         UmxA==
X-Gm-Message-State: ACgBeo0XrKgWexGZbNIArBIWvpQ2HZb/xw/jabBJq+Ahi6YGdf0XL9f4
        MrVDLskes/zIyOHey5fOIB7tsF2l2Tw=
X-Google-Smtp-Source: AA6agR7hDWtau73H0gMRXuASnsEScHXSpPpbXvZQU0ju7jUvDplhaLCbHREf2WOKUzpboOm8OOFX/g==
X-Received: by 2002:a17:902:f70a:b0:170:c5e7:874c with SMTP id h10-20020a170902f70a00b00170c5e7874cmr29079629plo.109.1661356757903;
        Wed, 24 Aug 2022 08:59:17 -0700 (PDT)
Received: from localhost.localdomain ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id 12-20020a17090a034c00b001fb438fb772sm1540318pjf.56.2022.08.24.08.59.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Aug 2022 08:59:17 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com
Cc:     ap420073@gmail.com
Subject: [PATCH 3/3] crypto: tcrypt: add async speed test for aria cipher
Date:   Wed, 24 Aug 2022 15:58:52 +0000
Message-Id: <20220824155852.12671-4-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220824155852.12671-1-ap420073@gmail.com>
References: <20220824155852.12671-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

In order to test for the performance of aria-avx implementation, it needs
an async speed test.
So, it adds async speed tests to the tcrypt.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 crypto/tcrypt.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 59eb8ec36664..f36d3bbf88f5 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -2648,6 +2648,13 @@ static int do_test(const char *alg, u32 type, u32 mask, int m, u32 num_mb)
 				speed_template_16);
 		break;
 
+	case 519:
+		test_acipher_speed("ecb(aria)", ENCRYPT, sec, NULL, 0,
+				   speed_template_16_24_32);
+		test_acipher_speed("ecb(aria)", DECRYPT, sec, NULL, 0,
+				   speed_template_16_24_32);
+		break;
+
 	case 600:
 		test_mb_skcipher_speed("ecb(aes)", ENCRYPT, sec, NULL, 0,
 				       speed_template_16_24_32, num_mb);
@@ -2859,6 +2866,12 @@ static int do_test(const char *alg, u32 type, u32 mask, int m, u32 num_mb)
 		test_mb_skcipher_speed("ctr(blowfish)", DECRYPT, sec, NULL, 0,
 				       speed_template_8_32, num_mb);
 		break;
+	case 610:
+		test_mb_skcipher_speed("ecb(aria)", ENCRYPT, sec, NULL, 0,
+				       speed_template_16_32, num_mb);
+		test_mb_skcipher_speed("ecb(aria)", DECRYPT, sec, NULL, 0,
+				       speed_template_16_32, num_mb);
+		break;
 
 	case 1000:
 		test_available();
-- 
2.17.1

