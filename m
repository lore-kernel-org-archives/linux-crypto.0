From: Rui Wang <rui.y.wang@intel.com>
Subject: [PATCH 0/2] crypto: Fix driver load failure
Date: Sun, 29 Nov 2015 22:45:32 +0800
Message-ID: <1448808334-8424-1-git-send-email-rui.y.wang@intel.com>
Cc: ying.huang@intel.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, rui.y.wang@intel.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:45630 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752548AbbK2PDa (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 29 Nov 2015 10:03:30 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

ghash_clmulni_intel fails to load on Linux 4.3+ with the following message:
"modprobe: ERROR: could not insert 'ghash_clmulni_intel': Invalid argument"

These two patches need to go together, for the driver to load correctly.

Rui Wang (2):
  crypto: ghash-clmulni - Fix load failure
  crypto: cryptd - Assign statesize properly

 arch/x86/crypto/ghash-clmulni-intel_glue.c | 26 ++++++++++++++++++++++++++
 crypto/cryptd.c                            |  1 +
 2 files changed, 27 insertions(+)

-- 
1.8.5.2
