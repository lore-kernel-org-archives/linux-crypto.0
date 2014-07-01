From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH 0/4] DRBG: Fixes for code review comments
Date: Tue, 01 Jul 2014 17:06:58 +0200
Message-ID: <36957559.tbJt1gJF6I@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Rafael Aquini <aquini@redhat.com>, aris@redhat.com,
	Fengguang Wu <fengguang.wu@intel.com>,
	Jet Chen <jet.chen@intel.com>, Su Tao <tao.su@intel.com>,
	Yuanhan Liu <yuanhan.liu@intel.com>, LKP <lkp@01.org>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:46446 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754932AbaGAPSg (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 1 Jul 2014 11:18:36 -0400
Received: from myon.chronox.de
	by mail.eperm.de with [XMail 1.27 ESMTP Server]
	id <S232> for <linux-crypto@vger.kernel.org> from <smueller@chronox.de>;
	Tue, 1 Jul 2014 17:17:28 +0200
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

the following fixes cover comments from code reviewers. The patch set
is an addition to the patch set offered several days ago [1].

[1] https://lkml.org/lkml/2014/6/28/497

Stephan Mueller (4):
  DRBG: Select correct DRBG core for stdrng
  DRBG: Mix a time stamp into DRBG state
  DRBG: fix memory corruption for AES192
  DRBG: HMAC-SHA1 DRBG has crypto strength of 128 bits

 crypto/drbg.c         | 77 ++++++++++++++++++++++++++++++++-------------------
 include/crypto/drbg.h |  2 +-
 2 files changed, 49 insertions(+), 30 deletions(-)

-- 
1.9.3
