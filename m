Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65D0DC43217
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Nov 2022 14:01:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230008AbiKXOBV (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 24 Nov 2022 09:01:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230211AbiKXOAl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 24 Nov 2022 09:00:41 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26F0614E6C0
        for <linux-crypto@vger.kernel.org>; Thu, 24 Nov 2022 05:58:38 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id g12so2567883wrs.10
        for <linux-crypto@vger.kernel.org>; Thu, 24 Nov 2022 05:58:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eK2HhZFuYKBw9Q1i1G+ZYdrg12Uwlkokjhvoi/Q+HPY=;
        b=D38n3pCWpXzjlzIFepFNOLyjuVk4JHdwHucQrpGgyIhDtSuhyieBCotwNYGLKhcsLH
         WxDDyNkTx2URYWVCTOtt4E1mJGwMhjgeBkw6SpOjbmPg6AN5/NLb2LFYBM47AnH6o6ED
         30mkG80aQOc2DLEBNgXILz/pS5ZcIa8CS5Pvk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eK2HhZFuYKBw9Q1i1G+ZYdrg12Uwlkokjhvoi/Q+HPY=;
        b=GdraRaBpsvETUOd1WnZdYbKHZFYEWQYQuEIkkzeAghT625M5FntYtsEA3Iq00TD0Q2
         fmbfZL5hDhOJRIJry80+//YvySBeEwWVffUO9TNBFBpZT1IJlqE7gCFOdZ79GJOw9Uws
         tw3geu0t5vF4KqPqPJw+hMTJC0IOEkBKnyzNsyTEgbhmg63Yvk2m6P+fYZd2TA/rYmef
         oSIeaFC0/IbKwO4kth20nf3S3aIQmu7NteKdmLapjufh+Ocw/9h8xF9XqhSb6pKtAz9B
         k5omGNy+xx1Fce4glkZCaTCJyvwCKG6iFV4IjugJzgXXXBNlV71by1mNl+vi3ZJZuB7f
         72Kw==
X-Gm-Message-State: ANoB5pl9b/X5II5/DHQrtj2pyehYa3ZL5BXGTvjr13Vb5fduff1gw2ig
        WQr66d7cDlbh7r2Bbn8eLfEdMQ==
X-Google-Smtp-Source: AA0mqf5sc5D8WHrub5ZtPIWUF7UHcLatkb1hu6n9mgvJRIQQ9In22C2OQPul1kbFM8wIG+G3AZNcNA==
X-Received: by 2002:adf:e5c4:0:b0:236:9701:97d2 with SMTP id a4-20020adfe5c4000000b00236970197d2mr13893227wrn.185.1669298316053;
        Thu, 24 Nov 2022 05:58:36 -0800 (PST)
Received: from localhost.localdomain ([2a09:bac1:28c0:140::15:1b6])
        by smtp.gmail.com with ESMTPSA id n14-20020a5d660e000000b00241bee11825sm1371440wru.103.2022.11.24.05.58.35
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 24 Nov 2022 05:58:35 -0800 (PST)
From:   Ignat Korchagin <ignat@cloudflare.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, David Howells <dhowells@redhat.com>,
        keyrings@vger.kernel.org
Cc:     kernel-team@cloudflare.com, lei he <helei.sig11@bytedance.com>
Subject: [RESEND PATCH v2 4/4] crypto: remove unused field in pkcs8_parse_context
Date:   Thu, 24 Nov 2022 13:58:12 +0000
Message-Id: <20221124135812.26999-5-ignat@cloudflare.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20221124135812.26999-1-ignat@cloudflare.com>
References: <20221124135812.26999-1-ignat@cloudflare.com>
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

