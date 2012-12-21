From: "Mark A. Greer" <mgreer@animalcreek.com>
Subject: [PATCH 00/10] crypto: omap-aes - Updates & New Functionality
Date: Fri, 21 Dec 2012 10:04:50 -0700
Message-ID: <1356109500-11719-1-git-send-email-mgreer@animalcreek.com>
Cc: linux-crypto@vger.kernel.org, linux-omap@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	"Mark A. Greer" <mgreer@animalcreek.com>
To: davem@davemloft.net, herbert@gondor.apana.org.au
Return-path: <linux-omap-owner@vger.kernel.org>
Sender: linux-omap-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: "Mark A. Greer" <mgreer@animalcreek.com>

[This supersedes the omap-aes driver patches sent in the
 "crypto: omap-aes updates" series sent a few weeks ago.]

This patch series does several things to the omap-aes crypto
driver including:
 - converting to use pm_runtime
 - adding suspend/resume support
 - converting to use dmaengine API
 - adding device tree support
 - adding OMAP4/AM33XX support
 - adding CTR support
 - some misc. cleanups

The patches are based on the current k.o. kernel, plus:
 - the ARM hwmod, etc patches from 
   "[PATCH 00/15] OMAP SHAM & AES Crypto Updates"
   (http://marc.info/?l=linux-omap&m=135610732120447&w=2)
 - the EDMA dmaengine patches submitted by Matt Porter
   "[RFC PATCH v3 00/16] DMA Engine support for AM33XX]"
   (https://lkml.org/lkml/2012/10/18/256)
 - some misc patches required by the EDMA patches
 - a hack to fix the compilation error that the current k.o. kernel has

A working examle is here:

	git@github.com:mgreeraz/linux-mag.git submitted/crypto/aes

Mark A. Greer (10):
  crypto: omap-aes - Remmove unnecessary pr_info noise
  crypto: omap-aes - Don't reset controller for every operation
  crypto: omap-aes - Convert to use pm_runtime API
  crypto: omap-aes - Add suspend/resume support
  crypto: omap-aes - Add code to use dmaengine API
  crypto: omap-aes - Remove usage of private DMA API
  crypto: omap-aes - Add Device Tree Support
  crypto: omap-aes - Convert to dma_request_slave_channel_compat()
  crypto: omap-aes - Add OMAP4/AM33XX AES Support
  crypto: omap-aes - Add CTR algorithm Support

 drivers/crypto/omap-aes.c | 654 ++++++++++++++++++++++++++++++++++------------
 1 file changed, 480 insertions(+), 174 deletions(-)

-- 
1.7.12

