Return-Path: <SRS0=juXm=2K=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 037F1C43603
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Dec 2019 19:03:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D232020866
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Dec 2019 19:03:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rPBICheQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727473AbfLTTDB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Dec 2019 14:03:01 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:34479 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727390AbfLTTDB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Dec 2019 14:03:01 -0500
Received: by mail-pj1-f68.google.com with SMTP id s94so4197395pjc.1
        for <linux-crypto@vger.kernel.org>; Fri, 20 Dec 2019 11:03:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Az4hfXTopX7SrfF1whWHLS+fjneINDp+zU6Cq6OOuU4=;
        b=rPBICheQoVAzsZ2tln0x+1e9/YenkBMqvTTvQ4+LtS6qG7ZaOVx2D9p5RkYNzux9jK
         nizzsKP+6Pzxl6f8MkQUUXQ6J2PiiQU/jZnEQj2umbVwYuQPU67Mds/e6/9WnRpHup/8
         1kIi3xYAhAmSOrXPJPQp+lRMHpRoDbWtnrToQLugwLxrbCnYsV4gpGdxCA5MpeQfk75H
         auWeSk9zjw+7Msh6EFNHOrAsyVBkOB9mx100S1dOw91w1rZCkIG4YRGprbDqH8QEytGQ
         yR97LGTy93M3MCdQOSUV/BJfzElwI5lf1ZiodjvlDhyAbHf7rGEwRGpDSdHC+aJ+P/8o
         05Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Az4hfXTopX7SrfF1whWHLS+fjneINDp+zU6Cq6OOuU4=;
        b=V+gC2ARDTkwNm6oErpsz31M+n6JFIOfiWC7IaZIfY3ZlWxHK1Py1UPQiAojO5R+9ZM
         NIc0V9b53c0GgGLA2tYcm+k673dP0Yd6+gHbmpbMzIW9Jt+QI/p7jlADG4VAYakLhTyN
         HxX1OTqD6jnStTxxkmPYcy1hOr/8E+5Y8/J1shHLO4JW4SCxbLx+6mbDvnW2m1zcmPSw
         RL/N/cpX0KIlD9aR5bWgOZmsumF8xPjLTZGc3ducsJFEzREgKwzfHrHD7WSB+56QH5YD
         Rz9nZP6K+z70gDIGN7LdelNZo7ocal9IjdiC3+p7QQCM73+Y0NhKk2Wq75bE7yR80xU/
         HQCw==
X-Gm-Message-State: APjAAAXBcKlrsMZYGmihYNjQjPDmb/8RjLdo1zcuIApMff/kreY4CpG2
        rAjWowsxvA9OBWdpgYtOiPc=
X-Google-Smtp-Source: APXvYqysOn0HgJF6hHXWiJEUMy3SFDH+X0kH3ZyIKABEsX74AwvpFD1erJKlJHvp5+SRvgeIjmfEzA==
X-Received: by 2002:a17:90a:2004:: with SMTP id n4mr18027020pjc.20.1576868580484;
        Fri, 20 Dec 2019 11:03:00 -0800 (PST)
Received: from gateway.troianet.com.br (ipv6.troianet.com.br. [2804:688:21:4::2])
        by smtp.gmail.com with ESMTPSA id i4sm10833612pjw.28.2019.12.20.11.02.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Dec 2019 11:03:00 -0800 (PST)
From:   Eneas U de Queiroz <cotequeiroz@gmail.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
Cc:     Eneas U de Queiroz <cotequeiroz@gmail.com>
Subject: [PATCH 1/6] crypto: qce - fix ctr-aes-qce block, chunk sizes
Date:   Fri, 20 Dec 2019 16:02:13 -0300
Message-Id: <20191220190218.28884-2-cotequeiroz@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191220190218.28884-1-cotequeiroz@gmail.com>
References: <20191220190218.28884-1-cotequeiroz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Set blocksize of ctr-aes-qce to 1, so it can operate as a stream cipher,
adding the definition for chucksize instead, where the underlying block
size belongs.

Signed-off-by: Eneas U de Queiroz <cotequeiroz@gmail.com>
---
 drivers/crypto/qce/skcipher.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/qce/skcipher.c b/drivers/crypto/qce/skcipher.c
index fee07323f8f9..1f1f40a761fa 100644
--- a/drivers/crypto/qce/skcipher.c
+++ b/drivers/crypto/qce/skcipher.c
@@ -270,6 +270,7 @@ struct qce_skcipher_def {
 	const char *name;
 	const char *drv_name;
 	unsigned int blocksize;
+	unsigned int chunksize;
 	unsigned int ivsize;
 	unsigned int min_keysize;
 	unsigned int max_keysize;
@@ -298,7 +299,8 @@ static const struct qce_skcipher_def skcipher_def[] = {
 		.flags		= QCE_ALG_AES | QCE_MODE_CTR,
 		.name		= "ctr(aes)",
 		.drv_name	= "ctr-aes-qce",
-		.blocksize	= AES_BLOCK_SIZE,
+		.blocksize	= 1,
+		.chunksize	= AES_BLOCK_SIZE,
 		.ivsize		= AES_BLOCK_SIZE,
 		.min_keysize	= AES_MIN_KEY_SIZE,
 		.max_keysize	= AES_MAX_KEY_SIZE,
@@ -368,6 +370,7 @@ static int qce_skcipher_register_one(const struct qce_skcipher_def *def,
 		 def->drv_name);
 
 	alg->base.cra_blocksize		= def->blocksize;
+	alg->chunksize			= def->chunksize;
 	alg->ivsize			= def->ivsize;
 	alg->min_keysize		= def->min_keysize;
 	alg->max_keysize		= def->max_keysize;
