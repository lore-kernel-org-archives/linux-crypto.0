From: Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>
Subject: [PATCH 0/8] NX crypto driver reestructure
Date: Thu, 24 Jul 2014 10:44:18 -0300
Message-ID: <20140724134414.GA22921@bluepex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: mhcerri@linux.vnet.ibm.com, fin@linux.vnet.ibm.com
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e24smtp04.br.ibm.com ([32.104.18.25]:50602 "EHLO
	e24smtp04.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758833AbaGXNoY (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 24 Jul 2014 09:44:24 -0400
Received: from /spool/local
	by e24smtp04.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-crypto@vger.kernel.org> from <leosilva@linux.vnet.ibm.com>;
	Thu, 24 Jul 2014 10:44:23 -0300
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


This set of patches deals with the reescruture of NX driver replacing the
use of spinlocks, that assure crypto context concurrency, by a copy of crypto 
ctx to another region of memory in order to be used by the current algorithm.
As this region of memory tends to be used constantly also was added a kmemcache
chunk avoiding the cost of constant allocations.


Leonidas Da Silva Barbosa (8):
  Adding nx_copy_ctx and kmemcache to handle with crypto context
  Replacing spinlocks by nx_copy_ctx on NX-AES-CBC
  Replacing spinlocks by nx_copy_ctx on NX-AES-CCM
  Replacing spinlocks by nx_copy_ctx on NX-AES-CTR
  Replacing spinlocks by nx_copy_ctx on NX-AES-ECB
  Replacing spinlocks by nx_copy_ctx on NX-AES-GCM
  Replacing spinlocks by nx_copy_ctx on NX-AES-XCBC
  Replacing spinlocks by nx_copy_ctx on NX-SHA256 and NX-SHA512

 drivers/crypto/nx/nx-aes-cbc.c  |   20 +++++++----
 drivers/crypto/nx/nx-aes-ccm.c  |   42 ++++++++++++++---------
 drivers/crypto/nx/nx-aes-ctr.c  |   20 +++++++----
 drivers/crypto/nx/nx-aes-ecb.c  |   20 +++++++----
 drivers/crypto/nx/nx-aes-gcm.c  |   64 +++++++++++++++++++----------------
 drivers/crypto/nx/nx-aes-xcbc.c |   51 ++++++++++++++++------------
 drivers/crypto/nx/nx-sha256.c   |   70 ++++++++++++++++++++++++---------------
 drivers/crypto/nx/nx-sha512.c   |   70 ++++++++++++++++++++++++---------------
 drivers/crypto/nx/nx.c          |   45 ++++++++++++++++++++++++-
 drivers/crypto/nx/nx.h          |    8 +++--
 10 files changed, 259 insertions(+), 151 deletions(-)
