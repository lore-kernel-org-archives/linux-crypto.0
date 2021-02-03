Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52F69C433DB
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Feb 2021 14:35:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0878F64F7C
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Feb 2021 14:35:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232791AbhBCOfa (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 3 Feb 2021 09:35:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232995AbhBCOet (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Feb 2021 09:34:49 -0500
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DA84C0612F2
        for <linux-crypto@vger.kernel.org>; Wed,  3 Feb 2021 06:33:20 -0800 (PST)
Received: by mail-qt1-x82d.google.com with SMTP id w20so15426251qta.0
        for <linux-crypto@vger.kernel.org>; Wed, 03 Feb 2021 06:33:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YJE2aPOEkLIKEj61l27Ctrd7+4+SFwAw4jzWQDD0G1c=;
        b=SJdUE6vYWhFUDqioD70Bas/UqqRLldg90N4oVMpwXEUF6VEH8kh7yyBgzz5rjSx1pJ
         a2gP2yoiqctYUMtHP9KuGiMKC+5IlB6SY2iujGxSe70FH5ex/qaY+BkgYgFkIn9jttYK
         wdWPF4nbDZfqW7NxJehEmslBC2Zrrr4YKqpe+NSHxxMaNjH5cADHUkf9euHOeV1VDIjO
         W2vf2dn2x28Uk708KnYDQSU8ZUh5YyyEAVZu+g+rWZ48Flz62f3ikVMnFjXb9Gtpkz0Q
         bjSX1nJBc1rYCeGu1A/Z0G+sj0BQJIna4mn3F/NRU7VAw7AK7sPo4FyOJMM/YX9nYIZE
         ApmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YJE2aPOEkLIKEj61l27Ctrd7+4+SFwAw4jzWQDD0G1c=;
        b=hcign7GKEqG6AtXjaxNdgEyWmIN1uDRjB0uG/KsemPdu/EVOeKg4MspGoviK5xR3s+
         g1OaGi2WHJ5omPyWYD8aAx+92qt/r9rNebZhcP0hWgpAuITaRev8zuMJUKsGAKlFmNH8
         liDM4DLZ71LcwAwkbrqTymOyoXv0h8TFrVLS63MtlevRZkXLOEKSGwWBjHa8gCVtpolp
         PKf6N+Je+H6Udk9qj6s8nc+xApPfpgSjN+v+RKhqRb6O1rfvyn02ZmLkqCPG/vZ9vG8W
         fuV34FMTnT5u/jxnHbrgzzK8qtJv9uDH61WstbLGO6aJzx6jtb5haIYX+lVqnNvwUuWj
         rPUQ==
X-Gm-Message-State: AOAM533IVUdCXLYj3U5mgdNr0oh54FqEjjKwitua0oL27LYIWkJsDVCV
        TYEG2NERECZr8loAQGQSony4Ig==
X-Google-Smtp-Source: ABdhPJxHfVjx5+yi3N1T967Q6Ylxy/lC8PdXs9lSNKroQLsYPplpCwtlj+IXkPC9rhLv30IXV+WFzw==
X-Received: by 2002:a05:622a:1d4:: with SMTP id t20mr2577449qtw.281.1612362799777;
        Wed, 03 Feb 2021 06:33:19 -0800 (PST)
Received: from pop-os.fios-router.home (pool-71-163-245-5.washdc.fios.verizon.net. [71.163.245.5])
        by smtp.googlemail.com with ESMTPSA id v15sm1775433qkv.36.2021.02.03.06.33.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Feb 2021 06:33:19 -0800 (PST)
From:   Thara Gopinath <thara.gopinath@linaro.org>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        bjorn.andersson@linaro.org
Cc:     ebiggers@google.com, ardb@kernel.org, sivaprak@codeaurora.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 10/11] crypto: qce: Remover src_tbl from qce_cipher_reqctx
Date:   Wed,  3 Feb 2021 09:33:06 -0500
Message-Id: <20210203143307.1351563-11-thara.gopinath@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210203143307.1351563-1-thara.gopinath@linaro.org>
References: <20210203143307.1351563-1-thara.gopinath@linaro.org>
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

