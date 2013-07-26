From: Marcelo Cerri <mhcerri@linux.vnet.ibm.com>
Subject: [PATCH 0/2] drivers/crypto/nx: fixes when input data is too large
Date: Fri, 26 Jul 2013 14:08:06 -0300
Message-ID: <1374858488-24658-1-git-send-email-mhcerri@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Marcelo Cerri <mhcerri@linux.vnet.ibm.com>
To: benh@kernel.crashing.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e24smtp01.br.ibm.com ([32.104.18.85]:33525 "EHLO
	e24smtp01.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757266Ab3GZRIT (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 26 Jul 2013 13:08:19 -0400
Received: from /spool/local
	by e24smtp01.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-crypto@vger.kernel.org> from <mhcerri@linux.vnet.ibm.com>;
	Fri, 26 Jul 2013 14:08:17 -0300
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This series of patches fixes two bugs that are triggered when the input data is
too large. The first one is caused by the miscalculation of physical addresses
and the second one by some limits that the co-processor has to the input data.

Marcelo Cerri (2):
  drivers/crypto/nx: fix physical addresses added to sg lists
  drivers/crypto/nx: fix limits to sg lists for SHA-2

 drivers/crypto/nx/nx-sha256.c | 108 +++++++++++++++++++++++-----------------
 drivers/crypto/nx/nx-sha512.c | 113 ++++++++++++++++++++++++------------------
 drivers/crypto/nx/nx.c        |  22 ++++++--
 3 files changed, 148 insertions(+), 95 deletions(-)

-- 
1.7.12
