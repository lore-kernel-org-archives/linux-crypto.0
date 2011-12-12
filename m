From: Kim Phillips <kim.phillips@freescale.com>
Subject: [PATCH 0/7] crypto: talitos/caam: SEC h/w v2.0 fix and cleanups
Date: Mon, 12 Dec 2011 14:59:09 -0600
Message-ID: <1323723556-7100-1-git-send-email-kim.phillips@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Herbert Xu <herbert@gondor.apana.org.au>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:16697 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753965Ab1LLVAf (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 12 Dec 2011 16:00:35 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The first patch in the series fixes a boottime oops on SEC h/w v.2.0.
The rest are minor cleanups.

The fourth - "crypto: caam - desc.h - convert spaces to tabs" -
is the result of running unexpand -a on desc.h, and may exceed list
message quota limits.  If this is the case, please execute unexpand
manually (or let me know how to better handle this situation).
Herbert, I'm cc'ing you on this, so you should receive all 7 patches.

Kim Phillips (7):
  crypto: talitos - fix bad kfree
  crypto: talitos - remove NO_IRQ references
  crypto: talitos - convert talitos_error to struct device
  crypto: caam - desc.h - convert spaces to tabs
  crypto: caam - more desc.h cleanups
  crypto: caam - fix polarity of "propagate error" logic
  crypto: caam - remove DECO access initialization code

 drivers/crypto/caam/caamalg.c     |   10 +-
 drivers/crypto/caam/ctrl.c        |   13 -
 drivers/crypto/caam/desc.h        | 2265 ++++++++++++++++++-------------------
 drivers/crypto/caam/desc_constr.h |    7 +-
 drivers/crypto/caam/regs.h        |    1 -
 drivers/crypto/talitos.c          |   31 +-
 6 files changed, 1156 insertions(+), 1171 deletions(-)

-- 
1.7.8
