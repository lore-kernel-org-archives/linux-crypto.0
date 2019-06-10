Return-Path: <SRS0=e/ms=UJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 580EAC28CC7
	for <linux-crypto@archiver.kernel.org>; Mon, 10 Jun 2019 13:31:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 34DAB207E0
	for <linux-crypto@archiver.kernel.org>; Mon, 10 Jun 2019 13:31:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390361AbfFJNbL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 10 Jun 2019 09:31:11 -0400
Received: from inva020.nxp.com ([92.121.34.13]:41898 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388833AbfFJNbK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 Jun 2019 09:31:10 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 1DF611A083B;
        Mon, 10 Jun 2019 15:31:09 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 1150B1A02A5;
        Mon, 10 Jun 2019 15:31:09 +0200 (CEST)
Received: from fsr-ub1864-014.ea.freescale.net (fsr-ub1864-014.ea.freescale.net [10.171.95.219])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id B2373205E4;
        Mon, 10 Jun 2019 15:31:08 +0200 (CEST)
From:   =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        NXP Linux Team <linux-imx@nxp.com>
Subject: [PATCH 0/2] crypto: caam - update IV using HW support
Date:   Mon, 10 Jun 2019 16:30:57 +0300
Message-Id: <20190610133059.1059-1-horia.geanta@nxp.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch set updates the drivers to rely on HW for providing
the output IV in case of skcipher algorithms.

It's both an improvement, as previously mentioned here:
https://lore.kernel.org/linux-crypto/VI1PR0401MB2591C51C446CFA129B50022298D20@VI1PR0401MB2591.eurprd04.prod.outlook.com
and a fix for the currently broken ctr(aes) IV update.

Horia Geantă (2):
  crypto: caam - use len instead of nents for bulding HW S/G table
  crypto: caam - update IV using HW support

 drivers/crypto/caam/caamalg.c      | 119 ++++++++++++----------
 drivers/crypto/caam/caamalg_desc.c |  31 ++++--
 drivers/crypto/caam/caamalg_desc.h |   4 +-
 drivers/crypto/caam/caamalg_qi.c   | 122 ++++++++++-------------
 drivers/crypto/caam/caamalg_qi2.c  | 152 ++++++++++++++---------------
 drivers/crypto/caam/caamhash.c     |  15 ++-
 drivers/crypto/caam/caampkc.c      |   4 +-
 drivers/crypto/caam/sg_sw_qm.h     |  18 ++--
 drivers/crypto/caam/sg_sw_qm2.h    |  18 ++--
 drivers/crypto/caam/sg_sw_sec4.h   |  18 ++--
 10 files changed, 262 insertions(+), 239 deletions(-)

-- 
2.17.1

