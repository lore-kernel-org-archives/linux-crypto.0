Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBD7CC4338F
	for <linux-crypto@archiver.kernel.org>; Fri, 30 Jul 2021 13:42:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B129E60F5E
	for <linux-crypto@archiver.kernel.org>; Fri, 30 Jul 2021 13:42:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231177AbhG3NmK (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 30 Jul 2021 09:42:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231139AbhG3NmJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 30 Jul 2021 09:42:09 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 670EEC06175F;
        Fri, 30 Jul 2021 06:42:04 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id e21so11135820pla.5;
        Fri, 30 Jul 2021 06:42:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Z+UTgWp+zpv9uq3n8GwXOFwx+FHu79iX7o0OWQdHhjs=;
        b=Fyip1ATb2rFxi2IRFfNqc3Rp9q8MpYQhoKqPhz+cUWvKRIrbPjBlNo8ksvNHZcSSyA
         7w0qcPeYLvmu+WKHtURXVpZNFu19fGN6SU9VqZHnPJEl4jEGnGxbL9KXBi63zHNBaeH/
         LIhyHYgoTv0hvHRpaRe9uTGA1aOCFYoV7e4fEIghn1BLHbuiNqJHEqU1j4uBAklG10Wi
         J1aDZKDbmt9iNDNdRGyxCRPIhZ1Oy10pxYMRwzG98naage6qzU2sxvhKK8rBY4gQSiqw
         3xf4t6QeBm/Niy6BP2RqgNuQiU/iwjuFXvhfBW64FfBKWzUv/foc0uZiilBE8CQ/zFe3
         HFFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Z+UTgWp+zpv9uq3n8GwXOFwx+FHu79iX7o0OWQdHhjs=;
        b=EawqQXuSwpe93zP452UNfkOpZjcCNOOzUDTAUjeJBSuALN7nt7BP88A/NDdj10XUcX
         3U3vuyekQ2yaTnCK+Yh3OwTrgyWsd9sJptXUa1PyO5Y1iQ29MZJoSkGAJAwrdCTdhQy2
         rF6SpAo0J+ys9Jc+AQrsFFCSO+sA8BZG0PshjABu2sO1CfTQQWy+a0gqZ3wDLA1EAZ73
         MDBGIhBBEb8wSfVOzE4LRoPiFG8mzTXDUlhXRCpPrJceRFM7peZ998C8Uei5MD1Y7dz4
         qGRIiFQwGYHPvNmAY9F16sWp1jQPqy1Tlu4mw7jjPGe2tafHObjSEmkkUtIdyZvh4Rkn
         17gQ==
X-Gm-Message-State: AOAM533n3+TU7UCfzFJMF00g0Ba/O0M2fHRlbtcBNcuHzFolPBIEni1C
        swj5NtwmaZGsyHoud2l9lgs=
X-Google-Smtp-Source: ABdhPJxBM8keu1unzD/GluhY0ROU1+97tKmo2Yp4H+Bl941FJpfzGqDhGI3Jf/lO34gqqBGZTBKAag==
X-Received: by 2002:a17:902:b493:b029:12b:aed5:ce06 with SMTP id y19-20020a170902b493b029012baed5ce06mr2572207plr.18.1627652523873;
        Fri, 30 Jul 2021 06:42:03 -0700 (PDT)
Received: from fedora.. ([49.36.215.73])
        by smtp.googlemail.com with ESMTPSA id j13sm2517789pjl.1.2021.07.30.06.41.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Jul 2021 06:42:03 -0700 (PDT)
From:   Shreyansh Chouhan <chouhan.shreyansh630@gmail.com>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        hpa@zytor.com
Cc:     Shreyansh Chouhan <chouhan.shreyansh630@gmail.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot+20191dc583eff8602d2d@syzkaller.appspotmail.com
Subject: [PATCH] crypto: add missing kernel_fpu_end() call
Date:   Fri, 30 Jul 2021 19:11:55 +0530
Message-Id: <20210730134155.1005358-1-chouhan.shreyansh630@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

xts_crypt() code doesn't call kernel_fpu_end() after calling
kernel_fpu_begin() if walk.nbytes is 0. Add a call to kernel_fpu_end()
for this case.

Reported-by: syzbot+20191dc583eff8602d2d@syzkaller.appspotmail.com
Signed-off-by: Shreyansh Chouhan <chouhan.shreyansh630@gmail.com>
---
 arch/x86/crypto/aesni-intel_glue.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index 2144e54a6c89..bd55a0cd7bde 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -894,6 +894,9 @@ static int xts_crypt(struct skcipher_request *req, bool encrypt)
 			kernel_fpu_begin();
 	}
 
+	if (walk.nbytes == 0)
+		kernel_fpu_end();
+
 	if (unlikely(tail > 0 && !err)) {
 		struct scatterlist sg_src[2], sg_dst[2];
 		struct scatterlist *src, *dst;
-- 
2.31.1

