Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9869C433B4
	for <linux-crypto@archiver.kernel.org>; Tue,  6 Apr 2021 22:50:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6764E613D3
	for <linux-crypto@archiver.kernel.org>; Tue,  6 Apr 2021 22:50:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344204AbhDFWuS (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 6 Apr 2021 18:50:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344191AbhDFWuQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 6 Apr 2021 18:50:16 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D41CC06174A
        for <linux-crypto@vger.kernel.org>; Tue,  6 Apr 2021 15:50:08 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id q14so6671868ybk.22
        for <linux-crypto@vger.kernel.org>; Tue, 06 Apr 2021 15:50:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=9unnZdwnJBhmIr85WtW6opdl6PIonHCZIupIJTvjWiM=;
        b=TkbGpsapVhMM/9vNTvKB2L0fGV6FDhcQqCVGeETLXWxcwfezHG91/Q32wDXz4NNQzM
         nc0exNLd9sY6ryGmhhmyHB1RRJGT8Chj3tHZWlz8EP2ltZ2XznhwfwqVrVa8wOWGyxx7
         0q80IQ90Nro8z6l81DX7mZp32wgeHg/9fnbOVCWSN+TnbJo+T+psv21FIznZvp11IQSD
         7OO9fnXsMk0l7y7GljMe9yy4UhNrmsgXxl6Vnzk+LjeuD/C1qm4zOXUElsRpln+otQI5
         b1CaykelVe2JuM1a88H8nPQECvnwDlaUMgwiRCR90/JGzBaByfMcJAkkJv8tWLv1lKzC
         aw8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=9unnZdwnJBhmIr85WtW6opdl6PIonHCZIupIJTvjWiM=;
        b=ECZPQYFLzUbyOh5xtUU3VwhNd4bdmj5hUUbe4PtyT57I0qRtEKmWHZKCnrQyO0f39v
         uq8Cw3Gq8PjbubXifX63I43W9FA2bWXJPN4qDjicv0rVcyV5+v3dHfe7aC+7nn0IWqyY
         KpVX36hNJvAahvYHU9m8NzPDBzabklJ5tjdlOaW3iMXm8j+BWkkI91tgNeZh7F+6xuOf
         YfbO9E4v5lIHB63gT0dzAQPAsDDNBLUo95jyYe/77Zm3Q5kcLbZBzrxy0sofU8llf3eS
         RNq90QqXpP/xypA+Ws6o7zgTypMbUID+ChZhEAMmU6UmOx+ryY8vCA93AmMVU/ET57fs
         rVcw==
X-Gm-Message-State: AOAM531aK8i7rGWYOBzPj9J53etKSbKtnXWdTDKAW523qsh0FhViDFK4
        53/ZKQSnO0poubNfmS1uDPX4aq6acJU=
X-Google-Smtp-Source: ABdhPJzlb0ZbdnN3YVCAvkv4hLaHNRneUSdCrOk9RA1gK+d59njBjzucCXv09ROJce8rsyMB2b1YQgaYp58=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:24a1:90fb:182b:777c])
 (user=seanjc job=sendgmr) by 2002:a25:b3c1:: with SMTP id x1mr517791ybf.506.1617749407346;
 Tue, 06 Apr 2021 15:50:07 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  6 Apr 2021 15:49:45 -0700
In-Reply-To: <20210406224952.4177376-1-seanjc@google.com>
Message-Id: <20210406224952.4177376-2-seanjc@google.com>
Mime-Version: 1.0
References: <20210406224952.4177376-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.0.208.g409f899ff0-goog
Subject: [PATCH v2 1/8] crypto: ccp: Free SEV device if SEV init fails
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        John Allen <john.allen@amd.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Borislav Petkov <bp@suse.de>,
        Christophe Leroy <christophe.leroy@csgroup.eu>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Free the SEV device if later initialization fails.  The memory isn't
technically leaked as it's tracked in the top-level device's devres
list, but unless the top-level device is removed, the memory won't be
freed and is effectively leaked.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 drivers/crypto/ccp/sev-dev.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index cb9b4c4e371e..ba240d33d26e 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -987,7 +987,7 @@ int sev_dev_init(struct psp_device *psp)
 	if (!sev->vdata) {
 		ret = -ENODEV;
 		dev_err(dev, "sev: missing driver data\n");
-		goto e_err;
+		goto e_sev;
 	}
 
 	psp_set_sev_irq_handler(psp, sev_irq_handler, sev);
@@ -1002,6 +1002,8 @@ int sev_dev_init(struct psp_device *psp)
 
 e_irq:
 	psp_clear_sev_irq_handler(psp);
+e_sev:
+	devm_kfree(dev, sev);
 e_err:
 	psp->sev_data = NULL;
 
-- 
2.31.0.208.g409f899ff0-goog

