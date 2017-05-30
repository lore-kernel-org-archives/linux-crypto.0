From: Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: [PATCH v3 0/2] crypto: ecdh - add privkey generation support
Date: Tue, 30 May 2017 17:52:47 +0300
Message-ID: <1496155969-13765-1-git-send-email-tudor.ambarus@microchip.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, <smueller@chronox.de>,
        <marcel@holtmann.org>, <Nicolas.Ferre@microchip.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:62090 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751214AbdE3O4G (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 May 2017 10:56:06 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

This patch set adds support for generating ecc private keys.
ecc private keys are generated using the method of extra random bits,
equivalent to that described in FIPS 186-4, Appendix B.4.1.

Generation of ecc private keys is helpful in a user-space to kernel
ecdh offload because the keys are not revealed to user-space.

Private key generation is also helpful to implement forward secrecy.
A public/private key system demonstrates the property of forward secrecy
if it creates new key pairs for each communication session. These key pairs
are generated on an as-needed basis and are destroyed after the session
is over. If an attacker were to record previous encrypted session data,
they wouldn't be able to decrypt it with possession of a long-term key.

There are crypto accelerators that are capable of generating and retaining
ecdh private keys without revealing them to software. This patch set is a
prerequisite for hardware ecdh with private key generation support.

Changes in v3:
 - make ecc priv key generation compliant with FIPS 186-4.
 - drop dh privkey generation. The implementation was broken because
   was generating private keys based on the length of p, instead of q.
   As of know the dh implementation does not provide a pointer to q,
   so just drop the dh pursue.
 - correct the length in memcpy in testmgr.
 - rebase on top of "[PATCH v4 00/14] fixes for kpp and akcipher"

v2 can be found at:
http://www.mail-archive.com/linux-crypto@vger.kernel.org/msg25193.html

Tudor Ambarus (2):
  crypto: ecdh - add privkey generation support
  crypto: testmgr - add genkey kpp test

 crypto/Kconfig   |  1 +
 crypto/Makefile  |  9 ++++---
 crypto/ecc.c     | 56 +++++++++++++++++++++++++++++++++++++++++
 crypto/ecc.h     | 14 +++++++++++
 crypto/ecdh.c    |  4 +++
 crypto/testmgr.c | 76 ++++++++++++++++++++++++++++++++++++++++++++++++--------
 crypto/testmgr.h | 47 +++++++++++++++++++++++++++++++++++
 7 files changed, 192 insertions(+), 15 deletions(-)

-- 
2.7.4
