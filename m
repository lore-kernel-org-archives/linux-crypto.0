From: Dan Streetman <ddstreet@ieee.org>
Subject: [PATCH 0/2] remove nx842.h from include/linux
Date: Fri, 12 Jun 2015 10:58:45 -0400
Message-ID: <1434121127-14508-1-git-send-email-ddstreet@ieee.org>
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Dan Streetman <ddstreet@ieee.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ig0-f178.google.com ([209.85.213.178]:37704 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752818AbbFLO67 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 12 Jun 2015 10:58:59 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Now that the crypto/842.c driver does only software 842 comp/decomp,
and the hardware crypto compressor for 842-nx is located in
drivers/crypto/nx with the NX 842 hw driver, there's no reason for
the nx842.h header to be located in include/linux/ anymore; nobody
should use the NX 842 hw driver directly, everyone should use the
crypto compression API.

The first patch moves the contents of include/linux/nx842.h into the
existing drivers/crypto/nx/nx-842.h header file.  The second patch
replaces the use of the NX842_MEM_COMPRESS define, since the 842-nx
crypto compression driver can directly get the required working
memory size from the NX 842 hw driver.

This cleans up include/linux/ by 1 file, and it saves some memory
by reducing the 842-nx working memory size down to exactly what the
NX 842 platform driver requires.

Dan Streetman (2):
  crypto: move include/linux/nx842.h into drivers/crypto/nx/nx-842.h
  crypto: replace NX842_MEM_COMPRESS with function

 MAINTAINERS                        |  1 -
 drivers/crypto/nx/nx-842-crypto.c  |  5 +++--
 drivers/crypto/nx/nx-842-powernv.c | 11 +++++++----
 drivers/crypto/nx/nx-842-pseries.c |  7 +++----
 drivers/crypto/nx/nx-842.c         | 11 +++++++++++
 drivers/crypto/nx/nx-842.h         | 18 +++++++++++++++++-
 include/linux/nx842.h              | 24 ------------------------
 7 files changed, 41 insertions(+), 36 deletions(-)
 delete mode 100644 include/linux/nx842.h

-- 
2.1.0
