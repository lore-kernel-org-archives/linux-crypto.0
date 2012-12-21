From: "Mark A. Greer" <mgreer@animalcreek.com>
Subject: [PATCH 0/9] crypto: omap-sham - Updates & New Functionality
Date: Fri, 21 Dec 2012 10:04:00 -0700
Message-ID: <1356109449-11624-1-git-send-email-mgreer@animalcreek.com>
Cc: linux-crypto@vger.kernel.org, linux-omap@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	"Mark A. Greer" <mgreer@animalcreek.com>
To: davem@davemloft.net, herbert@gondor.apana.org.au
Return-path: <linux-omap-owner@vger.kernel.org>
Sender: linux-omap-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: "Mark A. Greer" <mgreer@animalcreek.com>

[This supersedes the omap-sham driver patches sent in the
 "crypto: omap-sham updates" series sent a few weeks ago.]

This patch series does several things to the omap-sham crypto
driver including:
 - converting to use pm_runtime
 - adding suspend/resume support
 - converting to use dmaengine API
 - adding device tree support
 - adding OMAP4/AM33XX support
 - adding SHA224 and SHA256 support
 - some minor cleanups

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

	git@github.com:mgreeraz/linux-mag.git submitted/crypto/sham

Mark A. Greer (9):
  crypto: omap-sham - Remove unnecessary pr_info noise
  crypto: omap-sham - Convert to use pm_runtime API
  crypto: omap-sham - Add suspend/resume support
  crypto: omap-sham - Add code to use dmaengine API
  crypto: omap-sham - Remove usage of private DMA API
  crypto: omap-sham - Add Device Tree Support
  crypto: omap-sham - Convert to dma_request_slave_channel_compat()
  crypto: omap-sham - Add OMAP4/AM33XX SHAM Support
  crypto: omap-sham - Add SHA224 and SHA256 Support

 drivers/crypto/omap-sham.c | 913 +++++++++++++++++++++++++++++++++++----------
 1 file changed, 718 insertions(+), 195 deletions(-)

-- 
1.7.12

