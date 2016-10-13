From: Harsh Jain <harsh@chelsio.com>
Subject: [PATCH 0/6] chcr: AEAD support and bug fixes
Date: Thu, 13 Oct 2016 16:39:33 +0530
Message-ID: <cover.1476263960.git.harsh@chelsio.com>
Cc: jlulla@chelsio.com, atul.gupta@chelsio.com, yeshaswi@chelsio.com,
        hariprasad@chelsio.com, Harsh Jain <harsh@chelsio.com>
To: dan.carpenter@oracle.com, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:5213 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754058AbcJMLNM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 13 Oct 2016 07:13:12 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch series includes Bug Fixes, performance improvement and
support for following AEAD algos.
GCM,CCM,RFC4106,RFC4303,authenc(hmac(shaXXX),cbc(aes))

This patch series is based on linux-next tree and depends on
("crypto/chcr: Add support for Chelsio Crypto Driver ") series.

https://www.mail-archive.com/linux-crypto@vger.kernel.org/msg20658.html

Jitendra Lulla (3):
  Fix memory corruption done by  *((u32 *)dec_key + k) operation.
  Remove malloc/free in crypto operation and allocate memory in Init.
      Added new structure chcr_wr to populate Work Request Header.
  Destination buffer size passed to hardware should not be greater than
    crypto operation output.
Harsh Jain (3):
  Use SHASH_DESC_ON_STACK macro to allocate memory for ipad/opad
    calculation.
  Move tfm ctx variable to request context.
  Add support for AEAD algos
    GCM,CCM,RFC4106,RFC4303,authenc(hmac(shaXXX),cbc(aes))

 drivers/crypto/chelsio/Kconfig       |    1 +
 drivers/crypto/chelsio/chcr_algo.c   | 1998 +++++++++++++++++++++++++++++-----
 drivers/crypto/chelsio/chcr_algo.h   |  102 +-
 drivers/crypto/chelsio/chcr_core.c   |    8 +-
 drivers/crypto/chelsio/chcr_core.h   |   18 +-
 drivers/crypto/chelsio/chcr_crypto.h |  115 +-
 6 files changed, 1857 insertions(+), 385 deletions(-)

-- 
1.8.2.3
