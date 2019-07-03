Return-Path: <SRS0=EZcf=VA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08C70C46478
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jul 2019 13:50:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CBA4E218A6
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jul 2019 13:50:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ygibtc7g"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725933AbfGCNuW (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 3 Jul 2019 09:50:22 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:55014 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725943AbfGCNuW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Jul 2019 09:50:22 -0400
Received: by mail-wm1-f65.google.com with SMTP id g135so2297762wme.4;
        Wed, 03 Jul 2019 06:50:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=YFbVXlxoYz2j0yWH+kl6Asgr36XCltStIn0g6Mr9B8w=;
        b=Ygibtc7gTh0+cqjA02xazjen9ww1ScHU0j2G5jXkqHMZmtEfu05BjQPbn5MK8Ln+61
         EjBq/NFluFO5KnsyGCyPHTvG6jM2mN+AuNyfdXhe2J/ZM3vxBHXtf5wIO5o+BPmDwMJm
         GV/N+F9vOP9DYBk0e+tyqVlWcYoWzf2ll2jyTRte6u6Abnw9ol/A51ankU8DBtFqvSkZ
         tUVdPEeUbWSyioBh562LebC2aeKKQx6I7jWR984QpIVZ9QyhClxMWERqxk6LLSY8Dca+
         9w4/V2hPdzZha1HJovwsTBkD75Wijy9EoYcSA+f6OzkkYhuTQXTT/UwvNxaft6i2YiBb
         wlOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=YFbVXlxoYz2j0yWH+kl6Asgr36XCltStIn0g6Mr9B8w=;
        b=epmGl0mc3LMLPP9t+FQOZ0Mfe0tkWD26YPwc//4kVboh9ZXrfclXAV0LTNs4FS97/I
         4+Lq/PbMU6kLIy/ifiFRJuaxXOA9BOXjgQdnzIbZAGmoqaL7lOzfC7WRMtSG2N2UDLka
         lc2SqxlgCN1A+REwDvhUDUxyPH4IcNw9diJuuEpsK3jf1Nwh86AlgJVZLbTN+bZq9Rlw
         NmGcD5ZYfKcm/iDrSZiJQDFaiBZ5iRDI360n/qe+3ZjSi6NNXa+6aVsdqPvG9FXbMqcc
         ydDXcZtY8lziYLPX4fmcxWcyFz/wYLcejCxN0utwBOGxqRBx207YkSV8owgWYg1AGmvm
         ut8w==
X-Gm-Message-State: APjAAAXV5EEIgLbozquHIjx2K6OY+VKNZbfz6U4e2oi/Bsmk/u2mFOGc
        tQdg9pz01hHFGGJblSPHzq4=
X-Google-Smtp-Source: APXvYqwUh87fuoSZF/FPYj+B5TiydkOU+kjZrA/YtS4lovdEJlLn3AcrxHFEkISCsO2az/sjn1zqtQ==
X-Received: by 2002:a7b:cd04:: with SMTP id f4mr8722390wmj.64.1562161820234;
        Wed, 03 Jul 2019 06:50:20 -0700 (PDT)
Received: from puskevit.guest.wlan ([195.142.153.182])
        by smtp.gmail.com with ESMTPSA id t80sm2669920wmt.26.2019.07.03.06.50.18
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 03 Jul 2019 06:50:19 -0700 (PDT)
From:   Fatih ALTINPINAR <fatihaltinpinar@gmail.com>
X-Google-Original-From: Fatih ALTINPINAR
To:     herbert@gondor.apana.org.au
Cc:     davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Fatih ALTINPINAR <fatihaltinpinar@gmail.com>
Subject: [PATCH] Crypto: aegis128l: fix a coding stlye issue
Date:   Wed,  3 Jul 2019 16:49:35 +0300
Message-Id: <20190703134935.24747-1-fatihaltinpinar@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Fatih ALTINPINAR <fatihaltinpinar@gmail.com>

Fixed a coding style issue. Removed curly brackets of an one
line for statement.

Signed-of-by: Fatih ALTINPINAR <fatihaltinpinar@gmail.com>
---
 crypto/aegis128l.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/crypto/aegis128l.c b/crypto/aegis128l.c
index 9bca3d619a22..6c70e718c9c4 100644
--- a/crypto/aegis128l.c
+++ b/crypto/aegis128l.c
@@ -104,9 +104,8 @@ static void crypto_aegis128l_init(struct aegis_state *state,
 	crypto_aegis_block_xor(&state->blocks[6], &crypto_aegis_const[1]);
 	crypto_aegis_block_xor(&state->blocks[7], &crypto_aegis_const[0]);
 
-	for (i = 0; i < 10; i++) {
+	for (i = 0; i < 10; i++)
 		crypto_aegis128l_update_a(state, &chunk);
-	}
 }
 
 static void crypto_aegis128l_ad(struct aegis_state *state,
-- 
2.17.1

