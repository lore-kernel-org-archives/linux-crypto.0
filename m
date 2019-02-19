Return-Path: <SRS0=4Nwj=Q2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4D06C43381
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Feb 2019 14:57:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7B66720665
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Feb 2019 14:57:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726352AbfBSO5K (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 19 Feb 2019 09:57:10 -0500
Received: from inva020.nxp.com ([92.121.34.13]:40454 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725808AbfBSO5J (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 19 Feb 2019 09:57:09 -0500
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 176251A011B;
        Tue, 19 Feb 2019 15:57:08 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 0919F1A00BB;
        Tue, 19 Feb 2019 15:57:08 +0100 (CET)
Received: from enigma.ea.freescale.net (enigma.ea.freescale.net [10.171.81.110])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 9FBBE2061F;
        Tue, 19 Feb 2019 15:57:07 +0100 (CET)
From:   =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        linux-crypto@vger.kernel.org, linux-imx <linux-imx@nxp.com>
Subject: [PATCH 0/3] crypto: caam/jr - DMA API fixes
Date:   Tue, 19 Feb 2019 16:56:54 +0200
Message-Id: <20190219145657.2267-1-horia.geanta@nxp.com>
X-Mailer: git-send-email 2.16.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch set fixes issues uncovered when testing the Job Ring interface
with CONFIG_DMA_API_DEBUG=y.

First patch ("crypto: caam - fix hash context DMA unmap size") has to be
sent to -stable, according to "Fixes" tag.

Franck LENORMAND (1):
  crypto: caam - fix hash context DMA unmap size

Horia Geantă (2):
  crypto: caam - fix DMA mapping xcbc key twice
  crypto: caam - generate hash keys in-place

 drivers/crypto/caam/caamhash.c | 51 ++++++++++++++++--------------------------
 drivers/crypto/caam/key_gen.c  | 30 +++++++++----------------
 2 files changed, 29 insertions(+), 52 deletions(-)

-- 
2.16.2

