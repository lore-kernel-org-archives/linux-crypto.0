From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH v4 0/3] SP800-38F / RFC3394 key wrapping
Date: Thu, 15 Oct 2015 09:05:48 +0200
Message-ID: <5314960.0aGFzHXOSP@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: boris.brezillon@free-electrons.com, linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34343 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754183AbbJOHH7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 15 Oct 2015 03:07:59 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

Changes v4:
* make patch 3/3 standalone by incorporating and updating patch
https://lkml.org/lkml/2015/6/16/342

Changes v3:
* split patch for easier review
* add support for full SGL handling in decrypt by adding a "fast-forward"
function
* significant simplification of code and removal of one memcpy per round
* use of scatterwalk API throughout code and removal of self-written code
* perform a full CAVS test with all AES implementations available on X86
  (C, assembler and AES-NI)

Changes v2:
* Turn kw() into a blkcipher as suggested by Herbert Xu.
* Drop the support for user provided IV to initialize encrypt or
  for performing the verify step during decrypt.

Stephan Mueller (3):
  crypto: add key wrapping block chaining mode
  crypto: keywrap - enable compilation
  crypto: keywrap - add testmgr support

 crypto/Kconfig   |   7 +
 crypto/Makefile  |   1 +
 crypto/keywrap.c | 419 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 crypto/testmgr.c |  28 +++-
 crypto/testmgr.h |  41 ++++++
 5 files changed, 495 insertions(+), 1 deletion(-)
 create mode 100644 crypto/keywrap.c

-- 
2.5.0
