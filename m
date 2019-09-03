Return-Path: <SRS0=7iXC=W6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E60C8C3A5A2
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Sep 2019 16:43:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BEF4621881
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Sep 2019 16:43:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Y1N3tMki"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730118AbfICQn5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 3 Sep 2019 12:43:57 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:37925 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728854AbfICQn5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Sep 2019 12:43:57 -0400
Received: by mail-pf1-f196.google.com with SMTP id h195so4576583pfe.5
        for <linux-crypto@vger.kernel.org>; Tue, 03 Sep 2019 09:43:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=gkbLgubyXxiJMMRMzAmpKCmMYVcmKbpOZX5ob6E8mqs=;
        b=Y1N3tMkiZScTCyMI8i+q2vzi1sOGzQSoqt/D/zN5IwCEIXpRElOP7pBpBB3JMeiYin
         nnNv8+gg5JvB5xmZ0L2mqda6onQg97YTutIlPOhE5w6OSlbJOggzrDGjdePWjre1SG2k
         MKrEC/9BMHmgvQMqytJF5EzuZ8qwI69iG7YSoUIlgUdJu0xrKVXIvjoaqqpdpsCHZbox
         zwgSF9ihqMP8c0ampc2sLHfl/58O3zeMa//4/qJBjeSIoGIxWQ5fIBEbev1fHqnYIFl0
         fiKssFaNc6y2spi2cg1Hl9yYgq1T76u8jhjTRnN1XWg+h/ZsqoCfw9S/78qOZpbX56eO
         9K2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=gkbLgubyXxiJMMRMzAmpKCmMYVcmKbpOZX5ob6E8mqs=;
        b=NYB3SylRkeA9egQ6tBXCPhwOJBIMIPtvs9OnFmlZ+yv99MmD+8ZCgV1ZmoxN01FiJ7
         MbLmNI4iyT9lDqK48u2+l6T1Uoe/qJ8Z0sHYybu/rU+hzRSCQUbHjU9I8XErS8kQ2IIW
         1vRSosBlUGjJzr0YDQsrlWd22XLqyNTf5FKo9YkyEUGt9w8y8+9odvh6WWNpJflby29p
         HANJ0xqw6/4bEBuGWgUSoJtik3PyPXpw5CdD1tZD07qNd+Jt4E0I/N2MBjT2vmFvMHvd
         HLO7sqt96LBhJiY3SqpwRQWYK88Q8luTYklrKypf08KPJPOx5PzjpfUfQ9U0n69VUOCn
         1mOw==
X-Gm-Message-State: APjAAAXHssrx5dyd6IY/Ir8Bp5WcjVZXY2K2tnNq2c3QsGNKektqyWkQ
        O9LdeopJ/k0jotfce3h2pHMkTE8nNqf5daN0
X-Google-Smtp-Source: APXvYqxLN8jPnb4M9qzlorDiYEPu3SkvH5l5etJUT4+eZ1j0a1Bn/o3KiRzyyn5dl+o7/Lpo4ilsfA==
X-Received: by 2002:aa7:8559:: with SMTP id y25mr40695542pfn.260.1567529036208;
        Tue, 03 Sep 2019 09:43:56 -0700 (PDT)
Received: from e111045-lin.nice.arm.com ([104.133.8.102])
        by smtp.gmail.com with ESMTPSA id b126sm20311847pfb.110.2019.09.03.09.43.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Sep 2019 09:43:55 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 09/17] crypto: arm64/aes-cts-cbc-ce - performance tweak
Date:   Tue,  3 Sep 2019 09:43:31 -0700
Message-Id: <20190903164339.27984-10-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190903164339.27984-1-ard.biesheuvel@linaro.org>
References: <20190903164339.27984-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Optimize away one of the tbl instructions in the decryption path,
which turns out to be unnecessary.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/crypto/aes-modes.S | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/crypto/aes-modes.S b/arch/arm64/crypto/aes-modes.S
index 2879f030a749..38cd5a2091a8 100644
--- a/arch/arm64/crypto/aes-modes.S
+++ b/arch/arm64/crypto/aes-modes.S
@@ -293,12 +293,11 @@ AES_ENTRY(aes_cbc_cts_decrypt)
 	ld1		{v5.16b}, [x5]			/* get iv */
 	dec_prepare	w3, x2, x6
 
-	tbl		v2.16b, {v1.16b}, v4.16b
 	decrypt_block	v0, w3, x2, x6, w7
-	eor		v2.16b, v2.16b, v0.16b
+	tbl		v2.16b, {v0.16b}, v3.16b
+	eor		v2.16b, v2.16b, v1.16b
 
 	tbx		v0.16b, {v1.16b}, v4.16b
-	tbl		v2.16b, {v2.16b}, v3.16b
 	decrypt_block	v0, w3, x2, x6, w7
 	eor		v0.16b, v0.16b, v5.16b		/* xor with iv */
 
-- 
2.17.1

