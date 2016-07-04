From: Salvatore Benedetto <salvatore.benedetto@intel.com>
Subject: [PATCH 0/3] Add RSA CRT mode to qat driver
Date: Mon,  4 Jul 2016 17:21:37 +0100
Message-ID: <1467649300-8951-1-git-send-email-salvatore.benedetto@intel.com>
Cc: salvatore.benedetto@intel.com, linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:5564 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750713AbcGDQVs (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 4 Jul 2016 12:21:48 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

this patchset add CRT mode to qat driver.
First patch extend the parsing of the private key so that all required CRT
fields are saved. Second patch add a 4K test key. Third patch extend qat
to use CRT. This latest patch is based on my patch that drop asn1 from qat
driver.

Salvatore Benedetto (3):
  crypto: rsa - Store rest of the private key components
  crypto: testmgr - Add 4K private key to RSA testvector
  crypto: qat - Add RSA CRT mode

 crypto/rsa_helper.c                           |  75 +++++++++
 crypto/rsaprivkey.asn1                        |  10 +-
 crypto/testmgr.h                              | 200 +++++++++++++++++++++-
 drivers/crypto/qat/qat_common/qat_asym_algs.c | 234 +++++++++++++++++++++++---
 include/crypto/internal/rsa.h                 |  20 +++
 5 files changed, 508 insertions(+), 31 deletions(-)

-- 
2.7.4
