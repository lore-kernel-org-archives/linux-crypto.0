Return-Path: <SRS0=w8RP=WS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B3F3C3A5A1
	for <linux-crypto@archiver.kernel.org>; Thu, 22 Aug 2019 15:47:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D5C2823400
	for <linux-crypto@archiver.kernel.org>; Thu, 22 Aug 2019 15:47:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="NAKrHCFJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387888AbfHVPri (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 22 Aug 2019 11:47:38 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:54244 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387880AbfHVPri (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 22 Aug 2019 11:47:38 -0400
Received: by mail-wm1-f68.google.com with SMTP id 10so6121472wmp.3
        for <linux-crypto@vger.kernel.org>; Thu, 22 Aug 2019 08:47:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=ePEhvI4Ou85as0xCHV2LBgE4jtxI043xEpOM+J7yQmU=;
        b=NAKrHCFJmq8WKxoxGP/IRY1YFhYN7z4m+YH8w/gA21gZ44+QyW5djQ+Fkb8KEguhQ5
         UZUmxVoot1+faBVGjFdbM2rTTz6NLrBgminmlzDxGXgl+grvpIyx8kkcTLN21cybjAaw
         k2hXF9320G1s2xOTSFqMjprtVCL7UwE8PwvvalPtFBuztq41tC6urXcFDMqudAyiNip6
         jvPMxh6AY16oVhUwSqX0tZT/GP3WIdae07NMKzicBpajyhlA8cIH0Gs3xYilVkVTbRB4
         qYwL1j30y70gCMEr9XUU3ysBM7lRSguW41bFtOT2F9pS9U3o1H7wHtsstkQlaRRzwgC4
         HgDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ePEhvI4Ou85as0xCHV2LBgE4jtxI043xEpOM+J7yQmU=;
        b=tKTLPFMK2MDNI/L85JbV0xJt4McdTCcyFsL/wQ0SK6k/Lgfa0ORq1GI8PuMan0cD4O
         RGOw7apoEYX1pd/kgwgPeGcPWopQZoB+Bzuu7v3aMYs6SB6nZGmbantpWSV1mVsqv2tH
         GlnwXbiC0eJH2yAH400O+HXS1NhHLeiohSP2Wmt9iC0FauQUFmVSWDD4uqPqzHCEPYsT
         9/V9SozrV+aR4jT+nL1j9lLQHMAk4Fk+W0/rmg3LQb5Y5W6H/ypuDpIjlIKLmOxIxAKK
         ocsrMZIKtNfv4ux/9PSH5J5cmGaZlXPhTegsGpa9NixiobzlbaNvx3HV6xLMHhRPo2Sr
         qzTQ==
X-Gm-Message-State: APjAAAUrglpD1oi3xbGKd2MKpQPi0TyZp1FrbjQ0dVyGTC/OCXMajKu6
        BBsLeGRueWeSvTA/sDYBxosEdJktS2VdMw==
X-Google-Smtp-Source: APXvYqyNKdZtQJW2eRwHXoJNvpP5SXDzLDDLHDeCqNh2NEYwxtolQbqEAiuY3M1FSHXXsBPLg90c3w==
X-Received: by 2002:a05:600c:24cf:: with SMTP id 15mr7265597wmu.76.1566488856953;
        Thu, 22 Aug 2019 08:47:36 -0700 (PDT)
Received: from localhost.localdomain (adsl-91.109.242.50.tellas.gr. [109.242.50.91])
        by smtp.gmail.com with ESMTPSA id e10sm637wrn.33.2019.08.22.08.47.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Aug 2019 08:47:36 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Gary Hook <gary.hook@amd.com>
Subject: [PATCH] crypto: ccp - invoke fallback for XTS ciphertext stealing
Date:   Thu, 22 Aug 2019 18:47:31 +0300
Message-Id: <20190822154731.13301-1-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

For correctness and compliance with the XTS-AES specification, we are
adding support for ciphertext stealing to XTS implementations, even
though no use cases are known that will be enabled by this.

Since the ccp driver already has a fallback skcipher standby for
dealing with input sizes other than [16, 512, 1024, 2048, 4096],
just drop the check against the block size.

Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Gary Hook <gary.hook@amd.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/crypto/ccp/ccp-crypto-aes-xts.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-crypto-aes-xts.c b/drivers/crypto/ccp/ccp-crypto-aes-xts.c
index 783ba75e0618..8e4a531f4f70 100644
--- a/drivers/crypto/ccp/ccp-crypto-aes-xts.c
+++ b/drivers/crypto/ccp/ccp-crypto-aes-xts.c
@@ -116,9 +116,6 @@ static int ccp_aes_xts_crypt(struct ablkcipher_request *req,
 	if (!ctx->u.aes.key_len)
 		return -EINVAL;
 
-	if (req->nbytes & (AES_BLOCK_SIZE - 1))
-		return -EINVAL;
-
 	if (!req->info)
 		return -EINVAL;
 
-- 
2.17.1

