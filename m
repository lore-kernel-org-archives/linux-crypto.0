From: Mathias Krause <minipli@googlemail.com>
Subject: [PATCH 0/2] pcrypt/padata rcu fixes
Date: Thu, 28 Nov 2013 19:20:03 +0100
Message-ID: <1385662805-16919-1-git-send-email-minipli@googlemail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	Mathias Krause <minipli@googlemail.com>
To: Steffen Klassert <steffen.klassert@secunet.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bk0-f52.google.com ([209.85.214.52]:56114 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754031Ab3K1SUS (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 28 Nov 2013 13:20:18 -0500
Received: by mail-bk0-f52.google.com with SMTP id u14so3892560bkz.25
        for <linux-crypto@vger.kernel.org>; Thu, 28 Nov 2013 10:20:17 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Two small RCU related fixes, lockdep complained about.

Please apply!


Mathias Krause (2):
  crypto: pcrypt - Fix wrong usage of rcu_dereference()
  padata: Fix wrong usage of rcu_dereference()

 crypto/pcrypt.c |    2 +-
 kernel/padata.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

-- 
1.7.10.4
