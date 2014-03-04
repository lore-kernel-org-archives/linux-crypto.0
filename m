From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC PATCH 0/3] take 2: repurposing blkcipher walk api for aead
Date: Tue,  4 Mar 2014 13:28:37 +0800
Message-ID: <1393910920-5796-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pb0-f44.google.com ([209.85.160.44]:49588 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185AbaCDF2z (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 4 Mar 2014 00:28:55 -0500
Received: by mail-pb0-f44.google.com with SMTP id rp16so4724328pbb.17
        for <linux-crypto@vger.kernel.org>; Mon, 03 Mar 2014 21:28:54 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

I think this is a better approach than the one I proposed before. This time,
I have only added a single function specifically for use by aeads:

blkcipher_aead_walk_virt_block()

which takes an additional aead param which is used to get the ivsize, alignmask
and blocksize of the underlying transform.

Ard Biesheuvel (3):
  crypto: remove direct blkcipher_walk dependency on transform
  crypto: allow blkcipher walks over AEAD data
  arm64: add support for AES in CCM mode using Crypto Extensions

 arch/arm64/Makefile                |   1 +
 arch/arm64/crypto/Makefile         |  12 ++
 arch/arm64/crypto/aesce-ccm-core.S | 222 +++++++++++++++++++++++++++
 arch/arm64/crypto/aesce-ccm-glue.c | 297 +++++++++++++++++++++++++++++++++++++
 crypto/blkcipher.c                 |  81 +++++-----
 include/crypto/algapi.h            |   9 +-
 6 files changed, 587 insertions(+), 35 deletions(-)
 create mode 100644 arch/arm64/crypto/Makefile
 create mode 100644 arch/arm64/crypto/aesce-ccm-core.S
 create mode 100644 arch/arm64/crypto/aesce-ccm-glue.c

-- 
1.8.3.2
