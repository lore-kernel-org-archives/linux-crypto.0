Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC5D3C77B61
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Apr 2023 19:08:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244232AbjD0TIK (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Apr 2023 15:08:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244537AbjD0TIJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Apr 2023 15:08:09 -0400
Received: from viti.kaiser.cx (viti.kaiser.cx [IPv6:2a01:238:43fe:e600:cd0c:bd4a:7a3:8e9f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 566A4170C;
        Thu, 27 Apr 2023 12:07:52 -0700 (PDT)
Received: from ipservice-092-217-081-249.092.217.pools.vodafone-ip.de ([92.217.81.249] helo=martin-debian-2.paytec.ch)
        by viti.kaiser.cx with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <martin@kaiser.cx>)
        id 1ps6l3-0003RX-86; Thu, 27 Apr 2023 20:54:21 +0200
From:   Martin Kaiser <martin@kaiser.cx>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Martin Kaiser <martin@kaiser.cx>
Subject: [PATCH 0/3] hwrng: imx-rngc - simplify register definitions
Date:   Thu, 27 Apr 2023 20:53:54 +0200
Message-Id: <20230427185357.923412-1-martin@kaiser.cx>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This series simplifies some definitions for register bits and fields. We can
then use the FIELD_GET macro to read register fields instead of masking and
shifting manually.

Tested on an imx258 board (rngb).

Martin Kaiser (3):
  hwrng: imx-rngc - use bitfield macros to read fifo level
  hwrng: imx-rngc - use bitfield macros to read rng type
  hwrng: imx-rngc - use BIT(x) for register bit defines

 drivers/char/hw_random/imx-rngc.c | 32 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 17 deletions(-)

-- 
2.30.2

