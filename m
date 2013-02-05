From: Mathias Krause <minipli@googlemail.com>
Subject: [PATCHv2 0/3] crypto user API fixes
Date: Tue,  5 Feb 2013 18:19:12 +0100
Message-ID: <1360084755-11044-1-git-send-email-minipli@googlemail.com>
Cc: Steffen Klassert <steffen.klassert@secunet.com>,
	linux-crypto@vger.kernel.org,
	Mathias Krause <minipli@googlemail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bk0-f53.google.com ([209.85.214.53]:39299 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754355Ab3BERTc (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 5 Feb 2013 12:19:32 -0500
Received: by mail-bk0-f53.google.com with SMTP id j10so201998bkw.26
        for <linux-crypto@vger.kernel.org>; Tue, 05 Feb 2013 09:19:31 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This series fixes kernel memory disclosures (aka info leaks) and a bug
in the empty string test. In addition to the first version of this
series it also ensures all user supplied strings are nul-terminated
before using them.

Patch 1 is the same as in the first series, patch 2 was changed as
suggested by Herbert, patch 3 is new.

Please apply!


Mathias Krause (3):
  crypto: user - fix info leaks in report API
  crypto: user - fix empty string test in report API
  crypto: user - ensure user supplied strings are nul-terminated

 crypto/ablkcipher.c  |   12 ++++++------
 crypto/aead.c        |    9 ++++-----
 crypto/ahash.c       |    2 +-
 crypto/blkcipher.c   |    6 +++---
 crypto/crypto_user.c |   38 ++++++++++++++++++++++++++------------
 crypto/pcompress.c   |    3 +--
 crypto/rng.c         |    2 +-
 crypto/shash.c       |    3 ++-
 8 files changed, 44 insertions(+), 31 deletions(-)

-- 
1.7.10.4
