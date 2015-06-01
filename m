From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH v1 0/2] scatterlist: introduce sg_nents_for_len
Date: Mon, 1 Jun 2015 11:15:19 -0500
Message-ID: <20150601161519.729.75909.stgit@tlendack-t1.amdoffice.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: David Miller <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2on0104.outbound.protection.outlook.com ([207.46.100.104]:31425
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751340AbbFAQPY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 1 Jun 2015 12:15:24 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This series introduces and makes use of a new scatterlist function named
sg_nents_for_len. The purpose of this function is determine the number
of scatterlist entries required to satisify a specified length. The
resulting count can be used as input to the dma_map_sg function to map
only the entries needed.

This function is needed for cases where a supplied scatterlist has not
marked the last filled sg entry as the end of the scatterlist. In these
cases, the sg_nents function count includes sg entries that may not have
been filled in. When using this value in a dma_map_sg call it can result
in errors/bugs being generated.

The following patches are included in this series:
- Introduce the sg_nents_for_len function
- Update the ccp driver to use the sg_nents_for_len function

This patch series is based on cryptodev-2.6.

---

Tom Lendacky (2):
      scatterlist: introduce sg_nents_for_len
      crypto: ccp - Protect against poorly marked end of sg list


 drivers/crypto/ccp/ccp-ops.c |    7 +++++--
 include/linux/scatterlist.h  |    1 +
 lib/scatterlist.c            |   32 ++++++++++++++++++++++++++++++++
 3 files changed, 38 insertions(+), 2 deletions(-)

-- 
Tom Lendacky
