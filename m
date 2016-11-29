From: Harsh Jain <harsh@chelsio.com>
Subject: [PATCH v3 00/10] crypto/chcr: AEAD support and bug fixes
Date: Tue, 29 Nov 2016 19:00:33 +0530
Message-ID: <cover.1480413079.git.harsh@chelsio.com>
Cc: Harsh Jain <harsh@chelsio.com>
To: dan.carpenter@oracle.com, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, smueller@chronox.de,
        hariprasad@chelsio.com, jlulla@chelsio.com, atul.gupta@chelsio.com,
        yeshaswi@chelsio.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:6124 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754909AbcK2NbK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 29 Nov 2016 08:31:10 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch series includes Bug Fixes, performance improvement and
support for following AEAD algos.
GCM,CCM,RFC4106,RFC4303,authenc(hmac(shaXXX),cbc(aes))

v3:
-Break patch 01 into 2.
v2:
-Replace memcmp to crypto_memneq.
-Handle cryptlen less than authsize.
-Check assoclen and cryptlen passed should not the greater 
 than src sg list.
-Break patch 02 into 3


Jitendra Lulla (5):
  Fix memory corruption done by  *((u32 *)dec_key + k) operation.
  Cosmetic change. Moves get_aes_decrypt_key function to .c file and    
    declare inline "aes_ks_subword"
  crypto/chcr: Added new structure chcr_wr to populate Work Request
    Header.
  crypto/chcr: Fixes Unchecked dereference inside function
  crypto/chcr: Remove dynamic allocation
Harsh Jain (5):
  crypto/chcr: Calculate Reverse round key in setkey callback.
  crypto/chcr: Adjust Dest. buffer size
  crypto/chcr: Use SHASH_DESC_ON_STACK
  crypto/chcr: Move tfm ctx variable to request context
  Add support for following AEAD algos.     
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
