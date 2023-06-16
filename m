Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACE27EB64DA
	for <linux-crypto@archiver.kernel.org>; Fri, 16 Jun 2023 09:01:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233557AbjFPJAi (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 16 Jun 2023 05:00:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343643AbjFPI7i (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 16 Jun 2023 04:59:38 -0400
Received: from viti.kaiser.cx (viti.kaiser.cx [IPv6:2a01:238:43fe:e600:cd0c:bd4a:7a3:8e9f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 465D626A2;
        Fri, 16 Jun 2023 01:59:37 -0700 (PDT)
Received: from [167.98.155.120] (helo=martin-debian-2.paytec.ch)
        by viti.kaiser.cx with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <martin@kaiser.cx>)
        id 1qA5It-0000d1-NO; Fri, 16 Jun 2023 10:59:35 +0200
From:   Martin Kaiser <martin@kaiser.cx>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Martin Kaiser <martin@kaiser.cx>
Subject: [PATCH v2 0/2] hwrng: st - fix potential race condition
Date:   Fri, 16 Jun 2023 09:58:11 +0100
Message-Id: <20230616085813.1323082-1-martin@kaiser.cx>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230616083618.1320824-1-martin@kaiser.cx>
References: <20230616083618.1320824-1-martin@kaiser.cx>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Fix a potential race condition in the st-rng driver. There's a short timeframe
where the driver is still registered but its peripheral clock is disabled.

Add support for compile-testing the driver. I do not have any hardware that
supports st-rng.

v2: Remove some more obsolete code and rephrase the explanation. The point is
    that devres does now disable the clock.

Martin Kaiser (2):
  hwrng: st - support compile-testing
  hwrng: st - keep clock enabled while hwrng is registered

 drivers/char/hw_random/Kconfig  |  2 +-
 drivers/char/hw_random/st-rng.c | 21 +--------------------
 2 files changed, 2 insertions(+), 21 deletions(-)

-- 
2.30.2

