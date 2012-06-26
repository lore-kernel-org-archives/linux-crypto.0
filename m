From: Simon Baatz <gmbnomis@gmail.com>
Subject: [PATCH 0/1] MV_CESA with DMA: Clk init fixes
Date: Tue, 26 Jun 2012 22:31:51 +0200
Message-ID: <1340742712-5821-1-git-send-email-gmbnomis@gmail.com>
References: <20120618134718.GL9122@philter.vipri.net>
Cc: linux-crypto@vger.kernel.org, cloudy.linux@gmail.com
To: phil.sutter@viprinet.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:58204 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565Ab2FZUcF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 26 Jun 2012 16:32:05 -0400
Received: by weyu7 with SMTP id u7so230193wey.19
        for <linux-crypto@vger.kernel.org>; Tue, 26 Jun 2012 13:32:03 -0700 (PDT)
In-Reply-To: <20120618134718.GL9122@philter.vipri.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Phil,

I just found the time to test your updates. Alas, the mv_dma module
hangs at boot again.  The culprit seems to be setup_mbus_windows(),
which is called before the clock is turned on but accesses the DMA
engine.

I shifted the clock init code a bit and while doing so, fixed some error
case handling for mv_dma and mv_cesa.  See proposed patch in next mail.
   
- Simon

Simon Baatz (1):
  mv_dma: mv_cesa: fixes for clock init

 drivers/crypto/mv_cesa.c |    7 ++++++-
 drivers/crypto/mv_dma.c  |   44 +++++++++++++++++++++++++++++---------------
 2 files changed, 35 insertions(+), 16 deletions(-)

-- 
1.7.9.5
