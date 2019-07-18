Return-Path: <SRS0=4UBR=VP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7408C7618F
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Jul 2019 14:45:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 49D7821849
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Jul 2019 14:45:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727740AbfGROpi (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Jul 2019 10:45:38 -0400
Received: from inva020.nxp.com ([92.121.34.13]:49410 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726513AbfGROpi (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Jul 2019 10:45:38 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 944EC1A0086;
        Thu, 18 Jul 2019 16:45:36 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 883991A0006;
        Thu, 18 Jul 2019 16:45:36 +0200 (CEST)
Received: from lorenz.ea.freescale.net (lorenz.ea.freescale.net [10.171.71.5])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 3B5E6205C7;
        Thu, 18 Jul 2019 16:45:36 +0200 (CEST)
From:   Iuliana Prodan <iuliana.prodan@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-imx <linux-imx@nxp.com>
Subject: [PATCH 00/14] crypto: caam - fixes for kernel v5.3
Date:   Thu, 18 Jul 2019 17:45:10 +0300
Message-Id: <1563461124-24641-1-git-send-email-iuliana.prodan@nxp.com>
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

Horia Geantă (5):
  crypto: caam/qi - fix error handling in ERN handler
  crypto: caam - fix return code in completion callbacks
  crypto: caam - update IV only when crypto operation succeeds
  crypto: caam - keep both virtual and dma key addresses
  crypto: caam - fix DKP for certain key lengths

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

 drivers/crypto/caam/Makefile        |   2 +-
 drivers/crypto/caam/caamalg.c       | 226 ++++++++++++++++----------
 drivers/crypto/caam/caamalg_desc.c  |  46 ++++--
 drivers/crypto/caam/caamalg_desc.h  |   2 +-
 drivers/crypto/caam/caamalg_qi.c    | 222 +++++++++++++++----------
 drivers/crypto/caam/caamalg_qi2.c   | 316 ++++++++++++++++++++++++------------
 drivers/crypto/caam/caamhash.c      | 113 ++++++++-----
 drivers/crypto/caam/caamhash_desc.c |   5 +-
 drivers/crypto/caam/caamhash_desc.h |   2 +-
 drivers/crypto/caam/caampkc.c       |  80 ++++++---
 drivers/crypto/caam/caamrng.c       |  17 +-
 drivers/crypto/caam/common_if.c     |  88 ++++++++++
 drivers/crypto/caam/common_if.h     |  19 +++
 drivers/crypto/caam/desc_constr.h   |  34 ++--
 drivers/crypto/caam/error.c         |  61 ++++---
 drivers/crypto/caam/error.h         |   2 +-
 drivers/crypto/caam/key_gen.c       |   5 +-
 drivers/crypto/caam/qi.c            |  10 +-
 drivers/crypto/caam/regs.h          |   1 +
 19 files changed, 851 insertions(+), 400 deletions(-)
 create mode 100644 drivers/crypto/caam/common_if.c
 create mode 100644 drivers/crypto/caam/common_if.h

-- 
2.1.0

