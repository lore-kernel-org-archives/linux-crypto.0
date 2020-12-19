Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D248CC35270
	for <linux-crypto@archiver.kernel.org>; Sat, 19 Dec 2020 03:32:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9DCB823C81
	for <linux-crypto@archiver.kernel.org>; Sat, 19 Dec 2020 03:32:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726299AbgLSDcC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Dec 2020 22:32:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726476AbgLSDbv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Dec 2020 22:31:51 -0500
Received: from mail-qv1-xf32.google.com (mail-qv1-xf32.google.com [IPv6:2607:f8b0:4864:20::f32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 273C5C0611CE
        for <linux-crypto@vger.kernel.org>; Fri, 18 Dec 2020 19:30:35 -0800 (PST)
Received: by mail-qv1-xf32.google.com with SMTP id p12so1936223qvj.13
        for <linux-crypto@vger.kernel.org>; Fri, 18 Dec 2020 19:30:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YJE2aPOEkLIKEj61l27Ctrd7+4+SFwAw4jzWQDD0G1c=;
        b=K77tGdpSQ+xMM14yYMq1WYAAXE96zJ8N41hgJgBFYB3OEpifFIWHJuYoP/PJyhtstG
         H4aeCDacaVtKytY/VskSNfQEjIij2QkgzN2ym3MHhIE3xK6FOk2/wJTB5r490i7jTjOW
         3KxOsLG/fA2f1oizKJiKhYnqyCmnTWkZ2ya/TNv2rLl6a83I1j8Zuu4s/U+VoIy0ZjJr
         IFFk5/ogPUTi63Pqs7Wpkbot9i5z71+XNuAGxVzff9D5gN2zGzw4YOAiEEZyczIl3I85
         YuZFH5WxHP2hB3BnmoNyiLJPYWLhIDdftVqZsOG5RZxGKj83OuvAE/W7DAdnZNXt4Iit
         tJlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YJE2aPOEkLIKEj61l27Ctrd7+4+SFwAw4jzWQDD0G1c=;
        b=W1wJc/P+AexidnXy6odlaEMXxsXOb44JL0bIge0d+Bbb+LfNaioHpXOZqp2FIr/Ioz
         8I3ZsdrYpHGVVDpk/sKV7nucEEc1IKdTqlKyMNfayKWpgB32jRC04rmIS45EkMQP7Rq+
         eYv1hJ7v+jxMyJC0Qt1h0BaXuJwVZU9oRefM6W34HxAej+D3DTHVsKf+tUpF/h+wUNJA
         s4ovlxbs/t2vv8TbB6qn2SI2EWq/8QliHW5IaHP4gV0zfpHg9KNTc+af43VyDCg1YQyK
         bmdFYVgdcSJQikqy5cbiFLZp0GLZL+qHGAs7t1UKeW8mnotQH9bjOQjEpgmFV1TOqEBl
         GSyA==
X-Gm-Message-State: AOAM532U2gEojzHf9zYNmffrAt4WLWC944x3LiwFOooqzW0gYyIBbvxU
        z7Upr3A9gARZabvfoTg57aftUA==
X-Google-Smtp-Source: ABdhPJyup2brldzwfzliD+vFKuM/4Tbezy87g9fD3vRaKbDzEuyx3TVEO+Ivr7JYD4BjHf/NqxHrsg==
X-Received: by 2002:a0c:b48c:: with SMTP id c12mr7632370qve.9.1608348634463;
        Fri, 18 Dec 2020 19:30:34 -0800 (PST)
Received: from pop-os.fios-router.home (pool-71-163-245-5.washdc.fios.verizon.net. [71.163.245.5])
        by smtp.googlemail.com with ESMTPSA id y16sm4376045qki.132.2020.12.18.19.30.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Dec 2020 19:30:33 -0800 (PST)
From:   Thara Gopinath <thara.gopinath@linaro.org>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        bjorn.andersson@linaro.org
Cc:     ebiggers@google.com, ardb@kernel.org, sivaprak@codeaurora.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/6] drivers: crypto: qce: Remover src_tbl from qce_cipher_reqctx
Date:   Fri, 18 Dec 2020 22:30:26 -0500
Message-Id: <20201219033027.3066042-6-thara.gopinath@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201219033027.3066042-1-thara.gopinath@linaro.org>
References: <20201219033027.3066042-1-thara.gopinath@linaro.org>
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

