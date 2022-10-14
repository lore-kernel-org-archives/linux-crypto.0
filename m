Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82E23C433FE
	for <linux-crypto@archiver.kernel.org>; Fri, 14 Oct 2022 10:08:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbiJNKIG (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 14 Oct 2022 06:08:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230060AbiJNKIA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 14 Oct 2022 06:08:00 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 893F11C8438
        for <linux-crypto@vger.kernel.org>; Fri, 14 Oct 2022 03:07:57 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id bv10so6803402wrb.4
        for <linux-crypto@vger.kernel.org>; Fri, 14 Oct 2022 03:07:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eK2HhZFuYKBw9Q1i1G+ZYdrg12Uwlkokjhvoi/Q+HPY=;
        b=Q12kDcAzx20GbyBwu82F09Ued3HbvtAmoSfgYktrLlHUxhFVva+VbCLnOORVMgJJ68
         m1V2dJ2/LxOOba2XMIYnLgS00yWRtc9i/wJhpaeW1um5b8wTmHAL/expuRyQauiQFAsr
         U4WUyjJ1jSL6zmYaPgvpvjRXBmxUp+mv3JrwQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eK2HhZFuYKBw9Q1i1G+ZYdrg12Uwlkokjhvoi/Q+HPY=;
        b=ZIBuHUOppLAveGmet1mOLCNIExEJm+/RCeHhlW9BvBIKXGEoZ9PIkj7Mfm2FGhGB5s
         Fre2T2ZrD2tPqaJ7j1CGLJBhCbpanvp9azyZ+SIFhnQHh1WXCqB5AfbqjKyoxIrPomWV
         /LgIa9ewKOEujtMGi+pH+5mHqEKEaY5jin4F/XYwAoFMIYQ+hVvRcuQPZZskrG7t6qHs
         TY/E70c7DaHh0SJjKz80TGwBQjRqHxfGmH64Lrl8wNqulxej8yOmdbDfPJxnf+D+6D2A
         xq5rmfB2dtYWKQoYP0WLYaXUJGBXCZsqvDQZEPNP4ADgGPM/V87iX5CRBlRa246gmwsA
         /lnA==
X-Gm-Message-State: ACrzQf2MmDKRRlAHRMZ3VBglNDqiLXkXndUnTEJsB1Zt5NmjKCnC8J+N
        H+/wOSyxC7dtBZQ23IlaqrDKCnK+jd9wrA==
X-Google-Smtp-Source: AMsMyM6DWkbFsKMaUZdaXa24yX9XWkVFPkekjvx0o5XgsrJElKco8OsZ9YjMxQQu0bBYZIpsa+UiiA==
X-Received: by 2002:adf:ea04:0:b0:22e:6545:9963 with SMTP id q4-20020adfea04000000b0022e65459963mr2748701wrm.417.1665742075710;
        Fri, 14 Oct 2022 03:07:55 -0700 (PDT)
Received: from localhost.localdomain ([2a02:c7c:5308:6600:49a0:d6bf:5c1a:f3da])
        by smtp.gmail.com with ESMTPSA id c15-20020a5d414f000000b002285f73f11dsm1931008wrq.81.2022.10.14.03.07.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Oct 2022 03:07:55 -0700 (PDT)
From:   Ignat Korchagin <ignat@cloudflare.com>
To:     David Howells <dhowells@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     kernel-team@cloudflare.com, lei he <helei.sig11@bytedance.com>
Subject: [PATCH v2 4/4] crypto: remove unused field in pkcs8_parse_context
Date:   Fri, 14 Oct 2022 11:07:37 +0100
Message-Id: <20221014100737.94742-5-ignat@cloudflare.com>
X-Mailer: git-send-email 2.37.0 (Apple Git-136)
In-Reply-To: <20221014100737.94742-1-ignat@cloudflare.com>
References: <20221014100737.94742-1-ignat@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: lei he <helei.sig11@bytedance.com>

remove unused field 'algo_oid' in pkcs8_parse_context

Signed-off-by: lei he <helei.sig11@bytedance.com>
---
 crypto/asymmetric_keys/pkcs8_parser.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/crypto/asymmetric_keys/pkcs8_parser.c b/crypto/asymmetric_keys/pkcs8_parser.c
index e507c635ead5..f81317234331 100644
--- a/crypto/asymmetric_keys/pkcs8_parser.c
+++ b/crypto/asymmetric_keys/pkcs8_parser.c
@@ -21,7 +21,6 @@ struct pkcs8_parse_context {
 	struct public_key *pub;
 	unsigned long	data;			/* Start of data */
 	enum OID	last_oid;		/* Last OID encountered */
-	enum OID	algo_oid;		/* Algorithm OID */
 	u32		key_size;
 	const void	*key;
 	const void	*algo_param;
-- 
2.30.2

