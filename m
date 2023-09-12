Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD8A4CA0EEB
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Sep 2023 14:34:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236030AbjILOer (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 12 Sep 2023 10:34:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236034AbjILOeq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 12 Sep 2023 10:34:46 -0400
Received: from viti.kaiser.cx (viti.kaiser.cx [IPv6:2a01:238:43fe:e600:cd0c:bd4a:7a3:8e9f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7600CC7;
        Tue, 12 Sep 2023 07:34:42 -0700 (PDT)
Received: from dslb-178-004-201-190.178.004.pools.vodafone-ip.de ([178.4.201.190] helo=martin-debian-2.paytec.ch)
        by viti.kaiser.cx with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <martin@kaiser.cx>)
        id 1qg4TO-0005wr-RF; Tue, 12 Sep 2023 16:34:38 +0200
From:   Martin Kaiser <martin@kaiser.cx>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Martin Kaiser <martin@kaiser.cx>
Subject: [PATCH 0/2] hwrng: imx-rngc - adjust the timeouts
Date:   Tue, 12 Sep 2023 16:31:16 +0200
Message-Id: <20230912143117.55965-1-martin@kaiser.cx>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Set the timeouts for selftest and initial seed to approx. three times the
maximum possible duration.

This replaces the series "hwrng: imx-rngc - use polling instead of interrupt".

Martin Kaiser (2):
  hwrng: imx-rngc - reasonable timeout for selftest
  hwrng: imx-rngc - reasonable timeout for initial seed

 drivers/char/hw_random/imx-rngc.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

-- 
2.39.2

