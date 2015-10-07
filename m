From: Lee Jones <lee.jones@linaro.org>
Subject: [PATCH v2 0/3] hwrng: st: Couple of improvements
Date: Wed,  7 Oct 2015 13:23:26 +0100
Message-ID: <1444220609-31251-1-git-send-email-lee.jones@linaro.org>
Cc: kernel@stlinux.com, herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org, pankaj.dev@st.com,
	daniel.thompson@linaro.org, linux@arm.linux.org.uk,
	Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:37494 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340AbbJGMZe (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 7 Oct 2015 08:25:34 -0400
Received: by wicfx3 with SMTP id fx3so25719517wic.0
        for <linux-crypto@vger.kernel.org>; Wed, 07 Oct 2015 05:25:32 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This set contains a minor documentation fix, greater clarification
with how the FIFO depth/size is represented and finally a fix to
prevent early timeout during data acquisition.

v1 => v2:
 - Remove phantom bugfix (FIFO really is 4 deep, not 8)
 - Double timeout value to account for inconsistent call to udelay()
   - Suggested-by: Russell King <rmk+kernel@arm.linux.org.uk>

Lee Jones (3):
  hwrng: st: dt: Fix trivial typo in node address
  hwrng: st: Use real-world device timings for timeout
  hwrng: st: Improve FIFO size/depth description

 Documentation/devicetree/bindings/rng/st,rng.txt |  2 +-
 drivers/char/hw_random/st-rng.c                  | 13 ++++++++++---
 2 files changed, 11 insertions(+), 4 deletions(-)

-- 
1.9.1
