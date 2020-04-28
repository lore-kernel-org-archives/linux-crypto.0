Return-Path: <SRS0=WjNG=6M=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EF88C83004
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Apr 2020 05:14:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7156A206A1
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Apr 2020 05:14:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IiA0PMyj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726271AbgD1FOk (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 Apr 2020 01:14:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725792AbgD1FOk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Apr 2020 01:14:40 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EA18C03C1A9;
        Mon, 27 Apr 2020 22:14:39 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id y25so10120957pfn.5;
        Mon, 27 Apr 2020 22:14:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=8arvZaQJcqNGVCq1UJVOHVfTMEotjihrseoSatxmq9g=;
        b=IiA0PMyjaXBokFQI8HjbvWuWKhVN7VRwjhcXSqZVCAJHIyNLnuFD+d1om4TN3D67bZ
         Js844kN3p3PM9JjbLY0MhOLlcVs7+Gwxi9i8DU7RG72q2Ph/qxmZZFQtrRsDkki27XNh
         QhtWIpp2fYHU9vIReDAjNTjGrBDvv7FZuSJftS9wDVmvD8edIi7DNlPv9mmlH2eSc8Ol
         FXfu2P33y1YeCiG78Xua1hUVat0xkaJK9jcIg7JFHj2NHIlt/EVfky17PDGz9AzW1hSZ
         o3hmsn96kA3s6U4aBVB0rezSnvVmDB2lfJuu8FPJ8FEnUuRc/tbI+pQehI1RCPifkdSo
         0Mow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=8arvZaQJcqNGVCq1UJVOHVfTMEotjihrseoSatxmq9g=;
        b=LkQ9u60O52qxTELIGBpDbkf3XHnQEVpMIXZbTHttUdEgRtmQJoASzxfftOCIPVVJxr
         JDPBVy4bYm/BrWe+Za6+KDsWLy4y8VKYtLCfdNJ5FB6MzNxEKLrWQHYuY/Nu9ldJpF8g
         4xVhKI/gCCTdCQDfwx2aH+XXxuCswQE3GfNPKWWpTBMMhg4L305jQp2gYJpAOfPI6Iwr
         URDKJFd8o9+bKXaDm3t/QW2p176/fVm8jR26TdjU9mvzXfnYxtEArBegwwfvly4IEs0P
         EFa/XXIQ2A1VvMOqx8PNp6OjIIz/3RmF0IoHn/Yb16O1DkZzUqmQG2+e2GFwXnVBDxpL
         ihJw==
X-Gm-Message-State: AGi0PubnZQVzBHLlWtXrCwG9sZx/1S6AF1QPfnjoNpbPZhE+UIh9aAlC
        NG+X3oZ+fVt96R6M5DaVYksWg1jj
X-Google-Smtp-Source: APiQypKQqOZuwUwJz+kHfRdq6rkTbQNY/IS30pLOeUPXbigwQGrZ98fWsrJ1uBct26u9PWrRXqF/3g==
X-Received: by 2002:a62:1789:: with SMTP id 131mr25985808pfx.287.1588050878106;
        Mon, 27 Apr 2020 22:14:38 -0700 (PDT)
Received: from ZB-PF114XEA.360buyad.local ([103.90.76.242])
        by smtp.gmail.com with ESMTPSA id i72sm6319982pfe.104.2020.04.27.22.14.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2020 22:14:37 -0700 (PDT)
From:   Zhenzhong Duan <zhenzhong.duan@gmail.com>
To:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Cc:     horia.geanta@nxp.com, aymen.sghaier@nxp.com,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        Zhenzhong Duan <zhenzhong.duan@gmail.com>
Subject: [PATCH] crypto: caam - fix use after free issue in *_crypt_done
Date:   Tue, 28 Apr 2020 13:14:27 +0800
Message-Id: <20200428051427.508-1-zhenzhong.duan@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

In both aead_crypt_done and skcipher_crypt_done, edesc->bklog is
referenced after the structure pointed by edesc is freed.

Fix them by moving kfree(edesc) to the end of function call.

Signed-off-by: Zhenzhong Duan <zhenzhong.duan@gmail.com>
---
 drivers/crypto/caam/caamalg.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index b7bb7c30adeb..6d746ef5e650 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -973,8 +973,6 @@ static void aead_crypt_done(struct device *jrdev, u32 *desc, u32 err,
 
 	aead_unmap(jrdev, edesc, req);
 
-	kfree(edesc);
-
 	/*
 	 * If no backlog flag, the completion of the request is done
 	 * by CAAM, not crypto engine.
@@ -983,6 +981,8 @@ static void aead_crypt_done(struct device *jrdev, u32 *desc, u32 err,
 		aead_request_complete(req, ecode);
 	else
 		crypto_finalize_aead_request(jrp->engine, req, ecode);
+
+	kfree(edesc);
 }
 
 static void skcipher_crypt_done(struct device *jrdev, u32 *desc, u32 err,
@@ -1022,8 +1022,6 @@ static void skcipher_crypt_done(struct device *jrdev, u32 *desc, u32 err,
 		     DUMP_PREFIX_ADDRESS, 16, 4, req->dst,
 		     edesc->dst_nents > 1 ? 100 : req->cryptlen, 1);
 
-	kfree(edesc);
-
 	/*
 	 * If no backlog flag, the completion of the request is done
 	 * by CAAM, not crypto engine.
@@ -1032,6 +1030,8 @@ static void skcipher_crypt_done(struct device *jrdev, u32 *desc, u32 err,
 		skcipher_request_complete(req, ecode);
 	else
 		crypto_finalize_skcipher_request(jrp->engine, req, ecode);
+
+	kfree(edesc);
 }
 
 /*
-- 
2.17.1

