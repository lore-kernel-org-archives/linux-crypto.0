Return-Path: <SRS0=NifF=5A=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 191CAC10DCE
	for <linux-crypto@archiver.kernel.org>; Sun, 15 Mar 2020 17:42:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D4E7D206B1
	for <linux-crypto@archiver.kernel.org>; Sun, 15 Mar 2020 17:42:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HyTVFmzM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728984AbgCORmo (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 15 Mar 2020 13:42:44 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:36125 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728979AbgCORmn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 15 Mar 2020 13:42:43 -0400
Received: by mail-oi1-f195.google.com with SMTP id k18so15275855oib.3
        for <linux-crypto@vger.kernel.org>; Sun, 15 Mar 2020 10:42:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=Iu+E5wDCASxZ/TQS6RG9jeBsAPsd78QxO09wdHNTWKc=;
        b=HyTVFmzMxdM7CzcXrl6JdXvebyBnUywGcXu20i7uFjZME0sh6Uvw+/vle0opPwvh5E
         DYIJEwJ+VfpAbKrBIf6q0mwVInxGnBwpM8Ls7J6dWt+DxjFsKyhDyrDiqFJasVbS4RzL
         NpD6wy+pSli7wyUt7B/EmQoPkxVIEk3wS21y9fQkmzn6E+ZixAFStpaenw/x/mPDBl0E
         tpZWNRx/o1yArn3XzzbE3lju83rPCv3wSXiSckiqBvE5u2r5glzD4R3F+1dwHObRytDd
         aADALm9QoQCw+aaBywGufOGzNNdkFBgpbA+JQrN6MGkTi941SS7v030zufGKXZmXXOof
         U1OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=Iu+E5wDCASxZ/TQS6RG9jeBsAPsd78QxO09wdHNTWKc=;
        b=cxHQbL39YurTMduCYRbA4sEvMlzMKKhEV196iUITh0GOa9/RrCxPnfREhNOXfKfdFx
         6Y5otyWux3PjMGovIijEmVJ3dG2jKQaBHU5iYfwulyjJEF7DxOZXm5cnfutzPRTQprDS
         WVtsY/POcJUzDcFsVCbdlmP59SDQAWB05/eGn/frRENucdjEG559fPrGbTe2FE7csV4A
         LZQnbcropaG2+Adt3uP3T6fT127FYPuCl2GtQKnXoi/7pxXeVuqNJugd0tT/kD/rzFT/
         o6XntIscB+Go8xzd6ka6xM05FU3SVX1ScDa7uDMcq833Fvn40h1ti98P03uLBxNYr+Cb
         leRg==
X-Gm-Message-State: ANhLgQ33cUMdyLSF0/rp9OCmFLD4J+i0MjvKR5hKmIytr1461v9HeS3D
        qH4ZSUkkBYbEoGfuYh0jEw9c3nvicXgo/ZKR/mge+QBwIWmMdx9p
X-Google-Smtp-Source: ADFU+vtkAaKUyQ5vdj5qQYbGCSKUIpwsD7tBqAof/v95Q4h8Zqrn0plPftqC5JAOUGZNa9PdKrQkxd7mD0blUPSWz8U=
X-Received: by 2002:aca:47c8:: with SMTP id u191mr15287163oia.170.1584294163340;
 Sun, 15 Mar 2020 10:42:43 -0700 (PDT)
MIME-Version: 1.0
From:   Lothar Rubusch <l.rubusch@gmail.com>
Date:   Sun, 15 Mar 2020 18:42:07 +0100
Message-ID: <CAFXKEHahNKcjoU2Zd0XZBPvrSAW87xN5T5DR+rXzQ9uXH6zmPw@mail.gmail.com>
Subject: [PATCH] crypto: bool type cosmetics
To:     herbert@gondor.apana.org.au, davem@davemloft.net
Cc:     linux-crypto@vger.kernel.org, l.rubusch@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From d7e37962c530927952aa0f0601711fba75a3ddf2 Mon Sep 17 00:00:00 2001
From: Lothar Rubusch <l.rubusch@gmail.com>
Date: Sun, 15 Mar 2020 17:34:22 +0000
Subject: [PATCH] crypto: bool type cosmetics

When working with bool values the true and false definitions should be used
instead of 1 and 0.

Signed-off-by: Lothar Rubusch <l.rubusch@gmail.com>
---
 crypto/af_alg.c     | 10 +++++-----
 crypto/algif_hash.c |  6 +++---
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index 439367a8e95c..b1cd3535c525 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -821,8 +821,8 @@ int af_alg_sendmsg(struct socket *sock, struct
msghdr *msg, size_t size,
     struct af_alg_tsgl *sgl;
     struct af_alg_control con = {};
     long copied = 0;
-    bool enc = 0;
-    bool init = 0;
+    bool enc = false;
+    bool init = false;
     int err = 0;

     if (msg->msg_controllen) {
@@ -830,13 +830,13 @@ int af_alg_sendmsg(struct socket *sock, struct
msghdr *msg, size_t size,
         if (err)
             return err;

-        init = 1;
+        init = true;
         switch (con.op) {
         case ALG_OP_ENCRYPT:
-            enc = 1;
+            enc = true;
             break;
         case ALG_OP_DECRYPT:
-            enc = 0;
+            enc = false;
             break;
         default:
             return -EINVAL;
diff --git a/crypto/algif_hash.c b/crypto/algif_hash.c
index 178f4cd75ef1..da1ffa4f7f8d 100644
--- a/crypto/algif_hash.c
+++ b/crypto/algif_hash.c
@@ -83,7 +83,7 @@ static int hash_sendmsg(struct socket *sock, struct
msghdr *msg,
             goto unlock;
     }

-    ctx->more = 0;
+    ctx->more = false;

     while (msg_data_left(msg)) {
         int len = msg_data_left(msg);
@@ -211,7 +211,7 @@ static int hash_recvmsg(struct socket *sock,
struct msghdr *msg, size_t len,
     }

     if (!result || ctx->more) {
-        ctx->more = 0;
+        ctx->more = false;
         err = crypto_wait_req(crypto_ahash_final(&ctx->req),
                       &ctx->wait);
         if (err)
@@ -436,7 +436,7 @@ static int hash_accept_parent_nokey(void *private,
struct sock *sk)

     ctx->result = NULL;
     ctx->len = len;
-    ctx->more = 0;
+    ctx->more = false;
     crypto_init_wait(&ctx->wait);

     ask->private = ctx;
--
2.20.1
