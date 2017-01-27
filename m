From: Harsh Jain <harsh@chelsio.com>
Subject: [PATCH 0/8] Bug fixes
Date: Fri, 27 Jan 2017 16:09:04 +0530
Message-ID: <cover.1485501428.git.harsh@chelsio.com>
Cc: Harsh Jain <harsh@chelsio.com>
To: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        hariprasad@chelsio.com, netdev@vger.kernel.org, arjun@chelsio.com,
        atul.gupta@chelsio.com
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This patch series is based on Herbert's cryptodev-2.6 tree and depends on 
patch series "Bug Fixes for 4.10". It includes Bug Fixes.

Atul Gupta (2)
  crypto:chcr-Change flow IDs
  crypto:chcr- Fix wrong typecasting
Harsh Jain (8):
  crypto:chcr- Fix key length for RFC4106
  crypto:chcr-fix itnull.cocci warnings
  crypto:chcr- Use cipher instead of Block Cipher in gcm setkey
  crypto:chcr: Change cra_flags for cipher algos
  crypto:chcr- Change algo priority
  crypto:chcr-Fix Smatch Complaint

 drivers/crypto/chelsio/chcr_algo.c            | 53 ++++++++++++++-------------
 drivers/crypto/chelsio/chcr_algo.h            |  9 +++--
 drivers/crypto/chelsio/chcr_core.c            | 11 +++---
 drivers/crypto/chelsio/chcr_core.h            |  1 +
 drivers/crypto/chelsio/chcr_crypto.h          |  2 +-
 drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h |  8 ++++
 6 files changed, 47 insertions(+), 37 deletions(-)
 mode change 100644 => 100755 drivers/crypto/chelsio/chcr_algo.c

-- 
1.8.2.3
