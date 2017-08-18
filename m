From: Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH v4 0/1] crypto: engine - Permit to enqueue skcipher request
Date: Fri, 18 Aug 2017 13:42:26 +0200
Message-ID: <20170818114227.15739-1-clabbe.montjoie@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Corentin Labbe <clabbe.montjoie@gmail.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:36618 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750913AbdHRLrQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Aug 2017 07:47:16 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello

The crypto engine could actually only enqueue hash and ablkcipher request.
This patch serie permit it to enqueue skcipher requests by adding all necessary
functions.

Changes since v3
- Use cra_type only for distinguish ablkcipher from skcipher

Changes since v2
- added two patch for finding request type according to its cra_type

Changes since v1
- Aligned to column struct *dev in include
- Added missing mutex_unlock in crypto_engine_start()

Corentin Labbe (1):
  crypto: engine - Permit to enqueue skcipher request

 crypto/crypto_engine.c  | 120 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/crypto/engine.h |  14 ++++++
 2 files changed, 134 insertions(+)

-- 
2.13.0
