From: Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: [RFC PATCH 0/4] crypto: (ec)dh - add privkey generation support
Date: Wed, 17 May 2017 13:38:32 +0300
Message-ID: <1495017516-10048-1-git-send-email-tudor.ambarus@microchip.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, <smueller@chronox.de>,
        <marcel@holtmann.org>, <Nicolas.Ferre@microchip.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>
To: <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:35757 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751782AbdEQKiv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 17 May 2017 06:38:51 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

This is an RFC to discuss how to support private key generation for dh and
ecdh.

This is helpful in a user-space to kernel (ec)dh offload because the keys
are generated in kernel and never revealed to user-space.

Private key generation is also helpful to implement forward secrecy.
A public/private key system demonstrates the property of forward secrecy
if it creates new key pairs for each communication session. These
key pairs are generated on an as-needed basis and are destroyed after
the session is over. If an attacker were to record previous encrypted
session data, they wouldn't be able to decrypt it with possession of a
long-term key.

There are crypto accelerators that are capable of generating and retaining
private keys without revealing them to software. This patch set is a
prerequisite for hardware private key generation support.

Tudor Ambarus (4):
  crypto: ecc - add privkey generation support
  crypto: ecdh - allow user to provide NULL privkey
  crypto: dh - allow user to provide NULL privkey
  crypto: testmgr - add genkey kpp test

 crypto/dh.c      |  18 +++++++
 crypto/ecc.c     |  20 +++++++
 crypto/ecc.h     |  14 +++++
 crypto/ecdh.c    |   4 ++
 crypto/testmgr.c |  77 +++++++++++++++++++++++----
 crypto/testmgr.h | 155 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 277 insertions(+), 11 deletions(-)

-- 
2.7.4
