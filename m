Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EE3AC4332B
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Jan 2021 03:07:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1AAA723107
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Jan 2021 03:07:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387683AbhALDHJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 11 Jan 2021 22:07:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387682AbhALDHJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 11 Jan 2021 22:07:09 -0500
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDD55C0617A9
        for <linux-crypto@vger.kernel.org>; Mon, 11 Jan 2021 19:05:52 -0800 (PST)
Received: by mail-qk1-x731.google.com with SMTP id 143so732602qke.10
        for <linux-crypto@vger.kernel.org>; Mon, 11 Jan 2021 19:05:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YJE2aPOEkLIKEj61l27Ctrd7+4+SFwAw4jzWQDD0G1c=;
        b=FHZHVAvQFH71NDVBauCoz+B55dhLcRsdkajoKvOLnZoyTJq+4I8K9Og8Lk1vZ7rWnC
         DiAOSAnQTdcbeqKTyewqxEjHVDsHsfV9lmTTDtDNmxWm6gSgVHnEf2dEFxMM9lVfjq8F
         c9OTxAEXZTI5VpUbHn9dmEy5km2cowmprq03G6Bt2CxoySAKyTc7v1Oj67n8zIayR0Hy
         VfTyjF63WAR8kcnGg3nf2tPJJfW+awfpEhgVbgV0ggs7IJ78usyrl/lCS3yDrRnIEcSW
         Z++bgygu65OpIU2QEo9w7kjmeYf0DodFQ9F8mSIereqv1n43Yy+zpYvpTK/tfGqoDmVU
         f/AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YJE2aPOEkLIKEj61l27Ctrd7+4+SFwAw4jzWQDD0G1c=;
        b=A0xzR1C2Ser560HNxWHg8FfYhX+6FHz+HOgwJk8VHofKirwZt8QUIso7WO1jvNwK2T
         qjsFM48N7bqALOIPxcS+RyKyS4plCoIXS2fpnY7+dglAXlbT629DbsEBKZuqINvzh4o1
         8fdlzTf+7Y08iYeXak+jqXQkxUsv+0CDsKD3bxKmht1zuHmdczuH3ak0ztCgg8pl6BZy
         nTn7Zu4t5y8knmHfAvftakSqtrztXbytn+1ucbC/bI0A2Nhnn6o4HapvK/vTxdqZ+3am
         1QTXl6BIl+mFbn8643hMy13MX2cpVbSArQSnUL9Ba2YQSAXIvmgVhOsgB4c0/3Y7iEGM
         /EDw==
X-Gm-Message-State: AOAM532gwwg/KWo/+exQ4GlF8B8SXQisN6YDbaavtHMMty7RJVD/oaqn
        srd6xJrcqhh3CSI1o3yufFLgQg==
X-Google-Smtp-Source: ABdhPJxf3e4a0so5Iln3VXaLFeknfpUjHW8w/n+/U729zUA1wQmb98eBT4jX3dIEOaUJmv2zK+oM9w==
X-Received: by 2002:a37:5b85:: with SMTP id p127mr2514915qkb.180.1610420752138;
        Mon, 11 Jan 2021 19:05:52 -0800 (PST)
Received: from pop-os.fios-router.home (pool-71-163-245-5.washdc.fios.verizon.net. [71.163.245.5])
        by smtp.googlemail.com with ESMTPSA id c7sm814235qkm.99.2021.01.11.19.05.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jan 2021 19:05:51 -0800 (PST)
From:   Thara Gopinath <thara.gopinath@linaro.org>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        bjorn.andersson@linaro.org
Cc:     ebiggers@google.com, ardb@kernel.org, sivaprak@codeaurora.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 5/6] drivers: crypto: qce: Remover src_tbl from qce_cipher_reqctx
Date:   Mon, 11 Jan 2021 22:05:44 -0500
Message-Id: <20210112030545.669480-6-thara.gopinath@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210112030545.669480-1-thara.gopinath@linaro.org>
References: <20210112030545.669480-1-thara.gopinath@linaro.org>
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

