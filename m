From: Megha Dey <megha.dey@intel.com>
Subject: [PATCH 0/2] async implementation for sha1-mb
Date: Tue, 31 May 2016 14:42:19 -0700
Message-ID: <1464730941-8847-1-git-send-email-megha.dey@intel.com>
Cc: tim.c.chen@linux.intel.com, davem@davemloft.net,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	megha.dey@intel.com, fenghua.yu@intel.com,
	Megha Dey <megha.dey@linux.intel.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:28357 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751364AbcEaVhG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 31 May 2016 17:37:06 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

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

Megha Dey (2):
  crypto : stylistic cleanup in sha1-mb
  crypto : async implementation for sha1-mb

 arch/x86/crypto/sha-mb/sha1_mb.c | 292 ++++++++++++++++++++++++---------------
 crypto/ahash.c                   |   6 -
 crypto/mcryptd.c                 | 117 ++++++++--------
 include/crypto/hash.h            |   6 +
 include/crypto/internal/hash.h   |   8 +-
 include/crypto/mcryptd.h         |   8 +-
 6 files changed, 254 insertions(+), 183 deletions(-)

-- 
1.9.1
