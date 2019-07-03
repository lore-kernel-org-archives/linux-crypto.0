Return-Path: <SRS0=EZcf=VA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F6B1C06511
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jul 2019 08:55:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 78FEC218A3
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jul 2019 08:55:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="zlO5fXgV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727004AbfGCIz5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 3 Jul 2019 04:55:57 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:45242 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727056AbfGCIz4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Jul 2019 04:55:56 -0400
Received: by mail-lj1-f194.google.com with SMTP id m23so1485575lje.12
        for <linux-crypto@vger.kernel.org>; Wed, 03 Jul 2019 01:55:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=v0PIVf9kJ6MvTQ8WZzVWxmoyZ6elecqslJ5g4IBD9LA=;
        b=zlO5fXgV7lnU3kXFwn6kwVVN76FkzIcBhnN9xYidaAVf3c6LDy7ovqPCz7Uoryf3sj
         8d19eCWB+fJnCAzfRxXh9oqAOeReDmPomQujOdfcUA0hpT34VQt7PEihhEemE/14IjOb
         kCYs1b3hKkkvQemSZZmuDBWFOXaKT8dQaTeDYUnZanLzarQKWnR0mjRZIBijTHVsnj82
         +ghnbRxlFcf0SSWnzK/ad9PmeJ3SOW+iKem/4JS8IBuxvmC9TssqEiCAFoW+KeAmx/nh
         4LQ66dMxzZRobQ6SDqUmgaG2VBoi5cERM2NReec+loz4JnVLSz8GPfcMhM9o6ZqiHpxe
         VqjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=v0PIVf9kJ6MvTQ8WZzVWxmoyZ6elecqslJ5g4IBD9LA=;
        b=X4NlPyqRMgr22bsITKwAKp8ZJc/EhSvlitkMp6kCT1csVaxcybRiwMqKJfDjSVFGU7
         MI2mLzmKkfJFKE8dU3cazGJ4pAChElAPrpg1Aw0bIpwWxje6NgH4/z/IgvlabrY57TWg
         3di7wIUS4XcM0s1ymBpdvMbVoh5fLV1BjKhVoX8fxxMiVDvNtk2rUKc7/h3GQkG+Ijic
         /UUw0IqEinUarzl2oTG2ii3wXrvs+mononK2fJfHVaeNoaT0SlqRvC6r6kYfjXB3srT5
         nUbCcKivO9gwqkeGZdTUNGiXHeUI+QRGz6FbZ8MV+75NhPCESJLIUwECf72MizmiOqh3
         3mTw==
X-Gm-Message-State: APjAAAVkABEjBuU9PWQF1tdkDnDntwasNHWrKSBqn0tEDDxt+9HW4i88
        HHsj+DhHJmbfCROrhgHE4anj5FizkIAK1Kx5
X-Google-Smtp-Source: APXvYqy+Ip15Qn8Y1pI1rDQCVvh45qnllCIZwFTX73w+d3BLkADVmWcpuaSuXGGpwhXZY8rrNKIA9A==
X-Received: by 2002:a2e:635d:: with SMTP id x90mr20607515ljb.140.1562144154649;
        Wed, 03 Jul 2019 01:55:54 -0700 (PDT)
Received: from e111045-lin.arm.com (89-212-78-239.static.t-2.net. [89.212.78.239])
        by smtp.gmail.com with ESMTPSA id h4sm354529ljj.31.2019.07.03.01.55.53
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 03 Jul 2019 01:55:53 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Eric Biggers <ebiggers@google.com>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steve Capper <steve.capper@arm.com>,
        Milan Broz <gmazyland@gmail.com>
Subject: [PATCH v4 7/7] crypto: tcrypt - add a speed test for AEGIS128
Date:   Wed,  3 Jul 2019 10:55:12 +0200
Message-Id: <20190703085512.13915-8-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190703085512.13915-1-ard.biesheuvel@linaro.org>
References: <20190703085512.13915-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Reviewed-by: Ondrej Mosnacek <omosnace@redhat.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 crypto/tcrypt.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 798253f05203..72dc84e1c647 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -2332,6 +2332,13 @@ static int do_test(const char *alg, u32 type, u32 mask, int m, u32 num_mb)
 				  0, speed_template_32);
 		break;
 
+	case 221:
+		test_aead_speed("aegis128", ENCRYPT, sec,
+				NULL, 0, 16, 8, speed_template_16);
+		test_aead_speed("aegis128", DECRYPT, sec,
+				NULL, 0, 16, 8, speed_template_16);
+		break;
+
 	case 300:
 		if (alg) {
 			test_hash_speed(alg, sec, generic_hash_speed_template);
-- 
2.17.1

