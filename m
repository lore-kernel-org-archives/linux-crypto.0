Return-Path: <SRS0=kkEj=VC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C8F2C5B57D
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Jul 2019 09:19:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2C9F12147A
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Jul 2019 09:19:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IPuSXLRr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727010AbfGEJTz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 5 Jul 2019 05:19:55 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:34565 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726116AbfGEJTy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 5 Jul 2019 05:19:54 -0400
Received: by mail-ed1-f67.google.com with SMTP id s49so7669476edb.1
        for <linux-crypto@vger.kernel.org>; Fri, 05 Jul 2019 02:19:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=D65aWDbv/4VC+dU+H1d7BrPwuYTp9yWxRRias8MoVDg=;
        b=IPuSXLRrR+pa/MEv4Vo9Cyo/mPlOXLf6Gl78qU5ThL8B4jMzb+cYBRCNhPyThFwdtG
         f8WJHpXQH9f9lTw8E8Zo5vMjlpfpU6wscizmHRr3dN0wXyai0Fz6B20AXKpuq/fjah/A
         f7Azn7BMQ0r4DOU9lwLiGPXad6W5LgidMZ0AnF/TPWtzbJm11zXfJLnKEX5CzK5CKPb+
         JSr4hUlAqULktB9paD2mqEJuhWyp+MksvblGnDlUSHdQlkSoOgQ9W65Ja3aRR/EqMkA2
         7uvGDYDgPh7FbriSQn8NqYZWf6xPKfXO6gUmv9j2WCeMqSWsGEE8i+bPTSOqb3Eyxbc6
         MJDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=D65aWDbv/4VC+dU+H1d7BrPwuYTp9yWxRRias8MoVDg=;
        b=b+juh1ZiF1t4/Wfuni6Yo5ydDGVHdvys7kRRaPGPoR547DS+1LzDWlmUFb0WPwd/xQ
         4/0ZRCfOnaYgeDK2+ROqqQeMbz3nObTJl4Q/XofaCpfUpe9OYOIcF6aiWSbF5hwuZT8w
         BcK7dAa1QWEui9cd1xJwOFIzyer9OKnDrhr+Lzm3U2PMqmr4PFkk+Qm5XcWy/YJE+jWj
         eXVhkZD4T3jOjfk0XPSII2jc7a9/m/XnhKHGxJLyhkw1+FDm2zfzViMNhq7Pom/iz3JM
         usD1RowwkoSjqDfo7Dt2ujMm77TKbVyj9cMluWtGpCuV/maWAPK+XWBAO9uH7PUTh8R8
         Z6cA==
X-Gm-Message-State: APjAAAWHDQvEx0j3GwK8FkBNiqSR/yeHYkhu9qV0I4qo12Eg3tcLCXc8
        cGgyM1fC8AdsvuWgPcPVu/iu93El
X-Google-Smtp-Source: APXvYqyDrE2m5BpFlVypgGBSRVRAeZCuzIzgtp2rFWs6Ckn1BuIidTttMYyp8REmOvd0rYaFq8pjwg==
X-Received: by 2002:a17:906:7382:: with SMTP id f2mr2468051ejl.88.1562318393027;
        Fri, 05 Jul 2019 02:19:53 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id c49sm2537078eda.74.2019.07.05.02.19.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 Jul 2019 02:19:52 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCH] crypto: inside-secure - remove unused struct entry
Date:   Fri,  5 Jul 2019 10:17:25 +0200
Message-Id: <1562314645-22949-1-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch removes 'engines' from struct safexcel_alg_template, as it is
no longer used.

Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
---
 drivers/crypto/inside-secure/safexcel.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/crypto/inside-secure/safexcel.h b/drivers/crypto/inside-secure/safexcel.h
index 379d0b0..30a222e 100644
--- a/drivers/crypto/inside-secure/safexcel.h
+++ b/drivers/crypto/inside-secure/safexcel.h
@@ -660,7 +660,6 @@ struct safexcel_ahash_export_state {
 struct safexcel_alg_template {
 	struct safexcel_crypto_priv *priv;
 	enum safexcel_alg_type type;
-	u32 engines;
 	union {
 		struct skcipher_alg skcipher;
 		struct aead_alg aead;
-- 
1.8.3.1

