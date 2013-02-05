From: Alex Porosanu <alexandru.porosanu@freescale.com>
Subject: [PATCH 0/2] RNG4 support for SEC versions < 5
Date: Tue, 5 Feb 2013 12:21:23 +0200
Message-ID: <1360059685-4953-1-git-send-email-alexandru.porosanu@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from co9ehsobe003.messaging.microsoft.com ([207.46.163.26]:23084
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750960Ab3BEKW1 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 5 Feb 2013 05:22:27 -0500
Received: from mail78-co9 (localhost [127.0.0.1])	by mail78-co9-R.bigfish.com
 (Postfix) with ESMTP id 70302A01CA	for <linux-crypto@vger.kernel.org>; Tue,
  5 Feb 2013 10:22:26 +0000 (UTC)
Received: from CO9EHSMHS021.bigfish.com (unknown [10.236.132.252])	by
 mail78-co9.bigfish.com (Postfix) with ESMTP id AD4272E0085	for
 <linux-crypto@vger.kernel.org>; Tue,  5 Feb 2013 10:22:24 +0000 (UTC)
Received: from localhost.localdomain ([10.171.77.122])	by
 az84smr01.freescale.net (8.14.3/8.14.0) with ESMTP id r15AMLxH028285	for
 <linux-crypto@vger.kernel.org>; Tue, 5 Feb 2013 03:22:22 -0700
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

There are (at least) two platforms which have SEC < 5 but the new
RNG4 block. These platforms are BSC 9131 and BSC 9132 (that I know of
so far). Thus the condition in the caam driver which checks  for the 
version of the SEC block to decide if further initialization of the 
RNG block is needed or not is not always correct. This set of patches 
should fix this by adding support for retrieving the version of the 
RNG block and executing the intialization of it depending if
it is greater or equal than 4.

Alex Porosanu (2):
  crypto: caam - support for RNG version retrieval
  crypto: caam - fix RNG init for SEC with RNG version greater than 4

 drivers/crypto/caam/ctrl.c |   15 +++++++++++++--
 drivers/crypto/caam/regs.h |   37 +++++++++++++++++++++++++++++++++++++
 2 files changed, 50 insertions(+), 2 deletions(-)

-- 
1.7.7.6
