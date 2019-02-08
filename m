Return-Path: <SRS0=4jM/=QP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AAC4C169C4
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Feb 2019 13:51:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 72A4520869
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Feb 2019 13:51:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727602AbfBHNvR (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 Feb 2019 08:51:17 -0500
Received: from inva021.nxp.com ([92.121.34.21]:37706 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727398AbfBHNvR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 Feb 2019 08:51:17 -0500
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 9B30E2002A3;
        Fri,  8 Feb 2019 14:51:15 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 98BC220008E;
        Fri,  8 Feb 2019 14:51:15 +0100 (CET)
Received: from lorenz.ea.freescale.net (lorenz.ea.freescale.net [10.171.71.5])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 3D08420138;
        Fri,  8 Feb 2019 14:51:15 +0100 (CET)
From:   Iuliana Prodan <iuliana.prodan@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-imx <linux-imx@nxp.com>
Subject: [PATCH 0/4] crypto: caam - add ecb mode support
Date:   Fri,  8 Feb 2019 15:50:06 +0200
Message-Id: <1549633810-10380-1-git-send-email-iuliana.prodan@nxp.com>
X-Mailer: git-send-email 2.1.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch set adds ecb mode support for aes, des, 3des and arc4 ciphers.
skcipher implementation is reused, making sure to handle the no IV case.

While here:
-fix a DMA API issue where initial src/dst_nents are used instead of nents
returned by dma_map_sg()
-export arc4 defines in a common header
-update cbc des and 3des to check for weak keys 

Iuliana Prodan (4):
  crypto: caam - use mapped_{src,dst}_nents for job descriptor
  crypto: export arc4 defines
  crypto: caam - add ecb(*) support
  crypto: caam - weak key checking for cbc des, 3des

 crypto/arc4.c                      |   5 +-
 drivers/crypto/bcm/cipher.h        |   4 +-
 drivers/crypto/caam/Kconfig        |   1 +
 drivers/crypto/caam/caamalg.c      | 215 ++++++++++++++++++++++++++++---------
 drivers/crypto/caam/caamalg_desc.c |  18 ++--
 drivers/crypto/caam/compat.h       |   1 +
 include/crypto/arc4.h              |  13 +++
 7 files changed, 195 insertions(+), 62 deletions(-)
 create mode 100644 include/crypto/arc4.h

-- 
2.1.0

