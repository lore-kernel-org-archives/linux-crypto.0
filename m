Return-Path: <SRS0=RABd=V3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7C5FC0650F
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jul 2019 11:06:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C51D1206E0
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jul 2019 11:06:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730145AbfG3LGv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 30 Jul 2019 07:06:51 -0400
Received: from inva021.nxp.com ([92.121.34.21]:55492 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725974AbfG3LGv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Jul 2019 07:06:51 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id C798A20067C;
        Tue, 30 Jul 2019 13:06:48 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id BB077200679;
        Tue, 30 Jul 2019 13:06:48 +0200 (CEST)
Received: from lorenz.ea.freescale.net (lorenz.ea.freescale.net [10.171.71.5])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 55B37204D6;
        Tue, 30 Jul 2019 13:06:48 +0200 (CEST)
From:   Iuliana Prodan <iuliana.prodan@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-imx <linux-imx@nxp.com>
Subject: [PATCH v4 00/14] crypto: caam - fixes for kernel v5.3
Date:   Tue, 30 Jul 2019 14:06:31 +0300
Message-Id: <1564484805-28735-1-git-send-email-iuliana.prodan@nxp.com>
X-Mailer: git-send-email 2.1.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The series solves:
- the failures found with fuzz testing;
- resources clean-up on caampkc/caamrng exit path.

The first 10 patches solve the issues found with
CONFIG_CRYPTO_MANAGER_EXTRA_TESTS enabled.
They modify the drivers to provide a valid error (and not the hardware
error ID) to the user, via completion callbacks.
They check key length, assoclen, authsize and input size to solve the
fuzz tests that expect -EINVAL to be returned when these values are
not valid.

The next 4 patches check the algorithm registration for caampkc
module and unregister it only if the registration was successful.
Also, on caampkc/caamrng, the exit point function is executed only if the
registration was successful to avoid double freeing of resources in case
the initialization function failed.

This patch depends on series:
https://patchwork.kernel.org/project/linux-crypto/list/?series=152649

Changes since v3:
- use, newly renamed, helper functions from crypto API, to validate
the inputs;
- update rfc4106 shared descriptor, by moving the erratum workaround.

Horia Geantă (5):
  crypto: caam/qi - fix error handling in ERN handler
  crypto: caam - fix return code in completion callbacks
  crypto: caam - update IV only when crypto operation succeeds
  crypto: caam - keep both virtual and dma key addresses
  crypto: caam - fix MDHA key derivation for certain user key lengths

Iuliana Prodan (9):
  crypto: caam - check key length
  crypto: caam - check authsize
  crypto: caam - check assoclen
  crypto: caam - check zero-length input
  crypto: caam - update rfc4106 sh desc to support zero length input
  crypto: caam - free resources in case caam_rng registration failed
  crypto: caam - execute module exit point only if necessary
  crypto: caam - unregister algorithm only if the registration succeeded
  crypto: caam - change return value in case CAAM has no MDHA

 drivers/crypto/caam/Kconfig         |   2 +
 drivers/crypto/caam/caamalg.c       | 227 +++++++++++++++----------
 drivers/crypto/caam/caamalg_desc.c  |  47 ++++--
 drivers/crypto/caam/caamalg_desc.h  |   2 +-
 drivers/crypto/caam/caamalg_qi.c    | 225 +++++++++++++++----------
 drivers/crypto/caam/caamalg_qi2.c   | 320 +++++++++++++++++++++++-------------
 drivers/crypto/caam/caamhash.c      | 114 ++++++++-----
 drivers/crypto/caam/caamhash_desc.c |   5 +-
 drivers/crypto/caam/caamhash_desc.h |   2 +-
 drivers/crypto/caam/caampkc.c       |  80 ++++++---
 drivers/crypto/caam/caamrng.c       |  17 +-
 drivers/crypto/caam/desc_constr.h   |  34 ++--
 drivers/crypto/caam/error.c         |  61 ++++---
 drivers/crypto/caam/error.h         |   2 +-
 drivers/crypto/caam/key_gen.c       |  14 +-
 drivers/crypto/caam/qi.c            |  10 +-
 drivers/crypto/caam/regs.h          |   1 +
 17 files changed, 748 insertions(+), 415 deletions(-)

-- 
2.1.0

