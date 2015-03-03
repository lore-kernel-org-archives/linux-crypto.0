From: Martin Hicks <mort@bork.org>
Subject: [PATCH v2 0/5] crypto: talitos: Add crypto async queue handling
Date: Tue,  3 Mar 2015 08:21:32 -0500
Message-ID: <1425388897-5434-1-git-send-email-mort@bork.org>
Cc: linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org,
	=?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@freescale.com>,
	Martin Hicks <mort@bork.org>
To: Kim Phillips <kim.phillips@freescale.com>,
	Scott Wood <scottwood@freescale.com>,
	Kumar Gala <galak@kernel.crashing.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ig0-f173.google.com ([209.85.213.173]:45666 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756061AbbCCNVt (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 3 Mar 2015 08:21:49 -0500
Received: by igjz20 with SMTP id z20so27213638igj.4
        for <linux-crypto@vger.kernel.org>; Tue, 03 Mar 2015 05:21:48 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

I was testing dm-crypt performance with a Freescale P1022 board with 
a recent kernel and was getting IO errors while doing testing with LUKS.
Investigation showed that all hardware FIFO slots were filling and
the driver was returning EAGAIN to the block layer, which is not an
expected response for an async crypto implementation.

The following patch series adds a few small fixes, and reworks the
submission path to use the crypto_queue mechanism to handle the
request backlog.

Changes since v1:

- Ran checkpatch.pl
- Split the path for submitting new requests vs. issuing backlogged
  requests.
- Avoid enqueuing a submitted request to the crypto queue unnecessarily.
- Fix return paths where CRYPTO_TFM_REQ_MAY_BACKLOG is not set.


Martin Hicks (5):
  crypto: talitos: Simplify per-channel initialization
  crypto: talitos: Remove MD5_BLOCK_SIZE
  crypto: talitos: Fix off-by-one and use all hardware slots
  crypto: talitos: Reorganize request submission data structures
  crypto: talitos: Add software backlog queue handling

 drivers/crypto/talitos.c |  240 +++++++++++++++++++++++++++-------------------
 drivers/crypto/talitos.h |   44 +++++++--
 2 files changed, 177 insertions(+), 107 deletions(-)

-- 
1.7.10.4
