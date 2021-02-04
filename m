Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27D61C433E0
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Feb 2021 15:44:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E18F064F64
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Feb 2021 15:44:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237469AbhBDPny (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 4 Feb 2021 10:43:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:33162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237168AbhBDPnQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 4 Feb 2021 10:43:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 671D664F4D;
        Thu,  4 Feb 2021 15:42:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612453355;
        bh=EU2GB+SDJu3n1HEJNYfa0RUxpSUsohAvo/RCzjgzAGE=;
        h=From:To:Cc:Subject:Date:From;
        b=VASP5nnEDUJGGbJFGfnAdjemfxE7GLDMZ0oUaAd4SL5n+OlyfnEjEk+wg80IOADgo
         LjKRvbMkxjCMH74dmBs3UPnAxA0D7FxqMt11fjv9eX6R4/038/Hs+vdHG6dBMnYqwj
         ysxqB+JuqQl+4gUmtlIqlVHlljz9f5N3F9ZC+wUl08czrwOyNgh6ihEoTGCWKwzzo0
         RXtiDP6N8qQxuZUxGGMN1yTBTmwSH6gyRORRSkMVeVLkehsde33zmeGdE4PgTMWhgU
         0wa/A5D4GQIOGZtLpHYUNOlJFEw/MyhBiz+oUxBx94paBcVdjBo/sueH8i9Mg3rSwZ
         6IwZ3uQ1a8gIw==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Boris Brezillon <bbrezillon@kernel.org>,
        Arnaud Ebalard <arno@natisbad.org>,
        Srujana Challa <schalla@marvell.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Suheil Chandran <schandran@marvell.com>,
        Lukasz Bartosik <lbartosik@marvell.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: [PATCH 1/2] crypto: octeontx2 - fix -Wpointer-bool-conversion warning
Date:   Thu,  4 Feb 2021 16:42:15 +0100
Message-Id: <20210204154230.1702563-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

When CONFIG_CPUMASK_OFFSTACK is disabled, clang reports a warning
about a bogus condition:

drivers/crypto/marvell/octeontx2/otx2_cptlf.c:334:21: error: address of array 'lfs->lf[slot].affinity_mask' will always evaluate to 'true' [-Werror,-Wpointer-bool-conversion]
                if (lfs->lf[slot].affinity_mask)
                ~~  ~~~~~~~~~~~~~~^~~~~~~~~~~~~

In this configuration, the free_cpumask_var() function does nothing,
so the condition could be skipped.

When the option is enabled, there is no warning, but the check
is also redundant because free_cpumask_var() falls back to kfree(),
which is documented as ignoring NULL pointers.

Remove the check to avoid the warning.

Fixes: 64506017030d ("crypto: octeontx2 - add LF framework")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/crypto/marvell/octeontx2/otx2_cptlf.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptlf.c b/drivers/crypto/marvell/octeontx2/otx2_cptlf.c
index e27ea8909368..823a4571fd67 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptlf.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptlf.c
@@ -331,8 +331,7 @@ void otx2_cptlf_free_irqs_affinity(struct otx2_cptlfs_info *lfs)
 			irq_set_affinity_hint(pci_irq_vector(lfs->pdev,
 					      lfs->lf[slot].msix_offset +
 					      offs), NULL);
-		if (lfs->lf[slot].affinity_mask)
-			free_cpumask_var(lfs->lf[slot].affinity_mask);
+		free_cpumask_var(lfs->lf[slot].affinity_mask);
 	}
 }
 
-- 
2.29.2

