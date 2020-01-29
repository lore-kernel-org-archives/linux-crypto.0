Return-Path: <SRS0=eQ+U=3S=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30F57C3F68F
	for <linux-crypto@archiver.kernel.org>; Wed, 29 Jan 2020 14:38:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 03EAA206F0
	for <linux-crypto@archiver.kernel.org>; Wed, 29 Jan 2020 14:38:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726756AbgA2OiP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 29 Jan 2020 09:38:15 -0500
Received: from foss.arm.com ([217.140.110.172]:41988 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726773AbgA2OiP (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 29 Jan 2020 09:38:15 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0269A31B;
        Wed, 29 Jan 2020 06:38:15 -0800 (PST)
Received: from e110176-lin.kfn.arm.com (unknown [10.50.4.146])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B52D73F52E;
        Wed, 29 Jan 2020 06:38:13 -0800 (PST)
From:   Gilad Ben-Yossef <gilad@benyossef.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Ofir Drang <ofir.drang@arm.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] crypto: ccree - fix AEAD blocksize registration
Date:   Wed, 29 Jan 2020 16:37:57 +0200
Message-Id: <20200129143757.680-5-gilad@benyossef.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200129143757.680-1-gilad@benyossef.com>
References: <20200129143757.680-1-gilad@benyossef.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Fix an error causing no block sizes to be reported during
all AEAD registrations.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/crypto/ccree/cc_aead.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/ccree/cc_aead.c b/drivers/crypto/ccree/cc_aead.c
index edab44cbd353..b69cfbebc59a 100644
--- a/drivers/crypto/ccree/cc_aead.c
+++ b/drivers/crypto/ccree/cc_aead.c
@@ -2642,6 +2642,7 @@ static struct cc_crypto_alg *cc_create_aead_alg(struct cc_alg_template *tmpl,
 
 	alg->base.cra_ctxsize = sizeof(struct cc_aead_ctx);
 	alg->base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_KERN_DRIVER_ONLY;
+	alg->base.cra_blocksize = tmpl->blocksize;
 	alg->init = cc_aead_init;
 	alg->exit = cc_aead_exit;
 
-- 
2.25.0

