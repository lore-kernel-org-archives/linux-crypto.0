From: "Leonidas S. Barbosa" <leosilva@linux.vnet.ibm.com>
Subject: [PATCH 0/9] NX crypto driver fixes
Date: Tue, 28 Oct 2014 15:40:09 -0200
Message-ID: <20141028174006.GA15893@bluepex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: linux-kernel@vger.kernel.org,
	Marcelo Henrique Cerri <mhcerri@linux.vnet.ibm.com>,
	Fionnuala Gunter <fin@linux.vnet.ibm.com>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e24smtp02.br.ibm.com ([32.104.18.86]:57576 "EHLO
	e24smtp02.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855AbaJ1RkR (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 28 Oct 2014 13:40:17 -0400
Received: from /spool/local
	by e24smtp02.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-crypto@vger.kernel.org> from <leosilva@linux.vnet.ibm.com>;
	Tue, 28 Oct 2014 15:40:15 -0200
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch set fixes the follow issues in  NX crypto driver:

  - Bound limit issue that causes a memory crash
  - SHA concurrence issue
  - IV vector fix with the correct bit order
  - NX CCM does not support keys larger than 128 causing
  crashes in fips mode.


Leonidas S. Barbosa (9):
  Moving NX-AES-CBC to be process logic
  Moving NX-AES-CCM to be process logic and sg_list bounds
  Moving limit and bound logic in CTR and fix IV vector
  Moving NX-AES-ECB to be processed logic
  Moving NX-AES-GCM to be processed logic
  Moving NX-AES-XCBC to be processed logic
  Fix SHA concurrence issue and sg limit bounds
  Fixing the limit number of bytes to be processed
  Disable ccm and ccm4309 in fips mod

 drivers/crypto/nx/nx-aes-cbc.c  |   12 +--
 drivers/crypto/nx/nx-aes-ccm.c  |   61 +++++------
 drivers/crypto/nx/nx-aes-ctr.c  |   13 +--
 drivers/crypto/nx/nx-aes-ecb.c  |   12 +--
 drivers/crypto/nx/nx-aes-gcm.c  |   66 +++++++-----
 drivers/crypto/nx/nx-aes-xcbc.c |   81 +++++++++++---
 drivers/crypto/nx/nx-sha256.c   |  208 ++++++++++++++++++-------------------
 drivers/crypto/nx/nx-sha512.c   |  222 ++++++++++++++++++---------------------
 drivers/crypto/nx/nx.c          |  159 +++++++++++++++++++++++-----
 drivers/crypto/nx/nx.h          |    8 +-
 10 files changed, 469 insertions(+), 373 deletions(-)
