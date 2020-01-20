Return-Path: <SRS0=QLPS=3J=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 848DEC2D0DB
	for <linux-crypto@archiver.kernel.org>; Mon, 20 Jan 2020 12:24:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6259E208E4
	for <linux-crypto@archiver.kernel.org>; Mon, 20 Jan 2020 12:24:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726860AbgATMYQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 20 Jan 2020 07:24:16 -0500
Received: from inva021.nxp.com ([92.121.34.21]:46812 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726589AbgATMYQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 20 Jan 2020 07:24:16 -0500
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id D94972002F3;
        Mon, 20 Jan 2020 13:24:13 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id CBCCA200275;
        Mon, 20 Jan 2020 13:24:13 +0100 (CET)
Received: from lorenz.ea.freescale.net (lorenz.ea.freescale.net [10.171.71.5])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 5E94420414;
        Mon, 20 Jan 2020 13:24:13 +0100 (CET)
From:   Iuliana Prodan <iuliana.prodan@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Silvano Di Ninno <silvano.dininno@nxp.com>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-imx <linux-imx@nxp.com>,
        Iuliana Prodan <iuliana.prodan@nxp.com>
Subject: [PATCH v4 0/9] crypto: caam - backlogging support
Date:   Mon, 20 Jan 2020 14:23:59 +0200
Message-Id: <1579523048-21078-1-git-send-email-iuliana.prodan@nxp.com>
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
Patch #5 changes the return code of caam_jr_enqueue function
to -EINPROGRESS, in case of success, -ENOSPC in case the CAAM is
busy, -EIO if it cannot map the caller's descriptor.
Patches #6 - #9 integrate crypto_engine into CAAM, for
SKCIPHER/AEAD/RSA/HASH algorithms.

---
Changes since V3:
	- update return on ahash_enqueue_req function from patch #9.

Changes since V2:
	- remove patch ("crypto: caam - refactor caam_jr_enqueue"),
	  that added some structures not needed anymore;
	- use _done_ callback function directly for skcipher and aead;
	- handle resource leak in case of transfer request to crypto-engine;
	- update commit messages.

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

Iuliana Prodan (9):
  crypto: caam - refactor skcipher/aead/gcm/chachapoly {en,de}crypt
    functions
  crypto: caam - refactor ahash_done callbacks
  crypto: caam - refactor ahash_edesc_alloc
  crypto: caam - refactor RSA private key _done callbacks
  crypto: caam - change return code in caam_jr_enqueue function
  crypto: caam - support crypto_engine framework for SKCIPHER algorithms
  crypto: caam - add crypto_engine support for AEAD algorithms
  crypto: caam - add crypto_engine support for RSA algorithms
  crypto: caam - add crypto_engine support for HASH algorithms

 drivers/crypto/caam/Kconfig    |   1 +
 drivers/crypto/caam/caamalg.c  | 416 ++++++++++++++++++-----------------------
 drivers/crypto/caam/caamhash.c | 341 ++++++++++++++++-----------------
 drivers/crypto/caam/caampkc.c  | 187 +++++++++++-------
 drivers/crypto/caam/caampkc.h  |  10 +
 drivers/crypto/caam/caamrng.c  |   4 +-
 drivers/crypto/caam/intern.h   |   2 +
 drivers/crypto/caam/jr.c       |  37 +++-
 drivers/crypto/caam/key_gen.c  |   2 +-
 9 files changed, 523 insertions(+), 477 deletions(-)

-- 
2.1.0

