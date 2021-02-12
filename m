Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8358EC433E0
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Feb 2021 08:46:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B9D764E65
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Feb 2021 08:46:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbhBLIq4 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 12 Feb 2021 03:46:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbhBLIqz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 12 Feb 2021 03:46:55 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC188C061574;
        Fri, 12 Feb 2021 00:46:14 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id o24so193153wmh.5;
        Fri, 12 Feb 2021 00:46:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9W0viwdJntP7gI+dWPYfiMlk5bPjrilUkTfpNlZbWxk=;
        b=gDOwGzS//QQJgRI7onTiuqDZ2keD2N0xTf5WETdLTC4niVcPBQ/y4qJfImZxtt7VfD
         BHIRE9jJd7uEB25PsY+IerSaRj57+4WCVpI6MI5fgxhaAJvjRp6NXlrJW0TeRxz2kIr1
         vpw5nBw/lChSH0zzq/3yoeYHJGtik4UpwZgR1aCtEOmtHP3qWq/KitaBt7dKyxzKRkgV
         U9D77Rcv4rEr1qS6m0uryq+0WO5M0Xw3D8GmyJJpOB92l64AP1NWFndFDk5lv5QGDQnO
         wN230x38G3ZxE4j2Wey71OqksHpHo9Uvt1UnYfor2F8KDPjGy5u3UyLIYM1LkIc94teE
         F1+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9W0viwdJntP7gI+dWPYfiMlk5bPjrilUkTfpNlZbWxk=;
        b=JsdRviqMrDqNre28KRqN98/u+ICgObF29WLAQnVZINJs/ur4TcRLvb+qzrLyoOxg8I
         aKQJ5dGXR5OAlLOTwpCtJ4BkczKJT0KYFErJBx8aF9gOrsra/3JGgXM0kZZLeOHbTYwH
         PLgs8w0DUtQ7NDL6+48d9P93TQah0bS6l8Z3Ru97MQoY3S14O636FcXHOXZQmDm/CO8/
         x1n39ehp4KYGzM3Sh6V44Lk4BhXfz78lY5BrJKmhXCb9/qC8LqeJhx6MNXXo66d6zSKT
         WEdCYvVYKWQIfEhGxqy+Oc4JO+9I7GxOQaB5jAb7NBnYnKXz/O4dJvOVQaRF1sA7R8Pf
         OHcw==
X-Gm-Message-State: AOAM5338WJuN+SMZm5jTvOr94kmhqa5+FNS29h2RgobIcebolj/S1+OF
        dwNSDxcuxxfuwuFsTJPtyF0=
X-Google-Smtp-Source: ABdhPJyZJ/a5SmKJ8hCB2zTiNZ74x4e3yd/e+MIQVJgA8wy1CfdzxlCjp8o+jiyH8VB1DdClpjgubw==
X-Received: by 2002:a1c:2905:: with SMTP id p5mr1639409wmp.156.1613119573516;
        Fri, 12 Feb 2021 00:46:13 -0800 (PST)
Received: from Red.localdomain ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id j17sm12895530wmc.28.2021.02.12.00.46.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Feb 2021 00:46:13 -0800 (PST)
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     dan.carpenter@oracle.com, davem@davemloft.net,
        herbert@gondor.apana.org.au, jernej.skrabec@siol.net,
        lkp@intel.com, mripard@kernel.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH] crypto: sun8i-ss: fix result memory leak on error path
Date:   Fri, 12 Feb 2021 09:46:10 +0100
Message-Id: <20210212084610.32185-1-clabbe.montjoie@gmail.com>
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

