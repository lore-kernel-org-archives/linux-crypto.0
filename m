Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEFDFC43217
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Nov 2021 18:20:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B5C42634BC
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Nov 2021 18:20:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237434AbhKOSXD (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 15 Nov 2021 13:23:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241204AbhKOSSq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 15 Nov 2021 13:18:46 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B6E7C03D783
        for <linux-crypto@vger.kernel.org>; Mon, 15 Nov 2021 09:41:08 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id t1-20020a6564c1000000b002e7f31cf59fso1013523pgv.14
        for <linux-crypto@vger.kernel.org>; Mon, 15 Nov 2021 09:41:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=jpkiYNoU4Rt1WYtil9Ur4r8Q6chgaPPrn/vLi4efF9g=;
        b=G3pcIYNysMhR6NM66p0uo164DAAStqlIf6AwN268H6ksfaCnPKRR/89VetMeFilplI
         psmOOEU54SZ8Uh0mJF69xG3tmYG6Tj5dB3wrKrj1x1Jrvv2ShARB5HFfa9EHmyn9P48p
         Oetj277q7JizlSiYkm18u8AOWxSVzgZuzcQs5l7fdjCsQHJI2zChiirayJibbAq/Ze8j
         mSjSSEyMzBL6SiQqq7udVaCtnmNGEUMsM2fVKfgQWjFE+GTTTUPfCadyXluWOkleygUi
         zzLMpuPvGayBopjHc2JZmzc8m4cFPAcAxn7hVJZwGn0uWjAdYwGAmcKxocsMFkPrrOkY
         00Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=jpkiYNoU4Rt1WYtil9Ur4r8Q6chgaPPrn/vLi4efF9g=;
        b=kHqbyNyLhwLb1He9vg2VIU+kU6emyxg0bza4emZcwe7aE3EAemFxD8IKzuQkep7qxf
         fgok/4qpsgNUOdWNoU7yZv27KfqD1IwOWi5/DRfhYTTmYxT58wdff+7n3fNH8WvoEyef
         OHZ9UqTI8AvjG9Shm2s+jGHfWQ/YZ1HO5NbRwGVx9t+PK3HZ0gELSpV20zTYqi7ZY1Px
         Ts0L/kCdHFdYEXCoqg2XnVpPemTdA6b6ER9ERPs+T1ffJ9IQ92ERNAt/kgX/CyBmEymZ
         GWd9RMTBzZGgqOMnKRcgqnixoRohD7nCrL4myEt8MVCPswhQnYxYJvN710OKAsxUJPln
         IZ8g==
X-Gm-Message-State: AOAM533p3iDGnnASJFFm593L+bF2QCEqXN71eVS6CYeSVMtDBnoWJ4bj
        lqL+tN6OVLLWS04CYCpcSITUTyM2hE0=
X-Google-Smtp-Source: ABdhPJwZ25jW1mkY2E0R+YK+GsMUlaZ25F/AsxUD+F2TD80hQCqhChldrGScMqD5/Wji08WV2ZH0mWcP0/4=
X-Received: from pgonda1.kir.corp.google.com ([2620:15c:29:204:9fb:192e:3671:218c])
 (user=pgonda job=sendgmr) by 2002:a17:90a:df01:: with SMTP id
 gp1mr416288pjb.28.1636998067453; Mon, 15 Nov 2021 09:41:07 -0800 (PST)
Date:   Mon, 15 Nov 2021 09:40:58 -0800
In-Reply-To: <20211115174102.2211126-1-pgonda@google.com>
Message-Id: <20211115174102.2211126-2-pgonda@google.com>
Mime-Version: 1.0
References: <20211115174102.2211126-1-pgonda@google.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
Subject: [PATCH V4 1/5] crypto: ccp - Add SEV_INIT rc error logging on init
From:   Peter Gonda <pgonda@google.com>
To:     thomas.lendacky@amd.com
Cc:     Peter Gonda <pgonda@google.com>, Marc Orr <marcorr@google.com>,
        David Rientjes <rientjes@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Joerg Roedel <jroedel@suse.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        John Allen <john.allen@amd.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Currently only the firmware error code is printed. This is incomplete
and also incorrect as error cases exists where the firmware is never
called and therefore does not set an error code.

Signed-off-by: Peter Gonda <pgonda@google.com>
Reviewed-by: Marc Orr <marcorr@google.com>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Brijesh Singh <brijesh.singh@amd.com>
Cc: Marc Orr <marcorr@google.com>
Cc: Joerg Roedel <jroedel@suse.de>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: David Rientjes <rientjes@google.com>
Cc: John Allen <john.allen@amd.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/crypto/ccp/sev-dev.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 2ecb0e1f65d8..62031e861e69 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1104,7 +1104,8 @@ void sev_pci_init(void)
 	}
 
 	if (rc) {
-		dev_err(sev->dev, "SEV: failed to INIT error %#x\n", error);
+		dev_err(sev->dev, "SEV: failed to INIT error %#x, rc %d\n",
+			error, rc);
 		return;
 	}
 
-- 
2.34.0.rc1.387.gb447b232ab-goog

