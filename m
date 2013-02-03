From: Mathias Krause <minipli@googlemail.com>
Subject: [PATCH 0/2] crypto user API fixes
Date: Sun,  3 Feb 2013 12:08:59 +0100
Message-ID: <1359889741-23335-1-git-send-email-minipli@googlemail.com>
Cc: Steffen Klassert <steffen.klassert@secunet.com>,
	linux-crypto@vger.kernel.org,
	Mathias Krause <minipli@googlemail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:56229 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108Ab3BCLJL (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 3 Feb 2013 06:09:11 -0500
Received: by mail-wi0-f179.google.com with SMTP id ez12so1994373wid.12
        for <linux-crypto@vger.kernel.org>; Sun, 03 Feb 2013 03:09:10 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This series fixes kernel memory disclosures (aka info leaks) and a bug
in the empty string test.

The crypto user API is protected by CAP_NET_ADMIN so one needs some
level of privilege already to exploit the leaks. It still might be
material for stable, though. Your choice.

Please apply!


Mathias Krause (2):
  crypto: user - fix info leaks in report API
  crypto: user - fix empty string test in report API

 crypto/ablkcipher.c  |   12 ++++++------
 crypto/aead.c        |    9 ++++-----
 crypto/ahash.c       |    2 +-
 crypto/blkcipher.c   |    6 +++---
 crypto/crypto_user.c |   24 ++++++++++++------------
 crypto/pcompress.c   |    3 +--
 crypto/rng.c         |    2 +-
 crypto/shash.c       |    3 ++-
 8 files changed, 30 insertions(+), 31 deletions(-)

-- 
1.7.10.4
