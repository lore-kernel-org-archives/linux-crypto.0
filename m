From: Antoine Tenart <antoine.tenart@free-electrons.com>
Subject: [PATCH 00/17] crypto: inside-secure - various improvements
Date: Thu, 14 Dec 2017 15:26:42 +0100
Message-ID: <20171214142659.16987-1-antoine.tenart@free-electrons.com>
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        thomas.petazzoni@free-electrons.com,
        gregory.clement@free-electrons.com,
        miquel.raynal@free-electrons.com, oferh@marvell.com,
        igall@marvell.com, nadavh@marvell.com, linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:36764 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753130AbdLNOaE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 14 Dec 2017 09:30:04 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

This series depends on the previous one, "crypto: inside-secure - set of
fixes"[1]. The series contains various improvements to the Inside Secure
SafeXcel driver, which are bundled in a single series to avoid any
conflict.

- Patches 1-4 are cosmetic fixes (typo, more comments and dead code removal).
- Patches 5-8 are small improvements, mostly to improve the invalidation
  path.
- Patches 9-15 improve the request processing in the driver, by moving
  the requests dequeing into a workqueue and the result handling into a
  threaded IRQ thread. Other small improvements are made in the same
  direction.
- Patches 16-17 introduce the support of another revision of this crypto
  engine, similar to the one already supported. This crypto engine can be
  found on Marvell boards. (The corresponding device tree patches will follow
  once this series lands in).

Thanks!
Antoine

[1] https://www.spinics.net/lists/linux-crypto/msg30313.html

Antoine Tenart (13):
  crypto: inside-secure - remove extra empty line
  crypto: inside-secure - fix typo in a comment
  crypto: inside-secure - remove useless memset
  crypto: inside-secure - comment the caching function
  crypto: inside-secure - move request dequeueing into a workqueue
  crypto: inside-secure - use threaded IRQs for result handling
  crypto: inside-secure - dequeue all requests at once
  crypto: inside-secure - increase the ring size
  crypto: inside-secure - acknowledge the result requests all at once
  crypto: inside-secure - handle more result requests when counter is
    full
  crypto: inside-secure - retry to proceed the request later on fail
  crypto: inside-secure - EIP97 support
  Documentation/bindings: crypto: document the SafeXcel EIP97 compatible

Ofer Heifetz (4):
  crypto: inside-secure - refrain from unneeded invalidations
  crypto: inside-secure - EBUSY is not an error on async request
  crypto: inside-secure - move cipher crypto mode to request context
  crypto: inside-secure - remove unused parameter in invalidate_cache

 .../bindings/crypto/inside-secure-safexcel.txt     |   3 +-
 drivers/crypto/inside-secure/safexcel.c            | 370 ++++++++++++++-------
 drivers/crypto/inside-secure/safexcel.h            | 173 +++++++---
 drivers/crypto/inside-secure/safexcel_cipher.c     |  53 +--
 drivers/crypto/inside-secure/safexcel_hash.c       |  69 ++--
 5 files changed, 449 insertions(+), 219 deletions(-)

-- 
2.14.3
