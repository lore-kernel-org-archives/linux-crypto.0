From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH v1 0/4] TPM2: select hash algorithm for a trusted key
Date: Thu, 29 Oct 2015 17:59:24 +0200
Message-ID: <1446134370-11460-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org, keyrings@vger.kernel.org,
	chris.j.arges@canonical.com, seth.forshee@canonical.com,
	colin.king@canonical.com, josh@joshtriplett.org,
	Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
	Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
	linux-api@vger.kernel.org (open list:ABI/API),
	linux-crypto@vger.kernel.org (open list:CRYPTO API),
	linux-doc@vger.kernel.org (open list:DOCUMENTATION)
To: Peter Huewe <peterhuewe@gmx.de>,
	Marcel Selhorst <tpmdd@selhorst.net>,
	Mimi Zohar <zohar@linux.vnet.ibm.com>,
	David Howells <dhowells@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:60346 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757294AbbJ2QAY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 29 Oct 2015 12:00:24 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Jarkko Sakkinen (4):
  crypto: add entry for sm3-256
  tpm: choose hash algorithm for sealing when using TPM 2.0
  keys, trusted: select the hash algorithm
  keys, trusted: update documentation for 'hash=' option

 Documentation/security/keys-trusted-encrypted.txt |  3 ++
 crypto/hash_info.c                                |  2 ++
 drivers/char/tpm/tpm.h                            | 10 ++++--
 drivers/char/tpm/tpm2-cmd.c                       | 42 +++++++++++++++++++++--
 include/crypto/hash_info.h                        |  3 ++
 include/keys/trusted-type.h                       |  1 +
 include/uapi/linux/hash_info.h                    |  1 +
 security/keys/trusted.c                           | 20 ++++++++++-
 8 files changed, 75 insertions(+), 7 deletions(-)

-- 
2.5.0
