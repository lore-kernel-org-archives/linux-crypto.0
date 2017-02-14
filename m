From: Eric Biggers <ebiggers@google.com>
Subject: [PATCH 0/4] crypto: gf128mul cleanups
Date: Tue, 14 Feb 2017 13:43:26 -0800
Message-ID: <20170214214330.99845-1-ebiggers@google.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-it0-f44.google.com ([209.85.214.44]:38066 "EHLO
        mail-it0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753237AbdBNVpv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 14 Feb 2017 16:45:51 -0500
Received: by mail-it0-f44.google.com with SMTP id c7so50707149itd.1
        for <linux-crypto@vger.kernel.org>; Tue, 14 Feb 2017 13:45:50 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patchset makes a few cleanups to the generic GF(2^128) multiplication code
to make it slightly easier to understand and modify.  No functional changes are
intended.

Eric Biggers (4):
  crypto: gf128mul - fix some comments
  crypto: gf128mul - remove xx() macro
  crypto: gf128mul - rename the byte overflow tables
  crypto: gf128mul - constify 4k and 64k multiplication tables

 crypto/gf128mul.c         | 86 +++++++++++++++++++++++++++--------------------
 include/crypto/gf128mul.h | 32 +++++++++---------
 2 files changed, 67 insertions(+), 51 deletions(-)

-- 
2.11.0.483.g087da7b7c-goog
