Return-Path: <SRS0=5M5o=S3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD252C43219
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Apr 2019 16:25:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 16DEB2077C
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Apr 2019 16:25:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729494AbfDYQZS (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 25 Apr 2019 12:25:18 -0400
Received: from inva021.nxp.com ([92.121.34.21]:35684 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726434AbfDYQZS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 25 Apr 2019 12:25:18 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id C4B16200204;
        Thu, 25 Apr 2019 18:25:15 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id AD120200080;
        Thu, 25 Apr 2019 18:25:15 +0200 (CEST)
Received: from fsr-ub1864-014.ea.freescale.net (fsr-ub1864-014.ea.freescale.net [10.171.95.219])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 3D1B22061F;
        Thu, 25 Apr 2019 18:25:15 +0200 (CEST)
From:   =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Vakul Garg <vakul.garg@nxp.com>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        Marcin Niestroj <m.niestroj@grinn-global.com>,
        linux-crypto@vger.kernel.org, NXP Linux Team <linux-imx@nxp.com>
Subject: [PATCH 0/7] crypto: caam - IOMMU support
Date:   Thu, 25 Apr 2019 19:24:54 +0300
Message-Id: <20190425162501.4565-1-horia.geanta@nxp.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch set adds support in caam drivers (caam/jr, caam/qi, caam/qi2)
for the crypto engine to work behind an IOMMU.

The changes consist in:

1. Deferred probing support
-caam/jr - top level drivers are converted to "libraries"; this also fixes
the issue reported previously by Marcin:
https://patchwork.kernel.org/cover/10558409/
-caam/qi - use the newly added QBMan functions (*) to decide whether to defer
caam controller probing or not

2. Fixing spurios memory accesses, that lead to IOMMU access faults
-crypto engine prefetches S/G table entries in chunks of 4 (64 bytes),
and driver has to make sure memory is allocated and mapped
-crypto engine tries to prefetch S/G table entries when input / output
is marked as scattered, even though length is zero

3. Getting rid of platform device created by caam/qi
There are inherent problems with platform device being created dynamically
(and not relying on the existence of a DT node).

4. Update phys -> virt address translation in case IOMMU is present
iova -> phys -> virt

5. Fix the device used for key buffers DMA mapping
Key buffers are incorrectly DMA mapped using a job ring device, since they
are accessed eventually by the QI - this creating an ICID / stream ID
mismatch at IOMMU level.

Tests were performed on:
-LS1046A - caam/jr and caam/qi - job ring and queue interface
-LS1088A - caam/jr and caam/qi2 - job ring and dpsec interface

There are some dependencies (see below).
While not everything is in place, I would like at least to patches 1-8/9
being reviewed & merged.

i. Patch 9/9 (crypto: caam - defer probing until QMan is available) should
NOT be merged, since there are compilation dependencies on the patch series:
(*) Prerequisites for NXP LS104xA SMMU enablement
https://patchwork.kernel.org/project/linux-arm-kernel/list/?series=98625

ii. U-boot updates for LS1088A (needed for caam/jr ICID programming)
[U-Boot,1/2] armv8: fsl-layerscape: add missing sec jr base address defines
https://patchwork.ozlabs.org/patch/1059256/
[U-Boot,2/2] armv8: ls1088a: add icid setup for platform devices
https://patchwork.ozlabs.org/patch/1059259/

Horia Geantă (7):
  crypto: caam - avoid S/G table fetching for AEAD zero-length output
  crypto: caam - fix S/G table passing page boundary
  crypto: caam - convert top level drivers to libraries
  crypto: caam/qi - don't allocate an extra platform device
  crypto: caam/qi - fix address translations with IOMMU enabled
  crypto: caam/qi - DMA map keys using proper device
  crypto: caam - defer probing until QMan is available

 drivers/crypto/caam/Kconfig       |  46 ++++-------
 drivers/crypto/caam/Makefile      |  18 ++---
 drivers/crypto/caam/caamalg.c     |  72 ++++++++---------
 drivers/crypto/caam/caamalg_qi.c  | 124 +++++++++++++++---------------
 drivers/crypto/caam/caamalg_qi2.c |  72 +++++++++++++----
 drivers/crypto/caam/caamhash.c    |  81 ++++++-------------
 drivers/crypto/caam/caampkc.c     |  57 +++-----------
 drivers/crypto/caam/caamrng.c     |  54 ++-----------
 drivers/crypto/caam/ctrl.c        | 124 ++++++++++++++++++------------
 drivers/crypto/caam/desc_constr.h |  11 +++
 drivers/crypto/caam/intern.h      | 102 ++++++++++++++++++++++--
 drivers/crypto/caam/jr.c          |  43 +++++++++++
 drivers/crypto/caam/qi.c          |  52 ++++++-------
 13 files changed, 465 insertions(+), 391 deletions(-)

-- 
2.17.1

