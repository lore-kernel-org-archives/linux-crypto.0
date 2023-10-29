Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FE9FC4167B
	for <linux-crypto@archiver.kernel.org>; Sun, 29 Oct 2023 20:48:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230293AbjJ2Usk (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 29 Oct 2023 16:48:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbjJ2Ush (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 29 Oct 2023 16:48:37 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F5CFB6
        for <linux-crypto@vger.kernel.org>; Sun, 29 Oct 2023 13:48:35 -0700 (PDT)
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com [209.85.221.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id DD25B3F697
        for <linux-crypto@vger.kernel.org>; Sun, 29 Oct 2023 20:48:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1698612512;
        bh=kX0qGSlIN+myPQHKGzUHfDf+7TPtp+Gi684hQoqwER0=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=Xe+MkepyVY1uDDUDr8GTbeICmfgs9rSXk4tV79Ug1j66wOKExXIUBG6ydQpCInQf7
         OXP+agFHsG64ukG92UI6CEnYmeAULMNJCB9hf8WFoU5NM4cmI1kEXeVUKtHZ+WAgOb
         Emb4jC1web7kNfE4DExhZyh3W6B6qnW+JY+jK/lwD4/77kU1eDz3Ftk29a7ZyY3wO5
         ryonrVEhSQrzW9nHiDouFyUKrlX+ppn9ncI1qTsSr5uSvDbtmRxuBDk/vzCeSZWOT1
         GfTech6BswgvVY0mXy6hZs+NoE5xXoej7dMKLCQQIX3Vr4n5yUjGv2F5NeIs13wN7P
         gONx2bOetejOQ==
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-32da8de4833so2015491f8f.3
        for <linux-crypto@vger.kernel.org>; Sun, 29 Oct 2023 13:48:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698612512; x=1699217312;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kX0qGSlIN+myPQHKGzUHfDf+7TPtp+Gi684hQoqwER0=;
        b=qyiP7G+riWv+hXcgqH8uJbHjo2zA5HgFEFG45s1I6Mgq7qTk81AcIypozjZU4MqpKl
         Y/koflGACKvTJZF+kYktZ6J9pXhL2SLxQw38eQnxnfItQGx08mx/fWD/dnxiY49Nk3eY
         L6KJwJm4VIdsHNpoVrRHVlcZ9Kma4jQ0s2kRPIEi1ikY/PrvbnrrM1bRz7W+yC2PwYaa
         Zll4MAmmWeSj/piLf3Ss0GKKZBEupRW+61eTmUwXcTHPaJIMe29Bcs8tYcchlsLoYx7d
         KPhGPGCDbOcAo/91nkWz5JxfVdPUlczrfe8zcXePB4YVc62Yu2vjcfsOQRxlgB/H71cf
         WiiQ==
X-Gm-Message-State: AOJu0Yy6OnGiVNdxAM4Gjr/T8RnrE+w+nSgH6qZWGliBMDw1Di19Gs2C
        CrImDfcT8btieW9o+eCYni4sSCNblGEAPl0zC3887LCRJQheZEW7ruNQCwpWq22Q6gWh0YIh6lu
        ySar10cvlo09vJaaah24/odnCnAuLuV69rX9gwmC2Iw==
X-Received: by 2002:a5d:6051:0:b0:32d:a4c4:f700 with SMTP id j17-20020a5d6051000000b0032da4c4f700mr5575138wrt.38.1698612512451;
        Sun, 29 Oct 2023 13:48:32 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGjfCBiBEk+QucpwQLyHGqr1cR+Dvm3Yy3IgwtdHlACLwzb9JDkKDgf7RgNPULwzHs69RsgQw==
X-Received: by 2002:a5d:6051:0:b0:32d:a4c4:f700 with SMTP id j17-20020a5d6051000000b0032da4c4f700mr5575127wrt.38.1698612512143;
        Sun, 29 Oct 2023 13:48:32 -0700 (PDT)
Received: from localhost ([2001:67c:1560:8007::aac:c15c])
        by smtp.gmail.com with ESMTPSA id u9-20020a5d6ac9000000b0032d687fd9d0sm6599715wrw.19.2023.10.29.13.48.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Oct 2023 13:48:31 -0700 (PDT)
From:   Dimitri John Ledkov <dimitri.ledkov@canonical.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Stephan Mueller <smueller@chronox.de>
Cc:     simo@redhat.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] crypto: drbg - ensure most preferred type is FIPS health checked
Date:   Sun, 29 Oct 2023 22:48:20 +0200
Message-Id: <20231029204823.663930-1-dimitri.ledkov@canonical.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

drbg supports multiple types of drbg, and multiple parameters of
each. Health check sanity only checks one drbg of a single type. One
can enable all three types of drbg. And instead of checking the most
preferred algorithm (last one wins), it is currently checking first
one instead.

Update ifdef to ensure that healthcheck prefers HMAC, over HASH, over
CTR, last one wins, like all other code and functions.

Fixes: 541af946fe ("crypto: drbg - SP800-90A Deterministic Random Bit Generator")

Signed-off-by: Dimitri John Ledkov <dimitri.ledkov@canonical.com>
---
 crypto/drbg.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index ff4ebbc68e..2cce18dcfc 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -2018,9 +2018,11 @@ static inline int __init drbg_healthcheck_sanity(void)
 
 #ifdef CONFIG_CRYPTO_DRBG_CTR
 	drbg_convert_tfm_core("drbg_nopr_ctr_aes128", &coreref, &pr);
-#elif defined CONFIG_CRYPTO_DRBG_HASH
+#endif
+#ifdef CONFIG_CRYPTO_DRBG_HASH
 	drbg_convert_tfm_core("drbg_nopr_sha256", &coreref, &pr);
-#else
+#endif
+#ifdef CONFIG_CRYPTO_DRBG_HMAC
 	drbg_convert_tfm_core("drbg_nopr_hmac_sha256", &coreref, &pr);
 #endif
 
-- 
2.34.1

