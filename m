Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DD47C433F5
	for <linux-crypto@archiver.kernel.org>; Thu, 28 Oct 2021 11:04:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5725760FC4
	for <linux-crypto@archiver.kernel.org>; Thu, 28 Oct 2021 11:04:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229946AbhJ1LHS (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 28 Oct 2021 07:07:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229915AbhJ1LHR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 28 Oct 2021 07:07:17 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2002FC061570;
        Thu, 28 Oct 2021 04:04:51 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id ls14-20020a17090b350e00b001a00e2251c8so4380824pjb.4;
        Thu, 28 Oct 2021 04:04:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BypwsHWenwVGAGqQDl1H6nHdX2y/ObXcsPnl9/SBhVY=;
        b=WTKcTp6DwnnrxydNTA6eoM2AsnwR6Xm4OjZiMLGAOesRWAqXu/42K1Yzxvxs1WVyto
         GY322U2lUie/W6ReHSZW8ro8b54WjyXW+GGbxtC/ew4AzgKOMeJRXa57jdAKldc1p1G2
         zakVpw3j+oPAZCinbYe47BH5bQDYikTrihcr3aE+3gKw5t+z/4eGL0vf0McVnA2gVnE2
         jlwtvihYDV5R9e8IlWk4VAWS0BXf/qWlrgqbuZlVkJf0gDZa2rCSHQPj1IApOoln6Ie4
         V52Shnb/FTS/ieXLvmDFm/Xj4itGEWGlg2By1h4vYFaWiGq8ntnMA40+xX5H7mz/H31Z
         yrJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BypwsHWenwVGAGqQDl1H6nHdX2y/ObXcsPnl9/SBhVY=;
        b=L1qclYu3PvqTAE0D7YPUkXb0pYJTaHfldHfrh71vYnK3H6xnsUKpmZdoQ4YeU1Iplh
         OuilH2JQJn9UVwEoQeZcqXvoWaVokJ6+gkxbqvh7Sy1KHat16nhtZjpijyWitvccLMRF
         wkCaRzNQN26XmET4MIeMMLHGHeQYoiqLvo0715nCIo/hQkoEfhPhKQaCS9L0gz2gmVsD
         Eah5zZXhxI8MCdzvFceFHJsdObS/Irnbl7y3xE2rJ/UxEvIgyvUaRVKQZi8msj4QdQ5w
         d2oMfvgulizELSqC5UqTTDGrCYNIolYCKNJDwGqUG6O6FgDiuUuclEacTmSscJIYMCOP
         MrFw==
X-Gm-Message-State: AOAM530qy7cJMLlkK3WJMv2pNOWpGITA79s4/HLGU2rkPtScxL9kfwjw
        TuCHHzaB1gjSe04fvhZBJlI=
X-Google-Smtp-Source: ABdhPJyJl10wquaSxAU6/x/G6Jg1lqreYS589jXvgsDcuiLwwvULHM5FEXwKQ5jbkWDKBjhdryWiWA==
X-Received: by 2002:a17:90b:3a84:: with SMTP id om4mr11912782pjb.5.1635419090538;
        Thu, 28 Oct 2021 04:04:50 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id a15sm3355728pfv.64.2021.10.28.04.04.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Oct 2021 04:04:50 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: deng.changcheng@zte.com.cn
To:     herbert@gondor.apana.org.au
Cc:     davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Changcheng Deng <deng.changcheng@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] crypto: hisilicon/hpre - use swap() to make code cleaner
Date:   Thu, 28 Oct 2021 11:04:44 +0000
Message-Id: <20211028110444.15287-1-deng.changcheng@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Changcheng Deng <deng.changcheng@zte.com.cn>

Use swap() in order to make code cleaner. Issue found by coccinelle.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Changcheng Deng <deng.changcheng@zte.com.cn>
---
 drivers/crypto/hisilicon/hpre/hpre_crypto.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_crypto.c b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
index a032c192ef1d..f7957197ef10 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_crypto.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
@@ -1177,13 +1177,10 @@ static void hpre_rsa_exit_tfm(struct crypto_akcipher *tfm)
 static void hpre_key_to_big_end(u8 *data, int len)
 {
 	int i, j;
-	u8 tmp;
 
 	for (i = 0; i < len / 2; i++) {
 		j = len - i - 1;
-		tmp = data[j];
-		data[j] = data[i];
-		data[i] = tmp;
+		swap(data[i], data[j]);
 	}
 }
 
-- 
2.25.1

