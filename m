From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH v2 0/2] crypto: algif - change algif_skcipher to be
 asynchronous
Date: Mon, 09 Mar 2015 13:55:14 -0700
Message-ID: <20150309205514.9648.701.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	qat-linux@intel.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:29281 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752337AbbCIU7L (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 9 Mar 2015 16:59:11 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The way the algif_skcipher works currently is that on sendmsg/sendpage it
builds an sgl for the input data and then on read/recvmsg it sends the job
for encryption putting the user to sleep till the data is processed.
This way it can only handle one job at a given time.
To be able to fuly utilize the potential of existing crypto hardware
accelerators it is required to submit multiple jobs in asynchronously.
This series adds support for asynchronous operations for algif_skcipher.
First patch enables af_alg sgl to be linked.
Second patch implement asynch read for skcipher.

Changes in v2:
 - Use kmalloc instead of caches

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
Tadeusz Struk (2):
      crypto: af_alg - Allow to link sgl
      crypto: algif - change algif_skcipher to be asynchronous


 crypto/af_alg.c         |   18 +++-
 crypto/algif_skcipher.c |  233 ++++++++++++++++++++++++++++++++++++++++++++++-
 include/crypto/if_alg.h |    4 +
 3 files changed, 242 insertions(+), 13 deletions(-)
