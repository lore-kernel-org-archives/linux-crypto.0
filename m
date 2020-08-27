Return-Path: <SRS0=IKCX=CF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36F39C433DF
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Aug 2020 07:40:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C310207DF
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Aug 2020 07:40:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727935AbgH0Hki (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Aug 2020 03:40:38 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:41408 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727048AbgH0Hkg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Aug 2020 03:40:36 -0400
Received: by mail-lj1-f196.google.com with SMTP id f26so5291497ljc.8;
        Thu, 27 Aug 2020 00:40:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Xi4/bpC2nOhERW4W6wGYCHYDZC3N2KKX9AfZgS9TOgk=;
        b=pvXPGrMEVSxGOWACjDkrCiz8SXSMwlC8nFXZLmNhheSqAIULoq8rgGY5rFhlspegiH
         NvoTdiThCKDIYJfIN/TADWYv40Q9FRCvN5h+p+8haPjkhaHH8W2Mv8LMKr6IqQEHXdYt
         L9giiTg9WBdqcqk6dKVXTBPXtPZ6we4lke+kInzkcw8cZKWEr/BdnikFRGYiV+ehpWeF
         MGlxkdBkQnNrTMsuvGpMhTgBKRl+nxREOAxMcWgxdluICR0pVxku9mOBrc+G9iBkfNF6
         xGUFR0Erizp6C5hHHtOqqf2OpbWMpuiC0jjiIi3YpG72K1CmMh4HzXp9lfVxkaYc1J2f
         uexQ==
X-Gm-Message-State: AOAM530D7GtmTNNPTyoaNvQ62tieIaD5h0uGEuHW6mhoG/rFcyMOKlOf
        VqB//dnM55sen0ftqcowxow=
X-Google-Smtp-Source: ABdhPJw4M73xAaQ+uQ8XWCGjPw1KrfF+G/Xp9DyRTNwop2IGinJ8QCcXPy3zPRGN4xQlRCpOuZ4/zw==
X-Received: by 2002:a2e:7014:: with SMTP id l20mr8695707ljc.162.1598514034102;
        Thu, 27 Aug 2020 00:40:34 -0700 (PDT)
Received: from localhost.localdomain ([213.87.147.111])
        by smtp.googlemail.com with ESMTPSA id 7sm289520ljf.38.2020.08.27.00.40.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2020 00:40:33 -0700 (PDT)
From:   Denis Efremov <efremov@linux.com>
To:     Corentin Labbe <clabbe.montjoie@gmail.com>
Cc:     Denis Efremov <efremov@linux.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: sun8i-ss - remove redundant memzero_explicit()
Date:   Thu, 27 Aug 2020 10:40:23 +0300
Message-Id: <20200827074023.15565-1-efremov@linux.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Remove redundant memzero_explicit() in sun8i_ss_cipher() before calling
kfree_sensitive(). kfree_sensitive() will zero the memory with
memzero_explicit().

Signed-off-by: Denis Efremov <efremov@linux.com>
---
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c
index deb8b39a86db..ed2a69f82e1c 100644
--- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c
+++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c
@@ -248,7 +248,6 @@ static int sun8i_ss_cipher(struct skcipher_request *areq)
 			offset = areq->cryptlen - ivsize;
 			if (rctx->op_dir & SS_DECRYPTION) {
 				memcpy(areq->iv, backup_iv, ivsize);
-				memzero_explicit(backup_iv, ivsize);
 				kfree_sensitive(backup_iv);
 			} else {
 				scatterwalk_map_and_copy(areq->iv, areq->dst, offset,
-- 
2.26.2

