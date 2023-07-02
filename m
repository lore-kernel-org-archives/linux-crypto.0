Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27BEFEB64DA
	for <linux-crypto@archiver.kernel.org>; Sun,  2 Jul 2023 17:37:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbjGBRhB (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 2 Jul 2023 13:37:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229584AbjGBRhA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 2 Jul 2023 13:37:00 -0400
Received: from viti.kaiser.cx (viti.kaiser.cx [IPv6:2a01:238:43fe:e600:cd0c:bd4a:7a3:8e9f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 312E1183;
        Sun,  2 Jul 2023 10:36:58 -0700 (PDT)
Received: from dslb-188-097-041-125.188.097.pools.vodafone-ip.de ([188.97.41.125] helo=martin-debian-2.paytec.ch)
        by viti.kaiser.cx with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <martin@kaiser.cx>)
        id 1qG10J-0007s9-RR; Sun, 02 Jul 2023 19:36:55 +0200
From:   Martin Kaiser <martin@kaiser.cx>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Martin Kaiser <martin@kaiser.cx>
Subject: [PATCH 0/2] hwrng: nomadik - two simple cleanups
Date:   Sun,  2 Jul 2023 19:35:01 +0200
Message-Id: <20230702173503.163152-1-martin@kaiser.cx>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Use devm_clk_get_enabled to fix a (theoretical) race condition during removal.
Call dev_error_probe to print an error message and exit.

Both changes were compile-tested only, I don't have this hardware.

Martin Kaiser (2):
  hwrng: nomadik - keep clock enabled while hwrng is registered
  hwrng: nomadik - use dev_err_probe

 drivers/char/hw_random/nomadik-rng.c | 19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

-- 
2.30.2

