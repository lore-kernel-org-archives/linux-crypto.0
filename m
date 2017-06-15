From: Antoine Tenart <antoine.tenart@free-electrons.com>
Subject: [PATCH 00/13] crypto: inside-secure - various improvements
Date: Thu, 15 Jun 2017 09:56:16 +0200
Message-ID: <20170615075629.30907-1-antoine.tenart@free-electrons.com>
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        thomas.petazzoni@free-electrons.com,
        gregory.clement@free-electrons.com, oferh@marvell.com,
        igall@marvell.com, nadavh@marvell.com, linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:53408 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752123AbdFOIAH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Jun 2017 04:00:07 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

This series improves the newly added inside-secure driver in various
ways. There are also a few non-critical fixes.

The series is based on top of your cryptodev/master branch, as it
depends on the inside-secure driver addition ("crypto: inside-secure -
add SafeXcel EIP197 crypto engine driver").

I'd like to thank Ofer Heifetz and Igal Liberman who helped making
these changes!

Thanks,
Antoine

Antoine Tenart (10):
  crypto: inside-secure - use hmac ipad/opad constants
  crypto: inside-secure - fix the ring wr_cache offset
  crypto: inside-secure - fix incorrect DSE data cache setting
  crypto: inside-secure - update the context and request later
  crypto: inside-secure - use one queue per hw ring
  crypto: inside-secure - stop requeueing failed requests
  crypto: inside-secure - get the backlog before dequeueing the request
  crypto: inside-secure - only dequeue when needed
  crypto: inside-secure - increase the batch size
  crypto: inside-secure - use the base_end pointer in ring rollback

Igal Liberman (2):
  crypto: inside-secure - enable single WR in DSE configuration
  crypto: inside-secure - optimize DSE bufferability control

Ofer Heifetz (1):
  crypto: inside-secure - align the cipher and hash send functions

 drivers/crypto/inside-secure/safexcel.c        | 104 ++++++++++++-------------
 drivers/crypto/inside-secure/safexcel.h        |  18 +++--
 drivers/crypto/inside-secure/safexcel_cipher.c |  47 ++++++-----
 drivers/crypto/inside-secure/safexcel_hash.c   |  51 ++++++------
 drivers/crypto/inside-secure/safexcel_ring.c   |   2 +-
 5 files changed, 116 insertions(+), 106 deletions(-)

-- 
2.9.4
