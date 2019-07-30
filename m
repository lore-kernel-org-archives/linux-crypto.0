Return-Path: <SRS0=RABd=V3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BE55C433FF
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jul 2019 14:29:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3F3782089E
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jul 2019 14:29:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bUkMzZzy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727865AbfG3O3l (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 30 Jul 2019 10:29:41 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:41340 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727785AbfG3O3l (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Jul 2019 10:29:41 -0400
Received: by mail-ed1-f66.google.com with SMTP id p15so62723528eds.8
        for <linux-crypto@vger.kernel.org>; Tue, 30 Jul 2019 07:29:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=gstk0iS07Su8XYZZPXNeZMCB8RenxLuTadhveJbjwyo=;
        b=bUkMzZzydlW8kUUZD5xDSpxVEz4WZl+x4q5wpAMK8U6ZNB1aI1P3LBEQPk/li53x0c
         YA7qZEybX8zO14+q3FhY/6/7wjZicfbcmN6NC6BvShY/bhXrr16QIdGnwLagGgbntgj0
         xio0iqbVWybJQnLWPzi7VM/Xa7KtbSjnpZa2b9G3cE6cO9dNlI5frmMdspO2zKSCX1Hg
         S8OfVymIbM+oPj6TJSvU34ZQ1Xb8m1JUvX8oRoIC2W9wviziQrOi3YMK3egzcA86KYQk
         nZn2bI8fguhinm0bpljf5IbF+JLOtcx+9FPE1PsGIyAaJg58jCBaill6RkrCNhNtV9er
         t90Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=gstk0iS07Su8XYZZPXNeZMCB8RenxLuTadhveJbjwyo=;
        b=jcfvbVKvr4DF9dro2tEK6N8yIH+aZSw8GaYt08LaLsanGX2rr1F511OkIVZCNECul3
         dZnWw37axzkGEMSljC4aeU44xq+B+NJOeRbFi5o5zKqt+M/klDx9D8YlbQsPGJe67yUH
         JaYZKxwt2R05NpAaSN74C0XP1Njdis3w0+h5yYkE4B52RcL0AUrCkjYPkvPNNzEnra+1
         pK+xYa4/bAFGWQmwDfW4MDbhVfz6v4nwGjUr4wPyE+TwenzI+AhnK/y0DrpTtGVI1dOO
         YEaVk8mI6rjjeeU8AvE0Eg7HAXriayURNCgR1h9rtjj60wIiQ87YC2KWZD8DZe+Ju++F
         +TdQ==
X-Gm-Message-State: APjAAAVzGGVg2xl+I6FrXQD4PKfjnFIiE+34ibeGaL4ZqA/9CSFzQV2C
        Edh2X4Q5WwLvR+Lfq7Z1qAdUvOCd
X-Google-Smtp-Source: APXvYqzDo92bVgJrsWb7lq4CvEyXfVlTWjtoCiHF0KgJmmHSuMwlxl/LXdhR80IynHpJWVKiGZo1sQ==
X-Received: by 2002:a50:ed13:: with SMTP id j19mr54921935eds.8.1564496979505;
        Tue, 30 Jul 2019 07:29:39 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id e29sm15240776eda.51.2019.07.30.07.29.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Jul 2019 07:29:38 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCH 2/2] crypto: inside-secure: This fixes a mistake in a comment for XTS
Date:   Tue, 30 Jul 2019 15:27:12 +0200
Message-Id: <1564493232-30733-3-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1564493232-30733-1-git-send-email-pvanleeuwen@verimatrix.com>
References: <1564493232-30733-1-git-send-email-pvanleeuwen@verimatrix.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This fixes a copy-paste (and forgot to edit) mistake in a comment
for XTS regarding the key length specification.

Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
---
 drivers/crypto/inside-secure/safexcel_cipher.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
index a30fdd5..56dc8f9 100644
--- a/drivers/crypto/inside-secure/safexcel_cipher.c
+++ b/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -1847,7 +1847,7 @@ struct safexcel_alg_template safexcel_alg_xts_aes = {
 		.setkey = safexcel_skcipher_aesxts_setkey,
 		.encrypt = safexcel_encrypt,
 		.decrypt = safexcel_decrypt,
-		/* Add 4 to include the 4 byte nonce! */
+		/* XTS actually uses 2 AES keys glued together */
 		.min_keysize = AES_MIN_KEY_SIZE * 2,
 		.max_keysize = AES_MAX_KEY_SIZE * 2,
 		.ivsize = 16,
-- 
1.8.3.1

