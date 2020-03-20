Return-Path: <SRS0=WfFd=5F=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06ED6C4332D
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Mar 2020 11:39:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CCDB820722
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Mar 2020 11:39:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Fob+sYuO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726820AbgCTLjM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Mar 2020 07:39:12 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:54513 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726806AbgCTLjM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Mar 2020 07:39:12 -0400
Received: by mail-wm1-f68.google.com with SMTP id f130so4943979wmf.4
        for <linux-crypto@vger.kernel.org>; Fri, 20 Mar 2020 04:39:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YRigaEfZOb6sT9ALedVfWUUmpkTz74jGAgVfZWfCTyQ=;
        b=Fob+sYuOpvGpBI97uCwMjVGbGMOmrvt3Y/dC7S4RCtDMD5T0xSRSIIHqxocScmurq5
         yRIJb5W02subbYSs7Ww3eH0zJeZ8GFQTeVqPUTW9Z7+r/qt1r+o0E22d/1qht2+NuOYU
         LcHhfUFkPU6QD90TEK7INwEnGCRihFkNYL9fmbbn+SsFNSAVOM5ZZN5jdvRbRHaqOaf/
         qShOrBn74lsa5IWT7t5Ncb58bei9s2QnyvsgCihSi2fiex11IQCujaP3NAi6YRVAzBGS
         wa6/v9oeE+ULGAhBJcytnxo43Oyy3VKSZsRSfROhLBcAgXE+jxv+fCD9DJ8R+ET/rqEK
         u05w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YRigaEfZOb6sT9ALedVfWUUmpkTz74jGAgVfZWfCTyQ=;
        b=GUO6Kqe7GjasNu4O9Xtbd6b7Cjy6t2MnqdFgAJMcXLq1hsxYL0GN/NyqrQpj6vsGnH
         ix9QfCbzAzP5gq+xYNCXtzmDtVF0NaPsxfbOou7CYTe1mt9pNDRNeZINjkTl0sYcVFK1
         zw9CoDvmridXp7No6y17nFDeeHdg3FG2A4oubHY+oXKAs//jyOn2qzKlVyFbXW67hCN/
         fqnM8wObtT8GYX5HBJXzP3VRdDUzrLMunCCxvD4dOAcjtvPp0p7QwsLj/sS/Yq1Qc/ig
         tPDFAiTmSaJB3SMBmb9hXaKAKc7ifJnRZKjBgJzEyh7ewmJRG0vrOGrkIbMIopl58uft
         uInQ==
X-Gm-Message-State: ANhLgQ3HhD0KJnnI1Sm5mo5q5NG2JQr0Xd3dJ5OSyXcgwtIm4x4sOblW
        R0NC4WKstC36PqHku/XTSCo=
X-Google-Smtp-Source: ADFU+vuoZwN2FsLhNxRUmKehGqfKNCVWkZpA0JxjubTvOr2xowpZidJgE3lhQI0738wmxlqb9M6Kew==
X-Received: by 2002:a1c:a552:: with SMTP id o79mr2312257wme.87.1584704348381;
        Fri, 20 Mar 2020 04:39:08 -0700 (PDT)
Received: from 344f61f41c50.v.cablecom.net ([195.181.175.111])
        by smtp.gmail.com with ESMTPSA id l12sm7669841wrt.73.2020.03.20.04.39.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2020 04:39:07 -0700 (PDT)
From:   Lothar Rubusch <l.rubusch@gmail.com>
To:     herbert@gondor.apana.org.au, davem@davemloft.net
Cc:     linux-crypto@vger.kernel.org, l.rubusch@gmail.com
Subject: [PATCH v2] crypto: bool type cosmetics
Date:   Fri, 20 Mar 2020 11:36:31 +0000
Message-Id: <20200320113631.2470-1-l.rubusch@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

When working with bool values the true and false definitions should be used
instead of 1 and 0.

Hopefully I fixed my mailer and apologize for that.

Signed-off-by: Lothar Rubusch <l.rubusch@gmail.com>
---
 crypto/af_alg.c     | 10 +++++-----
 crypto/algif_hash.c |  6 +++---
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index 439367a8e95c..b1cd3535c525 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -821,8 +821,8 @@ int af_alg_sendmsg(struct socket *sock, struct msghdr *msg, size_t size,
 	struct af_alg_tsgl *sgl;
 	struct af_alg_control con = {};
 	long copied = 0;
-	bool enc = 0;
-	bool init = 0;
+	bool enc = false;
+	bool init = false;
 	int err = 0;
 
 	if (msg->msg_controllen) {
@@ -830,13 +830,13 @@ int af_alg_sendmsg(struct socket *sock, struct msghdr *msg, size_t size,
 		if (err)
 			return err;
 
-		init = 1;
+		init = true;
 		switch (con.op) {
 		case ALG_OP_ENCRYPT:
-			enc = 1;
+			enc = true;
 			break;
 		case ALG_OP_DECRYPT:
-			enc = 0;
+			enc = false;
 			break;
 		default:
 			return -EINVAL;
diff --git a/crypto/algif_hash.c b/crypto/algif_hash.c
index 178f4cd75ef1..da1ffa4f7f8d 100644
--- a/crypto/algif_hash.c
+++ b/crypto/algif_hash.c
@@ -83,7 +83,7 @@ static int hash_sendmsg(struct socket *sock, struct msghdr *msg,
 			goto unlock;
 	}
 
-	ctx->more = 0;
+	ctx->more = false;
 
 	while (msg_data_left(msg)) {
 		int len = msg_data_left(msg);
@@ -211,7 +211,7 @@ static int hash_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 	}
 
 	if (!result || ctx->more) {
-		ctx->more = 0;
+		ctx->more = false;
 		err = crypto_wait_req(crypto_ahash_final(&ctx->req),
 				      &ctx->wait);
 		if (err)
@@ -436,7 +436,7 @@ static int hash_accept_parent_nokey(void *private, struct sock *sk)
 
 	ctx->result = NULL;
 	ctx->len = len;
-	ctx->more = 0;
+	ctx->more = false;
 	crypto_init_wait(&ctx->wait);
 
 	ask->private = ctx;
-- 
2.20.1

