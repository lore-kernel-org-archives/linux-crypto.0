Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CCC7C4332F
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Nov 2021 17:21:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 74CEF60232
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Nov 2021 17:21:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbhKARYJ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 1 Nov 2021 13:24:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231303AbhKARYI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 1 Nov 2021 13:24:08 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4B50C0613B9
        for <linux-crypto@vger.kernel.org>; Mon,  1 Nov 2021 10:21:34 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id z187-20020a6233c4000000b0047c2090f1abso9656104pfz.23
        for <linux-crypto@vger.kernel.org>; Mon, 01 Nov 2021 10:21:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=qXnwABhA26FtcwRiOkwwItakkHsn0lTvM03+FEbDB6Y=;
        b=cNhKVmN7f088Pu5/9PtjPrttKwVpX3sYKA3eaSdHWr0g6Sk7xmlmyvAD0CQy7Bl1hp
         FrfufZcZMY8vSmeCHx/y67KRcgj8R+WCNWKpDE8ZcbOzRsLXZqPqg+I26Mv20RmM+f27
         3IugQqPP560OAxsV1HfKIulYRTcRZCWgdcs/GpX6H3lvO94MayP1zzzGRLv3Cj/kiM9e
         +phgfDQ+Up0A0ezw9qchJDS60DpudrPSN997Va6tb2h12NHECPDH+2lzduoepwusD02u
         6mMQuGgJaVxP9rssRmb101hzjdJcVs3FCKrx/8bVGTz1+60ZhrWXt9d9EJRpdZXEVnx4
         XUoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=qXnwABhA26FtcwRiOkwwItakkHsn0lTvM03+FEbDB6Y=;
        b=xOEp75Am9RGaaA/4k4xn/OZJNpoxeJ7O+4pZmQ6JrQm9KIz7v1yOW9TTR44S/gm2x0
         a1TuBJZjcvpUrZPVFfX6i99youcibToO5kri8EKybjQqLegxiwXqrR8VQMtBUDaklu2I
         LQW+nwHvJWvxCgUq9l7MHfX31DiArzu7U7RCOd9rk5kssJXZ1QlqOStxe7jnG9vfPLjo
         hW/3sWI2xNDvQwdAN7L/P4pQv9lN+hxM0L4rN952BLDvQZvzvHN3/aouOCstkF4+Rj+l
         9DziZeG0F52p88wbQ1sdLRJzoP0PneOJIJX9Fy1c5PT55D1fWRqsLGokQibmtkLeHNhs
         jvOg==
X-Gm-Message-State: AOAM530qSZOeLzAnd0JWApU3j/AZs42q9EyViN/WfaiCLrV0Ni0/+uF4
        TV2DyXBapAf5fJWxY1l+hY2tZrzN//k=
X-Google-Smtp-Source: ABdhPJxyqE49wKGj9/2dferzDZJUmxtvqtCDkNm6J1WmIaOTE7WyXbZfmPBVWXsaDjMxR/cjYQVF1SH4DA8=
X-Received: from pgonda1.kir.corp.google.com ([2620:15c:29:204:98c4:afe5:ed9f:d0db])
 (user=pgonda job=sendgmr) by 2002:a17:90a:974a:: with SMTP id
 i10mr250581pjw.117.1635787294348; Mon, 01 Nov 2021 10:21:34 -0700 (PDT)
Date:   Mon,  1 Nov 2021 10:21:25 -0700
In-Reply-To: <20211101172127.3060453-1-pgonda@google.com>
Message-Id: <20211101172127.3060453-3-pgonda@google.com>
Mime-Version: 1.0
References: <20211101172127.3060453-1-pgonda@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [PATCH V2 2/4] crypto: ccp - Move SEV_INIT retry for corrupted data
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

This change moves the data corrupted retry of SEV_INIT into the
__sev_platform_init_locked() function. This is for upcoming INIT_EX
support as well as helping direct callers of
__sev_platform_init_locked() which currently do not support the
retry.

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
 drivers/crypto/ccp/sev-dev.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index ec89a82ba267..e4bc833949a0 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -267,6 +267,18 @@ static int __sev_platform_init_locked(int *error)
 	}
 
 	rc = __sev_do_cmd_locked(SEV_CMD_INIT, &data, error);
+	if (rc && *error == SEV_RET_SECURE_DATA_INVALID) {
+		/*
+		 * INIT command returned an integrity check failure
+		 * status code, meaning that firmware load and
+		 * validation of SEV related persistent data has
+		 * failed and persistent state has been erased.
+		 * Retrying INIT command here should succeed.
+		 */
+		dev_dbg(sev->dev, "SEV: retrying INIT command");
+		rc = __sev_do_cmd_locked(SEV_CMD_INIT, &data, error);
+	}
+
 	if (rc)
 		return rc;
 
@@ -1091,18 +1103,6 @@ void sev_pci_init(void)
 
 	/* Initialize the platform */
 	rc = sev_platform_init(&error);
-	if (rc && (error == SEV_RET_SECURE_DATA_INVALID)) {
-		/*
-		 * INIT command returned an integrity check failure
-		 * status code, meaning that firmware load and
-		 * validation of SEV related persistent data has
-		 * failed and persistent state has been erased.
-		 * Retrying INIT command here should succeed.
-		 */
-		dev_dbg(sev->dev, "SEV: retrying INIT command");
-		rc = sev_platform_init(&error);
-	}
-
 	if (rc) {
 		dev_err(sev->dev, "SEV: failed to INIT error %#x, rc %d\n",
 			error, rc);
-- 
2.33.1.1089.g2158813163f-goog

