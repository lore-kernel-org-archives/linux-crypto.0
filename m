Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57179C4338F
	for <linux-crypto@archiver.kernel.org>; Sat, 14 Aug 2021 01:11:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3DD7261101
	for <linux-crypto@archiver.kernel.org>; Sat, 14 Aug 2021 01:11:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236322AbhHNBLv (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 13 Aug 2021 21:11:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236317AbhHNBLu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Aug 2021 21:11:50 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DB46C0617AE;
        Fri, 13 Aug 2021 18:11:23 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id l11so14219016plk.6;
        Fri, 13 Aug 2021 18:11:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=q7ftbmGt3dtvIFzhyKs506CMgP9EQiBj0ylWETSYGUU=;
        b=PfjepnBwOReI1jhsRoFZ/vC6hY6vzzrU3moCz4N4T6rgQrxWJqYaxuXGgPXYi2suJ9
         Qg26cY5XM6sWKXe1evMcdw98Muq01SWz1Ro33Eo6nXI99Sz1EPY+p5H+gL1SWVb94Apm
         Nxmz51FWZdbIooz3m51C4dQMyNvs6ziNxbCpmh7Ay7q0efEBGQwsBB05Rvxz55gxo6Hu
         Kr2tL3X9LOBLy6F8z2m8ol2+OATu1hNSTp7ewrxCZZ8QPPEKHLoH3hh/PshwtzON7dPd
         fX2iELBox/G/BKrCbU10c1xRBAmbjzTANvEb0hDVhfEAc0xjfqFogxYKdu9DjsrXp8eu
         S3qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=q7ftbmGt3dtvIFzhyKs506CMgP9EQiBj0ylWETSYGUU=;
        b=OKbZwWVm7imPCEQ18PCJH9Mnw21c0GAUsunu/f34S65Wwus2veAtKINlRWom9PqTLb
         VPhMF/jn3eo/h0DPXXCBaON3la8NoNGi3jSw5UFqFGrBXK1ERo8T61lmRE91tvVZ0Oio
         mYKDbEIh1FNwd6hFVDhCV/0/ABlfkgW+nlGRaHAsSennqjmXaczA9OGrupkgUO5RJOU0
         D0AmeJE6O7CZoNupOO6hGw8K3OSelyNylfcAHqoyDVwHRDO2mYVDLhg6FoZzGtj5I+fS
         XHq4CFwYK1dfCuhmzmMwLN2JPJqiujmuFLBJm4Yi2hEU6ZN0BleWmGDldDCtStasHWZo
         8+Fg==
X-Gm-Message-State: AOAM53169HF8BHurpMkEJwX/3FKJuXoiwIHZEnHO/44f1YDktpR+Ue47
        ZGG/sVSWCA7cKGnlGOTbgYs=
X-Google-Smtp-Source: ABdhPJwKjBgv7YnUfaMkFe3s/Vjd7ZJOK6EP1oHCrED+19jzodYusHhv5U49HcEDcydWmfXiyFmc8g==
X-Received: by 2002:a17:90b:3903:: with SMTP id ob3mr5109566pjb.44.1628903483065;
        Fri, 13 Aug 2021 18:11:23 -0700 (PDT)
Received: from WRT-WX9.. ([141.164.41.4])
        by smtp.gmail.com with ESMTPSA id o20sm4235448pgv.80.2021.08.13.18.11.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Aug 2021 18:11:22 -0700 (PDT)
From:   Changbin Du <changbin.du@gmail.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Changbin Du <changbin.du@gmail.com>
Subject: [PATCH] crypto: in_irq() cleanup
Date:   Sat, 14 Aug 2021 09:11:14 +0800
Message-Id: <20210814011114.4842-1-changbin.du@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Replace the obsolete and ambiguos macro in_irq() with new
macro in_hardirq().

Signed-off-by: Changbin Du <changbin.du@gmail.com>
---
 crypto/skcipher.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index a15376245416..418211180cee 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -431,7 +431,7 @@ static int skcipher_copy_iv(struct skcipher_walk *walk)
 
 static int skcipher_walk_first(struct skcipher_walk *walk)
 {
-	if (WARN_ON_ONCE(in_irq()))
+	if (WARN_ON_ONCE(in_hardirq()))
 		return -EDEADLK;
 
 	walk->buffer = NULL;
-- 
2.30.2

