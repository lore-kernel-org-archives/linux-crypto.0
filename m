Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D37A1C433E0
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Mar 2021 01:42:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A85B64E7A
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Mar 2021 01:42:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238472AbhCCBfs (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 2 Mar 2021 20:35:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1579862AbhCBRLM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 2 Mar 2021 12:11:12 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40C62C06178C;
        Tue,  2 Mar 2021 08:41:49 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id v15so20584174wrx.4;
        Tue, 02 Mar 2021 08:41:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9W0viwdJntP7gI+dWPYfiMlk5bPjrilUkTfpNlZbWxk=;
        b=PdEOlM28X5b1Ll7Y/aYJ3kGEIP1QsxP2nokFGItxFxk5oAYyPpzK8MbrqcuaUxwPw1
         m0dseYB82Z8wNWZQz+qwppcx5LiYwAzOubGer9oYB7UCkP0AgAqBqBIgg11TJMyQlZTA
         gDZNcuxPNWerKUj1YqL3qcdfVTlSy9OZd1whqEhSF6gW4WEtoHbc9CuAKhS70KVY6yAa
         VCQS/xuVAtq3d63mr1MBDmURVyAkGhSbS9KK49fhUy1zPmKSSQkzJ7yPHY+wsNgPygi9
         XylR9eHbh+KgWjfTIwzdFmeWx/SoIZCuKdcwyPqmXj9AGi4ycuOEI3Od6sEDGr8ISZnM
         ZPtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9W0viwdJntP7gI+dWPYfiMlk5bPjrilUkTfpNlZbWxk=;
        b=j8hNC07tTWfOzGM73eLFMubrJIX6BUk/WneT2RFs8Rinxyxb1IcLnxsZfJkLMqBE5t
         tx8UIp4KvnJSDpZ2+/Mp1DhcI7HbtkdLCYtS4PWK/rcuIIcO3xx3fVnBve49iIrIEuQz
         AFjeZsxBE+jTC0Z850X0LBTzvvR6+HVY3qm9chUdoJsdituT5MpC7yU3AMKkRjKMgBCx
         E93vdEm1bxMaUXb888LUdXiMDiMq+W959Ozu20xFcQ9LZPJBl7TjytEh5V/j1lSQu9Xo
         mFrgc2a+ZcQ3fHJfrnwhVilPuwATNcrff+yNjLpKLVXI5WZSnXKhoQ6EAbwT34lyjV/T
         9qBQ==
X-Gm-Message-State: AOAM5315QA20yCuzWUvhjUZHnLlDiq4krjNiPxTxq0xq2i/jsp/OTVNL
        pedrAPp1MTMaToYBipZO7ns=
X-Google-Smtp-Source: ABdhPJzFgCmzI+zTktaikKxMVsMvOJYAhlkzEjqVS88TYQIfiVVm/Y58QJ+dnOI/yP8XToMLqTzkkg==
X-Received: by 2002:adf:e411:: with SMTP id g17mr8273916wrm.225.1614703308022;
        Tue, 02 Mar 2021 08:41:48 -0800 (PST)
Received: from Red.localdomain ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id q15sm29227175wrr.58.2021.03.02.08.41.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Mar 2021 08:41:47 -0800 (PST)
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     dan.carpenter@oracle.com, davem@davemloft.net,
        herbert@gondor.apana.org.au, jernej.skrabec@siol.net,
        mripard@kernel.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe.montjoie@gmail.com>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH] crypto: sun8i-ss: fix result memory leak on error path
Date:   Tue,  2 Mar 2021 17:41:45 +0100
Message-Id: <20210302164145.28552-1-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch fixes a memory leak on an error path.

Fixes: d9b45418a917 ("crypto: sun8i-ss - support hash algorithms")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c
index 11cbcbc83a7b..0b9aa24a5edd 100644
--- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c
+++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c
@@ -438,8 +438,8 @@ int sun8i_ss_hash_run(struct crypto_engine *engine, void *breq)
 	kfree(pad);
 
 	memcpy(areq->result, result, algt->alg.hash.halg.digestsize);
-	kfree(result);
 theend:
+	kfree(result);
 	crypto_finalize_hash_request(engine, breq, err);
 	return 0;
 }
-- 
2.26.2

