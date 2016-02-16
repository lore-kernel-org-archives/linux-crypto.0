From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH 0/4] Documentation: crypto API documentation updates
Date: Tue, 16 Feb 2016 11:31:26 +0100
Message-ID: <1550901.OUzcZboqul@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:33904 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754860AbcBPKfL (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 16 Feb 2016 05:35:11 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

This patch set updates the kernel crypto API documentation. Due to recent
updates to the API, the documentation needs to be synchronized with the
reality.

The output of the DocBook with these patches is found in [1].

Herbert: The documentation in include/crypto/skcipher.h references
CRYPTO_ALG_TYPE_SKCIPHER which does (not yet?) exist. Shall that reference
stay in the documentation?

[1] https://www.chronox.de/crypto-API/index.html

Stephan Mueller (4):
  Documentation: crypto - add akcipher API
  Documentation: crypto - add crypto_rng_generate
  Documentation: crypto - update AEAD AD handling
  Documentation: crypto - add skcipher API documentation

 Documentation/DocBook/crypto-API.tmpl | 229 +++++++++++++++-------------------
 include/crypto/aead.h                 |   6 +-
 include/crypto/akcipher.h             |  28 ++---
 3 files changed, 115 insertions(+), 148 deletions(-)

-- 
2.5.0
