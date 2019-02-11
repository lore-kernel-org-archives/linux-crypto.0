Return-Path: <SRS0=2CiZ=QS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D0DEC169C4
	for <linux-crypto@archiver.kernel.org>; Mon, 11 Feb 2019 11:46:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 27B1D2070B
	for <linux-crypto@archiver.kernel.org>; Mon, 11 Feb 2019 11:46:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726977AbfBKLqb (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 11 Feb 2019 06:46:31 -0500
Received: from inva020.nxp.com ([92.121.34.13]:46426 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726041AbfBKLqb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 11 Feb 2019 06:46:31 -0500
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id DFC691A01D9;
        Mon, 11 Feb 2019 12:46:29 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id D3A0B1A01B7;
        Mon, 11 Feb 2019 12:46:29 +0100 (CET)
Received: from enigma.ea.freescale.net (enigma.ea.freescale.net [10.171.81.110])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 7828E205FA;
        Mon, 11 Feb 2019 12:46:29 +0100 (CET)
From:   =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        linux-crypto@vger.kernel.org, Leo Li <leoyang.li@nxp.com>,
        Roy Pledge <roy.pledge@nxp.com>,
        Vakul Garg <vakul.garg@nxp.com>
Subject: [PATCH 0/3] crypto: caam/qi2 - performance-related updates
Date:   Mon, 11 Feb 2019 13:46:11 +0200
Message-Id: <20190211114614.24748-1-horia.geanta@nxp.com>
X-Mailer: git-send-email 2.16.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The main update in this patch set is taking advantage of current DPIO
(SW portal) implementation, making sure a CPU-affine portal is used.

There is a dependency on Freescale SoC drivers tree:
https://git.kernel.org/pub/scm/linux/kernel/git/leo/linux.git/log/?h=next

Patches that need to be integrated start from (excluding) commit:
bfeffd155283 ("Linux 5.0-rc1")
up to (including) commit:
afb77422819f ("bus: fsl-mc: automatically add a device_link on fsl_mc_[portal,object]_allocate")

Thanks,
Horia

Horia Geantă (3):
  crypto: caam/qi2 - use affine DPIOs
  crypto: caam/qi2 - rate-limit enqueue failure prints
  crypto: caam/qi2 - relax busy polling while enqueuing FDs

 drivers/crypto/caam/caamalg_qi2.c | 56 ++++++++++++++++++++++-----------------
 drivers/crypto/caam/caamalg_qi2.h |  2 ++
 2 files changed, 34 insertions(+), 24 deletions(-)

-- 
2.16.2

