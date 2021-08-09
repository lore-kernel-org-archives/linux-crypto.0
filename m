Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83ADEC4338F
	for <linux-crypto@archiver.kernel.org>; Mon,  9 Aug 2021 14:10:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F5CE60E52
	for <linux-crypto@archiver.kernel.org>; Mon,  9 Aug 2021 14:10:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234389AbhHIOK5 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 9 Aug 2021 10:10:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233795AbhHIOK5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 9 Aug 2021 10:10:57 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19979C0613D3;
        Mon,  9 Aug 2021 07:10:37 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id t7-20020a17090a5d87b029017807007f23so31608394pji.5;
        Mon, 09 Aug 2021 07:10:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MUFNVlpNdlRwJoHqLGAZnu3q9EuzmxJ1VBkQMu2Z0H4=;
        b=f6mvq4ui2kWc0N6EALaDC8ssLCvnvtkvKy/P95WQ1nivu/AcJkT3bRlsK5ayCJddpb
         gdPpCb25NwZNBWcEHlLjZMU8yELiwt5nuswOPx9+HeXY9mCgf6CfmZgqaYbnIL3LfLMq
         GYMWsdE9Q2yDriL13wKIF3JX1IDLqHUkjMUIuN75yx30/YwN7BO909Jz/eN2qHamC793
         Sim30bCUv57QdSZErsEr7v34HNwdB04ODzTT6wf25IyW/cGSVTUYH1S2oT+LNkx61ABX
         sFDAvqNxUFddyqqEwTNjnEcAOimOgEjEMlEhTwBBs+M5RdboRh0oLIydbZCVcXSHrppu
         sCGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MUFNVlpNdlRwJoHqLGAZnu3q9EuzmxJ1VBkQMu2Z0H4=;
        b=g8Y3Db9fRNDdEi5+qcURreZqLw9yxyCFhyC1/FSDGhZeZrL3/LIS1LI9lG2/7QcbOc
         5//w0lg15lo27qSu6/Flp9xH7EI35VSAxIGaBUAlza4d4H2XwGucw0BFReY7NraWgyhd
         9nrmHvz5ui8XDCAB2TJBZK+XWlCCo2rAYPCmadmOA68H3S5seMmmWdWken2baegvFvTm
         S4WBaU4sJ+gGM5UAYeZICc49a4LCDhrR9+P/WWcwHwMVIdlfnHA4OYHeLufzQ2HkH4Ze
         zddcWWt4GKEO22S1mPA7YJ9brXSInEpjveFHRHQYWWldl/MdRG8cCwWU9rH5CSkrRVBE
         r6YQ==
X-Gm-Message-State: AOAM530v5xbE78qr1WYnVJX7seyB9cyHzC5FN9rq9WVJNxX94lLW502k
        gNjqms4V8MArq+Ql9Do1mOY=
X-Google-Smtp-Source: ABdhPJw7uIFi2b2Q6gjI2GPARWEmnnM1MxiiZJN+wFz9CDDFStnpfUdNCBDI36LTrAzrpSApLWsabg==
X-Received: by 2002:a17:90a:150d:: with SMTP id l13mr25476491pja.93.1628518236573;
        Mon, 09 Aug 2021 07:10:36 -0700 (PDT)
Received: from fedora.. ([2405:201:6008:6ce2:9fb0:9db:90a4:39e2])
        by smtp.googlemail.com with ESMTPSA id 136sm24551417pge.77.2021.08.09.07.10.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 07:10:36 -0700 (PDT)
From:   Shreyansh Chouhan <chouhan.shreyansh630@gmail.com>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        hpa@zytor.com, ardb@kernel.org
Cc:     Shreyansh Chouhan <chouhan.shreyansh630@gmail.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot+20191dc583eff8602d2d@syzkaller.appspotmail.com
Subject: [PATCH] crypto: xts_crypt() return if walk.nbytes is 0
Date:   Mon,  9 Aug 2021 19:40:27 +0530
Message-Id: <20210809141027.860850-1-chouhan.shreyansh630@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <YQ0Qm+Xs1g/7Eant@fedora>
References: <YQ0Qm+Xs1g/7Eant@fedora>
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
index 388643ca2177..ec6eac57c493 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -849,7 +849,7 @@ static int xts_crypt(struct skcipher_request *req, bool encrypt)
 		return -EINVAL;
 
 	err = skcipher_walk_virt(&walk, req, false);
-	if (err)
+	if (err || !walk.nbytes)
 		return err;
 
 	if (unlikely(tail > 0 && walk.nbytes < walk.total)) {
-- 
2.31.1

