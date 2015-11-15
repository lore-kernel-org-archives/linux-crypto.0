From: David Gstir <david@sigma-star.at>
Subject: [PATCH 0/2] Timing leaks in certain HW-crypto drivers
Date: Sun, 15 Nov 2015 17:14:40 +0100
Message-ID: <1447604082-1883-1-git-send-email-david@sigma-star.at>
Cc: herbert@gondor.apana.org.au, David Gstir <david@sigma-star.at>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.sigma-star.at ([95.130.255.111]:45996 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528AbbKOQQt (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 15 Nov 2015 11:16:49 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

[resend to linux-crypto]

Hi,

the following patches fix timing leaks which are introduced by using
(non-constant time) memcmp() to verify cryptograhic authentication tags.
Specifically, the AES-GCM and AES-CCM implementations in the IBM Power
in-Nest Crypto acceleration driver and the AEAD decryption function in the
Freescale SEC (talitos) driver are vulnerable to this kind of attack.
These timing leaks can be used by an attacker to find the correct
authentication tag value for arbitrary messages with far less effort
than brute-force testing all 2^n possible values for a n-bit tag.

The fix is rather simple: Use crypto_memneq() as the generic implementations
in crypto/* already do.

Kind regards,
David


David Gstir (2):
  crypto: nx - Fix timing leak in GCM and CCM decryption
  crypto: talitos - Fix timing leak in ESP ICV verification

 drivers/crypto/nx/nx-aes-ccm.c | 2 +-
 drivers/crypto/nx/nx-aes-gcm.c | 3 ++-
 drivers/crypto/talitos.c       | 2 +-
 3 files changed, 4 insertions(+), 3 deletions(-)

-- 
2.1.4
