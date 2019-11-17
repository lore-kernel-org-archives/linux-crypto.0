Return-Path: <SRS0=TGTC=ZJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42688C432C0
	for <linux-crypto@archiver.kernel.org>; Sun, 17 Nov 2019 22:31:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 220C820729
	for <linux-crypto@archiver.kernel.org>; Sun, 17 Nov 2019 22:31:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726974AbfKQWbu (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 17 Nov 2019 17:31:50 -0500
Received: from inva021.nxp.com ([92.121.34.21]:44586 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726151AbfKQWbE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 17 Nov 2019 17:31:04 -0500
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 5C8C520030A;
        Sun, 17 Nov 2019 23:31:02 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 4E9C22000AA;
        Sun, 17 Nov 2019 23:31:02 +0100 (CET)
Received: from lorenz.ea.freescale.net (lorenz.ea.freescale.net [10.171.71.5])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id D3747202AF;
        Sun, 17 Nov 2019 23:31:01 +0100 (CET)
From:   Iuliana Prodan <iuliana.prodan@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Gary Hook <gary.hook@amd.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-imx <linux-imx@nxp.com>,
        Iuliana Prodan <iuliana.prodan@nxp.com>
Subject: [PATCH 00/12] crypto: caam - backlogging support
Date:   Mon, 18 Nov 2019 00:30:33 +0200
Message-Id: <1574029845-22796-1-git-send-email-iuliana.prodan@nxp.com>
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
For better performance, crypto-engine software queue is bypassed,
if empty, and the request is sent directly to hardware. If this
returns -ENOSPC, the request is transferred to crypto-engine and
let it handle it.

While here, I've also made some refactorization.
Patch #1, adds a helper function - akcipher_request_cast, to get
an akcipher_request struct from a crypto_async_request struct.
Patches #2 - #5 include some refactorizations on caamalg, caamhash
and caampkc.
Patches #6, #7 change the return code of caam_jr_enqueue function
to -EINPROGRESS, in case of success, -ENOSPC in case the CAAM is
busy, -EIO if it cannot map the caller's descriptor and add a new
enqueue function for no backlogging requests. Also, to keep each
request information, like backlog flag, a new struct is passed as
argument to enqueue functions.
Patches #8 - #12 integrate crypto_engine into CAAM, for
SKCIPHER/AEAD/RSA/HASH algorithms.


Iuliana Prodan (12):
  crypto: add helper function for akcipher_request
  crypto: caam - refactor skcipher/aead/gcm/chachapoly {en,de}crypt
    functions
  crypto: caam - refactor ahash_done callbacks
  crypto: caam - refactor ahash_edesc_alloc
  crypto: caam - refactor RSA private key _done callbacks
  crypto: caam - change return code in caam_jr_enqueue function
  crypto: caam - refactor caam_jr_enqueue
  crypto: caam - support crypto_engine framework for SKCIPHER algorithms
  crypto: caam - bypass crypto-engine sw queue, if empty
  crypto: caam - add crypto_engine support for AEAD algorithms
  crypto: caam - add crypto_engine support for RSA algorithms
  crypto: caam - add crypto_engine support for HASH algorithms

 drivers/crypto/caam/Kconfig         |   1 +
 drivers/crypto/caam/caamalg.c       | 411 ++++++++++++++++--------------------
 drivers/crypto/caam/caamhash.c      | 323 +++++++++++++++-------------
 drivers/crypto/caam/caampkc.c       | 177 ++++++++++------
 drivers/crypto/caam/caampkc.h       |  11 +
 drivers/crypto/caam/caamrng.c       |   7 +-
 drivers/crypto/caam/intern.h        |  12 ++
 drivers/crypto/caam/jr.c            | 136 +++++++++++-
 drivers/crypto/caam/jr.h            |   4 +
 drivers/crypto/caam/key_gen.c       |   4 +-
 drivers/crypto/ccp/ccp-crypto-rsa.c |   6 -
 include/crypto/akcipher.h           |   6 +
 12 files changed, 635 insertions(+), 463 deletions(-)

-- 
2.1.0

