Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE6BFC433EF
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Jun 2022 07:06:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230099AbiFWHG1 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 23 Jun 2022 03:06:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230077AbiFWHGP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 Jun 2022 03:06:15 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF28845522
        for <linux-crypto@vger.kernel.org>; Thu, 23 Jun 2022 00:06:13 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id 68so12863189pgb.10
        for <linux-crypto@vger.kernel.org>; Thu, 23 Jun 2022 00:06:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tKM3xvFOU9BbHzW/2uuQbOBzRGB1RdsYKFUv60RJdxg=;
        b=r8IqrvjRWQT1pBFaEM8t6vVrtOXzX4aBi6mB5Zn9BhF6u/GdCpTiSIQ9EN1T89UQj6
         Q/XstSt/4WvBdRHCDoYjxdqu/Vgo7gOXkXbKIbZt9KDUqp+AF2VlRc1jaq5ikvtO20pM
         ga4RO4zQnvyJ+UiOEdglRFUW06tX01Ty+kLquhYQlfE59ZMlmpKfe3q1I0acI9TWYsXf
         zlT54N/o/t/0rcF+Z3wh1GM7GMx7vddnwm/3OB3a1xADfJhWz61ioPANF44Dg1svLas/
         ssRhFze6ur1kw8m5U1FZEow+xiZCpeVdIJbpPyTO59wLxKmlB3cIVfzbnRsQTQc6xrce
         ngfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tKM3xvFOU9BbHzW/2uuQbOBzRGB1RdsYKFUv60RJdxg=;
        b=LIrRx5PTcs9sgPzQIzy49gOoka4HvtZqM+5TyLlxVZR//JT754GqEZXsz5R1WfKJ86
         JjG/gzShSY9vXh1TJUIqqVWBJWSfCV70i4TUw0tmr16Qz51lbUpRx/wJ9Z4vliQHZvBR
         VjJcXzHTRd+8zLGmVP0p1WqA32wMKqvcCajYtiXGTC3ijb8imJBJE1vnrvpPJiKr1ORB
         VnWwKHLpoaor95qTMc8RNg463nzllm6z8RuU57H35w10sq+GFiZ/1T4Bt/A4AyPqnQIX
         45m3bUrP5EltgKvYEneoCudCleaMNraJIdFwcXe429vGvu8HPGY7J7bXZZVPExrpubHG
         TRQg==
X-Gm-Message-State: AJIora9HtBJ/5NUIlFZMwFukx2mmW7EIv+oFJP/Qr8IATOfEvTXHQp0G
        /udUvee8DA5wYJ+/u9YQqPdlow==
X-Google-Smtp-Source: AGRyM1vyVTszeaTgvw5g3puVzGBDCQwgKBdRvtGXDXW++HjJ81hyW0BTHsvDY8mGAjdO+0tAlWFXJw==
X-Received: by 2002:a63:b345:0:b0:409:fc0f:5d5c with SMTP id x5-20020a63b345000000b00409fc0f5d5cmr6274754pgt.587.1655967973467;
        Thu, 23 Jun 2022 00:06:13 -0700 (PDT)
Received: from FVFDK26JP3YV.bytedance.net ([139.177.225.250])
        by smtp.gmail.com with ESMTPSA id ji1-20020a170903324100b0016a15842cf5sm9125184plb.121.2022.06.23.00.06.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 Jun 2022 00:06:13 -0700 (PDT)
From:   Lei He <helei.sig11@bytedance.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        dhowells@redhat.com
Cc:     mst@redhat.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, berrange@redhat.com,
        pizhenwei@bytedance.com, lei he <helei.sig11@bytedance.com>
Subject: [PATCH v2 3/4] crypto: remove unused field in pkcs8_parse_context
Date:   Thu, 23 Jun 2022 15:05:49 +0800
Message-Id: <20220623070550.82053-4-helei.sig11@bytedance.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20220623070550.82053-1-helei.sig11@bytedance.com>
References: <20220623070550.82053-1-helei.sig11@bytedance.com>
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
2.20.1

