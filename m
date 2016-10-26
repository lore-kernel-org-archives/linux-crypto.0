From: Marcelo Cerri <marcelo.cerri@canonical.com>
Subject: [PATCH 0/3] crypto: testmgr - Add missing tests for internal sha*-mb implementations
Date: Wed, 26 Oct 2016 15:04:42 -0200
Message-ID: <1477501485-18371-1-git-send-email-marcelo.cerri@canonical.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org,
        Stephan Mueller <smueller@chronox.de>,
        Marcelo Cerri <marcelo.cerri@canonical.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-vk0-f43.google.com ([209.85.213.43]:34030 "EHLO
        mail-vk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753399AbcJZRFP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 26 Oct 2016 13:05:15 -0400
Received: by mail-vk0-f43.google.com with SMTP id p81so7305570vkd.1
        for <linux-crypto@vger.kernel.org>; Wed, 26 Oct 2016 10:05:15 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This series adds null tests for all sha*-mb internal algorithms so they can
be used in FIPS mode without further problems.

Since they are 3 separated modules I decided to use a separated commit for
each one.

Marcelo Cerri (3):
  crypto: testmgr - Add missing tests for internal sha1-mb
    implementation
  crypto: testmgr - Add missing tests for internal sha256-mb
    implementation
  crypto: testmgr - Add missing tests for internal sha512-mb
    implementation

 crypto/testmgr.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

-- 
2.7.4
