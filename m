Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 306F7C433DB
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Feb 2021 11:17:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E117E64DBA
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Feb 2021 11:17:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235680AbhBDLRU (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 4 Feb 2021 06:17:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235715AbhBDLMR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 4 Feb 2021 06:12:17 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32AF1C061225
        for <linux-crypto@vger.kernel.org>; Thu,  4 Feb 2021 03:10:22 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id i9so2643446wmq.1
        for <linux-crypto@vger.kernel.org>; Thu, 04 Feb 2021 03:10:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cxGJzZpz6qA+xiFT2fhj08K+AKiamZQBAjKu1cuB41g=;
        b=jyzJD24RWHuFc5gDwgp323TJgiD6YaBqxMG6JkMwvjTxcEH7LlCcpHG82W+8onqbfD
         IAfOefk8CiqkWG36lQ28CVBCphq/KgkKuepfBF0mbuniWh5ZtkKIbyo+prC9vXxRF2eb
         fFtE0vGQ/sNuTSjxnXD8iI5P6qI7On5v1kbxDeS2yUQ1G5T5G1rrl2SI694sSjiuhbrz
         LgxPl/W8gdORHLo+1GHLho7+XoF9aRSOax5OeXK9lyNMoP37DsfhkerUXNewLL8qtm4z
         i7JGhPPFCuPiavkerDwp4Cs1LhpGQzAQVKjx2gOF7SDXB5Ph0TtQA136NQ6vnyj2KD0D
         Ll4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cxGJzZpz6qA+xiFT2fhj08K+AKiamZQBAjKu1cuB41g=;
        b=J1CrUYiQGuyfNs8h2v8UUgCDjgx/r5f/ln4W9SALqrYJEFY+b3Shx04F3lgJDO0D1l
         bAFRVMYAazFi07PoNFrXgJLqHYIIURqaSDlW40MeQdv9Jo8+X5kDK9ptmflAtMlgJ4Ou
         QSBS7D0LgIygjhmqfU+a+zZy54qkA1l6sQ0GHCMAIjQaU/u2GIrJp8WEHpTQL7gf80d6
         BxhKJfyJbqXSaQrt60MUQQmAdka6a4D8dlaMKrHG1XfRsEJb40XVvUW0y55ni6Wpz7h/
         Z4N2JsFVODfSDYdmLBS6fO1kKgUi11zgTvixbb228bkPDhZGvojixrIT67TpumVv12c+
         6MhA==
X-Gm-Message-State: AOAM530hM6b5c7sxgfxmUmkbIa+LKZzMKPtdgJrrDZFbBInWLSr+sfS1
        KcsyKCjfsgv0bRorQDlAubdFpw==
X-Google-Smtp-Source: ABdhPJwd9xdvyO+0bCKJVzM+EKxnNtd4uas/Onrew1JvEjI4x3rojBBg47BW4DbMHR4XwYf9F06qlg==
X-Received: by 2002:a1c:1b15:: with SMTP id b21mr3911278wmb.116.1612437020990;
        Thu, 04 Feb 2021 03:10:20 -0800 (PST)
Received: from dell.default ([91.110.221.188])
        by smtp.gmail.com with ESMTPSA id y18sm7696218wrt.19.2021.02.04.03.10.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Feb 2021 03:10:20 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
Subject: [PATCH 15/20] crypto: caam: caamalg_qi2: Supply a couple of 'fallback' related descriptions
Date:   Thu,  4 Feb 2021 11:09:55 +0000
Message-Id: <20210204111000.2800436-16-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210204111000.2800436-1-lee.jones@linaro.org>
References: <20210204111000.2800436-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/crypto/caam/caamalg_qi2.c:87: warning: Function parameter or member 'xts_key_fallback' not described in 'caam_ctx'
 drivers/crypto/caam/caamalg_qi2.c:87: warning: Function parameter or member 'fallback' not described in 'caam_ctx'

Cc: "Horia Geantă" <horia.geanta@nxp.com>
Cc: Aymen Sghaier <aymen.sghaier@nxp.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/crypto/caam/caamalg_qi2.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/caam/caamalg_qi2.c b/drivers/crypto/caam/caamalg_qi2.c
index a780e627838ae..22e45c5bf2023 100644
--- a/drivers/crypto/caam/caamalg_qi2.c
+++ b/drivers/crypto/caam/caamalg_qi2.c
@@ -71,6 +71,8 @@ struct caam_skcipher_alg {
  * @adata: authentication algorithm details
  * @cdata: encryption algorithm details
  * @authsize: authentication tag (a.k.a. ICV / MAC) size
+ * @xts_key_fallback: whether to set the fallback key
+ * @fallback: the fallback key
  */
 struct caam_ctx {
 	struct caam_flc flc[NUM_OP];
-- 
2.25.1

