From: Harsh Jain <harsh@chelsio.com>
Subject: [PATCH v2 0/9] crypto/chcr: AEAD support and bug fixes
Date: Mon, 21 Nov 2016 21:30:46 +0530
Message-ID: <cover.1479740559.git.harsh@chelsio.com>
Cc: Harsh Jain <harsh@chelsio.com>
To: dan.carpenter@oracle.com, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, smueller@chronox.de,
        jlulla@chelsio.com, atul.gupta@chelsio.com, yeshaswi@chelsio.com,
        hariprasad@chelsio.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:31830 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754369AbcKUQB2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Nov 2016 11:01:28 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch series includes Bug Fixes, performance improvement and
support for following AEAD algos.
GCM,CCM,RFC4106,RFC4303,authenc(hmac(shaXXX),cbc(aes))

Jitendra Lulla (4):
  chcr:Fix memory corruption done
  Added new structure chcr_wr to populate Work Request Header.
  Fixes: 324429d74127, Unchecked dereference inside function.
  Remove malloc/free in hash operation and allocate memory in
    chcr_ahash_req_ctx structure.
Harsh Jain (5):
  Calculate Reverse round key in setkey callback.
  chcr: Adjust Dest. buffer size
  chcr: Use SHASH_DESC_ON_STACK
  chcr: Move tfm ctx variable to request context
  Add AEAD algos.    
    GCM,CCM,RFC4106,RFC4309,authenc(hmac(shaXXX),cbc(aes)).

 drivers/crypto/chelsio/Kconfig       |    1 +
 drivers/crypto/chelsio/chcr_algo.c   | 2014 +++++++++++++++++++++++++++++-----
 drivers/crypto/chelsio/chcr_algo.h   |  102 +-
 drivers/crypto/chelsio/chcr_core.c   |    8 +-
 drivers/crypto/chelsio/chcr_core.h   |   18 +-
 drivers/crypto/chelsio/chcr_crypto.h |  115 +-
 6 files changed, 1874 insertions(+), 384 deletions(-)

-- 
1.8.2.3
