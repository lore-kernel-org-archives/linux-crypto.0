Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C324C433DB
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Feb 2021 21:50:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DDE5864F8C
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Feb 2021 21:50:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229554AbhBDVuU (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 4 Feb 2021 16:50:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbhBDVqN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 4 Feb 2021 16:46:13 -0500
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AB0AC061223
        for <linux-crypto@vger.kernel.org>; Thu,  4 Feb 2021 13:44:10 -0800 (PST)
Received: by mail-qv1-xf2d.google.com with SMTP id l11so2523491qvt.1
        for <linux-crypto@vger.kernel.org>; Thu, 04 Feb 2021 13:44:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YJE2aPOEkLIKEj61l27Ctrd7+4+SFwAw4jzWQDD0G1c=;
        b=oeTV7brAnPNqzQlfpvHWPIN/2EByLwjB4ekTbsIoy2RKjdwjBERjCGhL/IfkW4K/ZU
         JcGD9gHoN67JvxbkFoswbR8lV9qF/FWuqxk6onmTMvPmDQBKd3o10vLUq3sQ2g0QnxjQ
         xSSZwGzTqRhYqZYsHjL9DOUT83eCqiu+FM3BMHtjoKSUZS8d2dTe8A+P/s26IIBSsHGq
         GmFLeVKUBPIG4s8I07Mdhu9oZKuddSgmwi8lKqODK8lOULkSTMP7MmgQw0w1rNz/IPcO
         i6orK5sgO0PdUyxhPdHY8KeiREjWthc9ZRiR/RqjN2iR0Yrdh44y8s21iSHxBzCXDn6S
         YVXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YJE2aPOEkLIKEj61l27Ctrd7+4+SFwAw4jzWQDD0G1c=;
        b=CKiOhNYt782Y+PWf0j9E/Z1IsuwrTyE9tY1BfjgorxDgsw9r4qptCSGMBLxdKAGfva
         iX1aabi3abVJEQyNmucVjUkoneqZrh/5cY0hlwmFA2TK++QAJmOiFaKqPsEe+F5ewgnn
         MHXErqU7mmdjuF+wMZgyN+wbd7Uh+pDGyVcEskALM1slc+yn+PJ7v+5iXRKwObJa47Na
         S92V6MFGBy4lsKBb79YubHgYqwUD962PhbQgILx6Wujvc4uco61Axh+XKjOw9Zfgug8J
         t/dga9YH9IHv6YmjjinIhot9YryRJcGjdm68SG7pyT3+JHjFYb0UgVjWu8MNxSEYRE5D
         0AJQ==
X-Gm-Message-State: AOAM531iBaKC8L5mnv8njVaSDDNjbIeO7FfRCkjpkKJb73CH008w7bu9
        RshKv2c2pPBfqib8OCccPOH6CA==
X-Google-Smtp-Source: ABdhPJwn3ZSW6oAClmcsSu2NnL8tNcCjUJzMWl9HG9iUhgwlapo4tz+vh2jft2Xgq75FhWD8ylwKEQ==
X-Received: by 2002:a05:6214:613:: with SMTP id z19mr1419357qvw.2.1612475049721;
        Thu, 04 Feb 2021 13:44:09 -0800 (PST)
Received: from pop-os.fios-router.home (pool-71-163-245-5.washdc.fios.verizon.net. [71.163.245.5])
        by smtp.googlemail.com with ESMTPSA id h185sm6353858qkd.122.2021.02.04.13.44.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Feb 2021 13:44:09 -0800 (PST)
From:   Thara Gopinath <thara.gopinath@linaro.org>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        bjorn.andersson@linaro.org
Cc:     ebiggers@google.com, ardb@kernel.org, sivaprak@codeaurora.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v5 10/11] crypto: qce: Remover src_tbl from qce_cipher_reqctx
Date:   Thu,  4 Feb 2021 16:43:58 -0500
Message-Id: <20210204214359.1993065-11-thara.gopinath@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210204214359.1993065-1-thara.gopinath@linaro.org>
References: <20210204214359.1993065-1-thara.gopinath@linaro.org>
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

