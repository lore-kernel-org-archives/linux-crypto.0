Return-Path: <SRS0=MR99=BD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 027F6C433E0
	for <linux-crypto@archiver.kernel.org>; Fri, 24 Jul 2020 10:10:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC6FC20768
	for <linux-crypto@archiver.kernel.org>; Fri, 24 Jul 2020 10:10:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726754AbgGXKKF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 24 Jul 2020 06:10:05 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59383 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726114AbgGXKKF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 Jul 2020 06:10:05 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1jyueP-0003Jc-Pd; Fri, 24 Jul 2020 10:10:01 +0000
From:   Colin King <colin.king@canonical.com>
To:     Matt Mackall <mpm@selenic.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] hwrng: core: remove redundant initialization of variable ret
Date:   Fri, 24 Jul 2020 11:10:01 +0100
Message-Id: <20200724101001.12505-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The variable ret is being initialized with a value that is never read
and it is being updated later with a new value.  The initialization is
redundant and can be removed.

Addresses-Coverity: ("Unused value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/char/hw_random/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index d2d7a42d7e0d..8c1c47dd9f46 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -611,7 +611,7 @@ EXPORT_SYMBOL_GPL(devm_hwrng_unregister);
 
 static int __init hwrng_modinit(void)
 {
-	int ret = -ENOMEM;
+	int ret;
 
 	/* kmalloc makes this safe for virt_to_page() in virtio_rng.c */
 	rng_buffer = kmalloc(rng_buffer_size(), GFP_KERNEL);
-- 
2.27.0

