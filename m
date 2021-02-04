Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8387FC433DB
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Feb 2021 11:12:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 56AD164F60
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Feb 2021 11:12:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235739AbhBDLMl (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 4 Feb 2021 06:12:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235682AbhBDLLu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 4 Feb 2021 06:11:50 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1DB6C0612F2
        for <linux-crypto@vger.kernel.org>; Thu,  4 Feb 2021 03:10:16 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id v15so3019270wrx.4
        for <linux-crypto@vger.kernel.org>; Thu, 04 Feb 2021 03:10:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=avN1u0Er/3jjbceQj3GDRB5KtHhfEhx0wpHOx8svPCg=;
        b=tbTk9psUc52Wwl90sZuJm/3vqked4L4RjNIaBf8tRL3qUxnaYWAE+Ijgg+Mwqge9mh
         C+lQ2LAaNUd9Jby+KXE88A9m6VnjNMqHu3U+EsZWNpHpUszlyKG37cJ9SOo0WjV/mT/H
         xJ020nufrEvJlN3WnYNB8z0mFMgP2fOISxcMVHdZUIxQtwUjbPr3FrvLIJtN3NyLBrZZ
         lk03+BTzI04dXjyjLMiY6b+JWk4ZeMOBhbROzr4VHLi+VTfY902xPc80ZK5aJsSZQb2n
         p0AALHyUhOwxR8ahBOkzU2+qOXqLDLRKm4bZwq+Seczaee2tiX+pXxfT6FVQn4Ic5JY4
         pG/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=avN1u0Er/3jjbceQj3GDRB5KtHhfEhx0wpHOx8svPCg=;
        b=YmTjSDlTVNjLqxarN0P5y61SjEDCOWo1vToHH+c4CbK/r/mE6LRp1mW+VPiRP6WAP3
         Fa9A30VMJ3J0Nue3GPlWTviAvdzhq5gQ0jZW2XMgp7GP8h0fl/EQuDK2qCo4KTHVd6/0
         QeqT/GrW+nWYuRNHNCDujWaqiiU8vnRTgf1MXEFmB6OX5xe2F9QISjaHo1L3ezah4kti
         25q9Vs+2rf8CvD13EE/9BViVneZsGk1Q8w5U93YbMPqSXWjgpnN6pf8DPYn5I2R+/TK9
         UY0JwsWIGN/VGpiFvP+M9t068Wgm/AAMHG87/9S2TVD1u2mc84h9VpXMNxu6/W0d1sy6
         8idg==
X-Gm-Message-State: AOAM533tEUcKOpqVuVNz+AsFhn/X9aZhFD+HeEOYDVE0JaqXGBsV4K0E
        7ErNy0YX7uOTI3uB+WSqw76nxw==
X-Google-Smtp-Source: ABdhPJzTMVni3uUeJoJsuMcvVIXormUpRYGc5uC7YJqFJZbIZqsofBqllUbt0pYWV02sTZYFmPC61g==
X-Received: by 2002:adf:dd05:: with SMTP id a5mr8572303wrm.402.1612437015406;
        Thu, 04 Feb 2021 03:10:15 -0800 (PST)
Received: from dell.default ([91.110.221.188])
        by smtp.gmail.com with ESMTPSA id y18sm7696218wrt.19.2021.02.04.03.10.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Feb 2021 03:10:14 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org,
        Ayush Sawal <ayush.sawal@chelsio.com>,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        Rohit Maheshwari <rohitm@chelsio.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Manoj Malviya <manojmalviya@chelsio.com>,
        Atul Gupta <atul.gupta@chelsio.com>,
        Jitendra Lulla <jlulla@chelsio.com>,
        M R Gowda <yeshaswi@chelsio.com>,
        Harsh Jain <harsh@chelsio.com>, linux-crypto@vger.kernel.org
Subject: [PATCH 10/20] crypto: chelsio: chcr_algo: Fix a couple of kernel-doc issues caused by doc-rot
Date:   Thu,  4 Feb 2021 11:09:50 +0000
Message-Id: <20210204111000.2800436-11-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210204111000.2800436-1-lee.jones@linaro.org>
References: <20210204111000.2800436-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/crypto/chelsio/chcr_algo.c:806: warning: Function parameter or member 'wrparam' not described in 'create_cipher_wr'
 drivers/crypto/chelsio/chcr_algo.c:806: warning: Excess function parameter 'req' description in 'create_cipher_wr'
 drivers/crypto/chelsio/chcr_algo.c:806: warning: Excess function parameter 'ctx' description in 'create_cipher_wr'
 drivers/crypto/chelsio/chcr_algo.c:806: warning: Excess function parameter 'qid' description in 'create_cipher_wr'
 drivers/crypto/chelsio/chcr_algo.c:806: warning: Excess function parameter 'op_type' description in 'create_cipher_wr'
 drivers/crypto/chelsio/chcr_algo.c:1566: warning: Function parameter or member 'req' not described in 'create_hash_wr'
 drivers/crypto/chelsio/chcr_algo.c:1566: warning: Function parameter or member 'param' not described in 'create_hash_wr'

Cc: Ayush Sawal <ayush.sawal@chelsio.com>
Cc: Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Cc: Rohit Maheshwari <rohitm@chelsio.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Manoj Malviya <manojmalviya@chelsio.com>
Cc: Atul Gupta <atul.gupta@chelsio.com>
Cc: Jitendra Lulla <jlulla@chelsio.com>
Cc: M R Gowda <yeshaswi@chelsio.com>
Cc: Harsh Jain <harsh@chelsio.com>
Cc: linux-crypto@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/crypto/chelsio/chcr_algo.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/chelsio/chcr_algo.c b/drivers/crypto/chelsio/chcr_algo.c
index f5a336634daa6..f77d3fd962bf8 100644
--- a/drivers/crypto/chelsio/chcr_algo.c
+++ b/drivers/crypto/chelsio/chcr_algo.c
@@ -797,10 +797,7 @@ static inline void create_wreq(struct chcr_context *ctx,
 
 /**
  *	create_cipher_wr - form the WR for cipher operations
- *	@req: cipher req.
- *	@ctx: crypto driver context of the request.
- *	@qid: ingress qid where response of this WR should be received.
- *	@op_type:	encryption or decryption
+ *	@wrparam: Container for create_cipher_wr()'s parameters
  */
 static struct sk_buff *create_cipher_wr(struct cipher_wr_param *wrparam)
 {
@@ -1559,7 +1556,8 @@ static inline void chcr_free_shash(struct crypto_shash *base_hash)
 
 /**
  *	create_hash_wr - Create hash work request
- *	@req - Cipher req base
+ *	@req: Cipher req base
+ *	@param: Container for create_hash_wr()'s parameters
  */
 static struct sk_buff *create_hash_wr(struct ahash_request *req,
 				      struct hash_wr_param *param)
-- 
2.25.1

