From: Antoine Tenart <antoine.tenart@bootlin.com>
Subject: [PATCH 0/8] crypto: inside-secure - stabilization and fixes
Date: Tue, 13 Feb 2018 09:26:49 +0100
Message-ID: <20180213082657.4759-1-antoine.tenart@bootlin.com>
Cc: Antoine Tenart <antoine.tenart@bootlin.com>,
        thomas.petazzoni@bootlin.com, gregory.clement@bootlin.com,
        miquel.raynal@bootlin.com, oferh@marvell.com, igall@marvell.com,
        nadavh@marvell.com, linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:44261 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933663AbeBMIaN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 13 Feb 2018 03:30:13 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

We spent a lot of time with Ofer to test various use cases of the Inside
Secure driver. We performed many tests in addition to the crypto
subsystem ones (IPsec, openssl speed, tcrypt...). As a result the driver
is a lot more stable in various configurations, with this series
applied.

The fixes of this series aren't all related, but were all found while
performing these stabilization process and tests.

Also as the company I'm working at changed its name from Free Electrons
to Bootlin, the first patch updates my email address in the MAINTAINERS
file.

The series is based on v4.16-rc1.

Thanks!
Antoine

Antoine Tenart (8):
  MAINTAINERS: update the Inside Secure maintainer email
  crypto: inside-secure - do not overwrite the threshold value
  crypto: inside-secure - fix the extra cache computation
  crypto: inside-secure - fix the cache_len computation
  crypto: inside-secure - do not process request if no command was
    issued
  crypto: inside-secure - fix the invalidation step during cra_exit
  crypto: inside-secure - keep the requests push/pop synced
  crypto: inside-secure - unmap the result in the hash send error path

 MAINTAINERS                                    |  2 +-
 drivers/crypto/inside-secure/safexcel.c        | 40 +++++++++++++++-----------
 drivers/crypto/inside-secure/safexcel.h        |  6 ++--
 drivers/crypto/inside-secure/safexcel_cipher.c |  2 +-
 drivers/crypto/inside-secure/safexcel_hash.c   | 10 ++++---
 5 files changed, 33 insertions(+), 27 deletions(-)

-- 
2.14.3
