Return-Path: <SRS0=5M5o=S3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 002E9C43219
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Apr 2019 14:52:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1D72C2067C
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Apr 2019 14:52:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727416AbfDYOwh (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 25 Apr 2019 10:52:37 -0400
Received: from inva021.nxp.com ([92.121.34.21]:48694 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726490AbfDYOwh (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 25 Apr 2019 10:52:37 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id E69262001E0;
        Thu, 25 Apr 2019 16:52:35 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id D8A6020000F;
        Thu, 25 Apr 2019 16:52:35 +0200 (CEST)
Received: from fsr-ub1864-014.ea.freescale.net (fsr-ub1864-014.ea.freescale.net [10.171.95.219])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 970EA2061F;
        Thu, 25 Apr 2019 16:52:35 +0200 (CEST)
From:   =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        linux-crypto@vger.kernel.org
Subject: [PATCH 0/3] crypto: caam/qi2 - ahash fixes for 5.2
Date:   Thu, 25 Apr 2019 17:52:20 +0300
Message-Id: <20190425145223.28603-1-horia.geanta@nxp.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

ahash implementation in caam/jr driver has undergone a few
DMA API related fixes.

This patch set contains similar fixes for ahash implementation
in caam/qi2 driver.

Horia Geantă (3):
  crypto: caam/qi2 - fix zero-length buffer DMA mapping
  crypto: caam/qi2 - fix DMA mapping of stack memory
  crypto: caam/qi2 - generate hash keys in-place

 drivers/crypto/caam/caamalg_qi2.c | 177 +++++++++++++-----------------
 drivers/crypto/caam/caamalg_qi2.h |   2 -
 2 files changed, 78 insertions(+), 101 deletions(-)

-- 
2.17.1

