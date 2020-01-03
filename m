Return-Path: <SRS0=TjYB=2Y=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAC5DC3276C
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Jan 2020 01:03:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8848C217F4
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Jan 2020 01:03:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726148AbgACBDT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 2 Jan 2020 20:03:19 -0500
Received: from inva020.nxp.com ([92.121.34.13]:47460 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727134AbgACBDT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 Jan 2020 20:03:19 -0500
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 6107A1A1B0C;
        Fri,  3 Jan 2020 02:03:12 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 543001A1B0B;
        Fri,  3 Jan 2020 02:03:12 +0100 (CET)
Received: from lorenz.ea.freescale.net (lorenz.ea.freescale.net [10.171.71.5])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 0416B205C2;
        Fri,  3 Jan 2020 02:03:11 +0100 (CET)
From:   Iuliana Prodan <iuliana.prodan@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-imx <linux-imx@nxp.com>,
        Iuliana Prodan <iuliana.prodan@nxp.com>
Subject: [PATCH v2 00/10] crypto: caam - backlogging support
Date:   Fri,  3 Jan 2020 03:02:43 +0200
Message-Id: <1578013373-1956-1-git-send-email-iuliana.prodan@nxp.com>
X-Mailer: git-send-email 2.1.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Integrate crypto_engine framework into CAAM, to make use of
the engine queue.
Added support for SKCIPHER, HASH, RSA and AEAD algorithms.
This is intended to be used for CAAM backlogging support.
The requests, with backlog flag (e.g. from dm-crypt) will be
listed into crypto-engine queue and processed by CAAM when free.

While here, I've also made some refactorization.
Patches #1 - #4 include some refactorizations on caamalg, caamhash
and caampkc.
Patches #5, #6 change the return code of caam_jr_enqueue function
to -EINPROGRESS, in case of success, -ENOSPC in case the CAAM is
busy, -EIO if it cannot map the caller's descriptor.
Also, to keep each request information, like backlog flag, a new
struct is passed as argument to enqueue function.
Patches #7 - #10 integrate crypto_engine into CAAM, for
SKCIPHER/AEAD/RSA/HASH algorithms.

---
Changes since V1:
	- remove helper function - akcipher_request_cast;
	- remove any references to crypto_async_request,
	  use specific request type;
	- remove bypass crypto-engine queue, in case is empty;
	- update some commit messages;
	- remove unrelated changes, like whitespaces;
	- squash some changes from patch #9 to patch #6;
	- added Reviewed-by.
---

Iuliana Prodan (10):
  crypto: caam - refactor skcipher/aead/gcm/chachapoly {en,de}crypt
    functions
  crypto: caam - refactor ahash_done callbacks
  crypto: caam - refactor ahash_edesc_alloc
  crypto: caam - refactor RSA private key _done callbacks
  crypto: caam - change return code in caam_jr_enqueue function
  crypto: caam - refactor caam_jr_enqueue
  crypto: caam - support crypto_engine framework for SKCIPHER algorithms
  crypto: caam - add crypto_engine support for AEAD algorithms
  crypto: caam - add crypto_engine support for RSA algorithms
  crypto: caam - add crypto_engine support for HASH algorithms

 drivers/crypto/caam/Kconfig    |   1 +
 drivers/crypto/caam/caamalg.c  | 450 +++++++++++++++++++----------------------
 drivers/crypto/caam/caamhash.c | 357 +++++++++++++++++---------------
 drivers/crypto/caam/caampkc.c  | 205 ++++++++++++-------
 drivers/crypto/caam/caampkc.h  |  22 ++
 drivers/crypto/caam/caamrng.c  |   4 +-
 drivers/crypto/caam/intern.h   |   3 +
 drivers/crypto/caam/jr.c       |  37 +++-
 drivers/crypto/caam/key_gen.c  |   2 +-
 9 files changed, 597 insertions(+), 484 deletions(-)

-- 
2.1.0

