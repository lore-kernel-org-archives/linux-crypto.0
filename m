From: Megha Dey <megha.dey@intel.com>
Subject: [PATCH V2 0/2] Implementation of an async interface for sha1-mb
Date: Thu,  2 Jun 2016 19:53:48 -0700
Message-ID: <1464922430-26976-1-git-send-email-megha.dey@intel.com>
Cc: tim.c.chen@linux.intel.com, davem@davemloft.net,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	megha.dey@intel.com, fenghua.yu@intel.com,
	Megha Dey <megha.dey@linux.intel.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Megha Dey <megha.dey@linux.intel.com>

Currently, sha1-mb uses an async interface for the outer algorithm
and a sync interface for the inner algorithm.
Herbert wants the sha1-mb algorithm to have an async implementation:
https://lkml.org/lkml/2016/4/5/286.
This patch introduces a async interface for even the inner algorithm.
Additionally, there are several checkpatch warnings in the sha1_mb.c file:
'WARNING: line over 80 characters' in the sha1_mb.c file. Also, the
syntax of some multi-line comments are not correct. This patchset fixes
these issues.

changes V1->V2
rename shash_ahash_mcryptd* functions to ahash_mcryptd_*
removed the export_symbols for the shash_ahash_mcryptd_* functions
use ahash_interfaces instead of touching the crypto_ahash_request directly

Megha Dey (2):
  crypto: sha1-mb - stylistic cleanup
  crypto : async implementation for sha1-mb

 arch/x86/crypto/sha-mb/sha1_mb.c | 292 ++++++++++++++++++++++++---------------
 crypto/ahash.c                   |   6 -
 crypto/mcryptd.c                 | 131 +++++++++---------
 include/crypto/hash.h            |   6 +
 include/crypto/internal/hash.h   |  16 +--
 include/crypto/mcryptd.h         |   8 +-
 6 files changed, 263 insertions(+), 196 deletions(-)

-- 
1.9.1
