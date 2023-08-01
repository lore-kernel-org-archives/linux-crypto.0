Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCCC7C001E0
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Aug 2023 13:57:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232481AbjHAN53 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 1 Aug 2023 09:57:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231332AbjHAN50 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 1 Aug 2023 09:57:26 -0400
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90840EC
        for <linux-crypto@vger.kernel.org>; Tue,  1 Aug 2023 06:57:18 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id e9e14a558f8ab-3490a1f8ae0so17618715ab.2
        for <linux-crypto@vger.kernel.org>; Tue, 01 Aug 2023 06:57:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google; t=1690898238; x=1691503038;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=V63lX8jJADmT+x3ehocFhAwNy3zEROKPKQmkKeMAkns=;
        b=XisN9mTlhuU084244jOxq6rmViLU82rCKFQtm0CjqcgougXjSCdQGow1jYSz+tRjh8
         lxKt+UFf9ri4gIjw4gO7pdos4kpYqyVdP8WGa7uZobSlzhZpe8z0+qtU+O/07MtbRbD1
         MvcryH0sBl7lUx4XFlKiVasvyU+Y3XSotWELQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690898238; x=1691503038;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=V63lX8jJADmT+x3ehocFhAwNy3zEROKPKQmkKeMAkns=;
        b=UJv+aBL3SZQ4toiPL2g3yF7yeKYQqVzgmfYxin8LeLLoIrwtV4zWkesVvwhT0k+n1M
         LhRYy/ee4lU5yxZmQFHLecYmVwDxDlDm0onOY8nVsGx9ckBqCgPO6nWHvfA57KCjfsH3
         siM1zswjrvbR1hKEJIoWN3NwSj+7aOCaB8gwftOIu99kbaindx81f3BDXspx0EhbTNSs
         mJt871EKwVwdXCyB7+iZaBxig6x8blirRCOwB7hyl4so2dFrXqRwNvIQG+hkUBADeBAO
         ed/UR05hsDYwUieUxqlZ6YRdIQnDhvjOMRSsfFYAvYJkdOVXYkyOXpY9+uWK0cwwY4W7
         7ORQ==
X-Gm-Message-State: ABy/qLanvONRBmOCoqnhtr7MVvcugX7HaVzgH18g+MljrAYjUitZTEQq
        Y5+hIhzif2mixe9mJbW5L2AjWQ==
X-Google-Smtp-Source: APBJJlE0JBSqcsLqZVUTUAYd4lW88JFS1i1F/6t/hSUtRBVdBJ48IvYgSaIlxoMu/WxqEfcFjgW2LQ==
X-Received: by 2002:a92:c9c3:0:b0:348:f28d:d06 with SMTP id k3-20020a92c9c3000000b00348f28d0d06mr5261388ilq.31.1690898237863;
        Tue, 01 Aug 2023 06:57:17 -0700 (PDT)
Received: from CMGLRV3.. ([2a09:bac5:9478:4e6::7d:54])
        by smtp.gmail.com with ESMTPSA id x1-20020a92de01000000b00342f537e3c3sm3834793ilm.2.2023.08.01.06.57.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Aug 2023 06:57:17 -0700 (PDT)
From:   Frederick Lawler <fred@cloudflare.com>
To:     herbert@gondor.apana.org.au, davem@davemloft.net
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@cloudflare.com, Frederick Lawler <fred@cloudflare.com>,
        stable@vger.kernel.org
Subject: [PATCH] crypto: af_alg - Decrement struct key.usage in alg_set_by_key_serial()
Date:   Tue,  1 Aug 2023 08:57:09 -0500
Message-Id: <20230801135709.2218855-1-fred@cloudflare.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Calls to lookup_user_key() require a corresponding key_put() to
decrement the usage counter. Once it reaches zero, we schedule key GC.
Therefore decrement struct key.usage in alg_set_by_key_serial().

Fixes: 7984ceb134bf ("crypto: af_alg - Support symmetric encryption via keyring keys")
Cc: <stable@vger.kernel.org>
Signed-off-by: Frederick Lawler <fred@cloudflare.com>
---
This is rebased ontop of Linus's 6.5-rc1. Original patch was introduced in 6.2.
---
 crypto/af_alg.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index 6218c773d71c..295ede1996a4 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -320,18 +320,21 @@ static int alg_setkey_by_key_serial(struct alg_sock *ask, sockptr_t optval,
 
 	if (IS_ERR(ret)) {
 		up_read(&key->sem);
+		key_put(key);
 		return PTR_ERR(ret);
 	}
 
 	key_data = sock_kmalloc(&ask->sk, key_datalen, GFP_KERNEL);
 	if (!key_data) {
 		up_read(&key->sem);
+		key_put(key);
 		return -ENOMEM;
 	}
 
 	memcpy(key_data, ret, key_datalen);
 
 	up_read(&key->sem);
+	key_put(key);
 
 	err = type->setkey(ask->private, key_data, key_datalen);
 
-- 
2.34.1

