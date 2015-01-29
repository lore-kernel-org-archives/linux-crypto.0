From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH 0/3] crypto: algif - change algif_skcipher to be asynchronous
Date: Thu, 29 Jan 2015 15:13:39 -0800
Message-ID: <20150129231338.25156.65450.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
	davem@davemloft.net, qat-linux@intel.com,
	linux-kernel@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:5278 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751265AbbA2XRO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 29 Jan 2015 18:17:14 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The way the algif_skcipher works currently is that on sendmsg/sendpage it
builds an sgl for the input data and then on read/recvmsg it sends the job
for encryption putting the user to sleep till the data is processed.
This way it can only handle one job at a given time.
To be able to fuly utilize the potential of existing crypto hardware
accelerators it is required to submit multiple jobs in asynchronously.
First patch enables asynchronous read and write on socket.
Second patch enables af_alg sgl to be linked.
Third patch implement asynch read for skcipher.

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
Tadeusz Struk (3):
      net: socket: enable async read and write
      crypto: af_alg - Allow to link sgl
      crypto: algif - change algif_skcipher to be asynchronous


 crypto/af_alg.c         |   16 ++
 crypto/algif_skcipher.c |  315 ++++++++++++++++++++++++++++++++++++++++++++++-
 include/crypto/if_alg.h |    4 -
 include/net/sock.h      |    2 
 net/socket.c            |   48 ++++++-
 5 files changed, 364 insertions(+), 21 deletions(-)
