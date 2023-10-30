Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B935C4332F
	for <linux-crypto@archiver.kernel.org>; Mon, 30 Oct 2023 12:05:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233131AbjJ3MFw (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 30 Oct 2023 08:05:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233095AbjJ3MFr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 30 Oct 2023 08:05:47 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 877BCCC
        for <linux-crypto@vger.kernel.org>; Mon, 30 Oct 2023 05:05:45 -0700 (PDT)
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com [209.85.208.198])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id B54413FD39
        for <linux-crypto@vger.kernel.org>; Mon, 30 Oct 2023 12:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1698667543;
        bh=goPlhkL/xzNb2R4OkDT742TxqiPYA+4C52wqVnxeTeU=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=ViAmbB4aptfuB10K4nwvaQsoxkNVtCrGfGQb5NO4WQ9w8DkqCJLsiM10Vb9mZ0FtJ
         09QB1iEKbnOdPSZBBlOsHF17sos+B4KHLHzDxCBWJ1cIZ4n57H6e+jD9BCvxVSnold
         EWC7h6nQZ3CIg5Nw7oVQeU+H4GFAhHqYycdAi09NtxCVqSXJVmgnH3Z3Z0/3WTODd6
         fDFasvU1DdQi8RUna1RAhOQtCw13VcgkTtEVLKVZHEk0g7cf+ZkRAqnUTFSRKV714Q
         hJ1yl6jWylmc4oMSk/LMIxBvz64rxJ25CJoI5i3gCHb31h2U+a7S6N5tVDEgPvIqdK
         leSoP3s4qjuqA==
Received: by mail-lj1-f198.google.com with SMTP id 38308e7fff4ca-2c50257772bso44283281fa.3
        for <linux-crypto@vger.kernel.org>; Mon, 30 Oct 2023 05:05:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698667543; x=1699272343;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=goPlhkL/xzNb2R4OkDT742TxqiPYA+4C52wqVnxeTeU=;
        b=o5DdnalLK68wCiwii5Q6Ld/VvBHK5kCgVSA6DvQzhvX+mygaa+XRqhEY2eM/TVpPXe
         oWnnMPGM7F1Vjso7gXJXVR0vJlmHGNmn3RxhNC7wyPX435ErvAKaAjvX46rqeZOKHqoj
         9+r2Dk01PG0p89ZDyPoFv+9Aw0/7i3DOOAD7rTbjX2EaHcmPIlcdaN11iKluEJ3XUW5P
         IwidvNeL4bDaUArbYJM6En3QeeeH0BC6Wc70sWP+8oPgfoSDF7ZYu0qRN04qhMpb8J/7
         6nVtHcGbHCGAHKatL/n0EMfYMtlJkBIqFI45+mcMdZvt4mBE2Kjj0kCsxGTvUpvNt0DH
         yrWg==
X-Gm-Message-State: AOJu0Yyj++edxgj1UhfPHfp8Uv2VzwortGcf3M6zxHA8uDGxgmtVQe4R
        t+fJje/iJWmo/VF7kI79nyNbcFInhSMkhjCcwWJOb+U76hZDxbN3TRMXunV7E8mRcASHHvUtzzu
        HfcKGRA9XxqX7tnCxEYdyjUVlxKGeBFXZloq36IZ+qg==
X-Received: by 2002:a05:6512:3b97:b0:507:9777:a34a with SMTP id g23-20020a0565123b9700b005079777a34amr9719642lfv.39.1698667543060;
        Mon, 30 Oct 2023 05:05:43 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGoJXGtoW+Yqd/RvASlxF5C9PTbciLZsCRzR68/fGUZamt97cY67cCfeewUQXDLtQyX5xXHTg==
X-Received: by 2002:a05:6512:3b97:b0:507:9777:a34a with SMTP id g23-20020a0565123b9700b005079777a34amr9719602lfv.39.1698667542331;
        Mon, 30 Oct 2023 05:05:42 -0700 (PDT)
Received: from localhost ([159.148.223.140])
        by smtp.gmail.com with ESMTPSA id n18-20020a056512311200b005056ccb222asm1418808lfb.105.2023.10.30.05.05.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Oct 2023 05:05:42 -0700 (PDT)
From:   Dimitri John Ledkov <dimitri.ledkov@canonical.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     smueller@chronox.de, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/4] crypto: drbg - ensure most preferred type is FIPS health checked
Date:   Mon, 30 Oct 2023 14:05:13 +0200
Message-Id: <20231030120517.39424-2-dimitri.ledkov@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231030120517.39424-1-dimitri.ledkov@canonical.com>
References: <20231029204823.663930-1-dimitri.ledkov@canonical.com>
 <20231030120517.39424-1-dimitri.ledkov@canonical.com>
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

This patch updates code from 541af946fe ("crypto: drbg - SP800-90A
Deterministic Random Bit Generator"), but is not interesting to
cherry-pick for stable updates, because it doesn't affect regular
builds, nor has any tangible effect on FIPS certifcation.

Signed-off-by: Dimitri John Ledkov <dimitri.ledkov@canonical.com>
Reviewed-by: Stephan Mueller <smueller@chronox.de>
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

