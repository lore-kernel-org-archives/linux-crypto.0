Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36B3AC433E0
	for <linux-crypto@archiver.kernel.org>; Sun,  7 Feb 2021 14:43:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 02B5264E4E
	for <linux-crypto@archiver.kernel.org>; Sun,  7 Feb 2021 14:43:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230163AbhBGOmn (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 7 Feb 2021 09:42:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229986AbhBGOlz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 7 Feb 2021 09:41:55 -0500
Received: from mail-qv1-xf35.google.com (mail-qv1-xf35.google.com [IPv6:2607:f8b0:4864:20::f35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDF04C061222
        for <linux-crypto@vger.kernel.org>; Sun,  7 Feb 2021 06:39:57 -0800 (PST)
Received: by mail-qv1-xf35.google.com with SMTP id v19so1073163qvl.7
        for <linux-crypto@vger.kernel.org>; Sun, 07 Feb 2021 06:39:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YJE2aPOEkLIKEj61l27Ctrd7+4+SFwAw4jzWQDD0G1c=;
        b=vRZA+bp9CxaDQnbcLIMCP86fsnHA3pAiAQ+Gh6AZO+NavKryjzwTvbla6AvGQpXs4j
         5f7+t6DFu5+mT3AEBZcAEUb6Ps+XJNTnUvvvLyUi2ePkBYR0N7AU/wj85+daDcMKY9sS
         Zde2mF07V+Kq5v6tnXBdFhSYq7jbMteRcxeoD0PG/q2xIKLqkJIFmrmnOwY+L6bOHrqX
         vaUrmzjoxYuF0adNhC5tq2qSe61XtxpNKegICELeNh0z2ffrPyWm1khd3ZfHNhTOzsOX
         j2ZGLeuYzb98FIMOqnxFKsTh2MsYG7QWkoKVuQYRzoWZu3QoK290Es05zpzJ2pvspkNN
         NPWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YJE2aPOEkLIKEj61l27Ctrd7+4+SFwAw4jzWQDD0G1c=;
        b=NFSw60TFa4rF/vnmgALmQSXdinThO5TQan6sqYl2kA+c27nDI6/1uqXBlgykxeb5pi
         V2rVo5VMQQxcCeyT1Sm/2yN92kbF55um/MefZrD+RrZbuahOPD6AJh/mqud9olGz+tW7
         F6zROGKhYnhji8dvZbFMr7UHf+jdvSzN6euQeCilstdgFnbZI3S5yfggAlWoYIQXiC/r
         uH99UtvUM3m/o5E/cQHuBZy7pDF33l+HqosZ/p/BWVA9y2VLMPgrFsETwuVuRJtZfGhM
         SxPFSQ4Xe8Hg3DlY7P4WEB+BdNHbb46a8LXdYMUWH/ltBk6wG7qwHzv47kDIBk25oPYq
         zgbA==
X-Gm-Message-State: AOAM533CPKQn8iFhk4oS2ulO5BaKQs/OXRUZ9m/tdawP3aGe/Hxe//zS
        ef3NeRnG/FH+CwZZ/mqefThFWQ==
X-Google-Smtp-Source: ABdhPJxzoljplC50Tdb6nYh/4X2st4nDncfUkPwTVPCnwyDqvM/wxkHJgxK+bAkl2xuH2moPC8yNyg==
X-Received: by 2002:ad4:4d4c:: with SMTP id m12mr12732537qvm.6.1612708797055;
        Sun, 07 Feb 2021 06:39:57 -0800 (PST)
Received: from pop-os.fios-router.home (pool-71-163-245-5.washdc.fios.verizon.net. [71.163.245.5])
        by smtp.googlemail.com with ESMTPSA id c81sm13941493qkb.88.2021.02.07.06.39.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Feb 2021 06:39:56 -0800 (PST)
From:   Thara Gopinath <thara.gopinath@linaro.org>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        bjorn.andersson@linaro.org
Cc:     ebiggers@google.com, ardb@kernel.org, sivaprak@codeaurora.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v6 10/11] crypto: qce: Remover src_tbl from qce_cipher_reqctx
Date:   Sun,  7 Feb 2021 09:39:45 -0500
Message-Id: <20210207143946.2099859-11-thara.gopinath@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210207143946.2099859-1-thara.gopinath@linaro.org>
References: <20210207143946.2099859-1-thara.gopinath@linaro.org>
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

