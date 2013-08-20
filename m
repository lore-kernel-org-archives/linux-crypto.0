From: Lokesh Vutla <lokeshvutla@ti.com>
Subject: [PATCH 0/2] crypto: omap-sham: Misc updates for driver
Date: Tue, 20 Aug 2013 20:32:33 +0530
Message-ID: <1377010955-5605-1-git-send-email-lokeshvutla@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, <linux-omap@vger.kernel.org>,
	<rnayak@ti.com>, <nsekhar@ti.com>, <lokeshvutla@ti.com>
To: <herbert@gondor.hengli.com.au>
Return-path: <linux-omap-owner@vger.kernel.org>
Sender: linux-omap-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This patch series updates the following for the driver:
-> Enable polling mode if DMA fails.
-> Correct the DMA burst size.

Lokesh Vutla (2):
  crypto: omap-sham: Enable Polling mode if DMA fails
  crypto: omap-sham: correct dma burst size

 drivers/crypto/omap-sham.c |   72 ++++++++++++++++++++++++++++----------------
 1 file changed, 46 insertions(+), 26 deletions(-)

-- 
1.7.9.5

