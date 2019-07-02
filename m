Return-Path: <SRS0=X5ob=U7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCB74C06513
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jul 2019 15:42:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B551A20989
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jul 2019 15:42:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jmSeDWEZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726305AbfGBPmj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 2 Jul 2019 11:42:39 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:38269 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726255AbfGBPmi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 2 Jul 2019 11:42:38 -0400
Received: by mail-ed1-f65.google.com with SMTP id r12so27736592edo.5
        for <linux-crypto@vger.kernel.org>; Tue, 02 Jul 2019 08:42:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=WpAfuuYKHl0ttzhje1hAnELF0mB5eBTpO17OxfOLfP8=;
        b=jmSeDWEZsUlW1BqJ+ZRv55iO/itXo/GgCtLWaUjzlxjzuhkEq2guPWmOlkYAh1DsOq
         D0LPCFC5FpSXSNGnkWCqHI8RHwUZP94RnmP/ghBOsEJ0PBPmyox8h3Wxays/HClkkNsL
         xGH3ZjMm3FGbl4GhAe841izsUCbFBpfApD2IxMG0B+basv9pG4GkOUacbiJhOfnFurix
         Y7D8BGoNfe0TJ1Vsqk4U7zFmdc27+tdEsOk8RuQPlrUy7+a57oEqU0P4d7Q94CHr+wTd
         m7Gbyd0pu/HVmx5QMuoG/ES0PMSDbp3qyHqjPuohdO39SDxoxN4ETItMn0RLZr6hrzef
         7xOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=WpAfuuYKHl0ttzhje1hAnELF0mB5eBTpO17OxfOLfP8=;
        b=edRVtjQ1I2oDfn++yoA1fNdapuOCOZXTX8VjneK49GP4xjIOrzrPqQ+mzne2LUNVTJ
         TgjddEovGGebBMUwBqFg3QXE4qJhxmFSPJRVJb+dsMiefn5Ph7NDDECThcDmk2h12QLS
         UXObaGToKTLX4/WQ2pOYXCcAbydJyPG8RBaq/+g0RPwrWYAU0WJfiUBtA/G2ioxLXXK1
         dDiHML/ss1wF5lA82XlBw8exJgAUuY0YQ3HyH5km8CQ3d4W6yn1tF/43UrVoU0Ob/kuO
         HKQb8xDP2pw8GXP3uNJR/snQr93olPhTauztEuQqf0tKFpTARIQ9gyGnjpz5Pre/GlP+
         DdYA==
X-Gm-Message-State: APjAAAVwRZ9FeOLR6nJhtdA2ZQayq43294vXLInqAWuPr84kkG7pPhKh
        q4GesJEqbi7CB0MbS5Fql3s4QYoi
X-Google-Smtp-Source: APXvYqzvZpv4GbsSXvYYsePhuaQe6u6y7K2N8ZScTyrgYRzyWccwx2fck02h5gQzREjuN5oX6wvzeg==
X-Received: by 2002:a17:906:d0d7:: with SMTP id bq23mr22234445ejb.296.1562082157146;
        Tue, 02 Jul 2019 08:42:37 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id j11sm2341704ejr.69.2019.07.02.08.42.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Jul 2019 08:42:36 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@insidesecure.com>,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCH 5/9] crypto: inside-secure - fix EINVAL error (buf overflow) for AEAD decrypt
Date:   Tue,  2 Jul 2019 16:39:56 +0200
Message-Id: <1562078400-969-8-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1562078400-969-1-git-send-email-pvanleeuwen@verimatrix.com>
References: <1562078400-969-1-git-send-email-pvanleeuwen@verimatrix.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Pascal van Leeuwen <pvanleeuwen@insidesecure.com>

This patch fixes a buffer overflow error returning -EINVAL for AEAD
decrypt operations by NOT appending the (already verified) ICV to
the output packet (which is not expected by the API anyway).
With this fix, all testmgr AEAD (extra) tests now pass.

Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
---
 drivers/crypto/inside-secure/safexcel.h        | 2 +-
 drivers/crypto/inside-secure/safexcel_cipher.c | 7 +++----
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel.h b/drivers/crypto/inside-secure/safexcel.h
index ed47df0..75c6126 100644
--- a/drivers/crypto/inside-secure/safexcel.h
+++ b/drivers/crypto/inside-secure/safexcel.h
@@ -481,7 +481,7 @@ static inline void eip197_noop_token(struct safexcel_token *token)
 #define EIP197_TOKEN_INS_ORIGIN_LEN(x)		((x) << 5)
 #define EIP197_TOKEN_INS_TYPE_OUTPUT		BIT(5)
 #define EIP197_TOKEN_INS_TYPE_HASH		BIT(6)
-#define EIP197_TOKEN_INS_TYPE_CRYTO		BIT(7)
+#define EIP197_TOKEN_INS_TYPE_CRYPTO		BIT(7)
 #define EIP197_TOKEN_INS_LAST			BIT(8)
 
 /* Processing Engine Control Data  */
diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
index c839514..ea122dd 100644
--- a/drivers/crypto/inside-secure/safexcel_cipher.c
+++ b/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -91,7 +91,7 @@ static void safexcel_skcipher_token(struct safexcel_cipher_ctx *ctx, u8 *iv,
 	token[0].stat = EIP197_TOKEN_STAT_LAST_PACKET |
 			EIP197_TOKEN_STAT_LAST_HASH;
 	token[0].instructions = EIP197_TOKEN_INS_LAST |
-				EIP197_TOKEN_INS_TYPE_CRYTO |
+				EIP197_TOKEN_INS_TYPE_CRYPTO |
 				EIP197_TOKEN_INS_TYPE_OUTPUT;
 }
 
@@ -117,14 +117,13 @@ static void safexcel_aead_token(struct safexcel_cipher_ctx *ctx, u8 *iv,
 
 	token[0].opcode = EIP197_TOKEN_OPCODE_DIRECTION;
 	token[0].packet_length = assoclen;
-	token[0].instructions = EIP197_TOKEN_INS_TYPE_HASH |
-				EIP197_TOKEN_INS_TYPE_OUTPUT;
+	token[0].instructions = EIP197_TOKEN_INS_TYPE_HASH;
 
 	token[1].opcode = EIP197_TOKEN_OPCODE_DIRECTION;
 	token[1].packet_length = cryptlen;
 	token[1].stat = EIP197_TOKEN_STAT_LAST_HASH;
 	token[1].instructions = EIP197_TOKEN_INS_LAST |
-				EIP197_TOKEN_INS_TYPE_CRYTO |
+				EIP197_TOKEN_INS_TYPE_CRYPTO |
 				EIP197_TOKEN_INS_TYPE_HASH |
 				EIP197_TOKEN_INS_TYPE_OUTPUT;
 
-- 
1.8.3.1

