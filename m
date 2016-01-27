From: Rui Wang <rui.y.wang@intel.com>
Subject: [PATCH v2 0/4] Fix sha1_mb failure and testing import()/export()
Date: Wed, 27 Jan 2016 17:08:34 +0800
Message-ID: <1453885718-24599-1-git-send-email-rui.y.wang@intel.com>
Cc: tim.c.chen@linux.intel.com, rui.y.wang@intel.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi All,

This patchset resulted from the failure when loading sha1_mb. It
is because ahash drivers are now required to implement import()
and export(). Also, now it seems beneficial to add a test case in
testmgr to test import()/export(), thus:

patch01 - patch03 fix the problems while loading sha1_mb.
patch04 adds a test case for import() and export(). A hash algo's
import()/export() can be tested by simply adding .partial = 1 to
its corresponding struct hash_testvec where .np > 1.

v2: Leverage template[i].np in the test case as suggested by Tim Chen.

Rui Wang (4):
  crypto x86/sha1_mb: Fix load failure
  crypto: mcryptd - Fix load failure
  crypto: algif_hash - wait for crypto_ahash_init() to complete
  crypto: testmgr - Add a test case for import()/export()

 arch/x86/crypto/sha-mb/sha1_mb.c |  39 +++++++++++
 crypto/algif_hash.c              |   4 +-
 crypto/mcryptd.c                 |   1 +
 crypto/testmgr.c                 | 136 +++++++++++++++++++++++++++++++++++++++
 crypto/testmgr.h                 |   4 +-
 5 files changed, 182 insertions(+), 2 deletions(-)

-- 
1.8.3.1
