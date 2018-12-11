Return-Path: <SRS0=eKEb=OU=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:17052 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726577AbeLKKv5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 11 Dec 2018 05:51:57 -0500
From: Harsh Jain <harsh@chelsio.com>
To: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        atul.gupta@chelsio.com, indranil@chelsio.com
Cc: Harsh Jain <harsh@chelsio.com>
Subject: [PATCH 0/6] crypto:chelsio: Bug Fixes
Date: Tue, 11 Dec 2018 16:21:36 +0530
Message-Id: <cover.1544520025.git.harsh@chelsio.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

It includes Bug Fixes

Harsh Jain (5):
  crypto:chcr: Swap location of AAD and IV sent in WR
  crypto:chcr:Use same value for both channel in single WR
  crypto:chcr: cleanup:send addr as value in function argument
  crypto:chelsio: Fix wrong error counter increments
  Crypto:Chelsio:Handle PCI shutdown event

Atul Gupta (5):
  crypto:chelsio: Reset counters on cxgb4 Detach

 drivers/crypto/chelsio/chcr_algo.c   | 401 +++++++++++++++++++++--------------
 drivers/crypto/chelsio/chcr_algo.h   |   2 +-
 drivers/crypto/chelsio/chcr_core.c   | 195 +++++++++++------
 drivers/crypto/chelsio/chcr_core.h   |  35 ++-
 drivers/crypto/chelsio/chcr_crypto.h |  10 +-
 5 files changed, 407 insertions(+), 236 deletions(-)

-- 
2.1.4
