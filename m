From: Martin Hicks <mort@bork.org>
Subject: [PATCH 0/2] crypto: talitos: Add AES-XTS mode
Date: Fri, 20 Feb 2015 12:00:08 -0500
Message-ID: <1424451610-5786-1-git-send-email-mort@bork.org>
Cc: linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org,
	Martin Hicks <mort@bork.org>
To: Kim Phillips <kim.phillips@freescale.com>,
	Scott Wood <scottwood@freescale.com>,
	Kumar Gala <galak@kernel.crashing.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ig0-f180.google.com ([209.85.213.180]:51437 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753921AbbBTRAR (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 20 Feb 2015 12:00:17 -0500
Received: by mail-ig0-f180.google.com with SMTP id b16so4544001igk.1
        for <linux-crypto@vger.kernel.org>; Fri, 20 Feb 2015 09:00:16 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This adds the AES-XTS mode, supported by the Freescale SEC 3.3.2.

One of the nice things about this hardware is that it knows how to deal
with encrypt/decrypt requests that are larger than sector size, but that 
also requires that that the sector size be passed into the crypto engine
as an XTS cipher context parameter.

When a request is larger than the sector size the sector number is
incremented by the talitos engine and the tweak key is re-calculated
for the new sector.

I've tested this with 256bit and 512bit keys (tweak and data keys of 128bit
and 256bit) to ensure interoperability with the software AES-XTS
implementation.  All testing was done using dm-crypt/LUKS with
aes-xts-plain64.

Is there a better solution that just hard coding the sector size to
(1<<SECTOR_SHIFT)?  Maybe dm-crypt should be modified to pass the
sector size along with the plain/plain64 IV to an XTS algorithm?

Martin Hicks (2):
  crypto: talitos: Clean ups and comment fixes for ablkcipher commands
  crypto: talitos: Add AES-XTS Support

 drivers/crypto/talitos.c |   45 +++++++++++++++++++++++++++++++++++++--------
 drivers/crypto/talitos.h |    1 +
 2 files changed, 38 insertions(+), 8 deletions(-)

-- 
1.7.10.4
