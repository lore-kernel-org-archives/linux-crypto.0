Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C218C433DB
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Jan 2021 19:18:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 492BD233EB
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Jan 2021 19:18:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388578AbhATTSQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Jan 2021 14:18:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392100AbhATSuw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Jan 2021 13:50:52 -0500
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BD74C061799
        for <linux-crypto@vger.kernel.org>; Wed, 20 Jan 2021 10:48:51 -0800 (PST)
Received: by mail-qt1-x829.google.com with SMTP id e15so17009373qte.9
        for <linux-crypto@vger.kernel.org>; Wed, 20 Jan 2021 10:48:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YJE2aPOEkLIKEj61l27Ctrd7+4+SFwAw4jzWQDD0G1c=;
        b=m6OwLILHrvtJ0mcAkErFeiRbxWWnYQiRbK1besy9tN5LjAdkoBV6XlBVPILT+zvLYS
         AdCKcD85a2CobiTu/5b4ig240n/g5sqvOlb+8h73Jp3KXA6jdl8vulXM2ebRLrEkVrHB
         v0UnS0xEsqc2jjZpoestC62hfu4rSj6BUI6mAi9VcDST3nWINy0CoKiwzWq6ytv1HhmM
         +xo5JUn3Q8auef4HYnzIYBanteThfLigipVgs9oeCb1MN9pObdiPswFBTUONuRiAE5Pc
         YfM7mGdmYRciHoqR9wYeczWwinuaSXmUZItKoFwA+Ba4M08Ho0kFAIay0jp+ReTRsLx+
         Psmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YJE2aPOEkLIKEj61l27Ctrd7+4+SFwAw4jzWQDD0G1c=;
        b=JT19UY9lzmVGgOoAZ+Zr4ephsTo3PFIXXPk/6BUmUpONBGR7vBG89+WQ/GljthFU8W
         uxgAYlcuwYTiv3YFrG97M/o1CgmuhSw6JEbowd1URVpH5EZfQAHFvRvYW3J30CbFfCgc
         +PA9mDafCnRq89kPBCfrf3DGjipTa4MYDVQnmNLmBa+YEDbUiZ9oDS/s2hQzdX0Jtgxz
         m9O3GpFN61HPaIQmLc/DjcOq5dsyGXrNzrx9Amroxj6X95/Tb26+usdYVsqkWmIDh+Hw
         ynq2DPp90x6b6+Y3dIUD4gHd8A76lU2b71+Zsxu0+bWefBZNqUjEMJrGsBDFtzRxRePc
         G1wA==
X-Gm-Message-State: AOAM531i7b/nMeOKhPoRZbkNB9Pru1oBpEpmhLkZaSt1hjXVvNMwIYBW
        cklrwb5Hhsktlq3yScAekVEX1A==
X-Google-Smtp-Source: ABdhPJwBQRVf9fK5zpVkbN5OtTOndxzPY2I3DAqDQD5hyvUNFU5gQt4Jcq8xPV0+QalCARaFCDyVSg==
X-Received: by 2002:ac8:721a:: with SMTP id a26mr10364146qtp.223.1611168530758;
        Wed, 20 Jan 2021 10:48:50 -0800 (PST)
Received: from pop-os.fios-router.home (pool-71-163-245-5.washdc.fios.verizon.net. [71.163.245.5])
        by smtp.googlemail.com with ESMTPSA id w8sm1769903qts.50.2021.01.20.10.48.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 10:48:50 -0800 (PST)
From:   Thara Gopinath <thara.gopinath@linaro.org>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        bjorn.andersson@linaro.org
Cc:     ebiggers@google.com, ardb@kernel.org, sivaprak@codeaurora.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 5/6] drivers: crypto: qce: Remover src_tbl from qce_cipher_reqctx
Date:   Wed, 20 Jan 2021 13:48:42 -0500
Message-Id: <20210120184843.3217775-6-thara.gopinath@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210120184843.3217775-1-thara.gopinath@linaro.org>
References: <20210120184843.3217775-1-thara.gopinath@linaro.org>
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

