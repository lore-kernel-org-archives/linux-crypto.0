From: James Hartley <james.hartley@imgtec.com>
Subject: [PATCH V5 0/2] crypto: Add Imagination Technologies hw hash accelerator
Date: Thu, 12 Mar 2015 23:17:25 +0000
Message-ID: <1426202247-6221-1-git-send-email-james.hartley@imgtec.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <devicetree@vger.kernel.org>, <ezequiel.garcia@imgtec.com>,
	<linux-crypto@vger.kernel.org>, <james.hartley@imgtec.com>
To: <herbert@gondor.apana.org.au>, <abrestic@chromium.org>,
	<smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailapp01.imgtec.com ([195.59.15.196]:47947 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342AbbCLXRa (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 12 Mar 2015 19:17:30 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This adds support for the Imagination Technologies hash accelerator which 
provides hardware acceleration for SHA1 SHA244 SHA256 and MD5 hashes.

Tested on silicon, using testmgr.

Changes from V4:
	* Moved clk_prepare_enable for both clocks into the probe function to
	  match the remove function, and avoid inflated prepare/enable counts.

Changes from V3:
	* Standardised the cra_priorities to 300, sufficient to be chosen
	  ahead of software / assembly implementations.
	* Addressed Andrew Bresticker's review comments, except for two items
	  that I will leave for when I have some more bandwidth if possible as
	  I don't think they are required:
		->Runtime PM
		->Threaded IRQ handler instead of a tasklet

Changes from V2:
	* This hardware does not support importing a partial hash state, 
	  so the init, update, final and finup have been reworked to use
	  a fallback driver; only digest remains as hardware accelerated.
	* Simplified the driver as a result of the above rework

Changes from V1:
	* Addressed review comments from Andrew Bresticker and 
	  Vladimir Zapolskiy
	* rebased to current linux-next

James Hartley (2):
  This adds support for the Imagination Technologies hash accelerator
    which     provides hardware acceleration for SHA1 SHA224 SHA256 and
    MD5 hashes.
  This adds the binding documentation for the Imagination Technologies
    hash     accelerator that provides hardware acceleration for
    SHA1/SHA224/SHA256/MD5     hashes.  This hardware will be present
    in the upcoming pistachio SoC.

 .../devicetree/bindings/crypto/img-hash.txt        |   27 +
 drivers/crypto/Kconfig                             |   14 +
 drivers/crypto/Makefile                            |    1 +
 drivers/crypto/img-hash.c                          | 1030 ++++++++++++++++++++
 4 files changed, 1072 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/img-hash.txt
 create mode 100644 drivers/crypto/img-hash.c

-- 
1.7.9.5
