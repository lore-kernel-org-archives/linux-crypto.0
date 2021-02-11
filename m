Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38F6DC433E0
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Feb 2021 20:06:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E9F2464DB2
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Feb 2021 20:06:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230353AbhBKUGX (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 11 Feb 2021 15:06:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230315AbhBKUEM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 11 Feb 2021 15:04:12 -0500
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D583CC061222
        for <linux-crypto@vger.kernel.org>; Thu, 11 Feb 2021 12:01:39 -0800 (PST)
Received: by mail-qk1-x731.google.com with SMTP id x14so6532159qkm.2
        for <linux-crypto@vger.kernel.org>; Thu, 11 Feb 2021 12:01:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YJE2aPOEkLIKEj61l27Ctrd7+4+SFwAw4jzWQDD0G1c=;
        b=DGSt07jo66PKKAE7l+SyIEMKfRHrgcFo/8QAJwD5aMsR2TU3gdrwcxHsgkcnBKdMCi
         4McoN6vQs0WGQwjyp2hofGeYIjjqAwR3a1Bc5ZS7HGmAm+e9M8bTRRnrpF0l8JTQgy+l
         V7bSVHHJKM/GRukriyE4Jsmx//OLVWakimzO8oC/S9rbuEawAKlBti/mQGTOLkYaqNI6
         cLmxHn+sUkMu13u0kikJCKX8e1kVV6QSr+c8y9+BZD84swd92hICfSi+2FPI2zF14HDr
         w7vsl1y54gZCjde/36GGPI+vbFi0KV6T5FveXT+FV9IUYcT6cBxHI7ytOZ3a/dAOrB4N
         vvkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YJE2aPOEkLIKEj61l27Ctrd7+4+SFwAw4jzWQDD0G1c=;
        b=cB9o2O06ko+zjvPQNcocG+69LOdXVwTyf77ppbHspru89hZ+6PJJvtZU8FRS4KZFJV
         8Y64PiT6ofRgqT+S90B6jj3uK8/G99VhvNQN/BwFWR7CHemAfZts0Dq0MXeYybtVwzmq
         aMM1UYxSLCe1o/s2trRSmuC7divWFttGHTz9tybhoIy0tyUrJk+swNstSIZfob0GqhkY
         BpjdKCYFEia9gpfD8jxGOAaI96nva6O4piDZcA9htV3zFNKhwuJBizMWHieJUHakYaBy
         pt3RTsPea4j63lvCs65fba1lJAtpYhUG6Pm/t1u8ngCaIkx2wSF41dYa5tLpBGPwrKcj
         COgw==
X-Gm-Message-State: AOAM532ERxRHME+m26SxeOPCuKouoGeg65Uv1FYHeYNhkBFIjlxuuMR9
        Jji5diZ4/3H/+ek//dF7YpK7eZrno0iuGg==
X-Google-Smtp-Source: ABdhPJznaAdNRp8Nki5n7arEtus622c0UfOBooWLUDPIt7dVUvPvrCgBa4QmZFyovNp1sN1PP6i+Jg==
X-Received: by 2002:a05:620a:2281:: with SMTP id o1mr9856106qkh.313.1613073699132;
        Thu, 11 Feb 2021 12:01:39 -0800 (PST)
Received: from pop-os.fios-router.home (pool-71-163-245-5.washdc.fios.verizon.net. [71.163.245.5])
        by smtp.googlemail.com with ESMTPSA id 17sm4496243qtu.23.2021.02.11.12.01.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 12:01:38 -0800 (PST)
From:   Thara Gopinath <thara.gopinath@linaro.org>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        bjorn.andersson@linaro.org
Cc:     ebiggers@google.com, ardb@kernel.org, sivaprak@codeaurora.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v7 10/11] crypto: qce: Remover src_tbl from qce_cipher_reqctx
Date:   Thu, 11 Feb 2021 15:01:27 -0500
Message-Id: <20210211200128.2886388-11-thara.gopinath@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210211200128.2886388-1-thara.gopinath@linaro.org>
References: <20210211200128.2886388-1-thara.gopinath@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

src_table is unused and hence remove it from struct qce_cipher_reqctx

Signed-off-by: Thara Gopinath <thara.gopinath@linaro.org>
---
 drivers/crypto/qce/cipher.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/crypto/qce/cipher.h b/drivers/crypto/qce/cipher.h
index cffa9fc628ff..850f257d00f3 100644
--- a/drivers/crypto/qce/cipher.h
+++ b/drivers/crypto/qce/cipher.h
@@ -40,7 +40,6 @@ struct qce_cipher_reqctx {
 	struct scatterlist result_sg;
 	struct sg_table dst_tbl;
 	struct scatterlist *dst_sg;
-	struct sg_table src_tbl;
 	struct scatterlist *src_sg;
 	unsigned int cryptlen;
 	struct skcipher_request fallback_req;	// keep at the end
-- 
2.25.1

