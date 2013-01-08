From: "Mark A. Greer" <mgreer@animalcreek.com>
Subject: [PATCH v2 00/10] crypto: omap-aes - Updates & New Functionality
Date: Tue,  8 Jan 2013 11:57:37 -0700
Message-ID: <1357671467-32363-1-git-send-email-mgreer@animalcreek.com>
Cc: linux-crypto@vger.kernel.org, linux-omap@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, russ.dill@gmail.com,
	"Mark A. Greer" <mgreer@animalcreek.com>
To: davem@davemloft.net, herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from m1plsmtpa01-02.prod.mesa1.secureserver.net ([64.202.165.174]:42672
	"EHLO m1plsmtpa01-02.prod.mesa1.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756904Ab3AHS54 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 8 Jan 2013 13:57:56 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: "Mark A. Greer" <mgreer@animalcreek.com>

Changes from v1:
 - Addressed comments by Russ Dill by defining omap_aes_of_match[] to
   contain an empty entry (end of list indicator) and defining 
   omap_aes_get_res_of() instead of incorrectly defining
   omap_aes_get_res_dev() when CONFIG_OF is not defined.

This patch series does several things to the omap-aes crypto
driver including:
 - converting to use pm_runtime
 - adding suspend/resume support
 - converting to use dmaengine API
 - adding device tree support
 - adding OMAP4/AM33XX support
 - adding CTR support
 - some misc. cleanups

The patches are based on the current k.o. 54e37b8 (Merge tag
'vfio-for-v3.8-v2' of git://github.com/awilliam/linux-vfio), plus:
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

 drivers/crypto/omap-aes.c | 658 ++++++++++++++++++++++++++++++++++------------
 1 file changed, 484 insertions(+), 174 deletions(-)

-- 
1.7.12
