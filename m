Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 698A1EB64DA
	for <linux-crypto@archiver.kernel.org>; Wed, 19 Jul 2023 07:20:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229730AbjGSHUL (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 19 Jul 2023 03:20:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbjGSHUK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 19 Jul 2023 03:20:10 -0400
Received: from viti.kaiser.cx (viti.kaiser.cx [IPv6:2a01:238:43fe:e600:cd0c:bd4a:7a3:8e9f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E686A4;
        Wed, 19 Jul 2023 00:20:09 -0700 (PDT)
Received: from ipservice-092-217-093-053.092.217.pools.vodafone-ip.de ([92.217.93.53] helo=martin-debian-2.paytec.ch)
        by viti.kaiser.cx with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <martin@kaiser.cx>)
        id 1qM1Th-0008I7-FB; Wed, 19 Jul 2023 09:20:05 +0200
From:   Martin Kaiser <martin@kaiser.cx>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Martin Kaiser <martin@kaiser.cx>
Subject: [PATCH 0/4] hwrng: cctrng - simplify the code a bit
Date:   Wed, 19 Jul 2023 09:18:02 +0200
Message-Id: <20230719071806.335718-1-martin@kaiser.cx>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

We can use module_platform_driver and devm_clk_get_optional_enabled in the
cctrng driver to make its code simpler.

The patches were compile tested only.

Martin Kaiser (4):
  hwrng: cctrng - don't open code init and exit functions
  hwrng: cctrng - let devres enable the clock
  hwrng: cctrng - merge cc_trng_clk_init into its only caller
  hwrng: cctrng - use dev_err_probe in error paths

 drivers/char/hw_random/cctrng.c | 93 +++++++--------------------------
 1 file changed, 19 insertions(+), 74 deletions(-)

-- 
2.30.2

