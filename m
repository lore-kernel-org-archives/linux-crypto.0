Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B24CECAAD2
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Aug 2022 05:32:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229455AbiHZFcH (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Aug 2022 01:32:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244898AbiHZFcE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Aug 2022 01:32:04 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03975CEB32
        for <linux-crypto@vger.kernel.org>; Thu, 25 Aug 2022 22:31:59 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id x14-20020a17090a8a8e00b001fb61a71d99so7070437pjn.2
        for <linux-crypto@vger.kernel.org>; Thu, 25 Aug 2022 22:31:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc;
        bh=oJblIJepf+htjTC3ekQFWoY3FZ9v/SVHSuA1T70fx5M=;
        b=JUTs+sMad4ug1dMd0Q+ncUvVi+FHxDDF+97T6//YsrXS/6GBHoQXo1eUkIHGeSl382
         6kp4eaU4XwVbhGvvpIP0p4h7/7CV+SpFY5gsEG8U0BIRg4agr5cFSgL7AZoxvapivSsc
         GZSfj+TjLG8HNFc/BhhW1pvNY5hEbuR9MK/8c8f84/6QtXSyftRAAtVoPjhsvJtHLY3S
         JDWgl4jdblSoBXsftfi8Q26mjM0UE/aSUzw2lfDv6aZxUQVW5SgejwCSgg7tTf9C2czN
         emj/v5VzbUosr3/Vg3uUh+99G4wMwpVxfPpG2XvreaR+zvsDBNhHpkkJgqLCy6WQooP/
         8s6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc;
        bh=oJblIJepf+htjTC3ekQFWoY3FZ9v/SVHSuA1T70fx5M=;
        b=AHD+Ef8s/GZK6GcQysURKEU4QFFgv7pe+TVghKGOUbQFRgBmOpz84KHncv8+t78pkG
         KNJ5viHXkWtD7bwrUupyABir3ovI/3OVDlSKb4Rm5wSuhkw9xcVEwiG8rE2JiUi/Up2G
         /IxycENhGtvmCjq9VXhx0oVDm4q3TIjua1LFwmMuQLE9xP3wBXb4D/30Bcyk4l+7ztb3
         KLDiPR8BSGgGRaKnry+beJ+wmF1alYLNhBiedTLM9P6ip5ERA0ZJXvM8KgPqgnYueZjs
         ABAQTAVklpeB1WrLYcMPwsC6G8DCaekIT1pEV/+kFUUEuwT+OcL9Ex9BStgY3Pr/8xnM
         uCVQ==
X-Gm-Message-State: ACgBeo3brroVgdJOtHcPwKh0VXwLy72aBjjJgtrKEawr77Upt9wWGcDg
        n5mosKEiiOK4OUwzU9dGUU67BGWPBIo=
X-Google-Smtp-Source: AA6agR4v3wEtAX8VmSFiLA5NzTgmevN8eWe+CCJFhkV9UIRcKL2kHYVgb+oToC9le5Fpiw3SzFokdA==
X-Received: by 2002:a17:90b:198e:b0:1fb:fb8:1072 with SMTP id mv14-20020a17090b198e00b001fb0fb81072mr2670683pjb.51.1661491917978;
        Thu, 25 Aug 2022 22:31:57 -0700 (PDT)
Received: from localhost.localdomain ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id i15-20020a170902c94f00b00172925f3c79sm545726pla.153.2022.08.25.22.31.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Aug 2022 22:31:56 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com
Cc:     elliott@hpe.com, ap420073@gmail.com
Subject: [PATCH v2 3/3] crypto: tcrypt: add async speed test for aria cipher
Date:   Fri, 26 Aug 2022 05:31:31 +0000
Message-Id: <20220826053131.24792-4-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220826053131.24792-1-ap420073@gmail.com>
References: <20220826053131.24792-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

In order to test for the performance of aria-avx implementation, it needs
an async speed test.
So, it adds async speed tests to the tcrypt.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v2:
 - No changes

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

