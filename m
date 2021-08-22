Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7DA9C4338F
	for <linux-crypto@archiver.kernel.org>; Sun, 22 Aug 2021 03:45:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C395861220
	for <linux-crypto@archiver.kernel.org>; Sun, 22 Aug 2021 03:45:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232371AbhHVDqE (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 21 Aug 2021 23:46:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232192AbhHVDqD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 21 Aug 2021 23:46:03 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F54EC061575;
        Sat, 21 Aug 2021 20:45:23 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id u15so8170958plg.13;
        Sat, 21 Aug 2021 20:45:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nG/fP2q2RAn5VxaTcM/j9eZOvQ9XxbrcfsGXIrq70lU=;
        b=VQFWPWkfVlHhwXKazmJ6ooYcAEFkIqzti1VOIFMzyPf47ewVLsi3ExQuclIEtSr40M
         Doo3IsZUIZKYfWoYdqdjleo3uRBXn5eZoMFsV6/NkDGUoYQJk5a7EpCDmJ6mjpTldv9H
         HmvO0YCsmrYzMej6fbl9hAhoQI84DzI/IdCcl05eE468Kdy+VG9P4SJXqI7xUxAjjtCx
         Iwmg8SIQRO45/K3CLwbl1mI4+l95q119CCf4fYE40jfj0ad6T4arliFwAgwaUz7oSVKt
         pKzbtmNRLEFTX2QgBoYWTX5SOAwly72jjF1lydeNLMYBX9s8jh15DlV2EnAPJhcxwJG8
         GAVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nG/fP2q2RAn5VxaTcM/j9eZOvQ9XxbrcfsGXIrq70lU=;
        b=KhflycxC6nahAoqKg3QNVSS4CXikzsLl0GrYNoA9fC5Bw+vQpSANVUU8LLXjom+LjC
         cUiHEkPWP3AMpGCmyTWs+L7uysllR9HkcKRGo3bCwiHWvaovqg/MmEsOT9eDTdmlzCvw
         hliO47YLa8NKHfX4qO9Gc+LZSZbILKLomAfQTldXU+N5wqXE8kkvIuxgRGAqhxZxcWi0
         d64tSElIrz1zJUrFbTHK1AvqZOka1R07SM/hlhCGzND52+rTDADIrl3rwHau1HJ4tNoD
         as2llAvECSO6OGhOyxEdytzglF6EaJ2A1jJsC8lEnG4k7Pe/lChjbd0Rtot/yJeT9ctv
         uguw==
X-Gm-Message-State: AOAM530YFCNo4Mc0wWETCgJlUXV46EEAbuTNbluzg4iQsXVqaLSZOdgB
        7kBU0OptkzWgd2v40Cqs3eY=
X-Google-Smtp-Source: ABdhPJzKnkkjIzXgi1tDPo+v2f+wHtm5+3VzFCODnn3N+1zpxycHfhGPuHILK2gEze//H3tV8Ornfw==
X-Received: by 2002:a17:90a:db44:: with SMTP id u4mr12891626pjx.180.1629603922441;
        Sat, 21 Aug 2021 20:45:22 -0700 (PDT)
Received: from fedora.. ([2405:201:6008:6ce2:9fb0:9db:90a4:39e2])
        by smtp.googlemail.com with ESMTPSA id 136sm13841275pge.77.2021.08.21.20.45.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Aug 2021 20:45:22 -0700 (PDT)
From:   Shreyansh Chouhan <chouhan.shreyansh630@gmail.com>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        x86@kernel.org, ardb@kernel.org
Cc:     Shreyansh Chouhan <chouhan.shreyansh630@gmail.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot+20191dc583eff8602d2d@syzkaller.appspotmail.com
Subject: [PATCH v2] crypto: xts_crypt() return if walk.nbytes is 0
Date:   Sun, 22 Aug 2021 09:15:14 +0530
Message-Id: <20210822034514.926652-1-chouhan.shreyansh630@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210820125315.GB28484@gondor.apana.org.au>
References: <20210820125315.GB28484@gondor.apana.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

xts_crypt() code doesn't call kernel_fpu_end() after calling
kernel_fpu_begin() if walk.nbytes is 0. The correct behavior should be
not calling kernel_fpu_begin() if walk.nbytes is 0.

Reported-by: syzbot+20191dc583eff8602d2d@syzkaller.appspotmail.com
Signed-off-by: Shreyansh Chouhan <chouhan.shreyansh630@gmail.com>
---
 arch/x86/crypto/aesni-intel_glue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index 388643ca2177..0fc961bef299 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -849,7 +849,7 @@ static int xts_crypt(struct skcipher_request *req, bool encrypt)
 		return -EINVAL;
 
 	err = skcipher_walk_virt(&walk, req, false);
-	if (err)
+	if (!walk.nbytes)
 		return err;
 
 	if (unlikely(tail > 0 && walk.nbytes < walk.total)) {
-- 
2.31.1

