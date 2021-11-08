Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10C2CC433F5
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Nov 2021 10:13:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE3AF61207
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Nov 2021 10:13:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235202AbhKHKPt (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 8 Nov 2021 05:15:49 -0500
Received: from mail.skyhub.de ([5.9.137.197]:38552 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237912AbhKHKPY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 8 Nov 2021 05:15:24 -0500
Received: from zn.tnic (p200300ec2f33110088892b77bd117736.dip0.t-ipconnect.de [IPv6:2003:ec:2f33:1100:8889:2b77:bd11:7736])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 464D71EC052C;
        Mon,  8 Nov 2021 11:12:39 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1636366359;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=p0GXWGKIciLQRqkr0wIaBSSGQPCdQZ52kaQiTCJltwQ=;
        b=gIj84H0LtVTP7E5lbAU4mgjFb/CNbjoI+sNG+VbPzdEOttquNDSaWjuysIX1sOMHyHFLhi
        q3a5uD+i+HYksdTlr95F1tqQiQXwT4LIQyBbaj5PhATKAGNTb+SWaSurAFfOvt7Hllh07q
        BTsgf72FXFUwSvR9VigijonCN8dFtxE=
From:   Borislav Petkov <bp@alien8.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     linux-crypto@vger.kernel.org
Subject: [PATCH v0 39/42] crypto: ccree - check notifier registration return value
Date:   Mon,  8 Nov 2021 11:11:54 +0100
Message-Id: <20211108101157.15189-40-bp@alien8.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20211108101157.15189-1-bp@alien8.de>
References: <20211108101157.15189-1-bp@alien8.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

Avoid homegrown notifier registration checks.

No functional changes.

Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: linux-crypto@vger.kernel.org
---
 drivers/crypto/ccree/cc_fips.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/ccree/cc_fips.c b/drivers/crypto/ccree/cc_fips.c
index 702aefc21447..de842da7d51c 100644
--- a/drivers/crypto/ccree/cc_fips.c
+++ b/drivers/crypto/ccree/cc_fips.c
@@ -146,7 +146,9 @@ int cc_fips_init(struct cc_drvdata *p_drvdata)
 	tasklet_init(&fips_h->tasklet, fips_dsr, (unsigned long)p_drvdata);
 	fips_h->drvdata = p_drvdata;
 	fips_h->nb.notifier_call = cc_ree_fips_failure;
-	atomic_notifier_chain_register(&fips_fail_notif_chain, &fips_h->nb);
+
+	if (atomic_notifier_chain_register(&fips_fail_notif_chain, &fips_h->nb))
+		pr_warn("Failure notifier already registered\n");
 
 	cc_tee_handle_fips_error(p_drvdata);
 
-- 
2.29.2

