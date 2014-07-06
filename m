From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH 0/6] DRBG: Rebasing unapplied patches
Date: Sun, 06 Jul 2014 02:22:29 +0200
Message-ID: <2266932.bfVPMOTOeI@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: joe@perches.com, dan.carpenter@oracle.com,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	fengguang.wu@intel.com, Randy Dunlap <rdunlap@infradead.org>,
	linux-crypto@vger.kernel.org, linux-next@vger.kernel.org,
	linux-kernel@vger.kernel.org, Rafael Aquini <aquini@redhat.com>,
	aris@redhat.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:41601 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750828AbaGFAqB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sat, 5 Jul 2014 20:46:01 -0400
Received: from myon.chronox.de
	by mail.eperm.de with [XMail 1.27 ESMTP Server]
	id <S255> for <linux-crypto@vger.kernel.org> from <smueller@chronox.de>;
	Sun, 6 Jul 2014 02:44:51 +0200
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

This patchset superseeds the patch sets submitted with [1] and [2]. It
rebases all non-applied patches to the current Herbert Xu's
cryptodev-2.6 tree.

[1] https://lkml.org/lkml/2014/6/28/497
[2] https://lkml.org/lkml/2014/7/1/332

Stephan Mueller (6):
  DRBG: cleanup of preprocessor macros
  DRBG: Fix format string for debugging statements
  DRBG: Call CTR DRBG DF function only once
  DRBG: Select correct DRBG core for stdrng
  DRBG: Mix a time stamp into DRBG state
  DRBG: HMAC-SHA1 DRBG has crypto strength of 128 bits

 crypto/drbg.c         | 134 +++++++++++++++++++++++++++++---------------------
 include/crypto/drbg.h |   2 +-
 2 files changed, 78 insertions(+), 58 deletions(-)

-- 
1.9.3
